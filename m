Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF29525435
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 19:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344469AbiELRyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 13:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357149AbiELRym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 13:54:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C94624D617
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 10:54:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEC4860FC3
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 17:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB17C385B8;
        Thu, 12 May 2022 17:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652378080;
        bh=+SzIeAc9aT9pQDcKAOv++Lu9oKWU5LBUplGr/eqkJ+E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kQIRZLOvkWEZBDdZVM+DTRDy8Hjv3E0eDTv/eKwJOI1hJhBpQm92rZ9btmkrw02yR
         FDIzIOGFJyyc1r5ryTb0jjOyjN/3jMipQlSsg+a9y8EIfWBGT7QxuWVvaX+tPpkki7
         GPPgngS2amIvbvJ7bOIf83Epd03aN4sziMy7RO70Ww51olZ5IYPQ9k23VXswNJLH8+
         kJ9jwV8ATaA2wYuCa75QrrNRWo91ruFnnSChQ0y8rDnLm6l0qGz/GHEinT72REYPq2
         UtVGz42bbxiOK9R5pxIDcktX8rFFf8hae96DMvZYgVyKlCOnDsFPDcSUXy8gILeFUe
         r2cYBHlD9O7bg==
Date:   Thu, 12 May 2022 20:54:35 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Antony Antony <antony.antony@secunet.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, Tobias Brunner <tobias@strongswan.org>
Subject: Re: [PATCH RFC ipsec] xfrm: fix panic in xfrm_delete from userspace
 on ARM 32
Message-ID: <Yn1J20HaaXeOjhLk@unreal>
References: <00959f33ee52c4b3b0084d42c430418e502db554.1652340703.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00959f33ee52c4b3b0084d42c430418e502db554.1652340703.git.antony.antony@secunet.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 09:44:57AM +0200, Antony Antony wrote:
> A kernel panic was reported on ARM 32 architecture.
> In spite of initialization, x = kmem_cache_zalloc(xfrm_state_cache, GFP_ATOMIC),
> x->mapping_maxage appears to be nozero and cause kernel panic in
> xfrm_state_delete().
> 
> https://github.com/strongswan/strongswan/issues/992
> 
> (__xfrm_state_delete) from [<c091ad58>] (xfrm_state_delete+0x24/0x44)
> (xfrm_state_delete) from [<bf4c31e4>] (xfrm_del_sa+0x94/0xe4 [xfrm_user])
> (xfrm_del_sa [xfrm_user]) from [<bf4c2180>] (xfrm_user_rcv_msg+0xe0/0x1d0 [xfrm_user])
> (xfrm_user_rcv_msg [xfrm_user]) from [<c0878da4>] (netlink_rcv_skb+0xd8/0x148)
> (netlink_rcv_skb) from [<bf4c1724>] (xfrm_netlink_rcv+0x2c/0x48 [xfrm_user])
> (xfrm_netlink_rcv [xfrm_user]) from [<c0878408>] (netlink_unicast+0x208/0x31c)
> (netlink_unicast) from [<c0878710>] (netlink_sendmsg+0x1f4/0x468)
> (netlink_sendmsg) from [<c07e1408>] (__sys_sendto+0xd4/0x13c)
> 
> Even if x->mapping_maxage is non zero I can't explain the cause of panic.
> However, roth-m reports setting  x->mapping_maxage = 0 fix the panic!
> 
> I am still not sure of the cause. So I proposing the fix as an RFC.

We all know that it can't be a fix. It is hard to judge by this
calltrace, but it looks like something in x->km is not set. It is
probably ".all" field.

Thanks

> Anyone has experience with nondeterministic kmem_cache_zalloc() on 32 bit ARM hardware?
> Note other initializations in xfrm_state_alloc() x->replay_maxage = 0. I
> wonder why those were added when there is kmem_cache_zalloc call above.
> 
> The bug report mentioned OpenWRT tool chain and OpenWRT kernel.
> 
> Fixes: 4e484b3e969b ("xfrm: rate limit SA mapping change message to user space")
> Reported-by: https://github.com/roth-m
> Suggested-by: Tobias Brunner <tobias@strongswan.org>
> Signed-off-by: Antony Antony <antony.antony@secunet.com>
> ---
>  net/xfrm/xfrm_state.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
> index b749935152ba..1724a9bd232e 100644
> --- a/net/xfrm/xfrm_state.c
> +++ b/net/xfrm/xfrm_state.c
> @@ -654,6 +654,9 @@ struct xfrm_state *xfrm_state_alloc(struct net *net)
>  		x->lft.hard_packet_limit = XFRM_INF;
>  		x->replay_maxage = 0;
>  		x->replay_maxdiff = 0;
> +		x->mapping_maxage = 0;
> +		x->new_mapping = 0;
> +		x->new_mapping_sport = 0;
>  		spin_lock_init(&x->lock);
>  	}
>  	return x;
> --
> 2.30.2
> 
