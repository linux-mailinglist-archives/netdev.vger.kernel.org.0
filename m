Return-Path: <netdev+bounces-5115-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F3DC70FADE
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:55:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC90B2813A6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:55:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8526619BDA;
	Wed, 24 May 2023 15:55:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E03F1951F
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2355C433D2;
	Wed, 24 May 2023 15:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684943708;
	bh=G7hrmYUfR5yH+TUkKZbiSr0+uC7SrwgnrQMWWuggF8w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=spoGVOuViLnttV2DaQj1HeCAivokOPr4vez+lwss4yCnFAXHSG1L5NFqDgGqqhG3+
	 p8tHWJSeJdfUTvGbAvXMvUhE2ojCbSwvV3C+33b6Oz5ZwUg7Tk619Gvi/GfNjk4je3
	 xti1sN0lWvHEB/g4nintWA7dEjC3sj3BcMoIJV0N1XdZnniesluvW5BExm4lxY/0hJ
	 r/vVTMNZVqyYesPfSX3JwWRXd2tetekG2EdlcPU7rFExq9dKBcAR+BvDaQL2nF16Um
	 TBQrJoooyaQi5z8mzgoGk3ZXAoWpl1XbUHA2xn0ZyYo+iTlB2i/yKcKkrTvCOFol9e
	 szF9DkIzscmVw==
Date: Wed, 24 May 2023 08:55:07 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Kurt
 Kanzenbach <kurt.kanzenbach@linutronix.de>, Paolo Abeni
 <pabeni@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 1/2] net: Add sysfs files for threaded NAPI.
Message-ID: <20230524085507.3f38c758@kernel.org>
In-Reply-To: <20230524111259.1323415-2-bigeasy@linutronix.de>
References: <20230524111259.1323415-1-bigeasy@linutronix.de>
	<20230524111259.1323415-2-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 13:12:58 +0200 Sebastian Andrzej Siewior wrote:
> I've been looking into threaded NAPI. One awkward thing to do is
> to figure out the thread names, pids in order to adjust the thread
> priorities and SMP affinity.
> On PREEMPT_RT the NAPI thread is treated (by the user) the same way as
> the threaded interrupt which means a dedicate CPU affinity for the
> thread and a higher task priority to be favoured over other tasks on the
> CPU. Otherwise the NAPI thread can be preempted by other threads leading
> to delays in packet delivery.
> Having to run ps/ grep is awkward to get the PID right. It is not easy
> to match the interrupt since there is no obvious relation between the
> IRQ and the NAPI thread.
> NAPI threads are enabled often to mitigate the problems caused by a
> "pending" ksoftirqd (which has been mitigated recently by doing softiqrs
> regardless of ksoftirqd status). There is still the part that the NAPI
> thread does not use softnet_data::poll_list.

This needs to go to the netdev netlink family, not sysfs.
There's much more information about NAPI to expose and sysfs will
quickly start showing its limitations.

