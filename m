Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40E540D12D
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 03:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbhIPBZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 21:25:28 -0400
Received: from mail-mw2nam12on2138.outbound.protection.outlook.com ([40.107.244.138]:22337
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229816AbhIPBZZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 21:25:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XihfSW0ysefBdZB5SduinvOS68oEit8eyiE03dyv2JHecNkCsa5v4/b24s0rLa8LL/gSOCMf2c9oq4/xhCIAuTediP3rZu1x5d8TmBVr04dxGSHY/vOuYtY1G5RgJaWqp0np0TeJHJ8RQDikRzU4mDu8qoM2bZWUBQnEJLrcbkX8Sz2izh0mshuhZQIKAHMcUmcMTFXLaKBfZOYXHYKyz6PPSlrEqGY9f6IIj7iOgW1lq0x1HASLfvYwFXYOsWyll18pAxnxhlyOa9/z2cgDzfuJW7nl3tE24HG/ovQxuk+dLuBs9XQCs0U5N6EOUfCB013q6hnVQF8/UIfG9M8rGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=W+nYrNRTczcC/F+zm3qOYKT0wSVCAHDK92oah3UepVs=;
 b=POu/cAI72ORSnw7huB96/vF6r7eT3rOB9iT+bI49I7CcTnqXUIPcTVDJteTragefUx5NtahoW2BWnXp5jGPZx4dd+cfsfM4Gvd67KIDE3sLxM1SPBIELP1DbpEiZtgpNC/QlLY/mH67b32kfRKyQFbWUSxhxSbgbv5nsHUF1NmsW3Zb13PVjCQe+cNa57f3dvqNsUyI4yoscUVSihSa3WGf/Ik8cVCsJhrfQ4c5MAWbD1OegmReQxJwY/4Rxitk4se7h+CqawwqdDz/nj/VEB03HdckCYUq0eG7UK+nlcJV0/OIR5GYBz4Ur4x3wPdzlAr96C/NavoCtmb38gQL3Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+nYrNRTczcC/F+zm3qOYKT0wSVCAHDK92oah3UepVs=;
 b=KbWrrxDzZnsaTSONJjobG7Z8xwT5J60wp9/6vZ8hc550xQbgEc3buylNEj/o486Rz9nDX/3woPd2xpOlAdZ/F4gThxpaCCbJQJjVXmNgvYh/5UTmAXTjceRDvrS6YaC5D8sBU7duQxznvfgvBNreMMaBebUBK9mTMIdX0gL7RLI=
Authentication-Results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5633.namprd10.prod.outlook.com
 (2603:10b6:303:148::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Thu, 16 Sep
 2021 01:24:01 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93%7]) with mapi id 15.20.4500.020; Thu, 16 Sep 2021
 01:24:01 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     colin.foster@in-advantage.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 net] net: mscc: ocelot: remove buggy duplicate write to DEV_CLOCK_CFG
Date:   Wed, 15 Sep 2021 18:23:40 -0700
Message-Id: <20210916012341.518512-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0129.namprd03.prod.outlook.com
 (2603:10b6:303:8c::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MW4PR03CA0129.namprd03.prod.outlook.com (2603:10b6:303:8c::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 01:24:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ca47370-443a-42bf-5b4b-08d978b0a9eb
X-MS-TrafficTypeDiagnostic: CO6PR10MB5633:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB5633B2261F86157236748972A4DC9@CO6PR10MB5633.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0GyFAebY4BTFoWy5fM2DPFZynoegu3HUpvA3+d8ge21DLnTDcSXj+LMDdNa4c+aMUFZT8Ai9LtyDgTja9TVTk8TEKfKsg2Hr1tJP8DnHjPJUPei0592Y6/WTYp0yIct+gG/MUoJmLdSCvYSouCedewXfmEXTJLPLIwWbI4/klVdC02Eep44PJY+xI00dny/laM0ta/UdWVh3clSowpcM+uNYlgAx0EVUz9ArRdb8kgfGgefQpTjHF+jFM8E6ZiacojPCTxRIGyhppg6Qff+PjHWRuiB63VChuF9GcR+aQQ2owf4IVIn36dzAI9eH3fN9577UOn6XCJh80Ab2r8B7eZXS44OhURpzV//BmJ0Z9mLaFQnrJMxMbsKPEUauCwNH9c3nMrdrjy2qruLoNkUn/9D3sJkoeRtVJ6c7UL7tCIVlJTxqavbYJ6Bp6mdU5GQqZW7XbrRqKPm9Dw+n/fNIHivVqDvNSh6xfWahjR23VindEmfGxRRQ1cgEhcuj3iRFK+fgue0MXxsSaiSQWfB6K/y4Mcnqk7mDT41ng2yJdjw7GlUZCKhZFH2GUxkyjENqgnoWIEyw5qOb1NfSEyEj78CuyR/lHo4OmHOHNaGdKLTmAHgHRzK7so1iwu/4nfNArbEf9KcGm3RRoz9kncByw/EogPCasX3CXwGBA9I+OVdX2enJsqc9O/03jmyDbt3y0CfvPqzed3xTlwb9pD7T4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(366004)(39830400003)(136003)(52116002)(6506007)(110136005)(186003)(956004)(2616005)(26005)(66946007)(66476007)(5660300002)(86362001)(66556008)(6666004)(1076003)(44832011)(36756003)(83380400001)(8676002)(2906002)(8936002)(4326008)(478600001)(6512007)(316002)(38100700002)(38350700002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?noKo9o8NBe0DnAvIOSvm9fX7soFvgVm1xhTvQXWtt+XqjLFcSefq5wp1/Cy+?=
 =?us-ascii?Q?YiH/XqkiKbJiI4URSaHahaQCiqqX/aiYFy6obPYo50Pa+cmYo94ex1p0Ya+s?=
 =?us-ascii?Q?uE7moX/GV3vcxWQS9uPgbGzjAdPReZTvSVGWXhDic/0+yB2mGxu2XlL+S8gV?=
 =?us-ascii?Q?MveEk+TS2i6ywGgPiMXGl1q+J6yInbNfBtG7VSf9ekMQp/AQVk1RUCrtkkjA?=
 =?us-ascii?Q?sJcpyuUXVbvh915GgLa1iNbW/oQ/XQqqdHREcvTHYCvm0AJrsnF4ncmmDXIH?=
 =?us-ascii?Q?pBfFPfkX8Xt2abvSpSxQ3P8bYaHekQg1crkT1k6TgjwhGfI9b8AnlBa4VZ2w?=
 =?us-ascii?Q?f62lyXKp34OaExdavmPG46pEAv+FWrkJW2V1RQvcF+11nOM1EdueyU2Sz33m?=
 =?us-ascii?Q?ntdFnB+RKCV8DCG6abP7S7ncZ/8Rn0ecH80JQft8US0juVVbvIoLOWDVZrmb?=
 =?us-ascii?Q?aFzEpeWZR3tMOPbhHmcVLof87tq4H2mJv1DFfmFKJbr9GvQVSe6qdQHYjaal?=
 =?us-ascii?Q?cKCjYP/7mvOJfrz5racNDIhGt0MnD5nJQp0CpHw7hws/UQ6dKDOG2u2LzJIy?=
 =?us-ascii?Q?WnGyrFA+L8EjzivpbDLw6nfvmbHER6w1DSjS1464Rvf/JIjubSBFb+UILBP5?=
 =?us-ascii?Q?0YqJ9Zyvz5llNPuVyeKcfRU/HOq5oPCL1Dhg/QpUMJFSP8CR6D6RNrk7PIGA?=
 =?us-ascii?Q?7sCFQUVS7IJPG8uh1uq4gREi5aqZwFuXmRfQWXjtFEa28MLyuAKAfQg3131G?=
 =?us-ascii?Q?9HkK5WBk08gsO0aLtnjgZl7/lFYmAUnW4vAierpLxHRSsJ5/VEq2gEtxP1Q0?=
 =?us-ascii?Q?xHRHNoZpfWYoNWa7FZRXOA74XKoa9CoKf/dXsRMp6JAsZaPZxn+dcAf2i3uQ?=
 =?us-ascii?Q?QCyTLTmbLq6xWsYHjyZu1PO4U9faS+Q6Llo3/DGXL8isVv7xSMU2XEyxHxGH?=
 =?us-ascii?Q?PjRYgix+GqrxoxHI4334S2+/JR1GLvZ1SLsQ2+1ign3r1O51A5ZbslVNOocp?=
 =?us-ascii?Q?X1XL/SRmLq9xh8Fd98ihlW2qpdPkCNihEx3ef94j8X3cm3wleKBvAwW02c99?=
 =?us-ascii?Q?HGd58uEoyfJaPw0yFvmZK1Gvh8wSjzABUgsh334fwxtCc5DRmVw4DjnzQB68?=
 =?us-ascii?Q?ztmb3ZwgxIKfEgNvllwfxrTfhH52HA+7vQi+ar0dg+g0Y8ispBhb6fl52fTd?=
 =?us-ascii?Q?iSAoFs1XgxvtND8IHRn3YLxJbPWWoPWF4mrS+ci57WQJ91vcGcANPQstlxLB?=
 =?us-ascii?Q?rYsDSt1MjNCIHGPmTs5VY8xhwCDd9ixHRkuVemR1WamSc93GmRbzcW7NZVwU?=
 =?us-ascii?Q?DA/1e6OmdUQyOuT/fGsNVgfk?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ca47370-443a-42bf-5b4b-08d978b0a9eb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 01:24:01.2235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7zuOSpmdhd0bX4TfI78ahojLlIp9/20Nns+3mKxhpyEuWrGsuSwQ1R0jRM16BcwqJztlNePV+mKieCEpt9WHVOKO1jELABFJx1pctXJl4rU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When updating ocelot to use phylink, a second write to DEV_CLOCK_CFG was
mistakenly left in. It used the variable "speed" which, previously, would
would have been assigned a value of OCELOT_SPEED_1000. In phylink the
variable is be SPEED_1000, which is invalid for the
DEV_CLOCK_LINK_SPEED macro. Removing it as unnecessary and buggy.

Fixes: e6e12df625f2 ("net: mscc: ocelot: convert to phylink")
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 08be0440af28..729ba826ba17 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -563,12 +563,6 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 	ocelot_port_writel(ocelot_port, DEV_MAC_ENA_CFG_RX_ENA |
 			   DEV_MAC_ENA_CFG_TX_ENA, DEV_MAC_ENA_CFG);
 
-	/* Take MAC, Port, Phy (intern) and PCS (SGMII/Serdes) clock out of
-	 * reset
-	 */
-	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(speed),
-			   DEV_CLOCK_CFG);
-
 	/* Core: Enable port for frame transfer */
 	ocelot_fields_write(ocelot, port,
 			    QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
-- 
2.25.1

