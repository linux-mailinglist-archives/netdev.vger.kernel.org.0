Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7E950BD5A
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 18:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449809AbiDVQqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 12:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449799AbiDVQqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 12:46:45 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E155F5F27B;
        Fri, 22 Apr 2022 09:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650645825; x=1682181825;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xADDbnxaU1b4Q/20IqRJCpY+MhrD0ojhcwpEDkBPSpk=;
  b=lMXJNfWaUdGMo95RYuhzGqkb0Nl75AS2LZU3dBgAsm+xBWi8y5OpL00Q
   5TDGBFvh9RFEzakixzeunIka+jmF3lUbBFzfMnHymNBtln5Ok1N6YkNWl
   y+Y9E3hbMgCY8dWCURAyU9a4UnFNJMJgGMYmVfDY/AGWA3c95KO8jKPhI
   S/M1MoYDJfkfbm7gYzlKlxfrdp5/VYlfKNbthMMh+QbNPuLZ399neeO/C
   k+z9y7yOz6jF08FjQ6rtYoFNZbUpgwuLVaW37uKm0zckCNCZHMkHMxm2U
   o0kJHXUfyhE+vFg2n47lhCTO6FExPOR9t2iLij8dTwK48kERuqr9ooX2I
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="244650074"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="244650074"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 09:43:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="530926142"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 22 Apr 2022 09:43:36 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 23MGhZw6006484;
        Fri, 22 Apr 2022 17:43:35 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Larysa Zaremba <larysa.zaremba@intel.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: Re: Accessing XDP packet memory from the end
Date:   Fri, 22 Apr 2022 18:41:37 +0200
Message-Id: <20220422164137.875143-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <87czhagxuw.fsf@toke.dk>
References: <20220421155620.81048-1-larysa.zaremba@intel.com> <87czhagxuw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Thu, 21 Apr 2022 19:17:11 +0200

> Larysa Zaremba <larysa.zaremba@intel.com> writes:
> 
> > Dear all,
> > Our team has encountered a need of accessing data_meta in a following way:
> >
> > int xdp_meta_prog(struct xdp_md *ctx)
> > {
> > 	void *data_meta_ptr = (void *)(long)ctx->data_meta;
> > 	void *data_end = (void *)(long)ctx->data_end;
> > 	void *data = (void *)(long)ctx->data;
> > 	u64 data_size = sizeof(u32);
> > 	u32 magic_meta;
> > 	u8 offset;
> >
> > 	offset = (u8)((s64)data - (s64)data_meta_ptr);
> > 	if (offset < data_size) {
> > 		bpf_printk("invalid offset: %ld\n", offset);
> > 		return XDP_DROP;
> > 	}
> >
> > 	data_meta_ptr += offset;
> > 	data_meta_ptr -= data_size;
> >
> > 	if (data_meta_ptr + data_size > data) {
> > 		return XDP_DROP;
> > 	}
> > 		
> > 	magic_meta = *((u32 *)data);
> > 	bpf_printk("Magic: %d\n", magic_meta);
> > 	return XDP_PASS;
> > }
> >
> > Unfortunately, verifier claims this code attempts to access packet with
> > an offset of -2 (a constant part) and negative offset is generally forbidden.
> >
> > For now we have 2 solutions, one is using bpf_xdp_adjust_meta(),
> > which is pretty good, but not ideal for the hot path.
> > The second one is the patch at the end.
> >
> > Do you see any other way of accessing memory from the end of data_meta/data?
> > What do you think about both suggested solutions?
> 
> The problem is that the compiler is generating code that the verifier
> doesn't understand. It's notoriously hard to get LLVM to produce code
> that preserves the right bounds checks which is why projects like Cilium
> use helpers with inline ASM to produce the right loads, like in [0].
> 
> Adapting that cilium helper to load from the metadata area, your example
> can be rewritten as follows (which works just fine with no verifier
> changes):
> 
> static __always_inline int
> xdp_load_meta_bytes(const struct xdp_md *ctx, __u64 off, void *to, const __u64 len)
> {
> 	void *from;
> 	int ret;
> 	/* LLVM tends to generate code that verifier doesn't understand,
> 	 * so force it the way we want it in order to open up a range
> 	 * on the reg.
> 	 */
> 	asm volatile("r1 = *(u32 *)(%[ctx] +8)\n\t"
> 		     "r2 = *(u32 *)(%[ctx] +0)\n\t"
> 		     "%[off] &= %[offmax]\n\t"
> 		     "r1 += %[off]\n\t"
> 		     "%[from] = r1\n\t"
> 		     "r1 += %[len]\n\t"
> 		     "if r1 > r2 goto +2\n\t"
> 		     "%[ret] = 0\n\t"
> 		     "goto +1\n\t"
> 		     "%[ret] = %[errno]\n\t"
> 		     : [ret]"=r"(ret), [from]"=r"(from)
> 		     : [ctx]"r"(ctx), [off]"r"(off), [len]"ri"(len),
> 		       [offmax]"i"(__CTX_OFF_MAX), [errno]"i"(-EINVAL)
> 		     : "r1", "r2");
> 	if (!ret)
> 		__builtin_memcpy(to, from, len);
> 	return ret;
> }
> 
> 
> SEC("xdp")
> int xdp_meta_prog(struct xdp_md *ctx)
> {
>         void *data_meta_ptr = (void *)(long)ctx->data_meta;
>         void *data = (void *)(long)ctx->data;
>         __u32 magic_meta;
>         __u8 offset;
> 	int ret;
> 
>         offset = (__u8)((__s64)data - (__s64)data_meta_ptr);
> 	ret = xdp_load_meta_bytes(ctx, offset - 4, &magic_meta, sizeof(magic_meta));
> 	if (ret) {
> 		bpf_printk("load bytes failed: %d\n", ret);
>                 return XDP_DROP;
> 	}
> 
>         bpf_printk("Magic: %d\n", magic_meta);
>         return XDP_PASS;
> }

At the moment, we use this (based on Cilium's and your), it works
just like we want C code to work previously:

#define __CTX_OFF_MAX 0xff

static __always_inline void *
can_i_access_meta_please(const struct xdp_md *ctx, __u64 off, const __u64 len)
{
	void *ret;

	/* LLVM tends to generate code that verifier doesn't understand,
	 * so force it the way we want it in order to open up a range
	 * on the reg.
	 */
	asm volatile("r1 = *(u32 *)(%[ctx] +8)\n\t"
		     "r2 = *(u32 *)(%[ctx] +0)\n\t"
		     "%[off] &= %[offmax]\n\t"
		     "r1 += %[off]\n\t"
		     "%[ret] = r1\n\t"
		     "r1 += %[len]\n\t"
		     "if r1 > r2 goto +1\n\t"
		     "goto +1\n\t"
		     "%[ret] = %[null]\n\t"
		     : [ret]"=r"(ret)
		     : [ctx]"r"(ctx), [off]"r"(off), [len]"ri"(len),
		       [offmax]"i"(__CTX_OFF_MAX), [null]"i"(NULL)
		     : "r1", "r2");

	return ret;
}

SEC("xdp")
int xdp_prognum_n0_meta(struct xdp_md *ctx)
{
	void *data_meta = (void *)(__s64)ctx->data_meta;
	void *data = (void *)(__s64)ctx->data;
	struct xdp_meta_generic *md;
	__u64 offset;

	offset = (__u64)((__s64)data - (__s64)data_meta);

	md = can_i_access_meta_please(ctx, offset, sizeof(*md));
	if (__builtin_expect(!md, 0)) {
		bpf_printk("No you can't\n");
		return XDP_DROP;
	}

	bpf_printk("Magic: 0x%04x\n", md->magic_id);
	return XDP_PASS;
}

Thanks for the help! It's a shame LLVM still suck on generating
correct object code from C.
I guess we'll define a helper above in one of the headers to not
copy-paste it back and forth between each program wanting to
access only the generic part of the metadata (which is always being
placed at the end).

> 
> -Toke
> 
> 
> [0] https://github.com/cilium/cilium/blob/master/bpf/include/bpf/ctx/xdp.h#L35

Thanks,
Al
