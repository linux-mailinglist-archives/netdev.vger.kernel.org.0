Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7CA673E31
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 17:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjASQF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 11:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjASQEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 11:04:54 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2053.outbound.protection.outlook.com [40.107.20.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91DC6F8BB
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 08:04:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbe6BeMnC2wIt+UKKf1g75RYxI0UpoukKv71BpIkXl46Lz6Kstj7TJZfh54F9MnavoeBfreAdIze7gOPs4KNNw46YSaPN3+w3uW0/hkPwHtIbFKUhycS80gtt95FOjSny4al8w3yO7AGeCwGDjFZxlqxq9Yh3LzV6w/PpYbAU7itEzmPg0SOohpjAw5a1dVZ/VyYW0kmiOBEEqyPA1YRo9HN0Y+OXeXLOBD6+ruJ2LQDHeFLbHrwnGt9dZzDiUdR54a0tAg+r0PCMNPO4kfILXIFQ5//TlfsZ8klD74aeyaKIzTJfaZaUhaQlEjkgsEFNglnZDFwbezdYnuJ2opJiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HlLunQcrlBevyhcjwHrR+MhMxkqF6n6nS7ypZePdNCQ=;
 b=UiTmnXqGs+84duuflgCtsZGuWPRNSGGy+937VjPOLwC6fNoEjRO9CgO+47+c7DqkaGtqpbeINlGoWq1NUBo3yzZDcLjgPmbT8z/okfnFQYdtIQRStQlvLYZzgBgSAHwW7vwXtY2gBUvVZE+7X2/hYxYFCcUPQp3nZJhgNLO2XwPA40PvN86xuM9n2CpSGeLlVFmKNAXN2+0g06Dk9pQcm/PWTYVo7OP7CyizJY9+8emXvPy66999I6Q5JVfNVptUGAda8y8Op03hmeO2GQC3wgO8XrUUX/aHJPYtFmHS5E8TWdqVFrXSGYdnbaNQXA74QmYLFEMLd0A6Pj6ifh4LYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HlLunQcrlBevyhcjwHrR+MhMxkqF6n6nS7ypZePdNCQ=;
 b=Vx5X+MN31mq1aAUbLZzGYCcvS5f14md0PLYvKLCtQyOq0VYI0jfb1iO99ANOa4G1D2dq18xmL5rcU1vCRaXbE21tsotN6DPqqhOJDVQMaXBeGg/5ifOUaUY+R/BLm5dMMiO28OjAqeZmiYtqFDTjSn0TRrMpPse+Rqi0HBRIYdg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB8036.eurprd04.prod.outlook.com (2603:10a6:20b:242::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 16:04:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 16:04:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH net-next 4/6] net: enetc: stop configuring pMAC in lockstep with eMAC
Date:   Thu, 19 Jan 2023 18:04:29 +0200
Message-Id: <20230119160431.295833-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230119160431.295833-1-vladimir.oltean@nxp.com>
References: <20230119160431.295833-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0130.eurprd04.prod.outlook.com
 (2603:10a6:208:55::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB8036:EE_
X-MS-Office365-Filtering-Correlation-Id: bec3f74c-dfa2-46a3-ab3c-08dafa36e248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mpYu9F6mZ6qqnPEMgPWGS+NMx00w9xYVSUQ41lcQhwSkkP6+iQdbJkEavk0fJbPtEKmLO/d/pn+hvsSdOiPbIi3hBCVEFAvpMU5wBKLPFPV8fZbUNA21LMGeicM0LuRZwD5jTULwfEJr1aRxCwvgD4PHswDjXMKEqCzG6vmdG6RqUmflJu2UlWeu2Z9fV6fnInvyA5GRBhra2Y9EeOYSRuHXKOaWhaWTk8ORYuvHylYu2cmF6n0dhbOfEd87fSZXM8Qn3PgpS2IKu4rm1zfGSgWL2fbVOSMsYEgIzCyOGa9oAklt96KOrqzmdtFr+bHxRbXyDgauvKzk9IDq2IZauIXczv5vO75L/QxaJyNwpT+IWMhV87S6s1C8VHcFrDazaj2Jq9gKztTCq7eJLHj1UNxMvLJmZNjxLQFnlZzgHBEXuOXlM8r7pXg+GJVeYOgVUTvoGbiwoWpGxfLDv10MdNCUXo7aU7YxEF3mziRDn2JG/zZLsZen0bSWa1wnLvnp835iV76bLaaFP6fE3XwgqEzL4tJOVXr7LK2oLgRMi69NdLcuMK4VEOFmjfz/tBqWRDMiWW2H9RHzxH+OC4fEmaF5JaN31a4DZICv9+BInrFxmIX5eJeL0gE0wp2sBPoFOMOAAS3JqoRizWy9xIg73I9Fde7XuNlSFzd5QQtVPsXOmeGxDO3ixejfDv9YK5Ec6iJGCsUYG9kefXsuzurRDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199015)(2906002)(41300700001)(83380400001)(6916009)(8676002)(66946007)(66476007)(66556008)(4326008)(36756003)(44832011)(2616005)(8936002)(316002)(5660300002)(54906003)(1076003)(6666004)(38100700002)(186003)(26005)(38350700002)(6506007)(52116002)(86362001)(478600001)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5Dt+6QTKONVOEK48oXSUu7YWfPDwQpoMpbTZ9il6DbbVe3tgUMQ/C/RGdPAZ?=
 =?us-ascii?Q?3UHYi7hxENAgsyuMJSpW1XLbqHVZF+rS/vLk2s46CbmsEgV9tYE9zu4Lx9pH?=
 =?us-ascii?Q?anPKAjVyKKcpXm4sn5sKgN0c8OgWfEG0vT5REyfYN7SbSIK5pak4JXLPlc3I?=
 =?us-ascii?Q?/X9g8zglMOpfvwlWCxx1A2IRVf4M5683qirb2+gAHdOklpZd+G77tfqSrc9v?=
 =?us-ascii?Q?F49llNsuFYZZuK2qaN3+OpuvCbu1NRtXjWdi+KV/WtKfkizh9T4OpJeZrDtK?=
 =?us-ascii?Q?gi6fmfxSV8DC+5XYYf15vEFbPZ3onO86m+KWSxpuIJWKUGqy4qo/SibdFrmd?=
 =?us-ascii?Q?WQAh63Q5EjCl0fbBXeKivixFRaata4J7ziRbQ1FfoiAjgwoSUQW17fPieosA?=
 =?us-ascii?Q?UgM4C0SIWPxSWBAamwJ1LT6jc46kQ7eW5C8gHz1fbt1ypWjDRJPS9DDmpqlW?=
 =?us-ascii?Q?RT/UwUtaqjmMcs5JmtB6v7w1AjH+i5wTA12+bdfjGd5HFJImCrdalURHeW9/?=
 =?us-ascii?Q?gaT1/Nu3U7rpRcNc93w+xYoZ/DunzBdZnIjWUiM3/w5NRPi93RVqokF4ALIy?=
 =?us-ascii?Q?nvsHxKvihtwfguqBZl3yDSWB2GU6rP0Eai/acVF2cYzUEpmpwqTdSgjKB8Ha?=
 =?us-ascii?Q?UXjf8jJd0nyGsJhtRCEFW2mNfQjbM0+FqaFlCUXED14gIZTmUjBTjis8iq7M?=
 =?us-ascii?Q?T0/pmysMbWmwWNaip3Ee4XZSwzU0REhonQqamIfsoJBLdRd5UpFkwf2x+AMC?=
 =?us-ascii?Q?30aTbqks3+kCt0GsKC/JGmQf/QCM8f+yfWYJkXSpSTBOtgM2alnJW0WcGU3D?=
 =?us-ascii?Q?A2cwocIzeJ8iZYPH6zwvrum+YE80r7hCRYGlawTbYCWuWyBj0xMUjMl8t5Uy?=
 =?us-ascii?Q?+VAjmkWo3C1kaGbYx728DXpWAolu20cyLkN+3Pjt9uz5rryUHIVIiyn4xo2L?=
 =?us-ascii?Q?3+B5+oTXMStL+kfCvKFI9Oq83DphjLdwAUb0JpDYNdMC4rHsSEz5JBHH6il8?=
 =?us-ascii?Q?043MJjZ9c27uaRj4S2yXcGjUmbTDmQ4ndInQfD5oib7TQrCUEw8WsO/ZTD6M?=
 =?us-ascii?Q?szsJWcq7RClvCLLCcvBexPoJOaJZBBzPyaRD8KZv+axQvAzXwyA9eMWFKb+X?=
 =?us-ascii?Q?+d4opuPd0ADt9fnkCsl6knAgJnyIP/pyMNyoxEyzw4q6unUxGabg9sapbkdJ?=
 =?us-ascii?Q?CLFhsrvM0ZTgPfhpKQAjCmKXs7/H2ORSPc8xIC7A65ysyt2kzA8JcHVaU0zs?=
 =?us-ascii?Q?YSJTk7pDHbPdsQdR1j8ATL6/WxQN9Ii+xY13eYxtX+zHr5IlWhTFTZitQxh6?=
 =?us-ascii?Q?HjCKCQB0nBi8hejFKxgWQKpXeZGhNG6IpdecEv5qnWujDhRADF8RlVSkC7xA?=
 =?us-ascii?Q?ex8sCBC/CFnyvDBAcJWV3xy2utGtgI04+RAVPve9OUw+QiDCwXW4Ffhowuff?=
 =?us-ascii?Q?0ZTW0xMr03raxuNdoMNbX/mSbL2q6k9GyaZO3ZNxC11MLM2k/N1iyPLUPkdC?=
 =?us-ascii?Q?nnf/lcaGAisCPTN+PsfgWFNeNmiz4ZSyDRVFQU0VzA9f7EBj1dA9CpIylx4S?=
 =?us-ascii?Q?rWHpALhlEF7nGao6XnNNQs4tgucccG8GBBh7jIRr1MU0ioUVkQdUQJizS7VU?=
 =?us-ascii?Q?RQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bec3f74c-dfa2-46a3-ab3c-08dafa36e248
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 16:04:46.0437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jfckicfAvrgVZKErKDMX/w6Elz4j/jSWAzxV2LXlxyRNrmmGrARcP8Lktxpb5INuimj329wFU1OeCHLm6noeLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB8036
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MWLM bit (MAC write lock-step mode) allows register writes to the
pMAC to be auto-performed whenever the corresponding eMAC register is
written by the driver. This allows their configuration to remain
in sync.

The driver has set this bit since the initial commit, but it doesn't do
anything, since the hardware feature doesn't work (and the bit has been
removed from more recent versions of the documentation).

The driver does attempt, more or less, to keep those MAC registers in
sync by writing the same value once to e.g. ENETC_PM0_CMD_CFG (eMAC) and
once to ENETC_PM1_CMD_CFG (pMAC). Because the lockstep feature doesn't
work, that's what it will stick to.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_hw.h | 1 -
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 4 +---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 5c88b3f2a095..98e1dd3fbe42 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -214,7 +214,6 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PSIRFSCFGR(n)	(0x1814 + (n) * 4) /* n = SI index */
 #define ENETC_PFPMR		0x1900
 #define ENETC_PFPMR_PMACE	BIT(1)
-#define ENETC_PFPMR_MWLM	BIT(0)
 #define ENETC_EMDIO_BASE	0x1c00
 #define ENETC_PSIUMHFR0(n, err)	(((err) ? 0x1d08 : 0x1d00) + (n) * 0x10)
 #define ENETC_PSIUMHFR1(n)	(0x1d04 + (n) * 0x10)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index bc012deedab4..1662e3f96285 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -590,10 +590,8 @@ static void enetc_configure_port_pmac(struct enetc_hw *hw)
 {
 	u32 temp;
 
-	/* Set pMAC step lock */
 	temp = enetc_port_rd(hw, ENETC_PFPMR);
-	enetc_port_wr(hw, ENETC_PFPMR,
-		      temp | ENETC_PFPMR_PMACE | ENETC_PFPMR_MWLM);
+	enetc_port_wr(hw, ENETC_PFPMR, temp | ENETC_PFPMR_PMACE);
 
 	temp = enetc_port_rd(hw, ENETC_MMCSR);
 	enetc_port_wr(hw, ENETC_MMCSR, temp | ENETC_MMCSR_ME);
-- 
2.34.1

