Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25339424B14
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 02:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239986AbhJGA0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 20:26:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240000AbhJGA0N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 20:26:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81F5A61177;
        Thu,  7 Oct 2021 00:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633566259;
        bh=tgaHTOugDFGxUUqdN69kCfzDlgrMjWwRYHT9cKyf9aE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KK71dAbQz2qNapWoYZuUUes+kImI2qfF2k21cp4JYOySPd+Ac3ZpI4y7YmOjynaMO
         UuFvtqr6imDJAi33ZZPhKInf2rgwzxaEkEdnlv8kJija52eQwRxjNqEHdeh0MVSaC0
         CEQZpP79cyJJnnQEypRh+DCoU/7qcRgwTUfvnHb/2aqlkjMwdBnVKr+UrdZPLatRVG
         7Q5bcZyYqXMMqjwavfrAj/5P+kg6gZLOYdid/29AmeS20mUGWyHdFg/lBE6XMpb2Wi
         T/bWUxDmezzc0goWeZaTNOobf109F9Ieu1npY+3YOk4Df7+IJlgDpgbkwlz2Me6hJp
         SCY24ODf3LMLw==
Date:   Wed, 6 Oct 2021 17:24:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next 1/2] net: enetc: declare NETIF_F_IP_CSUM and do
 it in software
Message-ID: <20211006172418.0293de02@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211006201308.2492890-2-ioana.ciornei@nxp.com>
References: <20211006201308.2492890-1-ioana.ciornei@nxp.com>
        <20211006201308.2492890-2-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Oct 2021 23:13:07 +0300 Ioana Ciornei wrote:
> This is just a preparation patch for software TSO in the enetc driver.
> Unfortunately, ENETC does not support Tx checksum offload which would
> normally render TSO, even software, impossible.
> 
> Declare NETIF_F_IP_CSUM as part of the feature set and do it at driver
> level using skb_csum_hwoffload_help() so that we can move forward and
> also add support for TSO in the next patch.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Did you choose NETIF_F_IP_CSUM intentionally?
It'll only support IPv4, and since you always fall back to SW
I'd think NETIF_F_HW_CSUM makes more sense.

> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
> index 3cbfa8b4e265..a92bfd660f22 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> @@ -319,7 +319,7 @@ static netdev_tx_t enetc_start_xmit(struct sk_buff *skb,
>  {
>  	struct enetc_ndev_priv *priv = netdev_priv(ndev);
>  	struct enetc_bdr *tx_ring;
> -	int count;
> +	int count, err;
>  
>  	/* Queue one-step Sync packet if already locked */
>  	if (skb->cb[0] & ENETC_F_TX_ONESTEP_SYNC_TSTAMP) {
> @@ -342,6 +342,12 @@ static netdev_tx_t enetc_start_xmit(struct sk_buff *skb,
>  		return NETDEV_TX_BUSY;
>  	}
>  
> +	if (skb->ip_summed == CHECKSUM_PARTIAL) {
> +		err = skb_csum_hwoffload_help(skb, 0);
> +		if (err)
> +			goto drop_packet_err;
> +	}

Any reason no to call skb_checksum_help() directly?
