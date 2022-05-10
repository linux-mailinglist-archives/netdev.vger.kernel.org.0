Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE95E522440
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 20:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244810AbiEJSmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 14:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235872AbiEJSmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 14:42:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 571BA1649BE
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 11:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652208125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=My8Rl7ea47B+HwUMWyal7bJCbA6soPVSA7SmTGeFXV4=;
        b=i8lY2zo5GTykQHnfFjcCLWqMClGpzGj3ydC/URkbNpsGfOZQ4wPqONhD5TIRAXvbAsfS6p
        qTjWPVPQnIaTJNICcIR+2hw6/pTd/1TM2wLRdviCqukqDMwMf3s49hkGwdPwPth1TzMdMA
        ssfcN04sNVETEoKwSnyx/n5b/t3Y0JM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-gTJ2yLWsM_Ot9w76UMdo3Q-1; Tue, 10 May 2022 14:42:02 -0400
X-MC-Unique: gTJ2yLWsM_Ot9w76UMdo3Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96F7A185A7BA;
        Tue, 10 May 2022 18:42:01 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2036515230D2;
        Tue, 10 May 2022 18:41:57 +0000 (UTC)
Date:   Tue, 10 May 2022 20:41:55 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Subject: Re: [PATCH bpf] bpf_trace: bail out from
 bpf_kprobe_multi_link_attach when in compat
Message-ID: <20220510184155.GA8295@asgard.redhat.com>
References: <20220506142148.GA24802@asgard.redhat.com>
 <CAADnVQKNkEX-caBjozegRaOb67g1HNOHn1e-enRk_s-7Gtt=gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQKNkEX-caBjozegRaOb67g1HNOHn1e-enRk_s-7Gtt=gg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 11:10:35AM -0700, Alexei Starovoitov wrote:
> On Fri, May 6, 2022 at 7:22 AM Eugene Syromiatnikov <esyr@redhat.com> wrote:
> >
> > Since bpf_kprobe_multi_link_attach doesn't support 32-bit kernels
> > for whatever reason,
> 
> Jiri,
> why did you add this restriction?
> 
> > having it enabled for compat processes on 64-bit
> > kernels makes even less sense due to discrepances in the type sizes
> > that it does not handle.
> 
> I don't follow this logic.
> bpf progs are always 64-bit. Even when user space is 32-bit.
> Jiri's check is for the kernel.

The interface as defined (and implemented in libbpf) expects arrays of userspace
pointers to be passed (for example, syms points to an array of userspace
pointers—character strings; same goes for addrs, but with generic userspace
pointers) without regard to possible difference in the pointer size in case
of compat userspace.

> > Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
> > Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> > ---
> >  kernel/trace/bpf_trace.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index d8553f4..9560af6 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -2410,7 +2410,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
> >         int err;
> >
> >         /* no support for 32bit archs yet */
> > -       if (sizeof(u64) != sizeof(void *))
> > +       if (sizeof(u64) != sizeof(void *) || in_compat_syscall())
> >                 return -EOPNOTSUPP;
> >
> >         if (prog->expected_attach_type != BPF_TRACE_KPROBE_MULTI)
> > --
> > 2.1.4
> >
> 

