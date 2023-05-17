Return-Path: <netdev+bounces-3426-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F406707113
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 20:48:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87EB4281712
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDD7931F06;
	Wed, 17 May 2023 18:48:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709B74420
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 18:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C447C433EF;
	Wed, 17 May 2023 18:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684349287;
	bh=AmPDufIVjIb0VxPo/YFNGszWHrR8ib13WMhB1Zb+HWk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GPJu0owjDbbuXoUWW/tJE2qTjljII0Jbu7BtcAVBMkZhSDqh7YqWMgB+AyDLiiseY
	 N60k8eWZ8VpClfVmUL4s8WhO5mpn8Qghe1Yfg0I2uvmAOl56v6tKSe1OVT9Mu9K4e+
	 5QINQ723OY82vPmDHkGZPthk2o6+i5MT3Xb1oCtB5TvoEPjAytSXm4Icov3JliheyY
	 /s58PLEcgzucjFbWRWzO/5d26G344J316XUnQehVc69BkpeoyVwxeLwInKIk/4OtfJ
	 WLTu4YXCE4DgYPUFNxXNaP/RwTvwea7PA/rXSrHYG6Yaf10Q55TH74Rjw7X6BbPfIS
	 PG5zD3BNASwoQ==
Date: Wed, 17 May 2023 11:48:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vlad Buslov <vladbu@nvidia.com>
Cc: Peilin Ye <yepeilin.cs@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
 "Daniel Borkmann" <daniel@iogearbox.net>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, "Jamal Hadi Salim" <jhs@mojatatu.com>, Cong Wang
 <xiyou.wangcong@gmail.com>, "Peilin Ye" <peilin.ye@bytedance.com>, John
 Fastabend <john.fastabend@gmail.com>, Pedro Tammela
 <pctammela@mojatatu.com>, Hillf Danton <hdanton@sina.com>,
 <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Cong Wang
 <cong.wang@bytedance.com>
Subject: Re: [PATCH net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <20230517114805.29e9bdca@kernel.org>
In-Reply-To: <87ttwbjq6y.fsf@nvidia.com>
References: <ZFv6Z7hssZ9snNAw@C02FL77VMD6R.googleapis.com>
	<20230510161559.2767b27a@kernel.org>
	<ZF1SqomxfPNfccrt@C02FL77VMD6R.googleapis.com>
	<20230511162023.3651970b@kernel.org>
	<ZF1+WTqIXfcPAD9Q@C02FL77VMD6R.googleapis.com>
	<ZF2EK3I2GDB5rZsM@C02FL77VMD6R.googleapis.com>
	<ZGK1+3CJOQucl+Jw@C02FL77VMD6R.googleapis.com>
	<20230516122205.6f198c3e@kernel.org>
	<87y1lojbus.fsf@nvidia.com>
	<20230516145010.67a7fa67@kernel.org>
	<ZGQKpuRujwFTyzgJ@C02FL77VMD6R.googleapis.com>
	<20230516173902.17745bd2@kernel.org>
	<87ttwbjq6y.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 May 2023 11:49:10 +0300 Vlad Buslov wrote:
> On Tue 16 May 2023 at 17:39, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 16 May 2023 15:58:46 -0700 Peilin Ye wrote:  
> >> 
> >> Seems like trying to delete an "in-use" cls_u32 filter returns -EBUSY  
> >
> > I meant -EBUSY due to a race (another operation being in flight).
> > I think that's different.  
> 
> I wonder if somehow leveraging existing tc_modify_qdisc() 'replay'
> functionality instead of returning error to the user would be a better
> approach? Currently the function is replayed when qdisc_create() returns
> EAGAIN. It should be trivial to do the same for qdisc_graft() result.

Sounds better than returning -EBUSY to the user and expecting them 
to retry, yes.

