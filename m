Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B39415520
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 22:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfEFU6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 16:58:11 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38509 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbfEFU6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 16:58:11 -0400
Received: by mail-pf1-f194.google.com with SMTP id 10so7403253pfo.5
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 13:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kLvBEkbGH2riUHwBmQ3jNmUgnYR588n2GWNQ8y8PGCE=;
        b=OTEKU73clE6B6zjUJhEw6aF1TCgyEE6l6Jlty1yHWx43iZ9pTMHpSlvBIvsXC3DZqW
         3dRE5Jt67zdSEBTCnNkF2c1i/hWhxPopBmGZWoN285CLByjeps7LkIuNvBSgYnPbwJlA
         IFqm8+81yGkeBshC/6R5YWtE7k47BPcG7nsxg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kLvBEkbGH2riUHwBmQ3jNmUgnYR588n2GWNQ8y8PGCE=;
        b=ryUFY1/JnEbmmG4WJypsU3bJ4cSlzry3YNdewuC343geZ2uSNpdDDHA6IypGrl0Knw
         aYmP9FtoeAXw3FHUb9nyWK8NUyMsjck9wabUjVp0lw3mDphi8BhFr5Y0rf6/WzPy3Mzy
         afZZ/2cUIgfvJuGXuuxI/aM1HPKfybWgRBey4iReMjFgZle89FBZzGUGRf//vWCgjiz2
         sbpFiccsbcSIWau3ILAhbTlX2AZ5x8tS0+xJxNHiVpMrUUdARyrBmitWOf0GShvCoDtw
         fQRBJ6+61tuB4RmZqMxzGXyZdfIJrfqsX7pS17y+xhBJ5hOfzEfp3wGqJD8xQ4LxY3q7
         tAkA==
X-Gm-Message-State: APjAAAWh2hiU3o9S6AYP1ZXBIS8SP+ENVjkbLJ5/CmOCLgffux2oM2pn
        yV6LlNnoXpN+IBe+kauRwOYs5Q==
X-Google-Smtp-Source: APXvYqzNxbDaZNkAkn2IFcOFX6jeB95iYdhBq3D6DLWqE4q+X5tNDHdBAe4TCV+WnbzUN5tSp0m8+g==
X-Received: by 2002:aa7:8384:: with SMTP id u4mr35598358pfm.214.1557176289853;
        Mon, 06 May 2019 13:58:09 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id l23sm5007490pgh.68.2019.05.06.13.58.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 13:58:08 -0700 (PDT)
Date:   Mon, 6 May 2019 16:58:07 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Will Deacon <will.deacon@arm.com>
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
Message-ID: <20190506205807.GA223956@google.com>
References: <20190502204958.7868-1-joel@joelfernandes.org>
 <20190503121234.6don256zuvfjtdg6@e107158-lin.cambridge.arm.com>
 <20190503134935.GA253329@google.com>
 <20190505110423.u7g3f2viovvgzbtn@e107158-lin.cambridge.arm.com>
 <20190505132949.GB3076@localhost>
 <20190505144608.u3vsxyz5huveuskx@e107158-lin.cambridge.arm.com>
 <20190505155223.GA4976@localhost>
 <20190505180313.GA80924@google.com>
 <20190506183506.GD2875@brain-police>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506183506.GD2875@brain-police>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 06, 2019 at 07:35:06PM +0100, Will Deacon wrote:
> Hi Joel,
> 
> On Sun, May 05, 2019 at 02:03:13PM -0400, Joel Fernandes wrote:
> > +Mark, Will since discussion is about arm64 arch code.
> > 
> > The difference between observing the bug and everything just working seems to
> > be the set_fs(USER_DS) as done by Masami's patch that this patch is based on.
> > The following diff shows 'ret' as 255 when set_fs(KERN_DS) is used, and then
> > after we retry with set_fs(USER_DS), the read succeeds.
> > 
> > diff --git a/mm/maccess.c b/mm/maccess.c
> > index 78f9274dd49d..d3e01a33c712 100644
> > --- a/mm/maccess.c
> > +++ b/mm/maccess.c
> > @@ -32,9 +32,20 @@ long __probe_kernel_read(void *dst, const void *src, size_t size)
> >  	pagefault_disable();
> >  	ret = __copy_from_user_inatomic(dst,
> >  			(__force const void __user *)src, size);
> > +	trace_printk("KERNEL_DS: __copy_from_user_inatomic: ret=%d\n", ret);
> >  	pagefault_enable();
> >  	set_fs(old_fs);
> >  
> > +	if (ret) {
> > +	set_fs(USER_DS);
> > +	pagefault_disable();
> > +	ret = __copy_from_user_inatomic(dst,
> > +			(__force const void __user *)src, size);
> > +	trace_printk("RETRY WITH USER_DS: __copy_from_user_inatomic: ret=%d\n", ret);
> > +	pagefault_enable();
> > +	set_fs(old_fs);
> > +	}
> > +
> >  	return ret ? -EFAULT : 0;
> >  }
> >  EXPORT_SYMBOL_GPL(probe_kernel_read);
> > 
> > In initially thought this was because of the addr_limit pointer masking done
> > by this patch from Mark Rutland "arm64: Use pointer masking to limit uaccess
> > speculation"
> > 
> > However removing this masking still makes it fail with KERNEL_DS.
> > 
> > Fwiw, I am still curious which other paths in arm64 check the addr_limit
> > which might make the __copy_from_user_inatomic fail if the set_fs is not
> > setup correctly.
> > 
> > Either way, I will resubmit the patch with the commit message fixed correctly
> > as we agreed and also address Alexei's comments.
> 
> I'm coming at this with no background, so it's tricky to understand exactly
> what's going on here. Some questions:

No problem, I added you out of the blue so it is quite understandable :)

>   * Are you seeing a failure with mainline and/or an official stable kernel?

This issue is noticed on the Pixel3 kernel (4.9 based):
git clone https://android.googlesource.com/kernel/msm
(branch: android-msm-crosshatch-4.9-q-preview-1)

>   * What is the failing CPU? (so we can figure out which architectural
>     extensions are implemented)
From cpuinfo:
AArch64 Processor rev 12 (aarch64)
(Qualcomm SDM845 SoC). It is a Pixel 3 phone.

>   * Do you have a .config anywhere? Particular, how are ARM64_PAN,
>     ARM64_TTBR0_PAN and ARM64_UAO set?

CONFIG_ARM64_SW_TTBR0_PAN is not set
CONFIG_ARM64_PAN=y
CONFIG_ARM64_UAO=y

I wanted to say I enabled SW_TTBR0_PAN config and also got the same result.

>   * Is the address being accessed a user or a kernel address?

User. It is the second argument of do_sys_open() kernel function. kprobe
gives bpf the pointer which the bpf program dereferences with
probe_kernel_read.

> If you're trying to dereference a pointer to userspace using
> probe_kernel_read(), that clearly isn't going to work.

Ok. Thanks for confirming as well. The existing code has this bug and these
patches fix it.

 - Joel

