Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A9027CA03
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732162AbgI2MPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:15:51 -0400
Received: from mail-eopbgr30069.outbound.protection.outlook.com ([40.107.3.69]:38469
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728503AbgI2LhZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gzCkPRohxPJ8Xxuw3EVLMBXyZaPJlBeo3bJIwZw7tcVHGOmERWrnyxU96h6+BoALTPJMzoaTGIOG6jUA/Vi7tNOPSYTAE8b/NEpQn7xycD4EKY83AWkwcDDVHjae7dr1mqhVMGrg6vuiiPwK/Odb+CJKwcNNn8lIGx8JIx1PplVxrXjJ7WScD5Umkc6fhdl4DUlSaa+MIpn7YKZcvUuPH8Nlqdbo2I2Qvx3uD1VOQgYqcYVgyuemA/HVc6Rp5ES2QNDMRzrhGwAcL9L5/TUFrZnavtbPclXMNlj2CPHjKp0v3M2h6mwdegxKespCwlN4+DSeq05C13C7U1ofXTqy3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fMJ4wb4BBVkfRVSai8jVpZ88L1zVxYpEIfYQPhZBatw=;
 b=lOkxbM/9Xr+qc1gRZ4bMdeR3Yy/kcBLn35VFoyWjKR2NxM6gRXaFpPUizrNolA6nzP6Fqw04OTh9PLVZkxAyfuVyiCsPHhxePdzop1k0ieekpuV+MDuZNb4fCtZEUHEDMLMe0hksdYyw3GehyyD2IvuKb99T/RW+OSx3n0WrsUgVxMUwBnzCE+lLNBPcFLSOnLL40vOMHxmUyNmX5s8ZdsztOsKC7J8r0v/XoBR5+gSPiX73tajSDtCHdYSM7+j571ihfzVItRRA0Fbw1VhHRB8z70IqGhDVHfctal9sPdPSc9gJMJHRsiHYpiynQbpqU8wXk3yJnSCtYHGEnmmHhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fMJ4wb4BBVkfRVSai8jVpZ88L1zVxYpEIfYQPhZBatw=;
 b=W1lIC56L3OoPG7tTI1MyC/wH8gm7Wen0MsJd49onVvsbXW7RLJ7SM6lISjVbEoZ370gW/zyBGzcN2n6fkG8jG1HpA1W9GRGPLYJJHA3FtsyZPipMkzubBBdzVus7UZSBEeKwvyBZshw2H/Fh2N06xP2CoYq6YORTSBrVlFWkCM0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Tue, 29 Sep
 2020 11:20:41 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 11:20:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net 2/2] net: dsa: seville: fix VCAP IS2 action width
Date:   Tue, 29 Sep 2020 14:20:25 +0300
Message-Id: <20200929112025.3759284-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929112025.3759284-1-vladimir.oltean@nxp.com>
References: <20200929112025.3759284-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM4PR0902CA0013.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::23) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM4PR0902CA0013.eurprd09.prod.outlook.com (2603:10a6:200:9b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Tue, 29 Sep 2020 11:20:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a1b6cba5-ad1d-4b1a-ec39-08d86469b33f
X-MS-TrafficTypeDiagnostic: VI1PR04MB4688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4688B41F4C4C26B692DA684BE0320@VI1PR04MB4688.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9pRS+3sP9JozIFQY6M0D8iBwX+e++MzR/rdc7yT7ocWzRt+KgYro5DbUER6iGzBR0rCWcTyjxI9jdi1ZDF+oEDJnkF/zbdfegZdyhgApgxyBu94c87drKRhOLRaPY2AadTZEoJHuTnsAx8aZTV7DPTH/7VMaP55Tu02pMvx4xuEHrPsQLYTsP1Y/owNaZ+d7s/3Ta0lkZxkhHq1WFo+OGEMaQmKFBpqbRaUuEgYxk9Bl9JFjP+EMWd4N1a+872MQ9jUznt7Ljyvo0TWgerX50T2pyRDdOvWIEkC8QtTJ9kyIMCjj959/5kC5eJuhdW74i94LALW569VR0j/wjrGhncqN+tLfBrKusBt3VhKr+LZ6tyY8s0JKLQDdcqz4Q7pt8TBmXVvJMKEElOFJ2GbogE40Hi8Qiel27OCNWK91e6nPAEZxfC4GvJ4Mgktb2PnT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(2906002)(8936002)(44832011)(5660300002)(66556008)(66476007)(36756003)(6666004)(66946007)(4744005)(69590400008)(6486002)(83380400001)(6512007)(4326008)(8676002)(316002)(186003)(86362001)(16526019)(26005)(2616005)(6506007)(956004)(1076003)(52116002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wqd34eQPOq2+7vXD0wBwPqtmUSdDCMzVrCN2vqOSFSaNuIvC5CW83N19HP3QF5CL+Z/ForaVJLx8QiYAIwjmHYXaFEoPYJt0pi8HGYjM/0GZn3zAgOzplEVXysw2hGKZfQD9dN8YW54kdh0OesliSxmRTC6dWHfp4kiXPQZ7VmHCtx+av3DpA554BvtMXqXX7ljS9LrMPBOD7tEZXzELOrnkiYz0JOpPM7ptFhGw1Q0+JKE/m+9OBIGWWsRwhx8JpV6ohmu3dr9T1KM6ctBoDd9XIq171NwMnG3CF8QrNExhwmyRgeo9RbjdwGfv2EjI58KJ88oIdMivXG6UoqeM1nokBpVXYlJXzgFLiaOabw0ZJOf2nUWucLizMS79EKxWQBThimfTP5sbJPZ5kRKCkGqAALX5mfKD6w2OqlDUzhRUe8OYaoP7z1gFFJr8nzKyYJtKv5Xj9c4fJhPUrUp4CNHshGPum5rlscLs6V4eHmTkrwei/qnSIgKM+Bnh1/x7wQln7418+9EKhijMXDnZCAPsMA0dlqRiz18bOE6BduN/rxS5+9scingyjyYqbzjMBD6xSQT0Do64wayIe1FyF1ZJwDGz1/rrqfF/xQ+fsCLrk7fnobzkbhWXrDjIfXwyYKRHo97JaSsI52J6YNuSTQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1b6cba5-ad1d-4b1a-ec39-08d86469b33f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 11:20:41.6898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J1tNqlS11lhS7tX4EI/D/ty7qn/hdn9SM9puCBf6j/C2m5A1xibsBIzUcE2OReDaBmctaW26qb7bcgnLZAfeLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4688
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the actions are packed together in the action RAM, an incorrect
action width means that no action except the first one would behave
correctly.

The tc-flower offload has probably not been tested on this hardware
since its introduction.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index e28dd600f464..64e7c1693ab2 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -696,7 +696,7 @@ static const struct vcap_props vsc9953_vcap_props[] = {
 		.action_type_width = 1,
 		.action_table = {
 			[IS2_ACTION_TYPE_NORMAL] = {
-				.width = 44,
+				.width = 50, /* HIT_CNT not included */
 				.count = 2
 			},
 			[IS2_ACTION_TYPE_SMAC_SIP] = {
-- 
2.25.1

