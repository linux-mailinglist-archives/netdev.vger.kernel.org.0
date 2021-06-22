Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3BD3B0D68
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 21:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbhFVTGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 15:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232662AbhFVTGo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 15:06:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5474B606A5;
        Tue, 22 Jun 2021 19:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624388668;
        bh=LUMG5XmvzeCr7rXnetTSokCsmQ+JNrsmHuq77crafBI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ruq0V+AIgYJ2Y28q4Q5GVOx8t7labR6q0Y7lL4uLqb+MEZTzCovVixsLAqnbeVCRM
         g2YfAPVocbIOd9SATzRdrIJls6JMVAWZWWxqyAYZsMR6W4Vi/X50YqqqGZh9FmG8aF
         4Xf1rUvmVmaEPVYRiEekNw/XiiHdkVgvCZYwHZKLolQOHxSJMrj/He54xBe26Su/40
         +8jJrRE8/WiGKybFGdS6WYwzgqaTsCkeOThBaPAJkApwLiEc/dC/lfVEGwrcGsiWGt
         6nxwZFONpAEmoWAQj+3U15DW5quBkpn13zb/QTTioLZR0W5qHtx92Pw26FaVMuf/WF
         hSK7P+N4KOl5A==
Date:   Tue, 22 Jun 2021 12:04:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, willemb@google.com,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org, Dave Jones <dsj@fb.com>
Subject: Re: [PATCH net-next] ip: avoid OOM kills with large UDP sends over
 loopback
Message-ID: <20210622120426.17ef1acc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <d4e2cf28-89f9-7c1f-91de-759de2c47fae@gmail.com>
References: <20210621231307.1917413-1-kuba@kernel.org>
        <8fe00e04-3a79-6439-6ec7-5e40408529e2@gmail.com>
        <20210622095422.5e078bd4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <462f87f4-cc90-1c0e-3a9f-c65c64781dc3@gmail.com>
        <20210622110935.35318a30@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <d4e2cf28-89f9-7c1f-91de-759de2c47fae@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Jun 2021 20:47:57 +0200 Eric Dumazet wrote:
> On 6/22/21 8:09 PM, Jakub Kicinski wrote:
> > On Tue, 22 Jun 2021 19:48:43 +0200 Eric Dumazet wrote:  
> >> I  really thought alloc_skb_with_frags() was already handling low-memory-conditions.
> >>
> >> (alloc_skb_with_frags() is called from sock_alloc_send_pskb())
> >>
> >> If it is not, lets fix it, because af_unix sockets will have the same issue ?  
> > 
> > af_unix seems to cap at SKB_MAX_ALLOC which is order 2, AFAICT.  
> 
> It does not cap to SKB_MAX_ALLOC.
> 
> It definitely attempt big allocations if you send 64KB datagrams.
> 
> Please look at commit d14b56f508ad70eca3e659545aab3c45200f258c
>     net: cleanup gfp mask in alloc_skb_with_frags
> 
> This explains why we do not have __GFP_NORETRY there.

Ah, right, slight misunderstanding.

Just to be 100% clear for UDP send we are allocating up to 64kB 
in the _head_, AFAICT. Allocation of head does not clear GFP_WAIT. 

Your memory was correct, alloc_skb_with_frags() does handle low-memory
when it comes to allocating frags. And what I was saying is af_unix
won't have the same problem as UDP as it caps head's size at
SKB_MAX_ALLOC, and frags are allocated with fallback.

For the UDP case we can either adapt the af_unix approach, and cap head
size to SKB_MAX_ALLOC or try to allocate the full skb and fall back.
Having alloc_skb_with_frags() itself re-balance head <> data
automatically does not feel right, no?
