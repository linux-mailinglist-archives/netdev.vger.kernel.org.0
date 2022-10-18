Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC072602E35
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbiJROUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiJROUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:20:04 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70042.outbound.protection.outlook.com [40.107.7.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBACB52FC0;
        Tue, 18 Oct 2022 07:19:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hj56msutnVIovS8gRknAg4b4AYQ+B6QYhxK6tY6akOVDSzEUqfPMaQlHZXT7M6gqSNeM5tonW1HQ6cVLzCt1X5PZAkDPhivjoZAbqlTdIfwlllqLLSDFwUXb9bqltPgAIExME/+Zm4IER/fcWY8iSUgw07oNDqfelcAlqgklovEajdlM7FnkMstm8BhMBoqlFvVvPHTk6B2+YQrVJxjEPn/i+LXHa76Gj/a8UK1Jn+aQdhj1PnJxxDv9hUSMSYEbo7GeXDceO2Np9GE8qxZdRXaC3sZXvuB0nVaEBJRiHNUnpbOOezxXNVd9KFsIPa8E4K41E/rrV2JaIMYihJKZsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SfTWCGRKZnZSbiP9nhTojG76NFV+CagH/wt18aoWw94=;
 b=BlLb9e6pc/tBY8m6rZ+6oxdNk+AwpvvU/MZM9UYpbvhB36RnC6fjrZZihBFAmCp7IUIEb5gI+Gd8jMlq9UzPe0hXr7frhj438sSGEAPejSJrcP5tQUCcgTsM2vPS/mBwFumF9ucvRlepXlviMjIhxXt1QVDLgk27bceguB7Xf3eG10IIYqmXSA2QRZmM6bNC5fiRrbohb2EeKF8fm3L8+SANk2DKFsfaU0jtzWR7zt2G7cpwHL2asPc7pqlcOO4o/XgXKcTrZTTf7y73r9n8D0RMCOoZ1gkffa3EDktxiWKgwj9ucl7R2EXCIZcUp7FBquSMQhaZQC0Ko4GsMevoWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SfTWCGRKZnZSbiP9nhTojG76NFV+CagH/wt18aoWw94=;
 b=UWJAq/ihn2KJNgxW7UeI27lZYD6eBk+9RQsbKZiEmXuTWecxP/zdUTxkIVpqPZx7I5hs9h6M7zl6PSDpfwyE/Cl0xNRSJz1vbC7B6mLtbfnXda+UNxj3uCjctUVEaokJ1xXiADoNo2vUgaS6jnvnTEbempCeIKuRQCYvy+UXr2Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8706.eurprd04.prod.outlook.com (2603:10a6:20b:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 14:19:38 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 14:19:38 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v3 07/12] net: dpaa2-eth: use dev_close/open instead of the internal functions
Date:   Tue, 18 Oct 2022 17:18:56 +0300
Message-Id: <20221018141901.147965-8-ioana.ciornei@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: a465900a-dc44-4da1-da48-08dab113ca3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UHEe/DCcFQ5D/um3yS82u26mbpPttLg7XGaDHc52y1BI4gTOl3+AOMZVCww+VBGtPgGfLwx6TucXnrfyq3ynbKctSQPDvWaFcSgrTHMee8+0pdgizgxFM8llXtILYgtCQEvBtOl3U6jKzb5D3CWQQVmiQ26GoCx/DHXgW7KtJyBX9vo1dRDXqLDkzePqfDhKdR+D+0u4FPFZuTBNpeAvBaYTqU6ZkCA6PRpB+v6cy1UEMLsjLX60nCxrFappF0v6klx8+WvIA7MYDy/zRLJI9OwM4tyUzjl6iDhOE3wle2hq/LFhVglotehHWE2SOjv8NGk2I1Gn0zr5BxgDs2V58+4J5nVczOU6YLd+VMvJQ+B1ycnO37P+Asx5vKU1cqXFIdbazfsTFm+6T+xISlerOtG0LLqB/KYNO1VvOFipjDleQXmTkC+9AlGpL6jWbnVyInlf7YJjwl27RQrHUBRywwSJsO025W98veO98hdREt4olXeDML0OYjCRLk301HU0hPMaW4PqeQBG8k0RamgYnH4aoAIreWuaPo7R6d4iesfWbJlwF4xzDYcW/WU8wTYA3c7pxOIeTY9jUs4ZIAyWWx3/064++67ZBq9IStSD+ucAe54SogAUoyNgzlwDve4TW5On7y7IPUe9g3l+yAU5eNdAzdVPvfSPTmdCT/C7HUGNFb1bnBScCDdtu7V16gCyzMYPtE2FpxfYXQW1DG/ZtjFXH/9kyIVIcu2jzaaPMvhgG1M7+XAwabM6TEIJucQqsnXsBucTC7aLueJNUwuEcz7+PcnAyM6iVWt9URQJP1I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199015)(36756003)(86362001)(7416002)(5660300002)(44832011)(38100700002)(2906002)(38350700002)(186003)(2616005)(1076003)(83380400001)(26005)(6506007)(316002)(478600001)(6486002)(110136005)(54906003)(6512007)(41300700001)(66476007)(66556008)(66946007)(52116002)(4326008)(8936002)(6666004)(8676002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2t2RvvBmwFWwXgMl7orSGMnPiqSQGsIVuQ5REjvqvCcq1Ub/mui5mfkNP7lU?=
 =?us-ascii?Q?h4yIhWzB6SiUpA22So+NrSlLh1Ft3OwomMwyva7ZJcoPSDc3uPpNZ3tXbp3C?=
 =?us-ascii?Q?OFn/klyzI17QyxmOV94uFHq0DHxZ9qpxVXetGajMn7nGtcv63zc3yusQl37M?=
 =?us-ascii?Q?pSE74dEBsIj0cPuP+aj6cOMIHJauZQFUrV2TvpyV6t2cDojtwzH0FBYlP9hI?=
 =?us-ascii?Q?baxxJZ7BSqxUfGFMgVX+66X7T0VBF8pSu59hPKvz8TofT5elbdhkid+juwZC?=
 =?us-ascii?Q?xM9S/Lnl7hVSfvK+vqMnCBKhfN18C+qB9woHj2zdrIHc/MwVzKSJk52jNmAX?=
 =?us-ascii?Q?cA6Xv1bNel+ZDkY3mesp/TRItHmFy1dHLr1k+D6p4VDglIvLf7hvdnnFl7MY?=
 =?us-ascii?Q?oOU+6liEMLQu6gT4DH+Wfbf2ISiy/dAzcHXuDvVL3cIbfLha/Ew3PUm8JS4P?=
 =?us-ascii?Q?j4fPrJ83UfewLrqOBwZy1LZUA1zf4tvvL0Lt+tBrWfb1z35BB1XcSagHsitZ?=
 =?us-ascii?Q?kh3Pw4T37vMn6N8sxtxxbqG5gGiwcxkEgV220auDAqEFupy5Fh+CuCgApZaV?=
 =?us-ascii?Q?AjekuwpeuXk6fdwXctOJaD6XNhgcKQwXyrYP9IK7rEnSyAKh5DdlBd29Famy?=
 =?us-ascii?Q?DfKhI7WwQ3ZebQrjU5cq25QWw4DhnhnNwKd9S0bJc4aU3JJl0UYus9cQ5xj4?=
 =?us-ascii?Q?/Gvje8Rjo/VwnP9dOPK+/ZVYfpi9HZ0VMjOaEi6EoiXePNaXeAgstolyO849?=
 =?us-ascii?Q?p2qJNh34bbvuxJhFUZoHO5/CE/kkT1nJyOZ2qX4A7Ui02poUOizXMF4rShXD?=
 =?us-ascii?Q?lAq5kwe2XOMtpGtwsFwT6n6TNP58KEIXmKnSOmndgLZvLLJ+UbLqQRLhXtWZ?=
 =?us-ascii?Q?vh0mVf0uudc0lmCszwNkGN1sppGtT14IKWSO2+MviS+rv8Jmj1wfZ09d7jSS?=
 =?us-ascii?Q?zHX3eCp+bnhOSxFJnj1i+tCBjMRP0/x4nfT6W8aST44/TmOpdK6jcV8QPF7/?=
 =?us-ascii?Q?GBBptLOhHDrdEb+DtuQJQ9IllItF/ZxORn+Mc+JFUL2DDs/UJV+EJZKjQRyU?=
 =?us-ascii?Q?FY7HHSEVXp+jqgnsOAfRSGKV49fjJMWLEc0OI4HNyt23hRY6qv7SXD/bnd+i?=
 =?us-ascii?Q?7E/U1DT3EOxry/4CuQGseUyqyEHkgWqs59f1O2Y9+YQhYnH8+KXcs4QMHlo3?=
 =?us-ascii?Q?1nDYU9K4h3q0/WnDn5h0iIpyePSEDTNl6oG6gdQPYO4k6jgSMcwWYOl5uAhs?=
 =?us-ascii?Q?iOaNY+y0e6H1XlUwhJZ5L/73IzN6hD/73wXSt6JK/8wtiMcfASU44g5XJr7z?=
 =?us-ascii?Q?ogexHuOcbSd0+zPW0+2K4JXumePCrVOXHGgGB6H9m6GA8HrybbpKyB42uK67?=
 =?us-ascii?Q?Ex71ZtxKNuHfP2IoCrNatrx1smrT9Q/qt/Gkz7eNok/bY0XlVTcWpmV+UwZD?=
 =?us-ascii?Q?oo1qt9UMWkTkFw8GMWUtxr5RZldalkm1vfrQjKKE+SJKv61KLRuInFxORY/9?=
 =?us-ascii?Q?FZL0BzgTINPe7YqACV9Mh2GZ1FLb3uAhVm4a0F+lFO/qCnZEUUDjUo1nFwoe?=
 =?us-ascii?Q?7MIOhUnyTbjJ0XMFShicxORMsnrhFcjHRIU7MLs0?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a465900a-dc44-4da1-da48-08dab113ca3f
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:19:38.4054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: crGxXj/Mm2s9aYuSIaBAZfJHi+GIro7D2r/rdXAdmp5FCIFayQ8bSnqojrtVUAzmH8kd8V8i/RoQkFMXGaFuvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8706
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of calling the internal functions which implement .ndo_stop and
.ndo_open, we can simply call dev_close and dev_open, so that we keep
the code cleaner.

Also, in the next patches we'll use the same APIs from other files
without needing to export the internal functions.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none
Changes in v3:
 - none

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 1213ae4e1301..b95e9a7123e0 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2626,7 +2626,7 @@ static int dpaa2_eth_setup_xdp(struct net_device *dev, struct bpf_prog *prog)
 	need_update = (!!priv->xdp_prog != !!prog);
 
 	if (up)
-		dpaa2_eth_stop(dev);
+		dev_close(dev);
 
 	/* While in xdp mode, enforce a maximum Rx frame size based on MTU.
 	 * Also, when switching between xdp/non-xdp modes we need to reconfigure
@@ -2654,7 +2654,7 @@ static int dpaa2_eth_setup_xdp(struct net_device *dev, struct bpf_prog *prog)
 	}
 
 	if (up) {
-		err = dpaa2_eth_open(dev);
+		err = dev_open(dev, NULL);
 		if (err)
 			return err;
 	}
@@ -2665,7 +2665,7 @@ static int dpaa2_eth_setup_xdp(struct net_device *dev, struct bpf_prog *prog)
 	if (prog)
 		bpf_prog_sub(prog, priv->num_channels);
 	if (up)
-		dpaa2_eth_open(dev);
+		dev_open(dev, NULL);
 
 	return err;
 }
-- 
2.25.1

