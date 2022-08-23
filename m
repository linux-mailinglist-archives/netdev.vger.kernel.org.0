Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A66859CCF0
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 02:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239027AbiHWAMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 20:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238990AbiHWALx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 20:11:53 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-cy1gcc01bn2102.outbound.protection.outlook.com [52.100.19.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFE357239;
        Mon, 22 Aug 2022 17:11:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRG26yB8p2FAwgkkLEw3LUwbZWegedEX4xadtXAyUzeObgHOmh7dgmc9Vzr7Rjk2lL+y/U+NXYUtuqI6VFm1cRnd8MTtsouqJ67PjyFGzTnGm1R7QdOups4I+QLNOdszIREVP4GRt58MThfZrtJ8sT+oO+iYJeInbKpVG2FV42DcHYvSpceb6ACUNH/D6QE6VRON3u42Vhk9wW8TEdnl6QsTUcP8jU+QbEDykYZ0KMRPQwXuyJe0p+dojl40gT5MAEjtgkhvBKingJ8MPhgf1Y6c62x7hHm9X/TGyLFx6/kljvVJ+AoonfjsX+tDozQ9yXRJo0nCXnAE6WspSG9oTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ax4Z8QmwAQ8cwH4bLDHV692v4k+bXZnEjQJP2AR4WEY=;
 b=cgLrqqN1qJOZYsh28EuZUx+22O5Id9iy986+R4p3FgTlm9HqaQNfSYiP54I5mnCyxK2+vt98+iEyy2JMS8PXBATpDrVKqZYKNihWBfmzJ6cA0OPY2H/RY4GJJjcQ7+p3rhkhRHRZp9WmSFqysX9r9ZxU4AphJ19w2Dm9d16loIhPTuUA4oPdIp4pY8YWJTxBNDG6f1miMHOs+T2AT6hXKTJ8Za9O1FSukx/c+BVq59PMhdgF7yXLxVgGLJxqEM6rTK5MqqQsjEbp5NFq8NnoLGJ/50f59HNWjf42tAKxpvBfNl73YyFCU1gPsMDtVeyC0cvBZHEC1Gqs0xj5iXIaog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ax4Z8QmwAQ8cwH4bLDHV692v4k+bXZnEjQJP2AR4WEY=;
 b=Zv+5xIhjaElydbhqOAD+WSdbaMmg4NwA3CEoCLyfl9xMn4EF+0OApSh1KLE1ShCpG+0dzWpciGRLY/dJBhc9NnzpaMuvpKF7QsfUKf+0NSO5PdenaYqzvPm9o05GqwqGboLO8qGyKam5mf0zkx4SFiekeWBSNYTguFNuzixOob0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by PA4P190MB1072.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Tue, 23 Aug
 2022 00:11:32 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5%4]) with mapi id 15.20.5546.021; Tue, 23 Aug 2022
 00:11:32 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v3 5/9] net: marvell: prestera: Add length macros for prestera_ip_addr
Date:   Tue, 23 Aug 2022 03:10:43 +0300
Message-Id: <20220823001047.24784-6-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
References: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::10) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9da65865-a0be-4a18-1f08-08da849c088a
X-MS-TrafficTypeDiagnostic: PA4P190MB1072:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:OSPM;SFS:(13230016)(4636009)(366004)(396003)(136003)(34036004)(39830400003)(346002)(376002)(38350700002)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(54906003)(6916009)(316002)(2906002)(8936002)(7416002)(44832011)(5660300002)(107886003)(6506007)(26005)(6512007)(52116002)(66574015)(1076003)(186003)(2616005)(6666004)(41300700001)(41320700001)(6486002)(508600001)(86362001)(36756003)(59833002);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?330UBYjpqcBFmMrga5YXgjwh9SyYJO8mNWiSFz35aosPXGwb+5+ioH7fnqY8?=
 =?us-ascii?Q?ZLcF1qICC1bXLPzrN5B0xmB7YKpm/zNKwMiu3WsuOvWm6n1beO3HP7nKM1/i?=
 =?us-ascii?Q?8MFi/DSuIbAEmqGSRYk5UH8a+FH/ZzJH2XNeWi7fgZOpsrE5+ByRa/YNaY7z?=
 =?us-ascii?Q?ItgR81gWynO3EgTLigCv5M9pi9j6yzXDH2RdmOgyNlXOHmT0yfSm1zEi54pc?=
 =?us-ascii?Q?Z3L99w6B1+DR7g83ghfPUg48yN00Lco4lYB1pUftvGXuEqX16b1NSBGlNZ5L?=
 =?us-ascii?Q?FjCRPBOy2kI/qrcNEoKNm8latemp4pzTwPMnv/9dZIXXQrA5oIqO7F2vi9eW?=
 =?us-ascii?Q?lJKfoFShjlF9iEE34klnqObr9P025x0uSawxak9uOIMMaczD8lN28d+x5qkE?=
 =?us-ascii?Q?XEfQCeGleuAjd1NqQkEk4Gtqs4RXbg+Rj1xyeeGMWs2UGD1zUnm0nGcN49Qy?=
 =?us-ascii?Q?nrZbWqMEdCX/DCE3sQod+HUPu0fujIzBSABNYZtGdT1j/Qn8zGdzYxseD0z7?=
 =?us-ascii?Q?HaHFFKUPavRHhu/uk7mb+N+1Of/TYzHnyRwfcSJj9D29pqilJZXNdi7k+/Gg?=
 =?us-ascii?Q?msJNzL+MCs05zv3TrBRcroozMhxoOVBn7sRVRAYvba/DugF1sVgexjgMhW+0?=
 =?us-ascii?Q?sb+DQb/nQ3XvD1vEFApbs++GPJOShCDvNVoYzUZ4OuYxv0DJ25XKvKMVTW4X?=
 =?us-ascii?Q?Z30F5s74sCyFoTSDCTanQ+wAHoxVcunpYF1cz+mNrDIXf/0ZXLOPsdw41yif?=
 =?us-ascii?Q?y1HIrTkvFxYTuIhzwm6M6SBduc0QXfLdWaM8Qc6qyNhZcq8AHVZx/5RZ9l93?=
 =?us-ascii?Q?UURRjbVGhvr1xmpuHe+OH6TrAnWLYhVzK3DqXvTACKFCnSdPDm9Q1hZFGGNF?=
 =?us-ascii?Q?GkfR9S/MKnS5AyZjnyJ6N2gJVoYRJ2MnyoddvApn7TQ0A3kCtICm4SNRSYSp?=
 =?us-ascii?Q?mcM365F1JnwW2ybNpe6CN9CmZLcidS+zisuwevonmIHcubupyEavCw6cQ5HW?=
 =?us-ascii?Q?4BkloZeZLjaG52PyeenJujEKn/Kxx3fFNH0wJOv0vhtwf2J9VoZzJW4+z8k2?=
 =?us-ascii?Q?DYWIp9qvYsV6SKSTWlfe5DymA4c2kbhiwWIcW+d2Sh1O/a9qkSreLcukBqDA?=
 =?us-ascii?Q?fM44SWasNQYh91CkvTzy4B3e4c9pchmCIF/AAH7SsASRFt3NoItgGCg=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y7ShZdOkOsRDXmwRWFKtc9WXMZgdP9RWjB4bRPgDfhaG7jX+zRrmEJfUGg0J?=
 =?us-ascii?Q?EZq6WZJckRegXpDKKZsEiP/2MO40m/yrAaqm/l72yAKMqwiK/XGnitGtN8xT?=
 =?us-ascii?Q?ZIMqyZ6iH2t+FysTzqHKCnWOsrMVBZTdJXUOFutnNI1foZ2RiYHdKYGZ77IR?=
 =?us-ascii?Q?mmwGqmKwFTvrnVy/19n2smLYU93tdumgzaiXkv6xtqSuART068hb4KYh2lvh?=
 =?us-ascii?Q?cVkQ9hhvXUNmE3H4cQw7Z4ZDLtIM/eUzkru6tys9RzC0kEftgioPqqfWwxcK?=
 =?us-ascii?Q?WKgxnjlUJlDIkrPYWdUJBI4z5V+ZJz9uXDDbJVaZkKP4yHk6Py/OBprkou06?=
 =?us-ascii?Q?8NZOIcFrOL5cLyJF984gELvQfeG5o0HDiC9vDw09ZQYZ3UMFJk8+CyOyeRMQ?=
 =?us-ascii?Q?GAVRhUS4MU360X3gJGt0Y2Esjxh7qGdkUOn171SH7TLCJYKP2MpDhfGK+1Ye?=
 =?us-ascii?Q?pNkwwOzxJbn2tyXTEZ0CJsK0X7WEwO5k7vEd8EwRonJrkEYdNi4BUWfi0Izh?=
 =?us-ascii?Q?606iiPvJMAbi63xX+lI9hy4iap/lGZAe8qNllR0naP9Av/5mchlEJVwVEOpN?=
 =?us-ascii?Q?RMf8+X9qMA4UxPrKbw4vKWPpTy5HjpjWpNZ5cPxwYUGaUxG14WkRwzRzi9xV?=
 =?us-ascii?Q?f78qc6Uxfx8I3ykK+Beb0XmPPJiSJ8YjKYoM6Y7tZy2D2uNtTbDKVlU0PGXI?=
 =?us-ascii?Q?x0fqA/WAqmpDfGF1AkMrBviMqL2zuOpcGd9eNWvLlU7U5HIXnnI71nGeWFbi?=
 =?us-ascii?Q?05UhiezZV1fsGKQ2lCkA1wVnt37QbgJ4s5iNzxyPAWiPZRdkJZGd2rK4ipis?=
 =?us-ascii?Q?ZMpgk0dZzOKluN6JJgUix/2ArsQwzbtXmV+5AAO1x2/L8LkCyc7cY4UgY+7C?=
 =?us-ascii?Q?kcyMF1sPpeyWBxKb90qN9xwbV/m47CyDBWlRXlU6J2uMV9f6fR0lo/QOZMcK?=
 =?us-ascii?Q?4qhx8Hqx3Yl6HWT7IDn9pAVx368I0uVRV5X4WVdb1Z3al1ME9tET+kp3khhS?=
 =?us-ascii?Q?loA/eEPs7jLzEA/2jzRcAIlQD0RI+QUeUjo8otQDfDSZl95r+BF/fOHEJ63c?=
 =?us-ascii?Q?wm6Jmj7wtpinFY9LnyFl0F036pBSsov6NaHIbPfYip6A2T5qu9zT5N5HIqY+?=
 =?us-ascii?Q?hT4SrhGhDboxhQnHbG97nYmryzolWOyEJmaQGHZRYK/u71UNZ1Y4IKK58dW0?=
 =?us-ascii?Q?8NOjWVTjnr64QwRLemuw1KOtvuY9RC5ljkGsbZIVvAPmgxx84GDjQwf9W7QS?=
 =?us-ascii?Q?JymVSNXUs7+FiDoOOpbV7J5/2oGyz9sKVjhyhdQDekIxQg2W4B7tSDy66sYv?=
 =?us-ascii?Q?N9bUH4aw5jeaRtm15WwvxeBYeV1SIFOylnUzqq/iShs1GTm3lp3eM+Qfg7GA?=
 =?us-ascii?Q?ti5FpNEFM6Y4Ddf1sydXEv1usCU+lMSEbD8/2/NDpLWoOL2uUIx92F37AtLj?=
 =?us-ascii?Q?B8Idu9dXD0ddIWiWgEZKR6kEtR7/vOpAH5CR3u/OKfee0hCJO+XOCmBweN8F?=
 =?us-ascii?Q?I/UTN7Cu0cbhflrhFd3hv212wdtAXI3vQ+Ujdeer4ojQOcQNpGyvpm7kHCtU?=
 =?us-ascii?Q?NiTvzgSiWSdU2/cIDJ6A68jMVHe2qh3Iok47m4y3bvReUI5+sRlWXZRRkN0U?=
 =?us-ascii?Q?fQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 9da65865-a0be-4a18-1f08-08da849c088a
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 00:11:32.0786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SRnY4/ZLKhCwct1gsbWxo7/0btuXgzg0jQoQgeUrVvXOlpfPeVVf/uHv4tUp13vjj0SJJTRZUSh3roZmzqT7DO07qq1ZqAF6VFaHPadITVs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4P190MB1072
X-Spam-Status: No, score=-0.6 required=5.0 tests=AXB_X_FF_SEZ_S,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add macros to determine IP address length (internal driver types).
This will be used in next patches for nexthops logic.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_router_hw.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
index 43bad23f38ec..9ca97919c863 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
@@ -31,6 +31,8 @@ struct prestera_ip_addr {
 		PRESTERA_IPV4 = 0,
 		PRESTERA_IPV6
 	} v;
+#define PRESTERA_IP_ADDR_PLEN(V) ((V) == PRESTERA_IPV4 ? 32 : \
+				  /* (V) == PRESTERA_IPV6 ? */ 128 /* : 0 */)
 };
 
 struct prestera_nh_neigh_key {
-- 
2.17.1

