Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7A052C405
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 22:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242110AbiERUE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 16:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242109AbiERUE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 16:04:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E54F719C757
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652904266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cg+jK1C7VyPf51yeEPplXxbPfgA1BVLN1iSf3puxwqE=;
        b=NEM+hRl/sMyy13WWuCcS2jgLjDGXB1NlX99uph5347BrB09aUAy2XNjctvs+uDafHKvvzz
        CwucL0HQcN2NS/sAVC4k+FBbGEfNMsitibkQw3B7PBz8S7TqnM8o//SF2LSjZZXaVNdKlF
        cfWXI1kEyqPjMHkdZK2Be5anS5kCGnk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-VnHplXE5Pdytuyy6-DrgUg-1; Wed, 18 May 2022 16:04:24 -0400
X-MC-Unique: VnHplXE5Pdytuyy6-DrgUg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 536B42800885;
        Wed, 18 May 2022 20:04:05 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EDFB3492C14;
        Wed, 18 May 2022 20:04:01 +0000 (UTC)
Date:   Wed, 18 May 2022 22:03:58 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf v3 2/2] bpf_trace: bail out from
 bpf_kprobe_multi_link_attach when in compat
Message-ID: <20220518200358.GB29226@asgard.redhat.com>
References: <cover.1652876187.git.esyr@redhat.com>
 <47cbdb76178a112763a3766a03d8cc51842fcab0.1652876188.git.esyr@redhat.com>
 <7bbb4a95-0d12-2a8f-9503-2613d774eaaa@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bbb4a95-0d12-2a8f-9503-2613d774eaaa@fb.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 09:55:05AM -0700, Yonghong Song wrote:
> 
> 
> On 5/18/22 5:22 AM, Eugene Syromiatnikov wrote:
> >Since bpf_kprobe_multi_link_attach doesn't support 32-bit kernels
> >for whatever reason, having it enabled for compat processes on 64-bit
> >kernels makes even less sense due to discrepances in the type sizes
> >that it does not handle.
> 
> If I understand correctly, the reason is due to
> in libbpf we have
> struct bpf_link_create_opts {
>         size_t sz; /* size of this struct for forward/backward compatibility
> */
>         __u32 flags;
>         union bpf_iter_link_info *iter_info;
>         __u32 iter_info_len;
>         __u32 target_btf_id;
>         union {
>                 struct {
>                         __u64 bpf_cookie;
>                 } perf_event;
>                 struct {
>                         __u32 flags;
>                         __u32 cnt;
>                         const char **syms;
>                         const unsigned long *addrs;
>                         const __u64 *cookies;
>                 } kprobe_multi;
>         };
>         size_t :0;
> };
> 
> Note that we have `const unsigned long *addrs;`
> 
> If we have 32-bit user space application and 64bit kernel,
> and we will have userspace 32-bit pointers and kernel as
> 64bit pointers and current kernel doesn't handle 32-bit
> user pointer properly.
> 
> Consider this may involve libbpf uapi change, maybe
> we should change "const unsigned long *addrs;" to
> "const __u64 *addrs;" considering we haven't freeze
> libbpf UAPI yet.
> 
> Otherwise, we stick to current code with this patch,
> it will make it difficult to support 32-bit app with
> 64-bit kernel for kprobe_multi in the future due to
> uapi issues.
> 
> WDYT?

As 32 bit arches are "unsupported" currently, the change would be more
a semantic one rather then practical;  I don't mind having it here (basically,
the tools/* part of [1]), though (assuming it is still possible to get it
in 5.18).

[1] https://lore.kernel.org/lkml/6ef675aeeea442fa8fc168cd1cb4e4e474f65a3f.1652772731.git.esyr@redhat.com/

> >
> >Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
> >Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> >---
> >  kernel/trace/bpf_trace.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> >index 212faa4..2f83489 100644
> >--- a/kernel/trace/bpf_trace.c
> >+++ b/kernel/trace/bpf_trace.c
> >@@ -2412,7 +2412,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
> >  	int err;
> >  	/* no support for 32bit archs yet */
> >-	if (sizeof(u64) != sizeof(void *))
> >+	if (sizeof(u64) != sizeof(void *) || in_compat_syscall())
> >  		return -EOPNOTSUPP;
> >  	if (prog->expected_attach_type != BPF_TRACE_KPROBE_MULTI)
> 

