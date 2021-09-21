Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A711413C5D
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 23:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbhIUV1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 17:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235230AbhIUV1E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 17:27:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88773610A1;
        Tue, 21 Sep 2021 21:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632259535;
        bh=ofFTyGF4sMS7LgGfb3+UK7Exashvavo/6kI2tbp3dxI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CwYvaoszyl8D16CyUWniUx24fxFI2P/IMPL/bJdyxNlUuZTg0fExx5Ca+DmjoGYLi
         BoJtEBvQ9ZWtGukMzHBdhpnD8lUAhI6VCKHnZem0KD1rscbS808NR23ZdPgkljrGYH
         KdPr5G0dSjIhhcHPT0x35b4yXQfDCMfsfdnsA0gj4YjPvhseGQA5HWVjjhf0hJcTWS
         cB24dieznblp/nmgRhzXb6i8vuhiMzFg8N8FvH7gtbgt1RYe+c/6ILykHsbf03VYGm
         yqSlnECc/3hlTHSUlqQRLDflACb/SCZWYPGdXv3TZXoi/cPn9U+4j/aar1k+UkawGt
         s5263WxoJcqvg==
Date:   Tue, 21 Sep 2021 14:25:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Christoph Paasch <christoph.paasch@gmail.com>,
        Hao Sun <sunhao.th@gmail.com>, kernel@openvz.org
Subject: Re: [RFC net v7] net: skb_expand_head() adjust skb->truesize
 incorrectly
Message-ID: <20210921142533.1403e537@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5ed3cdb8-0a72-9dfb-ecdd-d59411f63653@virtuozzo.com>
References: <20210917162418.1437772-1-kuba@kernel.org>
        <b38881fc-7dbf-8c5f-92b8-5fa1afaade0c@virtuozzo.com>
        <20210920111259.18f9cc01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c4d204a5-f3f1-e505-4206-26dfd1c097f1@virtuozzo.com>
        <20210920173949.7e060848@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5ed3cdb8-0a72-9dfb-ecdd-d59411f63653@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Sep 2021 09:36:26 +0300 Vasily Averin wrote:
> >> However I think we can do it later,
> >> right now we need to fix somehow broken skb_expand_head(),
> >> please take look at v8.  
> > 
> > I think v8 still has the issue that Eric was explaining over and over.  
> 
> I've missed sock_edemux check, however I do not see any other issues.
> Could you please explain what problem you talking about?
> 
> Eric said:
> "it is not valid to call skb_set_owner_w(skb, sk) on all kind of sockets",
> because socket might have been closed already.
> 
> Before the call we have old skb with sk reference, so sk is not closed yet
> and have nonzero sk->sk_wmem_alloc.
> 
> During the call, skb_set_owner_w calls skb_orphan that calls old skb destructor.
> Yes, it can decrement last sk reference and release the socket, 
> and I think this is exactly the problem that Eric was pointing out: 
> now sk access is unsafe.
> 
> However it can be prevented in at least 2 ways:
> a) clone old skb and call skb_set_owner_w(nskb, sk) before skb_consume(oskb).
>    In this case, skb_orphan does not call old destructor, because at this point
>    nskb->sk = NULL and nskb->destructor = NULL, and sk reference is kept by oskb.  
>    This is widely used in current code (ppp_xmit, ipip6_tunnel_xmit, 
>    ip_vs_prepare_tunneled_skb and so on).
>    This is used in v8 too.
> b) Alternatively, extra refs on sk->sk_wmem_alloc and sk->sk_refcnt can be
>    carefully taken before skb_set_owner_w() call. These references will not allow
>    to release sk during old destructor's execution. 
>    This was used in v6, and I think this should works correctly too. 
> 
> Could you please explain where I am wrong?
> Do you talking about some other issue perhaps?

I'm not particularly interested in being part of the arguing here.
If Eric acks your code it will be applied. I can do my cleanups on top.
