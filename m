Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F69467358B
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjASKdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjASKdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:33:11 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729947A9F
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:33:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+lZlcz1MDm72natEZHYN5GckMkz1ZeLmtuhrQa3YpMOM+kcZ2PWRqxGKolqy8GlZmq8OsvYKaphFSn4qJuKMvlxQbsrZOUYLWeWKRn+23oi6N3kICKDeSP92gSxDA6B6alznAJAivjaaZN5vbpW/99sXisEaTauyEBGvlziv6JCP6USsEyWfSgWrqLm6tfL5kt+vKBEsQ2/ajGeGiNUtNu0RWSoHBNc7qt9EsHNdJbETwgkXprU+89Wb/NIpSH1GwsKadYNlnD50i24LBFvnIdJzCsrjFjpOME0iwgp1oTP6YXyC9fXaPq4D+mfxM3Av/UFVHoH+R2lSojb8xWa1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eOk2t24mn5TlJ6T08hgoFbKJnh1VE1904Za64KOLAgY=;
 b=DiwAEgoDkqKh+ngWGAbrJc/a7ZsGj32zjvU4Gy+eVd0Juw1jirp/xg0hAKxZeSiGvroYIX7tkMV84kWyIHxAanrpaSF1b0gtzoBfpod66ZcErnLRnLizArhYgp7gSK2mmgH4FVSAtaxw0cakZwCMB56GINBeO/YE5+Uqy8n9fnhhbYwqye1ja85z1RqtrKMxT99Folk+4WRzMlylYqQaraAPQoDfl54Un6g/KELJqs9b3FMusjkYpq+DjyyTH1zSdKL009JIyqDPJTXKds0tgGDhLpIk682eXVAreCNbRFitSTHPg0CRTzAH1QrvXRdpw4yOiCbSGA2u8Nxe5GkSSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOk2t24mn5TlJ6T08hgoFbKJnh1VE1904Za64KOLAgY=;
 b=MbGAqU/bLBclyK1IQBhiLx+GOdwq+KNFMe1IXMlq9ib/nsEwlyPptcPgPskxtRuZMnIBfc1lV261bChoRTh2crqEQKcVdsRvDbhur7rVSc+K/ysUrM1+Mq1EkPK73HkrJYq2QDQRo3i8HgQKgaJjluqmAcdTUcEhJGmSy1zz5tzrTqS4XI5QRhjuRWNejIuxDypxQuIKY3Pk+86JYW5etmHyt+VOkLq42iFSFC2dy2Je9yixBnr1Q8pyYP7gzLKHxjPghQ0ZA561OeQiNacQcqnSpAnaYyg2r4sNx47klWP8hqBtv97rk+u6K/iixtrFLU4cKbZdsdTsMnj2YvXzPg==
Received: from MW4PR04CA0272.namprd04.prod.outlook.com (2603:10b6:303:89::7)
 by DS0PR12MB8071.namprd12.prod.outlook.com (2603:10b6:8:df::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.24; Thu, 19 Jan 2023 10:33:05 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::44) by MW4PR04CA0272.outlook.office365.com
 (2603:10b6:303:89::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25 via Frontend
 Transport; Thu, 19 Jan 2023 10:33:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Thu, 19 Jan 2023 10:33:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 02:32:59 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 19 Jan 2023 02:32:56 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 0/6] mlxsw: Add support of latency TLV
Date:   Thu, 19 Jan 2023 11:32:26 +0100
Message-ID: <cover.1674123673.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT030:EE_|DS0PR12MB8071:EE_
X-MS-Office365-Filtering-Correlation-Id: a19a854d-5bf5-4854-0919-08dafa088ca4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sM0plXn87yzqTNRUYqX651yj+UmyrZ8TlXnM6/8unFpYDkVzIZuv+vPqvqZzY3fXGrlsxiXflEszZJyjRm9x4mQtigFL/KXRZoHz/1HBHhZniwPHicIOY/lPlvz6SLdoJtN3dbrRXAKGbBgM99LaCcXtbEXkqz50xp5vsMyS5KYSayn69JiAZTAaM/JNLLBpdUXRtCwMCZiQIMqodNHd9iwAUNfNDXfGE30X/1IRx3v5IXDBI6heycz/gsA2cHbVSuLIjn1rulWXzWQgCwbqjASotZP3jZPJ8+lX1ghBcE4K8boHwN4BDCAT6tHKTLE9IqrRQ8J6hwU19RsTtHt5kTZt75ODCEeQ75VlvP72s53wVJZqgqXc7u1P8e/tLt7aQ+f+1PiABWuyNrXRMjhBEwrGmE4leNfe1jVd3MCQlP1b+KB24vX7Nzmtz+5q2TXWPQwQ83oi4vRTOwlfWLRBdopvxNSQj6V+7xs3VgQ7AWctmcw+cFJYW41vn47EKSdCL4PzpiyKB488nJZxzKKXx70pffYZAG8WbsrPj6t5XFvG71It+LrKz1S/FGnw9VR6MdkSSraqlJt6lWikUKnbNwzYA9Pf+G36HC0K31TaQFVEmPNeU9M3x+21HvHLcrg8qE/gcfj9t5cIlB9WWN3Za8x58OuIPi/OVrqDGIEtLl7TecwIjGOr3rPq+gSG18k26e+imWfcGxGH0ZeAcBdxGA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(136003)(346002)(451199015)(46966006)(36840700001)(40470700004)(7636003)(40460700003)(356005)(36756003)(82310400005)(40480700001)(86362001)(82740400003)(7696005)(2616005)(6666004)(107886003)(16526019)(478600001)(186003)(26005)(5660300002)(8936002)(2906002)(36860700001)(41300700001)(4326008)(8676002)(70206006)(70586007)(110136005)(336012)(54906003)(316002)(83380400001)(426003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 10:33:05.1026
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a19a854d-5bf5-4854-0919-08dafa088ca4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8071
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amit Cohen writes:

Ethernet Management Datagrams (EMADs) are Ethernet packets sent between
the driver and device's firmware. They are used to pass various
configurations to the device, but also to get events (e.g., port up)
from it. After the Ethernet header, these packets are built in a TLV
format.

This is the structure of EMADs:
* Ethernet header
* Operation TLV
* String TLV (optional)
* Latency TLV (optional)
* Reg TLV
* End TLV

The latency of each EMAD is measured by firmware. The driver can get the
measurement via latency TLV which can be added to each EMAD. This TLV is
optional, when EMAD is sent with this TLV, the EMAD's response will include
the TLV and will contain the firmware measurement.

Add support for Latency TLV and use it by default for all EMADs (see
more information in commit messages). The latency measurements can be
processed using BPF program for example, to create a histogram and average
of the latency per register. In addition, it is possible to measure the
end-to-end latency, so then the latency of the software overhead can be
calculated. This information can be useful to improve the driver
performance.

See an example of output of BPF tool which presents these measurements:

$ ./emadlatency -f -a
    Tracing EMADs... Hit Ctrl-C to end.
    Register write = RALUE (0x8013)
    E2E Measurements:
    average = 23 usecs, total = 32052693 usecs, count = 1337061
         usecs               : count    distribution
             0 -> 1          : 0        |                                 |
             2 -> 3          : 0        |                                 |
             4 -> 7          : 0        |                                 |
             8 -> 15         : 0        |                                 |
            16 -> 31         : 1290814  |*********************************|
            32 -> 63         : 45339    |*                                |
            64 -> 127        : 532      |                                 |
           128 -> 255        : 247      |                                 |
           256 -> 511        : 57       |                                 |
           512 -> 1023       : 26       |                                 |
          1024 -> 2047       : 33       |                                 |
          2048 -> 4095       : 0        |                                 |
          4096 -> 8191       : 10       |                                 |
          8192 -> 16383      : 1        |                                 |
         16384 -> 32767      : 1        |                                 |
         32768 -> 65535      : 1        |                                 |

    Firmware Measurements:
    average = 10 usecs, total = 13884128 usecs, count = 1337061
         usecs               : count    distribution
             0 -> 1          : 0        |                                 |
             2 -> 3          : 0        |                                 |
             4 -> 7          : 0        |                                 |
             8 -> 15         : 1337035  |*********************************|
            16 -> 31         : 17       |                                 |
            32 -> 63         : 7        |                                 |
            64 -> 127        : 0        |                                 |
           128 -> 255        : 2        |                                 |

    Diff between measurements: 13 usecs

Patch set overview:
Patches #1-#3 add support for querying MGIR, to know if string TLV and
latency TLV are supported
Patches #4-#5 add some relevant fields to support latency TLV
Patch #6 adds support of latency TLV

Amit Cohen (6):
  mlxsw: reg: Add TLV related fields to MGIR register
  mlxsw: Enable string TLV usage according to MGIR output
  mlxsw: core: Do not worry about changing 'enable_string_tlv' while
    sending EMADs
  mlxsw: emad: Add support for latency TLV
  mlxsw: core: Define latency TLV fields
  mlxsw: Add support of latency TLV

 drivers/net/ethernet/mellanox/mlxsw/core.c    | 108 ++++++++++++++----
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   2 -
 drivers/net/ethernet/mellanox/mlxsw/emad.h    |   4 +
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  12 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   1 -
 5 files changed, 103 insertions(+), 24 deletions(-)

-- 
2.39.0

