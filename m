Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27AA628F23
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 02:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbiKOBTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 20:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiKOBTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 20:19:14 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70075.outbound.protection.outlook.com [40.107.7.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A7417E10
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 17:19:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pjs7QjDwk/r3RFiFTumqG/kJzc6J6rv/aZ2PxxgV8IeZtbuU7zfk6yYOdUcTkvXK6nChvZX4hpyNNBWbBWBXxPid4+XU9RafwVHGq1YDNvINcc4LIBHo32xuthwiVC42Mtlp5KxJw5FtrKv6dCn3OmaRENuy1dc0r8ynWChjFnY69Y422D+y5sK+oKsVm19xCfxUGJNY3DkG5y8wyYcj14/V3nm3aQE1iG6CkiqMmGKqzm1hgiPdDs/GASyvzGmxLlRkfwH+GjmqSD7WMJ240BrtW9HUNTel8XDO1X94BA+IhWBk74YsI+iBAIMRZeyRHz8AlgiqLI2kFPupnKLQJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=48sYji7v5eu9xcrE/QeRVEsz88ardifB46uZI5IQcIw=;
 b=jpyHtGkRakP+4z/owDn+iHnlhj1mLWN7WtnpPk4iATUNol2cjDmN0poosiWpHf/1EwBwYMsEYpSkoyHgBmDrIJFRzXz2aoD2OPQxoWafSeM5Ro6KAaIP860uhtmb3AH2hgnwoZu6LXHOU9fnOQKag/xJQJfXZDezgN6sk3PAUP+92EOjPDOsFCWXNmJMoTmrWsQ2UH4Z0zkq66JgW3ORA93v0KqpEOFNcxO3Zgm3OcqtB/PjIrw/XBraBpznIDm5P8P1V9dwCMkpsfO1P6HWfGjhmLnWLOoZGV0hkM+DMe/eqOPesQ5ithahWTnxu5iA5jCm7PST8tdgvVTzmPLk8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48sYji7v5eu9xcrE/QeRVEsz88ardifB46uZI5IQcIw=;
 b=EebnQzWl/spNef+oYKxX3bVNyFxbfPFhbI6dUXw4tSwrpNaYAMH/5BDsL5WilbInq/V8qYdiEl70xDZWy/w6tCTweHlP21Ukpr/W1DbDwxN2fS8JaTK6ek//fKXUJIXlt+tEs+ZnJm+Op1GBb99Jjpu05H3Za00Ih8sZucECQtQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7815.eurprd04.prod.outlook.com (2603:10a6:20b:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Tue, 15 Nov
 2022 01:19:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 01:19:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Walle <michael@walle.cc>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: [PATCH v2 net-next 5/6] net: dsa: rename dsa_tag_driver_get() to dsa_tag_driver_get_by_id()
Date:   Tue, 15 Nov 2022 03:18:46 +0200
Message-Id: <20221115011847.2843127-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115011847.2843127-1-vladimir.oltean@nxp.com>
References: <20221115011847.2843127-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0006.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7815:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ddd1aae-9da9-45c2-f66d-08dac6a761c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZVQ6r8TShMJ9iI5ACR6f6Yb5UR8O3k6CMOjrC9vIx6jdEqN8CBFZ+HR97wKHWwUDa08U/pwtBZytO90ddQFOHLkESx4vTShEbetddID/T+VenvV7sB7kkLiHIop1I0jhPzbMJCueztYjMHvXOd+Vg9rnO9QThUL/4r5BTf4PAuKm9hYliEA/V3MOvMvLUxeoz0Ki60Z9MbmqCW5dmtGOOK5Lbv96W4gqTwD4xo+UHnPHO3XJPuykugK4a6FGDu4qjh+OYCCzpCzP9tnoqKpCEZ2LifPsvxXsESGh9GPQeFlTletgfatDW8A64vOCWN6KkX/Exnka/iCt9kqaP+NVA/BbaGZtpNPt57gaqa0A9pLWxFtejmkRq4pOu2jtAK6E/RA0xxGhFEoVnEQGIBhM7q3Q9aO3gRloON235tEukC+4w0qaaKTYMb8RAbQ3ly0mi09mgDYk+y9l1q7FtgWDKNhIH2XVP/JbNT2sUVtNflGuSxGhkKnKsqyCuvvu6NTjOQ7+Uf8bXD1GXaCzHIzBUaj9pokSIJc6NKfc+eCF/hxOhf7K3UCj2Sg/Abzz05JrRU7wDz/rKR1CMjMEUGytyUWwUJPptMeL9uVdWCeiN+tD29TwjM8J2ho5NZ6yn10D5YU9TXNEH+9xvLtjcSEYgnjqg40wjMFZWDuKKrt1azOQ+uVJk7c9+PHpSpr7S0OBfSOl5qoSTg3kXdaarUX5R9TosjvhAFlWZKLP574ZNxvUiRFQMJXCI57dGtijcENdjJIeE2hVD9Kf8iAHloGfcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(451199015)(66556008)(86362001)(316002)(6916009)(4326008)(7416002)(8936002)(8676002)(36756003)(5660300002)(41300700001)(44832011)(66946007)(66476007)(2616005)(6512007)(38350700002)(54906003)(38100700002)(478600001)(186003)(83380400001)(6486002)(26005)(6506007)(52116002)(6666004)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DNuXHWV3x7799+IU47lP07x7UR6yQ3JW/6Uy5VUresjKzjpE9RlK4uIX7Ity?=
 =?us-ascii?Q?qpaOsCKzJdneFZZClKNV1wH60t00RAy0WuxWmyAQj404oUpdxadf4h7YRFG3?=
 =?us-ascii?Q?azi+GgWsnCtdyEHZ2nb06NyRUYT2d4m2WmjO3V5rGCeO5ZQnXhNDs+oZA7KQ?=
 =?us-ascii?Q?0dNcgt9aGmomrk1yGLYKOjLFPJ9MiRYbxvSLL1oIRaC3sOz8EY3koIoFf1ri?=
 =?us-ascii?Q?cJxI+6R7tQoR7bVdRZw77hIMliiFY6Ut4SAueovaSySu3Tq3VjFj29OfC7wa?=
 =?us-ascii?Q?/aNtAtcjZTR3rY1+fjcXvAcncHZqreVIHB0utNl/ZjZHeIau9arP3xN4cCFX?=
 =?us-ascii?Q?1Y8VwbXzRqJuuJ2VVh4y2JvQCukOccR4SRP8KzTWKVjxdoVgY532Uq79DBGQ?=
 =?us-ascii?Q?4em239RKYfqyidWVDJFVowWYmie9JiaG+BMfmiwHkuIU5nybCKmeiGVEHfXo?=
 =?us-ascii?Q?G4l0/7wnHyhQTe8CW+7UtzYRcT6Wrkpcf9ymsiMbHIFE92w98ojGIaj0Mw3w?=
 =?us-ascii?Q?PmJkCkxRwmzb/7AR3lGv8zgHqkuC1UzwsaUY1YhDAf5s06qyUFU9nq6GkOYt?=
 =?us-ascii?Q?lNtk3u/de+x47g/PoLGsACKH4Pj8b6vHjGUR7HVmRpxDYgA821h/vi5iIo3C?=
 =?us-ascii?Q?67Rp3jkF8olO33qJKP+QwNLmApMZ1D++i/Izc5O17BqOkMaK7cpHkZcGZcw7?=
 =?us-ascii?Q?qxqKC1xeVXsmX6PEKHEJo6two1IYG+s6z4g1FM4q3i45vLDA2LYpmEvBs9YD?=
 =?us-ascii?Q?TWo4HBn+gcKpqB8pGXU4CKdH6qxvx+hzgv52WphpismbNrCreGuf/UrRHgyT?=
 =?us-ascii?Q?N8IIT3l3id3DG3v6sAZ+onQjWGNK6N3C1ARSrf2hbzFkD5rQIYveSFtP6ZhL?=
 =?us-ascii?Q?9qws+t4EPcZ/zj7NfBcJzpfw4cA6I96q1riTmqv6JcMxV7uYC1skSSjAQrfk?=
 =?us-ascii?Q?NBHDicCPg0Z0ARsnkIN7yTuVmTRTJClDnvTYhn0fyvgWbbhdJ0ExF7Ppsvk6?=
 =?us-ascii?Q?meFEs7vB8i7yUMkHTItyBLKKvzrGgulvkLYZI52VbdxLg4wriDPBO/2ZanB1?=
 =?us-ascii?Q?y6Ym7LOQc4+lmviRNDz6zwSCCLk+qWBZEd23zy+RDDc3laa5ZaPIk9RZL/xb?=
 =?us-ascii?Q?O0Lpd1kQlzfD5zXxlND8yBdIJhIuVpPKp7B46waHR0auHQhkF6LEUqYtAUlQ?=
 =?us-ascii?Q?a5JwvopCgBO1Z+ae9EVlT7UCC5GcWQS31iSLRyoPkMXmr7FSTYxdHqHMFTkT?=
 =?us-ascii?Q?O24XVTvlwoNy8sN8KUzIZ+M4/JfXlOf9fFrbImQrTSFO9gm8YcErSuDqjJD0?=
 =?us-ascii?Q?+Lx8I/NqcmPCdw+iJZlLqpiPOTLH2sopO2utkfGxsQnr4EB8nyzWcS+FHVBI?=
 =?us-ascii?Q?rps/IRRV/2TwRUuuVMjhx2q4UHfaJ36zlGdVIsBJ21lJHRqGt5rqDaSy5Xfr?=
 =?us-ascii?Q?vFyBRkdbH7OONPVulEMzw5igaIG7JJTTn3zjwduNKj6dk0Y/mLfgBwUrJW0B?=
 =?us-ascii?Q?1oc6QCOW65MAFhOfivMY3peO3BRWr4Ivv2RTzQhe8BHTEV2zFj5N/nzTMBVe?=
 =?us-ascii?Q?T71Xjkbd1wqVf5ZjGMMxiaWOa2Xa3oE/ehKUr5OA8C525yDuqIoe9RIK+LpJ?=
 =?us-ascii?Q?VA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ddd1aae-9da9-45c2-f66d-08dac6a761c1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 01:19:03.0004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PNlJEuP5zEwp7qqeXyUdTT3CaS+gSUpWKxHCsPb2VlPX0fWGFFxKx+BICN3Ksf6TKPdeDVCAGD6Gy9zywr4XJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7815
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A future patch will introduce one more way of getting a reference on a
tagging protocl driver (by name). Rename the current method to "by_id".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: split from previous patch 3/3

 net/dsa/dsa.c      | 2 +-
 net/dsa/dsa2.c     | 2 +-
 net/dsa/dsa_priv.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index e0ea5b309e61..d51b81cc196c 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -101,7 +101,7 @@ const struct dsa_device_ops *dsa_find_tagger_by_name(const char *name)
 	return ops;
 }
 
-const struct dsa_device_ops *dsa_tag_driver_get(int tag_protocol)
+const struct dsa_device_ops *dsa_tag_driver_get_by_id(int tag_protocol)
 {
 	struct dsa_tag_driver *dsa_tag_driver;
 	const struct dsa_device_ops *ops;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index b80dbd02e154..9920eed0c654 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1434,7 +1434,7 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 	}
 
 	if (!tag_ops)
-		tag_ops = dsa_tag_driver_get(default_proto);
+		tag_ops = dsa_tag_driver_get_by_id(default_proto);
 
 	if (IS_ERR(tag_ops)) {
 		if (PTR_ERR(tag_ops) == -ENOPROTOOPT)
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 9fe68d3ae2f5..e128095f9e65 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -243,7 +243,7 @@ struct dsa_slave_priv {
 };
 
 /* dsa.c */
-const struct dsa_device_ops *dsa_tag_driver_get(int tag_protocol);
+const struct dsa_device_ops *dsa_tag_driver_get_by_id(int tag_protocol);
 void dsa_tag_driver_put(const struct dsa_device_ops *ops);
 const struct dsa_device_ops *dsa_find_tagger_by_name(const char *name);
 
-- 
2.34.1

