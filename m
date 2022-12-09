Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6794D6487BA
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 18:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiLIR2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 12:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiLIR2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 12:28:37 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2076.outbound.protection.outlook.com [40.107.20.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9425F5C0C0
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 09:28:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QpiNzHdp1bPQuztAcPIV5VHyPlHcNs2kK+q8e5PXQxuI1zJYSw80c8+c0O9nLgbnDwd21u7nOABiC/q2KBtd+Sq5gQ9lCDEbfoqv8PC7Vdk6nzCk5Qd3u4lGk7N93H8AyCrV1mV/NMHlzarseaVRMMLn/25ssCUM0olk31CDL9ct5EhH2GN+4K0LpbOLJYO8fk6bxbUV5yHSFEVrrixk34NbP5O/Gwj+81QXUz7aJ875++N4RUGuIUB7LZluWqVgWGzRdRJS/8axDNMd8XpePNdrNFs2JRuQUAvr1b1s9ldtd1b1sXU2xAxz8poAC62xyP+BSwqI3i6FbeymMLUVTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5GsrLNG8T/9RnNWZFcWKvjFUL4UrGJiFenMMYP8uq4c=;
 b=b1OgBJyqyrISKfU1DdqtmrEc+XGof4flXCHcKSn1GIldixF8Je0OevhcwthyFvmK7TsGdMARh/xJsLzAEzklxQfT7FixUX2efCvYIvIf7oT5gJbPSLjfxdqUuYcxF/65SAAiLjsrLQBpNm9JQkvYLhQuggrOUy39sB4hToKr0LE5MEKjG783SXlsH8fabXhBiLgmye1yl09XF8rSDDfC/Go2+yIjnBEP5iFKVa+EhHfmX3uyWV+tysuL3qpDQ3/L7u0fSvVqpX9SFz20aFmpFyKnt6+ew/LV+pUeQrAJrOpzHOyPKK5kPPJW98oC+nsaN2mC7auqtm2RlmmWrAQqgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GsrLNG8T/9RnNWZFcWKvjFUL4UrGJiFenMMYP8uq4c=;
 b=TynA0KFDk9j3Pra/fvR5MhtHeNiuy7Ti0q/FZ2xrZTnnbC8die2AbollnXe4sxHJ8pJh277gF+AL6FKIdctndwC0mYVJ5ymoLF5AxMFurZf+hLIg18E+VI5pHkedZjog6x93v8l2j1gK1CLQnucPjp06m3OD1+FCTR2jB5eqYCU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBAPR04MB7253.eurprd04.prod.outlook.com (2603:10a6:10:1a2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 9 Dec
 2022 17:28:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 17:28:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCH v2 net-next 4/4] net: dsa: mv88e6xxx: replace VTU violation prints with trace points
Date:   Fri,  9 Dec 2022 19:28:17 +0200
Message-Id: <20221209172817.371434-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221209172817.371434-1-vladimir.oltean@nxp.com>
References: <20221209172817.371434-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::10) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DBAPR04MB7253:EE_
X-MS-Office365-Filtering-Correlation-Id: ffeeb3ea-7961-4e2e-b8ed-08dada0acb80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lXBa6nRcbgMvY4TNl9AzLb8TsmtPCTzRdF0ppH9JLZDOP+/6c1H7r5Y4bI7l3M4Ly4uYAq2d0apMKS1i/i1EjivP2svwQjJWO8leUudyUZL/JcKiLvfmdpIyoLWuZZhMTrFVB8qg3EXue4p1E4ixM6xrlnl9Dgl4Ej8BgbcGicVobZBWoxAkd65BZz9sHo4b4sI2LC2hNUGtYEijTeJ7ZnIOrCUV6Riqmz16d/495T6lAtTiEso7w/LmRnvgaQGCLRONQIjEaUC5Wdon7VEMuamI06/W3tSv3N4itsSfHyYIdNK+/UxsH/eDqBTf7p9XcLrTyvAUDq9U1TQtX5SDKonHFKfH0Isv+Ey2IMgAPssqzplkJZnKvKtFE0NLUoTuXIMgqAg+fdpwpvfuqUwW5AhM4OULCz7cvLDyoeY+xUIUk4shMuBfLiEeJcd393aPhEI8g2vQcZFmSEM1IxSIvyAnp62XSAu4IboT1S+a0tmajwYX85qUzM3B3xFAHA3jV9Zr886TJOvA03M9Usi5f13TlTEwPk2iRfUjKfI+1019B7gm6V8nzAQGsHz6ksWA/ATTkr54bzpO3s9ke3vpP7l/yNoWbuSRhaHHDCnwLJXejSyTWbgRMwYCFWWLYWFeBykCNPu6ea2IkvR7JYb9aiJuimvFx3Yais5a41ncRdig7yMwLugpEfjBegGdmg4M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199015)(86362001)(8676002)(6512007)(26005)(6506007)(6486002)(6666004)(8936002)(52116002)(36756003)(66556008)(66476007)(66946007)(83380400001)(38100700002)(4326008)(54906003)(6916009)(316002)(5660300002)(41300700001)(38350700002)(44832011)(2616005)(478600001)(186003)(2906002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K231cXXyKWJC+XoLAT8etOHZ+vmaXWXXFgRltOdRcNxFRwEiUgC9utjx2u10?=
 =?us-ascii?Q?WVQ/3BkAw2LMmQ0/v6D3O/mYKnn8UU/eYtow3mv8fDmixzBC+LgiTIyU3bNf?=
 =?us-ascii?Q?RVM9KR6E/1gNnZi4bfWGsyKvMKgjH2+Q0e7jLaR+Y8JcxThKswUtq2m5W+ei?=
 =?us-ascii?Q?Mpbc2EvK3AAWtVbrZ6jDgr5Q1bkx91Sw+s5WWrrflcKW5k0dkmeNMw4KHx28?=
 =?us-ascii?Q?JGGy/ID+Cje7VMvjBpTZJu0+hsBIFNvRjWoe3Q0WX8pc51RzoKtggf8ZSIkb?=
 =?us-ascii?Q?QS7M3cDNmAk9W96XDIUsjJoy3LMfmwqvUtpihIjeXI7S0h422NsRtBQzPsIo?=
 =?us-ascii?Q?IsgDKxfWngVf1ExjFQi4RlCdP+OnpJ+YygeMFj8pzRffwBWIMAPHW2Reu1Fp?=
 =?us-ascii?Q?e2QYm/fzwRbkenK8SxOdOJV9Qdm8XHW4/H4QjaIg0K3jtuz6Ms6g3bJ9qd+Q?=
 =?us-ascii?Q?ECVTx+s/Al3q8p74z8e8BUlDczpZcDq+Ym/dUJz5BmwQx37NH3OllbE6kYy3?=
 =?us-ascii?Q?ESsuGH+Z77EP2sQ8U1bXyHslrynWsIHYR74jzgUtIuQGC0gVUI23cKsJ7Zip?=
 =?us-ascii?Q?lmLqYp4939DcrXIRzlPmC+Py4XDY/Vbf7rcpjJG32Q/cUQkM4uF1eKo5LcTD?=
 =?us-ascii?Q?5MAQwJCUpzwCnsxtJgDYADD1Dcrd+lvzT44M7Ok5aIm/VldhY6vmOUdQkQ6S?=
 =?us-ascii?Q?rPGlMNEhUy9yVf9Nv5zsC7lQgA5wo4aynSlel7tADrPE3Otica0PpdXKr5Dn?=
 =?us-ascii?Q?NHiKfzxwQ7YXi0bqWIq0JFeH6+QL19rGFDNZNSbAdak7xwMp7go8aSN4F0xv?=
 =?us-ascii?Q?CJa3CC+IMZo4I4rNpJEPuov6t8HPf2fjgp5KO16VbrXQ6nsGF2cprw3eDLYl?=
 =?us-ascii?Q?gpUFF06TBMTBfxlxIeiEgrs6UtO/i3WiPj8x99mTpPd0VJ50UxG8e6js9whW?=
 =?us-ascii?Q?RcCh3BEIsdMnOm7my+t0xQxmlBP4ZIIvzsJB/JVkIexSKUe8IrQfmcyL5biE?=
 =?us-ascii?Q?Cjy1oeT/capdB1qVVlRtsqP3wwPDZg3iEBi5bx2TF6zXgOi16ygyEJ3YL0CZ?=
 =?us-ascii?Q?q+51OBmLJTXSojEVYBZ80DxWD/xD2C1PRRn3oVfz5huR4M9Ac1IQecADmfHu?=
 =?us-ascii?Q?7rNZQh8g6s+m8w3nkjtAQSLzxLl16opOW7vtPBiubZF6syekEa/lUyqIxgm/?=
 =?us-ascii?Q?7jDkL8ky5m2kiKaABG9nnwf/iKZ+ZWhIOKEY3T+Y9KkusnX0CGv9EGWg3zsd?=
 =?us-ascii?Q?/Vl5GHXzN2viGmIQzIkn5QsxM0/bDDvbZ4MfwSV8Aiqc+x7ji474l/zbL1dD?=
 =?us-ascii?Q?hqt75x8U30C2huSiVbRcEhYH48aH4kyPwawXhzSGcevoIAg9hqQht1hhSRkT?=
 =?us-ascii?Q?4ujShUqn8I3TR+x/tpDdYfzruBtFo0nHtM63BPW+Dtfb4hReDyclaeMke+ua?=
 =?us-ascii?Q?2jBAEDk2L+aYikqcW0WtvATwFhep+DlNplhCXn4QhyS0nPB8Uo4v26QlXav0?=
 =?us-ascii?Q?UIex0xX2zIdgMNaIQ7BF8eTV/iPe7HRpdO1TSdpAwhvgEWkPZAD7nkIDsm0D?=
 =?us-ascii?Q?mY45krVtk7gWbpYToR7D6llpjEQgXeZDzzDD1Dt353KXeUg6UtrqmhTIiMaB?=
 =?us-ascii?Q?Bg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffeeb3ea-7961-4e2e-b8ed-08dada0acb80
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 17:28:33.3834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ke7gq0lplqH29MmKzGiwG8gyq1KVU/turw9wgyYj/aKGHCamLuzXR0icp3Fs/dfpc5TQmY+JocGO3K/CNda5Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7253
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
$ trace-cmd report

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: rename port to spid

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
index d9ab5c8dee55..f59ca04768e7 100644
--- a/drivers/net/dsa/mv88e6xxx/trace.h
+++ b/drivers/net/dsa/mv88e6xxx/trace.h
@@ -55,6 +55,36 @@ DEFINE_EVENT(mv88e6xxx_atu_violation, mv88e6xxx_atu_full_violation,
 		      const unsigned char *addr, u16 fid),
 	     TP_ARGS(dev, spid, portvec, addr, fid));
 
+DECLARE_EVENT_CLASS(mv88e6xxx_vtu_violation,
+
+	TP_PROTO(const struct device *dev, int spid, u16 vid),
+
+	TP_ARGS(dev, spid, vid),
+
+	TP_STRUCT__entry(
+		__string(name, dev_name(dev))
+		__field(int, spid)
+		__field(u16, vid)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, dev_name(dev));
+		__entry->spid = spid;
+		__entry->vid = vid;
+	),
+
+	TP_printk("dev %s spid %d vid %u",
+		  __get_str(name), __entry->spid, __entry->vid)
+);
+
+DEFINE_EVENT(mv88e6xxx_vtu_violation, mv88e6xxx_vtu_member_violation,
+	     TP_PROTO(const struct device *dev, int spid, u16 vid),
+	     TP_ARGS(dev, spid, vid));
+
+DEFINE_EVENT(mv88e6xxx_vtu_violation, mv88e6xxx_vtu_miss_violation,
+	     TP_PROTO(const struct device *dev, int spid, u16 vid),
+	     TP_ARGS(dev, spid, vid));
+
 #endif /* _MV88E6XXX_TRACE_H */
 
 /* We don't want to use include/trace/events */
-- 
2.34.1

