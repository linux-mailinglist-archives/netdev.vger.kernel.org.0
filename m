Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F0B427F6F
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 08:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhJJG6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 02:58:22 -0400
Received: from mail-am6eur05on2139.outbound.protection.outlook.com ([40.107.22.139]:11744
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230267AbhJJG6N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 02:58:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQtVDYrXHfnV5bXwoAwaX9l44rUuStnZ0iSDxqHP2PsTVD3uglFuyy7sjTPLj4Xf0ridIMybzlbqj6jq5jNmY37kncXMGlMX1j3tJHz3WENyGdoGXV/dcNGYeYUz1sKdWs9sSfazMSduHboYlgqNqmYFFZXPYTfZaoJAY/WifQxioYc2rUcQqUlkvW7IYCnOd1CV3CbGqkP30uNTqZq0Tk8BRacOdIiUtB4IserxxF05f219v7b8MRz3ojCi4DvpXtnW/ZunjTgIAJ8LNN8usAaa4ed3FZHu19hPDCLg1yuC15a6QwZ6IToamlx5l9VwbmQStwVrsn7uDZo9RHK95w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xsQ4RaVEjboGSa/ozKMApxsPFweAZoX0F+0AGA8C2GY=;
 b=Xri3zvqmn6WIMoCZcA2UXBXRkXqAMIypdzzKC/0v1F3+h9uIYVDKejmgRJyis3u7Evv+hFFgQJtku5xC12CBW9QGU/qtLPaHye9c96AiyUcu/qwu6vcks7Hw8cXRPOltFrgvQYXmT7icJm+PHue+fQdcOucoHpRtr84wKaNb9H7ahT243XgpE6boV/WCtfS5ALaXlX+i0+BSSz3q2uLcDIueffDz35osUHxNrFMWq6WNOf6WeDjs2W9e1wYahjJlIL3h2KfKrEsN3M8YTtiS8N3Cbxc39v/HGQszypbgf1H5w9b6pLDfer2gvEtM2Q1VaAaEd8Q+EoJoVzNBjn36RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsQ4RaVEjboGSa/ozKMApxsPFweAZoX0F+0AGA8C2GY=;
 b=oAM/N2XuRUObVzNZrqueFWqBBJ6Fq36KCCj67tfsM8ER2wvLX6NObZ5cx2ksjks6p1DhWIy7sEldGFTKL6AoLGLHs+hdO/3H2GWwptyb4bruISFCQuWJUXru7I+fVxKlL4q8BpopyPx3iNzjfHdL1VbBtZFaGCj+28WKNzW3PAg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0223.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:a3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Sun, 10 Oct
 2021 06:56:12 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::4c5:a11b:e5c6:2f36]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::4c5:a11b:e5c6:2f36%4]) with mapi id 15.20.4587.025; Sun, 10 Oct 2021
 06:56:12 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net] sched: fix infinite loop when creating tc filter
Date:   Sun, 10 Oct 2021 09:55:47 +0300
Message-Id: <1633848948-11315-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HE1PR0202CA0029.eurprd02.prod.outlook.com
 (2603:10a6:3:e4::15) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by HE1PR0202CA0029.eurprd02.prod.outlook.com (2603:10a6:3:e4::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4587.18 via Frontend Transport; Sun, 10 Oct 2021 06:56:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3d7062b-3a82-40fd-bb7b-08d98bbb0bd9
X-MS-TrafficTypeDiagnostic: VI1P190MB0223:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB022345EF792380FCB0854D778FB49@VI1P190MB0223.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rKMHN7Pb+Rmq7l12nKn6eXuLdf4PoP2XnBjis1fzQ//BgUNjE+WnyFtKujZkvQkA2UkXW8GnP0UxLGYalfdeYJeITPUABiQbhvXY2hHUW1o66Cm1Zmps4Pe0TB4IwPlE0qtrzAf4cLfi0WX0GL8n7VbATkSctcPMBy160ZL6Fx51rncs8qCRYPXT8HsXoODcBATJx1kfzS/7JDQb00f4LKVGRp9Jo86wSZxoQ390XoVAz9HvggxeA3q2rVe4sg0RNbqJERcex9gTRvHgMijmnofIexGgFngVOsdSMsIg9PBD1jVMicvPWjr9BFrDDee3cc5ZXCQlEpmA3IDpylICQ4OqM8VZijpwKx0cuBBNat9W20Ifz65lgtFf0rdDnQ7lBFASn1Hl1tmfZBE8cljAxDPsiavZqUqpHG547RNXZ/xkKsUknifk5X8HBZA6/8X2ReH//GvOkdlIlEteHtxlib37oGlMv1C/wwOI9mY88/NPlN1kcXE/7YlNjmAHBTEvVKsscNIVQYUB4NRM5lmQ5+70vleIy88aQrDjr8ywzL4UolhVlxGWdv+G2AjCRHahg1hvVwpUFt2l1ni+7Z9QV2KOJouDvBfHrozIndpp7CXXkDpFRRD7ebjd7KfGtSBKPwdtGxtGvyC0D69WTR0YBGu17fbxO9OXbBEVT2i7PleIn3VpacKVwdKPXLfwrZrJpTSLmPNDsoFG7A92G+wD4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(396003)(39830400003)(366004)(346002)(136003)(4326008)(956004)(2616005)(54906003)(316002)(86362001)(5660300002)(66556008)(2906002)(66946007)(66476007)(36756003)(8676002)(186003)(508600001)(44832011)(8936002)(6916009)(6486002)(38100700002)(38350700002)(6666004)(6506007)(52116002)(6512007)(26005)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dbODmvkmoC6YLHu+a3CPyaKvlpwpr4GjaA1rhx7T5gqBHjWhaiiWzPyh54Ix?=
 =?us-ascii?Q?57ggIgSXKN/HGZJ8Gl2HOc2qAAWu5lqNXYgYjX3Nxtrv+87EFdSwfRc20TxI?=
 =?us-ascii?Q?8nRhucC6+F0q6FBr995atJ1rfuzvF2YkoRpw95JpLeNqFE1XHjXVLWOA2HP2?=
 =?us-ascii?Q?vpAnnaJhf23wS5BRHMUp1ti32bZMfKAm/jYMIn91DCmUdhIsdiM+CfbGZ1BF?=
 =?us-ascii?Q?nr6x4apIYHMwM7ET5JP0odE2vJ1FBNw879VRUtj26+jG2HmcV+2lCl9yVqH5?=
 =?us-ascii?Q?jLkWMPYd3TUTRXmUb6kIZyrP6sUw2i/igDHtpYGCHJ6TY6EcmccJI3awDcQB?=
 =?us-ascii?Q?S6i6no/mzeqx7MOWM6UFGPlc2d5jr5sqO+bNMbcSmLG3CIK5ppz92sjZVrUs?=
 =?us-ascii?Q?YTNSKaZpCNqCGAiQ6HURKrKExiGs2QVz+ZAdAqioIFXMmVGiScrGJM9z44Uq?=
 =?us-ascii?Q?a+VKZfc7eSh9UZsEjJ3FnJ/8uOKibdkZrJ4rEaq/vYt+1Pxa9CCHCOUOTH3D?=
 =?us-ascii?Q?RMwcLLp5ovoRkiDowhJpANvjEtkigXVxURD411+6yKxhhNC8Y4qKlwCIMuQm?=
 =?us-ascii?Q?QxTwlTwq3MccCQUYHqkMTDwY3fmZP8Alwp6SoQDlW9SxmPGemMX8ST1HBWTW?=
 =?us-ascii?Q?aNWI3tHFLEaH1wJVYydv9SaBIAJL6IjD8SZ6l2FciYLCVJgApsZb+iO3w93R?=
 =?us-ascii?Q?GuFe5D08+dyB1ivYttstiGzTF7HqVgQ6+YjLtxS+ANf2BbURWKR9X0kHlEHJ?=
 =?us-ascii?Q?4DkCgBg1OCC1zEJqfBhjr1/ZTVPPWfxXoWokJocfIwkwiRq/4PLljbCeqHb9?=
 =?us-ascii?Q?tdhIC1RV7Ge8RsmOeA1hplrty/EhXATBij7ecqlSDQqdtBxsc5lZDoojWLM+?=
 =?us-ascii?Q?sCkiwT2MclkNVX7u9fWcJbtQZi4P1ljxehYJCc5sto4FgYv71u5F49UR3ybk?=
 =?us-ascii?Q?Q2F7Z+EJrDT9RWTUgH0uxYWTLqNrIiEn7tBPzd3/NWlK4HWIbhd4lmwxTX2E?=
 =?us-ascii?Q?lHCP229+kzbekkCV+wrYh84WguwzCvaNI5roT7VwNdPSV+3DgX+WV1ZZDhb0?=
 =?us-ascii?Q?hm314O+KKR3LMfIhpTjctuL8/WYe+5YJqtNomuhH/s96inhe+h2c9A9m7LyU?=
 =?us-ascii?Q?BPfQvxBZIKy4yqfINpTJeQO7bmgB0LJbLvN1Uz6uBntzce+2wPcmVm+1XoRZ?=
 =?us-ascii?Q?G1qCa8JnXsNHEn6FxwkxVxNXyJYAGXfOkHzHWmO/Dj68p2Pe6AOpZxCY/0Bv?=
 =?us-ascii?Q?jcwNSJIg2Ot0WfzXb/33paeuID9sczhgHcN5QUHHGIHqo3X4yYKvkpcAHlhn?=
 =?us-ascii?Q?pkGfezSJ2WRG6wA2jNnQ19Ij?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: f3d7062b-3a82-40fd-bb7b-08d98bbb0bd9
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2021 06:56:12.5740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 04OmkH6shAOEGBK3wo/ENOf2ToqfNOQYYycY25KUQUp5912tsieZ+TQ+73k9it1Zcpd2DoMHu0aFxHLlvHpaD3TuNCOs/A7Xvftx/m5ntG8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

After running a specific set of commands tc will become unresponsive:

  $ ip link add dev DEV type veth
  $ tc qdisc add dev DEV clsact
  $ tc chain add dev DEV chain 0 ingress
  $ tc filter del dev DEV ingress
  $ tc filter add dev DEV ingress flower action pass

When executing chain flush, the "chain->flushing" field is set
to true, which prevents insertion of new classifier instances.
It is unset in one place under two conditions:

`refcnt - chain->action_refcnt == 0` and `!by_act`.

Ignoring the by_act and action_refcnt arguments the `flushing procedure`
will be over when refcnt is 0.

But if the chain is explicitly created (e.g. `tc chain add .. chain 0 ..`)
refcnt is set to 1 without any classifier instances. Thus the condition
is never met and the chain->flushing field is never cleared.
And because the default chain is `flushing` new classifiers cannot
be added. tc_new_tfilter is stuck in a loop trying to find a chain
where chain->flushing is false.

By moving `chain->flushing = false` from __tcf_chain_put to the end
of tcf_chain_flush will avoid the condition and the field will always
be reset after the flush procedure.

Fixes: 91052fa1c657 ("net: sched: protect chain->explicitly_created with block->lock")

Co-developed-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---
 net/sched/cls_api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d73b5c5514a9..327594cce554 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -563,8 +563,6 @@ static void __tcf_chain_put(struct tcf_chain *chain, bool by_act,
 	if (refcnt - chain->action_refcnt == 0 && !by_act) {
 		tc_chain_notify_delete(tmplt_ops, tmplt_priv, chain->index,
 				       block, NULL, 0, 0, false);
-		/* Last reference to chain, no need to lock. */
-		chain->flushing = false;
 	}
 
 	if (refcnt == 0)
@@ -615,6 +613,9 @@ static void tcf_chain_flush(struct tcf_chain *chain, bool rtnl_held)
 		tcf_proto_put(tp, rtnl_held, NULL);
 		tp = tp_next;
 	}
+
+	/* Last reference to chain, no need to lock. */
+	chain->flushing = false;
 }
 
 static int tcf_block_setup(struct tcf_block *block,
-- 
2.7.4

