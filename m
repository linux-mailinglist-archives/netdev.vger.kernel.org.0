Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95FEF4BB5C4
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 10:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbiBRJkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 04:40:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbiBRJkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 04:40:35 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60139.outbound.protection.outlook.com [40.107.6.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FB1151C6A;
        Fri, 18 Feb 2022 01:40:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGUAGRIa6gfPodB1WLDiwDE/WMh4xYQWFzZSoonwrkq4eYo7/rtoXgRGqxBjRYXJeWFxpWSmw2KimtODfFb3tcXoH3C1oAofcISX/y56ghxaH6pzn2RQ0rQf2rI/epOvOTmWWisL5yMJMvqI4Ve+WSycLk5Nsm4d6nWM5pFl03n6yYw1rdQ7MO+ccIzmxBDqFfcOvejUQiV+bXZbgSMKVy4hAoDW9p6qoTv2E5AE2wa6JdXFiemDB/YYJ3vI/2oSdfNdOFXz3z5R5V7V6WGtDuSEMcXVlfWaD4RJcsmNAgEjF65Zz3F/D/7hRekTjp2xbrlfvAJuIWkmwnQnh+wTMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g74Od77Be3VMm2wcJ42Ta59A9o9m44sL0dCWnHo2qds=;
 b=BECygGzimZ8p1BBXMOQGRtwu8w8RxUH/7Mfl0fzjyiqIP0daxXi5bWdATgRXS0iO1GKEzsW0I1WEcR7BaYPnLWAx1maB0HXm37wm+ea/zg2mP4k8eVFCkfv7vGg7Dnjn365T+kyhwj+daVf/tHEihg1msr9so20nLDXVcstyiCGgVrNAhBVjjv76DtTGLdooEqgPeTVIlzGZYSH0QdXTpKyp/kuMM/hVmuXbtONLKVeXVteCDo7m8iXSftuiNrjEhNKPQPbE4MPnWtZPWi2i4Y9mJro4o1Vp3PAJ3SWugt+V6m0//75KAeXnUKya0Jz78VKd50gfbWWcgiKa3+mG3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g74Od77Be3VMm2wcJ42Ta59A9o9m44sL0dCWnHo2qds=;
 b=jwtexfBjcHkhlCbqjDEfngMUBpA7ugOnp8mRS96m6r6B0bPimYxbg7vQlMXQRD05colzb+PAdmt26cnJ9GdAIDOcX22n+Wdl6qPFff23VctF/bB+iXMgV7yGlhL0LIPscRryFEnW6nKOrDqDiRlkKpC+atsEwIwMlCw/2TfL3LU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by PAXP190MB1504.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:1c7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Fri, 18 Feb
 2022 09:40:12 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::f16c:7fde:c692:f911]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::f16c:7fde:c692:f911%6]) with mapi id 15.20.4995.022; Fri, 18 Feb 2022
 09:40:12 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] net: prestera: flower: fix destroy tmpl in chain
Date:   Fri, 18 Feb 2022 11:39:49 +0200
Message-Id: <1645177190-6949-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0069.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::16) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0317b954-09e1-47d5-92f3-08d9f2c2a926
X-MS-TrafficTypeDiagnostic: PAXP190MB1504:EE_
X-Microsoft-Antispam-PRVS: <PAXP190MB1504886F60DD0834F4847C358F379@PAXP190MB1504.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:298;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: acXHomG8LGYSU9tBhepVazS/nL4gMj0xF56my8q9q9T1WfxmUlmhBrKGiL6NuOUU/l2op2SdlVY9AtPg6ps+Hn00qdyMYJu5mfaf7ZlRV+c22JeRrV/HZcRb1QRy7Z1807l9MrlUfgWhZ6gCklgqq5pVVbcdrqwx6UQPz/V9rGGV5acC4WpTeFcVMecPGF15AFWDiqa6vUlegRohFYHlrIqMZUd8W5nnBru0h8/9O9TwT+QpE6TT0mQ+6qozay18qkJ51oDlnemT5NPohDsviE1Rh89pTDflCsBfPCRTGQApZT7j1cIuheW77XktWn+DjPYcwn3RbJ910WLcV+BE6zgSckfKu7XKkZ1TY/tGF8XES6CSeTtfMnEcY3dfLmXGU9k5OlNt0lJC+nNHsNWHaQsQzR5nYmqpdZhAueZvt15k9QJvagkjKLpwNx/gY8hRhoaqlWuyh1iHLNZTFMatIyzKoHm0P5/H7HQKfzYpqsEXkxH+HXmvTnzy3sJgtE5nKKaS01+FstW8DDefvyphZX25jmHNw+si60romqcMNc2wnHDLxC+fZ5+784ZCWt1YkOESvJw2vWprWreFJzWFigaPBybDS4fZ3luCOazvWr9P3j1ROnQv1oELcM5cPbD1BJlkGhP8/aY6WJftB0gwi/28BEm8VHllWsjDKeOhVZ3oGtHjW8bZg6wVLkzPlzSG55DmbAnp7MtVtKsyYIndOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(376002)(136003)(346002)(396003)(366004)(39830400003)(6916009)(54906003)(36756003)(66476007)(6506007)(52116002)(6666004)(86362001)(508600001)(316002)(6486002)(6512007)(8936002)(38100700002)(66946007)(38350700002)(2616005)(5660300002)(44832011)(186003)(8676002)(4326008)(2906002)(83380400001)(66556008)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8rGxZ81ToOnKicq+32klEgsCvNa0k0Ig+q8RZJYe4634eNR7jjtc314HSTLb?=
 =?us-ascii?Q?uNmOKRxbNLpyJs2MsQHZhlruMGmMAoisdnC6Ikz6ypzu1L5vb4y4a6CUU2B5?=
 =?us-ascii?Q?OULTQBhGsTDDfZPuNOvVjakQaK1U5F3uPWWLneOwbdCG99QqXbyXsI0AALUY?=
 =?us-ascii?Q?INR/INxgeqjqfgJ2+ZceVfqT/g/ZfxtCPijDbzPFN2r/jdsBoSG6xny0BtmZ?=
 =?us-ascii?Q?F1v1VjBfxdTIKw7aImvyFEacHMFglkdHv8BnxAxIsHd9Jb/3v350lUPzhpet?=
 =?us-ascii?Q?In2ThD9MFe8LABl3aX06HUugulVP/nzSobD+jMIv+pICrxnd/hF1I2VN80DM?=
 =?us-ascii?Q?ij6sNm+vKCJ1h5h6OAJ64iYpR3Cw9du3/ecn2Wsf4UpBxlLfIws+ubOdPlyK?=
 =?us-ascii?Q?zYoUCm1Vo64sTg/DMqwdVrLXNxGZnfDam2yNue84k870Lq2fa5z7gOyEE+GR?=
 =?us-ascii?Q?2cQbuBRtyTHjjRHHj5BN+ge4hjsy1i4T027+gebAb5hFnX6vq9XS5dhubR0d?=
 =?us-ascii?Q?UUmBPcf5sEv3aM+SzHbihpdWOynyTYw/in+7wO5nhr1Hy03CPNz1ak9U+1YE?=
 =?us-ascii?Q?UPuYfruU3pk6llJNSK5uY8NEqA3XXvHaJrkUaI+RQr+AcrZEzgZ4fQdbV5rz?=
 =?us-ascii?Q?Gg6mS582uWOsTWGEMiYUY4S9UPyHas2tGZW1Y3SiIA55dyjaevfXDZdop6Zy?=
 =?us-ascii?Q?AucuMdqZOSy2pR2FYW773F2mhUadO3askRp3N22yGIPP0+gbHh4GnvxxUM82?=
 =?us-ascii?Q?MCcNsEiB/6sjy+/Hf4dDwFICT+hy8gyMYgQ8LRPm+ROqGVCyrUu6XgWgq70b?=
 =?us-ascii?Q?azpR7l//DYxqdpwF/taoZTkdUBe05EmInFARSIsqTl51ZhQKfQNbVFgvZkoO?=
 =?us-ascii?Q?S9iQUSfUXEOpivnRUHCHcs/IoO3cDPMakU49mFe4i/bgvv4F2h3uJhbQY77X?=
 =?us-ascii?Q?6yzRVvyJAj1q3A2d6Mr3YcZmlUE1dmX70tdN3l51y6nBap8HY2hK6/eqbdcU?=
 =?us-ascii?Q?1sVqneFpfX9SIwvT2JNY5yVx7NzxPu4MV2w2dz+7g2WVKgnfGEpGdYL1qORY?=
 =?us-ascii?Q?rrURAzt+0Fh8xOaUWhEwu/b48JcxkrVXY+QdpfUw6E5+NG1LjFqT1NNNNFFr?=
 =?us-ascii?Q?0Mp4ebK7tBm32hWgm6vlqPMjwAiDbozkXhqOBUQ+O6RtcdJub9g8kBExArhg?=
 =?us-ascii?Q?MD28QUb+0AgBn8FwYtWiFUAHPiFF+5kt55oF91ZypBQj+JMTG6AGQkoo2eG8?=
 =?us-ascii?Q?+9kII2aEjqfzxz+Xa7sPSLMHjU+pQl6Z30yvJ5x+iXD23xeK6h4mPgfaHgYu?=
 =?us-ascii?Q?WDVjXd77OkVzirhFPbVcJgZh/pfwrSkyvcO+m5k83xWGOieqcUkCKj4Jdj6o?=
 =?us-ascii?Q?C8ReTy3OHSqVtxDb2Ib9jDjKKpf/FTMspfwSpOIOgvEgSSh6cc6UV0dHVY93?=
 =?us-ascii?Q?plVnQSoxOsJUCNbtvK+B/RfEudCv+yQ67VfbT22GV9ESQQFCAFMy+ZCDLHwi?=
 =?us-ascii?Q?SV9Z2zh1lUPEwo5afZOMNu4NOfatE4Z0Hbl00pwTnh1sUzCp1Eec14nq0KaT?=
 =?us-ascii?Q?3rw8x/otMR+OcKVb32CG6r0EtEFC2KcbR6Gwc/tI2D2xIym0HNmH6CfXknb3?=
 =?us-ascii?Q?DU8PtYUqm4cjxQK8Gy2l3sJKrtOl6PSjb/y0txanogHe44DKR5JOiVVkINAs?=
 =?us-ascii?Q?SN7Yiw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 0317b954-09e1-47d5-92f3-08d9f2c2a926
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 09:40:12.7290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x7SVriMvUvKrZeBqNX6/mkxqF7IZtqfamF017vLYXZMIz+kR3i9Y62FOUU/BzOw/LkByR2yMTfuXuFPxrEsDnJNY2EgDFLtbRsWrg5Hon34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP190MB1504
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

Fix flower destroy template callback to release template
only for specific tc chain instead of all chain tempaltes.

The issue was intruduced by previous commit that introduced
multi-chain support.

Fixes: fa5d824ce5dd ("net: prestera: acl: add multi-chain support offload")
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---

V1->V2:
    use list_for_each_entry_safe instead of list_for_each_safe
    remove empty lines between tags

 .../ethernet/marvell/prestera/prestera_flower.c    | 28 +++++++++++++++-------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index 580fb986496a..921959a980ee 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -12,18 +12,21 @@ struct prestera_flower_template {
 	u32 chain_index;
 };
 
+static void
+prestera_flower_template_free(struct prestera_flower_template *template)
+{
+	prestera_acl_ruleset_put(template->ruleset);
+	list_del(&template->list);
+	kfree(template);
+}
+
 void prestera_flower_template_cleanup(struct prestera_flow_block *block)
 {
-	struct prestera_flower_template *template;
-	struct list_head *pos, *n;
+	struct prestera_flower_template *template, *tmp;
 
 	/* put the reference to all rulesets kept in tmpl create */
-	list_for_each_safe(pos, n, &block->template_list) {
-		template = list_entry(pos, typeof(*template), list);
-		prestera_acl_ruleset_put(template->ruleset);
-		list_del(&template->list);
-		kfree(template);
-	}
+	list_for_each_entry_safe(template, tmp, &block->template_list, list)
+		prestera_flower_template_free(template);
 }
 
 static int
@@ -423,7 +426,14 @@ int prestera_flower_tmplt_create(struct prestera_flow_block *block,
 void prestera_flower_tmplt_destroy(struct prestera_flow_block *block,
 				   struct flow_cls_offload *f)
 {
-	prestera_flower_template_cleanup(block);
+	struct prestera_flower_template *template, *tmp;
+
+	list_for_each_entry_safe(template, tmp, &block->template_list, list)
+		if (template->chain_index == f->common.chain_index) {
+			/* put the reference to the ruleset kept in create */
+			prestera_flower_template_free(template);
+			return;
+		}
 }
 
 int prestera_flower_stats(struct prestera_flow_block *block,
-- 
2.7.4

