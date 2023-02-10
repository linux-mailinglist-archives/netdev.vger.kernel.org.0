Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC49169295C
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 22:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbjBJVd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 16:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233824AbjBJVd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 16:33:57 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2054.outbound.protection.outlook.com [40.107.22.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4FF81CE3
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 13:33:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MuMr8ew6xoFBapcsdeHPcf1erh3MoTILzzmomGI/btXnCA6KoeZ7zxfOMPesjuG12W6XjtadydqG/dFlVk4EEnTiQBs5WMj+m6yJRyAFbpjv0pvgpcdWk0v7JOsLAWiOJs8t6Ng9Y68CNjF4a0e4Bm2/oeYsBjynQKpEiJwvm6gJUg+sIN8c5vLzMK7910JENti6UPbYfuCp/vyxpEeQQpM+RYfGt6nXIcLgClo9IkHCXvvPcIc0hkYdNqaQV8ttKLu6OXorJx3/GhJA1yYUr/0sGw3d+CVaxlayzbkg6zkBijeZxruUI5EMQZ6vsP0fGC90ygypqbfj/4+Bawp3Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G3VIYG2gelJOBl+veJVkKKuQpbd1bxM48He4cNmLss8=;
 b=GzxouE0TAjJ726Qoote5Ho6VsiXdJyDxjNJGW10bH+kCoO8myxTSOqkTihQGYeVgaNogGrc8nKvsG3DHRZixcy38Do174AGDz22E+tFCl4XjkLUb8nF32GriGHZ2pavJ7GrIsJpxXRf7tIZhlGtnkRGurkMRNCqlmhlGVDe6ICYAtPNjGJ1AiNyK7nolkNq7RzxyT6hNFDgDVRqIOFHEkrPZfWlo5DHZFdf3pKmfMmWeKEY0rghpxN6Izb+BkIfnOS/oRIHNIMd/4zoK8PKcnrVNhq2diPk3/TdzEv2p/IjGk0qK0iczmt24WVN0KNe8cqqzFeSy/oPm+BIgdZfghw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G3VIYG2gelJOBl+veJVkKKuQpbd1bxM48He4cNmLss8=;
 b=OXJ88nD5YoBpvITIX2NoFOl5u4D+UHBVdDD91tZ6IWHO4wFKOozV49ee6I7/di6nHEkuIy+mHejwA6y1esmEYTc4RTlZ2dy15uEuxpxnNxOc539aF9KlDC+2Jetoyu7xotWUJvGzQ3xB94hqcJrSKX3LuQASsITtQCQQuJDJ7Ao=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6881.eurprd04.prod.outlook.com (2603:10a6:208:18b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 21:33:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.019; Fri, 10 Feb 2023
 21:33:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Subject: [PATCH v3 ethtool 4/4] ethtool.8: update documentation with MAC Merge related bits
Date:   Fri, 10 Feb 2023 23:33:11 +0200
Message-Id: <20230210213311.218456-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230210213311.218456-1-vladimir.oltean@nxp.com>
References: <20230210213311.218456-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0019.eurprd04.prod.outlook.com
 (2603:10a6:208:122::32) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM0PR04MB6881:EE_
X-MS-Office365-Filtering-Correlation-Id: 96604b99-20d9-474d-d676-08db0bae7304
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7mzH3YXZHDDIVMp7CLcWJxjD4BjFBf2oAzvrWVswo8gMa10V6D/B4VNtJlsgaXOXSx4o5pHUyyc4iucYeDjdZRgtMUk1elCdlM+NiG2/+DDgzGsi2j021eC8wxZW3gZ8KT10Pb+AvBS55yeRkaJ+0Ldhk/6hhOaeZo8L5iWHOYV9q2s7Q6wgzoc6h9A2ZC2dZsYrCREYDcdZR+ivcQ43NpS+MkUu94AecT6UoXX7ayVuSbpn2U+r8jRtcS46J5uUmZRlUyKo8Hzq5axxg1UtHNY94Op16FSQ5xzM+RFM8HbLrhyBbDTV6y67ChLmi9AHL7LQwjdCE7yMvPUz4wWzjc08QLLgRY1tuACEUBKWnPOypuPoaXEkcTC/7jAvn2iHRK1K5tcXwVvGq2IMVmJmAipevSZrUEYZITzgbrxS4ldZ7DxHCxnOV46IheYHSVkWLU356tlbfwvKR6fHV/kfsXu+Fqgwi4zVxSj72JodNgLOqnXNBiSxG8KW/s5dLaiAsyPlunsnd0epYYpIiKma3mK9RH5we8TUyFn6NohQ5p75cS81loXyFN2xomZU8SLq2fKHS6juHTyO77r74vmJdabUC0j6MJq8kupLwQ8rJALBZHsGIxrWlrMOC/mIbd/h9NUSQTydLb3PNtnMW51Gv00Ri52bfLgV4Lxo0AAQSYvKRrYH3xn5yXYuColxQAjEw2dBT52/Qylt4i0btHq4Tg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199018)(186003)(66476007)(6512007)(6666004)(26005)(52116002)(2616005)(478600001)(6486002)(6506007)(83380400001)(66556008)(66946007)(1076003)(54906003)(316002)(8936002)(6916009)(4326008)(8676002)(41300700001)(5660300002)(44832011)(2906002)(15650500001)(38350700002)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3u5Pbg+eFfDz6yE+QL/xLI1lE4DvBEVwD+gfM/0TtV7XEx3fu2T1IdR31I5z?=
 =?us-ascii?Q?hV5C5mo5gkAfYnjUD2DFwiNqBX9GYQAtslGl6o4xUjrimYFXiX3UFjPXlIFF?=
 =?us-ascii?Q?vsIrLVv6NNwd3kitNV0Y/LwXuV0HPECf+yd0I2sCeW3hQIFGs/8fmolEmbbN?=
 =?us-ascii?Q?E712jSChYrbVaik4YCYwjqGaZ314UNSK0sKk9i3Wl1cPb6Yh64Msf5ntKamr?=
 =?us-ascii?Q?KW5T6XfIkwz1h/mZ1jexIB1mUwlNe1IcGPqtxppHqJqS924bI7g/okzad7fW?=
 =?us-ascii?Q?vYMPHfrF/CSGLLPqAtWjkPwIjCSSdbSmJJFeMy7u4yXu2A288/HfbVNtKPkd?=
 =?us-ascii?Q?7h0gpJb3xdXtt1tUaYjtlleE/ySEI2rMhecvNoMnNE5mjzcP/ztFEC1GUcMe?=
 =?us-ascii?Q?eD8MukSCw8YZC5DwwG/TN6ynTPTAOWwGSjaiJRFQUqAUkbmXWbm+PEIJtw7+?=
 =?us-ascii?Q?YqeAmVLtl7/HzbaT9dP0skzgOa5pVBvt3LnCXscJbbZShkAO4PajJeyK1h2e?=
 =?us-ascii?Q?pLXyqrGLuuSB+DtDYT/6uFp3BF/qn4HD06FcwxL4UawcXWoUOzZARu/HcVct?=
 =?us-ascii?Q?W24iDy0c2bA03SCZdBazTrUZ6UiiA4SsxJXDvY3Xwt0hlKJqTY2nCmc/nUst?=
 =?us-ascii?Q?SwU1v9HbvDsZMBxE/ZV1OdalhFd3vJKG13WP+pz2x9fJni99rPeEOJeILuvT?=
 =?us-ascii?Q?P5vow1J7SQm5LgIi/jf5dFoP0ZYi22S3t5mXaa/Gf6S3Cxd5LycBGAkawGmu?=
 =?us-ascii?Q?M88K122vomj02Tykies/l70Sxxa9zR1P3E8piiF2pLKOEsvLDtE8x2dP7YHz?=
 =?us-ascii?Q?mp4LQk5LS94mtVhU2WjiEMDTSELBwTWFXH30CiTUy5uP8f+F/V4ZTxAJZmtJ?=
 =?us-ascii?Q?nypkYn0dPyy9Wg5TbNz3I8xcJeVw2EYglxpI9metWXwVPCevCI6/SARizuSG?=
 =?us-ascii?Q?vOHo8WyKd/C1k9VgABjLCJou1wMH12tRJK5lDvzKCIJt4OgtxuBQ0CKAkxsI?=
 =?us-ascii?Q?O0rQwN3pozt/iZSWCZ5yqj/EiOAW1JSRMO4hAmSQ8tDgXHC0kp27A5M+shDq?=
 =?us-ascii?Q?W5ccH3dW9TIyqOvy6pyFUzxpyxRaGZMGldy1D6NoUB02Vuy3do8QWyKBrhSv?=
 =?us-ascii?Q?IwKA86yaojGhLVj1bC7E8MZGsLzKqOIbQ0sbjdggJb93xAN1KMMknxt07VNc?=
 =?us-ascii?Q?FaJTT79iXSBbVDvQf+cKaRBib7+cxfzGhpSI8J85upjCIOvlpobT6OX20Ybw?=
 =?us-ascii?Q?3/Ik8MTjP+WOfqyxDYHdxdMXkfpskMW0Mmbo/bdGhAR8Qu39tjJwidFiT9uR?=
 =?us-ascii?Q?Ykp1bwacR+60CwfdfkOIUWy53QtiQ3rbgkiiXHGyGTFXH11rH04xAX8fEMz6?=
 =?us-ascii?Q?1rw0grpCulJAytISiK5pY6wlaSmxK3Rg63MnBR/BOEOS1jqo5DGdkaPBEy87?=
 =?us-ascii?Q?edHUtvvGsminu3RmvZyL69tVnHrL+Uhwfg/s928T7DeZmcQQVkWl+oq2OmAe?=
 =?us-ascii?Q?vPrS2bU2UISmTpqh204hWB7AlXPruJVQRziT85+Ytb8Xn6nFePE+H3etKhPG?=
 =?us-ascii?Q?qUorEqKJQfcey0FT4j+Sw7MhDMSphILcGw/pMTaL9EPdwYZMzXBqJR+/a1Hq?=
 =?us-ascii?Q?UA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96604b99-20d9-474d-d676-08db0bae7304
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 21:33:28.6687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qV5g/oCCW6D+AszK8wktJgJeEp4DukrlTH2FJC1pANoQdf5XoG+dBHtinxhcd5dYMFaZMqHg7VauIPWWbhsaHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6881
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
Reviewed-by: Pranavi Somisetty <pranavi.somisetty@amd.com>
---
v2->v3:
- fix tx-min-frag-size formula
- specify values for verify-status
v1->v2: document --show-mm too

 ethtool.8.in | 107 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index c43c6d8b5263..03e149876c3f 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -505,6 +505,22 @@ ethtool \- query or control network driver and hardware settings
 .HP
 .B ethtool \-\-get\-plca\-status
 .I devname
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
@@ -548,6 +564,15 @@ displaying relevant device statistics for selected get commands.
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
@@ -713,6 +738,10 @@ naming of NIC- and driver-specific statistics across vendors.
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
@@ -1592,6 +1621,84 @@ for PLCA burst mode to work as intended.
 Show the current PLCA status for the given interface. If \fBon\fR, the PHY is
 successfully receiving or generating the BEACON signal. If \fBoff\fR, the PLCA
 function is temporarily disabled and the PHY is operating in plain CSMA/CD mode.
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
+tx-min-frag-size = 64 * (1 + addFragSize) - 4
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
+Values can be
+.B INITIAL,
+.B VERIFYING,
+.B SUCCEEDED,
+.B FAILED
+or
+.B DISABLED.
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
+.RE
 .SH BUGS
 Not supported (in part or whole) on all network drivers.
 .SH AUTHOR
-- 
2.34.1

