Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3700021F768
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 18:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgGNQei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 12:34:38 -0400
Received: from mail-vi1eur05on2078.outbound.protection.outlook.com ([40.107.21.78]:36320
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725931AbgGNQeh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 12:34:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLCVBCo7miBcrNhIfDC0hobuyZM3z6d2Zbcktz8mx6KoLA8JSna8TyukozQJFql5q/WVq7iozPZeeA2QWmFylms7+Wa1tcYqVpJu4ZNiuqPwJAoWt1w3TbLRtXpbjfcA4Ytzx5y4FIg4rb7R5uYNYobL+4upRI/2Zi1+iwup4r4DY77kgG9Utx4cyq7XO9F4Al3W/myY9Ss2R0vYwJ1rMMQrOiBZMpsC4zbISI0+w8DUPlf9sqwTF683WV892m1SvRWsKXtlkRx/dLK5YeXcj/EAlgYuHQy0fZ9QLzIRDZmrPB2c2vPaCAEeTiubtLvr5bn/y1MzJqZkqXyS00egwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhoYPjPKdZaiSXKyF//Ky0HpTKdyBAQIDLzazcjG/xI=;
 b=I1jlZnLb2Rba6/Nro8baMe7gdA4WbrLkP1W4XGvC47vAREgBAWlhneg8F5HJFIj8+p0CJKHj8lRYDJw8ZflmV9JFs6xJTUAnFYeX/PbSmWk8PE4MKz13baR/3uw6b/shxEPQU+MBhaJG+HkgmZgLqaRVHZjIEIZeo7FXdYKnlrwK4hQ658XewArWwGmat7msWogFjHYt04BiJedAn55HQ6cfXCadEVPsAIEQyjQbnnWA67aE6IengbSRkm8FLJgRRZT6K5XojKLePrZXF/9WHkDj4iW0+guX5j+b1WXHiBytWKaZETKubjNguXzWoR8loVREoHr60j4u2KqjdzO6Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhoYPjPKdZaiSXKyF//Ky0HpTKdyBAQIDLzazcjG/xI=;
 b=arA/CDwKc4+M3w+6fT9sI9RiaF5r7iroHADBUko/I14Fw9JFO0jl6J42uTImlnYlUxobaT/IOhPpDOfqMeQnb6YHhMbap2Lw+WqZgbPkmcyKoktjTxr7qEIcBM1kYaU5NphfUDVtt00xbXPleqY8hGNQKXKwCKY6FWSIDXw4SHs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB4524.eurprd05.prod.outlook.com (2603:10a6:7:96::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Tue, 14 Jul 2020 16:34:34 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 16:34:34 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH net-next v2 0/2] net: sched: Do not drop root lock in tcf_qevent_handle()
Date:   Tue, 14 Jul 2020 19:34:00 +0300
Message-Id: <cover.1594743981.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0033.eurprd03.prod.outlook.com
 (2603:10a6:205:2::46) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM4PR0302CA0033.eurprd03.prod.outlook.com (2603:10a6:205:2::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Tue, 14 Jul 2020 16:34:32 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c9d7adb7-6704-4bd1-d7fb-08d82813ca61
X-MS-TrafficTypeDiagnostic: HE1PR05MB4524:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB4524F793783341E74C7F128FDB610@HE1PR05MB4524.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +MNXPHNDNY0JqIcoNXSW0VxPCbw5ueIx54gM7F4dtYc81N13Ew8WXTFcOVznk/KHbNNuzV2vqbq+NgaPe1NFOP8mf1ub9dMvNmo+UWfYqEzniZTgJE/KpMya6iucd/N0AnGeBiwWX2gfVbtGoedwSegw/39Bks8DYFouJPOXH+vHDzgsE6TzX3W6gFxx0CSCCs3BOhUnZBQhHrsvbpheJI4Vb3zIt6eR+TIICr+GczEJipDDU54cF7AZwrR5OfH/SMu7kBOR0NaVWWZz8xO6mqKW2bbsHjdW2dx92ZJMEyi8ZXvv20bKk7ZW+64Ncv75KO3EKhS55o6Zvz47owW8TQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(136003)(39850400004)(366004)(186003)(2906002)(66476007)(16526019)(66946007)(66556008)(52116002)(107886003)(83380400001)(6506007)(4326008)(26005)(956004)(5660300002)(6512007)(2616005)(54906003)(6916009)(36756003)(86362001)(8676002)(6486002)(6666004)(8936002)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OjGAn9GUxaQrIyv6RE3MPMy/qf1H52Ka3k1u5EdLXqcgbLkaI5ha3vyGJ06Okcv/NUtirdMT3R51I/6kisod055+qePtRuLriu/9qoT+rAlCEx4xC1VAdaC0yD+pIaW6fNUFdzqKSAz2Yda48d4sc88j9fXoi7+I0D2mcvEeCgXUuLSMVvg4kBbpe2QH+sDi2CwapucyZy/4pMdItUBjfviiQnJOt9PbxFVFkoGR9eY6L6p6XrZ94J4d2Vry9R3A6jkefleIVsnyBzwrZM6Gbe2BvsWqtk0adW7cpdvFRzfnQjOugsqi3kIgsDSyWoUMOOR/f5ralbXulsrkyYDjCvvseIRqNCTTncp9deIeTf/poKqWbU8MdO+3G82qQs3dbx3EZnxXwAh9hwDxLXXBoNfpkgNFRGFSVwUk0zhpWgTJbSNY7zqA8AjbAREIWVbjBMQGpO6AFMSLbHOf/nQpCX8rcmTbFYX3pUXiYyeku9TAEpQ80IW8x+IYKGA7XX9W
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9d7adb7-6704-4bd1-d7fb-08d82813ca61
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 16:34:34.0663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XLjGWu+Mrlc1iaJRFZWIR96Ll7Mbozk+UZSqEmXQwO/6N3x2oMMU1IVEzoqMD0pnphdZfuR1hjvUm/+7/hRdSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4524
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

