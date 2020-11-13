Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E612B2255
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 18:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgKMR2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 12:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgKMR2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 12:28:35 -0500
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF5BC0613D1;
        Fri, 13 Nov 2020 09:28:34 -0800 (PST)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kdcs8-005FWW-C7; Fri, 13 Nov 2020 17:28:28 +0000
Date:   Fri, 13 Nov 2020 17:28:28 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Anders Roxell <anders.roxell@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: csum_partial() on different archs (selftest/bpf)
Message-ID: <20201113172828.GK3576660@ZenIV.linux.org.uk>
References: <CAJ+HfNiQbOcqCLxFUP2FMm5QrLXUUaj852Fxe3hn_2JNiucn6g@mail.gmail.com>
 <20201113122440.GA2164@myrica>
 <CAJ+HfNiE5Oa25QgdAdKzfk-=X45hXLKk_t+ZCiSaeFVTzgzsrw@mail.gmail.com>
 <20201113141542.GJ3576660@ZenIV.linux.org.uk>
 <f634b437-aa51-736b-e2f3-f6210fc6a711@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f634b437-aa51-736b-e2f3-f6210fc6a711@iogearbox.net>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 03:32:22PM +0100, Daniel Borkmann wrote:

> > And I would strongly recommend to change the calling conventions of that
> > thing - make it return __sum16.  And take __sum16 as well...
> > 
> > Again, exposing __wsum to anything that looks like a stable ABI is
> > a mistake - it's an internal detail that can be easily abused,
> > causing unpleasant compat problems.
> 
> I'll take a look at both, removing the copying and also wrt not breaking
> existing users for cascading the helper when fixing.

FWIW, see below the patch that sits in the leftovers queue (didn't make it into
work.csum_and_copy, missed the window, didn't get around to dealing with that
for -next this cycle yet); it does not fold the result, but deals with the rest
of that fun.  I would still suggest at least folding the result; something like
	return csum_fold(csum_sub(csum_partial(from, from_size, 0),
			          csum_partial(to, to_size, seed)),
instead of what this patch does, to guarantee a normalized return value.
Note that the order of csum_sub() arguments here is inverted compared to the
patch below  - csum_fold() returns reduced *complement* of its argument, so we
want to give it SUM(from) - SUM(to) - seed, not seed - SUM(from) + SUM(to).
And it's probably a separate followup (adding normalization, that is).

commit 1dd99d9664ec36e9068afb3ca0017c0a43ee420f
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Jul 8 00:07:11 2020 -0400

    bpf_csum_diff(): don't bother with scratchpads
    
    Just use call csum_partial() on to and from and use csum_sub().
    No need to bother with copying, inverting, percpu scratchpads,
    etc.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/net/core/filter.c b/net/core/filter.c
index 7124f0fe6974..3e21327b9964 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1635,15 +1635,6 @@ void sk_reuseport_prog_free(struct bpf_prog *prog)
 		bpf_prog_destroy(prog);
 }
 
-struct bpf_scratchpad {
-	union {
-		__be32 diff[MAX_BPF_STACK / sizeof(__be32)];
-		u8     buff[MAX_BPF_STACK];
-	};
-};
-
-static DEFINE_PER_CPU(struct bpf_scratchpad, bpf_sp);
-
 static inline int __bpf_try_make_writable(struct sk_buff *skb,
 					  unsigned int write_len)
 {
@@ -1987,10 +1978,6 @@ static const struct bpf_func_proto bpf_l4_csum_replace_proto = {
 BPF_CALL_5(bpf_csum_diff, __be32 *, from, u32, from_size,
 	   __be32 *, to, u32, to_size, __wsum, seed)
 {
-	struct bpf_scratchpad *sp = this_cpu_ptr(&bpf_sp);
-	u32 diff_size = from_size + to_size;
-	int i, j = 0;
-
 	/* This is quite flexible, some examples:
 	 *
 	 * from_size == 0, to_size > 0,  seed := csum --> pushing data
@@ -1999,16 +1986,11 @@ BPF_CALL_5(bpf_csum_diff, __be32 *, from, u32, from_size,
 	 *
 	 * Even for diffing, from_size and to_size don't need to be equal.
 	 */
-	if (unlikely(((from_size | to_size) & (sizeof(__be32) - 1)) ||
-		     diff_size > sizeof(sp->diff)))
+	if (unlikely((from_size | to_size) & (sizeof(__be32) - 1)))
 		return -EINVAL;
 
-	for (i = 0; i < from_size / sizeof(__be32); i++, j++)
-		sp->diff[j] = ~from[i];
-	for (i = 0; i <   to_size / sizeof(__be32); i++, j++)
-		sp->diff[j] = to[i];
-
-	return csum_partial(sp->diff, diff_size, seed);
+	return csum_sub(csum_partial(to, to_size, seed),
+			csum_partial(from, from_size, 0));
 }
 
 static const struct bpf_func_proto bpf_csum_diff_proto = {
