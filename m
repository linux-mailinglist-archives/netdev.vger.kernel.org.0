Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3895915B754
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 03:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgBMC4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 21:56:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729521AbgBMC4G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 21:56:06 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7970621739;
        Thu, 13 Feb 2020 02:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581562565;
        bh=v1Cdow8c5mnT/NMDSQZkvFxjLExeUuklGL4gKnniKXs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a7+1+jEh8u1G/rdtaepjruSQQTwG5z1NHyOkLot8vD1WbNRqccP+XJhHxzYhtWFCR
         1Xy9x1m1LyhaAJSTKS2NOMn71lcsgbJR+IovLNztH7t4BEYfQsK41VP5kT/7NLLT9b
         m490Lyxu3UsoUPYGilDHonx//E+lgK6OQI22INxs=
Date:   Wed, 12 Feb 2020 18:56:05 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, linux-mm@kvack.org,
        arjunroy@google.com, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH resend mm,net-next 3/3] net-zerocopy: Use
 vm_insert_pages() for tcp rcv zerocopy.
Message-Id: <20200212185605.d89c820903b7aa9fbbc060b2@linux-foundation.org>
In-Reply-To: <20200128025958.43490-3-arjunroy.kdev@gmail.com>
References: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
        <20200128025958.43490-3-arjunroy.kdev@gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jan 2020 18:59:58 -0800 Arjun Roy <arjunroy.kdev@gmail.com> wrote:

> Use vm_insert_pages() for tcp receive zerocopy. Spin lock cycles
> (as reported by perf) drop from a couple of percentage points
> to a fraction of a percent. This results in a roughly 6% increase in
> efficiency, measured roughly as zerocopy receive count divided by CPU
> utilization.
> 
> The intention of this patch-set is to reduce atomic ops for
> tcp zerocopy receives, which normally hits the same spinlock multiple
> times consecutively.

For some reason the patch causes this:

In file included from ./arch/x86/include/asm/atomic.h:5:0,
                 from ./include/linux/atomic.h:7,
                 from ./include/linux/crypto.h:15,
                 from ./include/crypto/hash.h:11,
                 from net/ipv4/tcp.c:246:
net/ipv4/tcp.c: In function ‘do_tcp_getsockopt.isra.29’:
./include/linux/compiler.h:225:31: warning: ‘tp’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  case 4: *(volatile __u32 *)p = *(__u32 *)res; break;
          ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~
net/ipv4/tcp.c:1779:19: note: ‘tp’ was declared here
  struct tcp_sock *tp;
                   ^~

It's a false positive.  gcc-7.2.0

: out:
:        up_read(&current->mm->mmap_sem);
:        if (length) {
:                WRITE_ONCE(tp->copied_seq, seq);

but `length' is zero here.  

This suppresses it:

--- a/net/ipv4/tcp.c~net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix
+++ a/net/ipv4/tcp.c
@@ -1788,6 +1788,8 @@ static int tcp_zerocopy_receive(struct s
 
 	sock_rps_record_flow(sk);
 
+	tp = tcp_sk(sk);
+
 	down_read(&current->mm->mmap_sem);
 
 	ret = -EINVAL;
@@ -1796,7 +1798,6 @@ static int tcp_zerocopy_receive(struct s
 		goto out;
 	zc->length = min_t(unsigned long, zc->length, vma->vm_end - address);
 
-	tp = tcp_sk(sk);
 	seq = tp->copied_seq;
 	inq = tcp_inq(sk);
 	zc->length = min_t(u32, zc->length, inq);

and I guess it's zero-cost.


Anyway, I'll sit on this lot for a while, hoping for a davem ack?
