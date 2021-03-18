Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8160A340964
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 16:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhCRP6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 11:58:15 -0400
Received: from www62.your-server.de ([213.133.104.62]:51900 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbhCRP6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 11:58:06 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lMv2B-0009xy-Qk; Thu, 18 Mar 2021 16:58:03 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lMv2B-000GJ0-DL; Thu, 18 Mar 2021 16:58:03 +0100
Subject: Re: [PATCH bpf-next v2] bpf: Simplify expression for identify bpf mem
 type
To:     Jianlin Lv <Jianlin.Lv@arm.com>, bpf@vger.kernel.org
Cc:     kuba@kernel.org, simon.horman@netronome.com, davem@davemloft.net,
        ast@kernel.org, alexei.starovoitov@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-api@vger.kernel.org,
        iecedge@gmail.com
References: <20210318063626.216024-1-Jianlin.Lv@arm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <939f6d78-b6f8-b9fc-35b7-e8560a8b020c@iogearbox.net>
Date:   Thu, 18 Mar 2021 16:58:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210318063626.216024-1-Jianlin.Lv@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26112/Thu Mar 18 12:08:11 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/21 7:36 AM, Jianlin Lv wrote:
> Added BPF_LD_ST_SIZE_MASK macro as mask of size modifier that help to
> reduce the evaluation of expressions in if statements,
> and remove BPF_SIZE_MASK in netronome driver.
> 
> Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
> ---
> v2: Move the bpf_LD_ST_SIZE_MASK macro definition to include/linux/bpf.h
> ---
>   drivers/net/ethernet/netronome/nfp/bpf/main.h |  8 +++-----
>   include/linux/bpf.h                           |  1 +
>   kernel/bpf/verifier.c                         | 12 ++++--------
>   3 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.h b/drivers/net/ethernet/netronome/nfp/bpf/main.h
> index d0e17eebddd9..e90981e69763 100644
> --- a/drivers/net/ethernet/netronome/nfp/bpf/main.h
> +++ b/drivers/net/ethernet/netronome/nfp/bpf/main.h
> @@ -346,8 +346,6 @@ struct nfp_insn_meta {
>   	struct list_head l;
>   };
>   
> -#define BPF_SIZE_MASK	0x18
> -
>   static inline u8 mbpf_class(const struct nfp_insn_meta *meta)
>   {
>   	return BPF_CLASS(meta->insn.code);
> @@ -375,7 +373,7 @@ static inline bool is_mbpf_alu(const struct nfp_insn_meta *meta)
>   
>   static inline bool is_mbpf_load(const struct nfp_insn_meta *meta)
>   {
> -	return (meta->insn.code & ~BPF_SIZE_MASK) == (BPF_LDX | BPF_MEM);
> +	return (meta->insn.code & ~BPF_LD_ST_SIZE_MASK) == (BPF_LDX | BPF_MEM);
>   }
>   
>   static inline bool is_mbpf_jmp32(const struct nfp_insn_meta *meta)
> @@ -395,7 +393,7 @@ static inline bool is_mbpf_jmp(const struct nfp_insn_meta *meta)
>   
>   static inline bool is_mbpf_store(const struct nfp_insn_meta *meta)
>   {
> -	return (meta->insn.code & ~BPF_SIZE_MASK) == (BPF_STX | BPF_MEM);
> +	return (meta->insn.code & ~BPF_LD_ST_SIZE_MASK) == (BPF_STX | BPF_MEM);
>   }
>   
>   static inline bool is_mbpf_load_pkt(const struct nfp_insn_meta *meta)
> @@ -430,7 +428,7 @@ static inline bool is_mbpf_classic_store_pkt(const struct nfp_insn_meta *meta)
>   
>   static inline bool is_mbpf_atomic(const struct nfp_insn_meta *meta)
>   {
> -	return (meta->insn.code & ~BPF_SIZE_MASK) == (BPF_STX | BPF_ATOMIC);
> +	return (meta->insn.code & ~BPF_LD_ST_SIZE_MASK) == (BPF_STX | BPF_ATOMIC);
>   }
>   
>   static inline bool is_mbpf_mul(const struct nfp_insn_meta *meta)
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index a25730eaa148..e85924719c65 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -995,6 +995,7 @@ struct bpf_array {
>   				 BPF_F_RDONLY_PROG |	\
>   				 BPF_F_WRONLY |		\
>   				 BPF_F_WRONLY_PROG)
> +#define BPF_LD_ST_SIZE_MASK	0x18	/* mask of size modifier */
>   
>   #define BPF_MAP_CAN_READ	BIT(0)
>   #define BPF_MAP_CAN_WRITE	BIT(1)
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index f9096b049cd6..29fdfdb8abfa 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -11384,15 +11384,11 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>   	for (i = 0; i < insn_cnt; i++, insn++) {
>   		bpf_convert_ctx_access_t convert_ctx_access;
>   
> -		if (insn->code == (BPF_LDX | BPF_MEM | BPF_B) ||
> -		    insn->code == (BPF_LDX | BPF_MEM | BPF_H) ||
> -		    insn->code == (BPF_LDX | BPF_MEM | BPF_W) ||
> -		    insn->code == (BPF_LDX | BPF_MEM | BPF_DW))
> +		/* opcode: BPF_MEM | <size> | BPF_LDX */
> +		if ((insn->code & ~BPF_LD_ST_SIZE_MASK) == (BPF_LDX | BPF_MEM))
>   			type = BPF_READ;
> -		else if (insn->code == (BPF_STX | BPF_MEM | BPF_B) ||
> -			 insn->code == (BPF_STX | BPF_MEM | BPF_H) ||
> -			 insn->code == (BPF_STX | BPF_MEM | BPF_W) ||
> -			 insn->code == (BPF_STX | BPF_MEM | BPF_DW))
> +		/* opcode: BPF_MEM | <size> | BPF_STX */
> +		else if ((insn->code & ~BPF_LD_ST_SIZE_MASK) == (BPF_STX | BPF_MEM))
>   			type = BPF_WRITE;
>   		else
>   			continue;
> 

To me this cleanup makes the code harder to read, in particular on verfier side,
I don't think it's worth it, especially given it's not in (highly) performance
critical code.

Thanks,
Daniel
