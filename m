Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C043D36DF78
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 21:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243950AbhD1TVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 15:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhD1TVy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 15:21:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C7B561003;
        Wed, 28 Apr 2021 19:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619637669;
        bh=Z+hf56Lv0OrVFj6ZxeSzSJ359yIHCQYAjIVswXKPv1E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p/g3l27LmUPWwfUaO1qJ65jhX9dBk9tuFJKOWu3zbqjSX5lA5OzjnTMSx7Ao8NSHU
         YP/9I3hAkW2hYUmhCNaV+jdJaMZ8U5WBCjjoDrildrFWzaA+h75ELokaEnsuVK/zng
         wcd4vzEAV4Vl5SAndYU6mVmzTIXE5vML5OrGMw0TVhDfsVAvMy3nhDIt+DyPxMT44Q
         uDG7fca/HRFqv9bQ9Q6PNlk8SD/mDed4SDIP7nB7JNCU3I1UGrwJ5V/wLT/nHvHsoR
         Iw1Fn+1E2cbWUgAEXr3WSXHgRTYjLtjnsH0VCJ2hLG4Vw5gCu+Y8MDILdfq96U6OU3
         vGSll2/BeMrxQ==
Date:   Wed, 28 Apr 2021 12:21:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, linux@armlinux.org.uk, palmer@dabbelt.com,
        paul.walmsley@sifive.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH] net: macb: Remove redundant assignment to w0 and queue
Message-ID: <20210428122106.2597718a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1619604188-120341-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1619604188-120341-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Apr 2021 18:03:08 +0800 Jiapeng Chong wrote:
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 0f6a6cb..5f1dbc2 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -3248,7 +3248,6 @@ static void gem_prog_cmp_regs(struct macb *bp, struct ethtool_rx_flow_spec *fs)
>  	/* ignore field if any masking set */
>  	if (tp4sp_m->ip4src == 0xFFFFFFFF) {
>  		/* 1st compare reg - IP source address */
> -		w0 = 0;
>  		w1 = 0;
>  		w0 = tp4sp_v->ip4src;
>  		w1 = GEM_BFINS(T2DISMSK, 1, w1); /* 32-bit compare */
> @@ -3262,7 +3261,6 @@ static void gem_prog_cmp_regs(struct macb *bp, struct ethtool_rx_flow_spec *fs)
>  	/* ignore field if any masking set */
>  	if (tp4sp_m->ip4dst == 0xFFFFFFFF) {
>  		/* 2nd compare reg - IP destination address */
> -		w0 = 0;
>  		w1 = 0;
>  		w0 = tp4sp_v->ip4dst;
>  		w1 = GEM_BFINS(T2DISMSK, 1, w1); /* 32-bit compare */

Looks like this was written like that on purpose.

> @@ -4829,7 +4827,7 @@ static int __maybe_unused macb_suspend(struct device *dev)
>  {
>  	struct net_device *netdev = dev_get_drvdata(dev);
>  	struct macb *bp = netdev_priv(netdev);
> -	struct macb_queue *queue = bp->queues;
> +	struct macb_queue *queue;
>  	unsigned long flags;
>  	unsigned int q;
>  	int err;
> @@ -4916,7 +4914,7 @@ static int __maybe_unused macb_resume(struct device *dev)
>  {
>  	struct net_device *netdev = dev_get_drvdata(dev);
>  	struct macb *bp = netdev_priv(netdev);
> -	struct macb_queue *queue = bp->queues;
> +	struct macb_queue *queue;
>  	unsigned long flags;
>  	unsigned int q;
>  	int err;

This chunk looks good!

Would you mind splitting the patch into two (1 - w0 assignments, and 
2 - queue assignments) and reposting? We can merge the latter, the
former is up to the driver maintainer to decide.
