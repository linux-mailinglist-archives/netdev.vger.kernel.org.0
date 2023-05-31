Return-Path: <netdev+bounces-6871-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B8D67187E9
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:01:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A739281562
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 362C617ADE;
	Wed, 31 May 2023 17:01:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB19514294
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 17:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E64C433EF;
	Wed, 31 May 2023 17:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685552487;
	bh=R7oOfdc1inXuLFb7cvDfmpI9BDI+dIPISRXuyEXNPvI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nzXesSLuaVO21WqMnqz6lZZkzoywNGhofB7+9w1885IbEkRQVdEWM4KHKSlR5VeUh
	 M1oBkZNiQGdN1h8nckTf1NxFC3vEjGc6N32U6OdnysH2ezKUhvfU9dHAiWYQUxAxex
	 WVTatdhX+KX4UwjwD/vqK4+X7h5HBPNS1RIxDrpnYQ/VJCIj3F/ohGcmWgMCB8Z0ap
	 C/rkGpAIcR+Z2RmiacrR6Gpe6lS8JClUDWzQqMfOPfJoTnNVyZ5O6uWArZkmi3n+7K
	 qHOB95TfohHPO3YPOggEcTQSlih2+d9rrUypXZhA2qeQ1Bpo+XPuXADSYesRboGN6O
	 xrtRBlkZ4pY7Q==
Date: Wed, 31 May 2023 10:01:25 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Yury Norov <yury.norov@gmail.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>, Pawel
 Chmielewski <pawel.chmielewski@intel.com>, Leon Romanovsky
 <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, Rasmus Villemoes
 <linux@rasmusvillemoes.dk>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel
 Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>,
 Valentin Schneider <vschneid@redhat.com>, Tariq Toukan <tariqt@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Heiko Carstens <hca@linux.ibm.com>, Barry
 Song <baohua@kernel.org>
Subject: Re: [PATCH v2 0/8] sched/topology: add for_each_numa_cpu() macro
Message-ID: <20230531100125.39d73e1d@kernel.org>
In-Reply-To: <ZHdrMiVSrPdM3xGn@yury-ThinkPad>
References: <20230430171809.124686-1-yury.norov@gmail.com>
	<ZHdrMiVSrPdM3xGn@yury-ThinkPad>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 31 May 2023 08:43:46 -0700 Yury Norov wrote:
> On Sun, Apr 30, 2023 at 10:18:01AM -0700, Yury Norov wrote:
> > for_each_cpu() is widely used in kernel, and it's beneficial to create
> > a NUMA-aware version of the macro.
> > 
> > Recently added for_each_numa_hop_mask() works, but switching existing
> > codebase to it is not an easy process.
> > 
> > This series adds for_each_numa_cpu(), which is designed to be similar to
> > the for_each_cpu(). It allows to convert existing code to NUMA-aware as
> > simple as adding a hop iterator variable and passing it inside new macro.
> > for_each_numa_cpu() takes care of the rest.  
> 
> Hi Jakub,
> 
> Now that the series reviewed, can you consider taking it in sched
> tree?

Do you mean someone else or did you mean the net-next tree?

