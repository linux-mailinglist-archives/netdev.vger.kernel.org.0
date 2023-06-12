Return-Path: <netdev+bounces-10145-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EB3A72C8B1
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:36:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE34B281186
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:36:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFFE917FFE;
	Mon, 12 Jun 2023 14:35:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6F818C17
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:35:58 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C7410DC;
	Mon, 12 Jun 2023 07:35:54 -0700 (PDT)
Received: from dggpemm500011.china.huawei.com (unknown [172.30.72.55])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QfvHj6xGMz18M7Y;
	Mon, 12 Jun 2023 22:30:57 +0800 (CST)
Received: from localhost.huawei.com (10.137.16.203) by
 dggpemm500011.china.huawei.com (7.185.36.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 22:35:51 +0800
From: renmingshuai <renmingshuai@huawei.com>
To: <vladbu@nvidia.com>
CC: <caowangbao@huawei.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<jhs@mojatatu.com>, <jiri@resnulli.us>, <kuba@kernel.org>,
	<liaichun@huawei.com>, <linux-kernel@vger.kernel.org>, <liubo335@huawei.com>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>, <renmingshuai@huawei.com>,
	<xiyou.wangcong@gmail.com>, <yanan@huawei.com>
Subject: Re: [PATCH net] net/sched: cls_api: Fix lockup on flushing explicitly created chain
Date: Mon, 12 Jun 2023 22:35:23 +0800
Message-ID: <20230612143523.2408056-1-renmingshuai@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <87cz20wywo.fsf@nvidia.com>
References: <87cz20wywo.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.137.16.203]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>On Mon 12 Jun 2023 at 10:59, Pedro Tammela <pctammela@mojatatu.com> wrote:
>> On 12/06/2023 06:34, Vlad Buslov wrote:
>>> Mingshuai Ren reports:
>>> When a new chain is added by using tc, one soft lockup alarm will be
>>>   generated after delete the prio 0 filter of the chain. To reproduce
>>>   the problem, perform the following steps:
>>> (1) tc qdisc add dev eth0 root handle 1: htb default 1
>>> (2) tc chain add dev eth0
>>> (3) tc filter del dev eth0 chain 0 parent 1: prio 0
>>> (4) tc filter add dev eth0 chain 0 parent 1:
>>> Fix the issue by accounting for additional reference to chains that are
>>> explicitly created by RTM_NEWCHAIN message as opposed to implicitly by
>>> RTM_NEWTFILTER message.
>>> Fixes: 726d061286ce ("net: sched: prevent insertion of new classifiers during
>>> chain flush")
>>> Reported-by: Mingshuai Ren <renmingshuai@huawei.com>
>>> Closes: https://lore.kernel.org/lkml/87legswvi3.fsf@nvidia.com/T/
>>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>>> ---
>>>   net/sched/cls_api.c | 12 +++++++-----
>>>   1 file changed, 7 insertions(+), 5 deletions(-)
>>
>>
>> Hi Vlad,
>>
>> Thanks for taking a look.
>> Could you also carry over the tdc test or ask Ren to post in a separate patch?
>
>Sure. I was planning to ask Mingshuai Ren to submit the new test as
>standalone patch after my fix has been accepted since including his code
>with my fix would require explicit approval of the whole patch and his
>Signed-off-by clause AFAIK.

OK. I will submit the new test as standalone patch after your fix is been accepted.

