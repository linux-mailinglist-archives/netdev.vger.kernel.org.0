Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0812068B992
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjBFKKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjBFKJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:09:27 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2076.outbound.protection.outlook.com [40.107.20.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E940616313;
        Mon,  6 Feb 2023 02:09:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QP36J9PAqdgiLNys2mwO4JXww+Viv8vCuVobQbSzCu9n0tru0lVoAk+88vEzZwbH+Olndc4kroPKsDfMxKpkP1g548NmSs92qi2aJU5PwdvRH6jRNQtKxiuHuz9AaOywr1wXqWOqBl7r+R/UUrQBBlp0F5qCww9Pc8cfhYEJT7KuBbe3eRGMQlU7upSrIxnw265TX9AG5rRxaQcRzQ/M0rymV193LLk0zIoc4cUVOA4EGJa4UHFpsAE4zZ15fj9wT4G1EhsGtC61S5z2//HCIYvQJpkKtaQOfGsonRLOhrRTkWC+9UvAYwwSwOMGEvlk6ZzJ5zMwwuI2Rwyk7DUOww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6HX8adyx/UjrtrUQWVrKO7Rm2DDjXOlzD+nWeVmVxg0=;
 b=Th3qC3dZOAjCuWuNhVuW9dcjRZShqVbM2CrIuCFtjwJrnkD0nOyVodw+x9nQD4Ck5vjnpmM88L5jgLycQQ4yxqBXgFL5SDefhiVgW1nRYSS4yzJWDxr121fJmLaR6aKX0b2knKT3xhInhhWm4BU1vtuND7Fu4H7gd76UPoP3zftC1Im1jowRx6aNC3WXbW7n1WVWFpiU9NL8+H7vZ6n0aRYjSO9kO7MmDEptFVBJTaHQKXQs5N9NJILsIKZAsgf50qzFXb8pey3W7Z6wYy92L7lS4oqRbRUBiUzzekJ8f6JVVmhtJUqcViJUcrhhkoJwMX5JdRB3YZa/2PZJ90bgKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6HX8adyx/UjrtrUQWVrKO7Rm2DDjXOlzD+nWeVmVxg0=;
 b=TchqRMroc978EAtcMPY46z0LQWlIhBHEMnGfzQNFlqZrJHX3ETKFEJGuB2o+PXLYRM4JfbhUCuNMls1G2PTGUVck52ri4fG36bm3pCwl7xP9RxloGTaqRWnng2LDn3HTw3JVHBde1Q/BdevaZX2KqKKLtI9gu156+2ba+4DwAP4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7735.eurprd04.prod.outlook.com (2603:10a6:20b:2a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 10:09:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 10:09:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next 08/11] net: enetc: increment rx_byte_cnt for XDP data path
Date:   Mon,  6 Feb 2023 12:08:34 +0200
Message-Id: <20230206100837.451300-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230206100837.451300-1-vladimir.oltean@nxp.com>
References: <20230206100837.451300-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0019.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7735:EE_
X-MS-Office365-Filtering-Correlation-Id: af5c78fa-d000-4a21-9c92-08db082a30cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8+zJZ1QlQ2OH+hACfirICRvzooZFDhz3okMqBHVpFncf/3xL8mQfJzKJiBBmJII12TKEAakJjJkdS0xWeWOYoRtJrlAvPIDXlVwggnaIYJdm9oix/9KQanuhneYlEa3bU1TWwsbxBW0t28xFyX0bCpNfGgRAqxdFuVjibRu3MPU39bEDg3obnqrakJ6wMYTx0fq8+BgT5LP4BPaRJvSxck/aru1+ivq5hoRAkoiIPH/XAf1JSlmz4U8ojwVSOv62iFGAYTetJLNYawMvX4jv6JUmKx4beUd5TJHZS2kPtXS6uZR9o4PeolcHbtmxeOQRtXENJ1gDHhdOybOu73VN6vONJYrziSFmZ2cky+BDRxZTDhXQ6iB6y+6jkVHYqFpEI2sAFkPopAII5cb4AUzdxEYMfVOTiEDYlqQ0zvh+cTw4Ovv7HTnk/aocmWFkZyUt76CYmVTTB/p58l3q40u5inbId+ewvluW89P4lg9BMDhe3/MpN5rh+ptFho58vFeJO526AjanRwIF2Jc4V8WFC22FKucC+rKZVfXFjqjJ5Ykh2w3e7OmSh4UGVejA7AnQCiY/2z5Q32y+YFgKHsePBSg3ZuoIisfdIgEAPDKwboGKq15NjcVp5SwSeA2hwG5SxDur1d8mPfTzH4V2aUYDNj13b1OzuxaabyFJyAU1w9zEGSW8VBfFzf8/rFTc39LvWqSBmI76ep+41pOnULMAVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(451199018)(86362001)(36756003)(38100700002)(38350700002)(66946007)(66556008)(4326008)(6916009)(41300700001)(8936002)(8676002)(7416002)(5660300002)(54906003)(66476007)(2906002)(44832011)(2616005)(83380400001)(478600001)(6486002)(186003)(52116002)(6512007)(26005)(316002)(6506007)(6666004)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uziW7g463TYMk/bNb0TDAEJm9xVQoW6+vzbhHKlm/CKSjdEboiFrRUBVRgAH?=
 =?us-ascii?Q?6vjiBtHklID7pxjrIm67dNOMnO4x9FAdzUIaRSwh3sZzYRDHR1gWGQuKfcKm?=
 =?us-ascii?Q?aGySuDqzI08jOT8n3S7g/x5UvMhbcQiKLShvPLhSTuzp2elREvk1rhiAtBiu?=
 =?us-ascii?Q?PAnktOGheU7LMunVusGZINozxTiclA+dhdzVC0ICqi+bQs4rVo6uIq3URUxY?=
 =?us-ascii?Q?4YL7Ykg75zxRlXUuOjLuzhQYXkvO5Fe1vRghOnUyQPvwnv4shv+IdxHQKECg?=
 =?us-ascii?Q?RJWRXmLGX/59RuwvDEARxIwKl090Ci3uG8ArtoWSZ/6rTBAUnSLMSwW84qTH?=
 =?us-ascii?Q?3ld0Tca6zwc6Htn/TrMdxP0pIhZMbqQhepxMbUsQRjRe8CeXxM+taB9cDN95?=
 =?us-ascii?Q?iw+XfsLsMbE47YNogp3d4jw/aM3Re6+90/FheSXf93WtojcLa8llXqeyiIyP?=
 =?us-ascii?Q?JXRv4OaESEI8I8gz7LoO9q9AzDX/gVMPI10CepfXxa4scFgdGgIqSesy/sC4?=
 =?us-ascii?Q?eT78HiOSKwDlVsjTPHK55DjFFzBt90yaBu0g0cU5UYBzciIyJdzwLl9YFRB+?=
 =?us-ascii?Q?UnQRyhCvWb4nZbFuPIjjPabgpW0lGgUQfJme5uxgSN4oLn/BmcgNe8xDs2Bk?=
 =?us-ascii?Q?YbiFkAymCQCAtpaX56X1d0Mdb90LXcEtcx0rXs6uqUJXA/6a+yP4eqR+98XS?=
 =?us-ascii?Q?CLhhMUYTC8IaxFjcPn1fVpKvcJUiD0SSi5z8cCBiWDVy/+r29wpPK08FmFzM?=
 =?us-ascii?Q?JT0G3cHuBadJ8f1MuUong7WxmfHouEnGrq3XXiIgtfwm5RA8YeNMvsebv/P9?=
 =?us-ascii?Q?3rFWspJsaylyXZHN4P0X5GBALjkkSgTgGl2g+w16UBjhwXK7Tauc80fvh30x?=
 =?us-ascii?Q?xdu5kuWARHJ6dU8k50FfHnfC0tRMGYob31rpY0nMwhdH0KgU7DpAwKk65mj/?=
 =?us-ascii?Q?ryuaA3lVOQpsiwkyTMNGG6zLaoQ1Gu+EwDNsWzJzg0zh+mhCXS4CaozSN6Ce?=
 =?us-ascii?Q?zJeF4v0mCiJ70rsn/5A+NNCiX/9wWSlblHMkB7t8MBEji07Bu5D0V0YNvYhV?=
 =?us-ascii?Q?s0dZ3LOSLYs82Ec/5An6+cj1Crnyi+ImYpTBxLEmB/P5PUfAEipzMcV3T3UC?=
 =?us-ascii?Q?UZOWStglkCFj7biqnRp17ileoYL1SAz6vg87GSI05FhBBKkszN7QhCZJB+4D?=
 =?us-ascii?Q?5xeBUJqrwRM3RbmdFUfMGXmCrdmLunEply1FDqzJ4H43H/keyujwE7dtOr7i?=
 =?us-ascii?Q?14Ewd2Oz7RdSMNiWNaaxAjTvlJPwlVgO/tOTWj8sc0spo625WR0EH2unwMtj?=
 =?us-ascii?Q?FFg2KjiB4BS6aiuX1QEFhxJhB4lO7zi/3qfoN3UV6IKQJzpfx49/2oSGee0X?=
 =?us-ascii?Q?lptHXGXBYuy33g4OJoNJR74YOi3wGhBUpqDmpPILGcd9cftZxgtmcsevGZDw?=
 =?us-ascii?Q?rTfpS4whG6cILvdk9WLEVVW68j6S6/XMViHdXk4r8AeWjRcuJ24qB6ImHKen?=
 =?us-ascii?Q?KsKU23iEy0SD1Tl7Mz42eLhH9ifoqlHwZfEraFufnTYbaqO7vpvLBHlRcQqB?=
 =?us-ascii?Q?submiwj5jdljg6mjP+DtiYtHi6ben/xPiCvsfScSNxIslXFcwPkpj+FvxTtQ?=
 =?us-ascii?Q?pA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af5c78fa-d000-4a21-9c92-08db082a30cd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 10:09:10.5518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /wBWapCzUu+UfS/NPDKOAko4UyOd67Vjcl+Jx3XHhAN3QZSlK8zM5aM0UcspF0os1TwJsy9BSLtV5mpz7PTDlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7735
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v->rx_ring.stats.bytes is apparently only used for interrupt coalescing,
not for printing to ethtool -S. I am unable to find a functional problem
caused by the lack of updating this counter, but it is updated from the
stack NAPI poll routine, so update it from the XDP one too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index fe6a3a531a0a..e4552acf762c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1461,7 +1461,8 @@ static void enetc_add_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
 
 static void enetc_build_xdp_buff(struct enetc_bdr *rx_ring, u32 bd_status,
 				 union enetc_rx_bd **rxbd, int *i,
-				 int *buffs_missing, struct xdp_buff *xdp_buff)
+				 int *buffs_missing, struct xdp_buff *xdp_buff,
+				 int *rx_byte_cnt)
 {
 	u16 size = le16_to_cpu((*rxbd)->r.buf_len);
 
@@ -1469,6 +1470,7 @@ static void enetc_build_xdp_buff(struct enetc_bdr *rx_ring, u32 bd_status,
 
 	enetc_map_rx_buff_to_xdp(rx_ring, *i, xdp_buff, size);
 	(*buffs_missing)++;
+	(*rx_byte_cnt) += size;
 	enetc_rxbd_next(rx_ring, rxbd, i);
 
 	/* not last BD in frame? */
@@ -1483,6 +1485,7 @@ static void enetc_build_xdp_buff(struct enetc_bdr *rx_ring, u32 bd_status,
 
 		enetc_add_rx_buff_to_xdp(rx_ring, *i, size, xdp_buff);
 		(*buffs_missing)++;
+		(*rx_byte_cnt) += size;
 		enetc_rxbd_next(rx_ring, rxbd, i);
 	}
 }
@@ -1571,7 +1574,7 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 		orig_i = i;
 
 		enetc_build_xdp_buff(rx_ring, bd_status, &rxbd, &i,
-				     &buffs_missing, &xdp_buff);
+				     &buffs_missing, &xdp_buff, &rx_byte_cnt);
 
 		xdp_act = bpf_prog_run_xdp(prog, &xdp_buff);
 
-- 
2.34.1

