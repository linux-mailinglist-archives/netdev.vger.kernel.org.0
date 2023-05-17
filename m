Return-Path: <netdev+bounces-3141-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DE62705C07
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 02:39:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3ADD01C20A39
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 00:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5585515BD;
	Wed, 17 May 2023 00:39:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E054D19F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 00:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E527BC433EF;
	Wed, 17 May 2023 00:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684283944;
	bh=Zslh2K+EiuqVbcrhfXH9F3Qcm2xfSzOpQ7kfI0xJDsc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HZ3jKn/4isWeBlgY0+8j3SRSjUdYBNm4ec8PBhTmmnZzG/PqvIiJJ3KCbKdAcSvyi
	 MmhxMHXLd+DpHywy7DkanNFAH+79ZFyYspjN94j25ZzoZlCy2DSEmbu0YCHx5r2bTE
	 abJWlytcrRsVdh9+iTDxq5asQwM6oipzWMyK6NBUbVoJTlTHGitf73iOdiX7MRWtgV
	 xmJ5JMJlReyH+Yq433eJEY3DG5sDFKCeNSL5m2su+sXI+NCRuJBPAIVDyIpio1/bNa
	 FTujAuXnKtOg9QYwyMmOEw9GLYVD1Kv+r34GcqRQLHa0ws7CGLOWZpJDZrLBE6jkGc
	 c5JaDjG5dtS3g==
Date: Tue, 16 May 2023 17:39:02 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Peilin Ye <yepeilin.cs@gmail.com>
Cc: Vlad Buslov <vladbu@nvidia.com>, Jiri Pirko <jiri@resnulli.us>, Daniel
 Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jamal
 Hadi Salim <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>, Peilin
 Ye <peilin.ye@bytedance.com>, John Fastabend <john.fastabend@gmail.com>,
 Pedro Tammela <pctammela@mojatatu.com>, Hillf Danton <hdanton@sina.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Cong Wang
 <cong.wang@bytedance.com>
Subject: Re: [PATCH net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <20230516173902.17745bd2@kernel.org>
In-Reply-To: <ZGQKpuRujwFTyzgJ@C02FL77VMD6R.googleapis.com>
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
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 16 May 2023 15:58:46 -0700 Peilin Ye wrote:
> > Given Peilin's investigation I think fix without changing core may
> > indeed be hard. I'm not sure if returning -EBUSY when qdisc refcnt
> > is elevated will be appreciated by the users, do we already have
> > similar behavior in other parts of TC?  
> 
> Seems like trying to delete an "in-use" cls_u32 filter returns -EBUSY

I meant -EBUSY due to a race (another operation being in flight).
I think that's different.

