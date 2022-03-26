Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684C94E83E7
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 20:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbiCZTw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 15:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiCZTwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 15:52:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456CD2D1EA
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 12:50:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E4D9B80B4F
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 19:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166E9C2BBE4;
        Sat, 26 Mar 2022 19:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648324244;
        bh=eRK61rV3yF1iEXDsceSve7eJ3sYNPnZjjY/6b2tb/Pk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dauicopgL+zdtxTIVnIljs4gFnvETxwOYdYwsyS2r7nrO2d38rXOQ8wy7Uc2FzaOb
         fYuf1hPJYhLWlEjNawc+nL7UotEOiUv0Ibv+hmmsMPPBoomPC6eef6QM/ZDB+8frZF
         k1gZhR03I06OzZDv9kxEsvHE+VZsxtzdtHM8+IWTKSkD6whb/aYz1wI4zTujFXzVSZ
         dCOVWLUzYdQ6cDMW5D8VjMhmSji/V6uSZI8yP1gzlrRStviyz+24jprBlF1yqJWtrG
         Lwjm2YnFtrXTFAcss+QkSKdFuPv+BL7f432aXQ0WlRJShPLnOnqLWpkCZtwGrXDZcH
         oaCkwMPPdMAYw==
Date:   Sat, 26 Mar 2022 12:50:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jie Wang <wangjie125@huawei.com>
Cc:     <mkubecek@suse.cz>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <salil.mehta@huawei.com>, <chenhao288@hisilicon.com>
Subject: Re: [RFCv2 PATCH net-next 1/2] net-next: ethtool: extend ringparam
 set/get APIs for tx_push
Message-ID: <20220326125042.216c9054@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220326085102.14111-2-wangjie125@huawei.com>
References: <20220326085102.14111-1-wangjie125@huawei.com>
        <20220326085102.14111-2-wangjie125@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 26 Mar 2022 16:51:01 +0800 Jie Wang wrote:
> Currently tx push is a standard driver feature which controls use of a fast
> path descriptor push. So this patch extends the ringparam APIs and data
> structures to support set/get tx push by ethtool -G/g.
> 
> Signed-off-by: Jie Wang <wangjie125@huawei.com>
> ---
>  include/linux/ethtool.h              | 3 +++
>  include/uapi/linux/ethtool_netlink.h | 1 +
>  net/ethtool/netlink.h                | 2 +-
>  net/ethtool/rings.c                  | 9 +++++++--

You need to add documentation in:
Documentation/networking/ethtool-netlink.rst

> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 4af58459a1e7..096771ee8586 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -72,11 +72,13 @@ enum {
>   * @rx_buf_len: Current length of buffers on the rx ring.
>   * @tcp_data_split: Scatter packet headers and data to separate buffers
>   * @cqe_size: Size of TX/RX completion queue event
> + * @tx_push: The flag of tx push mode
>   */
>  struct kernel_ethtool_ringparam {
>  	u32	rx_buf_len;
>  	u8	tcp_data_split;
>  	u32	cqe_size;
> +	u32	tx_push;

Can we make this a u8 and move it up above cqe_size?
u8 should be enough. You can use ethnl_update_u8().

>  };
>  
>  /**
> @@ -87,6 +89,7 @@ struct kernel_ethtool_ringparam {
>  enum ethtool_supported_ring_param {
>  	ETHTOOL_RING_USE_RX_BUF_LEN = BIT(0),
>  	ETHTOOL_RING_USE_CQE_SIZE   = BIT(1),
> +	ETHTOOL_RING_USE_TX_PUSH    = BIT(2),

You need to actually use this constant to reject the setting for
drivers which don't support the feature.

>  };
>  
>  #define __ETH_RSS_HASH_BIT(bit)	((u32)1 << (bit))

> @@ -94,7 +95,8 @@ static int rings_fill_reply(struct sk_buff *skb,
>  	     (nla_put_u8(skb, ETHTOOL_A_RINGS_TCP_DATA_SPLIT,
>  			 kr->tcp_data_split))) ||
>  	    (kr->cqe_size &&
> -	     (nla_put_u32(skb, ETHTOOL_A_RINGS_CQE_SIZE, kr->cqe_size))))
> +	     (nla_put_u32(skb, ETHTOOL_A_RINGS_CQE_SIZE, kr->cqe_size))) ||
> +	    nla_put_u8(skb, ETHTOOL_A_RINGS_TX_PUSH, !!kr->tx_push))
> 
>  		return -EMSGSIZE;
>  
>  	return 0;
> @@ -123,6 +125,7 @@ const struct nla_policy ethnl_rings_set_policy[] = {
>  	[ETHTOOL_A_RINGS_TX]			= { .type = NLA_U32 },
>  	[ETHTOOL_A_RINGS_RX_BUF_LEN]            = NLA_POLICY_MIN(NLA_U32, 1),
>  	[ETHTOOL_A_RINGS_CQE_SIZE]		= NLA_POLICY_MIN(NLA_U32, 1),
> +	[ETHTOOL_A_RINGS_TX_PUSH]		= { .type = NLA_U8 },

This can only be 0 and 1, right? Set a policy to to that effect please.

>  };
>  
>  int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
> @@ -165,6 +168,8 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
>  			 tb[ETHTOOL_A_RINGS_RX_BUF_LEN], &mod);
>  	ethnl_update_u32(&kernel_ringparam.cqe_size,
>  			 tb[ETHTOOL_A_RINGS_CQE_SIZE], &mod);
> +	ethnl_update_bool32(&kernel_ringparam.tx_push,
> +			    tb[ETHTOOL_A_RINGS_TX_PUSH], &mod);
>  	ret = 0;
>  	if (!mod)
>  		goto out_ops;

