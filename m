Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64EF6D4298
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbjDCKx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbjDCKxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:53:18 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D697111E8A
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 03:53:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IzRto7iZO9cTQAsWB6hpaKAlnxF3sWQxiccbif+VwLEMMIvOIrfuQ/LOpd2HA7h7pxPTHyR8xQkLVN6be+QxcDvglKpHuaaXEHUzTH7zsNRfx/isSsFSDDbk2fEnpkApilXpYifN8wbrR4RgUU64MNvFFu95Z80vaJ8nU6FkmMgXYGTeLxR2i0UP9pkCHz3LLBwY6z72JO53gtoCU3Z1DSobCBIoHpsxs4Nwd9kg846qPuQqh32TN7847Y/cAe+WXkWA9tMztmM/OQoWdOKWBpIqHhJIKWd6MR6GHB9sxyL/1+dKUNCUUwNK/TJOagv/lKjYUEt9xM0DEzvWt7A0/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JiuxIoM08fUh+XtMh8q7JETTpH7AXWqAV17zxZJK6RY=;
 b=Svm+ap8TUUtZaFG5m/LI53hNA8PW+gnzrZoFHn68KSpMjwM7txGdIlfTFB90cPhh6y0TxT+yKK7Vk4xPKN15AyZN7fUQZ++bk7h2pBn6JnDfko14mjpOWCBMkIGHerQHxHxfdrHBJobo09WBOp8UOmZGIqwWzrcXsHqaNoHk8JXt3mPkjfOQguNhbwCOtqwvfMPHiMkkKFt4539gDpoMqLUNnuMraXtSRhcOSa6v+NutkDea9vjwIiRJfQOrXAdU1S+fZlnxb8ojSzfmpoFd6LNVnQUcU0Rhawnvp+i0s3ZYKMas4AufIFdRm/pju3O8nsnuzm+DMsrWBWAOh3+2qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JiuxIoM08fUh+XtMh8q7JETTpH7AXWqAV17zxZJK6RY=;
 b=IEWeHhWWk0SWsThM5xenP55kUI/M5f/VzIcIZyrQJ0Y1PTcKHXIDmngy9zxgiINqHvt92+v4iNuf26Go9gtyzpvj0ygI2V3/ca05BL8p2YizhFlM8TWatb0ODM5LsDeX4H0hGRucH7lK5MNzmGa/nyjFo5etMQrx8psJb2DfHPA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB8479.eurprd04.prod.outlook.com (2603:10a6:10:2c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 10:53:03 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:53:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 1/9] uapi: add definitions for preemptible traffic classes in mqprio and taprio
Date:   Mon,  3 Apr 2023 13:52:37 +0300
Message-Id: <20230403105245.2902376-2-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 022d9abe-37ee-4312-cb41-08db34319967
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3uGRYFqMJ8XqnEW8Utu+KnJeq0t1kyaM6h+FQHelV2slm65c2Rhb/rJdHymE9dz92jZnGNv65t3rOSdjMfbo9gRwfbWSNyPj+iteLvbXI0nwGz2XX3i0m3QbVpypJ1US1Wx2Afj+6EG8NkLmLb5OI2FzdkXB25y5KhcizEmCyCCkYsPF7NQEHdCVda/dL3CXpPk289DcmXnCSqY+rS+NzEFyeYUx59b0PCM7i934HbYwpr+nJy7KGMjTgQxw1VK3/kAURnlmxq2OmmuawpgaYge6jbn/z39WzeyIXjh7CD2C66/AhkrL23PKgSFRHZ+oOHJIAPgA0/VVY4bDxk+EQdkDod2qR+9qzXQ30oNhpgPi/HwUE+8fRc1CBgO9bM/D/B0zYihbwaA52sQnMaz0TjbT0MlqweVbkzN+WTOVAd8JoWhP5rZ52zboW0SFqoJAyWBoh/CSExOgirquigYm14O1Ikch6GHGSQ59+LYwMalbI1JE6JVSaV0Uuq2923Rwr0b6+rxQ0fPdElx2ypRjzncwNrOl19pFS0Bbawe7B8jSVlsbOts/Nx276vzsbRCtQ8roZ7eAD55hJ2yakZVVNuVEfYldp05Tre0mInkv1uT04uKpE2w0e2Nw5S8hvL8Em+Qz3y6dOTiti8/1j0UJLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199021)(8676002)(6916009)(66556008)(66476007)(66946007)(54906003)(316002)(478600001)(8936002)(44832011)(41300700001)(5660300002)(38100700002)(38350700002)(4326008)(186003)(2616005)(52116002)(6486002)(6666004)(1076003)(26005)(6506007)(6512007)(86362001)(36756003)(2906002)(358055004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2ZE7oX6d0EK4QNEqD199hg29YLTfuvOXwyiatb0PcsCaCx/+oEfmkBfAr33U?=
 =?us-ascii?Q?lE2TeGw6Rw2Co7HXZbZQ2EwQL0IFpLNolSR+rsFAQ4VKDdVXuUTSkwn3dJJ/?=
 =?us-ascii?Q?ccb9+Aine00tu6YkiISESukKvGW2dlQV2Jkv9Jy30z31AtzKmRXdMhJWz+sH?=
 =?us-ascii?Q?IY2986glFWq7rQ3P0+VOeXs21fmnDOycKYlbQlABgBBNgtD/gShORAGfHmXl?=
 =?us-ascii?Q?ecYDB+YXH3wexOI10Z5YEJ5koxnsGXOTCdPlcXIv9k+cKgi0KVrcXPFRVRc9?=
 =?us-ascii?Q?P75cuHzR4rNpvwzqDevVyajNpILtZiVlO9Zcx5ZOdal6m+K2+a9wcnV04B86?=
 =?us-ascii?Q?esoYm/zO4djJY8mNtmOMDnifIkKp5Xc4F0wGF2Dv6Vp+tlQv9uwCzKzELR85?=
 =?us-ascii?Q?1JWFvMl8zHjGMKo7U6uowf9zOTf8kSfW8fPRAfLdQzUsO/U2K/qS/CIN0E9Z?=
 =?us-ascii?Q?f4/Z8TLArjMT6NB0oeRYqUDDh/r89i0DlcC86MLhqwYf9ij05zxDuaMJOEsT?=
 =?us-ascii?Q?5tuu8GGl8evbudO+pdsIZE5t03zys/tqonTRHN/je+SgAZXMRJD5iEgIal0h?=
 =?us-ascii?Q?SPFnNnzP0+Y7Ek9cpce23scPMJugQuc3c/voXYTYGb804VaKNvCmaY+y7Jcg?=
 =?us-ascii?Q?nqKEdQxN55iRjvPNaVjPRCSBh2mdAfut2G+o7pwwXH30dBmlA2xNEQVu8A2F?=
 =?us-ascii?Q?qoSFVyospiiP0Dey3dOTeQAsnCMwB9nbNYApGkDbT6u0so8DqKM4s/2h10oG?=
 =?us-ascii?Q?6TkEMqJdPjvQOEa499Z72/gWCyR/Dd22/yYBhrOXnu6ehDL7QArEaPqJ+4M3?=
 =?us-ascii?Q?WwqyYZcM5UEzpga+6GVjNPi/0Jx5XQwk0L6aosM2c4ZGeKvVwlq3F1akhgWG?=
 =?us-ascii?Q?cyJL99gQ4A0Z7mmbARWs/adfOyW/K3t4eTRbWLm8L9SPFlUeUGjn9PVxvtMA?=
 =?us-ascii?Q?obz9vMbj1uSMib1dggTSPgxf3dhY+WeM4tW/+RGnVxyqsKTP4EIZsvmDbhfL?=
 =?us-ascii?Q?vBQZEaNM8ht8sVT0KxicVqaq5lrFxt6MNWZTWF+6riEmHr1aZCMXmozWm6Km?=
 =?us-ascii?Q?b5WWQk8DuITo2hyrvVMkvEe3iK9gvzgLVHImi/V4jXd9ACHY3EcusHSQkciJ?=
 =?us-ascii?Q?FW50okdfKMydjWyTj0FgS+Y39xobLMUuMdF0VM2c1K9Kf8gkv02Y9eSHHmR0?=
 =?us-ascii?Q?T2Yv4r4gVSP9J6FTrDjc1EceV/0PS8k01noarDuuoYBN0Fvit7r3fT4BYWvR?=
 =?us-ascii?Q?5yeEHXkr+iylpt21L0FD+XMJ+JYHgJk7tyRK0N4biejW4U4ev/oORynoiwPK?=
 =?us-ascii?Q?uIF1hV4S1sXP/nSao9lvKehih5cGaXfXKABYTIuQbty+aIo/I90hkk4B7mIt?=
 =?us-ascii?Q?R7TyOQG+ke5zm6pDjxN7gguHZZ71zF3Ucep1M9KH2IAylzEiHBNNZD7Hb+r7?=
 =?us-ascii?Q?PSe1M2we3gicHkw3gvD6UmN4x0P5qzaGrmkhUhGaP052cWg3UJoaEUv1qBSr?=
 =?us-ascii?Q?GlvvGVEL0Z35PFhf21V9iiWUj78imG7FwAS8uKKYSB/1gT7DDPgmNzywRAu9?=
 =?us-ascii?Q?gFTL9ynbRg6BZWym1O6eFmw73yrRbwVWH/smuq1oIdsjEo+RLvd2wewcfhi8?=
 =?us-ascii?Q?JA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 022d9abe-37ee-4312-cb41-08db34319967
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:53:03.6827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dtK2iIIg36HPNEB3v9vrIwqQyGoODhfFi2CKsHENaQ29xA+zRW4/mKgA4jQgtEb8RKXKKKDbwe+YAPWvrtE2zA==
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

Get the definitions from the linux/pkt_sched.h which allow us to add
netlink attributes to the TCA_OPTIONS of mqprio and taprio that specify
which traffic classes are express and which are preemptible.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/uapi/linux/pkt_sched.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 000eec106856..51a7addc56c6 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -719,6 +719,11 @@ enum {
 
 #define __TC_MQPRIO_SHAPER_MAX (__TC_MQPRIO_SHAPER_MAX - 1)
 
+enum {
+	TC_FP_EXPRESS = 1,
+	TC_FP_PREEMPTIBLE = 2,
+};
+
 struct tc_mqprio_qopt {
 	__u8	num_tc;
 	__u8	prio_tc_map[TC_QOPT_BITMASK + 1];
@@ -732,12 +737,23 @@ struct tc_mqprio_qopt {
 #define TC_MQPRIO_F_MIN_RATE		0x4
 #define TC_MQPRIO_F_MAX_RATE		0x8
 
+enum {
+	TCA_MQPRIO_TC_ENTRY_UNSPEC,
+	TCA_MQPRIO_TC_ENTRY_INDEX,		/* u32 */
+	TCA_MQPRIO_TC_ENTRY_FP,			/* u32 */
+
+	/* add new constants above here */
+	__TCA_MQPRIO_TC_ENTRY_CNT,
+	TCA_MQPRIO_TC_ENTRY_MAX = (__TCA_MQPRIO_TC_ENTRY_CNT - 1)
+};
+
 enum {
 	TCA_MQPRIO_UNSPEC,
 	TCA_MQPRIO_MODE,
 	TCA_MQPRIO_SHAPER,
 	TCA_MQPRIO_MIN_RATE64,
 	TCA_MQPRIO_MAX_RATE64,
+	TCA_MQPRIO_TC_ENTRY,
 	__TCA_MQPRIO_MAX,
 };
 
@@ -1236,6 +1252,7 @@ enum {
 	TCA_TAPRIO_TC_ENTRY_UNSPEC,
 	TCA_TAPRIO_TC_ENTRY_INDEX,		/* u32 */
 	TCA_TAPRIO_TC_ENTRY_MAX_SDU,		/* u32 */
+	TCA_TAPRIO_TC_ENTRY_FP,			/* u32 */
 
 	/* add new constants above here */
 	__TCA_TAPRIO_TC_ENTRY_CNT,
-- 
2.34.1

