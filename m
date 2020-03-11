Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC67181F8E
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 18:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730478AbgCKReb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 13:34:31 -0400
Received: from mail-eopbgr60070.outbound.protection.outlook.com ([40.107.6.70]:25761
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730375AbgCKRea (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 13:34:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khHuqYIgqlaBoz2b3U84v6LohbW9n23t90jYPWCLpQ3GKVSut201zINFYSg5SbmkfXOawSTZZbMeCf2K080YdCMAQZ/X/V5zBXS9kQm0+8k/PcXaTS8EOe4JKo1d0/ED4jDJ9Po0sRAvVSuXYt4hDAUqB1ij1GfjR5Q0aRBSGrim94mdIB8+r+aQvccaONeBh2/5z+NLuDPAzyu+tCbRjvK6WdcWtdo5jj1BQHZburazNygR7pCbd5NQWU3oa0Y5G/o1DrEQNOXjTBqoBxWDccGMw5HJlIJBAf/uk7Kmo7MTIoqWV3BuOv5lrxMKAJZFfljANH9c8BfWmb48bq9tYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mBBbzaMAlwxSxZPhOgeyBjYnO6GEBQTmYhYZXEKeWqg=;
 b=W9g2cqprSIelTFDpWjG9FUVAKCwgQe5789x5nFEaQsYh4iONsuyWLYpyP5CWjk0FS9OadbkPuWLatuIQ3FzITsO/oxFo7dAFZd3Fc2rKb2MIzy+gjhynCuOBRElCr/BNS2WKjkDucJeQPLPULVEiGwvZp/DsTcOdH/GqlTm6cBTt6xFDSMXyS+p5BKheSN3RaDkGnZZ8ZOpKqaNSibzyWxlkjmSI6XaG9hbKD9VO0RC7Zj0pwWi/QKRvvF/E44KeVIAUzXcONJuaTv/zBU1Qe8TGyn4QW4ViPpc0hShfK2vi3QNN8ykcbtsyZerQWZkVG5tLUaq+llkAxZbaejaMFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mBBbzaMAlwxSxZPhOgeyBjYnO6GEBQTmYhYZXEKeWqg=;
 b=VCsf0Lzfhfu9gR49+nFW+NiSb9iJEYziDrGenQvWXpWgF8fh5cok2QzYMVuwKuqIZdrI1+a9atZHU7aFv78fdx3G3gNlJQ48zZoEUjGaPkg2aEws/1mxC4kEyqFGdOw7dBH9Gx6pZ5C34CU7VYAlEdm4FfvA76+P+KbkQsCrwAk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3449.eurprd05.prod.outlook.com (10.170.248.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Wed, 11 Mar 2020 17:34:27 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Wed, 11 Mar 2020
 17:34:27 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com
Subject: [PATCH net-next v2 0/6] RED: Introduce an ECN tail-dropping mode
Date:   Wed, 11 Mar 2020 19:33:50 +0200
Message-Id: <20200311173356.38181-1-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::17) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Wed, 11 Mar 2020 17:34:25 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 58e15d4b-25fd-43d5-9e30-08d7c5e27251
X-MS-TrafficTypeDiagnostic: HE1PR05MB3449:|HE1PR05MB3449:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB34492059254D9979C79E74B4DBFC0@HE1PR05MB3449.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(199004)(6506007)(186003)(107886003)(6666004)(81156014)(4326008)(81166006)(26005)(16526019)(8936002)(8676002)(2616005)(2906002)(86362001)(956004)(36756003)(6512007)(66476007)(66556008)(6486002)(6916009)(316002)(478600001)(1076003)(54906003)(52116002)(5660300002)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3449;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zwONL27NU/3NeowcjNdW/+KjBouBSyD/JUasVHN7xG7flKaB68nrTp9uqJx4FADvsudJEr1/ZcWFcLV9h2kn764IzFxt2C+LNjeQYSoPWPKDxqBK2i7UrA8Yt/IqAi7QJtgVmI3WdIZgIZlgYE/8mlCxeKFm9ujgFlAwG1M4M8sStb7gpKDIkyYyrCZLvFzW3aLB8M+FFcZhZMDyIS3W2YoFAoXJvw3JZsAN5Mpv8bM7pJheZ1SjM1eigC7tdq/wRcAp4voGHPg8DO9WKE8GuNGplB2EQXi66tu1dAsm0nzUzceNh7wNGa4QWWedeewLX5+tPaDZO7LK7uEz+DChYY1k5WaWbppvXq/a3bNdstXllNDFG8O8ujrqqbKrxtB31al1A+dDMjVjLAccKMWJUQ+L6m/KZ92jWuaIsAfNrd9PEmd9Q8FdLzRX3Cu6Kx9B
X-MS-Exchange-AntiSpam-MessageData: suFvFXfJN+08+3NQviVk6nEDZYdOFopl3/MegbEHh+86lUghn6sHo2N4A/HQbRgC64oIzr5Ju6qRK/oXCf2CTppagzBEZ2TWgGNqDJMZdK29jAC3wa1+lxIPxBlCNZbB9iCrH+mfCCMJjId/nOv8Wg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58e15d4b-25fd-43d5-9e30-08d7c5e27251
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 17:34:26.9725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LyKfy5+l+3jU1vq8Bx1QLn3yqkmoqMQSsvREB/sR5o6LeVhAfk8AtO0omZJpUEkG7HPhkGwQa+6tJNmqQXSQ4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3449
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

Therefore this patchset adds a new RED flag, TC_RED_TAILDROP. When the
qdisc is configured with this flag, non-ECT traffic is enqueued (and
tail-dropped when the queue size is exhausted) instead of being
early-dropped.

Unfortunately, adding a new RED flag is not as simple as it sounds. RED
flags are passed in tc_red_qopt.flags. However RED neglects to validate the
flag field, and just copies it over wholesale to its internal structure,
and later dumps it back.

A broken userspace can therefore configure a RED qdisc with arbitrary
unsupported flags, and later expect to see the flags on qdisc dump. The
current ABI thus allows storage of 5 bits of custom data along with the
qdisc instance.

GRED, SFQ and CHOKE qdiscs are in the same situation. (GRED validates VQ
flags, but not the flags for the main queue.) E.g. if SFQ ever needs to
support TC_RED_ADAPTATIVE, it needs another way of doing it, and at the
same time it needs to retain the possibility to store 6 bits of
uninterpreted data.

For RED, this problem is resolved in patch #2, which adds a new attribute,
and a way to separate flags from userbits that can be reused by other
qdiscs. The flag itself and related behavioral changes are added in patch
#3. In patch #4, the new mode is offloaded by mlxsw.

To test the new feature, patch #1 first introduces a TDC testsuite that
covers the existing RED flags. Patch #5 later extends it with taildrop
coverage. Patch #6 contains a forwarding selftest for the offloaded
datapath.

To test the SW datapath, I took the mlxsw selftest and adapted it in mostly
obvious ways. The test is stable enough to verify that RED, ECN and ECN
taildrop actually work. However, I have no confidence in its portability to
other people's machines or mildly different configurations. I therefore do
not find it suitable for upstreaming.

GRED and CHOKE can use the same method as RED if they ever need to support
extra flags. SFQ uses the length of TCA_OPTIONS to dispatch on binary
control structure version, and would therefore need a different approach.

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
  net: sched: RED: Introduce an ECN tail-dropping mode
  mlxsw: spectrum_qdisc: Offload RED ECN tail-dropping mode
  selftests: qdiscs: RED: Add taildrop tests
  selftests: mlxsw: RED: Test RED ECN taildrop offload

 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  |   9 +-
 include/net/pkt_cls.h                         |   1 +
 include/net/red.h                             |  30 +++
 include/uapi/linux/pkt_sched.h                |  17 ++
 net/sched/sch_red.c                           |  53 ++++-
 .../drivers/net/mlxsw/sch_red_core.sh         |  50 ++++-
 .../drivers/net/mlxsw/sch_red_ets.sh          |  11 ++
 .../drivers/net/mlxsw/sch_red_root.sh         |   8 +
 .../tc-testing/tc-tests/qdiscs/red.json       | 185 ++++++++++++++++++
 9 files changed, 344 insertions(+), 20 deletions(-)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json

-- 
2.20.1

