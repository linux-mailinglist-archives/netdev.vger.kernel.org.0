Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E089CEBB05
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 00:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbfJaXsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 19:48:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:52048 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727611AbfJaXsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 19:48:10 -0400
Received: from 38.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.38] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQKAe-0001Mk-Ic; Fri, 01 Nov 2019 00:48:05 +0100
Date:   Fri, 1 Nov 2019 00:48:04 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org,
        jakub.kicinski@netronome.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        toke@redhat.com
Subject: Re: [PATCH bpf-next v4 2/3] bpf: implement map_gen_lookup() callback
 for XSKMAP
Message-ID: <20191031234804.GA20080@pc-63.home>
References: <20191031084749.14626-1-bjorn.topel@gmail.com>
 <20191031084749.14626-3-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191031084749.14626-3-bjorn.topel@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25619/Thu Oct 31 09:55:29 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 09:47:48AM +0100, Björn Töpel wrote:
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> Inline the xsk_map_lookup_elem() via implementing the map_gen_lookup()
> callback. This results in emitting the bpf instructions in place of
> bpf_map_lookup_elem() helper call and better performance of bpf
> programs.
> 
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  kernel/bpf/xskmap.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
> index edcbd863650e..fa32f775b4de 100644
> --- a/kernel/bpf/xskmap.c
> +++ b/kernel/bpf/xskmap.c
> @@ -163,6 +163,22 @@ struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map, u32 key)
>  	return xs;
>  }
>  
> +static u32 xsk_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
> +{
> +	const int ret = BPF_REG_0, mp = BPF_REG_1, index = BPF_REG_2;
> +	struct bpf_insn *insn = insn_buf;
> +
> +	*insn++ = BPF_LDX_MEM(BPF_W, ret, index, 0);
> +	*insn++ = BPF_JMP_IMM(BPF_JGE, ret, map->max_entries, 5);
> +	*insn++ = BPF_ALU64_IMM(BPF_LSH, ret, ilog2(sizeof(struct xsk_sock *)));
> +	*insn++ = BPF_ALU64_IMM(BPF_ADD, mp, offsetof(struct xsk_map, xsk_map));
> +	*insn++ = BPF_ALU64_REG(BPF_ADD, ret, mp);
> +	*insn++ = BPF_LDX_MEM(BPF_DW, ret, ret, 0);

Your map slots are always exactly sizeof(struct xdp_sock *), right? Wouldn't
this BPF_DW crash on 32 bit?

Meaning, it would have to be BPF_LDX_MEM(BPF_SIZEOF(struct xsk_sock *), ...)?

> +	*insn++ = BPF_JMP_IMM(BPF_JA, 0, 0, 1);
> +	*insn++ = BPF_MOV64_IMM(ret, 0);
> +	return insn - insn_buf;
> +}
> +
>  int __xsk_map_redirect(struct bpf_map *map, struct xdp_buff *xdp,
>  		       struct xdp_sock *xs)
>  {
> @@ -303,6 +319,7 @@ const struct bpf_map_ops xsk_map_ops = {
>  	.map_free = xsk_map_free,
>  	.map_get_next_key = xsk_map_get_next_key,
>  	.map_lookup_elem = xsk_map_lookup_elem,
> +	.map_gen_lookup = xsk_map_gen_lookup,
>  	.map_lookup_elem_sys_only = xsk_map_lookup_elem_sys_only,
>  	.map_update_elem = xsk_map_update_elem,
>  	.map_delete_elem = xsk_map_delete_elem,
> -- 
> 2.20.1
> 
