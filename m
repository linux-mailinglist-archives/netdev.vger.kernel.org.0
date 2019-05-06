Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE9AD1431F
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 02:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbfEFABq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 20:01:46 -0400
Received: from foss.arm.com ([217.140.101.70]:39212 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbfEFABp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 20:01:45 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C9054374;
        Sun,  5 May 2019 17:01:44 -0700 (PDT)
Received: from e107158-lin.cambridge.arm.com (e107158-lin.cambridge.arm.com [10.1.194.71])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FA823F238;
        Sun,  5 May 2019 17:01:40 -0700 (PDT)
Date:   Mon, 6 May 2019 01:01:38 +0100
From:   Qais Yousef <qais.yousef@arm.com>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
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
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH RFC] bpf: Add support for reading user pointers
Message-ID: <20190506000137.akzv4rj5sasy6fby@e107158-lin.cambridge.arm.com>
References: <20190502204958.7868-1-joel@joelfernandes.org>
 <20190503121234.6don256zuvfjtdg6@e107158-lin.cambridge.arm.com>
 <20190503134935.GA253329@google.com>
 <20190505110423.u7g3f2viovvgzbtn@e107158-lin.cambridge.arm.com>
 <20190505132949.GB3076@localhost>
 <20190505144608.u3vsxyz5huveuskx@e107158-lin.cambridge.arm.com>
 <20190505155223.GA4976@localhost>
 <20190505180313.GA80924@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190505180313.GA80924@google.com>
User-Agent: NeoMutt/20171215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/05/19 14:03, Joel Fernandes wrote:
> On Sun, May 05, 2019 at 03:52:23PM +0000, Joel Fernandes wrote:
> > On Sun, May 05, 2019 at 03:46:08PM +0100, Qais Yousef wrote:
> > > On 05/05/19 13:29, Joel Fernandes wrote:
> > > > On Sun, May 05, 2019 at 12:04:24PM +0100, Qais Yousef wrote:
> > > > > On 05/03/19 09:49, Joel Fernandes wrote:
> > > > > > On Fri, May 03, 2019 at 01:12:34PM +0100, Qais Yousef wrote:
> > > > > > > Hi Joel
> > > > > > > 
> > > > > > > On 05/02/19 16:49, Joel Fernandes (Google) wrote:
> > > > > > > > The eBPF based opensnoop tool fails to read the file path string passed
> > > > > > > > to the do_sys_open function. This is because it is a pointer to
> > > > > > > > userspace address and causes an -EFAULT when read with
> > > > > > > > probe_kernel_read. This is not an issue when running the tool on x86 but
> > > > > > > > is an issue on arm64. This patch adds a new bpf function call based
> > > > > > > 
> > > > > > > I just did an experiment and if I use Android 4.9 kernel I indeed fail to see
> > > > > > > PATH info when running opensnoop. But if I run on 5.1-rc7 opensnoop behaves
> > > > > > > correctly on arm64.
> > > > > > > 
> > > > > > > My guess either a limitation that was fixed on later kernel versions or Android
> > > > > > > kernel has some strict option/modifications that make this fail?
> > > > > > 
> > > > > > Thanks a lot for checking, yes I was testing 4.9 kernel with this patch (pixel 3).
> > > > > > 
> > > > > > I am not sure what has changed since then, but I still think it is a good
> > > > > > idea to make the code more robust against such future issues anyway. In
> > > > > > particular, we learnt with extensive discussions that user/kernel pointers
> > > > > > are not necessarily distinguishable purely based on their address.
> > > > > 
> > > > > Yes I wasn't arguing against that. But the commit message is misleading or
> > > > > needs more explanation at least. I tried 4.9.y stable and arm64 worked on that
> > > > > too. Why do you think it's an arm64 problem?
> > > > 
> > > > Well it is broken on at least on at least one arm64 device and the patch I
> > > > sent fixes it. We know that the bpf is using wrong kernel API so why not fix
> > > > it? Are you saying we should not fix it like in this patch? Or do you have
> > > > another fix in mind?
> > > 
> > > Again I have no issue with the new API. But the claim that it's a fix for
> > > a broken arm64 is a big stretch. AFAICT you don't understand the root cause of
> > > why copy_to_user_inatomic() fails in your case. Given that Android 4.9 has
> > > its own patches on top of 4.9 stable, it might be something that was introduced
> > > in one of these patches that breaks opensnoop, and by making it use the new API
> > > you might be simply working around the problem. All I can see is that vanilla
> > > 4.9 stable works on arm64.
> > 
> > Agreed that commit message could be improved. I believe issue is something to
> > do with differences in 4.9 PAN emulation backports. AIUI PAN was introduced
> > in upstream only in 4.10 so 4.9 needed backports.
> > 
> > I did not root cause this completely because "doing the right thing" fixed
> > the issue. I will look more closely once I am home.
> > 
> > Thank you.
> 
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

PAN and UAO configs seem to affect its behavior. I lost access to my board to
play with this myself and will have to wait until I get back to the office on
Tuesday to revive it.

> 
> Either way, I will resubmit the patch with the commit message fixed correctly
> as we agreed and also address Alexei's comments.

Thanks

--
Qais Yousef
