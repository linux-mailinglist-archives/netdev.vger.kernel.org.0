Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B14C698813
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 23:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBOWq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 17:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjBOWqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 17:46:54 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2055.outbound.protection.outlook.com [40.107.6.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5F3233E1;
        Wed, 15 Feb 2023 14:46:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3HiwfvSEpwNDCujSoyi8J8v2du9N+I6cKJVeWPwW979v2CY4F+iKgshAlcS9m6ZjJRXyGlYoaD7X7MhY5oHcN2drCt5s4AdGKIzypguep0krDTEIHNaZ9g8OqPWRyVD0vpby73E4fSESOSt40vUcQ+m3u2+lAYOhkNcmosmd6R6h573ZH9MAD7GfWR9HOF+axZPBohfp3lV4QHK9rLuK+jYB+Ng8KT1WRBKZ4lhka+9JojEB6xNU19g8DXja/cfGeDG6ZkvOKprzYLUOLVv3/qtCFvfS+hrL9fkPT4VBYeSZZiQKbm1yIGGXpzjQ/Wdt6nD77xm0oy2ceEZHK4PNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CKOohzS/K/Dlch2P5S9NgV1EZmt31rFp1v7O+O8wuy4=;
 b=MDASfZeVI8xlPKFIcOxscorkx8Uy9s2ubIeVw566A08J32KKlAdzszN4roh00p0WFBdaPzLWEnUHqQ7LAk1qfKw3AIFcUr7ohzmTgrv+963SSD7pbzCw60SL1bcfAGAJ8tykhQFS91aY1GOpm2JF22v4VpE1EVnFvYPnhMgNa7sSmqVHJF2z5iq/IUG0+HrEUDIgxmAwKDDDCk6WYVU7WnLXAWjCEzzF4/VtOJgM8TM8p3JK/A2Z4vgEKnbGPhZOborPqhX27Gn4sFQOwIRqvWmz7zbJz+aa2ROlgEDd29LZ02az7Goq6VIXUBIiZDj14sjgqI5KP4L3cskdVQ1B9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CKOohzS/K/Dlch2P5S9NgV1EZmt31rFp1v7O+O8wuy4=;
 b=L/9bEDQlDYITc54RwqLdXMl0Ei27vGnoG4Ny7rXP1QMEHA7NYMOFn8ZOcQVZI8e5EGp0Q5MABGz9RmGc9sPrnAyQXovVURPB6OwUqg9BX8alqmMUcFejQceJ76N8hgs1fjEbqVGtkwROIr0i7qIw/B0UlyPwtFwW53A05USnziw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8748.eurprd04.prod.outlook.com (2603:10a6:20b:409::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 22:46:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 22:46:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] net/sched: taprio: dynamic max_sdu larger than the max_mtu is unlimited
Date:   Thu, 16 Feb 2023 00:46:32 +0200
Message-Id: <20230215224632.2532685-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230215224632.2532685-1-vladimir.oltean@nxp.com>
References: <20230215224632.2532685-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR04CA0138.eurprd04.prod.outlook.com (2603:10a6:207::22)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8748:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c5b5a5e-bb09-4035-fc0d-08db0fa68768
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E+53zfQKAYrgenVGUC0Cbg3FgpOpZE/08x5BoGQ+Gu/lGM6nnHmQF28MZZQ9DvCq2mHgfDZyMLPKfu7b8RyoRyOwC4YeVVQEBOw7mvOyMUpK6zLh4kBmRp+L9OXrg8OIn85YzKATAVQcYVvzgU1VoqYwxbg/I5DhA0JNcxWN11qThte6jh4IoYG+LLuZtA3upmoIInja17omaqvnhoeM1bdsd09pAKOCKHekEI2DhYKMQVpSM8p7R5XB01c7Jwnx6Lh884z58Q9e3oD/f6oq8N5FajPyrsp7t9eOP3LcJUDzmnawC/cruVVGhESTW9UiYR565E+ea9yN0O5oY7Iuls/HnIueagRZMKGY3rrzViznH5Mz3HyYbi3Mb8uEojg/FU6AImjgFIiNnGwVuLcgCk1IBZrNRhL11SHW1iwvgH8iGFUpbOZ8sViCOzpbWHoECQyUmCJVwU2BvgqAkpY5YMfIJHjnvxdXu9FekfJRc9hcqiC2MkUWMkD+KY+k4Rr287McdSyWJghBx/8VEMpBofuqtwKZmH9J5gaJzLwIYA3Vcn1TDBRt03IcOHK/Un9dk+74hpI+EVHWCeHyTKzN7R8Bp7Mrwkz7ijcSNKydiGhjF1rZI618E+rtZOFAaDIdyRZ70jQIT99EecXUFJZyEl/CN+/8Hi9SdX5ZENj3gqo2gf0yE8QcfMMmJH8LN/z9/etOUpMowXXF3urACLiLMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199018)(478600001)(6666004)(6512007)(26005)(38100700002)(1076003)(186003)(6506007)(54906003)(6486002)(83380400001)(38350700002)(52116002)(41300700001)(2616005)(2906002)(86362001)(36756003)(4326008)(8676002)(6916009)(66476007)(66946007)(66556008)(316002)(44832011)(5660300002)(8936002)(7416002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UqfawYAKzkHPb5AmYnTqXSbQAOGQZrcUqH3JLG5FdYuAk0r0tbg9s2GScb1m?=
 =?us-ascii?Q?X4gFjjXpL7CqPSEU/shx19X+HdUJOS2YQQ0J+/boETC3D+1mUXyKGLldw5d0?=
 =?us-ascii?Q?IVGH0q4VStXKYMedryEuju0fuTCjFUADDr9sRgCq2MZPtr4tDWfmjBFdkkPq?=
 =?us-ascii?Q?e2Zg7gTUPxqyBV1nF5fc/Ydl1LJlZslTqZ8Usel0nbdV9U43ff/VPEy9N0t/?=
 =?us-ascii?Q?iGafBQRwcVrbu3cfdQJrgjxiAIwt7dJKlfprF8Kbzs98It0N741P1S5EOdaq?=
 =?us-ascii?Q?p45CG6FQANTrbWe4TSkfwOIjI/tCoJu1V5AFn//ZoK8YytYRUCrKWcuReAPl?=
 =?us-ascii?Q?pHom5iIun9zv/Z6m88UZ8S0TY/vhQ1TpdJ9L1EF+8r6DPrk0FABrhCpgbnHZ?=
 =?us-ascii?Q?gzMWAG7ZB6sWhUecBgzztb1cOvAlEFCiC6IuaL0Am76Ka6vu9Yq5niGQZL7d?=
 =?us-ascii?Q?oGu9lyjNq8Q9wvrRoHR0irsdzD78J/RjvSLAVfO8jYmzGGux1KbqR1HvwvSl?=
 =?us-ascii?Q?8uXJTcnMBVO+2FTJtOAO0hAKPjlBb0u/XLpiEsNdUV7cBu0Q9sxBoZz9p+yP?=
 =?us-ascii?Q?lb3mOYqsWB3KbU8FaRnVJgUjbtqi0+OdJGvcat5vtBbpWn/yIo9OVJtUVjGt?=
 =?us-ascii?Q?llOqbA7JrXnNPXbGXyG3ENldN8zJ8ORSrQ/Yd2EIpHW0SWxNYpiIlQTMmuLF?=
 =?us-ascii?Q?Nl7UlTMpvr55EgvbzkLwCcjQXZIhJmlkYNOCu1C9b1X84CepY/yl7a42173x?=
 =?us-ascii?Q?MZf2TfkVqq7lOif5kObydbD+D6fkJ/9p5GS2rSy7w8K3L5GK6doGdAwmxQJw?=
 =?us-ascii?Q?hfj9PEv+5dPEQXZUcxfgxiZKGb0xYMXq0hTcYnIF0oWa1MRWXNaqIznwjh+A?=
 =?us-ascii?Q?EdccAW1kP1uLQvvKpQaZw00RjtxKRhHML3tVmHQ0u2qT15/MinlhUiOBJsnq?=
 =?us-ascii?Q?jzRdgB+03bP4fG5XjZwqUSl+ok/GL1OVSXNCIAuMam+krYwp32kgranY+Pf6?=
 =?us-ascii?Q?SPtoII2ndW/1FaH1ETTxzqEZQLoxQsp7yrB0H5EG2t6abW8itZ85rg8Bf6l9?=
 =?us-ascii?Q?3Pw5/+ZSh3grnEwN+k5HnJPtB05jIyezB5C46xvrgQkdNlc/NYKWwBPq8w5k?=
 =?us-ascii?Q?F7o2oDxSWPqovT0DFacHGBMdzji5LGwjnH2H/wKelbflCuAvuSnioax+qk6Y?=
 =?us-ascii?Q?os5qwYTVNtadMs182T/SgKD6b8YVvP+wqV75O6fLSCbW8OPZARdu5EdRoMGT?=
 =?us-ascii?Q?vjxPaHv/iRD9HeDAutLgU/W30q5IB0+y5ebc3i375QeWMWqAWghccKPBxn8K?=
 =?us-ascii?Q?I/yYt50EmYZ9O9JSgadPfJO/XNC6txGxRs3T48MPpI8i85lxU3xVn87sEnSx?=
 =?us-ascii?Q?BvXmEhVGAPRkkb1im/l4lqGzH9Aj8zvsq26ab4XSptIbsupq4bBnmoOetov1?=
 =?us-ascii?Q?xL/VQhvZwIVJVsvY3TSwpsetGvm90kj7hFuODeMyxRULyQeiSB1pRo5kqPSr?=
 =?us-ascii?Q?Ya+rWgkMo3d9m1B56Bzn5GFX8lxvmzmAUYzc3/8IN12Bi/50imyH8+JGeelM?=
 =?us-ascii?Q?FS2Nph5IawK+ogfAk+HfGpyslK1S0mDt2a2FSI1XLYrViQk2JzHRqxa0pdWj?=
 =?us-ascii?Q?jQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c5b5a5e-bb09-4035-fc0d-08db0fa68768
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 22:46:51.6817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AjqdVoJKmSvENpp1v7TgpzKQ0cAIgR3T9OuJrzKJUOMYxG0AHUAVARqau/SYYkfzqJb9+r1BxXkdBiHb9XBMwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8748
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It makes no sense to keep randomly large max_sdu values, especially if
larger than the device's max_mtu. These are visible in "tc qdisc show".
Such a max_sdu is practically unlimited and will cause no packets for
that traffic class to be dropped on enqueue.

Just set max_sdu_dynamic to U32_MAX, which in the logic below causes
taprio to save a max_frm_len of U32_MAX and a max_sdu presented to user
space of 0 (unlimited).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 53ba4d6b0218..1f469861eae3 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -288,6 +288,8 @@ static void taprio_update_queue_max_sdu(struct taprio_sched *q,
 						    dev->hard_header_len + 1);
 			}
 			max_sdu_dynamic = max_frm_len - dev->hard_header_len;
+			if (max_sdu_dynamic > dev->max_mtu)
+				max_sdu_dynamic = U32_MAX;
 		}
 
 		max_sdu = min(max_sdu_dynamic, max_sdu_from_user);
-- 
2.34.1

