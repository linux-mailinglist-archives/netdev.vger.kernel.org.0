Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504F4368F8A
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 11:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241755AbhDWJmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 05:42:49 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3343 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhDWJms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 05:42:48 -0400
Received: from DGGEML404-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FRTk25Ljvz19Gmj;
        Fri, 23 Apr 2021 17:38:18 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML404-HUB.china.huawei.com (10.3.17.39) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Fri, 23 Apr 2021 17:42:08 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 23 Apr
 2021 17:42:08 +0800
Subject: Re: [PATCH net v4 1/2] net: sched: fix packet stuck problem for
 lockless qdisc
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <olteanv@gmail.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andriin@fb.com>,
        <edumazet@google.com>, <weiwan@google.com>,
        <cong.wang@bytedance.com>, <ap420073@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <pabeni@redhat.com>, <mzhivich@akamai.com>,
        <johunt@akamai.com>, <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>
References: <1618535809-11952-1-git-send-email-linyunsheng@huawei.com>
 <1618535809-11952-2-git-send-email-linyunsheng@huawei.com>
 <20210419152946.3n7adsd355rfeoda@lion.mk-sys.cz>
 <20210419235503.eo77f6s73a4d25oh@lion.mk-sys.cz>
 <20210420203459.h7top4zogn56oa55@lion.mk-sys.cz>
 <80d64438-e3e5-e861-4da0-f6c89e3c73f7@huawei.com>
 <20210421053123.wdq3kwlvf72kwtch@lion.mk-sys.cz>
 <6a8dea49-3a3e-4172-1d65-5dbcb0125eda@huawei.com>
 <20210421084428.xbjgoi4r2d6t65gy@lion.mk-sys.cz>
 <b3dacf14-0fb6-0cad-8b85-f5c8d7cd97ef@huawei.com>
Message-ID: <a6abb3d8-f857-14e1-4212-a12df36027cf@huawei.com>
Date:   Fri, 23 Apr 2021 17:42:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <b3dacf14-0fb6-0cad-8b85-f5c8d7cd97ef@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme713-chm.china.huawei.com (10.1.199.109) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/21 17:25, Yunsheng Lin wrote:
> On 2021/4/21 16:44, Michal Kubecek wrote:
> 
>>
>> I'll try running some tests also on other architectures, including arm64
>> and s390x (to catch potential endinanity issues).

I tried debugging nperf in arm64, with the below patch:
diff --git a/client/main.c b/client/main.c
index 429634d..de1a3ef 100644
--- a/client/main.c
+++ b/client/main.c
@@ -63,7 +63,10 @@ static int client_init(void)
        ret = client_set_usr1_handler();
        if (ret < 0)
                return ret;
-       return ignore_signal(SIGPIPE);
+       //return ignore_signal(SIGPIPE);
+       signal(SIGPIPE, SIG_IGN);
+
+       return 0;
 }

 static int ctrl_send_start(struct client_config *config)
diff --git a/client/worker.c b/client/worker.c
index ac026893..d269311 100644
--- a/client/worker.c
+++ b/client/worker.c
@@ -7,7 +7,7 @@
 #include "worker.h"
 #include "main.h"

-#define WORKER_STACK_SIZE 16384
+#define WORKER_STACK_SIZE 131072

 struct client_worker_data *workers_data;
 union sockaddr_any test_addr;

It has below error output:

../nperf/nperf -H 127.0.0.1 -l 3 -i 1 --exact -t TCP_STREAM -M 1
server: 127.0.0.1, port 12543
iterations: 1, threads: 1, test length: 3
test: TCP_STREAM, message size: 1048576

run test begin
send begin
send done: -32
failed to receive server stats
*** Iteration 1 failed, quitting. ***


Tcpdump has below output:
09:55:12.253341 IP localhost.53080 > localhost.12543: Flags [S], seq 3954442980, win 65495, options [mss 65495,sackOK,TS val 3268837738 ecr 0,nop,wscale 7], length 0
09:55:12.253363 IP localhost.12543 > localhost.53080: Flags [S.], seq 4240541653, ack 3954442981, win 65483, options [mss 65495,sackOK,TS val 3268837738 ecr 3268837738,nop,wscale 7], length 0
09:55:12.253379 IP localhost.53080 > localhost.12543: Flags [.], ack 1, win 512, options [nop,nop,TS val 3268837738 ecr 3268837738], length 0
09:55:12.253412 IP localhost.53080 > localhost.12543: Flags [P.], seq 1:29, ack 1, win 512, options [nop,nop,TS val 3268837738 ecr 3268837738], length 28
09:55:12.253863 IP localhost.12543 > localhost.53080: Flags [P.], seq 1:17, ack 29, win 512, options [nop,nop,TS val 3268837739 ecr 3268837738], length 16
09:55:12.253891 IP localhost.53080 > localhost.12543: Flags [.], ack 17, win 512, options [nop,nop,TS val 3268837739 ecr 3268837739], length 0
09:55:12.254265 IP localhost.12543 > localhost.53080: Flags [F.], seq 17, ack 29, win 512, options [nop,nop,TS val 3268837739 ecr 3268837739], length 0
09:55:12.301992 IP localhost.53080 > localhost.12543: Flags [.], ack 18, win 512, options [nop,nop,TS val 3268837787 ecr 3268837739], length 0
09:55:15.254389 IP localhost.53080 > localhost.12543: Flags [F.], seq 29, ack 18, win 512, options [nop,nop,TS val 3268840739 ecr 3268837739], length 0
09:55:15.254426 IP localhost.12543 > localhost.53080: Flags [.], ack 30, win 512, options [nop,nop,TS val 3268840739 ecr 3268840739], length 0


Any idea what went wrong here?

Also, Would you mind running netperf to see if there is similar issue
in your system?

>>
>> Michal
>>
>> .
>>
> 
> 
> .
> 

