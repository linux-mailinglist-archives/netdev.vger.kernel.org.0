Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B373CD9C69
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 23:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390160AbfJPVWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 17:22:08 -0400
Received: from www62.your-server.de ([213.133.104.62]:47806 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729231AbfJPVWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 17:22:08 -0400
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iKqk2-0002cX-Hy; Wed, 16 Oct 2019 23:21:58 +0200
Received: from [178.197.249.55] (helo=pc-63.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iKqk2-0001ke-8R; Wed, 16 Oct 2019 23:21:58 +0200
Subject: Re: [PATCH v3 bpf-next 06/11] bpf: implement accurate raw_tp context
 access via BTF
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     x86@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
References: <20191016032505.2089704-1-ast@kernel.org>
 <20191016032505.2089704-7-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <04fab556-9eda-87ec-8f8c-defcab25a80e@iogearbox.net>
Date:   Wed, 16 Oct 2019 23:21:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191016032505.2089704-7-ast@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25604/Wed Oct 16 10:53:05 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/16/19 5:25 AM, Alexei Starovoitov wrote:
> libbpf analyzes bpf C program, searches in-kernel BTF for given type name
> and stores it into expected_attach_type.
> The kernel verifier expects this btf_id to point to something like:
> typedef void (*btf_trace_kfree_skb)(void *, struct sk_buff *skb, void *loc);
> which represents signature of raw_tracepoint "kfree_skb".
> 
> Then btf_ctx_access() matches ctx+0 access in bpf program with 'skb'
> and 'ctx+8' access with 'loc' arguments of "kfree_skb" tracepoint.
> In first case it passes btf_id of 'struct sk_buff *' back to the verifier core
> and 'void *' in second case.
> 
> Then the verifier tracks PTR_TO_BTF_ID as any other pointer type.
> Like PTR_TO_SOCKET points to 'struct bpf_sock',
> PTR_TO_TCP_SOCK points to 'struct bpf_tcp_sock', and so on.
> PTR_TO_BTF_ID points to in-kernel structs.
> If 1234 is btf_id of 'struct sk_buff' in vmlinux's BTF
> then PTR_TO_BTF_ID#1234 points to one of in kernel skbs.
> 
> When PTR_TO_BTF_ID#1234 is dereferenced (like r2 = *(u64 *)r1 + 32)
> the btf_struct_access() checks which field of 'struct sk_buff' is
> at offset 32. Checks that size of access matches type definition
> of the field and continues to track the dereferenced type.
> If that field was a pointer to 'struct net_device' the r2's type
> will be PTR_TO_BTF_ID#456. Where 456 is btf_id of 'struct net_device'
> in vmlinux's BTF.
> 
> Such verifier analysis prevents "cheating" in BPF C program.
> The program cannot cast arbitrary pointer to 'struct sk_buff *'
> and access it. C compiler would allow type cast, of course,
> but the verifier will notice type mismatch based on BPF assembly
> and in-kernel BTF.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Overall set looks great!

[...]
> +int btf_struct_access(struct bpf_verifier_log *log,
> +		      const struct btf_type *t, int off, int size,
> +		      enum bpf_access_type atype,
> +		      u32 *next_btf_id)
> +{
> +	const struct btf_member *member;
> +	const struct btf_type *mtype;
> +	const char *tname, *mname;
> +	int i, moff = 0, msize;
> +
> +again:
> +	tname = __btf_name_by_offset(btf_vmlinux, t->name_off);

More of a high-level question wrt btf_ctx_access(), is there a reason the ctx
access is only done for raw_tp? I presume kprobes is still on todo (?), what
about uprobes which also have pt_regs and could benefit from this work, but is
not fixed to btf_vmlinux to search its ctx type.

I presume BPF_LDX | BPF_PROBE_MEM | BPF_* would need no additional encoding,
but JIT emission would have to differ depending on the prog type.

> +	if (!btf_type_is_struct(t)) {
> +		bpf_log(log, "Type '%s' is not a struct", tname);
> +		return -EINVAL;
> +	}
> +
> +	for_each_member(i, t, member) {
> +		/* offset of the field in bits */
> +		moff = btf_member_bit_offset(t, member);
> +
> +		if (btf_member_bitfield_size(t, member))
> +			/* bitfields are not supported yet */
> +			continue;
> +
> +		if (off + size <= moff / 8)
> +			/* won't find anything, field is already too far */
> +			break;
> +
> +		/* type of the field */
> +		mtype = btf_type_by_id(btf_vmlinux, member->type);
> +		mname = __btf_name_by_offset(btf_vmlinux, member->name_off);
> +
> +		/* skip modifiers */
[...]
