Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488D421F7D1
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 19:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgGNRDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 13:03:30 -0400
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:28375
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728209AbgGNRDa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 13:03:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pr+sVXQi67S79m6NADYs72RXNEzWOxNvEeW2nihySCOY2aJTMc31P+3CWAtEqaBXlzVa/jwLi01HtIuGi9fzI06ANFDLp/RMGvRLwemZumB3x3a4d3/w8j2gQZ8Q1Bn4gBTf9etApde6DACor5Tmr1TAwefH7nS3ssg44RcvNAuCOHRPdEOWaO5zPZVUsa46skRba5uJcarGFthpwnuK6jh/c7sOFYVeQP2R29Be0liHcoAkT6DKQPXp9uEuX3xlNYsll9hR+weaVvsSGyxo2R1shaLOOeXEzVIymq9lp+jpjgw1BL8DwCriqetWYwrfsu+fpXEgAwcZ0fI7MEqOwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9R+J4b+Bq+X+MEjAuCM+HHchg37kWNRx+M6OAHx0Lg=;
 b=BIQwn5gXx86hdRTbUXhCQBxYX3LNprkvQe6CtUJciokO5+faALfM+ArZ+Ku6HJ7A+mBms8IhRa5BT1ynfaPX6uBtIMpZskOf8blNRtP4wYrJboSysVQ2A4bW+VB1I/3AJrKN8C4/VxXgGkhnlQCvNybwMGTTOiEuclVQi9HlkdVG5mefIk79qsE2p9lOMoaeTZ0oJunbb1a7dqnpG6z/TKYlQu3tDChrCFiRcggLYvmFwjNss+CMRpisRXZ02QRUD7/I33xZFMiJYgTRor29J0GQXMFkFt9kYpvLTB/90044Kj0JrFGne45Uz73+KOD5CA7jfZjwNg5b2XqsTfkdLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9R+J4b+Bq+X+MEjAuCM+HHchg37kWNRx+M6OAHx0Lg=;
 b=t93Xwo5eMoVe4Vpx67jOMxFyib3QQGGN4Lzcbs0aHdq+mjtOXCZzdAame5pX3yjQMJgFKJC4sc4oU5uQ6X7ka/AUDghx1SwKQul+sIeiQL+Q/rsyium/SoMyCy7MZZo7Wcv6rf0vU33TOZ6QukHi3HGvHULrKnSwnU9MuzdOaws=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3420.eurprd05.prod.outlook.com (2603:10a6:7:30::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.23; Tue, 14 Jul 2020 17:03:26 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 17:03:26 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH net-next v3 0/2] net: sched: Do not drop root lock in tcf_qevent_handle()
Date:   Tue, 14 Jul 2020 20:03:06 +0300
Message-Id: <cover.1594746074.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0028.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::15) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by FR2P281CA0028.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9 via Frontend Transport; Tue, 14 Jul 2020 17:03:24 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 71726447-716c-47d5-a3a8-08d82817d2a3
X-MS-TrafficTypeDiagnostic: HE1PR05MB3420:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3420EAFC2034516272779F27DB610@HE1PR05MB3420.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: beHXOprcROYOLlWxZvjQyQr1mhBMlnUwJtp7gkRZi14p0uFGKT4OxY9IwOLPaFAmVxbC4N6eI2AtqnERsl7DBoALwlJSaoPrHKGszrAjfQ0hkhlLdjpNZgUBVd1LO18YB5mMOrKWnRNYeSmUVgX9cRHUF7tmqMXfKdmhiuA6LC06iUXkEIqrdbyPhFKDnGN0iNY24f/FevgIc4aAuQNbFKn7l9vsSo257NJSFTvIwBeUGZcNmMH+uIoFniWxPRanHJkWn9RzSj+47hfevi5+37hHyKxE2/pCuY/NWJoHuRqWvdMWh+hWZJRtEIaGJ3rH5krLZAhanpHV+mZWb2pGeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(136003)(376002)(366004)(346002)(396003)(2616005)(4326008)(86362001)(52116002)(956004)(66946007)(6506007)(478600001)(26005)(66476007)(66556008)(16526019)(6486002)(186003)(316002)(107886003)(5660300002)(2906002)(36756003)(54906003)(8936002)(6916009)(6666004)(6512007)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DAModAiys9lIwoXt0jaNDawVvryCUuRH9h1mxUxXRsDU8rKgyvGtnFqVPN7Pycw83ArvKtvnPqfEdgzUg73bw9eTP/p5t7k1Sv+iNSg6459ruZJ918EjxHP4CfNIntdYJJcC/cMcVRNjUDXCR8RDHQIJgAXihogqlgTxZDraZY9qR12ytEvm2TrlV4yrgHRqWZ5wAUxDIVM1M1TrJ9lch3noKYBnqaLT9N+BkNM6TAltMnQTWEK8FiHr2Jw/JB764/fJBWtnjxs6kmZz+QdGB5ja0JsDXTX9sNu3MwJLUFVpw1VZpUAlE+MLHq7SF72cwQwLrITTZ07+Ml09Py1KTHWKifxP9qN8eGKKchUI5RW5Z78iKBsifRvS03hsc3YSzqlh6gUCNo1Ag2VegS47GPf0sUv8jSxhwNZlRYXJu/bS1RURB9PgJYq7lw8zXp28odj3si6KC2kAatt0eltzQMpZ0J53IXbiVA4xjPFzaUY9pDLtuK3DH3ldo8U/+kuR
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71726447-716c-47d5-a3a8-08d82817d2a3
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 17:03:25.8952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uT4RzdTrXhlfymcr9KPFdsbgjAaLaLBxpsM9HUsOwUdNdK8Pduhk6nva6KS2GUPIRTJHnBAEtP+/pNtCB3UHYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3420
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mirred currently does not mix well with blocks executed after the qdisc
root lock is taken. This includes classification blocks (such as in PRIO,
ETS, DRR qdiscs) and qevents. The locking caused by the packet mirrored by
mirred can cause deadlocks: either when the thread of execution attempts to
take the lock a second time, or when two threads end up waiting on each
other's locks.

The qevent patchset attempted to not introduce further badness of this
sort, and dropped the lock before executing the qevent block. However this
lead to too little locking and races between qdisc configuration and packet
enqueue in the RED qdisc.

Before the deadlock issues are solved in a way that can be applied across
many qdiscs reasonably easily, do for qevents what is done for the
classification blocks and just keep holding the root lock.

That is done in patch #1. Patch #2 then drops the now unnecessary root_lock
argument from Qdisc_ops.enqueue.

v3:
- Patch #2:
    - Add a S-o-b.

v2:
- Patch #2:
    - Turn this into a proper revert. No actual changes.

Petr Machata (2):
  net: sched: Do not drop root lock in tcf_qevent_handle()
  Revert "net: sched: Pass root lock to Qdisc_ops.enqueue"

 include/net/pkt_cls.h     |  4 ++--
 include/net/sch_generic.h |  6 ++----
 net/core/dev.c            |  4 ++--
 net/sched/cls_api.c       |  8 +-------
 net/sched/sch_atm.c       |  4 ++--
 net/sched/sch_blackhole.c |  2 +-
 net/sched/sch_cake.c      |  2 +-
 net/sched/sch_cbq.c       |  4 ++--
 net/sched/sch_cbs.c       | 18 +++++++++---------
 net/sched/sch_choke.c     |  2 +-
 net/sched/sch_codel.c     |  2 +-
 net/sched/sch_drr.c       |  4 ++--
 net/sched/sch_dsmark.c    |  4 ++--
 net/sched/sch_etf.c       |  2 +-
 net/sched/sch_ets.c       |  4 ++--
 net/sched/sch_fifo.c      |  6 +++---
 net/sched/sch_fq.c        |  2 +-
 net/sched/sch_fq_codel.c  |  2 +-
 net/sched/sch_fq_pie.c    |  2 +-
 net/sched/sch_generic.c   |  4 ++--
 net/sched/sch_gred.c      |  2 +-
 net/sched/sch_hfsc.c      |  6 +++---
 net/sched/sch_hhf.c       |  2 +-
 net/sched/sch_htb.c       |  4 ++--
 net/sched/sch_multiq.c    |  4 ++--
 net/sched/sch_netem.c     |  8 ++++----
 net/sched/sch_pie.c       |  2 +-
 net/sched/sch_plug.c      |  2 +-
 net/sched/sch_prio.c      |  6 +++---
 net/sched/sch_qfq.c       |  4 ++--
 net/sched/sch_red.c       | 10 +++++-----
 net/sched/sch_sfb.c       |  4 ++--
 net/sched/sch_sfq.c       |  2 +-
 net/sched/sch_skbprio.c   |  2 +-
 net/sched/sch_taprio.c    |  4 ++--
 net/sched/sch_tbf.c       | 10 +++++-----
 net/sched/sch_teql.c      |  4 ++--
 37 files changed, 77 insertions(+), 85 deletions(-)

-- 
2.20.1

