Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072D1297887
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 22:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755470AbgJWU5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 16:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755398AbgJWU5M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 16:57:12 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB8F520936;
        Fri, 23 Oct 2020 20:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603486631;
        bh=thTY5zzsx7x7mMLiptzquDZ6NGow+NNFqLQSrgL6Qhg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EYsxIIr2Lc8Ke+p7KXQJoR9s3TpIKPDEeXpMZk3IgazHq+cA4qO0S3X39ecdto3nr
         ZE7XfaDDJS0UC8XJYfVX/Ke0dYAwKRILtt0gzdP4PbzRUetJ/Z7+VyXFnicpuAsbek
         uXCacsSCDVzuOlgYPB65xext8Wy0XIGcSadEZ/hw=
Date:   Fri, 23 Oct 2020 13:57:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yi Li <yili@winhong.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH] net treewide: Use skb_is_gso
Message-ID: <20201023135709.0f89fd59@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201021103030.3432231-1-yili@winhong.com>
References: <20201021103030.3432231-1-yili@winhong.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020 18:30:30 +0800 Yi Li wrote:
> This patch introduces the use of the inline func skb_is_gso in place of
> tests for skb_shinfo(skb)->gso_size.
> 
> - if (skb_shinfo(skb)->gso_size)
> + if (skb_is_gso(skb))
> 
> - if (unlikely(skb_shinfo(skb)->gso_size))
> + if (unlikely(skb_is_gso(skb)))
> 
> - if (!skb_shinfo(skb)->gso_size)
> + if (!skb_is_gso(skb))
> 
> Signed-off-by: Yi Li <yili@winhong.com>

The places where gso_size is used on the Rx path may be driver
specific, so I'd rather you left those out.

At a quick look - the following ifs ones are on the Rx path:

> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> index 1a6ec1a12d53..af20884cd772 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> @@ -732,7 +732,7 @@ static void bnx2x_gro_receive(struct bnx2x *bp, struct bnx2x_fastpath *fp,
>  			       struct sk_buff *skb)
>  {
>  #ifdef CONFIG_INET
> -	if (skb_shinfo(skb)->gso_size) {
> +	if (skb_is_gso(skb)) {
>  		switch (be16_to_cpu(skb->protocol)) {
>  		case ETH_P_IP:
>  			bnx2x_gro_csum(bp, skb, bnx2x_gro_ip_csum);

> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> index a362516a3185..e694c99ee540 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> @@ -2990,7 +2990,7 @@ static int hns3_set_gro_and_checksum(struct hns3_enet_ring *ring,
>  						    HNS3_RXD_GRO_SIZE_M,
>  						    HNS3_RXD_GRO_SIZE_S);
>  	/* if there is no HW GRO, do not set gro params */
> -	if (!skb_shinfo(skb)->gso_size) {
> +	if (!skb_is_gso(skb)) {
>  		hns3_rx_checksum(ring, skb, l234info, bd_base_info, ol_info);
>  		return 0;
>  	}
> diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
> index 7ef3369953b6..9c264768f166 100644
> --- a/drivers/net/ethernet/ibm/ibmveth.c
> +++ b/drivers/net/ethernet/ibm/ibmveth.c
> @@ -1251,7 +1251,7 @@ static void ibmveth_rx_mss_helper(struct sk_buff *skb, u16 mss, int lrg_pkt)
>  		tcph->check = 0;
>  	}
>  
> -	if (skb_shinfo(skb)->gso_size) {
> +	if (skb_is_gso(skb)) {
>  		hdr_len = offset + tcph->doff * 4;
>  		skb_shinfo(skb)->gso_segs =
>  				DIV_ROUND_UP(skb->len - hdr_len,

> diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
> index a2494bf85007..092e24893cb9 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
> +++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
> @@ -934,7 +934,7 @@ static void qede_gro_receive(struct qede_dev *edev,
>  	}
>  
>  #ifdef CONFIG_INET
> -	if (skb_shinfo(skb)->gso_size) {
> +	if (skb_is_gso(skb)) {
>  		skb_reset_network_header(skb);
>  
>  		switch (skb->protocol) {
