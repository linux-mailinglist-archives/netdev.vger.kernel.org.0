Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B00B20BCE3
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgFZWqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:46:14 -0400
Received: from mail-eopbgr60081.outbound.protection.outlook.com ([40.107.6.81]:37251
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725836AbgFZWqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 18:46:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cAs/rPW3zDvTksShtmORuB4xWetJwUthM4RycDJpCiIPSFplSEaxHeK8c+6thijXqZ+uarfDTrdsO0kzxzTvkO/uFi0QmYpktOoyeRn568/LYqHoWRRlyWBmLPNpuVayuRiBQHF2IFTTwmoYT0BuETtQEyFVrBYlxQXjIxSqj+8TVGaFZoqNff9ihhdVq2ySu0BsnVo+LWfCbgrln/xOvgaT5ZRRAGU2j58K6o7jbSd7bS1mPj3FPI1y5UwMrEYcRFfK0uFGpxbWgNBcNHdKXn0vRQNhckCArIO7S5SW5W2T/h/+c3h0Q1CyNqHrlv/1TVf0O5ymeWuEuSybk2AJnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cI+ynPAboOdcGTOwCvhAmZXWnHBjynJ3oH4WXjWMiE4=;
 b=h7XM4gj17KbckBtSwZzy6iN7QN/mlACtGcB5Q3Bz6dOQo7LQbLSsJhVzr3YYyqcqPe8iH7ryLrpFPzKvBCVh62zUW4XYn8Q7sHMhxjgIKiiYu9dqGkJrAOQsRqhvnhSHQbLEYtxZE05S7XSM2Qjb6XuigHASf537FfpkCGPNnXVwh1KG7NvPGoIPJFjYaumAP8ZfABOE6mOgW1uaw8R6/ycj+pq1eW55yKTYPK6b1AUwyDiThNEaISShVok9F8kZ1DVqwlZ+AIqn/pIwwtYYkOYBc3TGnIl0PkwryfevASP6VuufEXYHMaOOMuh8c9i1d6KtcF/VO7iHtcO6RnhwAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cI+ynPAboOdcGTOwCvhAmZXWnHBjynJ3oH4WXjWMiE4=;
 b=O3NzCQgyDLTDXDYFimtZje4MPuu6L0f//hME2svWWlj2A3Q92qC4onVfjrT7eRO7Kbjggwq/Z2vZ3MjhqaH8BwLkC87b6kw25ByL2vLkyeQwfDVRoGYsW5p9jeeM6qArw+HscKd4c+Gf2LkoiKtlnCSzLMHwjvYphC0w1b8pKNQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3196.eurprd05.prod.outlook.com (2603:10a6:7:33::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.21; Fri, 26 Jun 2020 22:46:09 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3131.024; Fri, 26 Jun 2020
 22:46:08 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jiri@mellanox.com,
        idosch@mellanox.com, Petr Machata <petrm@mellanox.com>
Subject: [PATCH net-next v1 0/5] TC: Introduce qevents
Date:   Sat, 27 Jun 2020 01:45:24 +0300
Message-Id: <cover.1593209494.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0139.eurprd05.prod.outlook.com
 (2603:10a6:207:3::17) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR05CA0139.eurprd05.prod.outlook.com (2603:10a6:207:3::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Fri, 26 Jun 2020 22:46:07 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 982b26d9-38f4-4498-81ec-08d81a22b798
X-MS-TrafficTypeDiagnostic: HE1PR05MB3196:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB31967DF136B2200F88C3CD02DB930@HE1PR05MB3196.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mTfvyEfCWUqeInlJGmZ8WvEalsHUDQ1Tci68KEjS/fIXghItdzI4kBRajx03kznjnir+UMyTmEKRmcYse0hhiQSTw3xQ9hIO0HQZAF4Z8S31RaWoEqb4vpc14BpSTz6KpiDuE6b2dgfrsfs698u99QkT6CSvHtjCgNbLnoAH+Vpnru4s84Nu5YMoepwVe/EUx+TbhMEELcOvoJrM0TuPZ9SZ4wUKGI4xosW5QPayCcR4jSzCsUW1F4jXwnuuafyu5p1J/nFODBkbISP9gCFKvSwCcPSmGUbn6FPycb4KNQ6bf8HCMAoRoXgCqqo7FLBJ0vKAUfmh4ajEMVbc1A5XVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(5660300002)(66476007)(8676002)(956004)(54906003)(52116002)(2616005)(6666004)(83380400001)(4326008)(6512007)(2906002)(26005)(8936002)(6916009)(107886003)(66556008)(36756003)(478600001)(86362001)(66946007)(186003)(316002)(6486002)(6506007)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BbkU4tNtv6uliKS70uvLpuMWk4hUkgQADbkjHRIclafZrqu4C0fBuJj7vuhS4/v8CJBpAnxvKazxpg4bx8pOguJxrqdPwIcfKkIj/Cp2qdbBhl8oz3P1RriN2ZZmMxvgyrXTBIV/lXa9PkK3eWK09TLegu5ASQTF3Di4YXto6e3M+xBWEUkUll0OK73t+ikqcc1uq8yQSspgtu9u7lynhCwIeVHtZt7OG3YFTCur8Y2c6ZTvv1U7QDeDNR+d9QFfLq5gmVoBtjxUb0bEfG1sLDOfut9bO1sfCoA4GhugVluw8GrCj3+OIy22/V6sipFRmDlGlwEQSI7RpJtcVICXYqksQiXRDrM07eYI8gV3gggzfk79Cb5SyCNr9WWORSzXzON8hJqenPsrinRr2QHmrRkAIcaWExua2LxSQXAjvm7KfZTyP50piDHZutJr5jS2Dl1ztzKCz8opqAhuqvxJOkvzfu2Yurw4ZZKSUn2VOuY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 982b26d9-38f4-4498-81ec-08d81a22b798
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 22:46:08.7059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ftJMQDAVnckhDsV2AB6wJOYar1dljWUFQIsKYFowvidyvvLyyrETXS9OPKDmwcxRfArlQ5Qx2FQF7s0vvf0JhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3196
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Spectrum hardware allows execution of one of several actions as a
result of queue management decisions: tail-dropping, early-dropping,
marking a packet, or passing a configured latency threshold or buffer
size. Such packets can be mirrored, trapped, or sampled.

Modeling the action to be taken as simply a TC action is very attractive,
but it is not obvious where to put these actions. At least with ECN marking
one could imagine a tree of qdiscs and classifiers that effectively
accomplishes this task, albeit in an impractically complex manner. But
there is just no way to match on dropped-ness of a packet, let alone
dropped-ness due to a particular reason.

To allow configuring user-defined actions as a result of inner workings of
a qdisc, this patch set introduces a concept of qevents. Those are attach
points for TC blocks, where filters can be put that are executed as the
packet hits well-defined points in the qdisc algorithms. The attached
blocks can be shared, in a manner similar to clsact ingress and egress
blocks, arbitrary classifiers with arbitrary actions can be put on them,
etc.

For example:

# tc qdisc add dev eth0 root handle 1: \
	red limit 500K avpkt 1K qevent early_drop block 10
# tc filter add block 10 \
	matchall action mirred egress mirror dev eth1

The central patch #2 introduces several helpers to allow easy and uniform
addition of qevents to qdiscs: initialization, destruction, qevent block
number change validation, and qevent handling, i.e. dispatch of the filters
attached to the block bound to a qevent.

Patch #1 adds root_lock argument to qdisc enqueue op. The problem this is
tackling is that if a qevent filter pushes packets to the same qdisc tree
that holds the qevent in the first place, attempt to take qdisc root lock
for the second time will lead to a deadlock. To solve the issue, qevent
handler needs to unlock and relock the root lock around the filter
processing. Passing root_lock around makes it possible to get the lock
where it is needed, and visibly so, such that it is obvious the lock will
be used when invoking a qevent.

The following two patches, #3 and #4, then add two qevents to the RED
qdisc: "early_drop" qevent fires when a packet is early-dropped; "mark"
qevent, when it is ECN-marked.

Patch #5 contains a selftest. I have mentioned this test when pushing the
RED ECN nodrop mode and said that "I have no confidence in its portability
to [...] different configurations". That still holds. The backlog and
packet size are tuned to make the test deterministic. But it is better than
nothing, and on the boxes that I ran it on it does work and shows that
qevents work the way they are supposed to, and that their addition has not
broken the other tested features.

This patch set does not deal with offloading. The idea there is that a
driver will be able to figure out that a given block is used in qevent
context by looking at binder type. A future patch-set will add a qdisc
pointer to struct flow_block_offload, which a driver will be able to
consult to glean the TC or other relevant attributes.

Changes from RFC to v1:
- Move a "q = qdisc_priv(sch)" from patch #3 to patch #4
- Fix deadlock caused by mirroring packet back to the same qdisc tree.
- Rename "tail" qevent to "tail_drop".
- Adapt to the new 100-column standard.
- Add a selftest

Petr Machata (5):
  net: sched: Pass root lock to Qdisc_ops.enqueue
  net: sched: Introduce helpers for qevent blocks
  net: sched: sch_red: Split init and change callbacks
  net: sched: sch_red: Add qevents "early_drop" and "mark"
  selftests: forwarding: Add a RED test for SW datapath

 include/net/flow_offload.h                    |   2 +
 include/net/pkt_cls.h                         |  49 ++
 include/net/sch_generic.h                     |   6 +-
 include/uapi/linux/pkt_sched.h                |   2 +
 net/core/dev.c                                |   4 +-
 net/sched/cls_api.c                           | 119 +++++
 net/sched/sch_atm.c                           |   4 +-
 net/sched/sch_blackhole.c                     |   2 +-
 net/sched/sch_cake.c                          |   2 +-
 net/sched/sch_cbq.c                           |   4 +-
 net/sched/sch_cbs.c                           |  18 +-
 net/sched/sch_choke.c                         |   2 +-
 net/sched/sch_codel.c                         |   2 +-
 net/sched/sch_drr.c                           |   4 +-
 net/sched/sch_dsmark.c                        |   4 +-
 net/sched/sch_etf.c                           |   2 +-
 net/sched/sch_ets.c                           |   4 +-
 net/sched/sch_fifo.c                          |   6 +-
 net/sched/sch_fq.c                            |   2 +-
 net/sched/sch_fq_codel.c                      |   2 +-
 net/sched/sch_fq_pie.c                        |   2 +-
 net/sched/sch_generic.c                       |   4 +-
 net/sched/sch_gred.c                          |   2 +-
 net/sched/sch_hfsc.c                          |   6 +-
 net/sched/sch_hhf.c                           |   2 +-
 net/sched/sch_htb.c                           |   4 +-
 net/sched/sch_multiq.c                        |   4 +-
 net/sched/sch_netem.c                         |   8 +-
 net/sched/sch_pie.c                           |   2 +-
 net/sched/sch_plug.c                          |   2 +-
 net/sched/sch_prio.c                          |   6 +-
 net/sched/sch_qfq.c                           |   4 +-
 net/sched/sch_red.c                           | 102 +++-
 net/sched/sch_sfb.c                           |   4 +-
 net/sched/sch_sfq.c                           |   2 +-
 net/sched/sch_skbprio.c                       |   2 +-
 net/sched/sch_taprio.c                        |   4 +-
 net/sched/sch_tbf.c                           |  10 +-
 net/sched/sch_teql.c                          |   4 +-
 .../selftests/net/forwarding/sch_red.sh       | 492 ++++++++++++++++++
 40 files changed, 822 insertions(+), 84 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/sch_red.sh

-- 
2.20.1

