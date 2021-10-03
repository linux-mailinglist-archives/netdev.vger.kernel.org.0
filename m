Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0384E42044A
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 00:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhJCWZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 18:25:24 -0400
Received: from mail-am6eur05on2062.outbound.protection.outlook.com ([40.107.22.62]:35009
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231778AbhJCWZW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 18:25:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTJbsSDnQoQtT7CY65YcdWER2/xOevzWUmatpmqhOGIUDCUCM07NcV7A4gIhve85ZQkgnq7OgWq8JSbCoX1dVMKqG0HjD2XbmUJbS2u7zv44olDW629cppXF38pqQeyx2LBYxsEggRp03N6jNDKRRb6801RuTHqIVhRylE2dsdAyj9THsMc+IaUe+cgRWSfylCk6Uulu7T7Nv/cmM/G8IC11O4Z75NYs4FcnngOpzDa78/d4zRWB/3BhIDaFIgdEOHl+yophCESZj5Ms6ehCvbd20R06JGvL7unDjI9aa37bVaPNwtvV0i0PRV2gGFlTDSlLMS1pa4A3gtlIB7ZNRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iea7Fnu4avUrUyb4NhHwZiks5llReoKbEAn2re92g3Y=;
 b=HZwCroEm0q6AOh8ZAe4hkssi5QBA/Hq0Lm2ZSLP6WuTDismD5xEBIhxotkA/NPe6grYiDPygk7g9ZbixiFUD1/KsQuYjf2jktD1CgNYDPJgXrxry+zmSjyEpNXVK/xuLwF5aVH3y7xGnYxfV50KqnJDpGdgcwMOtZYcUR0LNrbxG4d4QGiNsQZTTzL8Ib0QS0Xj67HQ33kWz+FFwlnEZjmWflTRxsIyIyb0d6s41+p+CPcovWcDOH/CPGWP4t9MXFfIA4f9yiKgav8/QOTUucdVg9dNVojIJiNpAvB7GuUrvrH1C3NX0otvNADTb0adOKDG3JD8E87EcoVuwAmxQHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iea7Fnu4avUrUyb4NhHwZiks5llReoKbEAn2re92g3Y=;
 b=UmKjpdzw18iM/c1oNhz8M84slU5IHLB7AbHMy4V85lovDvlgnjVLJPIoJLb90npXre78TVF35nQgC9By2gyCbXqOUw0N4dI/Ayvdo5scg/CQBPzvTRplfUf3ErHnR/GYElGhWmTleMTFUVG6FbK34ZW46nSdRCiSHJKCJJMlcXc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4814.eurprd04.prod.outlook.com (2603:10a6:803:53::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Sun, 3 Oct
 2021 22:23:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Sun, 3 Oct 2021
 22:23:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net 0/2] DSA bridge TX forwarding offload fixes - part 1
Date:   Mon,  4 Oct 2021 01:23:10 +0300
Message-Id: <20211003222312.284175-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR0502CA0068.eurprd05.prod.outlook.com
 (2603:10a6:20b:56::45) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM6PR0502CA0068.eurprd05.prod.outlook.com (2603:10a6:20b:56::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Sun, 3 Oct 2021 22:23:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4171ba1-37b6-4d21-6375-08d986bc6efd
X-MS-TrafficTypeDiagnostic: VI1PR04MB4814:
X-Microsoft-Antispam-PRVS: <VI1PR04MB481404D1BF8C4583B06788D2E0AD9@VI1PR04MB4814.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K/ie2Mvvl3VT5IUXsXpPlG1plofTGFN57iinn/7SxevnNFcpSyTqOscU4FiOt01ni4nAgl3h5/i5Py7w4YSbaGx52hwiO69VJ6yeIU4tbrR6dF1Un23tPtOkYTJZ7etS+1ONQ1/lxBvbVaMtbNn0GwGP2Dy757cKnZf0/LsOCq/cdlT8dNa6ugWeYKoAQPtyyU0+ReWCFAA5g6hnquYUHAfab7LxC2CRLMcU20QByA43cpHIC7mkBLps6AL+qTSuhIDOdbkGCSD3+wiFkHnzFE0NLvggp4Hccxb8/8449mfFW5VrIt12sGoLZeq7qLb3n8AnxBEQMRZmxZzEYrKRq1nVmdavKydntdxD7+YD8+sDpRNuqCkLfyXvy+WyUclp0YJANue7NNfy4tcJc7aGtFQ6nkIJgVTZxxUkxZdCWzjhZsMVHdsbgcTer2G23KayfZ9DtcS4IM7Ka8Bgyu1TzPrDLn388xyQHS85/OHOtSFV6wDIXxS8IoV5F9i06kckEH5CpaZ8Hm62QZ8eAEk8T2+jMF3XgZhkpPqIztvWi1qHYobDSOZczJfWqher1yqeCFt6/96Asr86tM5tSFYYKdOcy6XMmVBqoj962yW0bwRDZV4sEHqLYTPkt08wbqq2utCoyrzfd3fmQEBzcziT0GUPfGfI0q7NkAnQ3+kXvCfcZDRrfY49euyEqJFJLIAMVNDJ+tAyfdrFVJRoxCjUUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(4744005)(5660300002)(38350700002)(1076003)(8676002)(38100700002)(44832011)(54906003)(316002)(508600001)(6666004)(8936002)(36756003)(66476007)(66556008)(186003)(6506007)(956004)(83380400001)(4326008)(2906002)(26005)(6486002)(110136005)(86362001)(2616005)(52116002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pkx/b2khNlYkD0aHK5GT1GxrPrapO9GzgFS5/AQOuYk0lw9+mYWPBkIQbxJj?=
 =?us-ascii?Q?TFQs5kLic35VUTuhpZkdoYLFXjwztmwRU4YWkOlZacUrYxfVDy1xxaUXAB4S?=
 =?us-ascii?Q?L/5A8QyvlG9d2cVZ/IqO7v/KEPGMD8Ow4X+uNzQ8PlKw8nfFBOChig9Jy8gn?=
 =?us-ascii?Q?LdlrV7LjX5xUOUbNOhA5Zav80ruCqaxrQC9mXa69a9ONY4B0jKUxhYhJJmQE?=
 =?us-ascii?Q?q0D07u0NgW9oqDwF+G3jthTqTJhg63YJZbfbgNGcpLAW9236orBIeIwI2GUK?=
 =?us-ascii?Q?SbEvTSeDQyT2Qg6ingJCIEFU4I5uLcbEHX9XYW2EyjWXx6ZEo58XrpjcPGIK?=
 =?us-ascii?Q?XgSMSebYbZ4ABmEHGkS4Zqtmi4Nj5ZoPgOUkpAh7Igf9OtFzWzg+4BYRzMaO?=
 =?us-ascii?Q?4zxO7PJmXJ/6iR5SsKqTVgfghQM3wl/agKO4cs0kWQ3l5AmPs369NwClPOxP?=
 =?us-ascii?Q?3CLqV82truRRaU1NkNrgrVcFzvCr0lzsD08RKMI65L5PB/rY+33GeKdl+hps?=
 =?us-ascii?Q?YY6KeG2SaiqXmXAtZ4MnQw51+Cgiv+pyUNBBn2tIN19NMVFqjx7oUiTGPzhO?=
 =?us-ascii?Q?ehpjT8vlr31hoSTE2khn8cW2IogZDlR3bCmwk/kkXmql/toCIXbxW9nJu8oy?=
 =?us-ascii?Q?a6pmKrWHNhlsjzso+vnlYYv1+hdR7NS+NT6KVetjbNaASCfnYkl+bqfpMcgO?=
 =?us-ascii?Q?P96Ra2V2f2rc1IfTHtrI9YN3nMTHiU1bDsGzt40tf+7KAGYgXWxXdVNRxRiI?=
 =?us-ascii?Q?DHJvxVBZ/glQ8AE2wEZs87PrI6XyXj5oI7si+mGaNY2XTwX0qoFv0o/srHEb?=
 =?us-ascii?Q?kXscUCIaGXLjgsC2K37WEnvPf+WUAFuODJGS5gO3UzAi6m/NnlLwTh4rOYWr?=
 =?us-ascii?Q?NLi3WEHTwZPAK9DewdQX0GoINbS51fmJdI4OYm+NMXd5ThqP4cPgdc32PNAU?=
 =?us-ascii?Q?e56qAEqyXYrmALzQQphmFqfAOd29sFyinyiveRU9yKZTTrlXtnn2R15Cnxcn?=
 =?us-ascii?Q?X4tq1426hw3ZlG1RxwSBP2agLtfIoXP/m5s65HFkpmJnqELbJ3jiXFbxCySV?=
 =?us-ascii?Q?CuvGi7c20NTo+KPbCZOQe4B4ius5pGfgy7MJdsw9mKI5MtWiuPUg7dH7nDnR?=
 =?us-ascii?Q?Yo+rJiP55VWlHot8HUYPM5RmlzdQOM39I5fDEvZRrmq8NObc50pQmTb93Wg2?=
 =?us-ascii?Q?dmOv7k8IKY3BKl//PR885pDge6Sz5qRS/LExTu0ajnQmKl2g0P75C6rr4JRA?=
 =?us-ascii?Q?782g5IuckBzqhuzW+ti0smbbKKgYNIbAve2wIsnVVykwPMhK1WyWuYVsaD0W?=
 =?us-ascii?Q?Zp1ZzT5ZPqMphxIyjYbseaul?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4171ba1-37b6-4d21-6375-08d986bc6efd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2021 22:23:32.5928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T3wsPIbXhqL8jS3voW/mo2PH1wxsA7a3AgeyGxr4WIC+/csiPerS1W2o2Q9xvv+a827rMqyCmGFiBQaKxhg5PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4814
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is part 1 of a series of fixes to the bridge TX forwarding offload
feature introduced for v5.15. Sadly, the other fixes are so intrusive
that they cannot be reasonably be sent to the "net" tree, as they also
include API changes. So they are left as part 2 for net-next.

Vladimir Oltean (2):
  net: dsa: tag_dsa: send packets with TX fwd offload from VLAN-unaware
    bridges using VID 0
  net: dsa: fix bridge_num not getting cleared after ports leaving the
    bridge

 net/dsa/dsa2.c    |  2 +-
 net/dsa/tag_dsa.c | 20 ++------------------
 2 files changed, 3 insertions(+), 19 deletions(-)

-- 
2.25.1

