Return-Path: <netdev+bounces-1866-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52D106FF5BC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:21:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F10C28146A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26AB262C;
	Thu, 11 May 2023 15:20:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EFA629
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B049C4339B;
	Thu, 11 May 2023 15:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683818454;
	bh=LlEqzQak7c2TgFwwm3ndbqMEHDmT7FAykIqojK/MUaI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DeYnWczTbjryXUB8lBvhvHWi0u2Rm/cpjy+OQhjGO4NDivP+aEqko9+fC9a49IRTD
	 iHzd80Bck8SR4V5N7RBxfAvGushssgM3AY2IVsYFCrurag+7IIvfkoN7zJtTuUByIM
	 r/M5lCaAGascT2J7/uNiJohBvZUppQhsB2HGRKFZfGzl+nZg6PTEN+YdKJzuaovSGS
	 Qk16NnM3cDQBCsGq28ghEaArT0tDFYrfSLfSHKxdYe86YJ6wMM2+9xAFSaujIOFKoK
	 3R9s2LiF1Cs4cClofYGpRebTh/3KvbG9duNxgWvXOg14n9M0K0FwaSlin1GBYLhf1R
	 qGHwtPD+kMuyw==
Date: Thu, 11 May 2023 08:20:53 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc: Vadim Fedorenko <vadfed@meta.com>, Jiri Pirko <jiri@resnulli.us>,
 Jonathan Lemon <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
 "Olech, Milena" <milena.olech@intel.com>, "Michalik, Michal"
 <michal.michalik@intel.com>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
 <mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, Vadim Fedorenko
 <vadim.fedorenko@linux.dev>
Subject: Re: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Message-ID: <20230511082053.7d2e57e3@kernel.org>
In-Reply-To: <MN2PR11MB46645511A6C93F5C98A8A66F9B749@MN2PR11MB4664.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
	<20230428002009.2948020-2-vadfed@meta.com>
	<ZFOe1sMFtAOwSXuO@nanopsycho>
	<20230504142451.4828bbb5@kernel.org>
	<MN2PR11MB46645511A6C93F5C98A8A66F9B749@MN2PR11MB4664.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 May 2023 07:40:26 +0000 Kubalewski, Arkadiusz wrote:
> >> Remove "no holdover available". This is not a state, this is a mode
> >> configuration. If holdover is or isn't available, is a runtime info.  
> >
> >Agreed, seems a little confusing now. Should we expose the system clk
> >as a pin to be able to force lock to it? Or there's some extra magic
> >at play here?  
> 
> In freerun you cannot lock to anything it, it just uses system clock from
> one of designated chip wires (which is not a part of source pins pool) to feed
> the dpll. Dpll would only stabilize that signal and pass it further.
> Locking itself is some kind of magic, as it usually takes at least ~15 seconds
> before it locks to a signal once it is selected.

Okay, I guess that makes sense.

I was wondering if there may be a DPLLs which allow other input clocks
to bypass the PLL logic, and output purely a stabilized signal. In
which case we should model this as a generic PLL bypass, FREERUN being
just one special case where we're bypassing with the system clock.

But that may well be a case of "software guy thinking", so if nobody
thinks this can happen in practice we can keep FREERUN.

> >Noob question, what is NCO in terms of implementation?
> >We source the signal from an arbitrary pin and FW / driver does
> >the control? Or we always use system refclk and then tune?
> >  
> 
> Documentation of chip we are using, stated NCO as similar to FREERUN, and it
> runs on a SYSTEM CLOCK provided to the chip (plus some stabilization and
> dividers before it reaches the output).
> It doesn't count as an source pin, it uses signal form dedicated wire for
> SYSTEM CLOCK.
> In this case control over output frequency is done by synchronizer chip
> firmware, but still it will not lock to any source pin signal.

Reading wikipedia it sounds like NCO is just a way of generating 
a waveform from synchronous logic.

Does the DPLL not allow changing clock frequency when locked?
I.e. feeding it one frequency and outputting another?
Because I think that'd be done by an NCO, no?

> >> Is it needed to mention the holdover mode. It's slightly confusing,
> >> because user might understand that the lock-status is always "holdover"
> >> in case of "holdover" mode. But it could be "unlocked", can't it?
> >> Perhaps I don't understand the flows there correctly :/  
> >
> >Hm, if we want to make sure that holdover mode must result in holdover
> >state then we need some extra atomicity requirements on the SET
> >operation. To me it seems logical enough that after setting holdover
> >mode we'll end up either in holdover or unlocked status, depending on
> >lock status when request reached the HW.
> >  
> 
> Improved the docs:
>         name: holdover
>         doc: |
>           dpll is in holdover state - lost a valid lock or was forced
>           by selecting DPLL_MODE_HOLDOVER mode (latter possible only
>           when dpll lock-state was already DPLL_LOCK_STATUS_LOCKED,
> 	  if it was not, the dpll's lock-status will remain
>           DPLL_LOCK_STATUS_UNLOCKED even if user requests
>           DPLL_MODE_HOLDOVER)
> Is that better?

Yes, modulo breaking it up into sentences, as Jiri says.

> What extra atomicity you have on your mind?
> Do you suggest to validate and allow (in dpll_netlink.c) only for 'unlocked'
> or 'holdover' states of dpll, once DPLL_MODE_HOLDOVER was successfully
> requested by the user?

No, I was saying that making sure that we end up in holdover (rather
than unlocked) when user requested holdover is hard, and we shouldn't 
even try to implement that.

