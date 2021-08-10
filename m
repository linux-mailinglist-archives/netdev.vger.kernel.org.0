Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152C63E58F0
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240061AbhHJLUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:20:34 -0400
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:44879
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237252AbhHJLUd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:20:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ap/itRbLlw2Wf2keRWwYsKufcRFznjbo7fEwiOea7i800IPigAFlrSGM6CuBjQYZpE7MxFO/U+s7JmTXgdA/uJaXd+/mhq+dN0CyK5QieRjhG+zS/B09/Z8u8GpWwfrfk3WhFLpNwlIyfUrLhPp+hv2WYbl6l3tJPGGMfSih2qTHJsEYJ7/tvOlMckvQdHi6hue5F64fxuWjw+ZFo0PWM77uUUSVkHIZE2Wuim22E9HdnTghEeHZBYFzUbkqZfkczcGeeMK0JEvU1gJ6a1vuYew0Udz6Gxe6ZCqlXoK3tbvq79nQZd4fuC/K8ldplIz36CQyF7wZSVi68LQvNQax+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0w8o6wsbuFSjZjeYGTGqdx27e9kH0gmbBQiHhtZOO6Q=;
 b=XJoRwZoYFTPvU6ZCbO51yz2CKFVGn9buZomtv/gpFdgNM0fBo5gpYqlKxEBz3i1bWqj80dTGR93aZycAjTxqJYkE87fo/6jygh0y8dnP3eZeTbtYAmsrAzR1gqzv2D4dkPlA0uek8aPZmP0YlV1lnddV+1xSKJruvDJEfMzg5mGraJcLy6/qgGnojEKnDmn6r3pCX2DQfWOxA5QEWxyMyPNdm5faA1M622oIicAPjAQKcg+PQwQGkjtrzDCEt57LgTMMcoXN4Fo2Kf34Wibm32iZnUv3+S5TFEVU0dvjE5vq0aAbhDcgWdRdDM/T6x5/ZngSddy4EsZhgoUXmyXO6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0w8o6wsbuFSjZjeYGTGqdx27e9kH0gmbBQiHhtZOO6Q=;
 b=pGFiQaatF+AGKxtvLreCfUIy2JcWYjHkxCImZyN5sR6/VtwLWiMGaeCegLQ+ey1n6DQVzS2uWRv7H2ZRzlvX0zYT6LCGYA4aG2YPbRbmUJ61U/FWU2a1PuXCI2lsxjc3QoknML23At4txHoz0oMTdogdQrmu7sLTQ/0F5go435s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4686.eurprd04.prod.outlook.com (2603:10a6:803:71::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Tue, 10 Aug
 2021 11:20:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 11:20:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>
Subject: [PATCH net 0/4] Fix broken backpressure during FDB dump in DSA drivers
Date:   Tue, 10 Aug 2021 14:19:52 +0300
Message-Id: <20210810111956.1609499-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P195CA0007.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:102:b6::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by PR3P195CA0007.EURP195.PROD.OUTLOOK.COM (2603:10a6:102:b6::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Tue, 10 Aug 2021 11:20:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20b57fb3-be72-4aac-4c95-08d95bf0cfdf
X-MS-TrafficTypeDiagnostic: VI1PR04MB4686:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4686AA6C1FD3EF25385A38D2E0F79@VI1PR04MB4686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NzI8iAN+swWKL2AZzWfI8g7+2LuxIm8m5CyIsvJ9JCOWAOwqF4AsVJHrKAid8ckWZjfpGyUWXmRENxX2AsZMIuHwKKqcWuzd3DqumLVyZb7qMUquH/cvLN2CypdGotYYS2Mp1Hhof9KPkBEVPS8xniNd/mSNn7m39dG5y9F8uL8FaO5YJFXZe3IUbRrq0ObmJbdiSjvEuNH+w6srTnCkUSBgAcW5mtIqXALory5HTRk6MCoi1Pw0YQvaa4nllj8BBpI5O3OuoXvThaaXnTFQcnCu1DByZJXeeZNLot0lpjQ8X4FLzwwoREKGi2940pNIxUKbrm0j+geX2jHsVwiZ0UTXgrAGgqjzKKl3VWAtRj9FD4/FCaHOML/VKcB352h7MxnLK1NLDJJiZt4jWwEOfisPsf9GDhNGbMp3tjQcKXduWtQlyOmSVCFAu8lk+0JTm1UeW57QP0qVHI4DWGwopPR308vy8N1KdI4ZMeWw+Ex6KAjiGsKoO/8XP7jsHPaNuyWcrJVF6H4ulJGk3MvmslFGOGGS4/7BvVl9wyjneJGEgCl0zmP+VcRnWt6n/+2byk5WwiAbsly/1N8UCWLdGxzXp1kB9M3kvq2SVlHgaNYGsx8X/PgP0Z7yt0T3Qw8NzxMBes3X7FwhjWYl5TGjyPCZOXc9rRguVRQqkQh/oJZzUbV6ltn/SoIaq0nWkcRGVPjnAryo4I+vhQjeQAcAvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(7416002)(86362001)(6486002)(6512007)(36756003)(956004)(44832011)(2616005)(8676002)(316002)(4326008)(6506007)(66476007)(52116002)(66556008)(66946007)(26005)(186003)(478600001)(38350700002)(38100700002)(2906002)(1076003)(8936002)(5660300002)(110136005)(54906003)(6666004)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JGpFQF9xXNKTgDOc47nePzSDRb4YnRFLiogYsXUjUXjnF/a4NNrf7aQeG+06?=
 =?us-ascii?Q?1ov5Rd7L5ibzSqMfGpjMaqHQ1mrCIKMLf4jkmz0d8H82mbrjcLBAxPO40wj6?=
 =?us-ascii?Q?dIGxJ8QGBX+Cwe/m/S7vr9VeY1VDvS32ThihZawH1zq2/e4QduwKkUUvOkg6?=
 =?us-ascii?Q?Ilo7lVRGaL4VUAWwPSZjzBnkQ3OvyBQ8ZMnGJHTp9+cERshEb+COKHzAqLog?=
 =?us-ascii?Q?N+cmrNsYFNjzYTUmjf+y+Kq7M+b4LrerPrsjYdMc6upxicItmrPdaJZROHdU?=
 =?us-ascii?Q?U1OpPS4z0qoWbmFeTZBZm2HuEOz4ziBkz5igQyscskzHTjOgU9zQsYDdpnw/?=
 =?us-ascii?Q?HKqK0kVKyah+LxKFH5APSvWU6A52yXLkxuuHQpyGIgZPhrQHYDaq3/95SFoo?=
 =?us-ascii?Q?5QeWKj/PN9U8GWgmGyEx0bvOl5ZYTBO79FRZIEWwUIAaKClSx/BwBPNfuMf3?=
 =?us-ascii?Q?IHlkQSUoWqbgQNyds1dmErkpYfHQuAn2MvAikF8wEjp0B6VysqnfyCcMml5O?=
 =?us-ascii?Q?riT6PPZvGTenuxG3q0BktAeFxncAlwvS2w0FiSUuXOizZWGL42nKSr1vGqCK?=
 =?us-ascii?Q?lSvXs/zQg2d4K7cNz9LMcXHK6A6xJjHnZYGp7Sqk2VwTYPTyZ9e10rR9/3Sb?=
 =?us-ascii?Q?zwSjvdoU7uk1C2/93aIc4J0Htj5dQDD3w7tbKzO1NENiX+YMgCKBGg20yTsa?=
 =?us-ascii?Q?aqiWfjKjmsfKnPGzKLvXwuOnpAlLnU3sOuyV3Nm3zsVsO1/i3N9hpVoRfN2B?=
 =?us-ascii?Q?pGzl3stwhCyWrlICcFG/7/hlIQYDZLshAX/22KGtJLoJDTuQDJiVxYUiu1yR?=
 =?us-ascii?Q?KQcGD+n4Mzl1qWBqS3cDlqD2o6YdDhKH+P8D2bllvSAE1tLFpnvs8AYe3GfB?=
 =?us-ascii?Q?0FBkQCwlEjoIAVGOAxwJsREQUgMKQrtg/f5maENHI8U0nwZQIyS83u+iYpkR?=
 =?us-ascii?Q?UM5rBg7BHPG7zgS24ONFbU5seKGC7gavRWEtyeJIpvtDJMqna2cD1vLfzN5F?=
 =?us-ascii?Q?kpghy3FisGusKwKko1AB10IUFYU6IZ/Ae4fYJ25VKa5Z61OtktyXAVVOj7sI?=
 =?us-ascii?Q?2V3NDf+tuNv+8Vg9xtT9dO6SBpuyTOYwTgLj/zYY2uaayqd7BTsqkNw9PStm?=
 =?us-ascii?Q?Du4tlwbhg2ltOjJlCJgScLsLNOCynf9/p/24AeYukXIlAv3CTmSBYJzQx01H?=
 =?us-ascii?Q?W1mh9ihG4Xnz96jO4uvSpriQydMoleXE3XYKQKus0HvXEE/k+KLdpRfaD3Dc?=
 =?us-ascii?Q?t+xgda5mdYByTRIF6DWKB14QMQIyMEDXaXm7PKMJBNM0nTwdcZqdhUhlr19j?=
 =?us-ascii?Q?4b/evRRlxWIpqfTDVU4F4Jde?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20b57fb3-be72-4aac-4c95-08d95bf0cfdf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 11:20:08.9041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yTOEfOfFyjHiCn8RmnEN4BB8pGNPlXrrjREWML//MgyOLKoWRe48UvjhIxWv3WBm7WSE2Tegey6gJ7QGqerl+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtnl_fdb_dump() has logic to split a dump of PF_BRIDGE neighbors into
multiple netlink skbs if the buffer provided by user space is too small
(one buffer will typically handle a few hundred FDB entries).

When the current buffer becomes full, nlmsg_put() in
dsa_slave_port_fdb_do_dump() returns -EMSGSIZE and DSA saves the index
of the last dumped FDB entry, returns to rtnl_fdb_dump() up to that
point, and then the dump resumes on the same port with a new skb, and
FDB entries up to the saved index are simply skipped.

Since dsa_slave_port_fdb_do_dump() is pointed to by the "cb" passed to
drivers, then drivers must check for the -EMSGSIZE error code returned
by it. Otherwise, when a netlink skb becomes full, DSA will no longer
save newly dumped FDB entries to it, but the driver will continue
dumping. So FDB entries will be missing from the dump.

DSA is one of the few switchdev drivers that have an .ndo_fdb_dump
implementation, because of the assumption that the hardware and software
FDBs cannot be efficiently kept in sync via SWITCHDEV_FDB_ADD_TO_BRIDGE.
Other drivers with a home-cooked .ndo_fdb_dump implementation are
ocelot and dpaa2-switch. These appear to do the correct thing, as do the
other DSA drivers, so nothing else appears to need fixing.

Vladimir Oltean (4):
  net: dsa: hellcreek: fix broken backpressure in .port_fdb_dump
  net: dsa: lan9303: fix broken backpressure in .port_fdb_dump
  net: dsa: lantiq: fix broken backpressure in .port_fdb_dump
  net: dsa: sja1105: fix broken backpressure in .port_fdb_dump

 drivers/net/dsa/hirschmann/hellcreek.c |  7 ++++--
 drivers/net/dsa/lan9303-core.c         | 34 ++++++++++++++------------
 drivers/net/dsa/lantiq_gswip.c         | 14 ++++++++---
 drivers/net/dsa/sja1105/sja1105_main.c |  4 ++-
 4 files changed, 37 insertions(+), 22 deletions(-)

-- 
2.25.1

