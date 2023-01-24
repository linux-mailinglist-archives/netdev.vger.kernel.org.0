Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0B0679B9A
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbjAXOV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbjAXOVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:21:24 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2056.outbound.protection.outlook.com [40.107.21.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1AC9ECF
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:21:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZMUKec4em+Z1rLvfVHQ4reIv+9YnWvewidc2nwY7idHr3+EU6mnsQGCEmPI3Oque4XBFtbpn4EPIc9HXrfV96j/cLwTUA5Bs7vXX/B9kcyCYom3EAdkt4cIOOrjUfbO2yTdfOAzUfKCOaKIRjP0JunrhXLf6PHio2SkeSKMlaTrukMLsfiRfpp9YM2oxy2d8rvcNxNwekBgVSrQJMEbQgVrsZCe7kS+oGpXZSw2npOdY4YLlgjhiSlkYPfW2ZmzlxuPk30vZzcSyIysC4LmvvrWn5hQH3LCMdfHx6w7B1axDKQlRr3SVRgzHhHqPVBn2FtNQ0uy3DFKI9wWqTN/jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hVeVngHmfxz9gNxTxMZsH3fCtOWjyS/ZVXUgQh6XG1I=;
 b=mL2eD+OfoKXw/fFjdqL8V1hS1LTvGfoa4/uoO3RtgNA81KSLEpxlbDN59LgFmsHzxHVUrbag0SjQoFuSPagNJimNz9+Yvz9O8DmEn+ikuQ1m5GdN6chAuFHXtBJP8k/+zNmwipx0iuOVwIwBAWpcPwx705K7AEUvK+HXiB1jrTl1X9PPHMb+qP60/Q0bxyhwPCFgdTh34dq1HXMCiBmJB112HnINinXCo7qiZck/yvkyZOapqip9ya3iUAMQqLi0KhCFUOaDTroGFjGzHnKI57ORlVMjws/3cJ+dxzIhGNiEDxlo74WlQ9ahfUGYaJ+gbbZe1MnS6A80k193c0Cckg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVeVngHmfxz9gNxTxMZsH3fCtOWjyS/ZVXUgQh6XG1I=;
 b=bWhlIkpKd+16jsnf64vnqvjRohZvsMw7ne9eQie+JNAxFqgFUPng3ULGzfy6EgsUbPNvaxV+/xqYBILVpVbJtL/q/S2FFQsG7xmdq0QG4apWfDmfyuxQd3CkthBuPM6RprTuoI3eLtQrPF2mIeN8YuG4FcQ69QNWjwLLoahBxiU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB9638.eurprd04.prod.outlook.com (2603:10a6:102:273::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:21:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 14:21:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH v2 ethtool 5/5] ethtool.8: update documentation with MAC Merge related bits
Date:   Tue, 24 Jan 2023 16:20:56 +0200
Message-Id: <20230124142056.3778131-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124142056.3778131-1-vladimir.oltean@nxp.com>
References: <20230124142056.3778131-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0158.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB9638:EE_
X-MS-Office365-Filtering-Correlation-Id: a06f85f2-ed13-4882-f466-08dafe163fc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aB7+/xhKVwoxp98WRCRVH7sivFzXW5rICzSFBDySbi8Kd1bLNRmQSw5mtBD181Zh/ENyFxjVnehtdetR2JWrzZkhCN9L9n546Qv8XQdyU0mthgjUmsfQOve6BbroDjrLxuEcRvCamaXRSLdnB/Y9QyX0n8XhCeFJoL6MRR+jCUpLrV6su/n5dZ8P+0+0Oe+Rxm9hgjW0hju2qInvYBkoPL2+m+8P0QBNY+DON4KIgXyeR2PpBBOxGV7/a89Egy/9eqdgjmbx0ntp+HMdmElgHxTLyaqYv/k5ovJNTfZVJJyMrVcZwdfljKGXA+0gnW2Af+SM9K9po31M/+fGHPSH/0e101fwa81CXF0OT5cBQthQ/Uc2jb04UrAR6Fakc6Wbncd+CmShBfwQ152+wCBtYT8yLUDzYC+KU38rInT7yakpY+T4/185nDrTBc0Jx73Zv66/d8ZvfRbKp0Mq7stB3b1g76T0pBICFyjdNdUmZbh3Ks3s/LiTV/nbWQvJAosHHffVHHYLWAohrE6f50XPwRT2HsFRuTOWoF0S6owFxLmJF/wt1xvacOYBl68nHqzAqmklVIFszzWhbITN00cnpsXYHt+eGc9DZe62kJIVUJpXTnj9E7fyVfvUVncZto2H1voj2Qb6lzEk1ZFh9DJEbp6mK0YXa8KqHMj4OdxgGmcfRxyh2BCnHNrJ2klwcPljLadhE9DRgSPUtCvtdlI6Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199015)(36756003)(41300700001)(86362001)(8936002)(5660300002)(4326008)(44832011)(2906002)(15650500001)(38350700002)(38100700002)(83380400001)(6486002)(52116002)(478600001)(66946007)(6512007)(6916009)(26005)(6506007)(186003)(8676002)(316002)(54906003)(2616005)(1076003)(66476007)(6666004)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G8Rk1LOAdmnCZoTfW5Q1PEsiCyedzFN/nw2/J1nCaFNIdQBpZKPpsdoeO7KW?=
 =?us-ascii?Q?7mimS2BA31AmAEqq6tbQIvjAbEbuIro4adXYcmmZe5g+97z01xy7V80xRny6?=
 =?us-ascii?Q?bEllxwsMoDPI18PNMGbbEwbbed6siOhdHAgP2RN2lHZEUf5IrM6zl5028HQc?=
 =?us-ascii?Q?JC4EArhvReZXh2LHOEe9wdzYOGQ9i6eRxTfkh5a1tst8aJnvoHc5sayx9ic5?=
 =?us-ascii?Q?GJyUeMtdbsFicLDgSSvwMYV8oxrPTufyuFoX9rOOSmRs+8i0D8Any/vM/ZzI?=
 =?us-ascii?Q?duW2TnRsgPN3Cq9xaWV/OQ8gPCLotnEyWklOv9wtArWz8wZpgX4NPIh51E2N?=
 =?us-ascii?Q?dm5qlSUwahVZOCEBHmoi+EkZ8TYxWm9SebCWIFpmPzxEs9AFipzfC6usIJJy?=
 =?us-ascii?Q?39bUA/8h7cGOtpe9QYhg3BpLi+2IzPRz9p+d0EwBQ16rQdHkQENe7vmlArqP?=
 =?us-ascii?Q?Rxk8G/hbCV4fqpTSZrN6rlevy6h22vh8AaRFgq0OTeohrQZI+8sqUdXG9FmP?=
 =?us-ascii?Q?AmS71Qr75wfZJTG3ZSS9klfH7xT5N3wC5GUfQ8jg2gHhctj/ZtjwByTR8lgF?=
 =?us-ascii?Q?+G3mBPXgSDlLNk1Rc4gApB+ODw4sQLBSrgUUSGnOtRTPsAeVdBx7C00u66Pl?=
 =?us-ascii?Q?lESGhQZt4HimmzfcDavOJCLcpbhH3XyUXsJeCvclbuGl8wJ9cvtVrPTUiwz+?=
 =?us-ascii?Q?CGzC6Zn8HUKnK50UqmOmdQWCU5vTyAmoeoxYcUpqq2QSuKPB+2/B9ldUIgZ1?=
 =?us-ascii?Q?RqwhrjUDIPA4X0uliOxGJnPW+eqVfIky02XukIU7MNGcbUmpyfLRs50SGeoj?=
 =?us-ascii?Q?er++qjHFLXMnT4AWM0RUKZwloGqG67CjcRZEltuj5RUxQY1GjEOsdl6Q9G71?=
 =?us-ascii?Q?2ub0Ckg70KYmaodnYnqZ00LmS1JhAqZ+Q94FrQDJy2laR+J/j2vxs42hi1Ti?=
 =?us-ascii?Q?0jDQOFrOEolzr5Hg5vtSQwf0RwplmIIycNiat5PszBPKuG8QRwyYpuadb00+?=
 =?us-ascii?Q?Kpj8j3UJFFo2vruAXoQQt6ERkgeAHwAqk71pNglC2o5ZAnbv6HGk4pK6AdA6?=
 =?us-ascii?Q?7fH2KGTGYeWtddtgTFPp78FKWv1jqITBkthwvlxS/BbiBW3I3/8EcIC8+A2i?=
 =?us-ascii?Q?ucg5J5Jgikkt27QAmN2c6ruYU4Ksr3Tf4VuIplYeLiywCucuLaW3xab9KEQB?=
 =?us-ascii?Q?1x1HXi4iNgJlTwJCsZKEogSU3ZjrnCVAnBh7MQEOGby87R0Fl21G5c17CZIY?=
 =?us-ascii?Q?afUkIkZbJSR4bg8+mWHEgq+btwtmAyXj2Vgz0ijuFYyDgOYndanyVjLIXM+A?=
 =?us-ascii?Q?mbk3hcpy7JPMxXa0VrYMUdKapR3RDZ9Q2hMk8wKh9AttMUWnzD0pHWgzMAKf?=
 =?us-ascii?Q?HUvWl52j4m90fvicNG42Vmpva2ddNaw2dNv0/H8oIqxjri79rHfLkTK2Nqwo?=
 =?us-ascii?Q?IuxKkN603awreFXRF6SAR9ZKDGyL1oiVJfD+5qD3CDpNNSq6xh+wBKtIWBN5?=
 =?us-ascii?Q?EncGCrkI6jZwJFH0/yw7NfjPZm6vcDnWuTNDK3oxTbJPDS1l4OEOVBT9TwHz?=
 =?us-ascii?Q?TnF35f66ze5FuI9wBmTdtD74pjbCJ2It8BmKnyrQMalmpQrTqomb6pWqLgNt?=
 =?us-ascii?Q?xQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a06f85f2-ed13-4882-f466-08dafe163fc9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:21:14.5844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PylSYDjdF2nhXEK7pCi9i5BRkLOX2WKZSBJx/907o4t0fWE5KKgEmf6IDdLIRTUHa27z3K2uCjcZ1uJcfstlrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9638
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the man page with the new --src argument for --show-pause, as
well as with the new --show-mm and --set-mm commands.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: document --show-mm too

 ethtool.8.in | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index e13229bc7b99..ff76381c117b 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -490,6 +490,22 @@ ethtool \- query or control network driver and hardware settings
 .I devname
 .RB [ power\-mode\-policy
 .BR high | auto ]
+.HP
+.B ethtool \-\-show\-mm
+.I devname
+.HP
+.B ethtool \-\-set\-mm
+.I devname
+.RB [ verify\-enabled
+.BR on | off ]
+.RB [ verify\-time
+.BR N ]
+.RB [ tx\-enabled
+.BR on | off ]
+.RB [ pmac\-enabled
+.BR on | off ]
+.RB [ tx\-min\-frag\-size
+.BR N ]
 .
 .\" Adjust lines (i.e. full justification) and hyphenate.
 .ad
@@ -533,6 +549,15 @@ displaying relevant device statistics for selected get commands.
 .TP
 .B \-a \-\-show\-pause
 Queries the specified Ethernet device for pause parameter information.
+.RS 4
+.TP
+.A3 \fB\-\-src \fBaggregate\fP \fBemac\fP \fBpmac\fP
+If the MAC Merge layer is supported, request a particular source of device
+statistics (eMAC or pMAC, or their aggregate). Only valid if ethtool was
+invoked with the
+.B \-I \-\-include\-statistics
+argument.
+.RE
 .TP
 .B \-A \-\-pause
 Changes the pause parameters of the specified Ethernet device.
@@ -698,6 +723,10 @@ naming of NIC- and driver-specific statistics across vendors.
 .TP
 .B \fB\-\-groups [\fBeth\-phy\fP] [\fBeth\-mac\fP] [\fBeth\-ctrl\fP] [\fBrmon\fP]
 Request groups of standard device statistics.
+.TP
+.A3 \fB\-\-src \fBaggregate\fP \fBemac\fP \fBpmac\fP
+If the MAC Merge layer is supported, request a particular source of device
+statistics (eMAC or pMAC, or their aggregate).
 .RE
 .TP
 .B \-\-phy\-statistics
@@ -1510,6 +1539,76 @@ transitioned by the host to high power mode when the first port using it is put
 administratively up and to low power mode when the last port using it is put
 administratively down. The power mode policy can be set before a module is
 plugged-in.
+.RE
+.TP
+.B \-\-show\-mm
+Show the MAC Merge layer state. The ethtool argument
+.B \-I \-\-include\-statistics
+can be used with this command, and MAC Merge layer statistics counters will
+also be retrieved.
+.RS 4
+.TP
+.B pmac-enabled
+Shows whether the pMAC is enabled and capable of receiving traffic and SMD-V
+frames (and responding to them with SMD-R replies).
+.TP
+.B tx-enabled
+Shows whether transmission on the pMAC is administratively enabled.
+.TP
+.B tx-active
+Shows whether transmission on the pMAC is active (verification is either
+successful, or was disabled).
+.TP
+.B tx-min-frag-size
+Shows the minimum size (in octets) of transmitted non-final fragments which
+can be received by the link partner. Corresponds to the standard addFragSize
+variable using the formula:
+
+tx-min-frag-size = 64 + (1 + addFragSize) - 4
+.TP
+.B rx-min-frag-size
+Shows the minimum size (in octets) of non-final fragments which the local
+device supports receiving.
+.TP
+.B verify-enabled
+Shows whether the verification state machine is enabled. This process, if
+successful, ensures that preemptible frames transmitted by the local device
+will not be dropped as error frames by the link partner.
+.TP
+.B verify-time
+Shows the interval in ms between verification attempts, represented as an
+integer between 1 and 128 ms. The standard defines a fixed number of
+verification attempts (verifyLimit) before failing the verification process.
+.TP
+.B max-verify-time
+Shows the maximum value for verify-time accepted by the local device, which
+may be less than 128 ms.
+.TP
+.B verify-status
+Shows the current state of the verification state machine of the local device.
+
+.RE
+.TP
+.B \-\-set\-mm
+Set the MAC Merge layer parameters.
+.RS 4
+.TP
+.A2 pmac-enabled \ on off
+Enable reception for the pMAC.
+.TP
+.A2 tx-enabled \ on off
+Administatively enable transmission for the pMAC.
+.TP
+.B tx-min-frag-size \ N
+Set the minimum size (in octets) of transmitted non-final fragments which can
+be received by the link partner.
+.TP
+.A2 verify-enabled \ on off
+Enable or disable the verification state machine.
+.TP
+.B verify-time \ N
+Set the interval in ms between verification attempts.
+
 .RE
 .SH BUGS
 Not supported (in part or whole) on all network drivers.
-- 
2.34.1

