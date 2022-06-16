Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA9554E53F
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 16:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377012AbiFPOpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 10:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiFPOpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 10:45:12 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78583403C3;
        Thu, 16 Jun 2022 07:45:11 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o1qkA-0009Gv-05; Thu, 16 Jun 2022 16:45:10 +0200
Received: from [85.1.206.226] (helo=linux-3.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o1qk9-000CPW-Ng; Thu, 16 Jun 2022 16:45:09 +0200
Subject: Re: [PATCH bpf-next 1/2] bpf, x86: Fix tail call count offset
 calculation on bpf2bpf call
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        kernel-team@cloudflare.com
References: <20220615151721.404596-1-jakub@cloudflare.com>
 <20220615151721.404596-2-jakub@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c19ed052-90ea-3bf5-c57c-7879844579ea@iogearbox.net>
Date:   Thu, 16 Jun 2022 16:45:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220615151721.404596-2-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26574/Thu Jun 16 10:06:40 2022)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/22 5:17 PM, Jakub Sitnicki wrote:
[...]
> int entry(struct __sk_buff * skb):
>     0xffffffffa0201788:  nop    DWORD PTR [rax+rax*1+0x0]
>     0xffffffffa020178d:  xor    eax,eax
>     0xffffffffa020178f:  push   rbp
>     0xffffffffa0201790:  mov    rbp,rsp
>     0xffffffffa0201793:  sub    rsp,0x8
>     0xffffffffa020179a:  push   rax
>     0xffffffffa020179b:  xor    esi,esi
>     0xffffffffa020179d:  mov    BYTE PTR [rbp-0x1],sil
>     0xffffffffa02017a1:  mov    rax,QWORD PTR [rbp-0x9]	!!! tail call count
>     0xffffffffa02017a8:  call   0xffffffffa02017d8       !!! is at rbp-0x10
>     0xffffffffa02017ad:  leave
>     0xffffffffa02017ae:  ret
> 
> Fix it by rounding up the BPF stack depth to a multiple of 8, when
> calculating the tail call count offset on stack.
> 
> Fixes: ebf7d1f508a7 ("bpf, x64: rework pro/epilogue and tailcall handling in JIT")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>   arch/x86/net/bpf_jit_comp.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index f298b18a9a3d..c98b8c0ed3b8 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -1420,8 +1420,9 @@ st:			if (is_imm8(insn->off))
>   		case BPF_JMP | BPF_CALL:
>   			func = (u8 *) __bpf_call_base + imm32;
>   			if (tail_call_reachable) {
> +				/* mov rax, qword ptr [rbp - rounded_stack_depth - 8] */
>   				EMIT3_off32(0x48, 0x8B, 0x85,
> -					    -(bpf_prog->aux->stack_depth + 8));
> +					    -round_up(bpf_prog->aux->stack_depth, 8) - 8);

Lgtm, great catch by the way!
