Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4FB21F2AA
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgGNNdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:33:46 -0400
Received: from mail-eopbgr80070.outbound.protection.outlook.com ([40.107.8.70]:57103
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726935AbgGNNdq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 09:33:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRwaS9MqGxJqpALaOn6w2XpMrYf6SVR4QHPYpPPsO4wuXoBVWzPTkk20+lG/i+wTow4bS0L9WNObm1G4iFIZAOaZG/mb4QFGJ9sI7WikaHUEkPFfI/Rp268c+YQBvxokee+KAey5tLayilZfBLQ96OOqa7wGpLrlrphmxsd3PJNNAIZIuemSJeZp0MnbuySKeDd3lxpVRDblSd0mNE+9G4V6HfPylmbrEnRtFQL93E9wlayfra800QUxqaHgweQQ4QlFmRR9JDOfgLd/WE+YnA6uYd6YKNHbtjqW0vGF2gXUAXAipIYeQnRDeOyPfsJ3DJpaa/rkygQPRAd3I6wu0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3q7H5DhfiPhZK4xJp01PX4rkODrxIVfnZOL8uoWJJM=;
 b=QY/05cewA3y7Fb/9TPuF5Eq/9jtkIDxhkjZnFhMRWZ+Y2baTjtD02xaavIrA8JsZuT62x5NaJGOpHBYuS1Fwgi+r5Pl1gN/DyuaRkgmaCL0Q7HNf4X/hG2dG8zLKsKO3x3OSTG/efK4Cb1rcf+rSFyP7OSBROpYm6O3WKq8cRYZJnAG9+RAZ9WjzwiHQVGnK+bzLEFuY7bXur+o0hJ4z5QR93QlPg46F3EcjkmS6SFpxjJeJm6x/P2pLwsL9sXLYolpzCHQ+XqmHGS2/BaQ4QNRnrTrmReYGXwzxIqxR0fe13JNHoRYiJp+9zNKqNtTrd3BPu1M5GHTJjm6XZ6ki+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3q7H5DhfiPhZK4xJp01PX4rkODrxIVfnZOL8uoWJJM=;
 b=bTFVXHilnJORvCQC9KEO1EDlCX4ylQXSYPB980NyrSocgpu43mey+JIuqKyJYSgXtGQMUnpWwVxHlSxIArbI8teNkyfcq2aJKzPr+zHtSq/yQmY/vo6orifyaE9tPQREkrCLCrxxmlLbTE4MRzjTchVenWFtZJyNB2FCWw8yJlQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0502MB3116.eurprd05.prod.outlook.com (2603:10a6:3:da::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.22; Tue, 14 Jul 2020 13:33:42 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 13:33:42 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH net-next 0/2] net: sched: Do not drop root lock in tcf_qevent_handle()
Date:   Tue, 14 Jul 2020 16:32:53 +0300
Message-Id: <cover.1594732978.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0020.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::30) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM4PR0902CA0020.eurprd09.prod.outlook.com (2603:10a6:200:9b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Tue, 14 Jul 2020 13:33:41 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 022ad275-71d0-4302-beaa-08d827fa865a
X-MS-TrafficTypeDiagnostic: HE1PR0502MB3116:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0502MB3116803D0908D890BBD6AAC2DB610@HE1PR0502MB3116.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zXVS3WHoX2i2PaETF/ARlnxRnhrPP2sGOilL5G2R77mMIMHSdCJBFfTM+lkk1u7HsfEpITenhwFlp9BcJgqIKcs/cLtVAvtg1c0DfZHKeeRZ7jmvDNmrOsz8BGgPFCCsN9Hha8mmoo4QSXtifx0OZbTa7Iw4DbmGnusNgu5GXaT11fENCVZvp/MXVJEzy4SCHbPkQRil8yM9tE2D6zxM9i0J3iXeHQmR+nHvDU0altNkp1Bz02HVgDDP+fohtBKTRL2zPyt65HmVsC8ycfzyV6/RA9XZ5k8lz8OYNLekevZ1je/syuYbwCJIQMazchc83tifGnn0yJPudSRsUV0vqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(396003)(39850400004)(366004)(346002)(8936002)(6666004)(83380400001)(478600001)(5660300002)(54906003)(4326008)(86362001)(52116002)(8676002)(2906002)(6486002)(6916009)(26005)(6506007)(66946007)(316002)(66556008)(66476007)(16526019)(186003)(36756003)(6512007)(2616005)(107886003)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4ZveadCaMlVtXAxzFBpyyq8UFgGaeX8IYNjm9msHDDrZNW7MhEi7PMXwImhov1QVyQa0Qkro2LUOUtmKDTKxmKJK7jjGcxvbpfxRPJwckJxX4JJiCxhKOA+0MSwaQ9CTAxwYLGv29C5ZGXOlZPVWmv5C6HbsTiyPlf1KracGj5IqzEi7Y8R2VDGSZEJO8hnOJ5ET1ogDqJdMav9t+j6c/9G/d7wL7LKOFoiO0vqSdPLNLiIjmS+hV9VlubV0wBQxjB/E9pbF9/tM3Yk/ZbsQcJuxnM9/iNTTW91uyxcIyCnzWf4Iou5R2GKOwzkcbv00Fu5BPi4Zu6GVCB8RQRlKCYreTDAltJIMbk07Qv8BPdJ5ytWuoD3E2u0G49c7B/ppOvNyA1+aoBOIjCjXgvRpfuYQ9AiyfmWG5Ef5BC63z/g9T6Xd4BUTxqMfq9um0KvPzOf9nKptZdhhF0IrlLhB5EWSQmHzlgZHghDRBwm7cgM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 022ad275-71d0-4302-beaa-08d827fa865a
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 13:33:42.4894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xrd3KAgwqRobTiWsHbnq6BgVK1qxCc5bbxXjKBNV6pDHQTFyVPUtUa4sBwFEnov98gc/Cs3QIpPEeI3dBJeynQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB3116
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


Petr Machata (2):
  net: sched: Do not drop root lock in tcf_qevent_handle()
  net: sched: Do not pass root lock Qdisc_ops.enqueue

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

