Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67624204351
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730927AbgFVWIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:08:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgFVWIq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 18:08:46 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D53D20716;
        Mon, 22 Jun 2020 22:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592863725;
        bh=VFe++tufNzgQBqW8sLblpgn7C8EYvvODgbGujeV9uRc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AGZ7N8sE2vs1Udw6WIaaGEBgWr2jL3q77mMS+DZJysQtj7dizLUBsp02BTGitM9ES
         bT/7d8xLNntErsWeE21KbEf8Z2VXPz1ovH95+3O+Ucd6fYK5uaV/DJfxEXWW5SqGRV
         baVfgbsccaydYje+nrIi4nBxiwYwA+ASMkDhbbx0=
Date:   Mon, 22 Jun 2020 15:08:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: Re: [PATCH net-next v1 2/5] hinic: add support to set and get irq
 coalesce
Message-ID: <20200622150843.5c0a94ff@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200620094258.13181-3-luobin9@huawei.com>
References: <20200620094258.13181-1-luobin9@huawei.com>
        <20200620094258.13181-3-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Jun 2020 17:42:55 +0800 Luo bin wrote:
> +static int is_coalesce_exceed_limit(struct net_device *netdev,
> +				    const struct ethtool_coalesce *coal)
> +{
> +	struct hinic_dev *nic_dev = netdev_priv(netdev);
> +
> +	if (coal->rx_coalesce_usecs > COALESCE_MAX_TIMER_CFG) {
> +		netif_err(nic_dev, drv, netdev,
> +			  "Rx_coalesce_usecs out of range[%d-%d]\n", 0,
> +			  COALESCE_MAX_TIMER_CFG);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (coal->rx_max_coalesced_frames > COALESCE_MAX_PENDING_LIMIT) {
> +		netif_err(nic_dev, drv, netdev,
> +			  "Rx_max_coalesced_frames out of range[%d-%d]\n", 0,
> +			  COALESCE_MAX_PENDING_LIMIT);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (coal->tx_coalesce_usecs > COALESCE_MAX_TIMER_CFG) {
> +		netif_err(nic_dev, drv, netdev,
> +			  "Tx_coalesce_usecs out of range[%d-%d]\n", 0,
> +			  COALESCE_MAX_TIMER_CFG);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (coal->tx_max_coalesced_frames > COALESCE_MAX_PENDING_LIMIT) {
> +		netif_err(nic_dev, drv, netdev,
> +			  "Tx_max_coalesced_frames out of range[%d-%d]\n", 0,
> +			  COALESCE_MAX_PENDING_LIMIT);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}

I think ERANGE is a more appropriate error code in these?
