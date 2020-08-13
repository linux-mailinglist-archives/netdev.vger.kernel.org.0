Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28302434CE
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 09:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgHMHVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 03:21:22 -0400
Received: from mail-eopbgr70083.outbound.protection.outlook.com ([40.107.7.83]:8323
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726081AbgHMHVV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Aug 2020 03:21:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ik9hTmrmXxHdVFy2Z7n6inu3gbzC1+4a7R+/7Bsm+6Yrz0UzETuBng2TiRCqnORXZr+1WUkstArrYy7HG6YwwzFmWdocZg7jMB9RlYkEBMeTo8L+mATRuqEUloKLKzbms3uiIJg8KPoKFsWBjNuoHUpJxboztFiqcpRXIm9GMsR5W68lC/xWb7WQVHNNgsDPLon1hgFH11LXh7uAXcRCkLh5qN4OeyxMPaM9D2IF6r9+QQhJ7osQV7YT2tMnX3OdLYOI1O+IBBowh5LIShD15q7v2+Gj8IzF4YDfFUtwjjbcAljuDgZtHXagFlocqlgvwPB+Z2cYFKrBKGoMW9gerQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E69Qn4YtKpd+uH9W/gDAWVs4RGkOQXZtcFKUSgzKQKA=;
 b=C5FA8ePCIC9k+Xy4LCZK2mTC38bpDwyFTA0NjSikajznz2M3Q9vLbhJS9yNdKCQYF0nMcJHpK5kX5CYS22tFMX85kdLsqvxoWr9ex7X5nwAmdREw/P70NEPHxk0NriQI6u/EfcsR6UzyX6xlvlefxKhV0tUsw7AkBzJ7orJ1O62Jy3e0FPbhv0JaZ6sGGvQ+j+0e+FPqEjwSoqb74MO6kb5Dz5C7h0VobprO6kTDqokkikrAFZQpTyeLnYFTT0OxzjAZwwza8z8ehPfvcWyMjXriyUBrKOzYZfokqVEpWkmBIjq+tnN91Zf80B/PRZ6qk3vKNSyfykOO8+JvJVbONg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E69Qn4YtKpd+uH9W/gDAWVs4RGkOQXZtcFKUSgzKQKA=;
 b=dKdAXjDl1O1v4Kclmq+LaXWvF/VxC6Qc7oeYksbV+2L+YlpSEDOzksJjhydGYBiB5C8ydWBGAddUH/V/FsGGoRdiAI9mjfRE3VSgAvH9BzkmIP+MIuSHlOvSiaKBRSDius0T1W/1RhU1/8SYr26KGjTyU2oqIueynRcKG4cv97o=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM5PR0401MB2643.eurprd04.prod.outlook.com
 (2603:10a6:203:34::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Thu, 13 Aug
 2020 07:21:16 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::1813:3947:758d:d754]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::1813:3947:758d:d754%6]) with mapi id 15.20.3283.016; Thu, 13 Aug 2020
 07:21:16 +0000
From:   fugang.duan@nxp.com
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, fugang.duan@nxp.com
Subject: [PATCH net,stable 1/1] net: fec: correct the error path for regulator disable in probe
Date:   Thu, 13 Aug 2020 15:13:14 +0800
Message-Id: <20200813071314.6384-1-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0103.apcprd03.prod.outlook.com
 (2603:1096:4:7c::31) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611-OptiPlex-7040.ap.freescale.net (119.31.174.67) by SG2PR03CA0103.apcprd03.prod.outlook.com (2603:1096:4:7c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.15 via Frontend Transport; Thu, 13 Aug 2020 07:21:14 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.67]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4ee840ad-f726-49ec-440b-08d83f59774b
X-MS-TrafficTypeDiagnostic: AM5PR0401MB2643:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM5PR0401MB2643C0F726B5D2F2EE7C8A59FF430@AM5PR0401MB2643.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mJGxJXR4O8nZI6LIc+J3dQdjaHVQQwFEDQVJ33hLqKF6z3brZT6WYN54gvJeop7m5rgMcer7I5fCzhRckInkTvNqSgejzWJ2Ns8sx5Liqq0KS+6UDcHnq9IMd4+twf3GbG8TCLVCTgGMpRtreZBvoZzoa2F6B/HogFqndRMq5SQ8gjqOBnpGAa7NrYUsPEYvwCje7aF7BVlqFjSTU0j/DqmpmCftXJu0JDuPYu6rvxLU+h5AEqBUhWzR+AjR3zFKA2ph8oAUb/ruSGiVVAKouSXCOWehQx9idOLJnZyAFt0pmHQw6BHFRoLg8vKJQwcogx31WjL9Z7HL5wigfTUX0mrKNZX83fEzqWbgusUJGZOF65lVRCbeNb8r/f8l/dDs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(8676002)(8936002)(478600001)(316002)(5660300002)(66556008)(6512007)(9686003)(26005)(66946007)(2906002)(83380400001)(66476007)(6916009)(2616005)(1076003)(6486002)(16526019)(36756003)(4744005)(4326008)(52116002)(86362001)(186003)(956004)(6506007)(142933001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: e5JKMWzoJ0276PuHmMZqA5r15y3zhfo/DNFxeWBonep0jQI/mCBPi5JX4d7rxfTS6GGLTzqXjsKsgCTsmEWI8ef6HT+OEqz1E+RYl+MnC6mdrI88SPsRuR7TNClUFUekug6hoiBWqwhbaU8HQqYwLhJJftosjfs2s0fIAmZKC047i7TdifTBkG50geCiVY8vpoQPnxcD8SKEXDyY1VwJgardKPS/gWJMAgPYr5/fmRJ9Jq8t6SDnYNBx+Hjpjku6cEuKQTR+r1Y/6ZnppOd/fv01rosTAGjKp7dv1u4+WTPmntkl3LbYheP907P78GPa8+N2rpMb+IXxKnYoA/5df+AyNlsuCBclFR7AhsjBOErVynCUGl8eqtMS1F7zt4/bj3BQgo4Mk6P/ppf9WDvAXXP7H6sTUYgZE4ZQGEcxv84182Dyzz2kd+MDW3BgnaTHyZ6iToIr4fXw7xDV6s/JSWmyuEQiPxtXRDjF8q7Hujqv0+Bb0RIZz+PU0QtNOUtedc2BFmLcv1ejKsxX0vjNlAT4wUPLrHyRAsL/RQ1LwsMn7n4VcnfIDUPa06iHFjK7TyTLUQCBy4EHMxKaI8VkwbUV+aqQ+jQK1J5Q84BsTp82RTMo+6d0QddFPKx5a28PqBia+7WoetiruiDyIwviUA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ee840ad-f726-49ec-440b-08d83f59774b
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2020 07:21:16.4322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OTmRjZwywNElTWltwNpk85+o/UiPoElszefbDERYYA8pLmML4y3fxjij8BiiA8Y//diPzud90l1lhl7d1TM1hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2643
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

Correct the error path for regulator disable.

Fixes: 9269e5560b26 ("net: fec: add phy-reset-gpios PROBE_DEFER check")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 9934421814b4..fb37816a74db 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3715,11 +3715,11 @@ fec_probe(struct platform_device *pdev)
 failed_irq:
 failed_init:
 	fec_ptp_stop(pdev);
-	if (fep->reg_phy)
-		regulator_disable(fep->reg_phy);
 failed_reset:
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	if (fep->reg_phy)
+		regulator_disable(fep->reg_phy);
 failed_regulator:
 	clk_disable_unprepare(fep->clk_ahb);
 failed_clk_ahb:
-- 
2.17.1

