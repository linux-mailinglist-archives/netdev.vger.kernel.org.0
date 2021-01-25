Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E1B302FE8
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732422AbhAYXOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:14:48 -0500
Received: from www62.your-server.de ([213.133.104.62]:46376 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732831AbhAYXNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 18:13:22 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l4B2B-0008OG-W5; Tue, 26 Jan 2021 00:12:36 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l4B2B-000Nj0-L3; Tue, 26 Jan 2021 00:12:35 +0100
Subject: Re: [PATCH bpf-next 3/3] libbpf, xsk: select AF_XDP BPF program based
 on kernel version
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com,
        andrii@kernel.org, Marek Majtyka <alardam@gmail.com>
References: <20210122105351.11751-1-bjorn.topel@gmail.com>
 <20210122105351.11751-4-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <cafcfa48-ecfd-1dbb-6b3a-220a52b6db16@iogearbox.net>
Date:   Tue, 26 Jan 2021 00:12:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210122105351.11751-4-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26060/Mon Jan 25 13:28:03 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/22/21 11:53 AM, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> Add detection for kernel version, and adapt the BPF program based on
> kernel support. This way, users will get the best possible performance
> from the BPF program.
> 
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> Signed-off-by: Marek Majtyka  <alardam@gmail.com>
> ---
>   tools/lib/bpf/xsk.c | 82 +++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 79 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index e3e41ceeb1bc..1df8c133a5bc 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -46,6 +46,11 @@
>    #define PF_XDP AF_XDP
>   #endif
>   
> +enum xsk_prog {
> +	XSK_PROG_FALLBACK,
> +	XSK_PROG_REDIRECT_FLAGS,
> +};
> +
>   struct xsk_umem {
>   	struct xsk_ring_prod *fill_save;
>   	struct xsk_ring_cons *comp_save;
> @@ -351,6 +356,55 @@ int xsk_umem__create_v0_0_2(struct xsk_umem **umem_ptr, void *umem_area,
>   COMPAT_VERSION(xsk_umem__create_v0_0_2, xsk_umem__create, LIBBPF_0.0.2)
>   DEFAULT_VERSION(xsk_umem__create_v0_0_4, xsk_umem__create, LIBBPF_0.0.4)
>   
> +

Fyi, removed this extra newline when I applied the series, thanks!

> +static enum xsk_prog get_xsk_prog(void)
> +{
> +	enum xsk_prog detected = XSK_PROG_FALLBACK;
> +	struct bpf_load_program_attr prog_attr;
> +	struct bpf_create_map_attr map_attr;
> +	__u32 size_out, retval, duration;
> +	char data_in = 0, data_out;
> +	struct bpf_insn insns[] = {
> +		BPF_LD_MAP_FD(BPF_REG_1, 0),
> +		BPF_MOV64_IMM(BPF_REG_2, 0),
> +		BPF_MOV64_IMM(BPF_REG_3, XDP_PASS),
> +		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
> +		BPF_EXIT_INSN(),
[...]
