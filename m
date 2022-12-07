Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACBDB646543
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiLGXka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiLGXkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:40:15 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2074.outbound.protection.outlook.com [40.107.20.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7D48B1A4
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 15:40:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=folaY9jhqrnKwA6H5zZVvlnKLxaZzBX64REQnZNo+7McRbaICwoa0oklsGgbqU54aH7mDcvwH5JoFSk2p0D2SNif+qrhZcHENbU6mUadWgEHbBc12OcI8ZlTDnm8UYM4wmCBM8VY7os9kcbBYPSh88qV3DaSwxoTHA2QGjA1SGyYTz5GzGWjcvA7aN0idUZbwgnxaBM5EBSdJNPYfLRrPlz034rRJhM8nq2ZpW+dRx5xIVvQ8NEBK7uO6sdFO4raHRhjDp+fmJLQVC33c1isvmA0dxQetzMtS9ZYFioUyw3ckGCrVMUPlY2HrpvvPal5ulm/k3r9qMTTRwljgPfxcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hEqY1pqWlbag0aY+d0jWRid9j/l/7JaIiRq0wZaKEVQ=;
 b=PbwTcgDbCTSDkH2QZpamDOAeo8P/j+ZvaS/X5KY5Z7/kjIAWxKGOJxxbdvCc6Fs8cpvetuvl4kd1cVbJZuSgSmodMI6yREaA9PiBqU+HBBjKGi33bgdys67r55nZpbYJ29Bi829DfkiKLitIlBT3eet1hSEpJO/QJDZkK3J7ZZ38Da11ERvGCrwHdVp8CbpZdgjLhHkFh77do5k+Lw69F0QnDpFbOzCqpZs/M1RABAVDDHByYLu8ojXGb+6aLwta6Rf2eju9N9Bh6UBOeeE+CDAvHQwn94bVtyfXdXYf9nTJ8A7oEFJD25Z6BZZHkpmZ8jnndNLgue4wYkhLj2zlzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEqY1pqWlbag0aY+d0jWRid9j/l/7JaIiRq0wZaKEVQ=;
 b=jptfkSL6zwi9jR69nSrtWu/w7skgwGAu0EYHqtzF3k5ABnVbU7QAcYBcwlHJ7VFQ0UIbsj0eDoQ6+1kgceSmHvBdRdLNWnOgCNZhfcCAVVNnwzCbP4ycCcpgJocep6U19jK86MnNbWE6WQce32HKI83DA0k4KeAK9DfIaR1Tt3U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU0PR04MB9659.eurprd04.prod.outlook.com (2603:10a6:10:320::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 23:40:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 23:40:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>
Subject: [PATCH net-next 3/3] net: dsa: mv88e6xxx: replace VTU violation prints with trace points
Date:   Thu,  8 Dec 2022 01:39:54 +0200
Message-Id: <20221207233954.3619276-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221207233954.3619276-1-vladimir.oltean@nxp.com>
References: <20221207233954.3619276-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0131.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU0PR04MB9659:EE_
X-MS-Office365-Filtering-Correlation-Id: 09c5f4ab-8bdf-4424-35e7-08dad8ac5fe0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0PISRZzas+nh82PMFV6iGNIYLIqVI4phdjTwCbB5DRDAB0FsSmAegvh9JzrfuCWBT3YqUGLjyNGMTKWiQrO4WNhqtZkELu7VM7OpggQVR6JVxSK6acTT+bzt1kriLIj8XdLU74uN4zHy2HxXI9M/mEDGVEuteyySXbYxAwIcO+reK1WckfK6fLUb5W3m1T4o501Ja6yfn3I9fSPuSKeRrLWI2N86q7LwhDv0TuND43JOjudXvheT53EfVlCGf1bSrF3F4ftnmx/6SHRisUL+gyMvkSQNKSZAOFGLx8Jvd/0rF7JJfJ7YIdPhnlvYs9mbZR5Jgsf+1AdEAkwi+vAIK2kgHt149/q+1/iPR8aoIrvsnYSvaoiia4XVn6iysjsPXsrpiUE4bz2joG9Fg3L/cMXk/pkIGBfPWpilr8TZXeVX1SI1N5IL1xVARY01TTPQ7FlK5pvZkkXSdWr1Ktr3xTXjbqg3nAYgb9TtqurgG/sb4uhbeRo7ovnI1FT7jyPajsEQC2xDKPWEFWlIAXfghY6Uk+B5++zsSQP8+I8ayHqRWBqq4H8+VqoPfFS/L1qV0sf0mnIGmxPCf8bzVjR/DVkyX4s8XvqQKZvPoDHAFB0FTJ4qUgYSlGEXAaoJSHwfFLJq56VJuNVbfbjZ+aeg7C1e38u2tFFIErSScQ+BAcz84B0VVR7YaBVGeHY9KXe/iyrEzwQc91vl4PhPIyzD7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199015)(41300700001)(44832011)(8676002)(66946007)(4326008)(66556008)(66476007)(8936002)(316002)(2906002)(5660300002)(6486002)(478600001)(36756003)(54906003)(26005)(186003)(6916009)(6512007)(6666004)(6506007)(52116002)(1076003)(2616005)(83380400001)(86362001)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iDig8E5rf+Qj7nLD4jXUVlmKZXmnp7BnXsWJ9SghX9UvHK9fYqE6+oMtRLge?=
 =?us-ascii?Q?s5pSaFjkxbLMyp8wzYYn3fS+/BwGUXci2/4a5ISMagUno70aRUqw7KF0k2vB?=
 =?us-ascii?Q?Uv4dBhtc+z5B1d69CoMf24nf0hPEzIrw8OlW6hN3G35+BZRdNkbshVD/e8AX?=
 =?us-ascii?Q?LSUuJIzkMuzAxDIrkNT4XfLUhSxdRDom98jP8EQ6FAvxthpLu/kUA1sDb4sA?=
 =?us-ascii?Q?ID8mLegOuHwOxhbU5/n/EyQ0XLhnMpQTEIBNhqeMuqpooYUFYcEkAisQ1gua?=
 =?us-ascii?Q?N/YOy5UwGB2us6R2GdWJv+wcqfF077FBqtJEBoxHd0pcuhY3kdGXfQpkrNC8?=
 =?us-ascii?Q?+UBhMV14Cw87jShS+THcLx2NxjiaczWCsUByanUSX2kx3Qj/haLTUOntu0rO?=
 =?us-ascii?Q?dv+4yFcTIDz5EGsywjuNiSkfGSAp3iZVz5VrF4J39VYc4YGYVAL7IhSvA+iJ?=
 =?us-ascii?Q?hwS99v9+rlYBdqQ9lx0tp9dToEkiJBnYq6AXiIKqCuhydniX41JhHrk+M9EF?=
 =?us-ascii?Q?cQb8wPtFv6HkwVaAy4Ut/SoUg9s27mjwOcuyQNEANCt4MeG2lxrqQjLRXE7s?=
 =?us-ascii?Q?G51SK11ahxKpitz4f0dJS/WEwJIcbJ/Blh8w6d+K4bH9/BDRFsH8IXzOGcYa?=
 =?us-ascii?Q?bRPCEAEeGBGft1KVS2j1yGnPTJaYBX/hRntFmk60oghLyYWvpiaRccwXW7I9?=
 =?us-ascii?Q?Fx6uRDRPjUT+3GdDXoyPYwnWwM4RVGvQSeQaoE2oPErQmvAJ6PODhpGi8SaM?=
 =?us-ascii?Q?B3oJiSuq8wMv31SF6omF3+0oU2h/tj8VooVRbf571SkMVOyEPX0UlcWR9q5z?=
 =?us-ascii?Q?qBQcpTMFuYxab4QbLrDjCwwC/jOmHOch1RI4G82Paw+ZAk1hh5KDt/Q3qJeM?=
 =?us-ascii?Q?gk2fPYJoj/ek7Opq4I7aZfTljkyOudTCgMi1Q8zsbbdRTEmWbF1dg450a+sK?=
 =?us-ascii?Q?djwqTTGjg24DtfmdSFeMbMMQoQLazZp3C6/dKYBhXhS9xqi1ehUc+u6yS2FC?=
 =?us-ascii?Q?i7rIkedHEo8b4ofDos75tMWx+MrwmVhjlxEKxS6QVv6n7/MlgTzDFrwesk0C?=
 =?us-ascii?Q?3Dqz4HIhWEMo9tow4sBJS5Mz0/y9Kkgt7A/K+R1dTvfr9ByjqLNhpHAp6ssG?=
 =?us-ascii?Q?Ib7oFsQjL4PSD44o0uYZSZVZZH4jJz7s0XWWOcELQDKpNVWPSsN+xNJ2dmQH?=
 =?us-ascii?Q?EfRdNS3g27piQpWwr7/3e2jj783Kfzo1+0rPO1bsOeQnzGGXvAJEnfy2RFNj?=
 =?us-ascii?Q?xraQL7KFwKyEDtunqcCFJUK5R5tLhTuw1d/sFN5g1KxDCk+EwUB/foiTIJfU?=
 =?us-ascii?Q?d5LblWMh6tO93zrCxwbo+55aleKQif4QMd7X3NlXzzVmW8xU5jemK+/KAzXs?=
 =?us-ascii?Q?RhLeqdvckU6V4YdLZUCAcXfAIxelUbJFyMJ4+fcGk1IZNNScqCuDgT2hY1Jt?=
 =?us-ascii?Q?0nX0v4sVtsji/chbv6wGfWggYeVMTbTa+UR5NtQXSDguWTlstn7CMknjK4ry?=
 =?us-ascii?Q?ZauR9Dm6FZYAA4YwwzxkqVftIqJ36iElTmGqfDOcCfN3YKF7qq65egGxOVXE?=
 =?us-ascii?Q?y5Q1UQ0ecvz5HQN883mtU2XxS5suDnMD/zYYaQEBcXssxPQtjT3bU88Ln5k7?=
 =?us-ascii?Q?Pg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09c5f4ab-8bdf-4424-35e7-08dad8ac5fe0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 23:40:08.2569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pcwLVYsD9Hj6N1J1+tW9gvjLkiWM1BMDxpaj9G7BlyQL7RSjC4UZuUM/06TBmWWAtDPgdsu59LvmsT/zpqajYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9659
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible to trigger these VTU violation messages very easily,
it's only necessary to send packets with an unknown VLAN ID to a port
that belongs to a VLAN-aware bridge.

Do a similar thing as for ATU violation messages, and hide them in the
kernel's trace buffer.

New usage model:

$ trace-cmd list | grep mv88e6xxx
mv88e6xxx
mv88e6xxx:mv88e6xxx_vtu_miss_violation
mv88e6xxx:mv88e6xxx_vtu_member_violation
mv88e6xxx:mv88e6xxx_atu_full_violation
mv88e6xxx:mv88e6xxx_atu_miss_violation
mv88e6xxx:mv88e6xxx_atu_member_violation
mv88e6xxx:mv88e6xxx_atu_age_out_violation
$ trace-cmd record -e mv88e6xxx sleep 10
$ trace-cmd report

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/global1_vtu.c |  7 +++---
 drivers/net/dsa/mv88e6xxx/trace.h       | 30 +++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1_vtu.c b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
index 38e18f5811bf..bcfb4a812055 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_vtu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
@@ -13,6 +13,7 @@
 
 #include "chip.h"
 #include "global1.h"
+#include "trace.h"
 
 /* Offset 0x02: VTU FID Register */
 
@@ -628,14 +629,12 @@ static irqreturn_t mv88e6xxx_g1_vtu_prob_irq_thread_fn(int irq, void *dev_id)
 	spid = val & MV88E6XXX_G1_VTU_OP_SPID_MASK;
 
 	if (val & MV88E6XXX_G1_VTU_OP_MEMBER_VIOLATION) {
-		dev_err_ratelimited(chip->dev, "VTU member violation for vid %d, source port %d\n",
-				    vid, spid);
+		trace_mv88e6xxx_vtu_member_violation(chip->dev, spid, vid);
 		chip->ports[spid].vtu_member_violation++;
 	}
 
 	if (val & MV88E6XXX_G1_VTU_OP_MISS_VIOLATION) {
-		dev_dbg_ratelimited(chip->dev, "VTU miss violation for vid %d, source port %d\n",
-				    vid, spid);
+		trace_mv88e6xxx_vtu_miss_violation(chip->dev, spid, vid);
 		chip->ports[spid].vtu_miss_violation++;
 	}
 
diff --git a/drivers/net/dsa/mv88e6xxx/trace.h b/drivers/net/dsa/mv88e6xxx/trace.h
index dc24dbd77f77..d8d31e862545 100644
--- a/drivers/net/dsa/mv88e6xxx/trace.h
+++ b/drivers/net/dsa/mv88e6xxx/trace.h
@@ -57,6 +57,36 @@ DEFINE_EVENT(mv88e6xxx_atu_violation, mv88e6xxx_atu_full_violation,
 		      const unsigned char *addr, u16 fid),
 	     TP_ARGS(dev, port, addr, fid));
 
+DECLARE_EVENT_CLASS(mv88e6xxx_vtu_violation,
+
+	TP_PROTO(const struct device *dev, int port, u16 vid),
+
+	TP_ARGS(dev, port, vid),
+
+	TP_STRUCT__entry(
+		__string(name, dev_name(dev))
+		__field(int, port)
+		__field(u16, vid)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, dev_name(dev));
+		__entry->port = port;
+		__entry->vid = vid;
+	),
+
+	TP_printk("dev %s port %d vid %u",
+		  __get_str(name), __entry->port, __entry->vid)
+);
+
+DEFINE_EVENT(mv88e6xxx_vtu_violation, mv88e6xxx_vtu_member_violation,
+	     TP_PROTO(const struct device *dev, int port, u16 vid),
+	     TP_ARGS(dev, port, vid));
+
+DEFINE_EVENT(mv88e6xxx_vtu_violation, mv88e6xxx_vtu_miss_violation,
+	     TP_PROTO(const struct device *dev, int port, u16 vid),
+	     TP_ARGS(dev, port, vid));
+
 #endif /* _MV88E6XXX_TRACE_H */
 
 /* We don't want to use include/trace/events */
-- 
2.34.1

