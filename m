Return-Path: <netdev+bounces-305-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E7EB6F6F8B
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 18:04:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC7AF1C21158
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 16:04:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A6BAA93F;
	Thu,  4 May 2023 16:04:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1187B1855
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 16:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBD1C433D2;
	Thu,  4 May 2023 16:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683216244;
	bh=Ov33ChoosA7Cg6h45OD0WZw1JmTuLbJ584Oy24/tJVw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DR204dEDNKBcZFSP8CNLlrVFA0V5T7uw3kTvqe8VeJNeBbra6huCqOW1gyOnh+d8V
	 xAgCzYQ5VjPQIXOIBNcAi+/bIj5n3LiigembK7raNPr5RL8qISsKu/WRMb2PF7UnS0
	 Ur0ugAfKCQDj3LNtTi7EZ2qTldvPT+Rh7Ss/2MudtXsMuw8Vx+MSbZIXe9aOM0IS8T
	 FVaTTjyje7Xgmzm7SqmJbjc/UtrIv4oIxYY9nC16c1TGKkYx4itmg86WAcAXUSzBhI
	 yCcDl/l8Z2P+TFEBsqIyYsw3ESufSDfm+FFe2vaheFRBMF1pT34Ll6xzGltabAfVNU
	 u8Q1tDHVdFhqg==
Date: Thu, 4 May 2023 09:04:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>, Vadim
 Fedorenko <vadim.fedorenko@linux.dev>, Vadim Fedorenko <vadfed@meta.com>,
 Jonathan Lemon <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
 poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 linux-arm-kernel@lists.infradead.org, "linux-clk@vger.kernel.org"
 <linux-clk@vger.kernel.org>, "Olech, Milena" <milena.olech@intel.com>,
 "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Message-ID: <20230504090401.597a7a61@kernel.org>
In-Reply-To: <ZFOQWmkBUtgVR06R@nanopsycho>
References: <ZBGOWQW+1JFzNsTY@nanopsycho>
	<20230403111812.163b7d1d@kernel.org>
	<ZDJulCXj9H8LH+kl@nanopsycho>
	<20230410153149.602c6bad@kernel.org>
	<ZDwg88x3HS2kd6lY@nanopsycho>
	<20230417124942.4305abfa@kernel.org>
	<ZFDPaXlJainSOqmV@nanopsycho>
	<20230502083244.19543d26@kernel.org>
	<ZFITyWvVcqgRtN+Q@nanopsycho>
	<20230503191643.12a6e559@kernel.org>
	<ZFOQWmkBUtgVR06R@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 May 2023 13:00:42 +0200 Jiri Pirko wrote:
> Thu, May 04, 2023 at 04:16:43AM CEST, kuba@kernel.org wrote:
> >On Wed, 3 May 2023 09:56:57 +0200 Jiri Pirko wrote:  
> >> Okay.
> >> 
> >> When netdev will have pin ID in the RT netlink message (as it is done
> >> in RFCv7), it is easy to get the pin/dpll for netdev. No problem there.
> >> 
> >> However, for non-SyncE usecase, how do you imagine scripts to work?
> >> I mean, the script have to obtain dpll/pin ID by deterministic
> >> module_name/clock_id/idx tuple.  
> >
> >No scoped idx.  
> 
> That means, no index defined by a driver if I undestand you correctly,
> right?

Yes, my suggestion did not include a scoped index with no
globally defined semantics.
 
> >> There are 2 options to do that:
> >> 1) dump all dplls/pins and do lookup in userspace
> >> 2) get a dpll/pin according to given module_name/clock_id/idx tuple
> >> 
> >> The first approach is not very nice.
> >> The currently pushed RFCv7 of the patchset does not support 2)
> >> 
> >> Now if we add support for 2), we basically use module_name/clock_id/idx
> >> as a handle for "get cmd". My point is, why can't we use it for "set
> >> cmd" as well and avoid the ID entirely?  
> >
> >Sure, we don't _have_ to have an ID, but it seems go against normal
> >data normalization rules. And I don't see any harm in it.
> >
> >But you're asking for per-device "idx" and that's a no-go for me,
> >given already cited experience.
> >
> >The user space can look up the ID based on identifying information it
> >has. IMO it's better to support multiple different intelligible elements  
> 
> Do you mean fixed tuple or variable tuple?
> 
> CMD_GET_ID
>   -> DPLL_A_MODULE_NAME  
>      DPLL_A_CLOCK_ID

> What is the next intelligible element to identify DPLL device here?

I don't know. We can always add more as needed.
We presuppose that the devices are identifiable, so whatever info
is used to identify them goes here.

>   <- DPLL_A_ID
> 
> CMD_GET_PIN_ID
>   -> DPLL_A_MODULE_NAME  
>      DPLL_A_CLOCK_ID

> What is the next intelligible element to identify a pin here?

Same answer. Could be a name of the pin according to ASIC docs.
Could be the ball name for a BGA package. Anything that's meaningful.

My point is that we don't want a field simply called "index". Because
then for one vendor it will mean Ethernet port, for another SMA
connector number and for the third pin of the package. Those are
different attributes.

>   <- DPLL_A_PIN_ID
> 
> >than single integer index into which drivers will start encoding all
> >sort of info, using locally invented schemes.  
> 
> There could be multiple DPLL and pin instances for a single
> module/clock_id tuple we have to distinguish somehow. If the driver
> can't pass "index" of DPLL or a pin, how we distinguish them?
> 
> Plus is is possible that 2 driver instances share the same dpll
> instance, then to get the dpll pointer reference, they do:
> INSTANCE A:
> dpll_0 = dpll_device_get(clock_id, 0, THIS_MODULE);
> dpll_1 = dpll_device_get(clock_id, 1, THIS_MODULE);
> 
> INSTANCE B:
> dpll_0 = dpll_device_get(clock_id, 0, THIS_MODULE);
> dpll_1 = dpll_device_get(clock_id, 1, THIS_MODULE);
> 
> My point is, event if we don't expose the index to the userspace,
> we need to have it internally.

That's fine, I guess. I'd prefer driver matching to be the same as user
space matching to force driver authors to have the same perspective as
the user. But a "driver coookie" not visible to user space it probably
fine.

