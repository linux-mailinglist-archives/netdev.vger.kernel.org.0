Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5A0522FE4
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236823AbiEKJv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238639AbiEKJvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:51:15 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60077.outbound.protection.outlook.com [40.107.6.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75932BB25
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:50:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPWpOJsZTlHM2QbU8HdRRPp1pBqX1GPtljsnFNLTxtOLMu5RS6PA5zSy7YZn30fVb0w95QTza4KNQQnIK2bf3veMBWA8cSJ+SW+ea3kk3lGgUsvnot2CQ6BVwPZwddTmF2Mx9gxymqA+JjUp9n+w9jT61DAFlww/yk0ufzYbyJEoY8mVT2FSX1tzfoiOHOoBHyUqmg1iKr7QsLOZgXvJQ/6AY+euvR4lkIakDvzIGL04D17YMjE8HWBH4DPhzN8+0HHBuP0OUq47IegcVwkIQqIbBJ4XwOFO5eIFGU/TaaXGyyeqgjgHAA9h5I6hSPAh4eKkJ+YnI+9Vjnis4I9MjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WSA+01gHjI2JlXCbdW9y3d3P6BILuWtv/4+QuctE0Ao=;
 b=k77EW/nllSffpxSGHennWsBAVVTmRXYV4usadWzn7kSaMnI3OUMMX1SagTIIfH0Q5tax6T2yEByTHYukjGpJlt4fJroOY8QnzGRd16d7axjq166Ak42MHXVcO+jaIbwnXtpGUs/+/3o/mHBeqkhNJvX8fuyhTxMYWS2BnXoqJTFv+EwCF5ywnKy0odsn2o1hj2+vB6+gTCouS1TGjzwdkNtH2Kr/iI+aKJcBANCLd4F/Ygl1LHnkJx3wQfpOhO1dssUCCigHaU4yPedqwEUqM4X2MfQ8sROOffSD31QT+MNtMRJasFAZYAn9D4ch7oheNmkwkAVsyxLnbpCTf5y6QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WSA+01gHjI2JlXCbdW9y3d3P6BILuWtv/4+QuctE0Ao=;
 b=SzqhsJmxSkjS2qlon94XKKHtrk8tB134ZqJZ99BN7d1T48v0x1bFJd7az6QrMaMgCjg/5m2IA1mBVMDvTgRqtaSE8KNGqD3ZxExvOYKeYDdrjpPxogUG9S3J4fcl3nvOO9+WTqpODMiJtUOtXBqLSbuh6CQuP1uBsfHyRtFHOmQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4964.eurprd04.prod.outlook.com (2603:10a6:208:c8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 09:50:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 09:50:47 +0000
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
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH v2 net-next 7/8] net: dsa: felix: dynamically determine tag_8021q CPU port for traps
Date:   Wed, 11 May 2022 12:50:19 +0300
Message-Id: <20220511095020.562461-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511095020.562461-1-vladimir.oltean@nxp.com>
References: <20220511095020.562461-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0158.eurprd06.prod.outlook.com
 (2603:10a6:20b:45c::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfb8da2f-c83f-4e47-3115-08da3333b910
X-MS-TrafficTypeDiagnostic: AM0PR04MB4964:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB49643E45D2904FD03AC0C14CE0C89@AM0PR04MB4964.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bR9XsMHDaxsIT/2f4vkw0C6FXLN5tVzMpxTlaZsG1CyYWf0FGXsDItGJJm2xEU/PVHoXBLYMnvUEbRCkx/CF5oT9kwxKMN+vZTWCp8+H/Jp7KQeJzuLAwkA2PvewpYhaz0zOhH7JTLz6opmA/IyQrfv5X7INUEnSevsTCHqE5rQTqgihqCUPXp7PKFH+NHwJP/VWKhg13ojv1iTdXfzBADAbKkOf0feOJqGGYliF7bGUlnr72YYMoR6bxlBqRn013r9gPIkHP7+H7aojaYNmVuYjU7BPKy4YR1PVQKD1Gdpe/YoVftmo3MkWDM/pQZwM7XQQHD1KZsoX3F7tnHKDa0lnZN9FES/ouaO+cI9AsKMVAlKzglypttHMR+l5g+hCxeHDYpIhSdbFujiubGYXq7svORpAkRUz2dmCN21kJOaMOMYzwcJqkP5WbtIx3cQBgYGVLENJOcHbgZuEbNzEf3KLGWv1Oj3irpvP2uLI+pleMVhcC81z7rvCmBvQJLW6E55MG/9DVR+nT32LD+70ymGrIykLtWvQuGclvb7o9xXe3MNhwIzFYaYscXzZ5p+QrYEBrK/O25ukRzH/uT6gUePlWwAmslRikB58igHlzcivSKjyrAizLCIA3PPwIcg4TwIbgcObdSSYzwd+iETEF/quvwNteOqXcmOsbaWni1jNI6/E1P0qgz7iXV5C/MnvfhGKlSrSUX6Qxyd6PttrWtUwv1nTh091jVbm0x0+N24=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(54906003)(38350700002)(66946007)(6916009)(508600001)(66476007)(8676002)(66556008)(186003)(1076003)(316002)(83380400001)(36756003)(2906002)(44832011)(86362001)(6512007)(5660300002)(2616005)(7416002)(8936002)(6486002)(6666004)(4326008)(6506007)(26005)(52116002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ge0HIKaozflkS8BSKMHQIkbI6IeTG958q6NHExRurdJHtcVaic9yTUX4Fi42?=
 =?us-ascii?Q?cMGo99S+EMc++1A802QafTpp3xlR0SpISBUNN9/+RnqGTDKidLVqodHS2kB3?=
 =?us-ascii?Q?rR+NBKAijmMZRToENDeJRg96GVGF08ZxO3IrR+4RFshdbYpMFvpiD9EFlY2A?=
 =?us-ascii?Q?eQ6WKlpVCA1fInj/L8yXrLN+fiHaB3qnPDwSgbFeeSmuQw4yEFKo6EhodtvB?=
 =?us-ascii?Q?cxUxWKsy0hxPaH6kSXcz0ugMqsRgyCZ78jT5IH5ZLfqZlC5JJ4w4n8+ILMar?=
 =?us-ascii?Q?HwVjwq9upRrFmhI4dqOtEieHHsdLdalM9dnOQHp7EfM/VesuvDC0sHBaPJZt?=
 =?us-ascii?Q?0GjVLyn3faQ/oNV0HXO1cPPOjvhzJlnmZLgSApA7S4IQoV0tZ+/e1NGXBtSj?=
 =?us-ascii?Q?KpB//iiGYvaERPUZ71q4dikqF4yNTYtuFTeuqXiWME7DVwgj+XSSoHOzpL4M?=
 =?us-ascii?Q?aH5uwSkGgrc26zTU3B3ULRF1RYToRKNBoCrAI1B39lKWvWdyQB69yYgIBTPE?=
 =?us-ascii?Q?bP0fZEd8HDwYRZtMVebLQ8ndBkW60WQmUL+fVhNV2xv6qJELz+uu9Mo8oLrl?=
 =?us-ascii?Q?RJY/39EaGBKssV3orwRKccyO+3nlHn59iDw0BSajQ0rPqewJm4E3lIRMyaZc?=
 =?us-ascii?Q?X92epykn+/WLfMFkQ/KqobLzwY34fGQnhrxYcB9RkYTOQTDqgl4C3FQq0utl?=
 =?us-ascii?Q?FRaUopeIcr8UFOlGs7OJ2OJ+D1DfIZORGgoIB4kbhASCOlvAI99LyFzEnYbW?=
 =?us-ascii?Q?TJojKYfBT93BXYFBzz99K9M8x9gkODoKIo83B1zWcM/5Cux31gnliFnwCM5i?=
 =?us-ascii?Q?s6BGw0sUGZPeJ+9pYYEFxCorgkfwerVg8zQ5VdwU8D34JAjXxjYbRQWs+BZJ?=
 =?us-ascii?Q?Og4SWqeOjL+NC8NGWHblxZPJk259FvI4JkUSaSFPti8pD+ThKMKBOrnX8Y9s?=
 =?us-ascii?Q?Wms7jGAZCVYljhhSDL83T6GSbwHKLJPGbb8JsZLOMK2uF1EB9/hFk31pyUeM?=
 =?us-ascii?Q?vR7kX28Y3vK3AVvWVpY4gFuGh6/k7hTNCnEJWpK1PiLvA6dRPxEkZONl8d4t?=
 =?us-ascii?Q?3jK2g7E/3fh//cN2x3wy7CyrWzlp6ZsO6GSBMpgqJ0+ARDAvOlO7Ea1F7sLX?=
 =?us-ascii?Q?WPdGIgu4wlR8FBlK27V5xLgPwDNZ6ebPEL/xZkaR9iXOkdk8onidTqNWvwpb?=
 =?us-ascii?Q?PRTYZiitm1AaXD5mvkS/OFTeVST0mN+63THvhP/zGLX3BPZhOPQtrNrcxnHh?=
 =?us-ascii?Q?IY8jlUa8BibzHPL2CMkFACthjPcsleLmln2n1riUlPyTKzTuePHmT/nbas0q?=
 =?us-ascii?Q?y3j/dJ1uVnGs+mz2RJniWZAOPXAyJzfab0jVyw+daLfj1dlENxk3Xk9iYO1U?=
 =?us-ascii?Q?yGLobHRLK9JTnVkBTkRqDLaiG+eVzLTUTtWGvVXX1sRm8r5YLkGIv8FZS7O0?=
 =?us-ascii?Q?d7QrXDdm7PvM8QOnKmkGtN1TVAqF+2opIhjVP2PN6vzzF36cgDyQQ3IaNRr/?=
 =?us-ascii?Q?CHonWQsJdyu/xPcqX69zlQAZqq8UyNZWlGc42p45Zza5Ej4XyoIx2omUF4R+?=
 =?us-ascii?Q?22zuL7vYch6KZHMJl0eexzWfdVjGu7znw9tTqobhbFkVqcbGddpy7+OyH9UJ?=
 =?us-ascii?Q?XlXnidhV3eALyr/h2aTcaD131TpZEwC+h+c4nnDFLsU5dzQUl0ADIAF/gm2R?=
 =?us-ascii?Q?lyum1FO3qs2wD9PYo4cDNfUpATlsw3zrWXTeaqYuY7BSEIwjLgp470hi8NTj?=
 =?us-ascii?Q?WFE9cSK2ryz5bt74knqq6PTadDUr+xM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfb8da2f-c83f-4e47-3115-08da3333b910
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 09:50:46.8947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bekx7TlCu5RPRcBvanSDt5V4olni1lw+qeJy5iJ3ab3l2M7IchZhq+mVCGJlDlQe3oz/Oqe88AKdwEj5LqktyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4964
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot switches support a single active CPU port at a time (at least as
a trapping destination, i.e. for control traffic). This is true
regardless of whether we are using the native copy-to-CPU-port-module
functionality, or a redirect action towards the software-defined
tag_8021q CPU port.

Currently we assume that the trapping destination in tag_8021q mode is
the first CPU port, yet in the future we may want to migrate the user
ports to the second CPU port.

For that to work, we need to make sure that the tag_8021q trapping
destination is a CPU port that is active, i.e. is used by at least some
user port on which the trap was added. Otherwise, we may end up
redirecting the traffic to a CPU port which isn't even up.

Note that due to the current design where we simply choose the CPU port
of the first port from the trap's ingress port mask, it may be that a
CPU port absorbes control traffic from user ports which aren't affine to
it as per user space's request. This isn't ideal, but is the lesser of
two evils. Following the user-configured affinity for traps would mean
that we can no longer reuse a single TCAM entry for multiple traps,
which is what we actually do for e.g. PTP. Either we duplicate and
deduplicate TCAM entries on the fly when user-to-CPU-port mappings
change (which is unnecessarily complicated), or we redirect trapped
traffic to all tag_8021q CPU ports if multiple such ports are in use.
The latter would have actually been nice, if it actually worked, but it
doesn't, since a OCELOT_MASK_MODE_REDIRECT action towards multiple ports
would not take PGID_SRC into consideration, and it would just duplicate
the packet towards each (CPU) port, leading to duplicates in software.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/ocelot/felix.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 0edec7c2b847..e76a5d434626 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -313,6 +313,21 @@ static void felix_8021q_cpu_port_deinit(struct ocelot *ocelot, int port)
 	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 
+static int felix_trap_get_cpu_port(struct dsa_switch *ds,
+				   const struct ocelot_vcap_filter *trap)
+{
+	struct dsa_port *dp;
+	int first_port;
+
+	if (WARN_ON(!trap->ingress_port_mask))
+		return -1;
+
+	first_port = __ffs(trap->ingress_port_mask);
+	dp = dsa_to_port(ds, first_port);
+
+	return dp->cpu_dp->index;
+}
+
 /* On switches with no extraction IRQ wired, trapped packets need to be
  * replicated over Ethernet as well, otherwise we'd get no notification of
  * their arrival when using the ocelot-8021q tagging protocol.
@@ -326,19 +341,12 @@ static int felix_update_trapping_destinations(struct dsa_switch *ds,
 	struct ocelot_vcap_filter *trap;
 	enum ocelot_mask_mode mask_mode;
 	unsigned long port_mask;
-	struct dsa_port *dp;
 	bool cpu_copy_ena;
-	int cpu = -1, err;
+	int err;
 
 	if (!felix->info->quirk_no_xtr_irq)
 		return 0;
 
-	/* Figure out the current CPU port */
-	dsa_switch_for_each_cpu_port(dp, ds) {
-		cpu = dp->index;
-		break;
-	}
-
 	/* We are sure that "cpu" was found, otherwise
 	 * dsa_tree_setup_default_cpu() would have failed earlier.
 	 */
@@ -356,7 +364,7 @@ static int felix_update_trapping_destinations(struct dsa_switch *ds,
 			 * port module.
 			 */
 			mask_mode = OCELOT_MASK_MODE_REDIRECT;
-			port_mask = BIT(cpu);
+			port_mask = BIT(felix_trap_get_cpu_port(ds, trap));
 			cpu_copy_ena = !!trap->take_ts;
 		} else {
 			/* Trap packets only to the CPU port module, which is
-- 
2.25.1

