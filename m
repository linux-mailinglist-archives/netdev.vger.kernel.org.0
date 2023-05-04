Return-Path: <netdev+bounces-469-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E74296F77FF
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 23:24:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27A261C214BA
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83DDCC13A;
	Thu,  4 May 2023 21:24:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7681156C7
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 21:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328B0C433EF;
	Thu,  4 May 2023 21:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683235492;
	bh=X1R+1Y4dItuazvCe96DQxVN2x4pKiM6Vl4JTO9IYSdg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WACgJMQO9BCbtOy8fzy581sUHqWMeaJhDlCrq6uNAb2LmMVS+N6YVXvhHVlhOOWR8
	 LQ/EsL86Dp8eCWQcCefQieeZ01Ouk68QMTTH7maUVGws7gWNPR5mWzek6hO74rJg+r
	 V8DwbmBIngTLri/203xOYPvYzkiUEWh7qVADQBhxqZTw3f3GdrDHshWCrO2Z/cyta7
	 BziVRB7q0H/ASsV/EaIAb6tybcEXQ0bI/9M0QV9LhwWypC2RO76NS+AQ8BHT4QtAFj
	 J/dXrTv1fRrxlQjzCwV/VB9QjSpLNYdXcn3bowMAmvZ/ycETV1Ah7SKcCNUUb6LXcd
	 xmX+J3SeLjFOw==
Date: Thu, 4 May 2023 14:24:51 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vadim Fedorenko <vadfed@meta.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Arkadiusz Kubalewski
 <arkadiusz.kubalewski@intel.com>, Jonathan Lemon
 <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>, Milena Olech
 <milena.olech@intel.com>, Michal Michalik <michal.michalik@intel.com>,
 linux-arm-kernel@lists.infradead.org, poros@redhat.com,
 mschmidt@redhat.com, netdev@vger.kernel.org, linux-clk@vger.kernel.org,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: Re: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Message-ID: <20230504142451.4828bbb5@kernel.org>
In-Reply-To: <ZFOe1sMFtAOwSXuO@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
	<20230428002009.2948020-2-vadfed@meta.com>
	<ZFOe1sMFtAOwSXuO@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 May 2023 14:02:30 +0200 Jiri Pirko wrote:
> >+definitions:
> >+  -
> >+    type: enum
> >+    name: mode
> >+    doc: |
> >+      working-modes a dpll can support, differentiate if and how dpll selects
> >+      one of its sources to syntonize with it, valid values for DPLL_A_MODE
> >+      attribute
> >+    entries:
> >+      -
> >+        name: unspec  
> 
> In general, why exactly do we need unspec values in enums and CMDs?
> What is the usecase. If there isn't please remove.

+1

> >+        doc: unspecified value
> >+      -
> >+        name: manual

I think the documentation calls this "forced", still.

> >+        doc: source can be only selected by sending a request to dpll
> >+      -
> >+        name: automatic
> >+        doc: highest prio, valid source, auto selected by dpll
> >+      -
> >+        name: holdover
> >+        doc: dpll forced into holdover mode
> >+      -
> >+        name: freerun
> >+        doc: dpll driven on system clk, no holdover available  
> 
> Remove "no holdover available". This is not a state, this is a mode
> configuration. If holdover is or isn't available, is a runtime info.

Agreed, seems a little confusing now. Should we expose the system clk
as a pin to be able to force lock to it? Or there's some extra magic 
at play here?

> >+      -
> >+        name: nco
> >+        doc: dpll driven by Numerically Controlled Oscillator

Noob question, what is NCO in terms of implementation?
We source the signal from an arbitrary pin and FW / driver does 
the control? Or we always use system refclk and then tune?

> >+    render-max: true
> >+  -
> >+    type: enum
> >+    name: lock-status
> >+    doc: |
> >+      provides information of dpll device lock status, valid values for
> >+      DPLL_A_LOCK_STATUS attribute
> >+    entries:
> >+      -
> >+        name: unspec
> >+        doc: unspecified value
> >+      -
> >+        name: unlocked
> >+        doc: |
> >+          dpll was not yet locked to any valid source (or is in one of
> >+          modes: DPLL_MODE_FREERUN, DPLL_MODE_NCO)
> >+      -
> >+        name: calibrating
> >+        doc: dpll is trying to lock to a valid signal
> >+      -
> >+        name: locked
> >+        doc: dpll is locked
> >+      -
> >+        name: holdover
> >+        doc: |
> >+          dpll is in holdover state - lost a valid lock or was forced by
> >+          selecting DPLL_MODE_HOLDOVER mode  
> 
> Is it needed to mention the holdover mode. It's slightly confusing,
> because user might understand that the lock-status is always "holdover"
> in case of "holdover" mode. But it could be "unlocked", can't it?
> Perhaps I don't understand the flows there correctly :/

Hm, if we want to make sure that holdover mode must result in holdover
state then we need some extra atomicity requirements on the SET
operation. To me it seems logical enough that after setting holdover
mode we'll end up either in holdover or unlocked status, depending on
lock status when request reached the HW.

> >+    render-max: true
> >+  -
> >+    type: const
> >+    name: temp-divider
> >+    value: 10
> >+    doc: |
> >+      temperature divider allowing userspace to calculate the
> >+      temperature as float with single digit precision.
> >+      Value of (DPLL_A_TEMP / DPLL_TEMP_DIVIDER) is integer part of
> >+      tempearture value.  
> 
> s/tempearture/temperature/
> 
> Didn't checkpatch warn you?

Also can we give it a more healthy engineering margin?
DPLL_A_TEMP is u32, silicon melts at around 1400C, 
so we really can afford to make the divisor 1000.

> >+    name: device
> >+    subset-of: dpll
> >+    attributes:
> >+      -
> >+        name: id
> >+        type: u32
> >+        value: 2
> >+      -
> >+        name: dev-name
> >+        type: string
> >+      -
> >+        name: bus-name
> >+        type: string
> >+      -
> >+        name: mode
> >+        type: u8
> >+        enum: mode
> >+      -
> >+        name: mode-supported
> >+        type: u8
> >+        enum: mode
> >+        multi-attr: true
> >+      -
> >+        name: lock-status
> >+        type: u8
> >+        enum: lock-status
> >+      -
> >+        name: temp
> >+        type: s32
> >+      -
> >+        name: clock-id
> >+        type: u64
> >+      -
> >+        name: type
> >+        type: u8
> >+        enum: type
> >+      -
> >+        name: pin-prio
> >+        type: u32
> >+        value: 19  
> 
> Do you still need to pass values for a subset? That is odd. Well, I
> think is is odd to pass anything other than names in subset definition,
> the rest of the info is in the original attribute set definition,
> isn't it?
> Jakub?

Probably stale code, related bug was fixed in YNL a few months back.
Explicit value should no longer be needed.

