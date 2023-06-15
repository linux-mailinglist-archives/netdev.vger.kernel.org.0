Return-Path: <netdev+bounces-10969-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D81A730DDD
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:04:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F1721C20E24
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 04:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90226639;
	Thu, 15 Jun 2023 04:04:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E588625
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616D2C433C9;
	Thu, 15 Jun 2023 04:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686801871;
	bh=Q/FNH9iBmC0yXrNGJoDHWdnQBtxwDbDGQZRfPYHidMc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aF0cm3Uksskq7y16fdH0d61UL4jwpf0oWFHwWvD2gFdrjSk6npNMywF7npluOPN7u
	 iByH+t7O2/oGIq6wOaGoLWpRyv6cDoy3M0nTiKo9A71HHl8o5Hu43kXHnrMtcHxzF/
	 NLdpTJwvvOsaL7xOF5SplkdOvd2qjNoJ1+QHdg7H0d/s/ZRIx3tywv8j9nKFl+98u/
	 GLXioRRGgW09X7qC/TPnwcVP2f/BkIit/QkJEU7wnneTGYhjwnYtmjh+VroCqmheVs
	 GUDjvZInkgnsGO1PTaqqnhF0VdHEv5zd9QmE64j7e1mgkt9XAY5JrWgD+Cp9IEKYBX
	 fwwIYeSGdejlg==
Date: Wed, 14 Jun 2023 21:04:30 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Edward Cree <ecree.xilinx@gmail.com>
Cc: Martin Habets <habetsm.xilinx@gmail.com>, =?UTF-8?B?w43DsWlnbw==?=
 Huguet <ihuguet@redhat.com>, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-net-drivers@amd.com, Fei
 Liu <feliu@redhat.com>
Subject: Re: [PATCH net] sfc: use budget for TX completions
Message-ID: <20230614210430.60f9512f@kernel.org>
In-Reply-To: <a4e26da4-cb09-7537-60ff-fd00ec4c49d6@gmail.com>
References: <20230612144254.21039-1-ihuguet@redhat.com>
	<ZIl0OYvze+iTehWX@gmail.com>
	<20230614102744.71c91f20@kernel.org>
	<a4e26da4-cb09-7537-60ff-fd00ec4c49d6@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jun 2023 01:36:17 +0100 Edward Cree wrote:
> I think the key question here is can one CPU be using a TXQ to send
>  while another CPU is in a NAPI poll on the same channel and thus
>  trying to clean the EVQ that the TXQ is using.  If so the NAPI poll
>  could last forever; if not then it shouldn't ever have more than 8k
>  (or whatever the TX ring size is set to) events to process.
> And even ignoring affinity of the core TXQs, at the very least XDP
>  TXQs can serve different CPUs to the one on which their EVQ (and
>  hence NAPI poll) lives, which means they can keep filling the EVQ
>  as fast as the NAPI poll empties it, and thus keep ev_process
>  looping forever.
> In principle this can also happen with other kinds of events, e.g.
>  if the MC goes crazy and generates infinite MCDI-event spam then
>  NAPI poll will spin on that CPU forever eating the events.  So
>  maybe this limit needs to be broader than just TX events?  A hard
>  cap on the number of events (regardless of type) that can be
>  consumed in a single efx_ef10_ev_process() invocation, perhaps?

It'd be interesting to analyze the processing time for Tx packets but
with GRO at play the processing time on Rx varies 10x packet to packet.
My intuition is that we should target even amount of time spent on Rx
and Tx, but Tx is cheaper hence higher budget.

The way the wind is blowing I think RT and core folks would prefer 
us to switch to checking the time rather than budgets. Time check
amortized across multiple events, so instead of talking about cap on
events perhaps we should consider how often we should be checking if 
the NAPI time slice has elapsed?

That said I feel like if we try to reshuffle NAPI polling logic
without a real workload to test with we may do more damage than good.

