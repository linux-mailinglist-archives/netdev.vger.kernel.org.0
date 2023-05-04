Return-Path: <netdev+bounces-232-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBDF96F62D2
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 04:16:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 446C01C21060
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 02:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BAABEA6;
	Thu,  4 May 2023 02:16:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269637E
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 02:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD03C4339C;
	Thu,  4 May 2023 02:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683166604;
	bh=PW+c9W1lKkqa0MGUEQOHm4KVa9/uzQUP2DqPlSFoTyA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ar9tY9+a1VSpkevOIpwMLxDvLwe71J3KkyKwwHlbpXI2yPggkJYL4FyRChYZYQRSj
	 YY5lSk4VjkP3rnl8mmQVaSKni6q2RNrrjzzI8HPP3uK8NieR5lUxlkzrlhJ7Kgq8Ps
	 yi3nAfPg1TgQHuZKpJ196ZMZJFt8I8dOvDFUyznn1KNDKB3JfyL4As8qj6JJ0O2Lcy
	 VXtb/Fneb/cPYLrxpxEy3zmxuPjoxO/cmU9CAJdW9DGiQT3PMxL31mjjWXauVh2vNB
	 9wAQP3LOKdFi1co+sgQu3jc69LOfq3tVicNqhGdS/EwWTsdwrUedSQh9ZFq+x5yorx
	 q+a/Lje3EvqVQ==
Date: Wed, 3 May 2023 19:16:43 -0700
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
Message-ID: <20230503191643.12a6e559@kernel.org>
In-Reply-To: <ZFITyWvVcqgRtN+Q@nanopsycho>
References: <ZBA8ofFfKigqZ6M7@nanopsycho>
	<DM6PR11MB4657120805D656A745EF724E9BBE9@DM6PR11MB4657.namprd11.prod.outlook.com>
	<ZBGOWQW+1JFzNsTY@nanopsycho>
	<20230403111812.163b7d1d@kernel.org>
	<ZDJulCXj9H8LH+kl@nanopsycho>
	<20230410153149.602c6bad@kernel.org>
	<ZDwg88x3HS2kd6lY@nanopsycho>
	<20230417124942.4305abfa@kernel.org>
	<ZFDPaXlJainSOqmV@nanopsycho>
	<20230502083244.19543d26@kernel.org>
	<ZFITyWvVcqgRtN+Q@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 3 May 2023 09:56:57 +0200 Jiri Pirko wrote:
> >Yup, non-deterministic, just a cyclic ID allocated by the core starting
> >from 1. Finding the right device / pin needs to be done via
> >informational attributes not making assumptions about the ID.  
> 
> Okay.
> 
> When netdev will have pin ID in the RT netlink message (as it is done
> in RFCv7), it is easy to get the pin/dpll for netdev. No problem there.
> 
> However, for non-SyncE usecase, how do you imagine scripts to work?
> I mean, the script have to obtain dpll/pin ID by deterministic
> module_name/clock_id/idx tuple.

No scoped idx.

> There are 2 options to do that:
> 1) dump all dplls/pins and do lookup in userspace
> 2) get a dpll/pin according to given module_name/clock_id/idx tuple
> 
> The first approach is not very nice.
> The currently pushed RFCv7 of the patchset does not support 2)
> 
> Now if we add support for 2), we basically use module_name/clock_id/idx
> as a handle for "get cmd". My point is, why can't we use it for "set
> cmd" as well and avoid the ID entirely?

Sure, we don't _have_ to have an ID, but it seems go against normal
data normalization rules. And I don't see any harm in it.

But you're asking for per-device "idx" and that's a no-go for me,
given already cited experience.

The user space can look up the ID based on identifying information it
has. IMO it's better to support multiple different intelligible elements
than single integer index into which drivers will start encoding all
sort of info, using locally invented schemes.

