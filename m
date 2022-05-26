Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDD45353EA
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 21:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347805AbiEZT27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 15:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242670AbiEZT24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 15:28:56 -0400
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F69F4DF52;
        Thu, 26 May 2022 12:28:55 -0700 (PDT)
Received: by mail-qt1-f174.google.com with SMTP id w17so2680433qtk.13;
        Thu, 26 May 2022 12:28:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ABNBkho3HuokJ1OxV81tEGMepDWeKd0C7azPUMmvl4s=;
        b=R1uR3BjuA1203FWh5X053ulrzj0MDRVnmpAbLve3D8UcBX0KWXA9frJf34OB6TZjEl
         /Mwg87/LD/IXaRJ4LZwLT31sxJ318ahjtKFf3VA9diuJSwUk4HmttWFVJ9732NOPA7og
         rLH/azkkbVCY2PDfU5PpYkgvDdsxm42tUGOE/3zK8T5SIYZhJ7Cg7bz30zSOBLuz4Y3e
         GtJ1K1WAWycNQ8u1nJ4s4vyv5eZd8VDkhUlYevsHTpqq/OdwGqn0gujIHxC2BVIJmjv2
         P0nIRZ+X70eByJ6KTxbjiQJr/sQx7cfr3PQYz/ZcYhAuWPxk7/nktyaL1tHAQq/LqNbR
         tuRA==
X-Gm-Message-State: AOAM533+F84Yybj7bs85uuCe7U7NKHWV10GbxAnYgSTI2cltmN8Ewd4T
        GoZVzF35JkUArlxfTqrEDeM=
X-Google-Smtp-Source: ABdhPJwZuGHr5yFZm4ksvR46I9zWL120ve44b2CID8M+OkKAYk6B54B2Fm2v9qAIuQanEJ2q1P1AyQ==
X-Received: by 2002:ac8:59d3:0:b0:2f3:d7ee:2b54 with SMTP id f19-20020ac859d3000000b002f3d7ee2b54mr30726125qtf.290.1653593334366;
        Thu, 26 May 2022 12:28:54 -0700 (PDT)
Received: from dev0025.ash9.facebook.com (fwdproxy-ash-006.fbsv.net. [2a03:2880:20ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id b13-20020a05620a0ccd00b006a36b7e55b3sm1587812qkj.4.2022.05.26.12.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 12:28:53 -0700 (PDT)
Date:   Thu, 26 May 2022 12:28:51 -0700
From:   David Vernet <void@manifault.com>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kernel-team@fb.com,
        Mykola Lysenko <mykolal@fb.com>
Subject: Re: [PATCH bpf] selftests/bpf: fix stacktrace_build_id with missing
 kprobe/urandom_read
Message-ID: <20220526192851.mu65slufe5rzdxir@dev0025.ash9.facebook.com>
References: <20220526191608.2364049-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526191608.2364049-1-song@kernel.org>
User-Agent: NeoMutt/20211029
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 12:16:08PM -0700, Song Liu wrote:
> Kernel function urandom_read is replaced with urandom_read_iter.
> Therefore, kprobe on urandom_read is not working any more:
> 
> [root@eth50-1 bpf]# ./test_progs -n 161
> test_stacktrace_build_id:PASS:skel_open_and_load 0 nsec
> libbpf: kprobe perf_event_open() failed: No such file or directory
> libbpf: prog 'oncpu': failed to create kprobe 'urandom_read+0x0' \
>         perf event: No such file or directory
> libbpf: prog 'oncpu': failed to auto-attach: -2
> test_stacktrace_build_id:FAIL:attach_tp err -2
> 161     stacktrace_build_id:FAIL
> 
> Fix this by replacing urandom_read with urandom_read_iter in the test.
> 
> Fixes: 1b388e7765f2 ("random: convert to using fops->read_iter()")
> Reported-by: Mykola Lysenko <mykolal@fb.com>
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
> index 6c62bfb8bb6f..0c4426592a26 100644
> --- a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
> +++ b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
> @@ -39,7 +39,7 @@ struct {
>  	__type(value, stack_trace_t);
>  } stack_amap SEC(".maps");
>  
> -SEC("kprobe/urandom_read")
> +SEC("kprobe/urandom_read_iter")
>  int oncpu(struct pt_regs *args)
>  {
>  	__u32 max_len = sizeof(struct bpf_stack_build_id)
> -- 
> 2.30.2
> 

Acked-by: David Vernet <void@manifault.com>
