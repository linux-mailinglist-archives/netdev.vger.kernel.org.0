Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC2250B4B1
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446420AbiDVKLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357489AbiDVKLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:11:42 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A2353E2D;
        Fri, 22 Apr 2022 03:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650622129; x=1682158129;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/FmqLfWpvmOwbiPUSBvWAith4pdUH6BNjBLa6DUQdf8=;
  b=b6Idk6Oa1AOOyVP6E1cyJX2VsBykd0oPwPxZqmiT89Ow80fSdJHTn1NO
   qJ6JDwSV6IgclebD72lO36kmvZHacIiRPxnpilaj1tOZd/NKjs3XVT1Ne
   tqp/g01rGI3GpQf7S2reXYlPsVDvUhydyuFhkq9qmqcdi3YqUzAEpiE/Y
   RNT1Cbs4CNqWbzmQ1F+Vhkiz5SF3AJC65WbdRem3XBkrGf8iudaSlDfyr
   1HY3Jy9sDbx2vWOwL9eycTSdYMMULL5gfFuBd3RE5ELKlMc4GhNbiAypP
   KO4AseCorkLvXL/hkfvKRY8MJDS19ff8GFd98jjSmMmxX8WTBcZRsB0sp
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="251965491"
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="251965491"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 03:08:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="511508135"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 22 Apr 2022 03:08:46 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 23MA8iG4002578;
        Fri, 22 Apr 2022 11:08:44 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        bpf <bpf@vger.kernel.org>, brouer@redhat.com,
        netdev <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>
Subject: Re: Accessing XDP packet memory from the end
Date:   Fri, 22 Apr 2022 12:06:32 +0200
Message-Id: <20220422100632.157922-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <f1417959-4b0d-7c33-4b2b-08989bb86b23@redhat.com>
References: <20220421155620.81048-1-larysa.zaremba@intel.com> <f1417959-4b0d-7c33-4b2b-08989bb86b23@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Thu, 21 Apr 2022 18:27:47 +0200

> On 21/04/2022 17.56, Larysa Zaremba wrote:
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
> 
> I'm not sure the verifier can handle this 'offset' calc. As it cannot
> statically know the sized based on this statement. Maybe this is not the
> issue.
> 
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
> 
> Are you forgetting to mention:
>   - Have you modified the NIC driver to adjust data_meta pointer and 
> provide info in this area?

Exactly. Previously, @data_meta == @data prior to running BPF
program in 100% cases. Now, the driver can provide arbitrary
metadata and set @data_meta to be @data - 32, data - 48 or so.

> 
> p.s. this is exactly what I'm also working towards[1], so I'll be happy
> to collaborate.  I'm missing the driver code, as link[1] is focused on
> decoding BTF data_meta area in userspace for AF_XDP.

Yeah, we're almost about to post a first RFC to LKML. This issue is
the last one, the rest just needs to be rebased to fix some minors
and polish the code.
It will contain the kernel core part and the driver part (only ice
for now). Then we could e.g. fuse it with your changes (we weren't
touching AF_XDP part) etc.
But for now, until an RFC is posted, you could take a look at the
code in my GH[0] if you're wish :) The second half of the ice code
is not committed yet tho.

> 
> [1] 
> https://github.com/xdp-project/bpf-examples/tree/master/AF_XDP-interaction
> 
> > For now we have 2 solutions, one is using bpf_xdp_adjust_meta(),
> > which is pretty good, but not ideal for the hot path.
> > The second one is the patch at the end.
> > 
> 
> Are you saying, verifier cannot handle that driver changed data_meta 
> pointer and provided info there (without calling bpf_xdp_adjust_meta)?

Correct. I suspect the verifier just assumes that @data_meta always
equals @data when executing BPF prog.
Let's assume:

	offset = data - data_meta; // 64 bytes
	data_meta += offset; // equals to data now
	/* Let's say xdp_meta_generic is 48 bytes long, then */
	data_meta -= sizeof(struct xdp_meta_generic);
	/* data_meta is now 16 bytes past the original data_meta,
	 * or data - 48.
	 */
	bpf_printk("magic: 0x%04x\n",
		   ((struct xdp_meta_generic)data_meta)->magic);

So in fact, this code is absolutely correct, it doesn't go past the
bounds in either direction, but the verifier claims it goes out of
bounds to the left by 48 bytes (not counting the offsetof).
OTOH,

	data_meta = (void *)ctx->data_meta;
	bpf_printk("magic: 0x%04x\n",
		   ((struct xdp_meta_generic)data_meta)->magic);

works with no issues. The verifier still thinks @data_meta == @data,
but this code effectively accesses the metadata, not the frame
itself.

> 
> 
> > Do you see any other way of accessing memory from the end of data_meta/data?
> > What do you think about both suggested solutions?
> > 
> > Best regards,
> > Larysa Zaremba
> > 
> > ---
> > 
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -3576,8 +3576,11 @@ static int check_packet_access(struct bpf_verifier_env *env, u32 regno, int off,
> >   	}
> >   
> >   	err = reg->range < 0 ? -EINVAL :
> > -	      __check_mem_access(env, regno, off, size, reg->range,
> > -				 zero_size_allowed);
> > +	      __check_mem_access(env, regno, off + reg->smin_value, size,
> > +				 reg->range + reg->smin_value, zero_size_allowed);
> > +	err = err ? :
> > +	      __check_mem_access(env, regno, off + reg->umax_value, size,
> > +				 reg->range + reg->umax_value, zero_size_allowed);
> >   	if (err) {
> >   		verbose(env, "R%d offset is outside of the packet\n", regno);
> >   		return err;

[0] https://github.com/alobakin/linux/commits/xdp_hints

Thanks,
Al
