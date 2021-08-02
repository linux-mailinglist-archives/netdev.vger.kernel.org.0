Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D543DDA4D
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbhHBONO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:13:14 -0400
Received: from mail-am6eur05on2124.outbound.protection.outlook.com ([40.107.22.124]:50528
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237511AbhHBOJr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:09:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+jo/DTfBOQ/MWIN5W0EM/xVbpHBGmLQaPnRNE6YKdCH1C6uxxW7nFD9dTllDr20qL8kniy/8O1dL1Pdt72zlA44Qg4q2FD1gGeNeAGcbqm+AXZiT9aNciGs/mqBoL3mGA2fXXmKoDP/a0LBvrBGrzKA9xRZVMz4IB9ibawtIe0VPWHzGJyWWOCfA5DshZ6q34Q6iLndBOCujNMCtTDNwNUiT7Y0zKG9kREFP9RYvWRATpHFa9Q9fknxlTt6KzEc24LhQeQb1oCHkMs8bE1YG+MUsz+Km0PJPCQMd//sZ17K6INHOa13xBsjVWhG5KglAZ/S5u6q5mpFzcl1OyfRjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YVFe2leDAYW5FKXr7qooA+twJthThQdyacj1HYb2KhM=;
 b=DZaOTV32S7GGr/TgrjLIBEfN8ZaIASgye+x8uxLrdeE40VqMei0bS2ysT9feiyIO3afbDODDf8H6BErq0+YjWwkX+ox6OveVX3oKrFhrspU5lVY0mnoti1QUbWzpNliJacGHONNWCf8c9M+Qc3MzNYGX4ZS4Gy5HaoUfgorj9jFuwE7utlkU/+IV8RPaDEshpe/O8w5WxVdiy7hLSRk5mDWma48EWi3H60zpjsY6/fu+HuGT/Cx2utcb93q1EVEhIJAsENiluH0r2/6EpHFZRlTxXaPAo+vT6BPIO2SqM95KVwN9NfbFwsHYhcRjx1054g+3gpAmePxKTi8L1MTmLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YVFe2leDAYW5FKXr7qooA+twJthThQdyacj1HYb2KhM=;
 b=BcZsYmKgCvSqmgx3t/WRR0SGCGizOQipNxsmEGskq0BZfVUUwYTT0LYETfjPUEMW58sYIRYvc8sw42CaDxx3EM/B57QaYRdzNZLNpKZlADw6EBSbGdv2j3cVBIF3JzjzPbmtSxhO7dZO74gP8YDsnY9EShYSQf7T++LHWHnTkVg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e4::5)
 by AM5P190MB0306.EURP190.PROD.OUTLOOK.COM (2603:10a6:206:20::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Mon, 2 Aug
 2021 14:09:22 +0000
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230]) by AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 14:09:22 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next v2 0/4] Marvell Prestera add policer support
Date:   Mon,  2 Aug 2021 17:08:45 +0300
Message-Id: <20210802140849.2050-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0066.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:8e::43) To AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:2e4::5)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P193CA0066.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:8e::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Mon, 2 Aug 2021 14:09:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f396394a-213e-458b-4939-08d955bf20b1
X-MS-TrafficTypeDiagnostic: AM5P190MB0306:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM5P190MB0306C836BD85C0406058E87195EF9@AM5P190MB0306.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fNwuQytEvd3olBnKvb4M6kGDQ3YbHkFcl4PmaI7GeUFlsf4rdB7JEITIdS6sUfSw4SPCNWGZQebpAChfgTy0xhIvprySUoo4Xhe2W9LhKLLHhJD031srjQWDQ5rhuF2bV/a7/5w+i804igAne9T/NyF99fI20SaqIAgxhxZwNuOMHqWSmpr9NhmxfRD8GTcveigFwCueDjTmGC5Ag3yqay561350fDcEuf5ID8AIqUhEuHo2Ra+rWeqQhgZTbPptIoGnK/TONEN+co4Yd44WP6y3SfPGKY62N9yfaC0qW2wOdbwO/Ngm3futLSXPmndTnhhX0jMtx4RHj1E5xO3lI9YbhHHKPZPj2hur/Dj6KCQN3+8V8yAFFTFGOCm3HawCLvtuw64ezO5K1CIqk7fQoRnjdIy1bs91vdKg7YbkG/evTXjg4jRDrJxb4F50IZFF6xvJ5/9HR0C2ne9v5DWUS1QlpEWriqnnAJWNjhT3581Qpwrc/Rmara6AnbmumcsaDBXCFItKQYau7lR7tpifNcSRrLf+dHnugKWHVd83fnNtTjTN3iFNK3Kjzpe3UeCsRqgXiUuaCvMMHdGXvtFP6EjXxUnYY5+Y43lZzmBj96gwKp5mUmn2N5N9I9vH8A/abTByFNdz5p5XQQgD3ahFRvYpqT0hTbl4ZJST7WUqqMpT6jjlCrrsnfJCqJtdy9tq4o2Ipx03tpjGPhkQ72G7jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P190MB1063.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(39830400003)(136003)(4326008)(44832011)(2616005)(478600001)(8936002)(956004)(186003)(6486002)(5660300002)(86362001)(66476007)(8676002)(6636002)(66556008)(52116002)(66946007)(1076003)(2906002)(36756003)(6512007)(6506007)(7416002)(83380400001)(26005)(110136005)(54906003)(38350700002)(316002)(38100700002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JUtf+73RPZe0blPzXTELlfxzgK2GYXwvorq881pfVjatU+CVQdQQsw249QhV?=
 =?us-ascii?Q?CUtmbWhj1pz8AZFjVu7RZwQsI4fB6UHj7QXGsPxBFsY9OfqI1WExuC6ufYjr?=
 =?us-ascii?Q?QS5Gv8imfyM6GUYPGXcPm09Gn1Um9PV+GFXbRscVTpHiPc1nqrVhVKaKPjSe?=
 =?us-ascii?Q?7Zzg65Mg26DNWmlR/03le7FKyQNnGD/qyd4SFo6b/df0RbTvSgddf/j+O5QT?=
 =?us-ascii?Q?1u3fKAYEfpRvvrb6d2VHs3vfvm7sMvJ4+g1MkJRG7QFAvhO7LAEj/WlJU+YC?=
 =?us-ascii?Q?EPYCdnrR9Dpl39FVNQhvzTELmGEkaT/WVTkjorbvUGT9Xy14VkMbGAiSfLIx?=
 =?us-ascii?Q?ztxYf43MyblxoDZgMWR9vsulyYNR3+5Fu5CY8QhWDn+IauXIUt4z9BtLU4dH?=
 =?us-ascii?Q?SfwzPETDXtSiUqfZ4jiYDTnE44WqNcBf9obxCenQpne2dTcNfK4M5+GFfR14?=
 =?us-ascii?Q?Z5OWM+N2h2L8Wy2DDYRXqtXfvuV91qbNy91ZD//NNDrSym/fmdjjdJcmCzBn?=
 =?us-ascii?Q?OJVHzMP0+QBKiB8SQe0+QtKYrZbC14vtUPqWRtQqyeGZmcrlCw/0IVG04mYR?=
 =?us-ascii?Q?U7OaBZGP3KOyyoKXn/N2RrWiopw0jwsOugotoTP4fmDiD5paxN1g2t4X9441?=
 =?us-ascii?Q?Rkka+Qc4rfriCHwSiL10kaIGIG/M0HWiEqKo/nz6pxfPusjMu6bOti8SQMwb?=
 =?us-ascii?Q?OYBKBgCA13Y+w7JY2hWNlDZpBWZOJXVIC3TNHUfEqg6O4cAAQnEgTTziHUcd?=
 =?us-ascii?Q?bm5tLhB/AuPYHZUiKSFWm4TurSb5PbMa+wkLOugJd7ewwhQ2r9uxfAmcIRYW?=
 =?us-ascii?Q?kcT4c7ohzwJr/BgIFXy5YsO/uJnup/tlqE/eFq4rWZdaZ8JknrgckRliAQwN?=
 =?us-ascii?Q?ozIFBt0nY+I3wCp2kGkTmVe0r1PHUS1taqHsfVvfD67XJTCQHIb7Ls41WDob?=
 =?us-ascii?Q?z3ouPuJNmFE+jv5ljzuM0wOtYBqGaqqMQ0/5yhWtizgTbECFy6CEcXOUDZS1?=
 =?us-ascii?Q?kYKfsVBD2uQLLe1lrlheUiajC8wBRBisb9Vo15RaB1+7aXHx1rd8aWJTgow5?=
 =?us-ascii?Q?jNJvC11t/eVv48Z5k8kiv+mKoB1v5eFrb6/WrScXw2RC3t29IdORxo7ArhZM?=
 =?us-ascii?Q?vnQuHomyQ7dJtLsUrpPQtqunqowiJwuLDnwfD6Xv/F53/QLT6AgDhLSBgLSF?=
 =?us-ascii?Q?vezKjYRIAdW1YOWnquzN2GCxZvbx/WE6XVQWpAh959WaKwZk1ZWLJbPLWpwY?=
 =?us-ascii?Q?0vAfLP0iiheRCa/LrhTVl2Kf2CC7uPpRrrgMeyA0h3+d9qESQPEYXGtHhhfY?=
 =?us-ascii?Q?RxTWk7ExUsr1ZLlABL0etC4I?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: f396394a-213e-458b-4939-08d955bf20b1
X-MS-Exchange-CrossTenant-AuthSource: AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 14:09:22.6703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rs/Uru8O1FeXxGpUCqOkuTFelc6Nyw+r+n23BZ043/N25sN3JueyBjrdY+6/JZtDEeDXueEvtLBz34AU15du6V/0rhuRoTfGSPLK/mPrWw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5P190MB0306
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

Offload action police when keyed to a flower classifier.
Only rate and burst is supported for now. The conform-exceed
drop is assumed as a default value.

Policer support requires FW 3.1 version. Because there are some FW ABI
differences in ACL rule messages between 3.0 and 3.1 so added separate
"_ext" struct version with separate HW helper.

Also added new __tc_classid_to_hwtc() helper which calculates hw tc
without need of netdev but specifying the num of tc instead, because
ingress HW queues are globally and statically per ASIC not per port.

v2:
    1) Added missing "static" in #4 patch prestera_hw.c

Serhiy Boiko (1):
  net: marvell: prestera: Offload FLOW_ACTION_POLICE

Vadym Kochan (3):
  net: marvell: prestera: do not fail if FW reply is bigger
  net: marvell: prestera: turn FW supported versions into an array
  net: sched: introduce __tc_classid_to_hwtc() helper

 .../ethernet/marvell/prestera/prestera_acl.c  |  14 ++
 .../ethernet/marvell/prestera/prestera_acl.h  |  11 +-
 .../marvell/prestera/prestera_flower.c        |  18 +++
 .../ethernet/marvell/prestera/prestera_hw.c   | 125 +++++++++++++++++-
 .../ethernet/marvell/prestera/prestera_pci.c  |  63 ++++-----
 include/net/sch_generic.h                     |   9 +-
 6 files changed, 197 insertions(+), 43 deletions(-)

-- 
2.17.1

