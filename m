Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C1B2FDB8F
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 22:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732679AbhATU4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 15:56:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45235 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389776AbhATUwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 15:52:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611175887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yPuqSMnpdY19vh+6lBfYBXmpqrBCsqyMzblm/T4o1BY=;
        b=Ej4SqSZiMPSIzYtGTv3JYXIpw733N/yHKvHKC/6T+y1DUiR23fEtwfVJ6qExtXOxWqWVsp
        4wfz7QffKP6Jf5PZEQqVLGz3l4UXrayZcmzsO2kT8AdI7yU3xVgkuRZnSsVqifHRXwUjTM
        oNeOXtQQ/y33yiD8qrv00eEM/ymbJAQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-G6OnHQY0OJW9jEkggwAQjQ-1; Wed, 20 Jan 2021 15:51:07 -0500
X-MC-Unique: G6OnHQY0OJW9jEkggwAQjQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6EC38066E5;
        Wed, 20 Jan 2021 20:51:05 +0000 (UTC)
Received: from krava (unknown [10.40.194.35])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2A3D860D52;
        Wed, 20 Jan 2021 20:51:04 +0000 (UTC)
Date:   Wed, 20 Jan 2021 21:51:03 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 3/3] selftests/bpf: Add asm tests for pkt vs
 pkt_end comparison.
Message-ID: <20210120205103.GI1760208@krava>
References: <20201111031213.25109-1-alexei.starovoitov@gmail.com>
 <20201111031213.25109-4-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111031213.25109-4-alexei.starovoitov@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 07:12:13PM -0800, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Add few assembly tests for packet comparison.
> 
> Tested-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

hi,
I'm now getting error when running this test:

#347/p pkt_end < pkt taken check Did not run the program (not supported) OK
Summary: 1 PASSED, 0 SKIPPED, 0 FAILED

it looks like my kernel does not have prog->aux->ops->test_run
defined for BPF_PROG_TYPE_SK_SKB for some reason

do I miss some config option? I recall running this
back in November, so I'm confused ;-)

thanks,
jirka

> ---
>  .../testing/selftests/bpf/verifier/ctx_skb.c  | 42 +++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/verifier/ctx_skb.c b/tools/testing/selftests/bpf/verifier/ctx_skb.c
> index 2e16b8e268f2..2022c0f2cd75 100644
> --- a/tools/testing/selftests/bpf/verifier/ctx_skb.c
> +++ b/tools/testing/selftests/bpf/verifier/ctx_skb.c
> @@ -1089,3 +1089,45 @@
>  	.errstr_unpriv = "R1 leaks addr",
>  	.result = REJECT,
>  },
> +{
> +       "pkt > pkt_end taken check",
> +       .insns = {
> +       BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,                //  0. r2 = *(u32 *)(r1 + data_end)
> +                   offsetof(struct __sk_buff, data_end)),
> +       BPF_LDX_MEM(BPF_W, BPF_REG_4, BPF_REG_1,                //  1. r4 = *(u32 *)(r1 + data)
> +                   offsetof(struct __sk_buff, data)),
> +       BPF_MOV64_REG(BPF_REG_3, BPF_REG_4),                    //  2. r3 = r4
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, 42),                  //  3. r3 += 42
> +       BPF_MOV64_IMM(BPF_REG_1, 0),                            //  4. r1 = 0
> +       BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_2, 2),          //  5. if r3 > r2 goto 8
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, 14),                  //  6. r4 += 14
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_4),                    //  7. r1 = r4
> +       BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_2, 1),          //  8. if r3 > r2 goto 10
> +       BPF_LDX_MEM(BPF_H, BPF_REG_2, BPF_REG_1, 9),            //  9. r2 = *(u8 *)(r1 + 9)
> +       BPF_MOV64_IMM(BPF_REG_0, 0),                            // 10. r0 = 0
> +       BPF_EXIT_INSN(),                                        // 11. exit
> +       },
> +       .result = ACCEPT,
> +       .prog_type = BPF_PROG_TYPE_SK_SKB,
> +},
> +{
> +       "pkt_end < pkt taken check",
> +       .insns = {
> +       BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,                //  0. r2 = *(u32 *)(r1 + data_end)
> +                   offsetof(struct __sk_buff, data_end)),
> +       BPF_LDX_MEM(BPF_W, BPF_REG_4, BPF_REG_1,                //  1. r4 = *(u32 *)(r1 + data)
> +                   offsetof(struct __sk_buff, data)),
> +       BPF_MOV64_REG(BPF_REG_3, BPF_REG_4),                    //  2. r3 = r4
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, 42),                  //  3. r3 += 42
> +       BPF_MOV64_IMM(BPF_REG_1, 0),                            //  4. r1 = 0
> +       BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_2, 2),          //  5. if r3 > r2 goto 8
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, 14),                  //  6. r4 += 14
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_4),                    //  7. r1 = r4
> +       BPF_JMP_REG(BPF_JLT, BPF_REG_2, BPF_REG_3, 1),          //  8. if r2 < r3 goto 10
> +       BPF_LDX_MEM(BPF_H, BPF_REG_2, BPF_REG_1, 9),            //  9. r2 = *(u8 *)(r1 + 9)
> +       BPF_MOV64_IMM(BPF_REG_0, 0),                            // 10. r0 = 0
> +       BPF_EXIT_INSN(),                                        // 11. exit
> +       },
> +       .result = ACCEPT,
> +       .prog_type = BPF_PROG_TYPE_SK_SKB,
> +},
> -- 
> 2.24.1
> 

