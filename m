Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B24E57B541
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 13:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238282AbiGTLVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 07:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238067AbiGTLVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 07:21:14 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2047.outbound.protection.outlook.com [40.107.21.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91069474C2
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 04:21:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXXT3O7if/Upi4xzutCtmtWvM5lojnktwJ38lt0GURdxCWLyhi6nALvRzJ0k+narZDMU/YJGgYRkntdB8YBFeb/n50/pKM7sxMGL4VtNUXnW9VYOKlzWLWDLI6mt1OuL9bJJNVQ1L6rPs3fhBo97Z0Kj1H6Q4Q6bd8V9t2QCyO2mm2wbu5CPQTdn0UDB+CtbkGK52o6l6C7fEt1pbz4zMjJt7LJV/slB4OkxpGwvSOLExkFL9+5AKzwgaeUo3bBbLhPzTZLvcEdsfYjN3WSueQtPTaDGmNiDzVtXHIEUEt3bEULPgF14WdphqgYoMRaKW9B+TVPgDlkW66Rj4gctmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJF5WvCUNN3enSZ7wAAKDWIZRG3yK9LGh/ZMRgetKkg=;
 b=ZqUBJCeb0zSEUepuOLESQZIpMi9KXODFKEjG/IqvOfSiCpl2vEidGex7cuyCGurQZkcv4ePXfKjdpLZYcmh8E//04qTUipySFc9nBtko/554sooLjRJDn+1z2F40oJV75cNHzcCOU9UuV1pDD+KMJQs29+6R2qoi8tzv3/h+Js0sLw2NV+AJbSqDsUZKdkDv3tyCZjVGKOecBRwsbdKMGUp2tf5/zrCM+pKdjWJ97AVNXKPfyciYw0n3vsmCXTRX5ZvFN6AxaK42UrESdtojp80LTBi4jN32f8FduqHw8FO4HUXkIvEnMvoxTOdxyszj9uN1wTwIKyfVYva9+N3P8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJF5WvCUNN3enSZ7wAAKDWIZRG3yK9LGh/ZMRgetKkg=;
 b=lYV+KmeOpjdhhmLfAdV0a3eEMRaL6ndwOYYe/ZKuwhQGmLlexN0/zr+Fzvoqtqlh87PY+QCcgo9oQdtrIYE0WHjG70OTkvzFa0tncv+vcyjjqF65/GZb+BQSZDYLqBbQkLHdUz1BxCIEL8Nfq38I0bCZgPT+siXNXM7FWbT0uZs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR0402MB3428.eurprd04.prod.outlook.com (2603:10a6:208:1a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Wed, 20 Jul
 2022 11:21:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5438.023; Wed, 20 Jul 2022
 11:21:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net] net: pcs: xpcs: propagate xpcs_read error to xpcs_get_state_c37_sgmii
Date:   Wed, 20 Jul 2022 14:20:57 +0300
Message-Id: <20220720112057.3504398-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0044.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1918a9a9-e9fe-4091-0395-08da6a41f1d1
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3428:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tWWerAo1vjQtXPBVylsOmyY7fww9qHNOALHuuSoed+YnqvldcRZkFfnX8UHEH092BIgeYovUU6zqxHiq+tioIdWluVja8E5Xi9YogJX0xkpM85Zxg/vqEB2dau41mi6A6ie5A28P9YFbpU5NGYxuhG889S4ilNwx+bI9E7Wre5YD175iaGs2ANwk7DxIen7ZJ6MwnYz5QJFAbdHnr6AUSIQ0RkyOZcjdApt21bL/XzkvNdP9VOYxI2l0EQLjLcyuNfUlmILDpky8AeCX9HuJXD2lS/b2y0cTB3egLyACwXWz64T24NfCVfI1EX8FeC0wBsMHbyb2oBBTGouVMO3014dd6WZDRXXH05wTcnwL3BjKSfBQ43rm1fIQobGzuuOZUYTO+ct5YyO4D/hFqOG7wSCUox3IBfWxfYTyqTU+tlbHkd7AsDPFLGVxbdsGnCGx0LPjSMlmz/PGLmKczAzUvDrn5+mntMDRG00fnBQPdPRiLNTOSk2y462RXJd6plAYJT8aj7WA6oxGNpsE0RX33S70cDk1cu0R73Y6jVUPKELsbMWMQ7BK8ESaP81tYruK/j+wVjCohaYjCmZYS5TNrn3Ecvq5OH5I0A4lo3WQHYomOgRIV7E1VCk3QHk437LtIGfSPOj0pYzqvPUuDO/DV9QBsDdNH8lUbqNOebW3eKLJ+ib+wdfHD+8TPZr2gkOpeqTorTRpIEAt/Cm6c/5ja/H3G8aGiaMk0sohcRVmGdHJwzKiBGuL/W4pLU40Hzf/Q3L2fSRe9sxmcKyEbqEVSHAvVq1RsPsKPC1Zh5GnEuM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(41300700001)(83380400001)(6512007)(2906002)(8936002)(1076003)(316002)(186003)(6916009)(6666004)(38350700002)(36756003)(6506007)(54906003)(38100700002)(2616005)(4326008)(66946007)(66476007)(6486002)(8676002)(66556008)(86362001)(5660300002)(26005)(44832011)(7416002)(478600001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c1Nl4pimolQoRZecn20KeLPZGsYKokY2hCyQe0jJKul47c3bVgZHeyKmfx+o?=
 =?us-ascii?Q?PJe7IoqB6608jzCv4Gcdi5C5hcTGrnvhvRGvjukYKkUOd7CWRuUi6NnkM0Vh?=
 =?us-ascii?Q?AHYVlbbIkRb9GU+CscYQCUIx88WRzMpQjf8Cv8HVzY+x1rx5YIwF/9MJ1k08?=
 =?us-ascii?Q?ZGubT4t7KsmyPyCIWKbFlUhxL0Kz5Im5LNCGcrHZgV0j7QmfXwRZfXEeUaeH?=
 =?us-ascii?Q?gKt2zc1Yw48OsJSXH5Bi3VWESoti93qw8mpM1/ETmaQ5860bdmJTmRdSV3OY?=
 =?us-ascii?Q?tDVxQc14AXRFx889ZYoF4vXnssBan/JR5SWxjoZ7xEI3pTLKAoxHb7CuKDfy?=
 =?us-ascii?Q?Qlx3MHqEV7YDJ3RHuMrg7ncZkRXykLN1gD44h4KIsDZT1zu1luYGWDoBYnZB?=
 =?us-ascii?Q?k6bBcEXQo1zyAeXtIX9bGDqDjjXIQISvlmq9RKpRMEakILMwNoTlNhsJZAAd?=
 =?us-ascii?Q?NHNXfKPb3vLvjVKWKhG4XZILP3SYZ+jfmPR+0z7b/fTmqf4qVEtXgWWiFhY9?=
 =?us-ascii?Q?F1mIRPDx+xsk7Fyxy0W9nbkyceQ3uO/4pR1RHBDFYPs+cSebYaGN29GhcR3Q?=
 =?us-ascii?Q?cfBE5qAGno1qURZhlnzyonpUrAdfAwOZofK/gXHfujSIUnez3u+GlPB7h1F1?=
 =?us-ascii?Q?wE/zgMWAA9TaQYmoEpJWl1BlMRiHOBjjhGWQEMiOw5xqBbmP/E4xo1/eycdD?=
 =?us-ascii?Q?+QIfIYat0MZJMgzHWIaMVIpUMwQeQa8aprd7ld3ALcyy2dl5iVIS9o5AZ25g?=
 =?us-ascii?Q?2fi3dBnBGXpuZUmALAL772+TDpHvuDLvjVqp8Vh0mkCfy+ZV2mGVkFz6qXe6?=
 =?us-ascii?Q?MJvhEPhCA56WzzbM3qaj312TKesNaHv+Cz5TiRld6ylc6f6ssDMqSCrRVtEs?=
 =?us-ascii?Q?7CuVUPx0E1uQOu/mIglZLcd6Lo9l2g7R1U5dwNEPJDr7nHeDsi4VFnTY9TtQ?=
 =?us-ascii?Q?Pvgq9N5PNW+vvn2OxngE5Ymn4tSq0HgzMyCm8Dm7WNyAVJUO1pYr/Y5OgvEZ?=
 =?us-ascii?Q?/tPGrizQrjYyzvIJiSBV+sktQZIcH5WBeE2LvFhnuYxqWao1TgH10gHyJfr3?=
 =?us-ascii?Q?P5uiQoj8TgnE0DU2WeF7dFI5MXE48VFsyW9IxpRuMY+3cwetUq4W4kOoCml/?=
 =?us-ascii?Q?PwVXpmPrgLa3CWS1HJje/lllCBOme7hrzpPPK/LchUejmq9vjAkFffOJOpNu?=
 =?us-ascii?Q?VIITKGEEb3d3zW3+iwTLRS9ETk4uxnzMjhxRSaBdGbe/XS1H9+8gm9BRKobL?=
 =?us-ascii?Q?rmHWhZyVHgqBpaF66Ri+5foOossxQFY0RLGeVOB87nClSXdZDKPzL2nvVo7P?=
 =?us-ascii?Q?bx8FamqXNIgkrTLUgmkFqQLM0vnJ+m+bJoDKhHNrYgK+eEE9o5Qv+7YdJWzm?=
 =?us-ascii?Q?kuSAkrN9etNrOdSgLxIyEJhL9XMlR9NntrKTyMY2L5E/OR3XGk/UYflNHfJf?=
 =?us-ascii?Q?E10Tmx52yF/wVAofUwyBHrq7/eFk+oM9dTC2cTB7P46ofsmUhLoiL7nIGMLI?=
 =?us-ascii?Q?Co9/RsKEC9D5+1tjHyOxdNanPaSg4a/peVSHsXwREzzLdrITQBTCvFyDYQ8F?=
 =?us-ascii?Q?vNycrRvFRY7sGnX45HyanyoilQyu1t/5IRm9VlvK7jKgm7QzVDolLowgtCQh?=
 =?us-ascii?Q?Xw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1918a9a9-e9fe-4091-0395-08da6a41f1d1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 11:21:09.0959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QHBPNG4G4Fjegf8YhYpeSd48I+ti8sYMKvApwIe6cmTCXfXRMkoqzNQZLEhUHeCNq9MMGKkiRs0sszjiPBvlCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3428
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While phylink_pcs_ops :: pcs_get_state does return void, xpcs_get_state()
does check for a non-zero return code from xpcs_get_state_c37_sgmii()
and prints that as a message to the kernel log.

However, a non-zero return code from xpcs_read() is translated into
"return false" (i.e. zero as int) and the I/O error is therefore not
printed. Fix that.

Fixes: b97b5331b8ab ("net: pcs: add C37 SGMII AN support for intel mGbE controller")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/pcs/pcs-xpcs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index ab0af1d2531f..70f88eae2a9e 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -986,7 +986,7 @@ static int xpcs_get_state_c37_sgmii(struct dw_xpcs *xpcs,
 	 */
 	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_INTR_STS);
 	if (ret < 0)
-		return false;
+		return ret;
 
 	if (ret & DW_VR_MII_C37_ANSGM_SP_LNKSTS) {
 		int speed_value;
-- 
2.34.1

