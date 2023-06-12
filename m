Return-Path: <netdev+bounces-10142-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 624FB72C894
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:31:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3FB02811A2
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:31:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F37646;
	Mon, 12 Jun 2023 14:31:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026271C750
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:31:14 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BCA3AA4;
	Mon, 12 Jun 2023 07:30:47 -0700 (PDT)
Received: from dggpemm500011.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QfvBl0JhgzLptq;
	Mon, 12 Jun 2023 22:26:39 +0800 (CST)
Received: from localhost.huawei.com (10.137.16.203) by
 dggpemm500011.china.huawei.com (7.185.36.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 22:29:42 +0800
From: renmingshuai <renmingshuai@huawei.com>
To: <vladbu@nvidia.com>
CC: <caowangbao@huawei.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<jhs@mojatatu.com>, <jiri@resnulli.us>, <kuba@kernel.org>,
	<liaichun@huawei.com>, <linux-kernel@vger.kernel.org>, <liubo335@huawei.com>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>, <renmingshuai@huawei.com>,
	<xiyou.wangcong@gmail.com>, <yanan@huawei.com>
Subject: Re: [PATCH v2] net/sched: Set the flushing flags to false to prevent an infinite loop and add one test to tdc
Date: Mon, 12 Jun 2023 22:29:14 +0800
Message-ID: <20230612142914.2404237-1-renmingshuai@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <87legswvi3.fsf@nvidia.com>
References: <87legswvi3.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.137.16.203]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>On Fri 09 Jun 2023 at 17:46, renmingshuai <renmingshuai@huawei.com> wrote:
>> When a new chain is added by using tc, one soft lockup alarm will be
>>  generated after delete the prio 0 filter of the chain. To reproduce
>>  the problem, perform the following steps:
>> (1) tc qdisc add dev eth0 root handle 1: htb default 1
>> (2) tc chain add dev eth0
>> (3) tc filter del dev eth0 chain 0 parent 1: prio 0
>> (4) tc filter add dev eth0 chain 0 parent 1:
>>
>>
>> The refcnt of the chain added by step 2 is equal to 1. After step 3,
>>  the flushing flag of the chain is set to true in the tcf_chain_flush()
>>  called by tc_del_tfilter() because the prio is 0. In this case, if
>>  we add a new filter to this chain, it will never succeed and try again
>>  and again because the refresh flash is always true and refcnt is 1.
>>  A soft lock alarm is generated 20 seconds later.
>
>Hi Mingshuai,
>
>Thanks for investigating and reporting this!
>
>> The stack is show as below:
>>
>> Kernel panic - not syncing: softlockup: hung tasks
>> CPU: 2 PID: 3321861 Comm: tc Kdump: loaded Tainted: G
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
>> Call Trace:
>>  <IRQ>
>>  dump_stack+0x57/0x6e
>>  panic+0x196/0x3ec
>>  watchdog_timer_fn.cold+0x16/0x5c
>>  __run_hrtimer+0x5e/0x190
>>  __hrtimer_run_queues+0x8a/0xe0
>>  hrtimer_interrupt+0x110/0x2c0
>>  ? irqtime_account_irq+0x49/0xf0
>>  __sysvec_apic_timer_interrupt+0x5f/0xe0
>>  asm_call_irq_on_stack+0x12/0x20
>>  </IRQ>
>>  sysvec_apic_timer_interrupt+0x72/0x80
>>  asm_sysvec_apic_timer_interrupt+0x12/0x20
>> RIP: 0010:mutex_lock+0x24/0x70
>> RSP: 0018:ffffa836004ab9a8 EFLAGS: 00000246
>> RAX: 0000000000000000 RBX: ffff95bb02d76700 RCX: 0000000000000000
>> RDX: ffff95bb27462100 RSI: 0000000000000000 RDI: ffff95ba5b527000
>> RBP: ffff95ba5b527000 R08: 0000000000000001 R09: ffffa836004abbb8
>> R10: 000000000000000f R11: 0000000000000000 R12: 0000000000000000
>> R13: ffff95ba5b527000 R14: ffffa836004abbb8 R15: 0000000000000001
>>  __tcf_chain_put+0x27/0x200
>>  tc_new_tfilter+0x5e8/0x810
>>  ? tc_setup_cb_add+0x210/0x210
>>  rtnetlink_rcv_msg+0x2e3/0x380
>>  ? rtnl_calcit.isra.0+0x120/0x120
>>  netlink_rcv_skb+0x50/0x100
>>  netlink_unicast+0x12d/0x1d0
>>  netlink_sendmsg+0x286/0x490
>>  sock_sendmsg+0x62/0x70
>>  ____sys_sendmsg+0x24c/0x2c0
>>  ? import_iovec+0x17/0x20
>>  ? sendmsg_copy_msghdr+0x80/0xa0
>>  ___sys_sendmsg+0x75/0xc0
>>  ? do_fault_around+0x118/0x160
>>  ? do_read_fault+0x68/0xf0
>>  ? __handle_mm_fault+0x3f9/0x6f0
>>  __sys_sendmsg+0x59/0xa0
>>  do_syscall_64+0x33/0x40
>>  entry_SYSCALL_64_after_hwframe+0x61/0xc6
>> RIP: 0033:0x7f96705b8247
>> RSP: 002b:00007ffe552e9dc8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f96705b8247
>> RDX: 0000000000000000 RSI: 00007ffe552e9e40 RDI: 0000000000000003
>> RBP: 0000000000000001 R08: 0000000000000001 R09: 0000558113f678b0
>> R10: 00007f967069ab00 R11: 0000000000000246 R12: 00000000647ea089
>> R13: 00007ffe552e9f30 R14: 0000000000000001 R15: 0000558113175f00
>>
>> To avoid this case, set chain->flushing to be false if the chain->refcnt
>>  is 2 after flushing the chain when prio is 0. I also add one test to tdc.
>>
>> Fixes: 726d061286ce ("net: sched: prevent insertion of new classifiers during chain flush")
>> Signed-off-by: Mingshuai Ren <renmingshuai@huawei.com>
>> Reviewed-by: Aichun Li <Liaichun@huawei.com>
>> ---
>> V1 -> V2:
>>   * Correct the judgment on the value chain->refcnt and add one test to tdc
>> ---
>>  net/sched/cls_api.c                           |  7 ++++++
>>  .../tc-testing/tc-tests/infra/filter.json     | 25 +++++++++++++++++++
>>  2 files changed, 32 insertions(+)
>>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/infra/filter.json
>>
>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>> index 2621550bfddc..3ea054e03fbf 100644
>> --- a/net/sched/cls_api.c
>> +++ b/net/sched/cls_api.c
>> @@ -2442,6 +2442,13 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>>  		tfilter_notify_chain(net, skb, block, q, parent, n,
>>  				     chain, RTM_DELTFILTER, extack);
>>  		tcf_chain_flush(chain, rtnl_held);
>> +		/* Set the flushing flags to false to prevent an infinite loop
>> +		 * when a new filter is added.
>> +		 */
>> +		mutex_lock(&chain->filter_chain_lock);
>> +		if (chain->refcnt == 2)
>> +			chain->flushing = false;
>> +		mutex_unlock(&chain->filter_chain_lock);
>
>I don't think this check is enough since there can be concurrent filter
>ops holding the reference to the chain. This just makes the issue harder
>to reproduce.
>
>I'll try to formulate a fix that takes any potential concurrent users
>into account and verify it with your test.

Thanks for your reply.
I didn't find any concurrent scenarios that would "escape" this check.
That's my understanding.
During the flush operation, after filter_chain_lock is obtained, no new chain reference
 could be added. After unlock, chain->flushing is set to true. The chain->refcnt and
 chain->action_refcnt are always different. Therefore, chain->flushing will be never set to false.
 Then there seems to be no concurrency problem until flushing is set to true.
would you mind tell me the concurrent scenario you're talking about?

