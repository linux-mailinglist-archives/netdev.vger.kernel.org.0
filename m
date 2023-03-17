Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72826BDE37
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 02:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjCQBjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 21:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjCQBjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 21:39:22 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1287611EBF;
        Thu, 16 Mar 2023 18:39:14 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so3435442pjg.4;
        Thu, 16 Mar 2023 18:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679017153;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LgL3jmUKYcGmk59NnGq21AmoLBz29O0EQuLBsPjDTqE=;
        b=WuNTnj1jRj5rETMyAh6a/Q3pYCKH7eewrTyQfHlkvFT2SlPqWlQ2TNJTt97CG6dJtX
         6qzn3OA2TtNW62ltj/BHfc20+Blc54wDAj466dFasVQA8hMaML4dXonW6d5ZLaObSQwx
         lV2KdiylG7YyDGaSblopfE8SMB4KRiJooP2YpJEfuz6Oos+o0QxZ9LSqw3ZFf04h7Z4f
         1FwDHFVRQl3gJlweUXl4HKeymE2l6ebRZTRVlRwu0CU7aYUMtO3OZAtkNvyWx0L0iEdA
         GGV1DxMS1w+PPWLw1tHZf6xEjERBYIDUuC77qrcGhGeSYG6pkuUcTGll297MdwBn0ViK
         4ZVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679017153;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LgL3jmUKYcGmk59NnGq21AmoLBz29O0EQuLBsPjDTqE=;
        b=Nn1HrRKvvXApZGim13OwoWJbZ0i7gqkhdDs3vTAu0wWAJ8MiVNHVhwzJG3862WyOK/
         Bt3XhIh3A+RFAK166LgZlV+z1mJ8hnu0taxXTcvUZ06ggWwbKr6POgE7U/6C9bvJXsgq
         Is8UPQeK6AmLGJ2u/LJLHuYGiU1phm1ZjNrb3r9kre/DpdznGMdY/kYVCNKH4TUfF6a6
         JjRvA6u0CGPbxed7zbDh043eqc1Gt8JA0td1RU694noW9TLnooP1O2qdeSkg7jTuDsoG
         3F2UYyLW9VcKPQeDwZmn7no8JJ7Ehf8bcxkwL/5wLgvj4/u50dQLsZ86sE/4vQY9iTBi
         QlIA==
X-Gm-Message-State: AO0yUKWMgo7ego2oDmfBl0+i3mGu+Zz6h8+ExfS1LXmhfC7yHOaVVpWL
        5DSl61rFqKyOxsmuzbGDSyqQgdRF39s=
X-Google-Smtp-Source: AK7set+3H+ZXVcSWJKUz2ES3eiPpN6QY4LJVLAM05fPoE+TlNGTafygqU++M+RZ/F5rJxvP5V487XQ==
X-Received: by 2002:a17:903:1108:b0:1a1:465b:2d22 with SMTP id n8-20020a170903110800b001a1465b2d22mr6789371plh.47.1679017153425;
        Thu, 16 Mar 2023 18:39:13 -0700 (PDT)
Received: from dhcp-172-26-102-232.dhcp.thefacebook.com ([2620:10d:c090:400::5:2bcf])
        by smtp.gmail.com with ESMTPSA id x21-20020a170902ea9500b0019c2cf12d15sm319700plb.116.2023.03.16.18.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 18:39:12 -0700 (PDT)
Date:   Thu, 16 Mar 2023 18:39:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        David Vernet <void@manifault.com>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Allow ld_imm64 instruction to point to
 kfunc.
Message-ID: <20230317013909.ckwsrcvvuisdars5@dhcp-172-26-102-232.dhcp.thefacebook.com>
References: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
 <20230315223607.50803-2-alexei.starovoitov@gmail.com>
 <CAEf4BzaSMB6oKBO2VXvz4cVE9wXqYq+vyD=EOe3YJ3a-L==WCg@mail.gmail.com>
 <CAADnVQLud8-+pexQo8rscVM2d8K2dsYU1rJbFGK2ZZygdAgkQA@mail.gmail.com>
 <CAEf4Bzat4dFCP40cMbDwPK-LyPKJtO1d0M44m9EbNajU9UgxFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzat4dFCP40cMbDwPK-LyPKJtO1d0M44m9EbNajU9UgxFw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 04:06:02PM -0700, Andrii Nakryiko wrote:
> 
> /* pass function pointer through asm otherwise compiler assumes that
> any function != 0 */
> 
> comment was referring to compiler assuming that function != 0 for
> __weak symbol? I definitely didn't read it this way. And "compiler
> assumes that function != 0" seems a bit too strong of a statement,
> because at least Clang doesn't.

Correct. Instead of 'any function' it should be 'any non-weak function'.

> 
> But for macro, it's not kfunc-specific (and macro itself has no way to
> check that you are actually passing kfunc ksym), so even if it was a
> macro, it would be better to call it something more generic like
> bpf_ksym_exists() (though that will work for .kconfig, yet will be
> inappropriately named).

Rigth. bpf_ksym_exists() is what I proposed couple emails ago in my reply to Ed.

> The asm bit, though, seems to be a premature thing that can hide real
> compiler issues, so I'm still hesitant to add it. It should work today
> with modern compilers, so I'd test and validate this.

We're using asm in lots of place to avoid fighting with compiler.
This is just one of them, but I found a different way to prevent
silent optimizations. I'll go with:

#define bpf_ksym_exists(sym) \
       ({ _Static_assert(!__builtin_constant_p(!!sym), #sym " should be marked as __weak"); !!sym; })

It will address the silent dead code elimination issue and
will detect missing weak immediately at build time.

Just going with:

if (bpf_rcu_read_lock) // comment about weak
   bpf_rcu_read_lock();
else
  ..

and forgetting to use __weak in bpf_rcu_read_lock() declaration will make it
"work" on current kernels. The compiler will optimize 'if' and 'else' out and
libbpf will happily find that kfunc in the kernel.
While the program will fail to load on kernels without this kfunc much later with:
libbpf: extern (func ksym) 'bpf_rcu_read_lock': not found in kernel or module BTFs.

Which is the opposite of what that block of bpf code wanted to achieve.

> > It works, but how many people know that unknown weak resolves to zero ?
> > I didn't know until yesterday.
> 
> I was explicit about this from the very beginning of BPF CO-RE work.
> ksyms were added later, but semantics was consistent between .kconfig
> and .ksym. Documentation can't be ever good enough and discoverable
> enough (like [0]), of course, but let's do our best to make it as
...
>   [0] https://nakryiko.com/posts/bpf-core-reference-guide/#kconfig-extern-variables

I read it long ago, but reading is one thing and remembering small details is another.
