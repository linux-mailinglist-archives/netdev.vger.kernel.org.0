Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981C746F239
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbhLIRnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:43:20 -0500
Received: from mail-eopbgr140049.outbound.protection.outlook.com ([40.107.14.49]:14725
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231476AbhLIRnT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 12:43:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HK7bPQbp4dvkMol0i6JEVzo3l4MjmDwJJzZd8a0FSlTprUgRoRl9C2daQxANE7ycqnOSEaI18nYTDLWr3fpJ6Y97lszwfB1b139NYzakYU89W97wMPg2paV1szSKN+ZEusO73m6BLX3R7z1awhI6pBz0G9FLa2PYcHg6ckyDIcF6YsQ+/7GgT8pIl8gNfCvax7kWfIZIVuZi9sJTQowvqdoSDMGii/0Rcy4nUAycJ2AFOKj0v4992L8FgsB1vfw6PkO+mdABhS/7DcRtxbF+a9guZhdHtqvNPT6NdCVW6r8RO+v2fAYUYN7V78QSP/lCzHFvXAA6ObyyQ7knhyJ/ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JhvVevCe64vTv9Dj3Gl+RttiP1wmGloM3bJ5ZE82dsE=;
 b=GPZqbzNJnI596K7wA85itmuQuyCbTGgFLPSyNCrJ+GshycELb2c2ukTWaB4/a0f0J0mlQCjcsF/O2/PPJNEnOSfuh1oDeuN/fekHffofWrSvpXmgsx1HS1m62Tw11M9UxtZpBQYFmnNDCvJwtV/NbvC0eSTBmCPOt0x+UUWIswAncf3fs01JP65ceYvxwgCOhsYZSdTsubeAjsMoqVf28bAYf5W8xilOph6SGVDFANWlrYDomRuMlTB9kuWWOnakKi11CXZeiHM/bu8V9ogfbSujF18A+4h41Hs2kDUVgqWKRaPPW+8QrLdVTcoaRGcwhc9lZKoCMjcQvH6WHKRZJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JhvVevCe64vTv9Dj3Gl+RttiP1wmGloM3bJ5ZE82dsE=;
 b=FgnDttbo+xrKhPEM5gfevZrmOhbtqN8TH4PjJSAtNs6I0vctDJnBH3D9Xhrodi4+Q8gTsHVseRhxuofHQb9EC+Aagj/QlXzO/2fbn+Lt7zjtWHT8tHTqL4LYvTqknZ+pbHiDg0EukE3dlHbrslneHFipw2qSdzGN6YcIxr7bOHI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7216.eurprd04.prod.outlook.com (2603:10a6:800:1b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 17:39:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 17:39:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v2 net-next 0/4] DSA master state tracking
Date:   Thu,  9 Dec 2021 19:39:23 +0200
Message-Id: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0059.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::48) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by VI1P195CA0059.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:5a::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Thu, 9 Dec 2021 17:39:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d6fb52a-5ebd-4b65-639d-08d9bb3ae2be
X-MS-TrafficTypeDiagnostic: VE1PR04MB7216:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB72169C5EF6D4838EB1B67328E0709@VE1PR04MB7216.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EoenH68XC+NFuy36d2TmHrYBS3z96KLzI7Fg7a5Tnix9t9XKvO/jaEwqXGcL2F+PkLQqTwPf2FtQDmwhKwNDOA+4SrIotEWZAd1J+x+fPh2NTx4pbMHf/LwMUdcv9WbL0Bu8jb92GnJxKxH3oQ77BpAj7PxPKmn8CRoSj1LuCWIcwEx/uOpCoq9oW3DJ5I2RkbJv4TRS1wdEWmkNopt5353lQyQzmeSW2vDyvrNXG1gyI1J3mhXnikDXfO8DlIg5E7q89jaZKD9ElHKu1+bvXwKybjbPW6Y8yuOSs2NG5n+X4v2vLW+0RkyWlk3RrqxNfAhlRN4iV9aPy4aABMXpW6WWnVlqZVon79QjSHOB62NFkpySwPTB32LXnA+vFNrkOUm5Rz4Tjd0qrMy6N5vnMZgEZAgN8vAx8mk1h5gCiitwoNufIxGXqfdlfn0c2+7DzHDORpaStA3w58+gLC0KJs5rma5QVHR6K0AxmxRA+LU2GQLcpUIvA5ndsqnBEyWDpfxynEFh2CFfR+j5YBpzPC+yEENaduWGFASaYOb3IBrMpCE0L6ni1IFxBDPo0BRjaB7rsUvxBIkkpGsf1qG1nM5AzU++jsfkEscj03wpdGajsyWi8uETAGpxOSfI7vLEYZP3lue3bGqWn81MZjF45CDh1nKjXLNdCKUAQZH4fihah6yi5g29xnf8onuBUgpcgkvhWCyPma+FZr480/MqidcJpV+MCj7JkDaoJNOy9v3JqhvmWe2/3eoKJ8VtIF1ed2q0nUG8/bC9qwMbY11lYt6giRajfEBC+FIuBy0hv+A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(6666004)(5660300002)(1076003)(44832011)(508600001)(6916009)(8936002)(956004)(8676002)(66946007)(4326008)(66476007)(66556008)(966005)(86362001)(2616005)(6486002)(26005)(186003)(83380400001)(6512007)(54906003)(38100700002)(38350700002)(2906002)(36756003)(6506007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k8THQxLETuceXibfj+lnTD5ZmxUWCPgxMYtpUmmwuZq6yMcnVk36S/ZMRVU3?=
 =?us-ascii?Q?1/6W8OBx2hvVrNhVmrZtQf880Qb7a0XzeV2BlcLBekkrQNX8O4I3yqj7JS/y?=
 =?us-ascii?Q?uMmrUqtI1JgLQwf0HdP7+pF9k9+YtjltBXqxD5ZHMMqNcBPqNSVA0U25d1Lg?=
 =?us-ascii?Q?5lJepSPGMHdHDtMrweLpp6jyzYs9VwXChFPZ0GStr6g+eJFjV/7+GPgAvaSP?=
 =?us-ascii?Q?EqE/vvPWxSD0+f6zWABlO2sDb1cYWgjDWkqO3jc5z+M3XJ93oLvh6I/nwrb1?=
 =?us-ascii?Q?PvHA1xkBfCSLdvc9u2W9FrCErARdZSqLwrgV9pSOgL9FBYWcwWqZzw7xidFY?=
 =?us-ascii?Q?ob+rOVDWNv6DIvueEHGTR7f7+1d88uITd1PtO0w/OAwN7FcLKk2HsfK0Y7ZI?=
 =?us-ascii?Q?BT4m9UZ+c7WOS4VzyCIRWcHiF4Pf8Svm/IGofl7AipEpCw7EDCAS6HYMCUX+?=
 =?us-ascii?Q?X7xlnXYHDUBQ3NScCLjipR6KG66xOwb1LlWFwvqVaoBU1PfWl+g1T7HUluKw?=
 =?us-ascii?Q?J4ZBX2MNNU8+YXWi66mGqQOcSJ019wWOxlrJTj4l5YcODjPkzuA5F1jO3OL/?=
 =?us-ascii?Q?q2m5DdDqqus/62t2jroMJn41uQsGnWW6lk32L9z6O6C4jGjuJ/PE9GtvEO45?=
 =?us-ascii?Q?V9/Q4aPon2Tk7ATesdQpfeQhKNYCzSVnmVZw+k3h9FNbL94HNHvEVq0Xcs8U?=
 =?us-ascii?Q?FZnmpoWkmPPkN4nsZ8JcSYlgpexdZDTRqOnmhFIZHPEH1zj2Coul4u2/QOCX?=
 =?us-ascii?Q?pIK+HkZigi0bW+UJsuMyqVuqhDSY1/QPf6DNnuuQggNisQWnqVHZbiI/vxgS?=
 =?us-ascii?Q?AvxbYCIi1srRIw/HwM4Cl1zZO32SUD3s8DrPqOEkRBws8Dj0OhwzKmeYhmUn?=
 =?us-ascii?Q?IFbwGfRN3DjDoFlpP+AAC++NSa/gJkfCeNPm1da706qzwjdFrGIdhGiXJxOP?=
 =?us-ascii?Q?xL6HPDTjjo0UWf2D52XtJ0U/2eKQ8UqvOl7OHSZQ3pTlB9Fepw1XcWVGrke9?=
 =?us-ascii?Q?Djb4H5/tGETN8xD18yHCKJnwSKo+EuxY5kF4+Q8bs8XISB1CDTgJMKmqNWL4?=
 =?us-ascii?Q?FkO2a5Zgq5SWIU6P/UwO7y47Kl/tclc1jwjJnwYf9/Mz02vWarHHv041Hthy?=
 =?us-ascii?Q?0SfWIYvfIPBhLzKGqDcu/VFRdJpJFvVnH+tet/DMfrO11QEcE/mpiK3oushU?=
 =?us-ascii?Q?T/0ZfhsJlQeZuxAl4YDpD54Hi/queJTcduhyoYhOK8Sryhp3WfMrK3Z4JTZ4?=
 =?us-ascii?Q?ij3C/vDAvwC8qw8j5gY1YZ41XEwg964DiMJsTrBghOQ04XuSkXp/06dXl2tf?=
 =?us-ascii?Q?4jG4OTa27tgMYuZcYUcl108MhWRz2jOod/WEPu+lBCojXdmRy4XrbSZZclt1?=
 =?us-ascii?Q?9BJyCnLIBjxIkkOqMbeHjjmNhk4K7dCkLboGo7aaN54Hatq0nvDmd1gHmH9i?=
 =?us-ascii?Q?8AxC5on2fnIFmXMjhmOsVHMrqNX8brpnMh2U9WEx28rD3DHVEVkmRZWNraFt?=
 =?us-ascii?Q?U5XN9wcm0YHj/2RHSRedrWfGQmi8pb61YZEqI6aNQSws9ioBU0hPzp+Gy+q1?=
 =?us-ascii?Q?9kj15TCIraKPqJcGUe9Foa912JLzs59o+aBVJJQss2TKe9cU/mEf4VFEznMx?=
 =?us-ascii?Q?XuSQqajovm1qSjrWpIolKSw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d6fb52a-5ebd-4b65-639d-08d9bb3ae2be
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 17:39:43.8761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yLdntpAwtM/e/NfTNZUIYiFR1z5nYHVInfA1QYYwIXVhWfyoQLAetkMHcnqBxQVZkwAM6WMGoMtCXSZYXZKjZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7216
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is provided solely for review purposes (therefore not to
be applied anywhere) and for Ansuel to test whether they resolve the
slowdown reported here:
https://patchwork.kernel.org/project/netdevbpf/cover/20211207145942.7444-1-ansuelsmth@gmail.com/

The patches posted here are mainly to offer a consistent
"master_state_change" chain of events to switches, without duplicates,
and always starting with operational=true and ending with
operational=false. This way, drivers should know when they can perform
Ethernet-based register access, and need not care about more than that.

Changes in v2:
- dropped some useless patches
- also check master operstate.

Vladimir Oltean (4):
  net: dsa: provide switch operations for tracking the master state
  net: dsa: stop updating master MTU from master.c
  net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
  net: dsa: replay master state events in
    dsa_tree_{setup,teardown}_master

 include/net/dsa.h  | 11 +++++++
 net/dsa/dsa2.c     | 80 +++++++++++++++++++++++++++++++++++++++++++---
 net/dsa/dsa_priv.h | 13 ++++++++
 net/dsa/master.c   | 29 ++---------------
 net/dsa/slave.c    | 27 ++++++++++++++++
 net/dsa/switch.c   | 15 +++++++++
 6 files changed, 145 insertions(+), 30 deletions(-)

-- 
2.25.1

