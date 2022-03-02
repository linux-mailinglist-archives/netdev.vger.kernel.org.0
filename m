Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932384CAEDC
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241783AbiCBTkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiCBTkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:40:35 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2068.outbound.protection.outlook.com [40.107.20.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E47AC4E1F
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:39:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lua+2tT+iFF/m/h2GJH1Qhp9Y7xEr2DaL8WX6KYOW+NHnuD5CaXxIGycY9gtK4FupAGVD+KjzjKEEQvglZQEEZ92AiLC1cAzartzwj96tp5PbPIH43lyB/T3BFgJc7UG9azzKuaeHgxL4U8J26ZQkSxOKVq5UPCXKjYyPbH0WyVTZ6tBMIX5TtwlC7qfsgiRxraoS9XW/LiSGXqPdyBmlTXfzyzwv6x+aaRGN57j3yIdUcNSWgRSXDjiQ1eaDj4od0CqEBLAc9m5FO4jKJGKm3l6NI54+a6SiuZAvJqhnXY9qn/TH4NzWNwNOTH/GqA3/FUxfA2ftSmI1pwtOqihXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qjamS3vO54BNus0GAUWdeA1Pv6Z5sHUEzJkebIQkP7s=;
 b=LCUq+L5nDdvW381dyfEntOprmdryIkNFXRZo9s39ggLgXtzEUe8i2zc25D0dU+XDLcReckm8VshO43kSswX6TXnmQs92ZEDBur5bZgE/MCCopizeTbTNqwCOkSrnvVVGNyN5q1MgHu70Q0+Sdwa54YeOticVFeL/nBDteSbe4mo+oCu8bvzs80QxB/7xXcWiEcNVp2YMv9zbg030srn3hXSW5LAv2h4HNQLNnNEduC7mPEAbqBd/f3yt3qlyVu84A6vCSGWgLZVbK4oZM05yOCpBfSgJk1v/CuYzETPaPQ1vxSlqR14WRLZbofyC5D6n+mfhGxpLlYIWhW5UnvXq5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qjamS3vO54BNus0GAUWdeA1Pv6Z5sHUEzJkebIQkP7s=;
 b=PvunMi2f80y1CjHdF9TUZ98rNygL2Rg3f1ibvg7iemWT2f0nLOd2l0/tTZLquNjP/8xy+6onzs8+yYbpedwFGpQnDGc6Zf5Bi4XlxV830W9zkrjcdAw6wAicdvZAj0AZWc9VIF7o/xTctnFjZBGD4gOuvXUgHeNuLmaF4ATaz1g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0401MB2601.eurprd04.prod.outlook.com (2603:10a6:3:86::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 19:39:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 19:39:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: [PATCH net] net: dcb: disable softirqs in dcbnl_flush_dev()
Date:   Wed,  2 Mar 2022 21:39:39 +0200
Message-Id: <20220302193939.1368823-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM7PR04CA0003.eurprd04.prod.outlook.com
 (2603:10a6:20b:110::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1316f092-2ce5-4aa8-76a0-08d9fc846976
X-MS-TrafficTypeDiagnostic: HE1PR0401MB2601:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0401MB260108FC90A965DC95CB7E5EE0039@HE1PR0401MB2601.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vN2tsTCcjHETa5XwRHqYHJntgbcrGJPoXK7Go500IeZq6P83AO/dLlV5KPabcACB1PsbNlJOAVAaCawkpBfQdIEJ4zIHtSghUlcV118byD1yJQEz87HfZRHCyNmBZkrTMdLXx1dc2F9bCErbxYIzjB/scUNP/Ar5yUJ7MWre2zAGfNABKTa46ffGvu+E9mBuY4W12XIL81hrnhHPmRMSK+rhfXo+kUBsHbbqbrXaPpagmBwY1+4pdG87XlITZXCQF+iSjYnU9gA3BoFvXlafbB0DWamUX4PlHwPcbxINu5mbQ3EXA+A8QSXGty48lmLoLIlUNUBksJjMFhPjZqVqriAjzVinZiRWqRXmUWxbPFHjcGHKPzuiNLqoceNNNSdFY6CRGvY+5NJM1uG/bz/ZlAx2PntIncSJ5kFpgq4DxQA/o8rEtx+Pf5f+38or/aibqthocZeXHuMPANrO4qGCxi/Kjg1xiaR4+neHXGGEVxtV5kqMM7jCEqcxkAI37qN7rZTmOr9HzRp/oxTjcUxNgzhQEzkthWjim1bXKzk//PbyAiwPGRdW082a+6fh2prWmbpA6ONHAVhPFV5Js3RVBgBC6woiDOkNoGR8ZJTXG8pwKgB5nPn6vuzTnSnh/600exXT7tF4EtQsH2ghGzUde8lMU++5d46JsRAd3MJEczJVF1YscFux3hsmD9cNPWABXUXxFxiRLfOO96BRGMgoqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(38100700002)(38350700002)(186003)(5660300002)(4326008)(8676002)(66476007)(66556008)(498600001)(66946007)(6512007)(44832011)(52116002)(1076003)(6506007)(26005)(6486002)(6916009)(8936002)(36756003)(2906002)(6666004)(86362001)(83380400001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LbK/aMmPtqpWkPJpIRetVDoBUFSLv/rpH7HUxk2vYfCfRz7Wk4uzlhCGlpwj?=
 =?us-ascii?Q?aSZlX9Jk6paLXbneCNVapFX8wCqzp1hkQnjIMIyVUX7TKI5SphrLKp0CHVkX?=
 =?us-ascii?Q?Qk0GzRJV/TNd/XUNi3rx936UdxMWxp8ozJxnj8fwrzQsYgd615YW19bCRr9B?=
 =?us-ascii?Q?Hd5MqekIxjbFveCeu4mZ+N6Vt30anb/ivJqudxSF1A2E8s3HUBjx3+ZLRM0f?=
 =?us-ascii?Q?ROpCl0R0SqueeTfyPpURgl8vW770yJOqCEtfn6pc3vPTAbquIO66XXnAuepz?=
 =?us-ascii?Q?WLhsuI1P5VmC7GkDoBwpQ8jtHiREq3kEimPRklqnrCEEcpPG9M93h7SwpGif?=
 =?us-ascii?Q?H3vxRSvCBcAwao9X7Ra7049QTI7ZgndbmYIyS+LS/8frOFJSrPbElCuvBbc0?=
 =?us-ascii?Q?mUb3fYhbrw5/2ZMBQmVDE8bYST9Y6gYEB00b6uqR7q6R4wXIqp4Xxj5/NzX7?=
 =?us-ascii?Q?kblaQTAK1QloObARuZ6ZohHW7mcQlq5pPi31q7ibAmsjNFVKiBX7IS+NsqWy?=
 =?us-ascii?Q?362mcEF2SBdA3zoo8EFJalbO1sB09lYXayiiLiffZax0o0de64GgLC9Wcuri?=
 =?us-ascii?Q?la2vPkOU/fsgxMHeIbK4zJo/k84JWNcnaR8l9T02ktNu7nTzWwd8n99O5iXI?=
 =?us-ascii?Q?c8PCx0k5ehV72HS2dKfc8VbxHYfRUNCBf8OY6WXy2uQ5QG5zOYvKW6Mgz3q8?=
 =?us-ascii?Q?+wFknDz8c9A5REC7mydbCAtqRwyLsnOZCCEAvmPIvl3n9mAhFwXRtFpB3aFL?=
 =?us-ascii?Q?EcrOrVvmPr4Q7i8/GI6FZ2+CqiNmrPJ7MVm2RLj1pEVSHeQ8S5UVuOhkt/1y?=
 =?us-ascii?Q?Uqkm773i8Y3OgC+5tl6vgMU7SKGfpgkwpfvUve1D8YYJr+kld0JzsJZTlFCO?=
 =?us-ascii?Q?YXtQXoOdqKQQT9OwFSNGeQkFU3Rpp3avDIDa/kNMLv6Ri4OY4PvQ/2TcjPHF?=
 =?us-ascii?Q?kiQbiX6+2pZWNtA+RQ7dFuzweBBwta3b4oLxPLT2Hr0o7zAHqFakMCb504Gd?=
 =?us-ascii?Q?zlndi/JbXe58EAfAdhCnQ8iaCfHNqlu6cRiZccNx0Ya71yfyW5xvZ2YKjyoh?=
 =?us-ascii?Q?MQyJRSQfgp7uTmefXhRyR2XRoNNJga4mBLlCLjePuQqPLPIO1VCDE8pfK0LY?=
 =?us-ascii?Q?qy63xDUQ9KzhfwuEO1fLHP2lJKSvKth6Ww+NFIxiBHSErDxihGx1ednAByCu?=
 =?us-ascii?Q?ns9qAD+RpsG90bt2svwfo8OMQQbIzq4o9krtIWd/LwO2D2HcZhOC/rFy2Qn1?=
 =?us-ascii?Q?siM0Lg1OrvPlyzGZvoOh5Xd6oa8pPi2of0NX+/YSSxYowsOCAzG4gkrfFEIr?=
 =?us-ascii?Q?OWdbWnFlsnY5oWKidxNdEf4qTZZOeXz/KCobv3Y0krsxwowwXQRvV54+QeFv?=
 =?us-ascii?Q?eMtmW+/AKKQkn7Aq+bD4MZxPZ3ncPcM2QEvqc3xgLLwnqt1xyS1xTVwYhVx9?=
 =?us-ascii?Q?ijrHb6jaVRkzCXH8vd5eoP37/R1Vjl5Q44Tr8TJSo8OadnmeFhNx/mlRPRCJ?=
 =?us-ascii?Q?HHu0EZdAR7YPM/zecbcY177nQFcDA20hAa+asLZ7CCyTcl4k5qc2spvAgIrL?=
 =?us-ascii?Q?jXMIPjemKjMqMY8ahe7J3XMjsvqgNxelf1jgzGvaKK2e86PsFA5tM8VbkfIa?=
 =?us-ascii?Q?tAF0xo2skJ9Zf4Xenh/adtw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1316f092-2ce5-4aa8-76a0-08d9fc846976
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 19:39:48.6608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S9TzaZ9oT8Ljuh01ZUVqL6CESB9T67Q3OENbfkJImUP5Oe5yjpfx7bRdmJsnD5w5NOdIZbmMyhA5/foX6p/knw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0401MB2601
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido Schimmel points out that since commit 52cff74eef5d ("dcbnl : Disable
software interrupts before taking dcb_lock"), the DCB API can be called
by drivers from softirq context.

One such in-tree example is the chelsio cxgb4 driver:
dcb_rpl
-> cxgb4_dcb_handle_fw_update
   -> dcb_ieee_setapp

If the firmware for this driver happened to send an event which resulted
in a call to dcb_ieee_setapp() at the exact same time as another
DCB-enabled interface was unregistering on the same CPU, the softirq
would deadlock, because the interrupted process was already holding the
dcb_lock in dcbnl_flush_dev().

Fix this unlikely event by using spin_lock_bh() in dcbnl_flush_dev() as
in the rest of the dcbnl code.

Fixes: 91b0383fef06 ("net: dcb: flush lingering app table entries for unregistered devices")
Reported-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dcb/dcbnl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index 36c91273daac..dc4fb699b56c 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -2077,7 +2077,7 @@ static void dcbnl_flush_dev(struct net_device *dev)
 {
 	struct dcb_app_type *itr, *tmp;
 
-	spin_lock(&dcb_lock);
+	spin_lock_bh(&dcb_lock);
 
 	list_for_each_entry_safe(itr, tmp, &dcb_app_list, list) {
 		if (itr->ifindex == dev->ifindex) {
@@ -2086,7 +2086,7 @@ static void dcbnl_flush_dev(struct net_device *dev)
 		}
 	}
 
-	spin_unlock(&dcb_lock);
+	spin_unlock_bh(&dcb_lock);
 }
 
 static int dcbnl_netdevice_event(struct notifier_block *nb,
-- 
2.25.1

