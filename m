Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FDD302EC0
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 23:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732171AbhAYWPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 17:15:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732793AbhAYWAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 17:00:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A805421D94;
        Mon, 25 Jan 2021 21:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611611965;
        bh=ORqeYhDzNKxbv5ko1rFEiAVS16hvNDh9QflvAl/4HUU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lp8G6Lvf8jWPPRHsOiBkUAs6i4Qh+oLmhaY6oQfk479JHUcIr1bP0kjAjli4L4wLa
         QZHzcsj8XpNnbrNG0DxB+Xw4HRKkgAUKid/D4xYDZm89e3Ppw3cpqL/oPi9U+r22ob
         AnHYRqGfd6kC8yDM3vrpI3m/wu0DcP2t/xlwme2LVxzWYgds51yJkqISuwEB1KPxIt
         KmbDLG324rUc5y+KI9n8KvcoHUVFC2TILw+S1y0eotM0sTjym4WD91B7cElOF6hnWu
         DBVn2zsoNtV1B/vWx9sry3KGj+HvP6gdvygc/tUGN6JhdJXCdMD/AVW9DLy5DOkZFB
         B9bi8A0wyccfg==
Date:   Mon, 25 Jan 2021 13:59:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chinmay Agarwal <chinagar@codeaurora.org>
Cc:     netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        sharathv@codeaurora.org
Subject: Re: [PATCH] neighbour: Prevent a dead entry from updating gc_list
Message-ID: <20210125135924.6baa37c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210125195927.GA26972@chinagar-linux.qualcomm.com>
References: <20210125195927.GA26972@chinagar-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jan 2021 01:29:37 +0530 Chinmay Agarwal wrote:
> Following race condition was detected:
> <CPU A, t0> - neigh_flush_dev() is under execution and calls neigh_mark_dead(n),
> marking the neighbour entry 'n' as dead.
> 
> <CPU B, t1> - Executing: __netif_receive_skb() -> __netif_receive_skb_core()
> -> arp_rcv() -> arp_process().arp_process() calls __neigh_lookup() which takes  
> a reference on neighbour entry 'n'.
> 
> <CPU A, t2> - Moves further along neigh_flush_dev() and calls
> neigh_cleanup_and_release(n), but since reference count increased in t2,
> 'n' couldn't be destroyed.
> 
> <CPU B, t3> - Moves further along, arp_process() and calls
> neigh_update()-> __neigh_update() -> neigh_update_gc_list(), which adds
> the neighbour entry back in gc_list(neigh_mark_dead(), removed it
> earlier in t0 from gc_list)
> 
> <CPU B, t4> - arp_process() finally calls neigh_release(n), destroying
> the neighbour entry.
> 
> This leads to 'n' still being part of gc_list, but the actual
> neighbour structure has been freed.
> 
> The situation can be prevented from happening if we disallow a dead
> entry to have any possibility of updating gc_list. This is what the
> patch intends to achieve.
> 
> Signed-off-by: Chinmay Agarwal <chinagar@codeaurora.org>
> ---
>  net/core/neighbour.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index ff07358..cf8e3076 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1244,13 +1244,14 @@ static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
>  	old    = neigh->nud_state;
>  	err    = -EPERM;
>  
> -	if (!(flags & NEIGH_UPDATE_F_ADMIN) &&
> -	    (old & (NUD_NOARP | NUD_PERMANENT)))
> -		goto out;
>  	if (neigh->dead) {
>  		NL_SET_ERR_MSG(extack, "Neighbor entry is now dead");
> +		new=old;
>  		goto out;
>  	}
> +	if (!(flags & NEIGH_UPDATE_F_ADMIN) &&
> +	    (old & (NUD_NOARP | NUD_PERMANENT)))
> +		goto out;
>  
>  	ext_learn_change = neigh_update_ext_learned(neigh, flags, &notify);
>  

Please run checkpatch on your patches:

ERROR: spaces required around that '=' (ctx:VxV)
#52: FILE: net/core/neighbour.c:1249:
+		new=old;
 		   ^
