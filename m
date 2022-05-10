Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DCE5226E0
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 00:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbiEJWa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 18:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236823AbiEJWaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 18:30:23 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989A6663E2;
        Tue, 10 May 2022 15:30:21 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n18so118489plg.5;
        Tue, 10 May 2022 15:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=v+XYD3B1CD7fnVkuXZZiJ8ZtuhmQGqA4o7hHZkBxvWY=;
        b=CsXF6CSIhEicYVpGrqK3J2sVIvDxYHv2oJWh66KWMXpSJNNi/o8w370qrW0HbfDFBn
         n6kWy7CfiS70LZHznsyRsmHs1fjdFaBVPjlWz8s9JDRsAapt/RXArPBvsCZh8LFxgARd
         es5EyD+9JZsPh27gwCbXyVZJvVdqpCr+/Z10J95jL47uQ02nz0Amx8oj4WyTw8G5TpZF
         jjPp0UZw4P2E2dm/00ADq1pIEoNHNA+CCayx5i2oKvUrNc80Sb8xS5rXBlWfBkgu6aSB
         JXZplPlkON7oToCHoG0GvEDknP1mSm2IreD1sy4NHpiJg1jVAh7o4GQIO0sTb/u2+6Z4
         dVEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=v+XYD3B1CD7fnVkuXZZiJ8ZtuhmQGqA4o7hHZkBxvWY=;
        b=nS3h045pEpjCd7D2gQ++E7LzHgUq7iPi4C7+ZtzV7h8zF+Ks4j+sdX1NgASG9ool66
         T4gOoZSq1Ytjkfyp0xlGeshn4oB4Vyl7wNG4sK+umc2n1Ug3y/mH02O1L7fNgIL/gY4j
         8UXWYW4gmnbJr+Pt0kTfV09lWaRk7030wWXL5qyzFUCNbXdILUYofeD5v8IQ4i6DDq6h
         KY37e8kg4Kpod47aQ9dqxM+mtUElkuJsAU753tVv0yWIkhBaTM/Q7PMFVD5xzOGZ1P6O
         8wbrNlAG3nzfSHtH98A3tHVHdsGv+/0qbppLxFvWNEq1MVrNIGBLnpTcYbduFj/MSSyv
         Aj6Q==
X-Gm-Message-State: AOAM530BTGdD5hHB53iGXYfCzdXCvoo71sknCnBULlBDhGMYwgy8wD1K
        r98W2RdecJ5O/FvZeikbopsKiBp3wiRi025oJMc=
X-Google-Smtp-Source: ABdhPJyW+3P2fiBcYuqtH2NIJob0aLq7yef+zcXGA1qS8NXwcCDxzFNmPqxro0CArW/2gU2n59aka7BMIReyiLAXsGo=
X-Received: by 2002:a17:90b:33c6:b0:1dc:ba92:41bb with SMTP id
 lk6-20020a17090b33c600b001dcba9241bbmr2013273pjb.26.1652221821087; Tue, 10
 May 2022 15:30:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220506142148.GA24802@asgard.redhat.com> <CAADnVQKNkEX-caBjozegRaOb67g1HNOHn1e-enRk_s-7Gtt=gg@mail.gmail.com>
 <20220510184155.GA8295@asgard.redhat.com>
In-Reply-To: <20220510184155.GA8295@asgard.redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 10 May 2022 15:30:10 -0700
Message-ID: <CAADnVQ+2gwhcMht4PuDnDOFKY68Wsq8QFz4Y69NBX_TLaSexQQ@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf_trace: bail out from bpf_kprobe_multi_link_attach
 when in compat
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 11:42 AM Eugene Syromiatnikov <esyr@redhat.com> wro=
te:
>
> On Tue, May 10, 2022 at 11:10:35AM -0700, Alexei Starovoitov wrote:
> > On Fri, May 6, 2022 at 7:22 AM Eugene Syromiatnikov <esyr@redhat.com> w=
rote:
> > >
> > > Since bpf_kprobe_multi_link_attach doesn't support 32-bit kernels
> > > for whatever reason,
> >
> > Jiri,
> > why did you add this restriction?
> >
> > > having it enabled for compat processes on 64-bit
> > > kernels makes even less sense due to discrepances in the type sizes
> > > that it does not handle.
> >
> > I don't follow this logic.
> > bpf progs are always 64-bit. Even when user space is 32-bit.
> > Jiri's check is for the kernel.
>
> The interface as defined (and implemented in libbpf) expects arrays of us=
erspace
> pointers to be passed (for example, syms points to an array of userspace
> pointers=E2=80=94character strings; same goes for addrs, but with generic=
 userspace
> pointers) without regard to possible difference in the pointer size in ca=
se
> of compat userspace.

I see. So kprobe_multi.syms and kprobe_multi.addrs will be 'long'
and 32-bit user space will have an issue with the 64-bit kernel.
Let's fix it properly.
We can remove sizeof(u64) !=3D sizeof(void *) and keep libbpf as-is
by keeping syms and addrs 'long' in uapi.
As far as I can see 32-bit user space on a 32-bit kernel
should work with existing code.
in_compat_syscall() can be used to extend addrs/syms.
