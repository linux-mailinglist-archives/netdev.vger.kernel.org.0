Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A76328D274
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 18:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgJMQlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 12:41:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728134AbgJMQle (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 12:41:34 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B795C252B8;
        Tue, 13 Oct 2020 16:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602607294;
        bh=AepnuuPkTX043zkw3GP7KDAMH+cpTjtdHQsMUPjqm4Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B9HWrpiBLpV+j9o4VKsTU2JvGjw/FGk8Lbxf9yayaLa9rPNC3YB3wgrF2CDOJ/Lay
         LqDJN87Mg4662JVZ3RIyn8UhVGbLHxTtzhtfODdA81CqODSiG04vW8saAI5uc4NVd8
         OKq5lVhSoJfzdoQg1NuWE+K11f6Ba90cLK9BYH/8=
Date:   Tue, 13 Oct 2020 09:41:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        manivannan.sadhasivam@linaro.org, hemantk@codeaurora.org
Subject: Re: [PATCH v2] net: Add mhi-net driver
Message-ID: <20201013094132.3a338771@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1602516363-27006-1-git-send-email-loic.poulain@linaro.org>
References: <1602516363-27006-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 17:26:03 +0200 Loic Poulain wrote:
> This patch adds a new network driver implementing MHI transport for
> network packets. Packets can be in any format, though QMAP (rmnet)
> is the usual protocol (flow control + PDN mux).
> 
> It support two MHI devices, IP_HW0 which is, the path to the IPA
> (IP accelerator) on qcom modem, And IP_SW0 which is the software
> driven IP path (to modem CPU).
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

> +static void mhi_net_rx_refill_work(struct work_struct *work)
> +{
> +	struct mhi_net_dev *mhi_netdev = container_of(work, struct mhi_net_dev,
> +						      rx_refill.work);
> +	struct net_device *ndev = mhi_netdev->ndev;
> +	struct mhi_device *mdev = mhi_netdev->mdev;
> +	struct sk_buff *skb;
> +	int err;
> +
> +	do {
> +		skb = netdev_alloc_skb(ndev, READ_ONCE(ndev->mtu));
> +		if (unlikely(!skb))
> +			break;
> +
> +		err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, ndev->mtu,
> +				    MHI_EOT);
> +		if (err) {
> +			if (unlikely(err != -ENOMEM)) {
> +				net_err_ratelimited("%s: Failed to queue RX buf (%d)\n",
> +						    ndev->name, err);
> +			}

nit: no need for parens here

> +			kfree_skb(skb);
> +			break;
> +		}
> +
> +		atomic_inc_return(&mhi_netdev->stats.rx_queued);
> +	} while (1);
> +
> +	/* If we're still starved of rx buffers, reschedule latter */
> +	if (unlikely(!atomic_read(&mhi_netdev->stats.rx_queued)))
> +		schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
> +}

> +	/* Start MHI channels */
> +	err = mhi_prepare_for_transfer(mhi_dev);
> +	if (err)
> +		goto out_err;
> +
> +	err = register_netdev(ndev);
> +	if (err)
> +		goto out_err;
> +
> +	return 0;

no need to

	mhi_unprepare_from_transfer(mhi_netdev->mdev);

here when coming from register_netdev() failure?

> +out_err:
> +	free_netdev(ndev);
> +	return err;
> +}
> +
> +static void mhi_net_remove(struct mhi_device *mhi_dev)
> +{
> +	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
> +
> +	unregister_netdev(mhi_netdev->ndev);
> +
> +	mhi_unprepare_from_transfer(mhi_netdev->mdev);
> +
> +	free_netdev(mhi_netdev->ndev);
> +}
