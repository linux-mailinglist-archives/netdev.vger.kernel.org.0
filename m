Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41CB26E5F91
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjDRLP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbjDRLP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:15:27 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2045.outbound.protection.outlook.com [40.107.104.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBB146BA;
        Tue, 18 Apr 2023 04:15:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQlpzmFq2EEpQ1MUs+lSNws3mZOx01PfQIfRTbTEfv8Lugfd/CiSo9Tc71609tPE2JGHaikDvkRLSsx0fKaDxtTT9X8VQzXOFMrvHZtLjeISLIA4320Z8jWjxOwWx6mmGtR56sszko1mLjeKBXYE7LldSD2cEa+Cg27qwaFBDrw0ARdDQ9/n5l78nd4zUdS4sosjK+wTIdS8r0lgHjVDsXM124nzTd/FLICZlHU0F5XMiZ13ylVvzSzK+SlF+L9YesAH9LZ1iLVof/DZV1mHIRAieabY9e/jJgDlhai+08W9g8tIU7BohXbInh807Hy+fIh4gaXFJAZh+QjD89BsxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZUBfqL8ZER71p4PwFMmPWN6oiSM69vL5qZGaDNdIfiQ=;
 b=StwkvzV6MmwnxIp0wgwgktt3lrFRfkBsT4LobM/eqpMJ5stBfRkE6Hk5J8U6wPkckeBCaXw2HYLePMYmGn949RVA8TuW1dnz+zFJ1Zu1pYi8xylTaBnNkmYRMSSsmskESIXjgpFJUjFHs+WkPo96BzPuQYI941z7M4USFgZXfqJTIq6gB9NOiqqpT8srLB84Z77yizK7QSR3UJmjvYnblIYB+ZFvcvAhAKd35SuA5NaEuO5mrBvJuQedHcB7v7DBXo45+dIRfZlxnnEZdPig0ZWAqK8G1YHmgT+UFUGy0AweXIzTbqqc7EkF79M+5Zie13L8cFRbO6gp81Un7giY3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUBfqL8ZER71p4PwFMmPWN6oiSM69vL5qZGaDNdIfiQ=;
 b=pUmfJpVryqR7A7P05ePoJeM057H5bzRPrZTVIeahYHGRkqTLKnlKdu3rDltB63R0tvrwbtlkAPLDYazCCL1orT6n/kpq4xTcnI2texH2UmIPUEyEn5VCnjQWJCj6BJa0yJkYFRWoD9WcAp9JCBl2LlGzEfxJbjKgCpKOx0BWNJE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8659.eurprd04.prod.outlook.com (2603:10a6:20b:42a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 11:15:22 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:15:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 5/9] net: ethtool: mm: sanitize some UAPI configurations
Date:   Tue, 18 Apr 2023 14:14:55 +0300
Message-Id: <20230418111459.811553-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418111459.811553-1-vladimir.oltean@nxp.com>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0152.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8659:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fec4046-b3ee-46e1-f7c4-08db3ffe3392
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MWvPWjyF9r57ZJ455F7nsF7X4+v++Qo12iA1/2fR4moH+QgYROGZ0Sn0yfd2AgiKI/cXRnvLcFdgaklbjuMyzTbJpB56xnRCvFTHbAp2a4xAPPCLr4/6nnzZih+zm4kzNqw4gvQwy6ZUEj03gViaBph6SqWilKWvyId5r20HY/CDmX5uiOg+VU+spUCl7+V7g9tuNHXaDJnhXJcTzzFej9szESlocZ87G+QqHqxXOju+F4j3pqMeT8FEdkMLtLQRyZui4eML3ILa09/ujAXAwTdhCDhC0AVSEaMj6pm8818ZMJ/E5OKIi92d/gr2Bxq9qRVyNAt6T8rXAQ6V1uXt51cTBGGpy235nNXWfJMwf1vO7UnRZjJLjQUAKzMEjKxAGT5EbTfNKeFOuH4kFNVEqAoPy8EubQfpakrSEGQCZUuc/WJM7IZFJNqcKxJS4sa1IGJeIWShbBMigzjuCsaHhmw30/3sNM7XXFgkpLQdccOSDRrsibyIo/1aY3JnkqidyJ898HWzBFcCvJUFQVJo2JE2z9k+/4HkL89mZhtBbHCNGLRvF01OP4Ff2hovvXmHo/KoB/CR913ey6R2EK23jHefmYHGlGzf6GKDjzvVMYLvKVXMloBBIqYpMTqHC931
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199021)(6666004)(6486002)(478600001)(86362001)(2616005)(36756003)(26005)(83380400001)(6512007)(1076003)(6506007)(186003)(38100700002)(38350700002)(52116002)(66556008)(66946007)(66476007)(316002)(2906002)(4326008)(6916009)(8936002)(5660300002)(8676002)(7416002)(44832011)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ha525zYnbg+7ay56hOfH82Djy0iEdEW8kunTxmas0L/+qw9iksyXU6vWT6N+?=
 =?us-ascii?Q?WiBRXewxI/W759FrVIQ+VlTJUrx7++nop0qT3ZBQ7q0qi/itZb4PKwKUtPB9?=
 =?us-ascii?Q?VMJPNP28VX2/Ww2vMBCrqbQBZQ7kPHT6LkC2IEJ9MSbxvNMvTUggkflUk41j?=
 =?us-ascii?Q?hSYKWBLlY/X6BI07779gKBrBqmNpxsiZbMaMLqHY0vhhfVUUVCa9edEhZ6jL?=
 =?us-ascii?Q?iBm6A0zMxdaIjcUzHDrn0dm3uDBF7Wv5L237GPuOgX5FMNJJYpH6miJiqQnP?=
 =?us-ascii?Q?mlP1C15Tlse1aTQ+ZSM6TM+2eVmrfNNoyds/r6nvuToCrEWpDyG4TX3oJv/g?=
 =?us-ascii?Q?09YoB5K8H4UrziRiwOKRPjSo2IdBfHONj7jcZZqwfvpHniklEFqfFfwDOzJ5?=
 =?us-ascii?Q?Hmeu3NJl3+Qqhtw+tswqnqlDyHg5ahE+BJRjktTOBObIOaQ0ZwiXw03LF01y?=
 =?us-ascii?Q?0kkANiQmKXoY7SBA9qLCZRCLSwlCO/BMnyQBdI4uYnIzANR9ze+VOyNXnJ+l?=
 =?us-ascii?Q?toDeF3G20gaQYkj/U2E0g8V+xfPSum3arO5Lt6Tlu61mB9FgDvpVEeJq4x8W?=
 =?us-ascii?Q?qKmpTh1/L0fLsFKwJzaUTJ01iFYzEGpV0ezFl80ZfwvScYigS49ic5n753My?=
 =?us-ascii?Q?FC52JoDDJ80uL+BlvDpex/CU3paba+VH6PeVFB/QW8kk4mW659TxCDoaefnk?=
 =?us-ascii?Q?TvwM5yLLDzoSOVlHRqKUCQqY8EfZE1xZoJyFhs+N1L2Txhf70ESFStuwgWjt?=
 =?us-ascii?Q?gsipkohjct+I0xkJI3LTVOlK7Zygze3r+qbYBPqVtQLRdIu5lDkI+SASqPff?=
 =?us-ascii?Q?kx1HdtYWsIuvUVv44XIruwQJMGRKHR8uM51hslDswhaF+XaYwbg9W8RHJy93?=
 =?us-ascii?Q?QpC1th/4ZbQ/SyILUvv3LFr4LWsfKL1RbphAtRW7wLXD5fFRhd3nj1sw4qe1?=
 =?us-ascii?Q?7z1WnZh/J7rqPkL5SP3F9G21b8wr5DRb7O70z3jD0hen+V15s5VYVMv/D5S+?=
 =?us-ascii?Q?t38e/F/jUBWzVRjsErRmSy8ReLPoTdrDdfPKyf1x/XPlRXWo0jyya2FXpH56?=
 =?us-ascii?Q?w8yS6FvXgiEhBld2AoeJ3ssO5ENeIAgRqGFXG70ohh2O/yv6ziaN3PQfgmUo?=
 =?us-ascii?Q?mlgeONKeQR99mG5nCVX2ILHLRQyOYRoMtBpblFrc+lNfGT8IIZ56woe4SnWU?=
 =?us-ascii?Q?XE/65q6F83wx/ifP4+B3rs6P+pbNjlQL8tHG0xUZaEkrdJ3U52Q7wJtd4bC9?=
 =?us-ascii?Q?XTWiHAfpoAQsWl2EjZGON6T3eVYAMPfzvyAMW2GEBBMaOKW/0iWGvnsCiqzW?=
 =?us-ascii?Q?43DtWfRxPbcbVw5FULL7GQC+Bzeq/I8iXbZ9+mPa37kIDeRQdHl856Aowbos?=
 =?us-ascii?Q?t8avsSU6+za27uLyQRrk9db0d8w0i+m6gnktNhzWIcvwohaKsOwgNoN3PSag?=
 =?us-ascii?Q?HcknFVxDzw92PYuja1g/qR5v3UwPt4tk+/c0hfhBdOp/A2OBSt9t7CKkSXVv?=
 =?us-ascii?Q?jp3/UKah4aBFIxzHDj/jvrFlGZgZBY/Vw4/b6DENsw98dtYuPIQ8+OY8QWdR?=
 =?us-ascii?Q?0MLdNP0LlCHj5t6agDstn7tJgfTBG05He0Yw4cJUnJiF/l+R909l0Edjyb+D?=
 =?us-ascii?Q?pA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fec4046-b3ee-46e1-f7c4-08db3ffe3392
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:15:22.4304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mvz9d6+mNxjGJbyYvi2ONn0kvTIMC4hRCz8DQDM3jcNZ2J+YLaqhFBlshkJ0Jxgr23mEm+VEecNgDCDu4iD+Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8659
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The verify-enabled boolean (ETHTOOL_A_MM_VERIFY_ENABLED) was intended to
be a sub-setting of tx-enabled (ETHTOOL_A_MM_TX_ENABLED). IOW, MAC Merge
TX can be enabled with or without verification, but verification with TX
disabled makes no sense.

The pmac-enabled boolean (ETHTOOL_A_MM_PMAC_ENABLED) was intended to be
a global toggle from an API perspective, whereas tx-enabled just handles
the TX direction. IOW, the pMAC can be enabled with or without TX, but
it doesn't make sense to enable TX if the pMAC is not enabled.

Add two checks which sanitize and reject these invalid cases.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: add missing "Verification requires TX enabled" check which was
        only mentioned in the commit message

 net/ethtool/mm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ethtool/mm.c b/net/ethtool/mm.c
index e00d7d5cea7e..4058a557b5a4 100644
--- a/net/ethtool/mm.c
+++ b/net/ethtool/mm.c
@@ -214,6 +214,16 @@ static int ethnl_set_mm(struct ethnl_req_info *req_info, struct genl_info *info)
 		return -ERANGE;
 	}
 
+	if (cfg.verify_enabled && !cfg.tx_enabled) {
+		NL_SET_ERR_MSG(extack, "Verification requires TX enabled");
+		return -EINVAL;
+	}
+
+	if (cfg.tx_enabled && !cfg.pmac_enabled) {
+		NL_SET_ERR_MSG(extack, "TX enabled requires pMAC enabled");
+		return -EINVAL;
+	}
+
 	ret = dev->ethtool_ops->set_mm(dev, &cfg, extack);
 	return ret < 0 ? ret : 1;
 }
-- 
2.34.1

