Return-Path: <netdev+bounces-5977-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36F57714193
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 03:10:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAF651C2028E
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 01:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C49C624;
	Mon, 29 May 2023 01:10:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4B37C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 01:10:29 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E87BB
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 18:10:27 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QTy724tQqzLpx1;
	Mon, 29 May 2023 09:07:26 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 29 May 2023 09:10:24 +0800
Message-ID: <c135ae5a-37ff-aa89-a3f7-976799181a04@huawei.com>
Date: Mon, 29 May 2023 09:10:23 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net] net: sched: fix NULL pointer dereference in mq_attach
To: Jamal Hadi Salim <jhs@mojatatu.com>
CC: <netdev@vger.kernel.org>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
	<wanghai38@huawei.com>, Peilin Ye <yepeilin.cs@gmail.com>
References: <20230527093747.3583502-1-shaozhengchao@huawei.com>
 <CAM0EoMkrpShprVbWSFN3FpFWtK9494Hyo+mOSNOJmXCFoieN7Q@mail.gmail.com>
From: shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <CAM0EoMkrpShprVbWSFN3FpFWtK9494Hyo+mOSNOJmXCFoieN7Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/5/29 3:05, Jamal Hadi Salim wrote:
> On Sat, May 27, 2023 at 5:30 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>>
>> When use the following command to test:
>> 1)ip link add bond0 type bond
>> 2)ip link set bond0 up
>> 3)tc qdisc add dev bond0 root handle ffff: mq
>> 4)tc qdisc replace dev bond0 parent ffff:fff1 handle ffff: mq
>>
> 
> This is fixed by Peilin in this ongoing discussion:
> https://lore.kernel.org/netdev/cover.1684887977.git.peilin.ye@bytedance.com/
> 
> cheers,
> jamal
> 
>
Hi jamal:
	Thank you for your reply. I have notice Peilin's patches before,
and test after the patch is incorporated in local host. But it still
triggers the problem.
	Peilin's patches can be filtered out when the query result of
qdisc_lookup is of the ingress type. Here is 4/6 patch in his patches.
+if (q->flags & TCQ_F_INGRESS) {
+	NL_SET_ERR_MSG(extack,
+		       "Cannot regraft ingress or clsact Qdiscs");
+	return -EINVAL;
+}
	However, the query result of my test case in qdisc_lookup is mq.
Therefore, the patch cannot solve my problem.
Thank you.

Zhengchao Shao
> 
>> The kernel reports NULL pointer dereference issue. The stack information
>> is as follows:
>> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
>> Internal error: Oops: 0000000096000006 [#1] SMP
>> Modules linked in:
>> pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> pc : mq_attach+0x44/0xa0
>> lr : qdisc_graft+0x20c/0x5cc
>> sp : ffff80000e2236a0
>> x29: ffff80000e2236a0 x28: ffff0000c0e59d80 x27: ffff0000c0be19c0
>> x26: ffff0000cae3e800 x25: 0000000000000010 x24: 00000000fffffff1
>> x23: 0000000000000000 x22: ffff0000cae3e800 x21: ffff0000c9df4000
>> x20: ffff0000c9df4000 x19: 0000000000000000 x18: ffff80000a934000
>> x17: ffff8000f5b56000 x16: ffff80000bb08000 x15: 0000000000000000
>> x14: 0000000000000000 x13: 6b6b6b6b6b6b6b6b x12: 6b6b6b6b00000001
>> x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
>> x8 : ffff0000c0be0730 x7 : bbbbbbbbbbbbbbbb x6 : 0000000000000008
>> x5 : ffff0000cae3e864 x4 : 0000000000000000 x3 : 0000000000000001
>> x2 : 0000000000000001 x1 : ffff8000090bc23c x0 : 0000000000000000
>> Call trace:
>> mq_attach+0x44/0xa0
>> qdisc_graft+0x20c/0x5cc
>> tc_modify_qdisc+0x1c4/0x664
>> rtnetlink_rcv_msg+0x354/0x440
>> netlink_rcv_skb+0x64/0x144
>> rtnetlink_rcv+0x28/0x34
>> netlink_unicast+0x1e8/0x2a4
>> netlink_sendmsg+0x308/0x4a0
>> sock_sendmsg+0x64/0xac
>> ____sys_sendmsg+0x29c/0x358
>> ___sys_sendmsg+0x90/0xd0
>> __sys_sendmsg+0x7c/0xd0
>> __arm64_sys_sendmsg+0x2c/0x38
>> invoke_syscall+0x54/0x114
>> el0_svc_common.constprop.1+0x90/0x174
>> do_el0_svc+0x3c/0xb0
>> el0_svc+0x24/0xec
>> el0t_64_sync_handler+0x90/0xb4
>> el0t_64_sync+0x174/0x178
>>
>> This is because when mq is added for the first time, qdiscs in mq is set
>> to NULL in mq_attach(). Therefore, when replacing mq after adding mq, we
>> need to initialize qdiscs in the mq before continuing to graft. Otherwise,
>> it will couse NULL pointer dereference issue in mq_attach(). And the same
>> issue will occur in the attach functions of mqprio, taprio and htb.
>> ffff:fff1 means that the repalce qdisc is ingress. Ingress does not allow
>> any qdisc to be attached. Therefore, ffff:fff1 is incorrectly used, and
>> the command should be dropped.
>>
>> Fixes: 6ec1c69a8f64 ("net_sched: add classful multiqueue dummy scheduler")
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>>   net/sched/sch_api.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
>> index fdb8f429333d..dbc9cf5eea89 100644
>> --- a/net/sched/sch_api.c
>> +++ b/net/sched/sch_api.c
>> @@ -1596,6 +1596,10 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
>>                                          NL_SET_ERR_MSG(extack, "Qdisc parent/child loop detected");
>>                                          return -ELOOP;
>>                                  }
>> +                               if (clid == TC_H_INGRESS) {
>> +                                       NL_SET_ERR_MSG(extack, "Ingress cannot graft directly");
>> +                                       return -EINVAL;
>> +                               }
>>                                  qdisc_refcount_inc(q);
>>                                  goto graft;
>>                          } else {
>> --
>> 2.34.1
>>
>>
> 

