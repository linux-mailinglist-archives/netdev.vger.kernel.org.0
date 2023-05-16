Return-Path: <netdev+bounces-3095-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D98817056FC
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:22:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBA3B1C20BBF
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08DFC2910B;
	Tue, 16 May 2023 19:22:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90ECD29101
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2764C433D2;
	Tue, 16 May 2023 19:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684264927;
	bh=FN416ecFDfAW41Eioma/+kx2ZpZ+tyHBV47uheUxRXs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=APe2b3ZFrWdZM7UdAwQ0MwILSkyB25UXxJRNF8mjWhQvWun59gwUzKdUtacMyqOvC
	 51PW874Crl0O2LX7qSCi1yvXAg20UQJkNEiRTlHyZlrvQs2w+scYwP5w+nWAacOo7F
	 QALfmINYvhDOuhYfQvqDYV3QYEdiwsgaP3oixzDqmzupWhnIWWTDowKddrjp8fnKlk
	 RHs1Pmx4/5fymS87iu+6DC6yKD29gQ8NNEs4h/X3wrup0gDwVhU/a25relmFMSJthF
	 Yd8kfHlUnWO4SzUzCmlvonqUgohJkOvmWjL6zD8o4di3iqMXbkEG8K2TSeOPvkS+I0
	 8QRDfaO4jnDrw==
Date: Tue, 16 May 2023 12:22:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vlad Buslov <vladbu@nvidia.com>
Cc: Peilin Ye <yepeilin.cs@gmail.com>, Jiri Pirko <jiri@resnulli.us>, Daniel
 Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jamal
 Hadi Salim <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>, Peilin
 Ye <peilin.ye@bytedance.com>, John Fastabend <john.fastabend@gmail.com>,
 Pedro Tammela <pctammela@mojatatu.com>, Hillf Danton <hdanton@sina.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Cong Wang
 <cong.wang@bytedance.com>
Subject: Re: [PATCH net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <20230516122205.6f198c3e@kernel.org>
In-Reply-To: <ZGK1+3CJOQucl+Jw@C02FL77VMD6R.googleapis.com>
References: <cover.1683326865.git.peilin.ye@bytedance.com>
	<e6c4681dd9205d702ae2e6124e20c6210520e76e.1683326865.git.peilin.ye@bytedance.com>
	<20230508183324.020f3ec7@kernel.org>
	<ZFv6Z7hssZ9snNAw@C02FL77VMD6R.googleapis.com>
	<20230510161559.2767b27a@kernel.org>
	<ZF1SqomxfPNfccrt@C02FL77VMD6R.googleapis.com>
	<20230511162023.3651970b@kernel.org>
	<ZF1+WTqIXfcPAD9Q@C02FL77VMD6R.googleapis.com>
	<ZF2EK3I2GDB5rZsM@C02FL77VMD6R.googleapis.com>
	<ZGK1+3CJOQucl+Jw@C02FL77VMD6R.googleapis.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 May 2023 15:45:15 -0700 Peilin Ye wrote:
> On Thu, May 11, 2023 at 05:11:23PM -0700, Peilin Ye wrote:
> > > You're right, it's in qdisc_create(), argh...  
> >  
> > ->destroy() is called for all error points between ->init() and  
> > dev_graft_qdisc().  I'll try handling it in ->destroy().  
> 
> Sorry for any confusion: there is no point at all undoing "setting dev
> pointer to b1" in ->destroy() because datapath has already been affected.
> 
> To summarize, grafting B mustn't fail after setting dev pointer to b1, so
> ->init() is too early, because e.g. if user requested [1] to create a rate  
> estimator, gen_new_estimator() could fail after ->init() in
> qdisc_create().
> 
> On the other hand, ->attach() is too late because it's later than
> dev_graft_qdisc(), so concurrent filter requests might see uninitialized
> dev pointer in theory.
> 
> Please suggest; is adding another callback (or calling ->attach()) right
> before dev_graft_qdisc() for ingress (clsact) Qdiscs too much for this
> fix?
> 
> [1] e.g. $ tc qdisc add dev eth0 estimator 1s 8s clsact

Vlad, could you please clarify how you expect the unlocked filter
operations to work when the qdisc has global state?

