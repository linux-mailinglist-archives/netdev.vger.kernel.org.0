Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA40B5BA4E7
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 05:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiIPDEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 23:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiIPDEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 23:04:09 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C34B9A68D;
        Thu, 15 Sep 2022 20:04:05 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MTJkv00T8zBsMd;
        Fri, 16 Sep 2022 11:01:58 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 16 Sep
 2022 11:04:02 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <cake@lists.bufferbloat.net>,
        <linux-kselftest@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <toke@toke.dk>, <vinicius.gomes@intel.com>,
        <stephen@networkplumber.org>, <shuah@kernel.org>,
        <victor@mojatatu.com>
CC:     <zhijianx.li@intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next 00/18] refactor duplicate codes in the qdisc class walk function
Date:   Fri, 16 Sep 2022 11:05:26 +0800
Message-ID: <20220916030544.228274-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The walk implementation of most qdisc class modules is basically the
same. That is, the values of count and skip are checked first. If count
is greater than or equal to skip, the registered fn function is
executed. Otherwise, increase the value of count. So the code can be
refactored.

The walk function is invoked during dump. Therefore, test cases related
 to the tdc filter need to be added.

Add test cases locally and perform the test. The test results are listed
below:

./tdc.py -c cake
ok 1 1212 - Create CAKE with default setting
ok 2 3241 - Create CAKE with bandwidth limit
ok 3 c940 - Create CAKE with autorate-ingress flag
ok 4 2310 - Create CAKE with rtt time
ok 5 2385 - Create CAKE with besteffort flag
ok 6 a032 - Create CAKE with diffserv8 flag
ok 7 2349 - Create CAKE with diffserv4 flag
ok 8 8472 - Create CAKE with flowblind flag
ok 9 2341 - Create CAKE with dsthost and nat flag
ok 10 5134 - Create CAKE with wash flag
ok 11 2302 - Create CAKE with flowblind and no-split-gso flag
ok 12 0768 - Create CAKE with dual-srchost and ack-filter flag
ok 13 0238 - Create CAKE with dual-dsthost and ack-filter-aggressive flag
ok 14 6573 - Create CAKE with memlimit and ptm flag
ok 15 2436 - Create CAKE with fwmark and atm flag
ok 16 3984 - Create CAKE with overhead and mpu
ok 17 2342 - Create CAKE with conservative and ingress flag
ok 18 2313 - Change CAKE with mpu
ok 19 4365 - Show CAKE class

./tdc.py -c cbq
ok 1 3460 - Create CBQ with default setting
ok 2 0592 - Create CBQ with mpu
ok 3 4684 - Create CBQ with valid cell num
ok 4 4345 - Create CBQ with invalid cell num
ok 5 4525 - Create CBQ with valid ewma
ok 6 6784 - Create CBQ with invalid ewma
ok 7 5468 - Delete CBQ with handle
ok 8 492a - Show CBQ class

./tdc.py -c cbs
ok 1 1820 - Create CBS with default setting
ok 2 1532 - Create CBS with hicredit setting
ok 3 2078 - Create CBS with locredit setting
ok 4 0482 - Create CBS with sendslope setting
ok 5 e8f3 - Create CBS with multiple setting
ok 6 23c9 - Replace CBS with sendslope setting
ok 7 a07a - Change CBS with idleslope setting
ok 8 43b3 - Delete CBS with handle
ok 9 9472 - Show CBS class

./tdc.py -c drr
ok 1 0385 - Create DRR with default setting
ok 2 2375 - Delete DRR with handle
ok 3 3092 - Show DRR class

./tdc.py -c dsmark
ok 1 6345 - Create DSMARK with default setting
ok 2 3462 - Create DSMARK with default_index setting
ok 3 ca95 - Create DSMARK with set_tc_index flag
ok 4 a950 - Create DSMARK with multiple setting
ok 5 4092 - Delete DSMARK with handle
ok 6 5930 - Show DSMARK class

./tdc.py -c fq_codel
ok 1 4957 - Create FQ_CODEL with default setting
ok 2 7621 - Create FQ_CODEL with limit setting
ok 3 6872 - Create FQ_CODEL with memory_limit setting
ok 4 5636 - Create FQ_CODEL with target setting
ok 5 630a - Create FQ_CODEL with interval setting
ok 6 4324 - Create FQ_CODEL with quantum setting
ok 7 b190 - Create FQ_CODEL with noecn flag
ok 8 c9d2 - Create FQ_CODEL with ce_threshold setting
ok 9 523b - Create FQ_CODEL with multiple setting
ok 10 9283 - Replace FQ_CODEL with noecn setting
ok 11 3459 - Change FQ_CODEL with limit setting
ok 12 0128 - Delete FQ_CODEL with handle
ok 13 0435 - Show FQ_CODEL class

./tdc.py -c hfsc
ok 1 3254 - Create HFSC with default setting
ok 2 0289 - Create HFSC with class sc and ul rate setting
ok 3 846a - Create HFSC with class sc umax and dmax setting
ok 4 5413 - Create HFSC with class rt and ls rate setting
ok 5 9312 - Create HFSC with class rt umax and dmax setting
ok 6 6931 - Delete HFSC with handle
ok 7 8436 - Show HFSC class

./tdc.py -c htb
ok 1 0904 - Create HTB with default setting
ok 2 3906 - Create HTB with default-N setting
ok 3 8492 - Create HTB with r2q setting
ok 4 9502 - Create HTB with direct_qlen setting
ok 5 b924 - Create HTB with class rate and burst setting
ok 6 4359 - Create HTB with class mpu setting
ok 7 9048 - Create HTB with class prio setting
ok 8 4994 - Create HTB with class ceil setting
ok 9 9523 - Create HTB with class cburst setting
ok 10 5353 - Create HTB with class mtu setting
ok 11 346a - Create HTB with class quantum setting
ok 12 303a - Delete HTB with handle

./tdc.py -c mqprio
ok 1 9903 - Add mqprio Qdisc to multi-queue device (8 queues)
ok 2 453a - Delete nonexistent mqprio Qdisc
ok 3 5294 - Delete mqprio Qdisc twice
ok 4 45a9 - Add mqprio Qdisc to single-queue device
ok 5 2ba9 - Show mqprio class

./tdc.py -c multiq
ok 1 20ba - Add multiq Qdisc to multi-queue device (8 queues)
ok 2 9903 - List multiq Class
ok 3 7832 - Delete nonexistent multiq Qdisc
ok 4 2891 - Delete multiq Qdisc twice
ok 5 1329 - Add multiq Qdisc to single-queue device

./tdc.py -c netem
ok 1 cb28 - Create NETEM with default setting
ok 2 a089 - Create NETEM with limit flag
ok 3 3449 - Create NETEM with delay time
ok 4 3782 - Create NETEM with distribution and corrupt flag
ok 5 a932 - Create NETEM with distribution and duplicate flag
ok 6 e01a - Create NETEM with distribution and loss state flag
ok 7 ba29 - Create NETEM with loss gemodel flag
ok 8 0492 - Create NETEM with reorder flag
ok 9 7862 - Create NETEM with rate limit
ok 10 7235 - Create NETEM with multiple slot rate
ok 11 5439 - Create NETEM with multiple slot setting
ok 12 5029 - Change NETEM with loss state
ok 13 3785 - Replace NETEM with delay time
ok 14 4502 - Delete NETEM with handle
ok 15 0785 - Show NETEM class

./tdc.py -c qfq
ok 1 0582 - Create QFQ with default setting
ok 2 c9a3 - Create QFQ with class weight setting
ok 3 8452 - Create QFQ with class maxpkt setting
ok 4 d920 - Create QFQ with multiple class setting
ok 5 0548 - Delete QFQ with handle
ok 6 5901 - Show QFQ class

./tdc.py -e 0521
ok 1 0521 - Show ingress class

./tdc.py -e 1023
ok 1 1023 - Show mq class

./tdc.py -e 2410
ok 1 2410 - Show prio class

./tdc.py -e 290a
ok 1 290a - Show RED class

Zhengchao Shao (18):
  net/sched: sch_api: add helper for tc qdisc walker stats dump
  net/sched: use tc_qdisc_stats_dump() in qdisc
  selftests/tc-testings: add selftests for cake qdisc
  selftests/tc-testings: add selftests for cbq qdisc
  selftests/tc-testings: add selftests for cbs qdisc
  selftests/tc-testings: add selftests for drr qdisc
  selftests/tc-testings: add selftests for dsmark qdisc
  selftests/tc-testings: add selftests for fq_codel qdisc
  selftests/tc-testings: add selftests for hfsc qdisc
  selftests/tc-testings: add selftests for htb qdisc
  selftests/tc-testings: add selftests for mqprio qdisc
  selftests/tc-testings: add selftests for multiq qdisc
  selftests/tc-testings: add selftests for netem qdisc
  selftests/tc-testings: add selftests for qfq qdisc
  selftests/tc-testings: add show class case for ingress qdisc
  selftests/tc-testings: add show class case for mq qdisc
  selftests/tc-testings: add show class case for prio qdisc
  selftests/tc-testings: add show class case for red qdisc

 include/net/pkt_sched.h                       |  13 +
 net/sched/sch_atm.c                           |   6 +-
 net/sched/sch_cake.c                          |   9 +-
 net/sched/sch_cbq.c                           |   9 +-
 net/sched/sch_cbs.c                           |   8 +-
 net/sched/sch_drr.c                           |   9 +-
 net/sched/sch_dsmark.c                        |  14 +-
 net/sched/sch_ets.c                           |   9 +-
 net/sched/sch_fq_codel.c                      |   8 +-
 net/sched/sch_hfsc.c                          |   9 +-
 net/sched/sch_htb.c                           |   9 +-
 net/sched/sch_mq.c                            |   5 +-
 net/sched/sch_mqprio.c                        |   5 +-
 net/sched/sch_multiq.c                        |   9 +-
 net/sched/sch_netem.c                         |   8 +-
 net/sched/sch_prio.c                          |   9 +-
 net/sched/sch_qfq.c                           |   9 +-
 net/sched/sch_red.c                           |   7 +-
 net/sched/sch_sfb.c                           |   7 +-
 net/sched/sch_sfq.c                           |   8 +-
 net/sched/sch_skbprio.c                       |   9 +-
 net/sched/sch_taprio.c                        |   5 +-
 net/sched/sch_tbf.c                           |   7 +-
 .../tc-testing/tc-tests/qdiscs/cake.json      | 488 ++++++++++++++++++
 .../tc-testing/tc-tests/qdiscs/cbq.json       | 184 +++++++
 .../tc-testing/tc-tests/qdiscs/cbs.json       | 234 +++++++++
 .../tc-testing/tc-tests/qdiscs/drr.json       |  71 +++
 .../tc-testing/tc-tests/qdiscs/dsmark.json    | 140 +++++
 .../tc-testing/tc-tests/qdiscs/fq_codel.json  | 326 ++++++++++++
 .../tc-testing/tc-tests/qdiscs/hfsc.json      | 167 ++++++
 .../tc-testing/tc-tests/qdiscs/htb.json       | 285 ++++++++++
 .../tc-testing/tc-tests/qdiscs/ingress.json   |  20 +
 .../tc-testing/tc-tests/qdiscs/mq.json        |  24 +-
 .../tc-testing/tc-tests/qdiscs/mqprio.json    | 114 ++++
 .../tc-testing/tc-tests/qdiscs/multiq.json    | 114 ++++
 .../tc-testing/tc-tests/qdiscs/netem.json     | 372 +++++++++++++
 .../tc-testing/tc-tests/qdiscs/prio.json      |  20 +
 .../tc-testing/tc-tests/qdiscs/qfq.json       | 145 ++++++
 .../tc-testing/tc-tests/qdiscs/red.json       |  23 +
 39 files changed, 2770 insertions(+), 148 deletions(-)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/cake.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbq.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbs.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/drr.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/dsmark.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/hfsc.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/htb.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/mqprio.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/multiq.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/netem.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/qfq.json

-- 
2.17.1

