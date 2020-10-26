Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80892299607
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 19:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1782669AbgJZSzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 14:55:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1781766AbgJZSzB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 14:55:01 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D18A42085B;
        Mon, 26 Oct 2020 18:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603738501;
        bh=Od3VBL/GZiD+iYTYRBGgRanb5ESWLy/+shzJMi1zKM0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1ptcIhXl2fZ9FfqaTc/h6IvIWDoGv6rn/Gvp6QKdZHO3AiUW6Hi0wXAhgwgkH9kwo
         Z0RA04BPCzl0pfz+e7sqyfwJRsgUtJE/IRsdVZA3jHIyU/aVD9aQ3kCzJ1HkoT89qf
         A9eavuhaRDxiJUaC9Fu4+6CNcityRhoeoIWK+Wkk=
Date:   Mon, 26 Oct 2020 11:54:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tung Nguyen <tung.q.nguyen@dektech.com.au>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [tipc-discussion] [net v2 1/1] tipc: fix memory leak caused by
 tipc_buf_append()
Message-ID: <20201026115456.4a620262@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201026104333.13008-1-tung.q.nguyen@dektech.com.au>
References: <20201026104333.13008-1-tung.q.nguyen@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 17:43:33 +0700 Tung Nguyen wrote:
> Commit ed42989eab57 ("fix the skb_unshare() in tipc_buf_append()")
> replaced skb_unshare() with skb_copy() to not reduce the data reference
> counter of the original skb intentionally. This is not the correct
> way to handle the cloned skb because it causes memory leak in 2
> following cases:
>  1/ Sending multicast messages via broadcast link
>   The original skb list is cloned to the local skb list for local
>   destination. After that, the data reference counter of each skb
>   in the original list has the value of 2. This causes each skb not
>   to be freed after receiving ACK:
>   tipc_link_advance_transmq()
>   {
>    ...
>    /* release skb */
>    __skb_unlink(skb, &l->transmq);
>    kfree_skb(skb); <-- memory exists after being freed
>   }
> 
>  2/ Sending multicast messages via replicast link
>   Similar to the above case, each skb cannot be freed after purging
>   the skb list:
>   tipc_mcast_xmit()
>   {
>    ...
>    __skb_queue_purge(pkts); <-- memory exists after being freed
>   }
> 
> This commit fixes this issue by using skb_unshare() instead. Besides,
> to avoid use-after-free error reported by KASAN, the pointer to the
> fragment is set to NULL before calling skb_unshare() to make sure that
> the original skb is not freed after freeing the fragment 2 times in
> case skb_unshare() returns NULL.
> 
> Fixes: ed42989eab57 ("fix the skb_unshare() in tipc_buf_append()")
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Reported-by: Thang Hoang Ngo <thang.h.ngo@dektech.com.au>
> Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>

Fixes tag: Fixes: ed42989eab57 ("fix the skb_unshare() in tipc_buf_append()")
Has these problem(s):
	- Subject does not match target commit subject
	  Just use
		git log -1 --format='Fixes: %h ("%s")'
