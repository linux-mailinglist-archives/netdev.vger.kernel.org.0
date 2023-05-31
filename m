Return-Path: <netdev+bounces-6647-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AE597172CC
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 03:00:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C17F628139C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 01:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3B30EBC;
	Wed, 31 May 2023 01:00:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C266EEA4
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 01:00:51 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF255F3
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:00:49 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QW9tF3qH1zTktw;
	Wed, 31 May 2023 09:00:37 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 09:00:46 +0800
Message-ID: <7dd3bd58-1c41-a46d-51f0-d04344542a76@huawei.com>
Date: Wed, 31 May 2023 09:00:46 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net] net: sched: fix NULL pointer dereference in mq_attach
To: Peilin Ye <yepeilin.cs@gmail.com>, Paolo Abeni <pabeni@redhat.com>
CC: Jamal Hadi Salim <jhs@mojatatu.com>, <netdev@vger.kernel.org>,
	<xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <weiyongjun1@huawei.com>,
	<yuehaibing@huawei.com>, <wanghai38@huawei.com>, <peilin.ye@bytedance.com>,
	<cong.wang@bytedance.com>
References: <20230527093747.3583502-1-shaozhengchao@huawei.com>
 <CAM0EoMkrpShprVbWSFN3FpFWtK9494Hyo+mOSNOJmXCFoieN7Q@mail.gmail.com>
 <c135ae5a-37ff-aa89-a3f7-976799181a04@huawei.com>
 <ZHRpfB2NatdM6fHJ@C02FL77VMD6R.googleapis.com>
 <CAM0EoMk+zO0RcnJ4Uie7jU+MNdFz7Mc37W223jVZip62QMRdzQ@mail.gmail.com>
 <ZHVAlCtzFeJrwKvc@C02FL77VMD6R.googleapis.com>
 <9cf98c8ae48c99850a0a25ae7919420ce5dfa7b4.camel@redhat.com>
 <ZHaWa/k/XZ+Jn8s7@C02FL77VMD6R.usts.net>
From: shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <ZHaWa/k/XZ+Jn8s7@C02FL77VMD6R.usts.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/5/31 8:35, Peilin Ye wrote:
> On Tue, May 30, 2023 at 12:16:10PM +0200, Paolo Abeni wrote:
>> Perhaps it would be worthy to add a specific test-case under tc-testing
>> for this issue?
> 
> FYI I've started creating ingress.json tests for the issues fixed in this
> series [1].  Zhengchao, I noticed that you've added a lot of tc-tests
> before, would you like to add another one for this issue you fixed?  Or I
> can do it if you're not going to.
> 
> [1] https://lore.kernel.org/r/cover.1685388545.git.peilin.ye@bytedance.com/
> 
> Thanks,
> Peilin Ye
> 
Hi Peilin:
	Thank you for the notice. I'd like to add the test-case in
another patch.

Zhengchao Shao

