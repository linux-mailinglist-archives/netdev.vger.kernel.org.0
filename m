Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546DE5856B0
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 23:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239479AbiG2V41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 17:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238276AbiG2V40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 17:56:26 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DC4DF67;
        Fri, 29 Jul 2022 14:56:25 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z18so7299208edb.10;
        Fri, 29 Jul 2022 14:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=1oJ5ppqV81dXGgROARm3vuKcjkQjJObMa2dG00eEj7w=;
        b=ZeymHzrZcHgrti6DtpxYn2wHVj1tb+D89fn3+wQlInaLgY/X3CrKhVor4DlLOYgPKm
         9w6QZXYf6GhObP3dpbRRIFsApY4FUvPhgCW0A3Rge6VCD4mRRSwEQob7fGIlCR0DrrqN
         riQfGI/3g92JkRIUqjtSxHYUI0N64mfjkwrbhW6sBBj+jhYVRWogHWx08TFGlb/v3DaV
         7PmqVUFY8xKPqt1fSqqY/ssBPNbfnHIjdEuiklaDQ6CTqPMuwZlWk97DX93YtSb+W2My
         UKLgGJ4RD0mFrROjCeYYrA7Pxe5uujmPJZXTBHMo8HiNjc8KDx6VOcr3KEzkdAv/Miaa
         +pDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=1oJ5ppqV81dXGgROARm3vuKcjkQjJObMa2dG00eEj7w=;
        b=AI++c9TRYSPVMK5enrocIJSEsjEx7EEzn0mTBUvY0plb/NHllCnXumNgGJcJ8e4g/K
         IZck18zFZIzEw7iYF5qFDKcp0YDb8Sfj8nDPj6MaJXvEm2r+aJ35/A7HzE1iYbcIhw3q
         X2ugBicbaKIc3JUCuIbi6PxqQymccxVeeE6hiRckZUWQHKU7r9t4gchWQaHb6FcZXoZU
         GCQ1ROqIXZrxCSlYSZ0R4e/F7fNrXssRpx0FX35pAVW2sNEgj2xlj6rzzF5OtgWPJdAZ
         toAmO/6s0NFJIVrAaUSp/1yPobjW01zEZWo/VisTiO889eTCmXViv+YZSEOqI1mf/hCF
         DVaQ==
X-Gm-Message-State: AJIora8Vk+T4Jwr/QRz97HU21+RaWpYTkLMYzXR3QPDp6Q6OzC5MRrLp
        31xnW64eHlLdas3tWEwu3PCerVQg1/eOcZnNNM8=
X-Google-Smtp-Source: AGRyM1soQseBLYKgvdEFDaSq50Y9XWsp5c865UialDKX7i0Cka6HNVhe9R9wqbc/CK0baT0hAhQHqznpzlIjANupI1I=
X-Received: by 2002:a05:6402:5108:b0:43b:e395:d2fb with SMTP id
 m8-20020a056402510800b0043be395d2fbmr5555406edd.260.1659131783873; Fri, 29
 Jul 2022 14:56:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220728114048.3540461-1-xukuohai@huaweicloud.com>
 <YuKAlk+p/ABzfUQ+@krava> <9170060c-8727-68d6-7be2-8aa75e30c6e6@huaweicloud.com>
 <YuKOQiJt+AA1cCEE@krava>
In-Reply-To: <YuKOQiJt+AA1cCEE@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 29 Jul 2022 14:56:12 -0700
Message-ID: <CAEf4BzboJpqnfAE_i7LPMe2HM_bNGo0AM8r=sAuP3E4BPZTo-w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Fix NULL pointer dereference when
 registering bpf trampoline
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Xu Kuohai <xukuohai@huaweicloud.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Bruno Goncalves <bgoncalv@redhat.com>,
        Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 6:31 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Thu, Jul 28, 2022 at 08:56:27PM +0800, Xu Kuohai wrote:
> > On 7/28/2022 8:27 PM, Jiri Olsa wrote:
> > > On Thu, Jul 28, 2022 at 07:40:48AM -0400, Xu Kuohai wrote:
> > > > From: Xu Kuohai <xukuohai@huawei.com>
> > >
> > > SNIP
> > >
> > > >
> > > > It's caused by a NULL tr->fops passed to ftrace_set_filter_ip(). tr->fops
> > > > is initialized to NULL and is assigned to an allocated memory address if
> > > > CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS is enabled. Since there is no
> > > > direct call on arm64 yet, the config can't be enabled.
> > > >
> > > > To fix it, call ftrace_set_filter_ip() only if tr->fops is not NULL.
> > > >
> > > > Fixes: 00963a2e75a8 ("bpf: Support bpf_trampoline on functions with IPMODIFY (e.g. livepatch)")
> > > > Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
> > > > Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> > > > Tested-by: Bruno Goncalves <bgoncalv@redhat.com>
> > > > Acked-by: Song Liu <songliubraving@fb.com>
> > > > ---
> > > >   kernel/bpf/trampoline.c | 11 +++++++++--
> > > >   1 file changed, 9 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > > > index 42e387a12694..0d5a9e0b9a7b 100644
> > > > --- a/kernel/bpf/trampoline.c
> > > > +++ b/kernel/bpf/trampoline.c
> > > > @@ -255,8 +255,15 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
> > > >                   return -ENOENT;
> > > >           if (tr->func.ftrace_managed) {
> > > > -         ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 0);
> > > > -         ret = register_ftrace_direct_multi(tr->fops, (long)new_addr);
> > > > +         if (tr->fops)
> > > > +                 ret = ftrace_set_filter_ip(tr->fops, (unsigned long)ip,
> > > > +                                            0, 0);
> > > > +         else
> > > > +                 ret = -ENOTSUPP;
> > > > +
> > > > +         if (!ret)
> > > > +                 ret = register_ftrace_direct_multi(tr->fops,
> > > > +                                                    (long)new_addr);
> > > >           } else {
> > > >                   ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
> > > >           }
> > >
> > > do we need to do the same also in unregister_fentry and modify_fentry ?
> > >
> >
> > No need for now, this is the only place where we call ftrace_set_filter_ip().
> >
> > tr->fops is passed to ftrace_set_filter_ip() and *ftrace_direct_multi()
> > functions, and when CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS is not enabled,
> > the *ftrace_direct_multi()s do nothing except returning an error code, so
> > it's safe to pass NULL to them.
>
> ok, makes sense
>
> Acked-by: Jiri Olsa <jolsa@kernel.org>
>

I've simplified this to

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 7ec7e23559ad..c122d8b3ddc9 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -248,8 +248,11 @@ static int register_fentry(struct bpf_trampoline
*tr, void *new_addr)
        int ret;

        faddr = ftrace_location((unsigned long)ip);
-       if (faddr)
+       if (faddr) {
+               if (!tr->fops)
+                       return -ENOTSUPP;
                tr->func.ftrace_managed = true;
+       }


and pushed to bpf-next. Thanks.


> jirka
