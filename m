Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7346648814
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 18:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiLIR66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 12:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiLIR6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 12:58:55 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2051.outbound.protection.outlook.com [40.107.20.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218AD934C2
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 09:58:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XHoIa96eUqJGvezVjffIAw2m0ezT5De2u91NISjZDb8xPPAAn1lLa8V+PN9Ue/MvONLp8uCm92N9Ikn+xVFzIpxJnok4Q1niHAtRuEY4d95zWodhJqMUTxNSP+UmLq2XOvv5D+rw3VoEZALpPJ1t0FfYLMct4Wi1MXh4ifr8aOOo8dAkkiScD1ABTGcv/rZxqkFzi9P+LlpcBTXlVYAEkBcDUuQf+EavVmjuczJenLCKZcNIUM05ebU+1rpBJiU62kj4c64lfE95Z4ballit7sUVmvJ8RD82NWAAqqXUx+bJCiohrYVbLhwv+E5YMdfMfu/ARO6fnBMa7m+zh+a59w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e5frSkEpIrfM510OYGlSAjQ+TM62ZlnBcn+FT/T4n1w=;
 b=GoBDrkVBpbm1qOtbzbocTwl7OcNKFXe5kkTL7JB70kRWQ+HbHXK9napwDwZC+iM9lt3TLzaW5N+sgXhRdXiAMGRFFCN1Hrmy7fK9E8eD6P8ZSzk6dF1DmZlFBFkIgWEE3/QiNsEQ64/Gf9FtTSxeIP4XTbDfAKGVeQMnKHyMGwWN5tVf5aRDlFWEtDQyr80cB9BCIZiN512Dp5hryiYNuhjru/YXG2wDMkmKvsPZDeSDfenwjqkuJMIN8gzoQene8wjLVzeJEvhoWzl/aFRM0uSHYHQZdDpfVyinYTHqHdjRiB3fL4jm6ZehJBO278x0U0UslGW1TfP2YLVtMOOmmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5frSkEpIrfM510OYGlSAjQ+TM62ZlnBcn+FT/T4n1w=;
 b=KOie7DeDuM7lzM13s7O8/7+dDHCoD7tH/+Brg8vG75pIylWEoyBvvEHKAsSdpBVIGkp86VZqtbqQn3WCROwLgWf6va4rv8BxgcLPxLOrN2ziGROzdbqTNSHbmJ/xTNjr4vniudyA0n8x6mYJBPacJwFaFGfEjCM8Xazu+NNvMN4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8519.eurprd04.prod.outlook.com (2603:10a6:10:2d2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Fri, 9 Dec
 2022 17:58:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 17:58:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next] net: dsa: don't call ptp_classify_raw() if switch doesn't provide RX timestamping
Date:   Fri,  9 Dec 2022 19:58:40 +0200
Message-Id: <20221209175840.390707-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0094.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:79::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8519:EE_
X-MS-Office365-Filtering-Correlation-Id: 3599f361-ed5e-4f7b-f7f0-08dada0f07bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pLqv/QBBScGCQ8Pm0Mq3TPRm8puTYso1biD8Se9PGNvEAXNFHiZhz7zUY5gZQy06fzwCcYJeR5WTq7VktfXYHEtZVL/H56/1cTuIvPbSnGbrwrWof4lIF517bRAtqEliWTqKjADjUj4I9mL3cN7R6rS9t5hHpOniDTgrcLdllI0FEjAy4oChtK6HHvvC4m5RdoubkZOg+gD8+hcYEd9WLa2rBXs4kZkZVLXGgxB2PYVstCdRkqI6CQZQjAYMX7xtND/dEF59JQ4nYaRyyr1M02i+e7f6rs0U54swsjKL6AThpqAScz0H5ArGyVr8HzY2elJGOGL+AKJD74YXEv1LmaKPQGrPvWyUlRZmFsoezwriVohtmm5NIibrqZWGOEqZE/3jhR/Q6KqMOfn9DUJSlHTaVDSsGpVVKuusZU9zRiylryXQic6aPbpLhfu3GyewtVukKhFmXSCG1bH7LM8F0pndbr9xpP9EF2Sa0lxkR3yLsTwaQWoLjdgygfIkEU/yAx9pVRVbCP1wPy9H8/wLO8PRWLMoFwPlyVn5voZkgFFaOP6b0GlazWta7giflJTq8mvz4BB+0PP1TmKrp80XHcSBUEiHv0srrPKXkWWiXO3HMO3u9HJtI+ndLcI0NZ5nODZYc9KSfILcIZGuCYIzWSCQclSzacnOruDFWolnZWfoxAJr3fZ8AEWZ7JufcIM+guxC2pR4BJ5xp5gsxn5uaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199015)(6486002)(478600001)(6666004)(1076003)(66476007)(36756003)(2616005)(38100700002)(41300700001)(54906003)(6916009)(26005)(6512007)(83380400001)(6506007)(52116002)(86362001)(316002)(4326008)(66556008)(8676002)(66946007)(38350700002)(186003)(8936002)(5660300002)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n7nH3L0526b6KLDlW5S3ecIfMJxC8BhSEF/v4QLOPHHQ7dPCezx9kCByLggG?=
 =?us-ascii?Q?VmZ1CRM/WbyWLu0KLsPzjcEEHxXd9CUsaaydQ96mgelJcVylWk5f5zF3Htav?=
 =?us-ascii?Q?6nQdtfByvtIXsKah3hfJbrH+LiNTC3znKT6yYB2s/F0k1ZVsTnh6bfqr68Je?=
 =?us-ascii?Q?6pqDtZ/pzIHYatXbZyW43pURRFHb9tdOmziPO0CGuWBS4NKQAOWiAso3PZ6R?=
 =?us-ascii?Q?AcgN0xVEQUYKptLHWwYSh6R1qWbzSeRw1M2DJuiHis+2VrZW1AGobecjDTZM?=
 =?us-ascii?Q?SsjDeEqmZrm/spwnZWkkcXGprrddxo2mXvcoRCWAuUqCLjuffTPet2PYt5d9?=
 =?us-ascii?Q?ubcxkV3P+WEtFcFqVepA0Yow/DOp3JybsSUxFw3yAhSF/8tTz4LBqkARfs+C?=
 =?us-ascii?Q?iV91j4nwl+z02nitQ6fVCCVKHd4fKvuAJicUt/lfOrQ6MRpG7t7cS6BhUd/+?=
 =?us-ascii?Q?1aA9D0qba4eatz8I9JHgHoFJ2lfwQd/GfUg9f0Yz4UcOr+8AzqZ3fFwSKd5l?=
 =?us-ascii?Q?IadyLhrx5nvYWc+SWTmR/zba17i59j7LgHET4WtNJdUIrmM+PPMWI0Lhz6K4?=
 =?us-ascii?Q?Low2/CTPx4OTnfP3A99uh1JJqk3IlLxEStSNrRDPDBg/8tm52Q28Xu2Nhdh9?=
 =?us-ascii?Q?b7oEmsyTavaAMnLrOTwfWeh8jvw8D95COJQVHY/eMyjwXg12EbdxESva96t9?=
 =?us-ascii?Q?8evkFd9S/uv44FMEDFDEc7vsT8uoMHzyEmy5JjlyYPPw7/ephRvDxpF5or2G?=
 =?us-ascii?Q?uPIN1zLDxFzSwzotmaUOarDXl/2ohgWqy9L4+Wy+BeyJ8EIatEtC3gKTgWRG?=
 =?us-ascii?Q?uM7tDO4ZxSMjCbVzvj0c6+0GkcjHgRgPadoPvJwO0sdhD4ImeIh1CAWLCAzX?=
 =?us-ascii?Q?c25SZvZj6wi9ERO5h7341dLG5BRRnBoFDj/KUPkQEdzTTNxCIYN0NzOO0n0g?=
 =?us-ascii?Q?ITmg/0K6uppUzflrl1Z0OVYhE6dJMKubj2ZWiH0ys3eFk5xqIkarp0KQImCz?=
 =?us-ascii?Q?/Eu+nd7ocbKwMFp0e3mXvwCae7OLsN+IP7jzxc8Sr61jmkAfT5huaYlLYMJl?=
 =?us-ascii?Q?uENYP3HfF7n/KUKrJlmqR2q+c3/Tz8raqWB2Yo56Qpdpk9uZEUaajRyRYUg0?=
 =?us-ascii?Q?UMQpfvsZeh/hwtyVByAo1GlUnHcFSFI6PUjLWCI3//eyF0+3iX5cvM/ZyY/T?=
 =?us-ascii?Q?v+8IurFfcU58eIhH7wDRtSx7Z46Gl0UfsBPwlh41yQFRB2uprZ1+b1RI4dJ8?=
 =?us-ascii?Q?7/1Qp/4GyWEGGO6ukgfR0K9Lbrleldinymwt7sHF3CRZup6cTeR+ytMCbqLr?=
 =?us-ascii?Q?yytTtMKlo/7vbSERPsCNRwhr3pSy2huTna3xt7CNeeLQpMHm4wbo/v8PE8Fe?=
 =?us-ascii?Q?vDhTkRJcdD/NTHh5jPQrePRqUYRZnfIrnBbDzy0RPWtmyil5+5jdCsajYupg?=
 =?us-ascii?Q?AySTPNmLCBngbOrjleHsPyhm8pGT8iOPjXcM6xvTR2UuiIb6uFl9Ah0wTvMr?=
 =?us-ascii?Q?9OIaiSYOXE0E9V7JdsuiHYtLJ5L8OmB3D3oHcOxayRVOv088MEn2Rcl9ixBI?=
 =?us-ascii?Q?ZAhOANN7+rOUslsdeMiIXpWYavAqu8u1YOjDLTNxS4xJtJdUysPiNLwD7GGo?=
 =?us-ascii?Q?mA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3599f361-ed5e-4f7b-f7f0-08dada0f07bc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 17:58:51.7254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 00JpAD8FNXY6LrKKvwk2aKTYJg4X6w1LunM0iH1HxEpb3t6z+dQUFn5GyXYNBbdE2fdaYw6kkx0S6vtB2oFMpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8519
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ptp_classify_raw() is not exactly cheap, since it invokes a BPF program
for every skb in the receive path. For switches which do not provide
ds->ops->port_rxtstamp(), running ptp_classify_raw() provides precisely
nothing, so check for the presence of the function pointer first, since
that is much cheaper.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/dsa/tag.c b/net/dsa/tag.c
index 383721e167d6..b2fba1a003ce 100644
--- a/net/dsa/tag.c
+++ b/net/dsa/tag.c
@@ -33,6 +33,9 @@ static bool dsa_skb_defer_rx_timestamp(struct dsa_slave_priv *p,
 	struct dsa_switch *ds = p->dp->ds;
 	unsigned int type;
 
+	if (!ds->ops->port_rxtstamp)
+		return false;
+
 	if (skb_headroom(skb) < ETH_HLEN)
 		return false;
 
@@ -45,10 +48,7 @@ static bool dsa_skb_defer_rx_timestamp(struct dsa_slave_priv *p,
 	if (type == PTP_CLASS_NONE)
 		return false;
 
-	if (likely(ds->ops->port_rxtstamp))
-		return ds->ops->port_rxtstamp(ds, p->dp->index, skb, type);
-
-	return false;
+	return ds->ops->port_rxtstamp(ds, p->dp->index, skb, type);
 }
 
 static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
-- 
2.34.1

