Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2790D632467
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiKUN4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiKUN4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:56:16 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7993BEAF8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:56:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ado6YKLfEhTYBgyMfcvPETiDBONmkb4U/dLTwU0pkOAIf8uE9epKTsAhqgvNE6rny+UVysDo+Sk9x43BhsC2QGsuqlFTsr6qaPUMO7BumCOEub3xsIcQOdxJeFe9i32P49Z229OpXDYHeHNt7KSM1XZTF0YpRKiOxulXOu8EzOJXQYm/5tk7IVfd65QHQ4qn3UoUL06gMoRy1OEzimT8hnw/wXOzzZtr5bBEKf/A7CNUq7rdw2TE51XBkDj1AuBAWa28Rymq9kzrTZs2e9ONmtUlFRhHdzEuHfUmQ0qgMLD5tSOgemtl+Gv31jHXFvgObledd+CMcNpBzn1Zv6rEhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PMnOQKRZQTcJWvqWT+IWgFdj6yMFJoAycuuFpohmIeA=;
 b=LUpnYzrL2wc8PWHtwP1yhgT63YBZDrywXMF/1PVBgYBKrS5600e0e/0AikiURSnKlyx37PfSisR8HwqhQbHTHL5CgH2Cns7HWjd3h+aJ4G1zz5fZpsXfij9HixXYNKMj8lt42C9Z7d5ERMp7IhDJatJNhMcbxYMbmVDb23TE7CLdC++W2iVfjFFjrUzo4LA7vSDmxOwTFo4RC5wNskH/trjCvSMMLv8RT5Wi1ScklaBa/LI1HHT1ObVZhEQ7tjqN5E2MqS0FGkq46FgQjn0VXH0yoeN/+6caCjcHzrWSy1JEIWc9ROZeiTHr89p9ecHJ/9drAhnIix8ibrmGq3WNnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMnOQKRZQTcJWvqWT+IWgFdj6yMFJoAycuuFpohmIeA=;
 b=Rc8iMzw1CJ78sdT7/aAqUo0yi7tiIOrIusgXLWesPbkZ0jnexhAqMoB5fRD0sTzkYUDln0T19q4p68vxe3+TrhLIGCB2GIZsVGQS2aCHk9q+3DcQ15tkcLagQXk+XMjFZeWZApVjp/vCTiCT2icvtPtmqkJW9xFolZMxruHMEPQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8134.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 13:56:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:56:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 01/17] net: dsa: unexport dsa_dev_to_net_device()
Date:   Mon, 21 Nov 2022 15:55:39 +0200
Message-Id: <20221121135555.1227271-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0015.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8134:EE_
X-MS-Office365-Filtering-Correlation-Id: ff64ff36-b50b-4c28-3b96-08dacbc82651
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1r886+rjz/nfGA4jb3dsD4dhcZQ532qhAXKs4LCE2fNo0OK+6sepKFQWaYzXEJyvavEJq16kOaig23eZBQ/+iHvbMbnCsYIMkOOjphu0taywvE2VN1rUaDQBGcoQ4LPxoJltwVnA7Gb6IZaVYKAMu/IUE8z6AIKT012xlRxzWnn1xoH5fNZHdAR576LM3ckEk2rkD1d+9EpIbhycNUTjdueMlUd2jsovsh6ZyXZFpv58a3SfYztMCWd78yuOt4V04gUePQwizZTuoJWxKN5A5l03b/OnpeJ8bFYqgxRTgBkEiruRyPSEvxkjwcVnSLSL0UR0Vkj4iw4DYT/4O+PPLnxjVPQQ4pq5f25oDB8dEIrB0I1kFA3cwrbMOSnj5Wjq0d7imcSeAcWH3AHN9HLMJSn1RtA/F2BwpT/liHpSfxxPMvfI2TooSR4Wl458i6S6/yVHo7vvFzhYZKbR+F6hFQELKq7AgtJlgMltnQm8alrvG75wKzbZPHVx7xkBoagSoAto/hPbYVZcfL/4XFBfDP4xR/MnkEjQzlDU4vzlBw1BD/zS9s/FcHQR4Wo9YGbuEZ+zSoipESASpI6rdhhQ6aC8RQXZ6HtCSqMGBLg7vxl2ccvXvSX3YpHx5SLGhBTZgisu6B9fbr+TOYFuWduXlW9kW74x5b5trEG0smdHo2UZT4T6THmVpEMJjJQQQLf1IxxICWmLYWmNLBZFzR+TKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(36756003)(478600001)(5660300002)(44832011)(6512007)(66946007)(54906003)(66476007)(26005)(6916009)(4326008)(8676002)(316002)(2616005)(6506007)(52116002)(66556008)(41300700001)(1076003)(186003)(8936002)(38350700002)(38100700002)(83380400001)(2906002)(86362001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jpQMh8sCSSN4eHNoTBygaSvQqKQfysVLZnNQQDGe4xQ5MrLbrBLce9a9/PJD?=
 =?us-ascii?Q?n0YeFNnKH7066Qv7Z7C3J61RhLREaYRtQ4jdSZQRkHgmSBM73Xv6cKt9yX97?=
 =?us-ascii?Q?9hU1jYwYg/RnoyT0vmbsFNPWw++trUg4bKxF1K2Dikxb0R4p7FF0qddg1M8i?=
 =?us-ascii?Q?WuMx54EwV+Xz2kp5w6B39euNxu3jcsOe3HhHUduk0NxyWbnrUx+3E2td9VBm?=
 =?us-ascii?Q?wpymjbPXruFcf0kDiF7Zd6eqgVVDalkM3TCLnYM1qcOx6Ep3QKM2BWsGhhda?=
 =?us-ascii?Q?NKbNmU3FO4M5844bx1nITy73LKE+ubQUbYqzlDxAQelu3xNCrMiwwETCEY7H?=
 =?us-ascii?Q?ibXw77ctQkiXJQP5ejAM2Gsx/fMqqLIpj+Gl7zsaIuQajZheS7lLrni7XC15?=
 =?us-ascii?Q?JkZmLDcE6isHa4vSCwPXXPC+P3l7zhePCDrRYJDPgwPAM6GaP1D4+KHEltdr?=
 =?us-ascii?Q?XpWKCCT8kXfdFXJYhcAzercn8I8ol+9L4QpWSLfK8dpt2p0wL7erUtk4InU1?=
 =?us-ascii?Q?l0ksmEG7RvmQLMXYk2JEjfYQLHlicK8edaru9fF0RX0z4MSSXKjW/8zVZXb9?=
 =?us-ascii?Q?uyq+JJle3lYCN+pn0FyZ6hcwOVq+aVyMJcrT8QahWnqLn5RDPIZy0toU8UrQ?=
 =?us-ascii?Q?9uvDhjmQ7L7z9SF5M0WbIYKOF36nZE6cLfXbzU7pytNhMSBnf3gyVfNJmJZv?=
 =?us-ascii?Q?dG3txeYoUKSB510WDnobFu0TOlF6wBl+GesDACy32Lcw44D7loyneH9ZIIZ7?=
 =?us-ascii?Q?FrCFW4EqzbuO3lwe0XYbZOiV+CKqkIBUqYBgSSrzd03oeF+r4KLQR0H+PBQW?=
 =?us-ascii?Q?wlAb3eryVwQCh0HC+O0x70rINyomqUfA2Qv5yiTwS3uh8IfjKNs2ZjBcfLKi?=
 =?us-ascii?Q?2nSux3sFpjJxoZxhv+rvXgxLlViOA6qwP22vpQf/yJ+VwNxkZeBfUJLHOfPm?=
 =?us-ascii?Q?wqaiqVHKbmrM+z3H/R/zQgerLF6rxmgin0rDZBlb5u2gcAakVPKKMxYQLnFY?=
 =?us-ascii?Q?qt49cn39K1x+yTV/3N0+Mcvwibs/HO606Lr1SD89MYAZe8B/fS/Sc+/CzNRT?=
 =?us-ascii?Q?S4mvWAqwwlLGR7M/8vBbZsyv62vFr1HKInmMyF2lBGsymW2trLYjQnsigD4L?=
 =?us-ascii?Q?m0BY4tBI2W+fwe316avAgPWdHKfJpz4Py2kkBcKhn64jecEeZ/exna22Gs2O?=
 =?us-ascii?Q?7dzVafkc7wzxxcYMlrPL0YCW3WY3UgfN5PVq9+FEYi2YI16ead9ArrII6Rzw?=
 =?us-ascii?Q?cdvK5rXouLEWnSlFyFj6HuTYaO1XVaAFJ0kxAci7Sh3AhReB5k8f5WEOxMle?=
 =?us-ascii?Q?ICKte/il8JxYlCBuiit3G2fS8gT5FSB84kpsHe9zzN6Fc5HLrStrcqSLxL5J?=
 =?us-ascii?Q?hzCTu4Tth+Yxn1XNXtvw5FcaUryyNzH6FjH7/Wud+kddC+dtFzPNAr8H3olB?=
 =?us-ascii?Q?tsZIdmR5ImD+ooaY+HYUBc+GTHHBH8KxR/EzgvDH6cuslxGGLUDVacVFwsHK?=
 =?us-ascii?Q?vZYjlXZtVfDvvg2/H/7nbOMKgOJn9XblcjaYx76CtTHI4B1ceKE3D0QqvUE+?=
 =?us-ascii?Q?902tDS4QCnopGK9IQ/UpoKdHFF6CcNS4iyXsxecsLuH+7I3KZh6YbQ2lmoez?=
 =?us-ascii?Q?Vw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff64ff36-b50b-4c28-3b96-08dacbc82651
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 13:56:12.4976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +GxbuO3q/ikSAy108dT4weZExT5pOeCNrNmqeG/4yEmcb587hd9glHKPJPnogAVQJ51OOuBdnuNkzMZ/+GV4OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8134
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dsa.o and dsa2.o are linked into the same dsa_core.o, there is no reason
to export this symbol when its only caller is local.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  | 2 --
 net/dsa/dsa.c      | 1 -
 net/dsa/dsa_priv.h | 2 ++
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 82da44561f4c..d5bfcb63d4c2 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1285,8 +1285,6 @@ struct dsa_switch_driver {
 	const struct dsa_switch_ops *ops;
 };
 
-struct net_device *dsa_dev_to_net_device(struct device *dev);
-
 bool dsa_fdb_present_in_other_db(struct dsa_switch *ds, int port,
 				 const unsigned char *addr, u16 vid,
 				 struct dsa_db db);
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 4afd3edbd64d..07158c7560b5 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -182,7 +182,6 @@ struct net_device *dsa_dev_to_net_device(struct device *dev)
 
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(dsa_dev_to_net_device);
 
 /* Determine if we should defer delivery of skb until we have a rx timestamp.
  *
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 24e0ea218a35..b60987e8d931 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -247,6 +247,8 @@ const struct dsa_device_ops *dsa_tag_driver_get_by_id(int tag_protocol);
 const struct dsa_device_ops *dsa_tag_driver_get_by_name(const char *name);
 void dsa_tag_driver_put(const struct dsa_device_ops *ops);
 
+struct net_device *dsa_dev_to_net_device(struct device *dev);
+
 bool dsa_db_equal(const struct dsa_db *a, const struct dsa_db *b);
 
 bool dsa_schedule_work(struct work_struct *work);
-- 
2.34.1

