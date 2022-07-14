Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF2D574696
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbiGNITp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234563AbiGNITl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:19:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2123.outbound.protection.outlook.com [40.107.94.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6B51F2EC
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 01:19:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJzx04gnoR53p62t+rC71IVaT4xe8VbVpye5xoOSkzSLLBRKRf9g9PABdw9/bTSXTQHk8+h673Bj6dnR4O3iFEeS0AgKKyo01iTuzqWILAlmhv7sQ9wQTfYH9M45Sl3CVv7jBSNbQBYSju3nUnlXRhlbYAduCP3Zb/mBomyOKQUT8H03qW+kF7nHHfNVtgX1lbMaXBXriex/+PyuB8KMaXoAr3XX8kymsra9su2GCaSU8VKIZzuBs+QpKQpDcGCnDnoXgPVkPgq2wsFTm+UO0gtDpbf+rzf/P63wn4lwxTMffGDOXDzTlETVyMgY97rBPSDForN1HAHuAdN8cmvpeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4qZ86DlTzFTYwuw3jW9Pqi/87K/6ijjHbT8uvEuSOQ4=;
 b=NiOZim5nb3btkI3pVYU/3PrtidNvR65inGp+NY2e8E11eYT/S7KmNUrefeXScATQBOP1jSjvCHzNnbUnM9rDhdLBpdMQzjWwTVydZiuan/aUuwLF+e4u/v7ptcx0pJVpRVqswXhjhN5/tNVpFc1iQCYLZxTMb0ZBnVRdDHbWTg2bA7i/2Ie912ojAIvWkhZbXFd4hno24Ly9zzsw9vOfGAdixgND1Pzr1qxsvmpFklZJFJW2Fw5K6qzF8jJjnvFtrK6P8UYX0QYbY4nkexbXWcwozR2yVlgkRjBxUfT+3KRdFsBAekpz4san67htISAr7mXkOOk01xuqbYPP41lJhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qZ86DlTzFTYwuw3jW9Pqi/87K/6ijjHbT8uvEuSOQ4=;
 b=vPsaPBAnA42aOcRTSq7CYaavf2qkZzTrjkzTuGwZCILRIIwekKhU4jqe0P+33493hfFzKSbQMvczcUOGcM7eXPyo5QBVSWDVst4HU8m8gUHuJzJeTye/QL9vDET/gODNHpSx28hBgaOa9r6ABqFzMqwmljk5bI7nbnIzewmsy4s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BYAPR13MB2855.namprd13.prod.outlook.com (2603:10b6:a03:ff::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.11; Thu, 14 Jul
 2022 08:19:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2%9]) with mapi id 15.20.5438.011; Thu, 14 Jul 2022
 08:19:37 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net v2] nfp: flower: configure tunnel neighbour on cmsg rx
Date:   Thu, 14 Jul 2022 10:19:15 +0200
Message-Id: <20220714081915.148378-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0018.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e8059a5-9e3c-4c87-e15a-08da65719772
X-MS-TrafficTypeDiagnostic: BYAPR13MB2855:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6GiJWDM4z/xYBg/P9dhj5dPathnNlGjwGP7Ud2FOVEMTK1/uKVVIPKJSqnZtEYknkK0xPUj/yrYP2BAcF2DQiYyVULsc0d4CLayfxh0VnL6e9+vifBBqcbcxUEiXSj2fCkkYGXKnP3u/8znk+3r+PnxBGle+pG2z8PoLE5usq9DhOKxCkIPT9M7CrOrLCc/4m25ZUYoDoq0ub1VO25/HV6X0plEUwwlGNgQW4FY3rYsSGf9uTA9LuLjJIqkOShyOZ9UgB0ey1/6uAQmkWoO4Y2Y7piwqCZ1SL5FaYbdKMbyqhUkX9nLIZmXx5Z9p1r9Bjana/ZS5KYIpcP4TeNzeeHvqCwbbyw0odtkfE0qaIofVz7a2sbcgFeXmaZnUN76opG4YwkwbixKoVXOZcchFUFAyP/4z+yI4q9SbQpv6lMVK30WSJycxOcvt6zPIRp0rmVp8ajZ7TFTKLMdYq65zNGCXILNaw+GQnZSn9+dULXUpDg8WXscV9tk6dtuBGvOS/xvAY+ZdNfD680X4e4JcBCeaXJr8TRHD4a4PXSPZRST3TCCp9FhBtw6IaiFdsyH4f5xg6zftygPxoxW+SG99m/mZdBYc2xP0UDr+Q3igNSfLa0cDBzW+uCDNd6pI35JpHp+Qit3HDYTDCtVjnW/2YpfE65lFqRAMFatYy+zx2/J8yHecY1MlyP2kM90NLuPJDeJdIcpBYV/wKX1Hg7pJXkF/NtUwV0NkV6gWPnxl1jfm11FnVNlbe2WiBqeRczOzek7TO4/MOwby+WJu6IoDlfmjO2okjK+TD6TUm1+ovCY/HdyX5CE7cZUdlIGeHZs0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39830400003)(376002)(346002)(366004)(396003)(136003)(186003)(83380400001)(36756003)(44832011)(2616005)(1076003)(38100700002)(5660300002)(107886003)(86362001)(8936002)(4326008)(6486002)(66476007)(478600001)(2906002)(6512007)(6506007)(41300700001)(6666004)(66556008)(316002)(8676002)(66946007)(110136005)(52116002)(83323001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?40oQBsYIcSut0eUTalmQyoV4q3eTw7mOuBMuRWdfsHUk3m5eCk0pzqCJ4U6v?=
 =?us-ascii?Q?3xIM49EkEFRjXzwozOz20LrZYiSqSiz0NtckZg3fGjq8Ricxwel75biE+mQ7?=
 =?us-ascii?Q?eHupdhuuQhznmcqxBOkWN+sKED+QrRNBBEn/NXsHXt/0FTo8Kw6+VuOVafDl?=
 =?us-ascii?Q?zFbxAOlBioTXAuRp3a6mbxWVzixVOJmMDN0KOYLOUO59XkAbZjyNHXuQDXh8?=
 =?us-ascii?Q?ttM3XSx76uq9soVf4OxgRO5sPVF0Im2j2Er+3LEBH4UL8nv+5yKuLswub12Q?=
 =?us-ascii?Q?gRtPbpSSItpIqLOOTqtGlon7eJwHP8MnOjd9AUH2Wxv22aJjLmDvSZb/HcaM?=
 =?us-ascii?Q?yODWcTqz061f2pAzOwQuHRHq9VNqKmqha0OvVZ9GoPIkpL1PDZblESMhSLix?=
 =?us-ascii?Q?PNueIUaM5oTi6GEKCMw8XpF0es8Mc5w/XvLJibhF6i0Pot7ea0u9QvZOz8ig?=
 =?us-ascii?Q?fcyPXoy5FgDPQ2/htKb9PBmOR3xhtKUlRxYfIBOOUKrJ4UI6NMJGttCl8L1R?=
 =?us-ascii?Q?iWJk78W8+qSqyAX/p7G8i+iTdz8WGrf4Y8326r+46NuTtL51VPUDJQb1svqh?=
 =?us-ascii?Q?YSfAS/gIYHadPJoUOnurY4jwnLfv6wGl5jJKoS0xmWrVcIe8PCDs67hBjH5M?=
 =?us-ascii?Q?pWfsDCZjx6peVad272ps8/9MDOpzz5VUikIQfy9amM1Um76KeehVlIwcslUd?=
 =?us-ascii?Q?7KjuyrPOBtZxYo8poemYB7Ww+opN/fwvpCUAp+TuNJoouRzwVxiVIAqO7tFo?=
 =?us-ascii?Q?IXVwlTWNqV3azbUVwJNqvSzNj2ZmaO9JcJBlnqus5M+a/8B0IUsfRBc5fCVO?=
 =?us-ascii?Q?QoRV8gKLq0yhlzLZOmM4xOlTU8aPDTEmJ7fwVNwNM9tyKs6x813eqLn5B6s3?=
 =?us-ascii?Q?Xkow8yRmkms7c4+AfRr1dsBUQ9MBKNFsAxwfCKG4hfsCbOaIqbFDUS1twa6g?=
 =?us-ascii?Q?n4VrV/6KpGkXwnpY91EEneys/WwuVqn5YlMs0/dx1nT9NUbEB7cVInXDFDxk?=
 =?us-ascii?Q?Gw7HFVzS6XWRLUmwLsX5osErywTSjOybOYruD/whGipSme+ihrrGkOWTV+PA?=
 =?us-ascii?Q?9No7Isl0b9G++ynP+qpSKuSR1d9Rt10r9iUyp8DHbuT60hIjal0xrQPGaa72?=
 =?us-ascii?Q?7TJJ1RwzGt+8pLRC+S9ySe4m5BUxrVqCfbyxHKv2HqPudWB8ERHa5l4CaNaS?=
 =?us-ascii?Q?R5cspE6sVcUdaEZC7nHj3IFzfMMlBij+2aTk8TEUkwA2ueZLds//v6HF5LM6?=
 =?us-ascii?Q?UlkT+6SeZXIXebtDeo+lvr5OWYEGli23wvVWMYzoU+Wt46bvTT6rePdxUsFE?=
 =?us-ascii?Q?CD1ZPmq0mwepfMKeaK9qyT46lz/Ly4ZmWLVwLXeMWLPPqeKGIBhTh61/+s/i?=
 =?us-ascii?Q?Z7pRusEwYfKpFopddRA2e2f/8jMbACHTO3v8RT/v+n8zK8QS/1Sbjjxo6+72?=
 =?us-ascii?Q?Ow6fPqr3MIwnBYpdS+nOTM9YK2VDYJ9cKdvYJ/bR+ndWNkWWCnujT6NlXoL8?=
 =?us-ascii?Q?27wyOBRh8ncwpS7g0rMQLuUcCWVBYJT1XkDIL4Ak8CCSts77yoZo+4N29Ihb?=
 =?us-ascii?Q?w/8khfEs3imU7MFNavVzB0KUNCy/6rsC9o3/HqUoDPe4kk1GR2BpTb2On69D?=
 =?us-ascii?Q?6GZph5Mu39DjsL1b5W7d+0KiYI/TTMduk/C46dmTXpZ/GFaiTfjNdM9y6Akb?=
 =?us-ascii?Q?7ssz+w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e8059a5-9e3c-4c87-e15a-08da65719772
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 08:19:37.3882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eS5JUgL8J6CmJa5HtiuSkCi/YJfYCTgLolQLSeOygpsVrSA3wTDG6xlzAlnvfekXEtksl/jumj8tqMDvPxB7QuSOtvWx8qkzqCgdLRxKvBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR13MB2855
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Yuan <tianyu.yuan@corigine.com>

nfp_tun_write_neigh() function will configure a tunnel neighbour when
calling nfp_tun_neigh_event_handler() or nfp_flower_cmsg_process_one_rx()
(with no tunnel neighbour type) from firmware.

When configuring IP on physical port as a tunnel endpoint, no operation
will be performed after receiving the cmsg mentioned above.

Therefore, add a progress to configure tunnel neighbour in this case.

v2: Correct format of fixes tag.

Fixes: f1df7956c11f ("nfp: flower: rework tunnel neighbour configuration")
Signed-off-by: Tianyu Yuan <tianyu.yuan@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Reviewed-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../netronome/nfp/flower/tunnel_conf.c         | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 6bf3ec448e7e..97dcf8db7ed2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -447,7 +447,8 @@ void nfp_tun_unlink_and_update_nn_entries(struct nfp_app *app,
 
 static void
 nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
-		    void *flow, struct neighbour *neigh, bool is_ipv6)
+		    void *flow, struct neighbour *neigh, bool is_ipv6,
+		    bool override)
 {
 	bool neigh_invalid = !(neigh->nud_state & NUD_VALID) || neigh->dead;
 	size_t neigh_size = is_ipv6 ? sizeof(struct nfp_tun_neigh_v6) :
@@ -546,6 +547,13 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
 		if (nn_entry->flow)
 			list_del(&nn_entry->list_head);
 		kfree(nn_entry);
+	} else if (nn_entry && !neigh_invalid && override) {
+		mtype = is_ipv6 ? NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6 :
+				NFP_FLOWER_CMSG_TYPE_TUN_NEIGH;
+		nfp_tun_link_predt_entries(app, nn_entry);
+		nfp_flower_xmit_tun_conf(app, mtype, neigh_size,
+					 nn_entry->payload,
+					 GFP_ATOMIC);
 	}
 
 	spin_unlock_bh(&priv->predt_lock);
@@ -610,7 +618,7 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 
 			dst_release(dst);
 		}
-		nfp_tun_write_neigh(n->dev, app, &flow6, n, true);
+		nfp_tun_write_neigh(n->dev, app, &flow6, n, true, false);
 #else
 		return NOTIFY_DONE;
 #endif /* CONFIG_IPV6 */
@@ -633,7 +641,7 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 
 			ip_rt_put(rt);
 		}
-		nfp_tun_write_neigh(n->dev, app, &flow4, n, false);
+		nfp_tun_write_neigh(n->dev, app, &flow4, n, false, false);
 	}
 #else
 	return NOTIFY_DONE;
@@ -676,7 +684,7 @@ void nfp_tunnel_request_route_v4(struct nfp_app *app, struct sk_buff *skb)
 	ip_rt_put(rt);
 	if (!n)
 		goto fail_rcu_unlock;
-	nfp_tun_write_neigh(n->dev, app, &flow, n, false);
+	nfp_tun_write_neigh(n->dev, app, &flow, n, false, true);
 	neigh_release(n);
 	rcu_read_unlock();
 	return;
@@ -718,7 +726,7 @@ void nfp_tunnel_request_route_v6(struct nfp_app *app, struct sk_buff *skb)
 	if (!n)
 		goto fail_rcu_unlock;
 
-	nfp_tun_write_neigh(n->dev, app, &flow, n, true);
+	nfp_tun_write_neigh(n->dev, app, &flow, n, true, true);
 	neigh_release(n);
 	rcu_read_unlock();
 	return;
-- 
2.30.2

