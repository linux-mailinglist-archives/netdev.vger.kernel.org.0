Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A333531A20
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbiEWUZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 16:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbiEWUZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 16:25:44 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1282CC5DB9;
        Mon, 23 May 2022 13:25:43 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ntEcR-0000zc-VY; Mon, 23 May 2022 22:25:36 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ntEcR-000GNc-AC; Mon, 23 May 2022 22:25:35 +0200
Subject: Re: [PATCH] bpf: fix probe read error in ___bpf_prog_run()
To:     menglong8.dong@gmail.com, ast@kernel.org
Cc:     andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>,
        Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
References: <20220523073732.296247-1-imagedong@tencent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <abb90d45-e39e-4fdc-9930-17e3f6f87c06@iogearbox.net>
Date:   Mon, 23 May 2022 22:25:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220523073732.296247-1-imagedong@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26550/Mon May 23 10:05:39 2022)
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/22 9:37 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> I think there is something wrong with BPF_PROBE_MEM in ___bpf_prog_run()
> in big-endian machine. Let's make a test and see what will happen if we
> want to load a 'u16' with BPF_PROBE_MEM.
> 
> Let's make the src value '0x0001', the value of dest register will become
> 0x0001000000000000, as the value will be loaded to the first 2 byte of
> DST with following code:
> 
>    bpf_probe_read_kernel(&DST, SIZE, (const void *)(long) (SRC + insn->off));
> 
> Obviously, the value in DST is not correct. In fact, we can compare
> BPF_PROBE_MEM with LDX_MEM_H:
> 
>    DST = *(SIZE *)(unsigned long) (SRC + insn->off);
> 
> If the memory load is done by LDX_MEM_H, the value in DST will be 0x1 now.
> 
> And I think this error results in the test case 'test_bpf_sk_storage_map'
> failing:
> 
>    test_bpf_sk_storage_map:PASS:bpf_iter_bpf_sk_storage_map__open_and_load 0 nsec
>    test_bpf_sk_storage_map:PASS:socket 0 nsec
>    test_bpf_sk_storage_map:PASS:map_update 0 nsec
>    test_bpf_sk_storage_map:PASS:socket 0 nsec
>    test_bpf_sk_storage_map:PASS:map_update 0 nsec
>    test_bpf_sk_storage_map:PASS:socket 0 nsec
>    test_bpf_sk_storage_map:PASS:map_update 0 nsec
>    test_bpf_sk_storage_map:PASS:attach_iter 0 nsec
>    test_bpf_sk_storage_map:PASS:create_iter 0 nsec
>    test_bpf_sk_storage_map:PASS:read 0 nsec
>    test_bpf_sk_storage_map:FAIL:ipv6_sk_count got 0 expected 3
>    $10/26 bpf_iter/bpf_sk_storage_map:FAIL
> 
> The code of the test case is simply, it will load sk->sk_family to the
> register with BPF_PROBE_MEM and check if it is AF_INET6. With this patch,
> now the test case 'bpf_iter' can pass:
> 
>    $10  bpf_iter:OK
> 
> Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>   kernel/bpf/core.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 13e9dbeeedf3..09e3f374739a 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1945,14 +1945,15 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
>   	LDST(W,  u32)
>   	LDST(DW, u64)
>   #undef LDST
> -#define LDX_PROBE(SIZEOP, SIZE)							\
> +#define LDX_PROBE(SIZEOP, SIZE, TYPE)						\
>   	LDX_PROBE_MEM_##SIZEOP:							\
>   		bpf_probe_read_kernel(&DST, SIZE, (const void *)(long) (SRC + insn->off));	\
> +		DST = *((TYPE *)&DST);						\
>   		CONT;
> -	LDX_PROBE(B,  1)
> -	LDX_PROBE(H,  2)
> -	LDX_PROBE(W,  4)
> -	LDX_PROBE(DW, 8)
> +	LDX_PROBE(B,  1, u8)
> +	LDX_PROBE(H,  2, u16)
> +	LDX_PROBE(W,  4, u32)
> +	LDX_PROBE(DW, 8, u64)

Completely uncompiled, but maybe just fold it into LDST instead:

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 9cc91f0f3115..fc5c29243739 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1948,6 +1948,11 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
                 CONT;                                                   \
         LDX_MEM_##SIZEOP:                                               \
                 DST = *(SIZE *)(unsigned long) (SRC + insn->off);       \
+               CONT;                                                   \
+       LDX_PROBE_MEM_##SIZEOP:                                         \
+               bpf_probe_read_kernel(&DST, sizeof(SIZE),               \
+                                     (const void *)(long)(SRC + insn->off)); \
+               DST = *((SIZE *)&DST);                                  \
                 CONT;

         LDST(B,   u8)
@@ -1955,15 +1960,6 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
         LDST(W,  u32)
         LDST(DW, u64)
  #undef LDST
-#define LDX_PROBE(SIZEOP, SIZE)                                                        \
-       LDX_PROBE_MEM_##SIZEOP:                                                 \
-               bpf_probe_read_kernel(&DST, SIZE, (const void *)(long) (SRC + insn->off));      \
-               CONT;
-       LDX_PROBE(B,  1)
-       LDX_PROBE(H,  2)
-       LDX_PROBE(W,  4)
-       LDX_PROBE(DW, 8)
-#undef LDX_PROBE

Thanks,
Daniel
