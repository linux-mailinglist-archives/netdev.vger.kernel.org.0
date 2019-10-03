Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D01AEC9AF2
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 11:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbfJCJqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 05:46:14 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60490 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728812AbfJCJqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 05:46:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JxrG8Mn2uZyLkMXrN1Ic9KgHpU4+ehJobTt9BpQgG9w=; b=VFieSiS5Fs0+7C5XwBbvc5Obf
        mIyGviu+am8IL8Ra5pAd11cSN617A9gznwI37Yf4Dp8Sl8tC3VqUTs9dJgGXoZPvKYf+AqsHkB8b1
        8BRl48FP/craVB4KmEQVblf1ksECLjmBBSpipBLRJD+z/jqwy9Xo5iTQa2QJi+4cIbv7yShRNW5LJ
        Au1IkM0pwYb43zhETVB9MJcdKcBNpxFCrFME3WknVcBxKiFhyeDHwoJgelZa7ZxWeQRgc3fSMP4K4
        8ejY6ob+p5CYm8wf5o95EGaAymm/fEMFgd2LcSAJbf+0E6sKmWb1NGV8o3FDb4pdaq9uV+vbQp25t
        Kd6Iu90BQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iFxgZ-00066l-Q8; Thu, 03 Oct 2019 09:46:11 +0000
Date:   Thu, 3 Oct 2019 02:46:11 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] tcp: fix slab-out-of-bounds in tcp_zerocopy_receive()
Message-ID: <20191003094611.GC32665@bombadil.infradead.org>
References: <20191003031959.165054-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003031959.165054-1-edumazet@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 08:19:59PM -0700, Eric Dumazet wrote:
> Apparently a refactoring patch brought a bug, that was caught
> by syzbot [1]

That wasn't refactoring.  As you know (because we talked about it at
LSFMM), this is an enabling patch for supporting hch's work to fix
get_user_pages().

> Original code was correct, do not try to be smarter than the
> compiler :/

That wasn't an attempt to be smarter than the compiler.  I was trying
to keep the line length below 80 columns.  Which you probably now see
that you haven't done.

I must have a blind spot here.  I can't see the difference between the
two versions.

> +++ b/net/ipv4/tcp.c
> @@ -1798,13 +1798,11 @@ static int tcp_zerocopy_receive(struct sock *sk,
>  		}
>  		if (skb_frag_size(frags) != PAGE_SIZE || skb_frag_off(frags)) {
>  			int remaining = zc->recv_skip_hint;
> -			int size = skb_frag_size(frags);
>  
> -			while (remaining && (size != PAGE_SIZE ||
> +			while (remaining && (skb_frag_size(frags) != PAGE_SIZE ||
>  					     skb_frag_off(frags))) {
> -				remaining -= size;
> +				remaining -= skb_frag_size(frags);
>  				frags++;
> -				size = skb_frag_size(frags);
>  			}
>  			zc->recv_skip_hint -= remaining;
>  			break;
> -- 
> 2.23.0.581.g78d2f28ef7-goog
> 
