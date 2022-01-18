Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC50492C8F
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 18:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347450AbiARRkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 12:40:31 -0500
Received: from mga12.intel.com ([192.55.52.136]:35172 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347431AbiARRka (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jan 2022 12:40:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642527630; x=1674063630;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=scW7dmc1XgQjgAaAfRPfOrJpDb4NFZz+bBYBvska3j8=;
  b=XFaJg2fyeByyUVjtQcHLfyR909PHqvFg/VSY+5nXnq//goCYCjrF3nU3
   TygQyRZEhjjhotO3YagCrP4chPOSuIYeklx3/BMDBJy/UJ698cZHFLr2v
   43p4+vAYPSIO2DRJ1at7pNArWdjVBM+Lq8p6aOvUROVdmBM7qIZbTtKuE
   b5aEKmHAksYJQJ/hC+GjXcUVzB83T7Ihfj5P/ULIyF2M5Gu6VHjsSy6SY
   qsd9mIT8L2lf8wpb3/GPo9uH3W0ONS+Pl8Uyx8zqt3No5tsagzGdvyHk/
   gNCR2KIQgmGaCJEL3EIDvZam99xfW6IRPr6MNB/bCM7sh6pkbKZX2nw+x
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="224850333"
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="224850333"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 09:40:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="595127061"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 18 Jan 2022 09:40:28 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20IHeRSt029313;
        Tue, 18 Jan 2022 17:40:27 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [RFC PATCH 2/3] net: gro: minor optimization for dev_gro_receive()
Date:   Tue, 18 Jan 2022 18:39:03 +0100
Message-Id: <20220118173903.31823-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <c262125543e39d6b869e522da0ed59044eb07722.camel@redhat.com>
References: <cover.1642519257.git.pabeni@redhat.com> <35d722e246b7c4afb6afb03760df6f664db4ef05.1642519257.git.pabeni@redhat.com> <20220118155620.27706-1-alexandr.lobakin@intel.com> <c262125543e39d6b869e522da0ed59044eb07722.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 18 Jan 2022 17:31:00 +0100

> On Tue, 2022-01-18 at 16:56 +0100, Alexander Lobakin wrote:
> > From: Paolo Abeni <pabeni@redhat.com>
> > Date: Tue, 18 Jan 2022 16:24:19 +0100
> > 
> > > While inspecting some perf report, I noticed that the compiler
> > > emits suboptimal code for the napi CB initialization, fetching
> > > and storing multiple times the memory for flags bitfield.
> > > This is with gcc 10.3.1, but I observed the same with older compiler
> > > versions.
> > > 
> > > We can help the compiler to do a nicer work e.g. initially setting
> > > all the bitfield to 0 using an u16 alias. The generated code is quite
> > > smaller, with the same number of conditional
> > > 
> > > Before:
> > > objdump -t net/core/gro.o | grep " F .text"
> > > 0000000000000bb0 l     F .text	0000000000000357 dev_gro_receive
> > > 
> > > After:
> > > 0000000000000bb0 l     F .text	000000000000033c dev_gro_receive
> > > 
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > ---
> > >  include/net/gro.h | 13 +++++++++----
> > >  net/core/gro.c    | 16 +++++-----------
> > >  2 files changed, 14 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/include/net/gro.h b/include/net/gro.h
> > > index 8f75802d50fd..a068b27d341f 100644
> > > --- a/include/net/gro.h
> > > +++ b/include/net/gro.h
> > > @@ -29,14 +29,17 @@ struct napi_gro_cb {
> > >  	/* Number of segments aggregated. */
> > >  	u16	count;
> > >  
> > > -	/* Start offset for remote checksum offload */
> > > -	u16	gro_remcsum_start;
> > > +	/* Used in ipv6_gro_receive() and foo-over-udp */
> > > +	u16	proto;
> > >  
> > >  	/* jiffies when first packet was created/queued */
> > >  	unsigned long age;
> > >  
> > > -	/* Used in ipv6_gro_receive() and foo-over-udp */
> > > -	u16	proto;
> > > +	/* portion of the cb set to zero at every gro iteration */
> > > +	u32	zeroed_start[0];
> > > +
> > > +	/* Start offset for remote checksum offload */
> > > +	u16	gro_remcsum_start;
> > >  
> > >  	/* This is non-zero if the packet may be of the same flow. */
> > >  	u8	same_flow:1;
> > > @@ -70,6 +73,8 @@ struct napi_gro_cb {
> > >  	/* GRO is done by frag_list pointer chaining. */
> > >  	u8	is_flist:1;
> > >  
> > > +	u32	zeroed_end[0];
> > 
> > This should be wrapped in struct_group() I believe, or compilers
> > will start complaining soon. See [0] for the details.
> > Adding Kees to the CCs.
> 
> Thank you for the reference. That really slipped-off my mind.
> 
> This patch does not use memcpy() or similar, just a single direct
> assignement. Would that still require struct_group()?

Oof, sorry, I saw start/end and overlooked that it's only for
a single assignment.
Then it shouldn't cause warnings, but maybe use an anonymous
union instead?

	union {
		u32 zeroed;
		struct {
			u16 gro_remcsum_start;
			...
		};
	};
	__wsum csum;

Use can still use a BUILD_BUG_ON() in this case, like
sizeof(zeroed) != offsetof(csum) - offsetof(zeroed).

> 
> Thanks!
> 
> Paolo

Thanks,
Al
