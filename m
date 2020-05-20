Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351E41DB11C
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 13:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgETLLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 07:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbgETLLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 07:11:32 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6429E207C4;
        Wed, 20 May 2020 11:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589973091;
        bh=CZO2oVmSFplMBz9Hp/Ib++cLu93ut1vlEwhwSgDctvg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0JQBodzpZZsofv0Hjk8g+YCto+yzr1HnJmp8bkaaHFsZdNStcwkqu6sxB/Cq7RGNZ
         D9oyW+ivG0VvZVxdbnNjqnjrKg4ZFxKYuPou20DYf2dxIBIfJoUskwUkakdJdMZzgW
         O2b3pTDEl9xo3o3HjCuYb8IrGfvnz8+E0HAxmEdI=
Date:   Wed, 20 May 2020 20:11:26 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/20] maccess: always use strict semantics for
 probe_kernel_read
Message-Id: <20200520201126.f37d3b1e46355199216404e2@kernel.org>
In-Reply-To: <20200519134449.1466624-14-hch@lst.de>
References: <20200519134449.1466624-1-hch@lst.de>
        <20200519134449.1466624-14-hch@lst.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020 15:44:42 +0200
Christoph Hellwig <hch@lst.de> wrote:

> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 2f6737cc53e6c..82da20e712507 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1208,7 +1208,13 @@ fetch_store_strlen(unsigned long addr)
>  	u8 c;
>  
>  	do {
> -		ret = probe_kernel_read(&c, (u8 *)addr + len, 1);
> +		if (IS_ENABLED(CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE) &&
> +		    (unsigned long)addr < TASK_SIZE) {
> +			ret = probe_user_read(&c,
> +				(__force u8 __user *)addr + len, 1);
> +		} else {
> +			ret = probe_kernel_read(&c, (u8 *)addr + len, 1);
> +		}
>  		len++;
>  	} while (c && ret == 0 && len < MAX_STRING_SIZE);

To avoid redundant check in the loop, we can use strnlen_user_nofault() out of
the loop. Something like below.

...
	u8 c;

	if (IS_ENABLED(CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE) &&
	    (unsigned long)addr < TASK_SIZE) {
		return strnlen_user_nofault((__force u8 __user *)addr, MAX_STRING_SIZE);

	do {
		ret = probe_kernel_read(&c, (u8 *)addr + len, 1);
		len++;
	} while (c && ret == 0 && len < MAX_STRING_SIZE);
...

This must work because we must not have a string that continues across
kernel　space and user space.

Thank you,


-- 
Masami Hiramatsu <mhiramat@kernel.org>
