Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A96E153BE
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 20:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbfEFSfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 14:35:16 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:59244 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbfEFSfP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 14:35:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC17CA78;
        Mon,  6 May 2019 11:35:14 -0700 (PDT)
Received: from brain-police (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C0C843F5AF;
        Mon,  6 May 2019 11:35:09 -0700 (PDT)
Date:   Mon, 6 May 2019 19:35:06 +0100
From:   Will Deacon <will.deacon@arm.com>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Qais Yousef <qais.yousef@arm.com>, linux-kernel@vger.kernel.org,
        Michal Gregorczyk <michalgr@live.com>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Mohammad Husain <russoue@gmail.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        duyuchao <yuchao.du@unisoc.com>,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ingo Molnar <mingo@redhat.com>, netdev@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH RFC] bpf: Add support for reading user pointers
Message-ID: <20190506183506.GD2875@brain-police>
References: <20190502204958.7868-1-joel@joelfernandes.org>
 <20190503121234.6don256zuvfjtdg6@e107158-lin.cambridge.arm.com>
 <20190503134935.GA253329@google.com>
 <20190505110423.u7g3f2viovvgzbtn@e107158-lin.cambridge.arm.com>
 <20190505132949.GB3076@localhost>
 <20190505144608.u3vsxyz5huveuskx@e107158-lin.cambridge.arm.com>
 <20190505155223.GA4976@localhost>
 <20190505180313.GA80924@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190505180313.GA80924@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joel,

On Sun, May 05, 2019 at 02:03:13PM -0400, Joel Fernandes wrote:
> +Mark, Will since discussion is about arm64 arch code.
> 
> The difference between observing the bug and everything just working seems to
> be the set_fs(USER_DS) as done by Masami's patch that this patch is based on.
> The following diff shows 'ret' as 255 when set_fs(KERN_DS) is used, and then
> after we retry with set_fs(USER_DS), the read succeeds.
> 
> diff --git a/mm/maccess.c b/mm/maccess.c
> index 78f9274dd49d..d3e01a33c712 100644
> --- a/mm/maccess.c
> +++ b/mm/maccess.c
> @@ -32,9 +32,20 @@ long __probe_kernel_read(void *dst, const void *src, size_t size)
>  	pagefault_disable();
>  	ret = __copy_from_user_inatomic(dst,
>  			(__force const void __user *)src, size);
> +	trace_printk("KERNEL_DS: __copy_from_user_inatomic: ret=%d\n", ret);
>  	pagefault_enable();
>  	set_fs(old_fs);
>  
> +	if (ret) {
> +	set_fs(USER_DS);
> +	pagefault_disable();
> +	ret = __copy_from_user_inatomic(dst,
> +			(__force const void __user *)src, size);
> +	trace_printk("RETRY WITH USER_DS: __copy_from_user_inatomic: ret=%d\n", ret);
> +	pagefault_enable();
> +	set_fs(old_fs);
> +	}
> +
>  	return ret ? -EFAULT : 0;
>  }
>  EXPORT_SYMBOL_GPL(probe_kernel_read);
> 
> In initially thought this was because of the addr_limit pointer masking done
> by this patch from Mark Rutland "arm64: Use pointer masking to limit uaccess
> speculation"
> 
> However removing this masking still makes it fail with KERNEL_DS.
> 
> Fwiw, I am still curious which other paths in arm64 check the addr_limit
> which might make the __copy_from_user_inatomic fail if the set_fs is not
> setup correctly.
> 
> Either way, I will resubmit the patch with the commit message fixed correctly
> as we agreed and also address Alexei's comments.

I'm coming at this with no background, so it's tricky to understand exactly
what's going on here. Some questions:

  * Are you seeing a failure with mainline and/or an official stable kernel?
  * What is the failing CPU? (so we can figure out which architectural
    extensions are implemented)
  * Do you have a .config anywhere? Particular, how are ARM64_PAN,
    ARM64_TTBR0_PAN and ARM64_UAO set?
  * Is the address being accessed a user or a kernel address?

If you're trying to dereference a pointer to userspace using
probe_kernel_read(), that clearly isn't going to work.

Will
