Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955371E857C
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgE2Ro1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:44:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgE2Ro0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:44:26 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56A1D2065C;
        Fri, 29 May 2020 17:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590774266;
        bh=+iDSBula8gNJyVxxpwCdOty3yDjVLuXbf0HVOUDxtZo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xj1XqGvnpCNL8ezAbiUYngQH0gbL4h6d21XNiQ36NNNRQUYo9b/e20+FCU1Ub87RX
         8skVWXVAa3YICNeCJZUw4BkxQ61AkjIy56q4lE2EKD5WArQfKMi2X7YBHOn241E6z9
         hJ373EtCMTTy/SN6M1ZKiN/IcOKrFiee6VYtHbks=
Date:   Fri, 29 May 2020 10:44:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: Re: [PATCH net-next v2] hinic: add set_channels ethtool_ops support
Message-ID: <20200529104424.58dd665a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200528183633.6689-1-luobin9@huawei.com>
References: <20200528183633.6689-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 18:36:33 +0000 Luo bin wrote:
> add support to change TX/RX queue number with ethtool -L
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

Luo bin, your patches continue to come with Date: header being in the
past. Also suspiciously no time zone offset. Can you address this?

> +static int hinic_set_channels(struct net_device *netdev,
> +			      struct ethtool_channels *channels)
> +{
> +	struct hinic_dev *nic_dev = netdev_priv(netdev);
> +	unsigned int count = channels->combined_count;
> +	int err;
> +
> +	if (!count) {
> +		netif_err(nic_dev, drv, netdev,
> +			  "Unsupported combined_count: 0\n");
> +		return -EINVAL;
> +	}

This check has been added to the core since the last version of you
patch:

	/* ensure there is at least one RX and one TX channel */
	if (!channels.combined_count &&
	    (!channels.rx_count || !channels.tx_count))
		return -EINVAL;

> +	netif_info(nic_dev, drv, netdev, "Set max combined queue number from %d to %d\n",
> +		   hinic_hwdev_num_qps(nic_dev->hwdev), count);
> +
> +	if (netif_running(netdev)) {
> +		netif_info(nic_dev, drv, netdev, "Restarting netdev\n");
> +		hinic_close(netdev);
> +
> +		nic_dev->hwdev->nic_cap.num_qps = count;
> +
> +		err = hinic_open(netdev);
> +		if (err) {
> +			netif_err(nic_dev, drv, netdev,
> +				  "Failed to open netdev\n");
> +			return -EFAULT;
> +		}
> +	} else {
> +		nic_dev->hwdev->nic_cap.num_qps = count;
> +	}
> +
> +	return 0;
>  }

