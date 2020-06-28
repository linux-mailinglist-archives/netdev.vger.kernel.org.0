Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF10F20C53C
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 03:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgF1Bod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 21:44:33 -0400
Received: from mail-db8eur05on2085.outbound.protection.outlook.com ([40.107.20.85]:6160
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726378AbgF1Boc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 21:44:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fkNi6TruPU09TMXUo0T/w1G4k9P48q0Udt33KnuMPKfFbmpSexUX0m2F3ZLiN6qaOhn7TqHi/GCWofZLMHXc6+dwPwvuxqffxSQ9K5rvs7cCVECwnMst2waz8EbmGbdq9OGeXeWDXYFnvOH8Fx+p4dpGPBPVTDN1leNGfO4Fw4T2qDJWFCkicyJBx4g4MRFVf/KJY0o4Ds3LBsJTl3FGxfgUHZvhWYxMUVEJVT5zn+l3Gds0vEQK+DNPVelijZpLvBCLDVfP72NfeWNwOJ4/K4BO9iV6osvo3qOvXWevgr7z4+Oh/SYnB5s6AQXgRCvlcjPeEe2aIIRkW68Xte6stg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kWe4grM1QFndulPu96VHnqFZOhhIifQyZYMyDZuUvp4=;
 b=V3kClsy5VRw6906w6kzjDB0tYrEd5FFMDQxuOCxa4fimZQVuq6ve3qhnB5NgYlUPzojj8oiOy86HqUaPgAdECV+PiPNcnab7Nk0fSonQFUyHB+tMImUDoD+ZWYB6dio7ejP1uyaTMfJdj0TJRM2/XWwmMT7t8sQ3HoJgj0phsHzx2gYhGGehuDYjHxlWyDOAejqlAGiUeS3m+8FPR84t2Zb6i5iLoLFlGgjwJaux90Z9qEA05wWWIO+7yp6znQbv78R4D71SharLJzZ+O1DSdIdQTOf0eNEaO+cWjbpNVZbRNp89dFSXinMUNJe25QwRu6A1Jgb4cG6wMqKx59GAUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kWe4grM1QFndulPu96VHnqFZOhhIifQyZYMyDZuUvp4=;
 b=UPySdSgb3hn6vUGM1j9Mcj/Mgj9nnl0WKiNGNsKg+QTAdLwwUiTpIq8e6AnV1PmIJMfNqzyAd0heQitt7vSmdVqNf3V+zfIcEW+r4PWxKsOQvlC7t2/qipAlasfzGCs6wKJ7n/e97hyFF5cmlnVE9pIP5SuwLYH5Vpn3Gt28vIg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VI1PR04MB6029.eurprd04.prod.outlook.com (2603:10a6:803:101::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Sun, 28 Jun
 2020 01:44:28 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3131.026; Sun, 28 Jun 2020
 01:44:28 +0000
From:   Po Liu <po.liu@nxp.com>
To:     dsahern@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, davem@davemloft.net, jhs@mojatatu.com,
        vlad@buslov.dev, po.liu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com
Subject: [iproute2-next] action police: make 'mtu' could be set independently in police action
Date:   Sun, 28 Jun 2020 09:46:02 +0800
Message-Id: <20200628014602.13002-1-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0097.apcprd06.prod.outlook.com
 (2603:1096:3:14::23) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tsn.ap.freescale.net (119.31.174.73) by SG2PR06CA0097.apcprd06.prod.outlook.com (2603:1096:3:14::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sun, 28 Jun 2020 01:44:25 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e9874d3f-3dd2-4ae4-8e7b-08d81b04cba6
X-MS-TrafficTypeDiagnostic: VI1PR04MB6029:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6029F11922DE2DE56B3F9C0892910@VI1PR04MB6029.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0448A97BF2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dr9L0/v3t5hGYP9Sg+kezGFuFeyNKHMo7A7fP2Z3K5LFxqQ+SnVWngWI7hUgKZlhtm5b+XrpIITmgMJXY0iSVuU6mOVuTh6JQpVJQQYg94HbDWsd1QGQGSbajjISVhIgsxX1VciHFqULPbze4Arlxy4XD+q0o3M3GxancULSWiWPkq5cehuZVjMu1nqLmHrFJocHtZw4LClU9BqDEEhLrenf2m7lxyATRl98rn3ryw9CMrPyGj1yEfc6UVR7KZJW7FJ2D6mjyGT/X903mjhJMRpNXNO93Z2BEQZOritar9Dtzd5C5FMiUSU0/Zb9BzbjM3b3ss0Qm9QmBDsK09Vmrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39850400004)(376002)(136003)(366004)(346002)(2906002)(83380400001)(316002)(2616005)(6486002)(5660300002)(186003)(16526019)(8676002)(26005)(8936002)(478600001)(86362001)(66476007)(36756003)(44832011)(4326008)(4744005)(52116002)(1076003)(956004)(6512007)(6506007)(66556008)(66946007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gpRVF2GvxnhPWuND3QA+N4w9KUr9CRj7kKDytjyjuxQVuRpge8KDxIUvqmH2KD6EqVDOd0X8d1C6XYYcwHa5u6+v0UXYOdHIPw4hcoy1uLlSXRzHv9a3PYGeINF+bWhPXXxd38XPD/CcB1ZUS9qxM5riqvEgreHbsBVTCzKrkaNmMRHw04sOzuOQSyCptAoB9sy8rJ1hHjFrOgJ/+XKUnNF0PX83xf8pj2qmDmUTMixeaxDVS3RvWJWWFaV/osUjc8zQKa7DLPOC7yctowHx31blFfuCaXRKSRyDJKNqYvfs8ngKCqetGWCuijLGnqGFcojsySuxmcUak0nLJYITguVssxImSBZGFKLTj8RRoHIer1MFjsW5BaR2IDv2BjOWFbbP+R3+VcreaXxjesvCgXceGg9Jz62ZwclG/+pE2lo4zZ2bZXNRpq9W0FWP2TPg8UIU0Swzyvc8e5ccQmT7kPjFMQbbL7Y2LEFf3wp48fo=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9874d3f-3dd2-4ae4-8e7b-08d81b04cba6
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6496.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2020 01:44:28.6902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mgnzdYLrlOqz6W6+rZ3ZI97fWgw4NiaqmxD+B8rMZN4Pz/nc73wTCRE7amVxJMv3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6029
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current police action must set 'rate' and 'burst'. 'mtu' parameter
set the max frame size and could be set alone without 'rate' and 'burst'
in some situation. Offloading to hardware for example, 'mtu' could limit
the flow max frame size.

Signed-off-by: Po Liu <po.liu@nxp.com>
---
 tc/m_police.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tc/m_police.c b/tc/m_police.c
index a5bc20c0..89497f67 100644
--- a/tc/m_police.c
+++ b/tc/m_police.c
@@ -161,8 +161,8 @@ action_ctrl_ok:
 		return -1;
 
 	/* Must at least do late binding, use TB or ewma policing */
-	if (!rate64 && !avrate && !p.index) {
-		fprintf(stderr, "\"rate\" or \"avrate\" MUST be specified.\n");
+	if (!rate64 && !avrate && !p.index && !mtu) {
+		fprintf(stderr, "\"rate\" or \"avrate\" or \"mtu\"MUST be specified.\n");
 		return -1;
 	}
 
-- 
2.17.1

