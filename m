Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE794308D47
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 20:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbhA2TU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 14:20:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55200 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233086AbhA2TTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 14:19:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611947872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dK1BOSLuMB04Wgs7u3v/d74T6ixHNcvI7cxC3Lt8/rc=;
        b=MdAfYrpvC1J8Ckszgku5hfACkpgEtDm4xdnC5tkhH5jkAzVbNaeyrI70zTHZNEKVqn5w6a
        ohl93/LmFdMNyYuL4G0lqB7nBu57SEBqdgqSQ5/1CNsAFYMfYv7ODbwHv6CaS2xhQM4wGS
        gnI6Eh7VxJTqlc/rLJT3izStkmMRZPs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-2_QK0jdXNLCtaHN-Pno6xg-1; Fri, 29 Jan 2021 14:17:47 -0500
X-MC-Unique: 2_QK0jdXNLCtaHN-Pno6xg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B8FF8042B4;
        Fri, 29 Jan 2021 19:17:46 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBCB427C59;
        Fri, 29 Jan 2021 19:17:29 +0000 (UTC)
Date:   Fri, 29 Jan 2021 20:17:28 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        toshiaki.makita1@gmail.com, lorenzo.bianconi@redhat.com,
        toke@redhat.com, Stefano Brivio <sbrivio@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCH v2 bpf-next] net: veth: alloc skb in bulk for
 ndo_xdp_xmit
Message-ID: <20210129201728.4322bab0@carbon>
In-Reply-To: <20210129170216.6a879619@carbon>
References: <415937741661ac331be09c0e59b4ff1eacfee782.1611861943.git.lorenzo@kernel.org>
        <20210129170216.6a879619@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 17:02:16 +0100
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> > +	for (i = 0; i < n_skb; i++) {
> > +		struct sk_buff *skb = skbs[i];
> > +
> > +		memset(skb, 0, offsetof(struct sk_buff, tail));  
> 
> It is very subtle, but the memset operation on Intel CPU translates
> into a "rep stos" (repeated store) operation.  This operation need to
> save CPU-flags (to support being interrupted) thus it is actually
> expensive (and in my experience cause side effects on pipeline
> efficiency).  I have a kernel module for testing memset here[1].
> 
> In CPUMAP I have moved the clearing outside this loop. But via asking
> the MM system to clear the memory via gfp_t flag __GFP_ZERO.  This
> cause us to clear more memory 256 bytes, but it is aligned.  Above
> offsetof(struct sk_buff, tail) is 188 bytes, which is unaligned making
> the rep-stos more expensive in setup time.  It is below 3-cachelines,
> which is actually interesting and an improvement since last I checked.
> I actually have to re-test with time_bench_memset[1], to know that is
> better now.

After much testing (with [1]), yes please use gfp_t flag __GFP_ZERO.

 SKB: offsetof-tail:184 bytes
  - memset_skb_tail Per elem: 37 cycles(tsc) 10.463 ns

 SKB: ROUNDUP(offsetof-tail: 192)
  - memset_skb_tail_roundup Per elem: 37 cycles(tsc) 10.468 ns

I though it would be better/faster to round up to full cachelines, but
measurements show that the cost was the same for 184 vs 192.  It does
validate the theory that it is the cacheline boundary that is important.

When doing the gfp_t flag __GFP_ZERO, the kernel cannot know the
constant size, and instead end up calling memset_erms().

The cost of memset_erms(256) is:
 - memset_variable_step(256) Per elem: 31 cycles(tsc) 8.803 ns

The const version with 256 that uses rep-stos cost more:
 - memset_256 Per elem: 41 cycles(tsc) 11.552 ns


Below not relevant for your patch, but an interesting data point is
that memset_erms(512) only cost 4 cycles more:
 - memset_variable_step(512) Per elem: 35 cycles(tsc) 9.893 ns

(but don't use rep-stos for const 512 it is 72 cycles(tsc) 20.069 ns.)

[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/time_bench_memset.c
CPU: Intel(R) Xeon(R) CPU E5-1650 v4 @ 3.60GHz
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

