Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BE7287AF3
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 19:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730998AbgJHRZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 13:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgJHRZR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 13:25:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0390204EF;
        Thu,  8 Oct 2020 17:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602177917;
        bh=gOVHS1ICX8ZT/5rhmADXZCHjUtxW9FSl2u2ObxJnfLw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kHZdPERl5GDikb/wcLQ+5+ORarbCMWyJHp7zzeeKJh1dJlZhD1VGJvwLEPaTlGQut
         Ha628XD17MbeJGXur7MU6y5YhPD2FsE2v5cm3VFLdZuIznQzrigwCziBSu6Qh1pyIz
         A8vjug96YqJ3nJMy67vWYwRrtziCXm0vFJjjS8yM=
Date:   Thu, 8 Oct 2020 10:25:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [net] tipc: fix NULL pointer dereference in tipc_named_rcv
Message-ID: <20201008102514.1184c315@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008073156.116136-1-hoang.h.le@dektech.com.au>
References: <20201008073156.116136-1-hoang.h.le@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Oct 2020 14:31:56 +0700 Hoang Huu Le wrote:
> diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
> index 2f9c148f17e2..fe4edce459ad 100644
> --- a/net/tipc/name_distr.c
> +++ b/net/tipc/name_distr.c
> @@ -327,8 +327,13 @@ static struct sk_buff *tipc_named_dequeue(struct sk_buff_head *namedq,
>  	struct tipc_msg *hdr;
>  	u16 seqno;
>  
> +	spin_lock_bh(&namedq->lock);
>  	skb_queue_walk_safe(namedq, skb, tmp) {
> -		skb_linearize(skb);
> +		if (unlikely(skb_linearize(skb))) {
> +			__skb_unlink(skb, namedq);
> +			kfree_skb(skb);
> +			continue;
> +		}
>  		hdr = buf_msg(skb);
>  		seqno = msg_named_seqno(hdr);
>  		if (msg_is_last_bulk(hdr)) {
> @@ -338,12 +343,14 @@ static struct sk_buff *tipc_named_dequeue(struct sk_buff_head *namedq,
>  
>  		if (msg_is_bulk(hdr) || msg_is_legacy(hdr)) {
>  			__skb_unlink(skb, namedq);
> +			spin_unlock_bh(&namedq->lock);
>  			return skb;
>  		}
>  
>  		if (*open && (*rcv_nxt == seqno)) {
>  			(*rcv_nxt)++;
>  			__skb_unlink(skb, namedq);
> +			spin_unlock_bh(&namedq->lock);
>  			return skb;
>  		}
>  
> @@ -353,6 +360,7 @@ static struct sk_buff *tipc_named_dequeue(struct sk_buff_head *namedq,
>  			continue;
>  		}
>  	}
> +	spin_unlock_bh(&namedq->lock);
>  	return NULL;
>  }
>  
> diff --git a/net/tipc/node.c b/net/tipc/node.c
> index cf4b239fc569..d269ebe382e1 100644
> --- a/net/tipc/node.c
> +++ b/net/tipc/node.c
> @@ -1496,7 +1496,7 @@ static void node_lost_contact(struct tipc_node *n,
>  
>  	/* Clean up broadcast state */
>  	tipc_bcast_remove_peer(n->net, n->bc_entry.link);
> -	__skb_queue_purge(&n->bc_entry.namedq);
> +	skb_queue_purge(&n->bc_entry.namedq);

Patch looks fine, but I'm not sure why not hold
spin_unlock_bh(&tn->nametbl_lock) here instead?

Seems like node_lost_contact() should be relatively rare,
so adding another lock to tipc_named_dequeue() is not the
right trade off.

>  	/* Abort any ongoing link failover */
>  	for (i = 0; i < MAX_BEARERS; i++) {

