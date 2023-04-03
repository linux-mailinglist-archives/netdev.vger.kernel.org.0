Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9A56D429E
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbjDCKyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbjDCKxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:53:34 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2060.outbound.protection.outlook.com [40.107.22.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DBDB76F
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 03:53:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AwDqiBwNV/RyxXigO6mVBx3MGcTl7J5HagZBWEseONqp3Wj+JWQFUCodKQMUdkPx85G+ZJysBvNTORF8N9G6yTC53lojf2tdEMRzkfJM7OOcwkF5Q7NI5C+0p1lACG/nQHWXfkxSpZFPUjKhhrE017rUbNxpyQiftWXSedi6xHUfKkX24PUFjDPP+yHDI39tnTkpn1XEbWLKv/7xRAPwOPWzIAX0/BHDnIKxVNZ4RDiU/Ykh+ayRldirpn0r1nZ1vjRku16hn5i0WGs9rdfD5uFJCiAzxKY0nkto6sfa+5ZewrWkhiyFdCSY9NFIFH5M+QH+Be84kbarUdb04bMViw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZ09lQ2EjxALltfDWQ4bHiT52QAFHn4E5bhGpBmYThQ=;
 b=Dh89ZXLJZZZuONX3U1/5ssbt09lUWmWlc8VPoJhg1TGBubCh3ob0DQ92IjvVYeLjCcMViCIj+7VcU6fTZ2GdHvolLegKTAJxZlvHWCVJzpiszGPzoK5CVXX0M3zCgMF5zhtlH0wLVdfpbMJ2VULfaRsVBiqkxlF5cjrUOtO9NVFvAnGxxHY8/yjTGSz8co3u3M7jjqOXIYSOlPrI2KUOoC+/Hqu8ZBFTlKr0KQ6Q1GcHSFWX/F/ENmLiFbv+bQtsCjGtId6lpYdwZZgbP3yXLkIQdbtYutY3/EPVqcM5jgUk0013ZxPRI+MY36STpnrQKgcBl9PQB5aGMcHUomgtBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZ09lQ2EjxALltfDWQ4bHiT52QAFHn4E5bhGpBmYThQ=;
 b=FrOEK+rFMBe9bwiJeEEZMznK/520Vb49OpdtVZ47Rf7pKUEMZ17lthZPCJrU3LoFsKQw/NZtcewLdbPkl1vK/Tw1cCbv1qNkonrZ1Z/eZ4qoUNprcYMGFdbssKYFgC1cFpnizodmxBO7X4fDbgGowdMtpJbrxI1y0AI3iTuTcs8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB8479.eurprd04.prod.outlook.com (2603:10a6:10:2c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 10:53:07 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:53:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 7/9] tc/mqprio: break up synopsis into multiple lines
Date:   Mon,  3 Apr 2023 13:52:43 +0300
Message-Id: <20230403105245.2902376-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230403105245.2902376-1-vladimir.oltean@nxp.com>
References: <20230403105245.2902376-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::16)
 To AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB8479:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f78b5a4-fdbe-4523-ae2a-08db34319b57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xxQmwCBA2ZJEwxe07D+dHltIg3vK4R2dd08eMQzwF57eGmfJxXB0C6aDn41tiXpMeid59S3D7CNHTuks5UITjYkw97vprKaHN47lF2lUYMQAazOL8tJfBqWETYF6adM6/Majcy8XiU+z0HddjZNYW2baW1bBYqzmbtQLyHXZdLfqNrx/JKPQsMwrZQozPCv8zGrtGNsbeQIWQAq8YJ1uPUEPMREmpKpJbnbk0O8dB47ugc/HX2nbBECpvsQc1mP1Un/XWKh204VOorj5aL970aP9f0jATFkOj0DciPyoalBvymhhGNgE8kkD2wAZj8I6CPAJ4jSR6N+9fT9onOP5d1PA2j/DWnVFjOdT8V8CACPdizFBtLtnTOi70/8pfIrhOm6V1deGgsqrQ52yVFxVlh/oJMJxdDOwV77ERNTm/V3QI8J7XSmYfzBRL5HXDMx51p4XUW7T9mubUKxHqzECtL7MfCFdDs6t4qlkPYISsQG9sBH0rFOH0SGM6JJEDy/16ChTUaqj7EPJVoQiPH4tLI7JaPA9IMQRLwOhxs/hZEOUPcE0ikF5RJ34+3hnRZjYI3LlIkhcZ5oQAuW8YXHIvD3YhnqNw+GM6n55dW5S9dnPqGO3HRbJI/2lNCgmr2J5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199021)(8676002)(6916009)(66556008)(66476007)(66946007)(54906003)(316002)(478600001)(8936002)(44832011)(41300700001)(5660300002)(38100700002)(38350700002)(4326008)(186003)(83380400001)(2616005)(52116002)(6486002)(6666004)(1076003)(26005)(6506007)(6512007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wNLgxVzUZPiKAoP1mMC+6qLlQiVv3xw230RVyI5eVSYpZpt8xEWk9AT8J0sQ?=
 =?us-ascii?Q?6aDU1OvD7aJ0WelCwJkhAsDCrZezMiVW4I3sT1QPrN84NMb5Z9ZLbehFHIlZ?=
 =?us-ascii?Q?akgW5QD4f/PedfmkW76PT9acjofGn0RSoLVCiEotFpwDBxT9vzn3+/tr6lkU?=
 =?us-ascii?Q?XSkOwzyMkfzHH2GKf4v5j1GORt8ctk1RDgnELRpwolstU78Clb8KravRB/WZ?=
 =?us-ascii?Q?I5sgNl424pOYzggfF9gSpsKJiC0qMfdz5tFX5eUsZIDX+plvqdVArFKCWF1T?=
 =?us-ascii?Q?G6oW44Iy2xTxeCy8H79u/ylsFfFIM0+BuCWbgkHjeSMRb8SExxfhA1lo5+Fe?=
 =?us-ascii?Q?uJsB5exzSKsGW3llwQSY8D7IAPKBYKudRmELiKBoefKzwexWJps6e18wLM8N?=
 =?us-ascii?Q?FO/dz+CerTJZ9qS2bVzs4gxPbl3nOJEOvMFpVwPC+DQ12eY3pu8pWx2HcfHR?=
 =?us-ascii?Q?23LcIZydkPKJ2KRCz7QFOJ//Q3T++siQ2nGil5fPXVhCN36n8Yj1KFB032kL?=
 =?us-ascii?Q?lzWteEB3Il7twx4FGVjJgwEknj4ntZJrV3GgQV67v0u8vh1CNpIreyHH0xTx?=
 =?us-ascii?Q?hX6zNQCTwqko7M1mCXCdfuCGryf71R1/OY4HoULEYJoVjQsC9jTdpj8L8GPq?=
 =?us-ascii?Q?Yj+Rl3ZeKNXwGFxSSH1w3qZsgrCxtly9fu6gJkw0cAPc2zHdhcQ0ISZCTU8z?=
 =?us-ascii?Q?ImyLcwaeYXNvKWI9t8oJoFTYbwefYDM/59k79fy0AMead8FP6EZ5lyWPVdw+?=
 =?us-ascii?Q?0oIZEjAzdOnMH2Vs78syagvQa8S7rovQk5i37hAPmnU+nVlBEbOMYGsosKZw?=
 =?us-ascii?Q?sn53cSdZCPJKZH+ccLf9eEvI7E7YsWrzSZtOmQEIwABb709ZCRv0/NgVZLBu?=
 =?us-ascii?Q?hyns36pZKMGMlzQjTdWt7U6LU214v0tpGe977jc0zjkLKhzCiiASKgxnSeJH?=
 =?us-ascii?Q?3He9j4iZbIv38/ckZgIS/noX/wN8spT7hq7Q/B9zUlRP7pJZ3Py+hQsX9Qeq?=
 =?us-ascii?Q?BZzbXQMGO7sKnbf/wXMlJ6cVibMXKrageIRpM6tv3TJ61uPdNtSOK1n5qmY7?=
 =?us-ascii?Q?DK4sQ44U4LNpXES9WJ2NkBC0ZFRqOLVCUhukqwWC5RhhpX61wDExEcvKN2Ik?=
 =?us-ascii?Q?YfbHH0z6leBxUu8eLBHy7QHTs09YCkOdwAJYyCSTnQsDdCK2Ic6nKJZpGgQ6?=
 =?us-ascii?Q?vvn459HRsY3jBbkz8zxOjeNiN8RLBNOuh41ko6r38nsiE2iSuIIl0LomKdg/?=
 =?us-ascii?Q?CIJLCYEo0ZuRRHm3mUZaVgPnDa9tSLdYkqGv/vSn4E6Xt5jFY3LgOgvcL5Fh?=
 =?us-ascii?Q?ob8VpQdVBUBkkLuFqnkR7yAfR0tPHqACZ9ncRUjBgzzzeUmulDuRglsqwoUg?=
 =?us-ascii?Q?hyedAZFfKyj1M8Lw7NnKYM4TvHcUBcVHgUal5H6h/W7NWzN72GSJpN9ISbNf?=
 =?us-ascii?Q?AWb8XZgbM/04TkRln/1q2ND/G8P8xlfWSVw8Ag3ReWwePDDM2pEViu8MLI1x?=
 =?us-ascii?Q?+GFTHWGGo1m5HA85YUg/+R1bmTDc2KTSzmkW2d92oS0hdsXSZ37c5k+iHgxR?=
 =?us-ascii?Q?3qqS3a+Qa7qaZWgQ3g4KoUB0YoW68NbRp7g9MlECzXBrRT9TvzMMz60IrSj2?=
 =?us-ascii?Q?Kg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f78b5a4-fdbe-4523-ae2a-08db34319b57
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:53:06.9074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aq5aII7GW2JxksRCddaGt2JCSs9tZDooeHdkIo7J8Bf9x0P+3tItap7oTH8emn4dw+/500o9AOzvyzufMib6jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8479
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tc-taprio(8) has a synopsis which is much easier to follow, because it
breaks up the command line arguments on multiple lines. Do this in
tc-mqprio(8) too.

Also, the highlighting (bold) of the keywords is all wrong. Take the
opportunity to fix that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 man/man8/tc-mqprio.8 | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/man/man8/tc-mqprio.8 b/man/man8/tc-mqprio.8
index e17c50621af0..3441cb68a27f 100644
--- a/man/man8/tc-mqprio.8
+++ b/man/man8/tc-mqprio.8
@@ -3,23 +3,30 @@
 MQPRIO \- Multiqueue Priority Qdisc (Offloaded Hardware QOS)
 .SH SYNOPSIS
 .B tc qdisc ... dev
-dev
-.B  ( parent
-classid
-.B | root) [ handle
-major:
-.B ] mqprio [ num_tc
-tcs
-.B ] [ map
-P0 P1 P2...
-.B ] [ queues
-count1@offset1 count2@offset2 ...
-.B ] [ hw
-1|0
-.B ] [ mode
-dcb|channel
-.B ] [ shaper
-dcb|bw_rlimit ] [
+dev (
+.B parent
+classid | root) [
+.B handle
+major: ]
+.B mqprio
+.ti +8
+[
+.B num_tc
+tcs ] [
+.B map
+P0 P1 P2... ] [
+.B queues
+count1@offset1 count2@offset2 ... ]
+.ti +8
+[
+.B hw
+1|0 ] [
+.B mode
+dcb|channel ] [
+.B shaper
+dcb|bw_rlimit ]
+.ti +8
+[
 .B min_rate
 min_rate1 min_rate2 ... ] [
 .B max_rate
-- 
2.34.1

