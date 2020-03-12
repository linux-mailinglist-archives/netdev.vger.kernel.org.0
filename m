Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C095183D15
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgCLXMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:12:43 -0400
Received: from mail-eopbgr10083.outbound.protection.outlook.com ([40.107.1.83]:26253
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726710AbgCLXMn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 19:12:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJRjT9GyDtp9+BsybYCV+hulD2LvcM55AD8Nxl9w4S9fV4aVgrErxXifO5LKzUdPlSLE+StCyRTENZmA3atS73wEdks02krfHaeRo7Gm/xknN5xt3dU18nhld6aMYGy2arM3J8TNtSEOTa5SM9KcdWo6Bt5sH5m6v+ZmY0JH0AVFvEJgek3W5y3qcQWeEnwuV9xqsdHzYqAQjQeSP+1m8t8eDD0XYRdpOu4Bffafkt/suckcsVwvrA8YMXS5n3nq+lU5hrFMvrU4kGQr86DXsyqvWjCa/UTxOB7Cah/xas+iUUN3/rp5o51loAuIMufxdo2hBEVggJCkEaT53acWWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DX5PQgxvp1MDvFCIT5GkHyrpcra+qm4N8/pHzZ3Bi8Y=;
 b=iiP5aoWhjKhn4osAghNBH2tMYAGIWqe4+NHu+TtltBVn387EbZ4CxQAxsagRkmx8n/vOdMs4mtvdbgJTwK52Ef7V/PhbcjvNEO244E+nM26Ags+Cq4eKIZYVTYBbcgdGxpauw9403/TD0FTRmegF7cc7v0qZ6EnVDx3758E6gfKaa5yx3CG8njOApaouKdRxsVDuwuL3achZZSx3UJKSsC270gJEgX0dztL/AfVrpbgEyN9wr5rFKCtyr0154jpImXYKjfC2S6JvpIb1ABMSN6N/nYZpBJilsy+7TtH0PDJFi4BYKBElvUj1LC/FhgRr9e3HhIXh5ZKG5wSWryc0pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DX5PQgxvp1MDvFCIT5GkHyrpcra+qm4N8/pHzZ3Bi8Y=;
 b=OhduD/V4bu/TEJw7dXuXap8RgRoiN7hS1lU8sQ8/HupRROVh0+TAh/McMTlMHjFLMcUWlJgJ3g4Wg/hcs6Ad+bqnpmqk4XQcOflCWFr22ET/j4lLRRxaJtdypV0Aq0OQ0n8r1kDvwdeZ6ga8K6alspCKBPVdrK87NRy0XOLoqKI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3194.eurprd05.prod.outlook.com (10.170.241.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Thu, 12 Mar 2020 23:12:35 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 23:12:35 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [PATCH net-next v4 0/6] RED: Introduce an ECN nodrop mode
Date:   Fri, 13 Mar 2020 01:10:54 +0200
Message-Id: <20200312231100.37180-1-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2P264CA0002.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::14)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR2P264CA0002.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.20 via Frontend Transport; Thu, 12 Mar 2020 23:12:34 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fb3da0a6-8e44-44a8-f3b2-08d7c6dad9b9
X-MS-TrafficTypeDiagnostic: HE1PR05MB3194:|HE1PR05MB3194:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3194B4B6312624437045DB10DBFD0@HE1PR05MB3194.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(199004)(316002)(2906002)(66556008)(8676002)(66476007)(66946007)(4326008)(54906003)(81156014)(81166006)(6666004)(36756003)(1076003)(5660300002)(6512007)(6506007)(6486002)(52116002)(478600001)(16526019)(107886003)(26005)(8936002)(6916009)(956004)(86362001)(186003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3194;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hrNI+fmQZdWvB6toxZJ84J/Km1toWmiJGwP8leifyKKz+NnNTAsQNJ9tlhMJlUja4333ruqVVzwhdKFK4c/OdxEt+71PDPYj2i7HxCA0Bo4IUtS59gnROzpHoTDU6XGT5q9huK1IRjBKOEIYmZ3tvKiiGG14vEV1LN1i6hTgNuipM9xPA5MSYmR10Peqk7kj817JzxCEQs/IgDqXjZKJEHU/Lu2yZyoGUwAr0q5NqfUikXq6PkS3j4maK2P/fqmF1HE4/XHUz4cRRzcT9arkXDmPvHtvhFlL8p7c0ILeXz2+5V68Nk9XpK0PChycvrarqtGzMKQboCghjBiasCIs6VYYvoRwomqXgGs7kt7ddrAyHEHjF5aLZs/a8B+enIxteNl1bv3VGRHfINfXSY6tT/SrZrCdk65yyLctmJfURBS5xwBESypEg3L+vVoBXGPn
X-MS-Exchange-AntiSpam-MessageData: Km6lF6Hu3xzITJYMieDKZlC49Ygk7CTbhh+MlSmpOHYxjXOMGwmbT7wLM9ZkWH8CdV7cb99AMbJRG8VTqQhM1L/zwoWAL1/DOMaYmq1Bzhhst6sBMiNZw62Dq+OHBB1j0DzVY2QFv+nXmHWmltpaRw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb3da0a6-8e44-44a8-f3b2-08d7c6dad9b9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 23:12:35.7535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XdZ3JE+hr4cOl5VDdiW9i7BXamg4+j7RiPA/zFRorNCyGvJTji/9qOgaXAVdx0qxDuNlxE6jKMY7qO2NNR+g8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3194
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the RED qdisc is currently configured to enable ECN, the RED algorithm
is used to decide whether a certain SKB should be marked. If that SKB is
not ECN-capable, it is early-dropped.

It is also possible to keep all traffic in the queue, and just mark the
ECN-capable subset of it, as appropriate under the RED algorithm. Some
switches support this mode, and some installations make use of it.
There is currently no way to put the RED qdiscs to this mode.

Therefore this patchset adds a new RED flag, TC_RED_NODROP. When the qdisc
is configured with this flag, non-ECT traffic is enqueued instead of being
early-dropped.

Unfortunately, adding a new RED flag is not as simple as it sounds. RED
flags are passed in tc_red_qopt.flags. However RED neglects to validate the
flag field, and just copies it over wholesale to its internal structure,
and later dumps it back.

A broken userspace can therefore configure a RED qdisc with arbitrary
unsupported flags, and later expect to see the flags on qdisc dump. The
current ABI thus allows storage of 5 bits of custom data along with the
qdisc instance. With the new flag in place, storing 1 to this area would
gain the meaning of "nodrop mode", which is a change of behavior and ABI
breakage.

GRED, SFQ and CHOKE qdiscs are in the same situation. (GRED validates VQ
flags, but not the flags for the main table.) E.g. if SFQ ever needs to
support TC_RED_ADAPTATIVE, it needs another way of doing it, and at the
same time it needs to retain the possibility to store 6 bits of
uninterpreted data.

For RED, this problem is resolved in patch #2, which adds a new attribute,
and a way to separate flags from userbits. This can be reused by other
qdiscs. The flag itself and related behavioral changes are added in patch
#3. In patch #4, the new mode is offloaded by mlxsw.

To test the new feature, patch #1 first introduces a TDC testsuite that
covers the existing RED flags. Patch #5 later extends it with nodrop
coverage. Patch #6 contains a forwarding selftest for the offloaded
datapath.

To test the SW datapath, I took the mlxsw selftest and adapted it in mostly
obvious ways. The test is stable enough to verify that RED, ECN and ECN
nodrop actually work. However, I have no confidence in its portability to
other people's machines or mildly different configurations. I therefore do
not find it suitable for upstreaming.

GRED and CHOKE can use the same method as RED if they ever need to support
extra flags. SFQ uses the length of TCA_OPTIONS to dispatch on binary
control structure version, and would therefore need a different approach.

v4:
- Patch #2:
    - Declare .strict_start_type at element with index zero, not at the
      first array element declaration.

v3:
- Patch #2:
    - Change TCA_RED_FLAGS from NLA_U32 to NLA_BITFIELD32. Change
      RED_SUPPORTED_FLAGS the macro to red_supported_flags the constant
      and use as .validation_data.
    - Set policy's .strict_start_type to TCA_RED_FLAGS
    - red_get_flags(): Don't modify the passed-in flags until the end of
      the function. Return errno instead of bool.
    - Keep red_sched_data.flags as unsigned char.
    - Because bitfield32 allows only a subset of flags to be set, move the
      validation of the resulting configuration in red_change() into the
      critical section. Add a function red_validate_flags() specifically
      for the validation.
    - Remove braces when setting tc_red_qopt.flags in red_dump().
    - Check nla_put()'s return code when dumping TCA_RED_FLAGS.
    - Always dump TCA_RED_FLAGS, even if only old flags are active.
      The BITFIELD32 interface is richer and this way we can communicate
      to the client which flags are actually supported.
- Patch #3:
    - Rename "taildrop" to "nodrop"
    - Make red_use_nodrop() static instead of static inline
- Patch #4:
    - Adjust for the rename from is_taildrop to is_nodrop.
- Patch #5:
    - Rename "taildrop" to "nodrop"
- Patch #6:
    - Rename "taildrop" to "nodrop"

v2:
- Patch #1
    - Require nsPlugin in each RED test
    - Match end-of-line to catch cases of more flags reported than
      requested
- Patch #2:
    - Replaced with another patch.
- Patch #3:
    - Fix red_use_taildrop() condition in red_enqueue switch for
      probabilistic case.
- Patch #5:
    - Require nsPlugin in each RED test
    - Match end-of-line to catch cases of more flags reported than
      requested
    - Add a test for creation of non-ECN taildrop, which should fail

Petr Machata (6):
  selftests: qdiscs: Add TDC test for RED
  net: sched: Allow extending set of supported RED flags
  net: sched: RED: Introduce an ECN nodrop mode
  mlxsw: spectrum_qdisc: Offload RED ECN nodrop mode
  selftests: qdiscs: RED: Add nodrop tests
  selftests: mlxsw: RED: Test RED ECN nodrop offload

 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  |   9 +-
 include/net/pkt_cls.h                         |   1 +
 include/net/red.h                             |  38 ++++
 include/uapi/linux/pkt_sched.h                |  17 ++
 net/sched/sch_red.c                           |  72 ++++++-
 .../drivers/net/mlxsw/sch_red_core.sh         |  50 ++++-
 .../drivers/net/mlxsw/sch_red_ets.sh          |  11 ++
 .../drivers/net/mlxsw/sch_red_root.sh         |   8 +
 .../tc-testing/tc-tests/qdiscs/red.json       | 185 ++++++++++++++++++
 9 files changed, 371 insertions(+), 20 deletions(-)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json

-- 
2.20.1

