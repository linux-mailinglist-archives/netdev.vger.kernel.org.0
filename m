Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409864B8108
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 08:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiBPHK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 02:10:59 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiBPHK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 02:10:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981546D19E
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 23:10:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A5A560C4F
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 07:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A04AC004E1;
        Wed, 16 Feb 2022 07:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644995325;
        bh=vKUt+m4mob6CrDjAXDgKrQa56GZRMHr1E8mtFL8ki+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GgmG+SzWwVWFq+nxNO0mU1ENNJR5H6GmPd8kwdrmK99h+SSFy0Uz2skwjc6b54iS4
         /hGfM+P89uLUygTPXYhwFXnvcsI2DlskOi2kO6n2BcrU/4dGDfNRI3ImFDQ1C1c8+m
         FK9+cbJorpGWs1Y0mkWQfJhLeDS7hSuLudqxwIYguSzUf9Q6joS2KqzsXgWz0Q3IE9
         O55ldM0IoSzPU9ddgza5yOwvyxjyhDsHpo6aq6hcpPtBQuRZzXJZ2PYsOx/QD1qeBz
         6+M8vryZM8SocB+kul457DFKnhI2V0nFtjz7Dr85EP0aI0FiWIQHpcDnPRkyJvWyjM
         mdDGAUjxsr7Bg==
Date:   Wed, 16 Feb 2022 09:08:38 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     jmaloy@redhat.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, maloy@donjonn.com, xinl@redhat.com,
        ying.xue@windriver.com, parthasarathy.bhuvaragan@gmail.com
Subject: Re: [v2,net] tipc: fix wrong notification node addresses
Message-ID: <Ygyi9rgXShc1MCoX@unreal>
References: <20220216020009.3404578-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216020009.3404578-1-jmaloy@redhat.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 09:00:09PM -0500, jmaloy@redhat.com wrote:
> From: Jon Maloy <jmaloy@redhat.com>
> 
> The previous bug fix had an unfortunate side effect that broke
> distribution of binding table entries between nodes. The updated
> tipc_sock_addr struct is also used further down in the same
> function, and there the old value is still the correct one.
> 
> We fix this now.
> 
> Fixes: 032062f363b4 ("tipc: fix wrong publisher node address in link publications")
> 

Please don't put blank lines between Fixes and SOB lines.

Thanks

> Signed-off-by: Jon Maloy <jmaloy@redhat.com>
> 
> ---
> v2: Copied n->addr to stack variable before leaving lock context, and
>     using this in the notifications.
> ---
>  net/tipc/node.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/net/tipc/node.c b/net/tipc/node.c
> index fd95df338da7..6ef95ce565bd 100644
> --- a/net/tipc/node.c
> +++ b/net/tipc/node.c
> @@ -403,7 +403,7 @@ static void tipc_node_write_unlock(struct tipc_node *n)
>  	u32 flags = n->action_flags;
>  	struct list_head *publ_list;
>  	struct tipc_uaddr ua;
> -	u32 bearer_id;
> +	u32 bearer_id, node;
>  
>  	if (likely(!flags)) {
>  		write_unlock_bh(&n->lock);
> @@ -414,6 +414,7 @@ static void tipc_node_write_unlock(struct tipc_node *n)
>  		   TIPC_LINK_STATE, n->addr, n->addr);
>  	sk.ref = n->link_id;
>  	sk.node = tipc_own_addr(net);
> +	node = n->addr;
>  	bearer_id = n->link_id & 0xffff;
>  	publ_list = &n->publ_list;
>  
> @@ -423,17 +424,17 @@ static void tipc_node_write_unlock(struct tipc_node *n)
>  	write_unlock_bh(&n->lock);
>  
>  	if (flags & TIPC_NOTIFY_NODE_DOWN)
> -		tipc_publ_notify(net, publ_list, sk.node, n->capabilities);
> +		tipc_publ_notify(net, publ_list, node, n->capabilities);
>  
>  	if (flags & TIPC_NOTIFY_NODE_UP)
> -		tipc_named_node_up(net, sk.node, n->capabilities);
> +		tipc_named_node_up(net, node, n->capabilities);
>  
>  	if (flags & TIPC_NOTIFY_LINK_UP) {
> -		tipc_mon_peer_up(net, sk.node, bearer_id);
> +		tipc_mon_peer_up(net, node, bearer_id);
>  		tipc_nametbl_publish(net, &ua, &sk, sk.ref);
>  	}
>  	if (flags & TIPC_NOTIFY_LINK_DOWN) {
> -		tipc_mon_peer_down(net, sk.node, bearer_id);
> +		tipc_mon_peer_down(net, node, bearer_id);
>  		tipc_nametbl_withdraw(net, &ua, &sk, sk.ref);
>  	}
>  }
> -- 
> 2.31.1
> 
