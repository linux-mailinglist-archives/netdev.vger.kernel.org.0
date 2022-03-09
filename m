Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468D84D2EF9
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 13:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbiCIMVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 07:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbiCIMVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 07:21:40 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2082.outbound.protection.outlook.com [40.107.21.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118041768F5
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 04:20:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3Qchha7qn9tDJOL9e67qJJbbCLCTY1pVP7saBT8hnCEbENv1H/NA0CPctQ2x78PKRcM7Bz0UJLJ6WpqYCAv2prVDkpU/wx3jzelhsSVgOTT/gsuFuvqd+Vsr2fHa74KBGa/sSohtdqbpHXT9vISE0tB5WbdKMsFqwdqEkE17SkFRmTfnvRPtfnx8YuZFLkctt3O2fNpspAhVHlSsAAr7LHHeJ1SPZ8OJp6e9xPFZr8pq/roNS9NTAIQxqnNkD/n/n6BHxlc/zU40B5NLkzLhRJ7Lcw6mE4kJActTT4WK15DYhI+UAxkteFRYfBV3v0thDkvRzFkl9W2JyXu5ZWfVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q3V/3cOXyFKLR43Q4SFVon5FxBf43AFuTRaHaVZ/25Q=;
 b=Kjn8VpDveMsD6jRtBvA28oh1S3NMnaRYVQRdrYzwFQmkvhLYC4etEUoFpr93fqoX2TetB7JSWkDUJz4g8sMxwvxgk48zSKFZiwM6aR0mv4skJ80P/86T2swzLNTyZ6/8j2EsG5QLhi/8Rdt4R4xSDM8Cmzc+gqlsAVzF2WOYwgmNiPLyBMrQbFlRqvxyFiPZq2AS/fG7WjcjlgJ0+l8wYr0CrkLRGbCW4Mo+aSl5frCGF2s1qfr5iuUUJlDM+r1n3l2HhQzgLhN06wpk/iEytvwqNj0i+uKpFPo/Q/79Y469CDutNRvvi424HztIs/NksLF7okpgTP9+UaCGTh3J1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q3V/3cOXyFKLR43Q4SFVon5FxBf43AFuTRaHaVZ/25Q=;
 b=IQUb5mLsj9oqWHcRtKGFcBZGd7YtGF6fjtOauq/nkaZgszIl1NbUPSJkCGTwDsD1xS5/hpyqrxUERKlFt2GSas9uwUZsewCr0yx15WFOxmCoKjMav4Fcb1unVLVSL92QgtKBtW1C4mVX9nKT23oQveoKVCaGLHKuHDULd4nk6qc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4598.eurprd04.prod.outlook.com (2603:10a6:20b:26::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Wed, 9 Mar
 2022 12:20:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 12:20:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next] net: tcp: fix shim definition of tcp_inbound_md5_hash
Date:   Wed,  9 Mar 2022 14:20:12 +0200
Message-Id: <20220309122012.668986-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0302CA0010.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09ac6341-9ba2-4525-49e2-08da01c7360d
X-MS-TrafficTypeDiagnostic: AM6PR04MB4598:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB45989CBDFE173F4446109FABE00A9@AM6PR04MB4598.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XUDCbP8Wnco6rmtZsW03T/QkZ4dc2ufnsz8LyQUkV7rAdMY9gPHA8i1OxY6y+gFUcLY3KEQmx3yp9gYMzepBSwePZLKcR8LvrY85qxoxtN/3Jm+1VKmaLM7JBUGzD98BtGmFj5MQZ1A6GKDTUSQ4Pe1E51okyTHRm+O9OKylxgV4DzkX3ZiCESW2/eTVJn7tTVgjA5EORVGUt7B8EXEZlz9iDrCl7a4qvxYI1ILnIbnnB/MVfSCvzLWMlyxz2C6Bq8X/SMn9ov0NEpcvTOq2+ZNeqJ3fXdIw6V3l4L01t2+XzXkPGtECiliT5FUrEM2JD6Jel8zvzZDbpEUUEMvBt/sp4nAWXEEmwlUNQ7e6WbLDjx2x3gRJyfV8PEM6PMHt06CL8QUVWvIc7J9IZ3RM4ifLmjtn+mtoDzQBnl7RZ5kYYgtayJdNW2U/YMZvxDJats9F9acN4p/2exLi/lXRFvMndYw+j+MClO9t2priNapKBzYzZYO3/6mDnOiO0ZDco6S2lCaY4j7TvX5WTHUQcCYr8viSwy+OnaaxszyQHpqFHBr6xn5Ohi9/CjfWcG6Udc7cnIvWh+F2LgNOZgXV3PPQNxVhTtbYuuHaEqmYxvFnaEu/DYAxKs/S4iGhwbi/6gZA2a9vfnz1uqW3WpB3aNU1Zc5eM3DSZ9vkTAWDq+kzNAC0ZWfP1V2RzDKs3u3pcdoEbShCbZFfuY6hQMEikg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66946007)(8676002)(66476007)(8936002)(4744005)(6486002)(44832011)(5660300002)(2616005)(1076003)(186003)(6506007)(6512007)(26005)(36756003)(83380400001)(2906002)(6666004)(52116002)(4326008)(86362001)(38350700002)(38100700002)(54906003)(498600001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?44OhM+/vR/SEgiK62W76IlK4UVtvv0W+926LvwOETcTDCnvXoeeXvY+UHMCU?=
 =?us-ascii?Q?71l7LoHUtNGocUcK08iu3eyXGc+TpS1SKqxEgfdB8xK0NmdZ0jb8BGEv41lf?=
 =?us-ascii?Q?3mNvboz0smh1b6gOzBAjU/1kQE2vdwV62nKvBXxtP3U/FyUsmnd3KDya8GUG?=
 =?us-ascii?Q?RFMw9svBvNdji11lTwqxVoRO9w7pbQW3QTujTWxS24kLgl0MfOZ+22f7kV21?=
 =?us-ascii?Q?ezR2Og2y22DmDrJFxhD01VkfFYEbNcDdM9Vwog9gTDHY1SMaGGzhRATUzOQv?=
 =?us-ascii?Q?VbxpOTDioQX4Jez415chcqJBCa4CaRT/9l/rWimFGrOawH7oGAr4XjGvmXPX?=
 =?us-ascii?Q?OHetXY3aOkYNub9fVU67PaJiBlv63eojtWIvjLXLz0q+mekRuTq3cL3mqLlk?=
 =?us-ascii?Q?yT+jYNSwVnDjGxzLtLPyqWCSfUeAHH/mD0BN7EhWx0Th3ew0UHWJ4IdwGv1s?=
 =?us-ascii?Q?p4Fa3AYidB2mD6LGZKflgf2Ypkrqd1T6vCx7KGEEUJqZbijjsGOODQnf2Z8C?=
 =?us-ascii?Q?M815zcvLvck9/ekeWXrWHTDbGb9/B8kfATVOMbYZhi24keDQDc1U2/J7BVF3?=
 =?us-ascii?Q?hBFDjHWyRnpS/XE1JgGh5KPsI04B1d4JE0r2Z3sh6qoZl12BshlEmRiU9qdD?=
 =?us-ascii?Q?Wwhv+MTUYDrZutCqaGqkzfIZktzB3wXEE7ornM+DpSkLFhCBmhhmCWlMTHWJ?=
 =?us-ascii?Q?11dE8JihMdMI2pVgOi9BmiQEj6LB8/Va/GHgrUpLYJdKsbr+dQ81ioaSrvle?=
 =?us-ascii?Q?cSgSpwHnida5ZK8qs7LCmOKkx+3pa7LrHyX2EIIwKb/8ZELeaO4nz96pixQk?=
 =?us-ascii?Q?IYr4GScO/0hswRxPlZego2w+dG+bpDq90ZiA5X0XHVos9+1pduL+k26m/mrQ?=
 =?us-ascii?Q?oks2nlRJRTg8oaqqigCi1qSBtzLHNy2O1/Cqg3icV76jIGgGmVB9kblyMNbI?=
 =?us-ascii?Q?ExL018ueoRFsl+0zZIfdIS1itOvpngHUGhFDKqF0I2KbamIqEoMQqidJKiPz?=
 =?us-ascii?Q?tBvONKSlCAiG3RqUFPnsDMqhWpaPMOj/bcImSoKeYK9O0RGZdmhho9NQAdMl?=
 =?us-ascii?Q?lomwMGyFH4qMXESXUNK18GfuDaloD9YxPZP5fK13nDjDYg0OfFQdsGOvlXVk?=
 =?us-ascii?Q?uCRdkCOXp+a1Cgvg5P+hd9yoMMUV/dSZDkGq4M1jm4T++HG+v+xPQ+brrZdM?=
 =?us-ascii?Q?tL+hVI3V0pM2bhBvICe518cZbMEPzThAkij0VYqPWAeTjpT/GmuXH0S+Dark?=
 =?us-ascii?Q?KGL1Pld54+joI8oNN9glgBWabL/DibKptCUiGBYia22MRIYrAgGOXdyrGdBm?=
 =?us-ascii?Q?W/sm6H6KEnBZnp88AKPTmd4nS6j+iOCB5auwRV2iLVzkUSfvUSC+94u7A4ci?=
 =?us-ascii?Q?bfHmDLpnDafU23HywKNYw6fJQXAHnAhpqdwm1qpqxYJ63SUJNKvxkmX7Fzg0?=
 =?us-ascii?Q?TVdzvJlrOxAgs7c1yROJk66+IHYMVTzPF7i54OG5bopuUHBakN1VgRxY4tIG?=
 =?us-ascii?Q?MNCheV3pwxi+zfukTcMdkzEbUW11v/2W+lx8FaON0xMhCrWGgtforewmiyRl?=
 =?us-ascii?Q?hRlPUqL9vvjsbQAe1fpwGweHikDxM3i13sI7aqYfenGLs6cag1T9bmSG+lph?=
 =?us-ascii?Q?e+h7EJ31Q6fAliIEBxF1mEw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09ac6341-9ba2-4525-49e2-08da01c7360d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 12:20:34.5337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EoTGtHIBcfttv0ynVhJyU469KNPH5OIn4uwwPnueeSPO98XpCoG+rj4dz5s8kCe1poYp7FBZpxElgTQ2z++aKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4598
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_TCP_MD5SIG isn't enabled, there is a compilation bug due to
the fact that the static inline definition of tcp_inbound_md5_hash() has
an unexpected semicolon. Remove it.

Fixes: 1330b6ef3313 ("skb: make drop reason booleanable")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/tcp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index ee8237b58e1d..70ca4a5e330a 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1693,7 +1693,7 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
 static inline enum skb_drop_reason
 tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 		     const void *saddr, const void *daddr,
-		     int family, int dif, int sdif);
+		     int family, int dif, int sdif)
 {
 	return SKB_NOT_DROPPED_YET;
 }
-- 
2.25.1

