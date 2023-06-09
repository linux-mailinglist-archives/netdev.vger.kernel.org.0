Return-Path: <netdev+bounces-9428-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ABD6728E92
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 05:31:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E2B41C20FA5
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 03:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 631EF1C10;
	Fri,  9 Jun 2023 03:31:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1BC1879
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 03:31:46 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5A930FE;
	Thu,  8 Jun 2023 20:31:42 -0700 (PDT)
Received: from dggpemm500011.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Qcmlc1ChSzkXMB;
	Fri,  9 Jun 2023 11:29:16 +0800 (CST)
Received: from localhost.huawei.com (10.137.16.203) by
 dggpemm500011.china.huawei.com (7.185.36.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 11:31:38 +0800
From: renmingshuai <renmingshuai@huawei.com>
To: <pctammela@mojatatu.com>
CC: <caowangbao@huawei.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<jhs@mojatatu.com>, <jiri@resnulli.us>, <kuba@kernel.org>,
	<liaichun@huawei.com>, <linux-kernel@vger.kernel.org>, <liubo335@huawei.com>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>, <renmingshuai@huawei.com>,
	<xiyou.wangcong@gmail.com>, <yanan@huawei.com>
Subject: [PATCH v3] net/sched: Set the flushing flags to false to prevent an infinite loop and add one test to tdc
Date: Fri, 9 Jun 2023 11:31:15 +0800
Message-ID: <20230609033115.3738692-1-renmingshuai@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <91e6a8cd-2775-d759-4462-b1be7dc79bbe@mojatatu.com>
References: <91e6a8cd-2775-d759-4462-b1be7dc79bbe@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.137.16.203]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>On 08/06/2023 09:32, renmingshuai wrote:
>>> On 07/06/2023 01:19, renmingshuai wrote:
>>>>> On 06/06/2023 11:45, renmingshuai wrote:
>>>>>> When a new chain is added by using tc, one soft lockup alarm will
>>>>>> be
>>>>>>     generated after delete the prio 0 filter of the chain. To
>>>>>>     reproduce
>>>>>>     the problem, perform the following steps:
>>>>>> (1) tc qdisc add dev eth0 root handle 1: htb default 1
>>>>>> (2) tc chain add dev eth0
>>>>>> (3) tc filter del dev eth0 chain 0 parent 1: prio 0
>>>>>> (4) tc filter add dev eth0 chain 0 parent 1:
>>>>>
>>>>> This seems like it could be added to tdc or 3 and 4 must be run in
>>>>> parallel?
>>>> 3 and 4 do not need to be run inparallel. When a new chain is added
>>>> by the
>>>>    way as step 1 and the step 3 is completed, this problem always
>>>>    occurs
>>>>    whenever step 4 is run.
>>>
>>> Got it,
>>> The test still hangs with the provided patch.
>>>
>>> + tc qdisc add dev lo root handle 1: htb default 1
>>> + tc chain add dev lo
>>> + tc filter del dev lo chain 0 parent 1: prio 0
>>> [   68.790030][ T6704] [+]
>>> [   68.790060][ T6704] chain refcnt 2
>>> [   68.790951][ T6704] [-]
>>> + tc filter add dev lo chain 0 parent 1:
>>> <hangs>
>>>
>>> Also please add this test to tdc, it should be straightforward.
>>>
>> Sorry for not testing before. I forgot that the chain->refcnt was
>> increased by 1 when tcf_chain_get() is called in tc_del_tfilter().
>>   The value of chain->refcnt is 2 after chain flush. The test
>>   result is as follows:
>> [root@localhost ~]# tc qdisc add dev eth2 root handle 1: htb default 1
>> [root@localhost ~]# tc chain add dev eth2
>> [root@localhost ~]# tc filter del dev eth2 chain 0 parent 1: prio 0
>> [root@localhost ~]# tc filter add dev eth2 chain 0 parent 1:
>> Error: Filter kind and protocol must be specified.
>> We have an error talking to the kernel
>> 
>> And I have add this test to tdc:
>> [root@localhost tc-testing]# ./tdc.py -f tc-tests/filters/tests.json
>> ok 7 c2b4 - Adding a new fiter after deleting a filter in a chain does
>> not cause  an infinite loop
>> 
>> Fixes: 726d061286ce ("net: sched: prevent insertion of new classifiers during chain flush")
>> Signed-off-by: renmingshuai <renmingshuai@huawei.com>
>
>Please respin with the following applied:
>
>diff --git 
>a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json 
>b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
>index c759c3db9a37..361235ad574b 100644
>--- a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
>+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
>@@ -125,25 +125,5 @@
>          "teardown": [
>              "$TC qdisc del dev $DEV2 ingress"
>          ]
>-    },
>-    {
>-        "id": "c2b4",
>-        "name": "Adding a new fiter after deleting a filter in a chain 
>does not cause an infinite loop",
>-        "category": [
>-            "filter",
>-            "prio"
>-        ],
>-        "setup": [
>-            "$TC qdisc add dev $DEV1 root handle 1: htb default 1",
>-            "$TC chain add dev $DEV1"
>-        ],
>-        "cmdUnderTest": "$TC filter del dev $DEV1 chain 0 parent 1: 
>prio 0",
>-        "expExitCode": "0",
>-        "verifyCmd": "$TC filter add dev $DEV1 chain 0 parent 1:",
>-        "matchPattern": "Error: Filter kind and protocol must be 
>specified.",
>-        "matchCount": "1",
>-        "teardown": [
>-            "$TC qdisc del dev $DEV1 root handle 1: htb default 1"
>-        ]
>      }
>  ]
>diff --git 
>a/tools/testing/selftests/tc-testing/tc-tests/infra/filters.json 
>b/tools/testing/selftests/tc-testing/tc-tests/infra/filters.
>json
>new file mode 100644
>index 000000000000..55d6f209c388
>--- /dev/null
>+++ b/tools/testing/selftests/tc-testing/tc-tests/infra/filters.json
>@@ -0,0 +1,24 @@
>+[
>+    {
>+        "id": "c2b4",
>+        "name": "Adding a new filter after flushing empty chain doesnt 
>cause an infinite loop",
>+        "category": [
>+            "filter",
>+            "chain"
>+        ],
>+        "setup": [
>+            "$IP link add dev $DUMMY type dummy || /bin/true",
>+            "$TC qdisc add dev $DUMMY root handle 1: htb default 1",
>+            "$TC chain add dev $DUMMY",
>+            "$TC filter del dev $DUMMY chain 0 parent 1: prio 0"
>+        ],
>+        "cmdUnderTest": "$TC filter add dev $DUMMY chain 0 parent 1:",
>+        "expExitCode": "2",
>+        "verifyCmd": "$TC chain ls dev $DUMMY",
>+        "matchPattern": "chain parent 1: chain 0",
>+        "matchCount": "1",
>+        "teardown": [
>+            "$TC qdisc del dev $DUMMY root handle 1: htb default 1"
>+        ]
>+    }
>+]

Ok. The new test is passed.
[root@localhost tc-testing]# ./tdc.py -f tc-tests/infra/filter.json
Test c2b4: Adding a new filter after flushing empty chain doesn't cause an infinite loop
All test results:
1..1
ok 1 c2b4 - Adding a new filter after flushing empty chain doesn't cause an infinite loop

Fixes: 726d061286ce ("net: sched: prevent insertion of new classifiers during chain flush")
Signed-off-by: renmingshuai <renmingshuai@huawei.com>
---
 net/sched/cls_api.c                           |  7 ++++++
 .../tc-testing/tc-tests/infra/filter.json     | 25 +++++++++++++++++++
 2 files changed, 32 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/infra/filter.json

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2621550bfddc..3ea054e03fbf 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2442,6 +2442,13 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 		tfilter_notify_chain(net, skb, block, q, parent, n,
 				     chain, RTM_DELTFILTER, extack);
 		tcf_chain_flush(chain, rtnl_held);
+		/* Set the flushing flags to false to prevent an infinite loop
+		 * when a new filter is added.
+		 */
+		mutex_lock(&chain->filter_chain_lock);
+		if (chain->refcnt == 2)
+			chain->flushing = false;
+		mutex_unlock(&chain->filter_chain_lock);
 		err = 0;
 		goto errout;
 	}
diff --git a/tools/testing/selftests/tc-testing/tc-tests/infra/filter.json b/tools/testing/selftests/tc-testing/tc-tests/infra/filter.json
new file mode 100644
index 000000000000..db3b42aaa4fa
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/infra/filter.json
@@ -0,0 +1,25 @@
+[
+    {
+        "id": "c2b4",
+        "name": "Adding a new filter after flushing empty chain doesn't cause an infinite loop",
+        "category": [
+            "filter",
+            "chain"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY root handle 1: htb default 1",
+            "$TC chain add dev $DUMMY",
+            "$TC filter del dev $DUMMY chain 0 parent 1: prio 0"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY chain 0 parent 1:",
+        "expExitCode": "2",
+        "verifyCmd": "$TC chain ls dev $DUMMY",
+        "matchPattern": "chain parent 1: chain 0",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY root handle 1: htb default 1",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    }
+]
-- 
2.27.0


