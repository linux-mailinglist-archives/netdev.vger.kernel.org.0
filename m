Return-Path: <netdev+bounces-6189-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 667D57152C9
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 03:03:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AE04280FA8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 425877EC;
	Tue, 30 May 2023 01:03:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F75636
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD7EC433EF;
	Tue, 30 May 2023 01:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685408626;
	bh=kAT5fvEFUD94iWwrqKTiRXR3bJ3UKRVwgwbttql1BuQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bx/Sn96Wn3n2+UjI2VfjVC79eHJ1XKlvr9VEFhenhhxtrY4GoSLjLmD20QVrwI1vp
	 QyjAqHD4U8W+yIrP/5XJvYtKXqmvqWYlApZbdHUqv6jJnOujAK7Qcd3GOtmB7qhkib
	 ufGXB+BB0tdaE2AAg0ieGKc12fyy1SiXXwo0Cp9sQpuyhxSyvBL4ofnFus7hphHEDc
	 8R5x+Dct4eX2uCctzIE6NmwW7LnjSqKjJ+htK8HtiThbYuXIAMOB2Ly+OiZyHzue8P
	 mWjwSO5HJOoZ3+RONj+AoLEycyzcPw0Ga7PdAW+Ke5ZTgKgdbpuF1aP63hHC+dcsw7
	 wrcGCNGDLHYqA==
Date: Mon, 29 May 2023 18:03:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vlad Buslov <vladbu@nvidia.com>
Cc: Peilin Ye <yepeilin.cs@gmail.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
 Pedro Tammela <pctammela@mojatatu.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko
 <jiri@resnulli.us>, Peilin Ye <peilin.ye@bytedance.com>, Daniel Borkmann
 <daniel@iogearbox.net>, "John Fastabend" <john.fastabend@gmail.com>, Hillf
 Danton <hdanton@sina.com>, <netdev@vger.kernel.org>, Cong Wang
 <cong.wang@bytedance.com>
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <20230529180344.3a9c2f35@kernel.org>
In-Reply-To: <87fs7fxov6.fsf@nvidia.com>
References: <cover.1684887977.git.peilin.ye@bytedance.com>
	<429357af094297abbc45f47b8e606f11206df049.1684887977.git.peilin.ye@bytedance.com>
	<faaeb0b0-8538-9dfa-4c1e-8a225e3534f4@mojatatu.com>
	<CAM0EoM=3iYmmLjnifx_FDcJfRbN31tRnCE0ZvqQs5xSBPzaqXQ@mail.gmail.com>
	<CAM0EoM=FS2arxv0__aQXF1a7ViJnM0hST=TL9dcnJpkf-ipjvA@mail.gmail.com>
	<7879f218-c712-e9cc-57ba-665990f5f4c9@mojatatu.com>
	<ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
	<20230526193324.41dfafc8@kernel.org>
	<ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
	<CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
	<87jzwrxrz8.fsf@nvidia.com>
	<87fs7fxov6.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 29 May 2023 15:58:50 +0300 Vlad Buslov wrote:
> If livelock with concurrent filters insertion is an issue, then it can
> be remedied by setting a new Qdisc->flags bit
> "DELETED-REJECT-NEW-FILTERS" and checking for it together with
> QDISC_CLASS_OPS_DOIT_UNLOCKED in order to force any concurrent filter
> insertion coming after the flag is set to synchronize on rtnl lock.

Sounds very nice, yes.

