Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF21F500BEC
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 13:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242591AbiDNLRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 07:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242581AbiDNLQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 07:16:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8290327B22;
        Thu, 14 Apr 2022 04:14:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F1D3B828E6;
        Thu, 14 Apr 2022 11:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE836C385A5;
        Thu, 14 Apr 2022 11:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649934872;
        bh=NmetDrxQ+EhR6cSrYu4CXnVLfNx9HrQ/wJn7pNgkRNQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cAOOydwO3ql5oucGvzxYWVmHeQtwnjGuUZe9yX/3fKx7Ie2l8ACcJLd04elVLkCYD
         UwmpsD479bfr3SYn2pcFEY9MdggMb3lMYHXjxvHV7g4M2AXYsGAA8blffgVJOtZfhV
         e35oWN0i4nST7+2NCuEqJgtxNoTcgcxbntFhhp1La8j4Qi2EH+w6ZrhaGfqtCbtLxP
         uBVxcm+uOPm9VraGQw95SyXAaQBKUWW87pVZHVDM61OxlABbH8Q21tld5RNouqvCP1
         TImh2hYV4MirBJjO82pnDZOY25w2jTjgjHDswMAeesMpws/iOOmhznXLjRahv9qfgZ
         VbxuO1TA4ykeg==
Date:   Thu, 14 Apr 2022 13:14:24 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Feng Zhou <zhoufeng.zf@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] ip6_gre: Fix skb_under_panic in __gre6_xmit()
Message-ID: <20220414131424.744aa842@kernel.org>
In-Reply-To: <9cd9ca4ac2c19be288cb8734a86eb30e4d9e2050.1649715555.git.peilin.ye@bytedance.com>
References: <c5b7dc6020c93a1e7b40bc472fcdb6429999473e.1649715555.git.peilin.ye@bytedance.com>
        <9cd9ca4ac2c19be288cb8734a86eb30e4d9e2050.1649715555.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Apr 2022 15:33:00 -0700 Peilin Ye wrote:
> The following sequence of events caused the BUG:
> 
> 1. During ip6gretap device initialization, tunnel->tun_hlen (e.g. 4) is
>    calculated based on old flags (see ip6gre_calc_hlen());
> 2. packet_snd() reserves header room for skb A, assuming
>    tunnel->tun_hlen is 4;
> 3. Later (in clsact Qdisc), the eBPF program sets a new tunnel key for
>    skb A using bpf_skb_set_tunnel_key() (see _ip6gretap_set_tunnel());
> 4. __gre6_xmit() detects the new tunnel key, and recalculates
>    "tun_hlen" (e.g. 12) based on new flags (e.g. TUNNEL_KEY and
>    TUNNEL_SEQ);
> 5. gre_build_header() calls skb_push() with insufficient reserved header
>    room, triggering the BUG.
> 
> As sugguested by Cong, fix it by moving the call to skb_cow_head() after
> the recalculation of tun_hlen.
> 
> Reported-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> Co-developed-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
> ---
> Hi all,
> 
> I couldn't find a proper Fixes: tag for this fix; please comment if you
> have any sugguestions.  Thanks!

What's wrong with

Fixes: 6712abc168eb ("ip6_gre: add ip6 gre and gretap collect_md mode")

?

> diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
> index b43a46449130..976236736146 100644
> --- a/net/ipv6/ip6_gre.c
> +++ b/net/ipv6/ip6_gre.c
> @@ -733,9 +733,6 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
>  	else
>  		fl6->daddr = tunnel->parms.raddr;
>  
> -	if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
> -		return -ENOMEM;
> -
>  	/* Push GRE header. */
>  	protocol = (dev->type == ARPHRD_ETHER) ? htons(ETH_P_TEB) : proto;
>  
> @@ -763,6 +760,9 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
>  			(TUNNEL_CSUM | TUNNEL_KEY | TUNNEL_SEQ);

We should also reject using SEQ with collect_md, but that's a separate
issue.

>  		tun_hlen = gre_calc_hlen(flags);
>  
> +		if (skb_cow_head(skb, dev->needed_headroom ?: tun_hlen + tunnel->encap_hlen))
> +			return -ENOMEM;
> +
>  		gre_build_header(skb, tun_hlen,
>  				 flags, protocol,
>  				 tunnel_id_to_key32(tun_info->key.tun_id),
