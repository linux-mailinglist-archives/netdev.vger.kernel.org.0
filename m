Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E0C1E539F
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 04:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgE1CEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 22:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgE1CEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 22:04:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7583D207CB;
        Thu, 28 May 2020 02:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590631473;
        bh=Bm2dTuY2AQspqM7SzMj2c/DT+ozxm6kUi6HWpA8TsHk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P1CBXYMU6KgliH8T3/2k6OMetj5IIP9IfCeW6vXHFuAVES38CNoXgmhsLExw5WPRS
         BGr2sIDNzBzrcfeE+DMAJESNZIIeUKJWWPI8HGY2ObOdmL8XyU7KUun0WVlXahBjEC
         cDYAJp751q754Z0TTj9fuvNilxFW+islAyRbCf+k=
Date:   Wed, 27 May 2020 19:04:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/23] bpf: handle the compat string in
 bpf_trace_copy_string better
Message-Id: <20200527190432.e4af1fba00c13cb1421f5a37@linux-foundation.org>
In-Reply-To: <20200521152301.2587579-13-hch@lst.de>
References: <20200521152301.2587579-1-hch@lst.de>
        <20200521152301.2587579-13-hch@lst.de>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 17:22:50 +0200 Christoph Hellwig <hch@lst.de> wrote:

> User the proper helper for kernel or userspace addresses based on
> TASK_SIZE instead of the dangerous strncpy_from_unsafe function.
> 
> ...
>
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -331,8 +331,11 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
>  	switch (fmt_ptype) {
>  	case 's':
>  #ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> -		strncpy_from_unsafe(buf, unsafe_ptr, bufsz);
> -		break;
> +		if ((unsigned long)unsafe_ptr < TASK_SIZE) {
> +			strncpy_from_user_nofault(buf, user_ptr, bufsz);
> +			break;
> +		}
> +		fallthrough;
>  #endif
>  	case 'k':
>  		strncpy_from_kernel_nofault(buf, unsafe_ptr, bufsz);

Another user of strncpy_from_unsafe() has popped up in linux-next's
bpf.  I did the below, but didn't try very hard - it's probably wrong
if CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=n?

Anyway, please take a look at all the bpf_trace.c changes in
linux-next.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: bpf:bpf_seq_printf(): handle potentially unsafe format string better

User the proper helper for kernel or userspace addresses based on
TASK_SIZE instead of the dangerous strncpy_from_unsafe function.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/bpf_trace.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/kernel/trace/bpf_trace.c~xxx
+++ a/kernel/trace/bpf_trace.c
@@ -588,15 +588,22 @@ BPF_CALL_5(bpf_seq_printf, struct seq_fi
 		}
 
 		if (fmt[i] == 's') {
+			void *unsafe_ptr;
+
 			/* try our best to copy */
 			if (memcpy_cnt >= MAX_SEQ_PRINTF_MAX_MEMCPY) {
 				err = -E2BIG;
 				goto out;
 			}
 
-			err = strncpy_from_unsafe(bufs->buf[memcpy_cnt],
-						  (void *) (long) args[fmt_cnt],
-						  MAX_SEQ_PRINTF_STR_LEN);
+			unsafe_ptr = (void *)(long)args[fmt_cnt];
+			if ((unsigned long)unsafe_ptr < TASK_SIZE) {
+				err = strncpy_from_user_nofault(
+					bufs->buf[memcpy_cnt], unsafe_ptr,
+					MAX_SEQ_PRINTF_STR_LEN);
+			} else {
+				err = -EFAULT;
+			}
 			if (err < 0)
 				bufs->buf[memcpy_cnt][0] = '\0';
 			params[fmt_cnt] = (u64)(long)bufs->buf[memcpy_cnt];
_

