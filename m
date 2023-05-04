Return-Path: <netdev+bounces-335-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35C196F7213
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:44:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 229351C21254
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 18:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9892FBE77;
	Thu,  4 May 2023 18:44:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59D5BE65
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 18:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BD8C433EF;
	Thu,  4 May 2023 18:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683225862;
	bh=AXfZhTl4CAMvddsRCT4gxAh0YyM5asyL2fZDOM7392g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WKzVy8mPC9n4w3mgqz2/js9aYICqzA/fx0l7jqU1fyyLMgzs58E4YbmFonjUjLpAX
	 RXe/3eLky0H5Cs0KIvtPPR4oo9oZFLtMP7VzzqlgILoNr0H2qmTSzvGt1ppUb8WXr6
	 nzHs/4eUk/xNEyKwRTA1WLVx8BAC0Rlayl7S7ihPDjVy8OVRFvmobPBGitk7/zVHMy
	 JZ3pT8ZfhY8xRAoptCgeuCh2IExIbvSmgtu1XW8UlUzsBGyI+lLw2IiWMzETsybIkC
	 7XTawLFp+29cXqL60yUsacTMnt3qHf3kvV7xZXF/96ookU4ADuzOBi+xXvGvta0vN5
	 /HvEpodh8j7sQ==
Date: Thu, 4 May 2023 11:44:21 -0700
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
Message-ID: <20230504114421.51415018@kernel.org>
In-Reply-To: <ZFPwqu5W8NE6Luvk@nanopsycho>
References: <ZDJulCXj9H8LH+kl@nanopsycho>
	<20230410153149.602c6bad@kernel.org>
	<ZDwg88x3HS2kd6lY@nanopsycho>
	<20230417124942.4305abfa@kernel.org>
	<ZFDPaXlJainSOqmV@nanopsycho>
	<20230502083244.19543d26@kernel.org>
	<ZFITyWvVcqgRtN+Q@nanopsycho>
	<20230503191643.12a6e559@kernel.org>
	<ZFOQWmkBUtgVR06R@nanopsycho>
	<20230504090401.597a7a61@kernel.org>
	<ZFPwqu5W8NE6Luvk@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 May 2023 19:51:38 +0200 Jiri Pirko wrote:
> >> What is the next intelligible element to identify DPLL device here?  
> >
> >I don't know. We can always add more as needed.
> >We presuppose that the devices are identifiable, so whatever info
> >is used to identify them goes here.  
> 
> Allright. So in case of ptp_ocp and mlx5, module_name and clock_id
> are enough. In case of ice, DPLL_A_TYPE, attr is the one to make
> distinction between the 2 dpll instances there
> 
> So for now, we can have:
>  CMD_GET_ID
>    -> DPLL_A_MODULE_NAME  
>       DPLL_A_CLOCK_ID
>       DPLL_A_TYPE
>    <- DPLL_A_ID
> 
> 
> if user passes a subset which would not provide a single match, we error
> out with -EINVAL and proper exack message. Makes sense?

Yup, that sounds good to me.

> >Same answer. Could be a name of the pin according to ASIC docs.
> >Could be the ball name for a BGA package. Anything that's meaningful.  
> 
> Okay, for pin, the type and label would probably do:
>  CMD_GET_PIN_ID
>    -> DPLL_A_MODULE_NAME  
>       DPLL_A_CLOCK_ID
>       DPLL_A_PIN_TYPE
>       DPLL_A_PIN_LABEL

Label sounds dangerously open ended, too. Would that be the SMA
connector label (i.e. front panel label)? Or also applicable to
internal pins? It'd be easier to talk details if we had the user
facing documentation that ships with these products.

>    <- DPLL_A_PIN_ID
> 
> Again, if user passes a subset which would not provide a single match,
> we error out with -EINVAL and proper exack message.
> 
> If there is only one pin for example, user query of DPLL_A_MODULE_NAME
> and DPLL_A_CLOCK_ID would do return a single match. No need to pass
> anything else.
> 
> I think this could work with both ice and ptp_ocp, correct guys?
> 
> For mlx5, I will have 2 or more pins with same module name, clock id
> and type. For these SyncE pins the label does not really make sense.
> But I don't have to query, because the PIN_ID is going to be exposed for
> netdev over RT netlink. Clicks.
> 
> Makes sense?

