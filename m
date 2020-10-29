Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B530429F250
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 17:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgJ2Qzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 12:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgJ2Qzy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 12:55:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E7C7206A1;
        Thu, 29 Oct 2020 16:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603990553;
        bh=ga55R+8vpkxfmvABMoQMaist7YDTQxENjDo32sHy0q8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CXQbKMvJchr6uKavl0UK/G08xnrNHhmYK7yUS5tUPJgXM/yLvFMSBLxbVZ+AAtnSj
         7HLmAz80C8upY3SFvpsOwhuLlGIPXH5189nqHaezjlu7QsKaQqyjIH3PMZuUBozMAS
         E43av5XkZzfAc/cpMCyBZCYsQzvnylCSU9WbbfNw=
Date:   Thu, 29 Oct 2020 09:55:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tung Nguyen <tung.q.nguyen@dektech.com.au>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [tipc-discussion] [net v3 1/1] tipc: fix memory leak caused by
 tipc_buf_append()
Message-ID: <20201029095552.4b72b04a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201027032403.1823-1-tung.q.nguyen@dektech.com.au>
References: <20201027032403.1823-1-tung.q.nguyen@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 10:24:03 +0700 Tung Nguyen wrote:
> Commit ed42989eab57 ("tipc: fix the skb_unshare() in tipc_buf_append()")
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
> Fixes: ed42989eab57 ("tipc: fix the skb_unshare() in tipc_buf_append()")
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Reported-by: Thang Hoang Ngo <thang.h.ngo@dektech.com.au>
> Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>

Applied, queued for all the stables.

Thanks everyone!
