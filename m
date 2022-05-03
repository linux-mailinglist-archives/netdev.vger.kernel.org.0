Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C340D5183CA
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 14:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbiECMFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235054AbiECMFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:05:38 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80084.outbound.protection.outlook.com [40.107.8.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2893057C
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 05:02:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fKQEf79craf1PlqLR63G8AN6c7CqkkpOe+ZYfAeYL6W3ifm/Ic33JYUyPicjCRnroWquzM/zLQB8ypCCGepeHQevP87OatKMDN4RyKgH72nGTfN7coxbN8JkRLLFCF1ye+4T9sx1B1XDIuNNypnrx/oaS60cNmTT80DzEyVThPcHqd2gBA1ZIU4Serlb/2w3MIeYsGt/kQgRH+S6rbegiwqT+xwcmSZfTBo6CxqqbUOMqzaIjCFyxU66HMAH3K8ZGk2QuHtNziAuJjwmMtw44+WW/6G/2CyC8FtWx/aWZ2UMKMYfLBsj8E4jK+FzW3VuPiWnGWd6kbSTDMlw4b/TDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dg1gG3woC1bSUuCN9N3/m+juVugOoEKTySiq6i+G46g=;
 b=jhz8xXyn1u3BWKFKUriPuV3jDJAmPA7gAwATc9MhdI1ipr0n3xfw8TM45qQZEpbNTI7l1i8Yen6WQSHiSUgKj5B2M+X7Wq/YRnBFWAPzaLxLs49IovLW4rsZmXlCA2ErvakNQbmJH6gyX2E2bcISnFCCHkmKHVcfyYL7aRk4nD8gHvhTPipFugpkqtjC3qj4GSJwbYbh3FDaVIOb0QXmyKN/fpO6F1MCP33VjuGX8SSkpRPq2+afhHqeJnyI8Wwlcg2It/55FSGZmmccqul+sH3Ktlnj80FhfLRL5XAkHVHkMKCK52ht82bYaXkmIB9lf8Tss2V0ULD9rNnObYhfIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dg1gG3woC1bSUuCN9N3/m+juVugOoEKTySiq6i+G46g=;
 b=mZFlPSZ8KZfajQe8J02aC6zH/fj6XpgyhOL6lBZKPXikq+sk/V/BsvlJZWNtTrtzWpc7V40i6Wjo8FgCPCiuR95SowqGghHEo5sA6+0Q3XH5Rju1iJ8kplXqShMyqWHmN6MuKtW43F6rane7WEMhtVOP5FdBCxy0iROjaDoqBgU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AS1PR04MB9480.eurprd04.prod.outlook.com (2603:10a6:20b:4d6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Tue, 3 May
 2022 12:02:04 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 12:02:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 1/5] net: mscc: ocelot: use list_add_tail in ocelot_vcap_filter_add_to_block()
Date:   Tue,  3 May 2022 15:01:46 +0300
Message-Id: <20220503120150.837233-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503120150.837233-1-vladimir.oltean@nxp.com>
References: <20220503120150.837233-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0067.eurprd04.prod.outlook.com
 (2603:10a6:802:2::38) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d64193d7-d773-4cf9-3d19-08da2cfcbccf
X-MS-TrafficTypeDiagnostic: AS1PR04MB9480:EE_
X-Microsoft-Antispam-PRVS: <AS1PR04MB9480BC54A0B3E1E749C67085E0C09@AS1PR04MB9480.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gsuoK7yeOnyy2UyLunhv7ojXZnsTEmgZtoEGm8xg/KBZ8yvpLB8enORpfC+qWoOe/TuzSbi5EcokeZHe++YqpvuLOitADBFDaqU5HWZvhDHzuXf6ge81fRDl7mYRz2+jNt8ZGA+bVDQsNF3tvmEYMPft/VGortGNHt8FH1qttnYPv9pLRD7+hVuSuuQ9Pxa2wyw9gVHsilUvfg878L+DbiHC+AAuPo8C8DQA03ipT38v+0Kv+Bvr43IL5X3pzwlzKU8qRHgM5Jn4PKPN9kHiPbljfEB5Rs6eAFcUGATG6Mo1Q2DW/W97kHTuouHLBhp7kQnErCRTXFSJH6MyMRVz7FzYKoX3CdVRYCgb4gExO/qekuGANz5t5Wnkkyc0ULSXVnSvdrDLjdscSSup22j6Dyvh+MFMrJg7o1aBtFjCYGsR2gc4lvUqDz1e0PTMCoeteL9631UH3sZN1EdDjsrQcYIq6EC69zaOhZMGMkbnRKZkuXUap+hKoAh4jIcQDld0Q6E6c5K1wPVVxpZO7FfOx2ZpJ5aR/mQ67UdN75uLFVLiHaTq8ahXwpU4/torIEmkHZIElrfFYHKMAQ4iM0zEODl6Dqh7xu7ChFV+v966lOvmTw6VQRfxnD0gua0rQVCA3kGErTxf3/deXRZAbB4niYyx5B80p1bg+AcibiVtdaTv+IWB7i2IQZ+Vs9XwRgzd/vfsKPBvU/LUXnJuDLTk8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66946007)(83380400001)(8936002)(7416002)(8676002)(66476007)(4744005)(44832011)(5660300002)(38350700002)(4326008)(508600001)(86362001)(6666004)(186003)(54906003)(2616005)(1076003)(38100700002)(6916009)(6506007)(26005)(316002)(2906002)(6512007)(52116002)(36756003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P+kU7T/JccKdg5d+vN/eJAZndPlhpY6dW1AOmOgGwkCWNUFvrhIuy52VBs6k?=
 =?us-ascii?Q?Oshty9JyXum7jGGjX84Ljt/ursp1XvAeDrqk6B8Mu6qIJUeOpzyW+OSvckD9?=
 =?us-ascii?Q?DXYpBdbsyDlHz1KQwMxangfZDHh+xNxxyenv3vE3+dwrCCFRMe7MYTDv5GNY?=
 =?us-ascii?Q?42S20BR1rhqlNqtRo0kYl4GHJnvvLPn3EUPZYU2if6GlnulVYN13Dqu8ifz/?=
 =?us-ascii?Q?8XTvvJx/xdpAqhIKXdz/Wxvg/zuck9WLTYKHLJQQSFvfXhxCyhCh6uvheJUW?=
 =?us-ascii?Q?nhgbTp0a9okSj5EK5UKltZH4GPAwmdMOdA6i/PZFG8InwMJddXHDvh87Jg0u?=
 =?us-ascii?Q?2YtEC9akP195XTLMM3OuZqFbXLAxng1Iy3+uVpvN7WNwvU0DChqb3w0KgdVt?=
 =?us-ascii?Q?wQmlISUU5i92zoby8uF4Yo/TLXV63GKzkATxwDPYTGqmMyB73g0jn7TCxGQs?=
 =?us-ascii?Q?Z3QcWiP1utACqh62qOBjurPtrk8IDExakQ+fuW1O2Z9qRMHS4F0HhGPSGI8q?=
 =?us-ascii?Q?JOhttMuU5hJu9kJt38VS199maoWOOXU919dXCDrEsrS6lkfuI7YqGZa31y9Z?=
 =?us-ascii?Q?7+U7y7YIK1OROWMPwnhfjBuPcj1ElGVn4puECtWyI4E7ZW1X4MIkr7htA/Xm?=
 =?us-ascii?Q?n9BdSqpI2DPyrWC9M4D5w03PoRk99of6t9PGjygPTjK3NxhvyL1vgyaRPeqc?=
 =?us-ascii?Q?KYDk4r1boIHRZxnpEpTCFIfQyKnK7uvWOW9s0FnRzMWVTGoW5D+azQymaV0m?=
 =?us-ascii?Q?VSp8u5LDsMxSWxxMIUCIUKU8ZfLTlOeJY81UL5MheOwUYFJvQwXPf462IZUy?=
 =?us-ascii?Q?2Uzp9XbmBm+NReJk2YJUWDtDE8QbkxdY/17mTr63S5pf4Tvgwe2oSaFtVCUJ?=
 =?us-ascii?Q?Xs6smrl1Vl5owZ7okUMo3F1gfzLasrZ68r8hqgy76ZwOBvu2q1a/ZPY95+6d?=
 =?us-ascii?Q?xEX8xmsvs/S5a+zTa21jR+BuILoVx2JlOScqGO+TVEbbCei83GHDPctkBmPx?=
 =?us-ascii?Q?v+J8JkCL9VhavHCXyQBC2Lojr6VnDtI8/OWR1JHRnbwdEAUnaiELe7t/QBMx?=
 =?us-ascii?Q?JGjSYaZWsC6gUDXLR7WhcTM3/usnb2bYZxtnFHgfAym7ZRBa2pibIKHI96WM?=
 =?us-ascii?Q?zWu44W1mKEMDjojT45HbfnMACCjBE9enOvqjT8uyR3kYmuyZ8qUwFmaUgzOG?=
 =?us-ascii?Q?SAsDdbfbcjkGQebYZuIjLbPS+RNKaeGcQ4/CfOpqUqzSlV+zuvszaMjXlzr9?=
 =?us-ascii?Q?HMPjz88Naee/TL00XBqq/saZSCipJhsIOoudjMK/9n8WAB3qYpGIa9CxogMm?=
 =?us-ascii?Q?6g4EMHuw4+pgmiCLzRSeCHDsb5XFNSAInYakfOen+9DGdSMkbTKL3ztZcLPb?=
 =?us-ascii?Q?HZlNks12CKI5HZo2/F0CvBDd3QcQQLCWY29FBEsXOMLaQ/+sM02r+5Se/1vD?=
 =?us-ascii?Q?1bvisXiO61MGVU+33wpS0xxMHYcbHpjGfRGncO40i3mQjQ0WMTJyo6uYM/VT?=
 =?us-ascii?Q?wlEBom5srPauLnseY40IaTsqPqfCfwCfAysk8/YhLpmvQcy2BU55wkwIZVZw?=
 =?us-ascii?Q?S7ZF/hb2O7STYVc4hoRTIFd2J/AzuThSRTSHeco05zgTjBGJG2kPxPJSp3EY?=
 =?us-ascii?Q?Ks/nDje8jb9cSUnyeF4ZQveynF4+QIrhiqpcWBipkwBgO4FGM7S/wl+RAzMK?=
 =?us-ascii?Q?tfY3LxdPLHBQ+/fJxjiwwkT2udyOOBHpVvQC87pC3dyLLER6InOJg+PnXwPE?=
 =?us-ascii?Q?g6yr7+KQhOATKAMLKygQNsnysqUEiZY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d64193d7-d773-4cf9-3d19-08da2cfcbccf
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 12:02:03.9456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Fwk7NBADFr9BMoeF/yZ0+Kze5NvOnK2TrpotC/LLjkgOrRUELcgvPmrrHyrupLnvZLOGdXWWDXgrNymgIqe+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9480
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

list_add(..., pos->prev) and list_add_tail(..., pos) are equivalent, use
the later form to unify with the case where the list is empty later.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index e98e7527da21..cba42566edc3 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1012,7 +1012,7 @@ static int ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
 		if (filter->prio < tmp->prio)
 			break;
 	}
-	list_add(&filter->list, pos->prev);
+	list_add_tail(&filter->list, pos);
 
 	return 0;
 }
-- 
2.25.1

