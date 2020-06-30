Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FB420F266
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 12:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732209AbgF3KPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 06:15:22 -0400
Received: from mail-vi1eur05on2088.outbound.protection.outlook.com ([40.107.21.88]:6261
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731155AbgF3KPU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 06:15:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWQBaK5AHbkEDTnOv2FKwvkKMQ+Kv9bYexc4dO3BZUui90D2nNVeaRNrS8dUIa/l8Oje3OOohjElsqmYRn8kMAVdJeIECSVfh92pvyzEJXlsHkhxeY4l03ekCLRcGeCc+R6m+fEntQ8M+eDDfVLDW8iI2Oxi4aWQkhMo0PLF8eFffAdLNsSLeI7keeEuTbMSkLMvWJ24y2xRhE5mgvJjpuf1mnejv35/GoVNBqCxWqWrXIaiSTeWMXDK3SiZebMX1G8C4bWtVkkKI2o6aYsHQzwEFoU17o5qzsG8OBXKd7jXOpqvP8LbyQPMN/B4kCN7HclfcAOm0N7bwHFGcrcwTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8wkRKCDwtxXgvgw4m3jemMHQFUqi9k7RQHvH2WYJBs=;
 b=eJmcrzcNEWJ46HJ6Zo/drC64s/Gp804synOHMFBi5WQCC7I+J7mB/PVBjd69q5Oh746LAOwaJrib0uaYWT8jpGVGq2BjcAn0C6jqmRbJLhQQUMfz5FgBMzvJivl9+W0l+PKmDQ8oDGUSxmUIZNVBs2M66s5KJrb+hQX7LBdb3K8GQb7qs46IbaByjh0A8BYoT9WfbUfJdvtqlcNBWqO96aSh8SMl8IGbt3N2YelIotyDjuwcj5V71h/Czn613VozxQk0g15VD84VO8UC8ECVHjdkEQa13pVeqVTqsaNq1EEXsiI6tStOj71v8qTHjUSEluZPnyjsfJgPdIyEKiYigg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8wkRKCDwtxXgvgw4m3jemMHQFUqi9k7RQHvH2WYJBs=;
 b=iip4wv/iibiE/K9dNOJ2yN98rrugzCBK11QgYCLfKihXoDss3BtYog3bd6lEUbBewF4FmGI189+Li62NkfR20BtIaAKrKVeVm88Au1sE6TTI9dae3LVvJ1apNP+0jadtKl8wdeq3u1Bl4U5lKygdYQwMMUTfgnuGHKLThoxETo8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3417.eurprd05.prod.outlook.com (2603:10a6:7:33::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.26; Tue, 30 Jun 2020 10:15:17 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3131.028; Tue, 30 Jun 2020
 10:15:17 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH iproute2-next v2 0/4] Support qevents
Date:   Tue, 30 Jun 2020 13:14:48 +0300
Message-Id: <cover.1593509090.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:208:be::49) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR04CA0108.eurprd04.prod.outlook.com (2603:10a6:208:be::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Tue, 30 Jun 2020 10:15:16 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 23a877b5-818b-4c83-68b9-08d81cde7c6e
X-MS-TrafficTypeDiagnostic: HE1PR05MB3417:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3417E11244299BEB3F54AC4CDB6F0@HE1PR05MB3417.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3H6M9XCDj3rQ1dYRX1nyeiHDnjWSQZgORTX76o99cDmYAww4xXFZ2vBWFueFraauKDti97jlPdjtoXI0Rm3ZXweKlo+Q8C7b1luI/sO1oWQGD+8UWVsuHRXPP4uFLHJ78YpHm2zTT3nSjhqYfj2t5Rf6+j6uV1XrtDjTpQ9inuBHRXVBkeLV7trM/Qnabww+48mV/A2avb13QjT/T/AOSQqnQVahUB4AaPqKVVaQe44nekV+Ox4OwF7fsA13uR+0Lad6GsrsUa8Z8LHoVTKnSz+kmSlGxU2wn1oM1ldiDwmmjwxW1MrxsXIj7LHvoPrdLwdqiQEFa/ABn82s07rpQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(6486002)(478600001)(956004)(16526019)(2616005)(107886003)(186003)(4326008)(2906002)(6916009)(8936002)(86362001)(83380400001)(6512007)(316002)(36756003)(66556008)(66476007)(8676002)(66946007)(54906003)(6666004)(6506007)(52116002)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wkqFxO9yKfUVem3gk7h4raDSQZHIiapFW5w4QjxlFgct5eJX1xOaz0RD/cWvbTGqd74aK8nGftaRGCYa35aCCHL/SYpFoBZDiJiaUPkR0rd0tlAIK9qk9PwsmIvjabPKLSkr5gc3Bw/YxLb967fjRalehRLYEwkgpalyihUURvDxQmrV/sILpMLpBSSVYmGKeGcIpl5DwxLdwAJl9Ma5NUmPDcVEGy1+qC4ncM70SChiwplRLNFTcXHQArdBgGfC66Yvr5OBaNujbMv7W1tcQatswhBpovRvb0QyDkEru3cUS4M9HWkzQnCUbIviBdmunf1OtO/kGHGwLHjG8Z0QmqdM9oZRk/IYzqnAJrYQhWOXYJs/qX6XeMciI1oRcw024uE1AeArXyhDEz4t7q16JsAN6PdPNX8SGrJlCus8MLb63bg8iYQcYozK0AT/bN04Fu1Z5/UCezkNbzGTmSZKbt+XXcsoz/CzENIACwwHK9U=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23a877b5-818b-4c83-68b9-08d81cde7c6e
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 10:15:17.1431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v8phlTNqsWTzxkWK3jr77vgyB4fgS5xPTKJ93Cl3Ru7ppNI97aEaq/0oye0KelungalL6AF+0D2RzM735SYRmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3417
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To allow configuring user-defined actions as a result of inner workings of
a qdisc, a concept of qevents was recently introduced to the kernel.
Qevents are attach points for TC blocks, where filters can be put that are
executed as the packet hits well-defined points in the qdisc algorithms.
The attached blocks can be shared, in a manner similar to clsact ingress
and egress blocks, arbitrary classifiers with arbitrary actions can be put
on them, etc.

For example:

# tc qdisc add dev eth0 root handle 1: \
	red limit 500K avpkt 1K qevent early_drop block 10
# tc filter add block 10 \
	matchall action mirred egress mirror dev eth1

This patch set introduces the corresponding iproute2 support. Patch #1 adds
the new netlink attribute enumerators. Patch #2 adds a set of helpers to
implement qevents, and #3 adds a generic documentation to tc.8. Patch #4
then adds two new qevents to the RED qdisc: mark and early_drop.

Changes from v1 to v2:
- Patch #3:
    - s/early/early_drop/ in the example.

Changes from RFC to v1:
- Rename "tail" qevent to "tail_drop".
- Adapt to the new 100-column standard.
- Add a selftest

Petr Machata (4):
  uapi: pkt_sched: Add two new RED attributes
  tc: Add helpers to support qevent handling
  man: tc: Describe qevents
  tc: q_red: Add support for qevents "mark" and "early_drop"

 include/uapi/linux/pkt_sched.h |   2 +
 man/man8/tc-red.8              |  18 ++-
 man/man8/tc.8                  |  19 ++++
 tc/Makefile                    |   1 +
 tc/q_red.c                     |  30 ++++-
 tc/tc_qevent.c                 | 202 +++++++++++++++++++++++++++++++++
 tc/tc_qevent.h                 |  49 ++++++++
 7 files changed, 317 insertions(+), 4 deletions(-)
 create mode 100644 tc/tc_qevent.c
 create mode 100644 tc/tc_qevent.h

-- 
2.20.1

