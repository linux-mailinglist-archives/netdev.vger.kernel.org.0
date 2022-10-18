Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E14602E33
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiJROUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiJROT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:19:58 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20605.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::605])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9014222B39;
        Tue, 18 Oct 2022 07:19:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9zrAgDsmF27QDnRvAHii54Xv5OXMPygWJde86jxaMNodONUncZqR9Nhz/C6EUgEBpxhFuPxOFTQAgT//hjmYG59ZF6thyEdaDaHXM7Ir36V4/fyf4iQgICT8yTbBKiwnMA+zBD6pTxssTZb3iKN56DXuZ7uf5kyS7tjYAntr7lWNxZ3GiUe7z6ZnxLMg5De91pPqAgFyiKD9h6SL4VSVtgFvSnDNidw02yG+ztdMJaGp3iEfHYo2Fni+/ipGJcc56n/HpModkul2M7uxdqROkCiIGmjpr8/UST4y4tjojMXsYKWSoiS/a2I2eJNQx/a6AmiEx7cmduXxmOzU/zmTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gsG1Sw3gLvG4flE++zuXG1IeA9BPuSQ4EoxZ8IQYM98=;
 b=XuEnW6ROB5XLQKCOPOkcCzUVIZEvajYlXd+8NREJCkdj1KJxVjqc1n38ClRn5CLD/J/lPhEu1GhXHbfFudJjJo9GBUXB8ChQeNn3/o68oFmDYcpvnIIz/tAHPIGqgpPoj0VXA46RczPt9H/yNDWL3exJQiywPVZkL87w7KibE87yGYK4cxX0q0E11Jocjm9vO3gt3WVauMNinkq1r+XyermNB1CCpOqj3QIisHOB+DUntahxZFH1xQeTDOErU1B5gOd+33QAUOBuHwGlasWWdnouQTgtl2a0RM3kqM0UBpJlRmYx7MNxSyYmPyIO/igYChf7fgUGu7aQ5XRFZj8Low==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gsG1Sw3gLvG4flE++zuXG1IeA9BPuSQ4EoxZ8IQYM98=;
 b=VZSlhD7cODlcmzINzTlpzT2rlX7lBzzqwz8ow2R5FgTut3fwf7Wm3xzo9Wdl6xiRWGvMCY5+2I6aRnEINZ+7dOWDzhYj6WtRCrhQc3ORCTP4+YnHXHZ+PNWkPsQ65iZiP+8OovzEmrY4oNU27de+IGq+Jjli7ri8ue+HbQ0XJMU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8706.eurprd04.prod.outlook.com (2603:10a6:20b:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 14:19:33 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 14:19:33 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v3 04/12] net: dpaa2-eth: export the CH#<index> in the 'ch_stats' debug file
Date:   Tue, 18 Oct 2022 17:18:53 +0300
Message-Id: <20221018141901.147965-5-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221018141901.147965-1-ioana.ciornei@nxp.com>
References: <20221018141901.147965-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0002.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::19) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8706:EE_
X-MS-Office365-Filtering-Correlation-Id: 41a93ce7-b9b3-408a-bad8-08dab113c72e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a5oSWgibWc9eZV2CgC0RCGdCuhqvafdJPgAnga/J7KlHf3om6w2REH1pfGXyrZYb0RXJt9r7Xrr/ZNfZTCVZZHxW/eATCQCBGJm7lWZnPzlBh5x/w/G3M3hz6YAGUMQj9zCTrhvoZw/xMOGX14ETXOolVYhKNwfuNqQIUd1LJTvwcvWGIRUxeMMLugDBUewkpHI7btu3EbSvke/2Qvuf6hGMKYOrh4p8CYzAq4D4FUmYpiEyEj+zYGsIk0dWtdsIu+pnbSACsmuVHENCS5OOYeX8YXd2ZIz7CwYRLDfZXSooZy+yvCUJ018Huro00ae6eLavkqxSt88pS2Mea0+ElQCH7y8mwWGr4K3858OOB7ukTiXXMG/5eRD3Pw0033s56+Ne/cTfc1ZCdYaBt0cwc5TpgFio20om9IiMA/fnQVZljFsa8HXB1se8GGE3/sDVA0uoUuPztSZJmswtRHlvxqoBZvmI/bvBhxVT5TWdV2LLMePP8aSan1lsOKmdLqmnjCyGUdh8hobVgEahkkDa6v5jiU24xxf3Pf+QOBazyUTvSJAquwahWE4VIoovaKed/CDkM7OHyiOxNPGVp5Fr/uGkYtDA57HtMLKF+qAbZ+5AoRf6cx0xo9fLt8Ug8FFTCMz8gynf6n4jf0rkSAnKxzyvMtPPdt67W9a+yNnjjYaMwCy0l99LzDMtKEYr/byvEXXhT/GghDk2B53qw0vGji5yzpYPAaSyPYaWHC3XB3VWZvc6vAHzS2n5os40LOdigkvgKmP3egCgkqG07NwJmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199015)(36756003)(86362001)(7416002)(5660300002)(44832011)(38100700002)(2906002)(38350700002)(186003)(2616005)(1076003)(83380400001)(26005)(6506007)(316002)(478600001)(6486002)(110136005)(54906003)(6512007)(41300700001)(66476007)(66556008)(66946007)(52116002)(4326008)(8936002)(6666004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?geEjKvqL0JSDnlLeu+UV1If+ymc1WvB1CEVkxX33yzp5zsc0x22LLbkUOkkW?=
 =?us-ascii?Q?7Se38X0TtOi+Ixbn6YNLwP7eLbLRFOcQD9lgFxmvPzMlQKLM6++RnAKZrsjc?=
 =?us-ascii?Q?B/jU/lggUI+QFxosM/dOV0nkYd6KoN6C8OixFvAUfgLDKRWRJKmegjT0ySo2?=
 =?us-ascii?Q?enoBBKgq/+aUckQn+wJbZWjmQQuCcggiJnmS2Yb4tRx0G/oj8ETfUCBqQF+b?=
 =?us-ascii?Q?jkXyAKr9zPbfhrp1PGcAmI7REYgbbMyMPNsk9sNujOz1c6rvqqVErE3XSfSX?=
 =?us-ascii?Q?D50lmWzakfebOl3uSvFmBDETZAviqQSiwRHJc8B9uL2C0QDSa10uhQ+usdIs?=
 =?us-ascii?Q?vKsrAibENYT+I+zez8Nd/FadAtIyEiSS60SpqDuaK/5BJFiZuxaIcK6jwJEm?=
 =?us-ascii?Q?du3CGxLcNVMSUDnp52dvffRhnCw4uLnwHd9A2USlYev2xQ8bG9rWQJdr21/s?=
 =?us-ascii?Q?A/D6xx611RrJhTFFLrfHmylQ0781WC8n2es0bxFAIgDSP0XGEURJUV60AZJW?=
 =?us-ascii?Q?udmOD2N//0DHEE/HFwLxOWxyYDQKTtg8enf222diFgNfe+oUeatue2ZfrYof?=
 =?us-ascii?Q?7CC6FvUIWiODolM1v2CsQa0D6mNbQ35MJSTASKyCHsKsmB8FdRj+QWXV2PNy?=
 =?us-ascii?Q?hUYw3rKzJmwaYGBXLHD+mMK/JPwz2+QCqWkzeLW4drQ6twPDaMBy3kwMFR0Y?=
 =?us-ascii?Q?7rgpbZVrYJCo4QOsC876y62qQ3IHsisnvFuZX0ti+pH99WS1JyMqbltbguDl?=
 =?us-ascii?Q?p873BSzFcdp7iyZiCNVvTWWy8FVjgzhTVqRYEsFgtgBgJ8gKO4SkdFVe2Sf6?=
 =?us-ascii?Q?DSH3OXd/wOB7dQGCW/oSAVrJpiIhh/k28uktfUoMWN94CSD/T5E/BQ1DTxEA?=
 =?us-ascii?Q?2Y2LDc6RYlhYAyy2M637ggIkPmAb6j3iDw0MV+5i3m/v2qDLehH8WHRmFuGa?=
 =?us-ascii?Q?mHrxcMq2FOMQWN7rO6/ZbYIqU6uzbF8wWTHcFgIbBFaqzh2/NRBTl6StWbqx?=
 =?us-ascii?Q?quaUwLtUGIhOsNEqx3l99K95Gz5eis8BCLuIuDtiGon9Ze9hF+/2qPyqj1wj?=
 =?us-ascii?Q?Are5epUm6HxFfn7y3ZQ46WaTqhRCp+MjU8lcwy5Zt8YooqPr6dNXjYePTp9l?=
 =?us-ascii?Q?eQvwe7kcZzcUr9Dv5tstzG/cetozU6qMC0hodNIJk5/QiRmRsotyVp67MXQd?=
 =?us-ascii?Q?9371ft/mR8nywC2BDKcOLkeoboD3SM3cPz6O2sgnpcvnuaMd6+6zVpvM+L7k?=
 =?us-ascii?Q?512DVxCjrXNwKRd/DMFgeyqqR75a6EmtR6yzJYUJS2oL03j08mr8jbq5WaEj?=
 =?us-ascii?Q?2Hdounf0/DyB4rlWdurNiLucjqjzBw3xUE18ieohDHaeGfDRN6NyGaQEWdiG?=
 =?us-ascii?Q?rQ00s0KfNexw6jf7eJmTEOQZtzklgQKP37tw9dVWUy9JCTS4W1oLCiM2Aobt?=
 =?us-ascii?Q?2G7ixVMg/Nhv93fwtOity+Pjy1psuqX6/BTVFUO8MqRZkWWZIT+E+5EYd27f?=
 =?us-ascii?Q?k2FYgd3dvvyKwgeAkBTzAb//fBM34JIXdClXrXRIjCM/YLLEIaf9/7tycLvb?=
 =?us-ascii?Q?6XFO4cmBIYz0D7fjq9UAgFiFVr6cYqnt60n3Z6h+?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41a93ce7-b9b3-408a-bad8-08dab113c72e
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:19:33.2459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YpmSyav4XenN1GRyTu6HU3+IzRXbjvm1u+3GnMTOrdCcEhxEeJP2JWuiIdRA/+jx9YH7iUKQ+ycl7vc58zuqgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8706
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just give out an index for each channel that we export into the debug
file in the form of CH#<index>. This is purely to help corelate each
channel information from one debugfs file to another one.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none
Changes in v3:
 - none


 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index 8356af4631fd..54e7fcf95c89 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -98,14 +98,14 @@ static int dpaa2_dbg_ch_show(struct seq_file *file, void *offset)
 	int i;
 
 	seq_printf(file, "Channel stats for %s:\n", priv->net_dev->name);
-	seq_printf(file, "%s%16s%16s%16s%16s%16s%16s\n",
-		   "CHID", "CPU", "Deq busy", "Frames", "CDANs",
+	seq_printf(file, "%s  %5s%16s%16s%16s%16s%16s%16s\n",
+		   "IDX", "CHID", "CPU", "Deq busy", "Frames", "CDANs",
 		   "Avg Frm/CDAN", "Buf count");
 
 	for (i = 0; i < priv->num_channels; i++) {
 		ch = priv->channel[i];
-		seq_printf(file, "%4d%16d%16llu%16llu%16llu%16llu%16d\n",
-			   ch->ch_id,
+		seq_printf(file, "%3s%d%6d%16d%16llu%16llu%16llu%16llu%16d\n",
+			   "CH#", i, ch->ch_id,
 			   ch->nctx.desired_cpu,
 			   ch->stats.dequeue_portal_busy,
 			   ch->stats.frames,
-- 
2.25.1

