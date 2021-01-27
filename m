Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47616306591
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 22:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhA0VAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 16:00:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233893AbhA0U7v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 15:59:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E28B64D9A;
        Wed, 27 Jan 2021 20:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611781147;
        bh=eIYqbchM+HXo1X1MSzIptiIE5fGH4nONxFrMSsTR2mM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S6SXdxIqJhU6GN05gEhkI40IpDm7uAA9z6UekBTVAYbu+KZboVtSX5e9R43A46p0r
         jPgy3BtB5UM4F0vPRAi4suxc69hy5RVcASQhJoR61SKccgz7CYL9b5mCB3joGZWNo+
         egXwbHYbXu1tY4x2Oxg+DXeL4ozs/pnu8fr2eesq/4gX8XmgtS75wLVL0gjXUqYnIo
         AlPyVSY6dasPNwuyM1VaK0t5lY2JNq5Zf8B4gPmDLeyRONdIuQ0NnRL36iBy/XjiDV
         uVHySXoonIAxavsq80j74fTc8tMUBQ0ekB5R3Y2w8Vtfai9v/xGBrCSEg8JSlhpqoH
         zo0Pa68oWIU9Q==
Date:   Wed, 27 Jan 2021 12:59:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH RFC net-next] net/sched: act_police: add support for
 packet-per-second policing
Message-ID: <20210127125905.628c0a9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210127110222.GA29081@netronome.com>
References: <20210125151819.8313-1-simon.horman@netronome.com>
        <20210126183812.180d0d61@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210127110222.GA29081@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021 12:02:23 +0100 Simon Horman wrote:
> > > +void psched_ppscfg_precompute(struct psched_pktrate *r,
> > > +			      u64 pktrate64)
> > > +{
> > > +	memset(r, 0, sizeof(*r));
> > > +	r->rate_pkts_ps = pktrate64;
> > > +	r->mult = 1;
> > > +	/* The deal here is to replace a divide by a reciprocal one
> > > +	 * in fast path (a reciprocal divide is a multiply and a shift)
> > > +	 *
> > > +	 * Normal formula would be :
> > > +	 *  time_in_ns = (NSEC_PER_SEC * pkt_num) / pktrate64
> > > +	 *
> > > +	 * We compute mult/shift to use instead :
> > > +	 *  time_in_ns = (len * mult) >> shift;
> > > +	 *
> > > +	 * We try to get the highest possible mult value for accuracy,
> > > +	 * but have to make sure no overflows will ever happen.
> > > +	 */
> > > +	if (r->rate_pkts_ps > 0) {
> > > +		u64 factor = NSEC_PER_SEC;
> > > +
> > > +		for (;;) {
> > > +			r->mult = div64_u64(factor, r->rate_pkts_ps);
> > > +			if (r->mult & (1U << 31) || factor & (1ULL << 63))
> > > +				break;
> > > +			factor <<= 1;
> > > +			r->shift++;  
> > 
> > Aren't there helpers somewhere for the reciprocal divide
> > pre-calculation?  
> 
> Now that you mention it, yes.
> 
> Looking over reciprocal_divide() I don't think it a good fit here as it
> operates on 32bit values, whereas the packet rate is 64 bit.
> 
> Packet rate could be changed to a 32 bit entity if we convince ourselves we
> don't want more than 2^32 - 1 packets per second (a plausible position
> IMHO) - but that leads us to a secondary issue.
> 
> The code above is very similar to an existing (long existing)
> byte rate variant of this helper - psched_ratecfg_precompute().
> And I do think we want to:
> a) Support 64-bit byte rates. Indeed such support seems to have
>    been added to support 25G use-cases
> b) Calculate byte and packet rates the same way
> 
> So I feel less and less that reciprocal_divide() is a good fit.
> But perhaps I am mistaken.
> 
> In the meantime I will take a look to see if a helper common function can
> be made to do (64 bit) reciprocal divides for the packet and byte rate
> use-cases.  I.e. the common code in psched_ppscfg_precompute() and
> psched_ratecfg_precompute().

No strong feelings, I'll just ask to document the reasoning in the
commit message or the comment above.
