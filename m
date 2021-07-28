Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085E53D9545
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhG1S2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:28:06 -0400
Received: from mail-eopbgr50046.outbound.protection.outlook.com ([40.107.5.46]:42390
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229542AbhG1S2F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 14:28:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FgypskUyS1Jp6wXNzKn6PqncuydBCtAdUwy1N7nB6LkiGao1A/4XUDDS6nEGyZ7vHBxgBSjjf9ccdWl4U/0VmV5MOwyGAtlB5ewmlOPlHT3TNtKILp/zpW0YbIvBn3r9BMQUvfMTxHZibDoamFIiYIqEAtKn5gyvyWavBWHGlsGDJe95yHW7CldtfMbRW3ovNO1sWpSeyCfylnzFC+qgB+2Ma3gGj16Ts4SetdIw7cVE0ofyh7bGclBA1UhDRPUbhKyTVCtnkeRwmy0yBpyaH6hCq1gJcyfhMDAlMMw1JEwhgdLN4+rHM3drXZvhBW4kRd1dAjtiUQXD366OqfvBwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+LJK9wxQHaum5F4SKoBbhXjaHPTzhoYrZFS8+zEx2NY=;
 b=iWKyJVMGA5xJiFLCu2U0QgVfwvgplJglDC8UoyAZH2uHmz8XOmAABgNDxQ0Zp16yskkV+6btvwUmF6+7mClGBA7FtZVn2lLs3W6N4+HDBWBtVC9IpUoPuSO0N6fCqduzhTwqL9iFFcFnHYY9U5mx7pT8dWhVsehyUAfxietZ9QKqoeEhevbHL+sNm225EH/RF4WFVIXpN7pV4/BPJ3jWePx7KAdMkbWNBS9VMg1/oEOyZAJeenams/n9Wh3Nwv5I2vIPW/Sze0EVBvlI3OhHcA8WUalmOQR2Vlqezwf5o/HUCFGshmWImDrlMZIutNPbZpYBQpXeZMbk8k7YgLfzqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+LJK9wxQHaum5F4SKoBbhXjaHPTzhoYrZFS8+zEx2NY=;
 b=YgzcFOmE7qJbcYDBR4umVnUugGpK5EUZOeoFg8gOVFTBnBMz5+GhFeP4MV+/FDueMUBhIU+OngBF81IxRrsqU+HeWSrrxvY53OMG0044c8ajPQhrFjIPdSMpIPZVYaHVzLxj78BsHPNSYoQLnVDI/9PZujxPyMAluJsvMsrhBB8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6944.eurprd04.prod.outlook.com (2603:10a6:803:133::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Wed, 28 Jul
 2021 18:28:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.033; Wed, 28 Jul 2021
 18:28:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net-next 0/2] Plug the last 2 holes in the switchdev notifiers for local FDB entries
Date:   Wed, 28 Jul 2021 21:27:46 +0300
Message-Id: <20210728182748.3564726-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0089.eurprd07.prod.outlook.com
 (2603:10a6:207:6::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM3PR07CA0089.eurprd07.prod.outlook.com (2603:10a6:207:6::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.6 via Frontend Transport; Wed, 28 Jul 2021 18:28:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3dcfb6b5-0be5-471f-5d69-08d951f56eac
X-MS-TrafficTypeDiagnostic: VI1PR04MB6944:
X-Microsoft-Antispam-PRVS: <VI1PR04MB69440DACADCD8251FA6761B8E0EA9@VI1PR04MB6944.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fmCG6edKjKD3c0wTL53jnnjibVdHXrOI46mJEiNgJSe7bpWXTgT0nPNWvPfNY+KGCCPr9pFy8PD0MH83IE1+tWMW5cesWyLa9dXLs0uKF2bcjXCGTPEFpm0g1+FFlrHHdA569i2uuTximd9xFRiHvgmy02TPSv+pzt523h6Pvzl1gMCNLAXJRegKI6X7NmWp1MK48D7/Y+yhNQVh1WNkz6cul0Azlp0hWKIRcpiVEXbEtZL/zEIZGaaARYJjklQUfJshq4dO2h+ttZobHXzEutRclN2ehQnUIwkhOF0DqQZDi8gjOqUMedUKh7BWxva76R8f5PcG6E9QHd0nmmXzavzYkUXQy8ai+0AH5Qd1w/St0G2F725pKChOj/VaUn44Esnmx3EcTnCr+t395WodtSulV0GQBkMuGbHPaSX7ZYe6t2ANCX1TxGc97RO+VWWoTJvPjMY57rucLOWxQHd9gnJA7VaedAPMacFrxHDpE9Ke9YNPEOkCtU0CMMCcVjFWUb/AEWaNqMK37asK1EwwbsiL6xBFIthT0CHHg9dGfRHe9X3SJUuFkjBEOtOkUmxYDwMg5TMm4CUe0Yq5RKqUZgJ9hk1d/q8Jj/DfJZEiHE/wXy+hXXkMVS1NIG/7U9lrqcwZ3fA72biyWD8NEJTcYHyJw9weB9RIlw8Js1wAxsUzLxXtGd6q9ioNDkQZbD3y94YhGjNdWIvscMM/pbzdeb/ETGYakvAudD444jNP+r1AQktwHDjQnsmXEw6I8ow4jpEhWgV4mBet76fgRansmRvXSc7hn//NxdVeTjGUTQOX632s8iFXW8FevE6F9s6D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(346002)(136003)(376002)(396003)(5660300002)(966005)(8936002)(8676002)(478600001)(1076003)(2906002)(4326008)(36756003)(86362001)(83380400001)(7416002)(6512007)(38100700002)(44832011)(52116002)(38350700002)(66556008)(110136005)(26005)(66476007)(316002)(956004)(6486002)(2616005)(54906003)(66946007)(6666004)(6506007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Eq5DUM+QQVhJkvwTQ5Y3rlSnHq14p/QqqRGbsMuD4nukL1fJBQ5ewVJmvmIb?=
 =?us-ascii?Q?fHKLz7D/ZvkZSm8xOuruP0suYEyvt+GraSuJ2v2eoW8SIrT5pAeGaSQayf8s?=
 =?us-ascii?Q?qtPkXwRQ4I02VC0GK4BcwtWiZxtRoL6q0Ng+0F47kaj4/kcKNdbyhFk7pY3e?=
 =?us-ascii?Q?j/1sORaNVolAdv+U3Do9cn3SAJT1/4kydJMQ5p5oxTumgJnj7e0Gr3lGdUEF?=
 =?us-ascii?Q?yrgv2L6XaYMkrAvXirQGywRhwHAuDLB5HwVi0xuP95l7Bv28wlV8vD8z98nz?=
 =?us-ascii?Q?6kx/x88l00OTC0x8j6R1R+w+UHW1Nr7uaJKu3RfQEQ6TVVNBD7detQuW8ahd?=
 =?us-ascii?Q?4Iky5ZZGMhN8mTul5TrnNu8Y6xt3nofyRjIVjAAQHiyRiOZooCZoueRjvRfY?=
 =?us-ascii?Q?3za7N1o0kmOQMhtZXmeZQH4hu40NHwNuPHst9+JviYCMihmbNPWrGNgHGouU?=
 =?us-ascii?Q?CjIssJLDQhOqQCeHICYKg3GHqvIQDQFdDvyoglmwow6MVd7pALrGhxyS1pqk?=
 =?us-ascii?Q?4N/UpoEWF3gQIb0sNkH6h5FMAvo9nogJ1U7bdNs/dbFXfBv66dFzrtXxhZSM?=
 =?us-ascii?Q?GEA+Lc6yOx6WF+pzpJxfUE3Dx9meAz9bmVHeySszAH7/LIFPNtVpGVolsmFr?=
 =?us-ascii?Q?AMJQtGyVAPEHtsCZZhaFWl3OCzE5QYid2Erdz/y0EO7kFzbknMehVA7xpaht?=
 =?us-ascii?Q?cprOutW/vZhfLFmPbvSszSLLMlXU85d5Lui5EMTovYKJhGYQnkxAjz+NSnI0?=
 =?us-ascii?Q?X6rA0VK3j3rkUAT427Lm4yD8n7iyTdk3jLHoDaQPyT9+0HIwcsKY4wevlqDc?=
 =?us-ascii?Q?dtmrS3sPt6TyeheYjaW6A9qutc3WZuGh1opElqwLPVKAm2C/6WQkYp506mCu?=
 =?us-ascii?Q?uuNLDL4mxAdfhfa4Uwb7MGlHAvzv+NAMr5v0eLfsqmpDrGDguQBQr4d5U4gm?=
 =?us-ascii?Q?adGglm7YXGTVajwjhTOJOkPMekxYrdlgcC3pENy2JkVS0BA0AgEsmtYJWOYP?=
 =?us-ascii?Q?jbWn0G1DtYk4JpmUxS/4RiXulS8QyoWeplUnTGzFCGgh86Lr1y3GrfsyFg1Z?=
 =?us-ascii?Q?jg9nPB/9MoJQnfr39vTdbiEgneroRHMcg1zKwfg60tHAyw5bERxXYI7OwHuR?=
 =?us-ascii?Q?gDL/Uhuk1LOC6mlf5RdC7kSX+IW9YeAgd/qN9jztVQwRnjsrS6EdKFvxxK47?=
 =?us-ascii?Q?Jgp3RcEhGOO12pvM3UrO/MUDid724UIGLkp0QpomN0ltAqTE+Xl562pJ+pbO?=
 =?us-ascii?Q?TQk4osqQEsLimZenp/t8ny1i5s6kZ1aJcRDB94uKET20sqtEiuTU2Lr+guIU?=
 =?us-ascii?Q?hrz/Rr/7rG2+Fu0uQOqsgcOQ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dcfb6b5-0be5-471f-5d69-08d951f56eac
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 18:28:01.6912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7VNyUezcTdB29jScY14obuuFit9i8bqjA+Se3xdPSHPp7+ikVK5u5BEz48iIZHydJ0j0ohKKMqIa/3noeE5mzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6944
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The work for trapping local FDB entries to the CPU in switchdev/DSA
started with the "RX filtering in DSA" series:
https://patchwork.kernel.org/project/netdevbpf/cover/20210629140658.2510288-1-olteanv@gmail.com/
and was continued with further improvements such as "Fan out FDB entries
pointing towards the bridge to all switchdev member ports":
https://patchwork.kernel.org/project/netdevbpf/cover/20210719135140.278938-1-vladimir.oltean@nxp.com/
https://patchwork.kernel.org/project/netdevbpf/cover/20210720173557.999534-1-vladimir.oltean@nxp.com/

There are only 2 more issues left to be addressed (famous last words),
and these are:
- dynamically learned FDB entries towards interfaces foreign to DSA need
  to be replayed too
- adding/deleting a VLAN on a port causes the local FDB entries in that
  VLAN to be prematurely deleted

This patch series addresses both, and patch 2 depends on 1 to work properly.

Vladimir Oltean (2):
  net: bridge: switchdev: replay the entire FDB for each port
  net: bridge: switchdev: treat local FDBs the same as entries towards
    the bridge

 net/bridge/br_fdb.c       | 24 +++++++-----------------
 net/bridge/br_private.h   |  4 ++--
 net/bridge/br_switchdev.c | 16 +++-------------
 3 files changed, 12 insertions(+), 32 deletions(-)

-- 
2.25.1

