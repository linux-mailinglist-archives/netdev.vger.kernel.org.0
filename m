Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6AF4AA376
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352889AbiBDWq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:46:58 -0500
Received: from mail-eus2azon11021015.outbound.protection.outlook.com ([52.101.57.15]:22676
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1352975AbiBDWq4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 17:46:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHIsAis+JhmOmsmPEnf6jN0Ejb1GOtmreyOlZdghohZ/rkwyfeMkElS6kazdk5R6+6S1+aA5/q0jQgxtYOw7gf6ZPpozHbHuxQVMlTGFayM5y0PIAhR4I5FF0G750qO2EndJZBdkB2nswTCwsEKdC7K/1JWy5KpqPnJHxCiegLSCBHGkDxx2a0FvTv38g9bilFtXTAR5pu4icUVWYeSamz8gjmyvWtfdBj3yF1mbJS2YqBFtXklB9azYZF5m3/cyXOWvcZsXMrFeoKmvZKm7lL3D86Ihv4zS+IqQRPfZ1V/k4za+Pt+JTaZKrS2J8KD2/3n05aN3KKsZGQqmd+BFHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tbBUNOLD7BMOfYDtPZBbnS+3wEL/rvXJ2wjDVFCzebc=;
 b=cwsdlefNetPKQujUBJo2jIwKg24ehutdKpIbcsm0BBqpGNZaGeWGz4MrS3JozrRG51/ZiZZvfAXcSJHIV/IMAIEJ4vUmwiwjRr2wD6j7tdFnH7uwngYWNmdv3jxAszyx6veuf4s1mte0/XMJhScva+9csFNewnE5Frolotz1fXyV5+5ZiQ/zgWM1+UcNV6FEpr1LnGxawAHumum6Vw671ZG6gkcEdU++gOvgLwdWfKf3lhPOtadY35qSszT1JjpBTo7R+PkrJsIFQtqQySLD8csdvYHmqnWagf6K6uxeyliUHvFBzFzg6ZPx4hn4wZK5ziWFA0aXEyAzDNA5WIQMtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbBUNOLD7BMOfYDtPZBbnS+3wEL/rvXJ2wjDVFCzebc=;
 b=UTWmOIdrzsxaEyIeB92LoIIACkyThZ8rFBWJQsDycrDW7QsjKxAUbliusklACSxLb0C+yhSflAW6BCLOM7cxxSEoIs671VW428VuGthv/OeGQqZ2vmlVyPzq5ib5GsYXV3iERec01wfJtLow5C8pcCv66l3Eg+DpczKRlQz85X4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
 by BN8PR21MB1155.namprd21.prod.outlook.com (2603:10b6:408:73::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.8; Fri, 4 Feb
 2022 22:46:51 +0000
Received: from DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::1d9b:cd14:e6bb:43fd]) by DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::1d9b:cd14:e6bb:43fd%8]) with mapi id 15.20.4975.005; Fri, 4 Feb 2022
 22:46:51 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        sthemmin@microsoft.com, paulros@microsoft.com,
        shacharr@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH net-next, 1/2] net: mana: Add handling of CQE_RX_TRUNCATED
Date:   Fri,  4 Feb 2022 14:45:44 -0800
Message-Id: <1644014745-22261-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1644014745-22261-1-git-send-email-haiyangz@microsoft.com>
References: <1644014745-22261-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW3PR06CA0018.namprd06.prod.outlook.com
 (2603:10b6:303:2a::23) To DM6PR21MB1340.namprd21.prod.outlook.com
 (2603:10b6:5:175::19)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 852d9192-8f68-4c68-30c4-08d9e8303bf6
X-MS-TrafficTypeDiagnostic: BN8PR21MB1155:EE_
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-AtpMessageProperties: SA|SL
X-Microsoft-Antispam-PRVS: <BN8PR21MB11553636CDC302A13B8F091DAC299@BN8PR21MB1155.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XELMGnA0u+dy3KjHegRLHuvx3tsZMEpgd3pi3psViVkHiEnCe8JFhpk6tGee9SpJRvH8H5dBz4q8533z7UhT7rtlEOaBYZ/UyM4jcuyBTEpw9Byy++Ur6AG8v1UVxZVOM+yxyi2Nt5zXSdqIsylleDrXzdquq0z8NSppwTZ/YtRKVUxJ4rvfYWq6NYVj/G5JXSChTPbDPzyzq4dZ2isiEJgicjA1hcmqsoO754VJNfWLMgifh10A1sLqLQj1skma6MT/epXAu8xSkGJMnl1BlMcuty1hK8CyKq1ey6X9reJ+CnalMgN7a3Qlja04uV+VeimMBq49OIH6XNXVB8Log7DiJ+unlhJTuFkNka4CsoWQvu12J7qypkNTjFidAHLxdGZQ4r4bX8h0zCviXbXF8I/k6RhhEj1JpmZhj9R22+0VB906G5xcaO+3Hb8qtPwJzKFMkpRKe7xHeppvClSstEmUxka0g9KTITlXVGsXaduqe5WSgweyvqBZTnLhdcIjSDKdxX2yuDTDE4MNiOl8u5G7hh78aichMGf8DvmloSFhifrapTgEsz4RAKk4lqEujDK6uBHSk9bCSdDriBBGcMsIlOy83eq1s7bLXG02eg3mk4Bgx9Xd19in/kTmnlZwptgdLm5WyVBwut6XEL9SwqbwnPUN8yoHHqGctxQaWOY7ZottRDrMlUcArh+POSl3N0rXh/NUPT4uckFFkHXnv2tZB0VT5NbHbSPUJt1UgWKr7syWn7G7Mknm/7g85A0A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1340.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(38350700002)(4326008)(83380400001)(2906002)(5660300002)(8936002)(36756003)(2616005)(316002)(6486002)(8676002)(52116002)(7846003)(6512007)(6506007)(26005)(66946007)(66476007)(82950400001)(82960400001)(6666004)(508600001)(66556008)(186003)(10290500003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mn2xtK45zGq+//qC+Y8+R3TL9oEik2O6uTviGZU2KM3P8JGJHG5k2XVWZzoO?=
 =?us-ascii?Q?jdZqVx846AOU+I2tGY0ipPcwaETX6wAzH5cO8+1cDoQ+6RfuSIy37xqCE+yP?=
 =?us-ascii?Q?swMVg8Dc2teIZx+MKJG3PWuF7dpROEYxYxgRhPg2pLaUmEetnbMuzgpsqD4e?=
 =?us-ascii?Q?5hl4fBSPdQGxR9FOKw6CF3GBLc1oV8Zgl/BNOFDSUeeu05rK66mCP4Vpa/8K?=
 =?us-ascii?Q?+9s2QQ3ZdCC+eIRxw5BgNhXad70ktG6qn1BS6VHNPNHJKEcbimSRwp8jPfmN?=
 =?us-ascii?Q?N/mnzbYlcQYyAB1zFSLBMGKLRrO00jRZoEtXgD9RvPEblLJJwIgAgH3pgm/K?=
 =?us-ascii?Q?vXih51gmkC7NiSW7nbUXnnfSz8sGQ7k/mF+Hp2L4ti6eDqSiioWN4T7jAhT4?=
 =?us-ascii?Q?fbaoIf1AIThEMom1MHIpfJ4wPYGhsNcY3yV/LzFZ9d2Anve+kuwKVF9wbZEI?=
 =?us-ascii?Q?xVtF5kn8PdzkA1OPx5POAILpR9ZtNtTrGeHr8F6pu9QiRFQlZUEm8TxoHavm?=
 =?us-ascii?Q?70fWCIKEfaS+ikHX2xEntlhDLxtdBkbwfVY1TAjMlvplPQimRyRhHkYPKUJ/?=
 =?us-ascii?Q?KZiBa43W5N7TpGbz1E4Y2k0tHXbKU7FMMZGUaO9hNtdL9rNkiTFu5R53hn/b?=
 =?us-ascii?Q?aMydedUOUwsrg5k7FXpm1nSN9RC3jVK4IXrqqo4jkPPk2Ch2s064nmXW4gNS?=
 =?us-ascii?Q?HGHMVLTnjYo3LiUoMg3BSgsk11rMeHhbMw60RBdYmufl8aNn2LP2dpfdTJq7?=
 =?us-ascii?Q?OWviCp37BGpPC3o+jUHi7kbWlVvwcu5i12lEj/RNaAqQNf3+UzoFXjguI71e?=
 =?us-ascii?Q?5LMe4pgrS5BEoqGm7ZxAccfHYMCuhZfaS3w/udLNguo0AccovJsLgeR5Z/oA?=
 =?us-ascii?Q?Ykb5A8npkorJEhiB37F2fxUCOEo17uuQhJ+iaYVoOAv1Cv3+4uTlRjFvWz9Y?=
 =?us-ascii?Q?cu86mW8TdFSIGAPpDa07wt7N41Nwd31aH8McmWvo1qtqBLQBJ5IUgLvx93lx?=
 =?us-ascii?Q?YkEjncaatQfOLn3CHxLjN+qKng2rWIEgZ/+BlIDpSN3i243TmAJH5VAosvfv?=
 =?us-ascii?Q?j24mk0LhPzhlhPeO5lusUV9Yy8MWZvuM7FUQozmqGkMNnggBrxc7YYLSMEqf?=
 =?us-ascii?Q?IhRYwZbzP18EDmTerVb7KrQ8Tt0aSUBlh2d9I//O8RDDwg962uL+17wBrw1f?=
 =?us-ascii?Q?GRQngY/YxBQgRgtUhJx/DkzDbJCZsHkWLBOGcs5OYvdoLJkiokARVyMMdDiz?=
 =?us-ascii?Q?cy4P5mcGwo22YeLHQ6ikzzYYz8/zoDxawCqUX/3VbzLSv7seJnMiORsvJbdH?=
 =?us-ascii?Q?R4f+8dUIKYKqKW2Xqu15w6NBkvkkXX23Yjbf6tBxGRtp8rsG5gyyvhllPG6z?=
 =?us-ascii?Q?sWCbyqAYZpzmbdwyB6n/3maxguc/Fbn3b0ZPrj8vPuyJprUZ1LEykVTUAgN2?=
 =?us-ascii?Q?jQ9BOaON0PR3yIjyMrddIl7rmmavi7D/SlFx2Lna5jz1YAiTT5kdhAqHGO4U?=
 =?us-ascii?Q?Whmso846JH4K4rqGSpCTMaYhz1D2cPRnMAtYNb6Sk92dSINF+TdnPvu+P+8c?=
 =?us-ascii?Q?0cQJWXFY2RsTSoZbmkzrKUwemNiBf8dLpohK+gZtApi94JCmQCznka6Ibcpy?=
 =?us-ascii?Q?EEuH04HWvPLCMjIaNOwHwQA=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 852d9192-8f68-4c68-30c4-08d9e8303bf6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1340.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 22:46:51.3749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M8/7m1ZsM2nmWZyyg+1wrt8f+JwN7d6bPzxbwcpjyw+aqyLiuWaPl7GcXW1DYmCUs57jnrsEjaXfn7CtiRliuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1155
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The proper way to drop this kind of CQE is advancing rxq tail
without indicating the packet to the upper network layer.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 69e791e6abc4..d2481a500654 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1085,8 +1085,10 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 		break;
 
 	case CQE_RX_TRUNCATED:
-		netdev_err(ndev, "Dropped a truncated packet\n");
-		return;
+		++ndev->stats.rx_dropped;
+		rxbuf_oob = &rxq->rx_oobs[rxq->buf_index];
+		netdev_warn_once(ndev, "Dropped a truncated packet\n");
+		goto drop;
 
 	case CQE_RX_COALESCED_4:
 		netdev_err(ndev, "RX coalescing is unsupported\n");
@@ -1154,6 +1156,7 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 
 	mana_rx_skb(old_buf, oob, rxq);
 
+drop:
 	mana_move_wq_tail(rxq->gdma_rq, rxbuf_oob->wqe_inf.wqe_size_in_bu);
 
 	mana_post_pkt_rxq(rxq);
-- 
2.25.1

