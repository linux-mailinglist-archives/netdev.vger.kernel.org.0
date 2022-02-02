Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A354A707E
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 13:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240243AbiBBMK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 07:10:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:4817 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232109AbiBBMK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 07:10:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643803828; x=1675339828;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YmxMLJ95REGy0bqVN5sejcHYM1laIC+RS0DJHm4FlWs=;
  b=gsM19nT0/cXJi4kGjBsGyBNNALdL76FHiWqWdXGRwZC1n3FD41EBc5FP
   1cobBGMaLv2eJXwosWE7TkDglYVHNRM+MPBsE7pMdevruvOXaXcKqrw64
   XTYv/ypg8AkNxcqhaa8vid/SRD7LyktgUd2DQC+YhJn0OFucjWMdvImfF
   saPBpuKuIxAMF7bcYe/Pu7Qz4CBlhz9ctGCBbeRhT44XC6Ozuk1VijkWv
   hLW6pvehuKDQ4img7S14bxeSLQlYGprTCUhLBA5s8sVJOVqbOfpmOq8mv
   wLsYkCuDJjRT3zPx6Om2R6Se2PA4tAx1DBQMFVS76XTA+Y7UA9ixQOhfF
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10245"; a="272385841"
X-IronPort-AV: E=Sophos;i="5.88,336,1635231600"; 
   d="scan'208";a="272385841"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 04:10:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,336,1635231600"; 
   d="scan'208";a="534832246"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 02 Feb 2022 04:10:26 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 212CAPlH013636;
        Wed, 2 Feb 2022 12:10:25 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: Re: [RFC PATCH 2/3] net: gro: minor optimization for dev_gro_receive()
Date:   Wed,  2 Feb 2022 13:08:27 +0100
Message-Id: <20220202120827.23716-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <7bbab59c6d6cd2eb4e6d2fb7b2c2636b7d03445d.camel@redhat.com>
References: <cover.1642519257.git.pabeni@redhat.com> <35d722e246b7c4afb6afb03760df6f664db4ef05.1642519257.git.pabeni@redhat.com> <20220118155620.27706-1-alexandr.lobakin@intel.com> <c262125543e39d6b869e522da0ed59044eb07722.camel@redhat.com> <20220118173903.31823-1-alexandr.lobakin@intel.com> <7bbab59c6d6cd2eb4e6d2fb7b2c2636b7d03445d.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Wed, 02 Feb 2022 11:09:41 +0100

> Hello,

Hi!

> 
> On Tue, 2022-01-18 at 18:39 +0100, Alexander Lobakin wrote:
> > From: Paolo Abeni <pabeni@redhat.com>
> > Date: Tue, 18 Jan 2022 17:31:00 +0100
> > 
> > > On Tue, 2022-01-18 at 16:56 +0100, Alexander Lobakin wrote:
> > > > From: Paolo Abeni <pabeni@redhat.com>
> > > > Date: Tue, 18 Jan 2022 16:24:19 +0100
> > > > 
> > > > > While inspecting some perf report, I noticed that the compiler
> > > > > emits suboptimal code for the napi CB initialization, fetching
> > > > > and storing multiple times the memory for flags bitfield.
> > > > > This is with gcc 10.3.1, but I observed the same with older compiler
> > > > > versions.
> > > > > 
> > > > > We can help the compiler to do a nicer work e.g. initially setting
> > > > > all the bitfield to 0 using an u16 alias. The generated code is quite
> > > > > smaller, with the same number of conditional
> > > > > 
> > > > > Before:
> > > > > objdump -t net/core/gro.o | grep " F .text"
> > > > > 0000000000000bb0 l     F .text	0000000000000357 dev_gro_receive
> > > > > 
> > > > > After:
> > > > > 0000000000000bb0 l     F .text	000000000000033c dev_gro_receive
> > > > > 
> > > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > > ---
> > > > >  include/net/gro.h | 13 +++++++++----
> > > > >  net/core/gro.c    | 16 +++++-----------
> > > > >  2 files changed, 14 insertions(+), 15 deletions(-)
> > > > > 
> > > > > diff --git a/include/net/gro.h b/include/net/gro.h
> > > > > index 8f75802d50fd..a068b27d341f 100644
> > > > > --- a/include/net/gro.h
> > > > > +++ b/include/net/gro.h
> > > > > @@ -29,14 +29,17 @@ struct napi_gro_cb {
> > > > >  	/* Number of segments aggregated. */
> > > > >  	u16	count;
> > > > >  
> > > > > -	/* Start offset for remote checksum offload */
> > > > > -	u16	gro_remcsum_start;
> > > > > +	/* Used in ipv6_gro_receive() and foo-over-udp */
> > > > > +	u16	proto;
> > > > >  
> > > > >  	/* jiffies when first packet was created/queued */
> > > > >  	unsigned long age;
> > > > >  
> > > > > -	/* Used in ipv6_gro_receive() and foo-over-udp */
> > > > > -	u16	proto;
> > > > > +	/* portion of the cb set to zero at every gro iteration */
> > > > > +	u32	zeroed_start[0];
> > > > > +
> > > > > +	/* Start offset for remote checksum offload */
> > > > > +	u16	gro_remcsum_start;
> > > > >  
> > > > >  	/* This is non-zero if the packet may be of the same flow. */
> > > > >  	u8	same_flow:1;
> > > > > @@ -70,6 +73,8 @@ struct napi_gro_cb {
> > > > >  	/* GRO is done by frag_list pointer chaining. */
> > > > >  	u8	is_flist:1;
> > > > >  
> > > > > +	u32	zeroed_end[0];
> > > > 
> > > > This should be wrapped in struct_group() I believe, or compilers
> > > > will start complaining soon. See [0] for the details.
> > > > Adding Kees to the CCs.
> > > 
> > > Thank you for the reference. That really slipped-off my mind.
> > > 
> > > This patch does not use memcpy() or similar, just a single direct
> > > assignement. Would that still require struct_group()?
> > 
> > Oof, sorry, I saw start/end and overlooked that it's only for
> > a single assignment.
> > Then it shouldn't cause warnings, but maybe use an anonymous
> > union instead?
> > 
> > 	union {
> > 		u32 zeroed;
> > 		struct {
> > 			u16 gro_remcsum_start;
> > 			...
> > 		};
> > 	};
> > 	__wsum csum;
> > 
> > Use can still use a BUILD_BUG_ON() in this case, like
> > sizeof(zeroed) != offsetof(csum) - offsetof(zeroed).
> 
> Please forgive me for the very long delay. I'm looking again at this
> stuff for formal non-rfc submission.

Sure, not a problem at all (:

> 
> I like the anonymous union less, because it will move around much more
> code - making the patch less readable - and will be more fragile e.g.
> some comment alike "please don't move around 'csum'" would be needed.

We still need comments around zeroed_{start,end}[0] for now.
I used offsetof(csum) as offsetofend(is_flist) which I'd prefer here
unfortunately expands to offsetof(is_flist) + sizeof(is_flist), and
the latter causes an error of using sizeof() against a bitfield.

> 
> No strong opinion anyway, so if you really prefer that way I can adapt.
> Please let me know.

I don't really have a strong preference here, I just suspect that
zero-length array will produce or already produce -Warray-bounds
warnings, and empty-struct constructs like

	struct { } zeroed_start;
	u16 gro_remcsum_start;
	...
	struct { } zeroed_end;

	memset(NAPI_GRO_CB(skb)->zeroed_start, 0,
	       offsetofend(zeroed_end) - offsetsof(zeroed_start));

will trigger Fortify compile-time errors from Kees' KSPP tree.

I think we could use

	__struct_group(/* no tag */, zeroed, /* no attrs */,
		u16 gro_remcsum_start;
		...
		u8 is_flist:1;
	);
	__wsum csum;

	BUILD_BUG_ON(sizeof_field(struct napi_gro_cb, zeroed) != sizeof(u32));
	BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
				 sizeof(u32))); /* Avoid slow unaligned acc */

	*(u32 *)&NAPI_GRO_CB(skb)->zeroed = 0;

This doesn't depend on `csum`, doesn't need `struct { }` or
`struct zero[0]` markers and still uses a direct assignment.

Also adding Gustavo, maybe he'd like to leave a comment here.

> 
> Thanks!
> 
> Paolo

Thanks,
Al
