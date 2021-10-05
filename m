Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE7B421AFE
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 02:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhJEASB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 20:18:01 -0400
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:30119
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229564AbhJEASA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 20:18:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTub/3jln6dxoqJDhc4tJG8fF+3RwgMfTH1C+ZDSRYpFC2v9kK3fImnnw+0ThWVEv91X+LrjyrK6nrPa665+80EJmrM1h6JS+rFVDcY0YhCc+LzGikX6g04pV3Huz4SSqHDqsd2sILf8UtmsC6lS3N/qQr68QwjgSTB44l6CG9lyc0hmcyYjVsHoSDjIMVh/oDkPD9ZH33dSoHydU8iIinIvfnUvFXU3wk11qsvKgkukplq0oY+mHQvAnVnKit7mFNWhJuNlDsVAuIaX9ri0Wu0H1iMaUxWfS8TUK+EpNgTRwOqumBIoWTk1CkDhUu44BVzcFMnvdesrQEMVygzTxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8baB2jiNsrB8JRTrU3t+m3lLs4qBLOX84GiZqd/1r0o=;
 b=ak4fsN9huOBMQXyuelaKGu37fAN7Qf+vw44tuF/3UMhZk+gC7jTIPj5s6Vf1THJjwICCxyPeZ8e0EeyEq8Fsf23CHLjKyJdz1K/hVi/vp48Bhi5t4jW15/yNDcp4XuAGuyL2IpgrYOHCOk9eyIO+Sc78a31qQ2VzwVAy9zhXYzJPq73vWOY8MyJJMc0uoF1/TAQAVTnB8eHlHhghQNaE7azmhWtUboejmwZzYCfJa0/0UE1AQxORJ/jBwP8yDSTtMjIYPybotSdirJLqscosInYDis3oYNm0wKJ4XMShvZssQIoX2Us2+NpeCbupJJq+ZXjAAWhqOSm7zaS/kcMmcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8baB2jiNsrB8JRTrU3t+m3lLs4qBLOX84GiZqd/1r0o=;
 b=iPLhgeKjrpdSTecDXaO0QV+FoSAjMzJRcH9EGpVVtIBcDWcOwLKWa/KXBxCeYCji18qE6WwIkjKKb60+TLSDF4KW9yU2VIiY9CGNA4Lr0piBmWVIKw0UumcYkc7Te0fzg+CEn8PqW5eh4hIXbQ2IbRZVB/W2E04CC223bQBP7gY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3615.eurprd04.prod.outlook.com (2603:10a6:803:9::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 00:16:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 00:16:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v2 net 0/4] DSA bridge TX forwarding offload fixes - part 1
Date:   Tue,  5 Oct 2021 03:14:10 +0300
Message-Id: <20211005001414.1234318-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P192CA0107.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:8d::48) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM6P192CA0107.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:8d::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 00:16:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56033e30-9a5a-4dc1-cdfc-08d987955450
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3615:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB361513E3138A97BE80F10995E0AF9@VI1PR0402MB3615.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RfkovuHOiJTVzLY7wsIxFWkRke+Y+n8gHVd9svaky3IduiaiRwZ/49o8QZwFk94tXtXABbmcMqMllGpMUTmRfEEpmINz4h265OcDzTR7mmEmP4AxHRwKC/n9Dc7U3Q96he41vH/KvByq4jbthxmXUb3uctmbLJrecLtxFBTi17Mua4Muda/qWmCOz3FqU3lDRyXQioAtlAxpXUf4tKERNSJkPQjcesONVZOlrMbDx2xveI7KHv8rjhAuCNXeBzzkiiuTRgq1IVJJ/RC7iTzHDZdvTWnr2Ib6fq0EGi3eRVEwGXgtXrvWp+85i111tC70Zn5nxS4VkzCe6/98IyaowJn2lGkp+s25baWSfcYZQc1crqEgjU8WmZnytTQmxRQUBwJ6C2L6pmjDxTk5xCAZ9i8ivhxSAmoNIc36D1ylHDcKnjAIcvvdy4PwnwpQJ9WD3UK0vH+OY7bEkFShFfEJkQFh9NndzMnUqNeBRIOHDtWJCT3/iBXnnQI4ZSBhvTlK0NoeCqclWCZSt/mi2BeydZl+vT+9ijv49dopLShV6atD2le/IoucReHpeIvkFXsPXuHJqifuj1FA+oj4e4jLcYNYJuL52YevHwSu4z/6H54a69Yhci7Ey4zESm0akTJp/VT3nql8Q1lEiZcrEHdctWNV1Gw0YVySJB2zTmHeRl0UpZjODCpvcIi2F6tA6oLKN7j3whOvyZfVKo5YvsVb8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(36756003)(38350700002)(110136005)(316002)(8936002)(4326008)(54906003)(83380400001)(956004)(2616005)(26005)(6666004)(5660300002)(6486002)(8676002)(6512007)(66556008)(52116002)(66476007)(186003)(66946007)(1076003)(508600001)(44832011)(38100700002)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OYwudc8xXYW8RiEuX0lwdsGgX82iBo78i6GkWWoLfcgO0fq9mY3aZ14nbQRp?=
 =?us-ascii?Q?NyJ0LjXBr/80UyptOsUDID3tbUz5kMH4qxhDh5tw3O+xOUZw2l+vHX8Jn9vZ?=
 =?us-ascii?Q?RnK+QpA6qQ4IYsDEzuPRjiyIDi5RkWC+ksy/xCYFw3Q9VypmlCWREk9GiTJQ?=
 =?us-ascii?Q?qPkRXqRqkhXW1jsGM+etcwdXsuCxAn2W9GdeKxEZLXUWJMXeiUT0rCJ/LCS3?=
 =?us-ascii?Q?ia/9HK8sGWW8bEqAQ7UsgI8fjqkRQpyk/BJompE3X/WKg6lrfx5Qj4PEWFGF?=
 =?us-ascii?Q?or6QFXC7xzg7gimB/avGcMb9wW9VddHANb2b9WAZ+ZYvEMfHkZXmBXWGUgyH?=
 =?us-ascii?Q?7TKIC745UT3qTkGftu5i4ahb/h/8YOuGvgWiV4q04iDrSGjsV38GCaoF2C5r?=
 =?us-ascii?Q?NXTxgP9r8h2m7dmvE134aVXq70fdzHPwdZIKsx8/4ZBzVd1pKMaUP38+9hxN?=
 =?us-ascii?Q?nhUFBEdOs/gWLds0Dhhicc0IR0zWPIw8MUHSAm0OE855RKiBIDm824N1VQJG?=
 =?us-ascii?Q?JXqCTCOCzEFfORQR9jmh7b6Z3oqvIArucgf7uQei7cp9vh2LsuxK1WjAziHZ?=
 =?us-ascii?Q?TeIIx4mcddBW5ffREVZgh1JYQtrYe98xIpBlJjSRij0OrtGVGiT2GVEoTS77?=
 =?us-ascii?Q?QSHi+IuyDevIm07z/TxoHzDYJ17RRuo3qs346wUs78LB2XqePozrcX0S9ITH?=
 =?us-ascii?Q?LHBPM38QVRwvxbHUySBSoW5xUVutj85tdea3Fh8u+5a81IPl8vRDLmYZPpHM?=
 =?us-ascii?Q?NuZVKNrINADxGLnzFNtMFeHpXZQ51lGeeqPRkkURsHzYBT2occYx/2CKwMp4?=
 =?us-ascii?Q?ABrzYzABZgqH3424Hqw/YfvvT6rG5YB9xPmLVNS2WCuuP/aJZe/5HHrI+wEg?=
 =?us-ascii?Q?iq8RAKRulor9VR2jUjWSdqckJ0pMDNsp0A/lf8mtecBsveWGLQR/KCbGg6ZE?=
 =?us-ascii?Q?lD3pAQ0sWcVNnZM3t3fZrsGZbeDdg6TJ4sQLO9jNO0tqWQ1ZHHnBum06XHql?=
 =?us-ascii?Q?jTztFMrFsAQl6hffQeaMtAgbfKsepMiZL+bfU8mvZ3wZ9TT563ZgCJxoXU4l?=
 =?us-ascii?Q?EnYbV0YtB+UVIHI5ZycxQdLFRUpZQ0Lkvxp/i0BKyaQ95pRK0wa2ak6Tz1k8?=
 =?us-ascii?Q?TbfgcXCssSKOPYs33a8IDPmVGJJUrpd74eTfFoPe8VsvTkYRVVAptdky+va3?=
 =?us-ascii?Q?mweM5vCVaspa0jgEw4wEyokx3BRNF22lLqiIlKHkiZn9guA5uGpAbTxVDkqh?=
 =?us-ascii?Q?6okplMuTlaEmDlnyCWWmw/xeTayKwI31hr8j1Bx4RQJt4dOzRpuhdjWhrynY?=
 =?us-ascii?Q?lEhVpQBcd2p60nySrD2mFs7s?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56033e30-9a5a-4dc1-cdfc-08d987955450
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 00:16:08.6802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9RYhQ7iLpb25gEjsKxsBdCSinHBs60sEOUFgIIvLb06c1zJIOnVHUBUMGED1c6/RusBiY6TB58DcBwl9iOZdIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3615
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is part 1 of a series of fixes to the bridge TX forwarding offload
feature introduced for v5.15. Sadly, the other fixes are so intrusive
that they cannot be reasonably be sent to the "net" tree, as they also
include API changes. So they are left as part 2 for net-next.

Changes in v2:
More patches at Tobias' request.

Vladimir Oltean (4):
  net: dsa: fix bridge_num not getting cleared after ports leaving the
    bridge
  net: dsa: tag_dsa: send packets with TX fwd offload from VLAN-unaware
    bridges using VID 0
  net: dsa: mv88e6xxx: keep the pvid at 0 when VLAN-unaware
  net: dsa: mv88e6xxx: isolate the ATU databases of standalone and
    bridged ports

 MAINTAINERS                      |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c | 112 ++++++++++++++++++++++++++-----
 drivers/net/dsa/mv88e6xxx/chip.h |   9 +++
 drivers/net/dsa/mv88e6xxx/port.c |  21 ++++++
 drivers/net/dsa/mv88e6xxx/port.h |   2 +
 include/linux/dsa/mv88e6xxx.h    |  13 ++++
 net/dsa/dsa2.c                   |   2 +-
 net/dsa/tag_dsa.c                |  28 +++-----
 8 files changed, 150 insertions(+), 38 deletions(-)
 create mode 100644 include/linux/dsa/mv88e6xxx.h

-- 
2.25.1

