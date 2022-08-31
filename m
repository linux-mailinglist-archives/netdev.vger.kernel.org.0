Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640455A8403
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 19:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiHaRJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 13:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbiHaRI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 13:08:59 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150045.outbound.protection.outlook.com [40.107.15.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C82C6FEB
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 10:08:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/n7cbh7KDdICTXiamOHavrYfMwyFBszlIAbUQLkIYknREKR0iJfflGRLmjqUYGSLiBGhmpa94H8RuJqRWZrlDEZF9bmw+VoIrZE1Zh773rxr2y3o4C3uWo/x2k0OjPQxCagX1v+9ALa0xUOCt+PO5em3Lkj4yH4F0k5FUENemwr32Z4bHRAq+/v5OegK/0N0plbJXfiVBzYyVwnmTL+uTZdysf4YXQn2Bmrw91rzQ6xVjCNo1+HxpIX1b5x2g1peJtMGrbHZUf4t6BVBrOrEO9TV10wq52erTVsIN5KyHrY7zTq6Ukzsp+PPEh8Ry+blE/fwLp8gLDLB/qs7FqTYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FmcLtBME+0c/R10TeL59TyGX/6Iim0OGmAv+pWN6Qwg=;
 b=ZJzZBus0/CjLZdTVJ8flDtSwqLZenvs6y8esECiAhH4iFiMRWC6GU9uk1Rp2aaC+zcGEX5RFQ7i9jQusBsrngN90bvEhymrvsK9ChP4n1FDHoO/AEydWNyClBdVspjfUCd2c7QhgzdzKG48SZttfHJLlu+c35CbSOxygqeuwaCDsJTJDZFbd2RW0PSYKbyDtriHF2czSQEmpGGLDxtO39OfGjq7jWvu64Ho3U4ZlvSHJPiMbvnEMkNN9HcKY1O0RVF1+ITG1SfjT+/UP1GCXAVGNhnwi1rQO80TqzTWZr5ickk4j2pgKJa5H4HKNywjbE6PaQLbdreLeSI62fDu2zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FmcLtBME+0c/R10TeL59TyGX/6Iim0OGmAv+pWN6Qwg=;
 b=iYEVcs2EPPDEmhoEgOdF8EjC+93fxGeh0HtRvxp+0VrWozJy7m90yfjx8Jo+sf/CoVDnBuyayGsTILc7y+9NShb9uqTTiASPJ/25eS8lWZby20B1AGVjMrm2My55ECvZIIiuf1vTTcPEyzYnG0/Q+9fiDPOCxN9Pve7nwTQZlXI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR0402MB3654.eurprd04.prod.outlook.com (2603:10a6:209:21::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Wed, 31 Aug
 2022 17:08:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 17:08:54 +0000
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
        Colin Foster <colin.foster@in-advantage.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 net-next] selftests: net: dsa: symlink the tc_actions.sh test
Date:   Wed, 31 Aug 2022 20:08:39 +0300
Message-Id: <20220831170839.931184-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P251CA0024.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a598387b-57d2-432b-84dd-08da8b737ba6
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3654:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: liM/K9T/9YQ7ljEmDeergXJdj9bh6KQU+7o93ywscsTL/qev/adM1FJ2MKCZxXTnYp5jKEKfyXryDms92TNTiBYIUs/FTX3dPSp2iNCEZlTsjHL/Bs10rVfTXvU1zzq1vrK65OIxvJhALtyS8lSV8FnzhDR2XKuqCMlgtEd9z4s7UxCQb0h4JownpjNagcsBdnnmaiVubQD6e65avKRy8oPYUMbZasfXloFW0eiyPPQ4x4PgQgfp6LWVmA4pQ1Pxtu7gUo2kuhfUrN/LH236Vkfl6nxODr/zWgKCXkj68WKGtYE2Yz77K/LmiDT6aqU0qpjW/1RieJHHFl8X3264nweofdnhsTqdBPP1sSC70V4o8COUyoU6orUPwOQg6NyW9vc8FI+OOb2/wPmV8ZQXl/jxr/WKlGcrxs3ip8Yw1Qb8FXIJxPSI7aMC+tJSfItf1+bLemBEU+jMYwahL3ND/hGZe+wCPimkZplrOlN51tgpWnb43JyWS1UpxuckeUwpAo0myg2PlHcwKHwxThRGv32rNndjoOh4wVMQfGellQptqGRm5o8ADYaF3ZphMlyRW6Ea1tPnb1DYZzdD8SyleT2VhRHtI8gs7GgBVTSg17Tq57g8xIFp+dk39Vxrfdt+Q+aJEXzzAvZd7aO3c4dL14YFKTsKHF9/qHttHUjnP6Tlg9EMgFAw+Wy484NEta9p6lr2OgIVsxYZRBjvrBUXgzQmZ0rjCC2OcgXWIKUUfzKC79Z7l6vy/AmPXqOjIDA0KahLWpR2s2P6BxBC9v8z1USFydcGHOr0Bl4MgKe9vd0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(2906002)(26005)(1076003)(38350700002)(36756003)(6916009)(316002)(54906003)(38100700002)(6506007)(6486002)(8676002)(966005)(7416002)(8936002)(52116002)(66556008)(44832011)(6666004)(6512007)(41300700001)(5660300002)(83380400001)(186003)(66476007)(86362001)(66946007)(4326008)(478600001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?arwPAfFXMet92wnA7PQM+BgM7D8UDLZlWfyMQroKNEXAEHTLrMewge2boBBI?=
 =?us-ascii?Q?MdNvsMvB8cng0JcGQ+IlpVocnX2OtNE5p0AnLVZUvBMQvX1QJ7u+zdZ4qLgC?=
 =?us-ascii?Q?93Gc+iOVfssBFOTAAHPFct8Kw6TG7jyTIU2LMvJBwrmrjwdF47c7/nooPumF?=
 =?us-ascii?Q?GiCEl3JvKuGauZ7ZpM++drYdextuqgYCC7GI0BKBmNpHXnOozhKWamuncPTt?=
 =?us-ascii?Q?AUEGKAD1SHlMthLMfJ4UP/jKkgmcn3CnekcLSayOs3hJBKw7jBvQq83ETfHN?=
 =?us-ascii?Q?WzuaSvoA7PfW6ABS35lOhLMkJjvWCDCIadkbNdhyqp0gNcYNyenRD52CnUuj?=
 =?us-ascii?Q?ng3vj9g+e2xPuZiPNVjySLjFN9aiF5HB1/NY/qTguBdf3oMOLF4sGs8Lrays?=
 =?us-ascii?Q?dZxvu2a16wPVEIYMBrJlasVxVB4otzXQsSrQJL+hbIa5ncpQvh4h4tiFvHfM?=
 =?us-ascii?Q?5/ohKkwusZwPiPXYAan9dROeQnCOXel/E9uEqpwkRlNqizNP9Uy+mlADFIDU?=
 =?us-ascii?Q?7Dgl89UKABgqsBgTRjKWjs1bko/Rmh3OQePA7xYWw7Irz/KnM1/lNms7vNuA?=
 =?us-ascii?Q?8PIm5qJ5yMNsXAJDS3Ck77yaLpQNsUTVONHV8/MPWr8+zHRKwAC8ggpnM0hG?=
 =?us-ascii?Q?UYn/JhNeKRFFhGCxEmska/aSQiJTPGiyC4Usbeke4w+zGY22mf3zyizouhxB?=
 =?us-ascii?Q?bavf1e46u0bnrp+q2DEMI/TG933QuO9zF8GCtOnMr2Nze+cgLkT+lliXvXe8?=
 =?us-ascii?Q?yHdKITkg8dBV43gMU6fpEzxi5p7CKu02shXPw5p9wb67wfRh8pYfgIGE+pil?=
 =?us-ascii?Q?6wK4QJS+ZjGvM2vKj9SR/OgY3LfNQGifXIccDGL5239aeAS8IXwmP/MUHJ0x?=
 =?us-ascii?Q?g94ugSLuctjOJwBycep6qLY7rBzJgtRs/Xkegsnt+pl16SjAlAfKdHVbM8hT?=
 =?us-ascii?Q?zjDcjRnlbHe9y3aCsIbSWDeb+mRE0A7qxErJtZ3iV5awhKyIJkKbuCemxUHF?=
 =?us-ascii?Q?W1TFl0prY120fOJDtFJulXJymQzSHEfAxDDfZzfhl05IzE9SupgU61BmBne+?=
 =?us-ascii?Q?LtWwyU0ZwoLdbmU7JGB/65lpyoZWllwGIsTm+NaLC7r7eVmpky3iOcvNwBUh?=
 =?us-ascii?Q?Zq9eVBqGRUBq4R5/QTUroTQe+OKLwOi7l4KizOE6s/olK7G5gNwLuSE7jSOp?=
 =?us-ascii?Q?vKRBThxo5WJTD5d0GnbWVrkPOPVBLnkGH7Znjmn+LeLxSKyQYucJiQdBuqD1?=
 =?us-ascii?Q?fkQ3l9iX9gBcrXljDjhU1cWlFUnXZeV4cgsvRnc1u0+ZctCguJhEknXDFSVL?=
 =?us-ascii?Q?bU9ug7QHDC0XtzpDEMS7MechGEGEegaec2zuzKfAC85bGEMqzeHzf5Wlt3IT?=
 =?us-ascii?Q?bP+7AVSNg/O4kZakquS6Ya4kEbEOHe+gJVbS5yMzPnQMt05R+Eb4NzskTsTL?=
 =?us-ascii?Q?iHgxypN/lTiYRyzlGydv98UFSYwq9w3GPvnBHLaK9VZGUu0/CpCvNe8oP7q4?=
 =?us-ascii?Q?G3+DmdmR0Y9MTEeommEDKJU1eNCpijOEE+kdo5ufzltvzQ3hjmQXQw/xKyI7?=
 =?us-ascii?Q?g+88705PnD8rm4S1nBj98h7KPqUlJCea3icnsKxaHJXzb7uzVh4EisbEAAi9?=
 =?us-ascii?Q?dw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a598387b-57d2-432b-84dd-08da8b737ba6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 17:08:54.1169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i596bCcne/iOEu4dEIE6VmXVCOtED/+9PTAfgTCgEtwkcbgJn2AX00QY/kSazmQnRKa0uLD/f+Sy4WIKx0E4Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3654
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This has been validated on the Ocelot/Felix switch family (NXP LS1028A)
and should be relevant to any switch driver that offloads the tc-flower
and/or tc-matchall actions trap, drop, accept, mirred, for which DSA has
operations.

TEST: gact drop and ok (skip_hw)                                    [ OK ]
TEST: mirred egress flower redirect (skip_hw)                       [ OK ]
TEST: mirred egress flower mirror (skip_hw)                         [ OK ]
TEST: mirred egress matchall mirror (skip_hw)                       [ OK ]
TEST: mirred_egress_to_ingress (skip_hw)                            [ OK ]
TEST: gact drop and ok (skip_sw)                                    [ OK ]
TEST: mirred egress flower redirect (skip_sw)                       [ OK ]
TEST: mirred egress flower mirror (skip_sw)                         [ OK ]
TEST: mirred egress matchall mirror (skip_sw)                       [ OK ]
TEST: trap (skip_sw)                                                [ OK ]
TEST: mirred_egress_to_ingress (skip_sw)                            [ OK ]

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- also change the Makefile to install the symlinks

Previous version at
https://patchwork.kernel.org/project/netdevbpf/patch/20220503120804.840463-4-vladimir.oltean@nxp.com/
was part of a series that did not apply cleanly to net-next at the time.
The other patches were resent and accepted, but not this one, it seems.

 tools/testing/selftests/drivers/net/dsa/Makefile      | 3 ++-
 tools/testing/selftests/drivers/net/dsa/tc_actions.sh | 1 +
 tools/testing/selftests/drivers/net/dsa/tc_common.sh  | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)
 create mode 120000 tools/testing/selftests/drivers/net/dsa/tc_actions.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/tc_common.sh

diff --git a/tools/testing/selftests/drivers/net/dsa/Makefile b/tools/testing/selftests/drivers/net/dsa/Makefile
index 2a731d5c6d85..c393e7b73805 100644
--- a/tools/testing/selftests/drivers/net/dsa/Makefile
+++ b/tools/testing/selftests/drivers/net/dsa/Makefile
@@ -8,9 +8,10 @@ TEST_PROGS = bridge_locked_port.sh \
 	bridge_vlan_unaware.sh \
 	local_termination.sh \
 	no_forwarding.sh \
+	tc_actions.sh \
 	test_bridge_fdb_stress.sh
 
-TEST_PROGS_EXTENDED := lib.sh
+TEST_PROGS_EXTENDED := lib.sh tc_common.sh
 
 TEST_FILES := forwarding.config
 
diff --git a/tools/testing/selftests/drivers/net/dsa/tc_actions.sh b/tools/testing/selftests/drivers/net/dsa/tc_actions.sh
new file mode 120000
index 000000000000..306213d9430e
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/dsa/tc_actions.sh
@@ -0,0 +1 @@
+../../../net/forwarding/tc_actions.sh
\ No newline at end of file
diff --git a/tools/testing/selftests/drivers/net/dsa/tc_common.sh b/tools/testing/selftests/drivers/net/dsa/tc_common.sh
new file mode 120000
index 000000000000..bc3465bdc36b
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/dsa/tc_common.sh
@@ -0,0 +1 @@
+../../../net/forwarding/tc_common.sh
\ No newline at end of file
-- 
2.34.1

