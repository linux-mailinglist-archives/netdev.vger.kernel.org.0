Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E856670E20
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjAQXwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjAQXv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:51:56 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2082.outbound.protection.outlook.com [40.107.14.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7C34FAD5
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 15:03:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kW/vlfbjgxiHD32Bas0mR6SKYiRvGXsmSmtOfHXb0NpMEPM5bLuJOps4XphAhUkIQwJwBPGmpZK5dbIE5QKv8NXyDdFitDZtRFjNNyf/K55wFUNf4qG1XXQzveTiDEAKEMCngEX5EspsjFCLIf8jlOXw7QZXc/CcL26yfAM/YTCS4bEa++Va22Xf/CwFsxEH9Yd1BwCGt93zvEJwL86gRobcvOy8S/OL0vTdzX8M9/aE0UmriDsYD/Ym2qgjUZvtjzZS/FOEusg+9P7hyOOruC9BO6E5zpRmccGO9nhWd7BtIJBvdWXitn4jaT+mY2NjJPJByqL4h9exb/iGDw9eKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DSrkGp3kkCyg7Q8Nhx+scLiixeVXivqcG4zpjjGmsJY=;
 b=LURlZqgFqiYEcHXjnNM0TpLZqwGeBdoSc55rUrqw3rtri5iVmseg8a0YzWLm/3RG5xfGXIwzAMwkqK+4W2NSzy77JdE7ikQzXnKnoVYuYhXQlbLqvCjmvgrkdUPmAPBVpqMI6QVrJnFTSiRlBAq3c2rMJO8tAw4iO8akq0QRNwwZyWui/EjRNMPYqQnkjX8RhpvZnmUe2pKegfOiXB7AHHtAL52s6UyiaLd9V+68TT2vIvWPpEBrONDSeTppXJofoFlr9Bc8hQJ0JJJyaIdwA6R9I+4ZM73ej0w3ib5l3SwPeyoM5/ZGxBwJVzhd/8vFhi0cMi+Kp3rcKHlshGPpBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSrkGp3kkCyg7Q8Nhx+scLiixeVXivqcG4zpjjGmsJY=;
 b=IiBSs7PBELRrlGL9MvWEKtLRo1qZN1MP+CK6cH/Oux7N2qJskV8fmaudzWPv+RqZvkSLUtvVL6ICVBmecA+uLR4iwSghCkb00YYwt3le64BWFGnn5W1k/iW9bqs7gR1H6eRPzey+Gtg+w84IsCZAkg+LyOg1gY3JA362ZLBD9a8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6808.eurprd04.prod.outlook.com (2603:10a6:20b:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 23:03:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 23:03:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 10/12] net: enetc: rename "xdp" and "dev" in enetc_setup_bpf()
Date:   Wed, 18 Jan 2023 01:02:32 +0200
Message-Id: <20230117230234.2950873-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
References: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB6808:EE_
X-MS-Office365-Filtering-Correlation-Id: 63e3f6b4-55e9-423e-30a1-08daf8df071d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BdNcUzOSeGlL/SU0YdVHwpREwwvRMvqni4NjHaS/Wo8AhHQguIMKCvtlFyT1ZHKA4pu4MOiTye65cZjBQQI7QjkWb7cnyYcComOOYyrUXhiXnMCD6qvAq4fGHRD/9MzWGbMABZYA3F0aJuLLMAJ7sChvJsArXf/FSibpMuEJh+/QScCG/gnQw4sMMFEvv7bFxab5RIFIAAoaINw77C2hdf5HQSJdJgCB/JB7q2R51M/4XR5GENoi4Xd2Jo4YDNczLyoeVAjAoD2zOdkh55b+887XCU76gbrAb2YCl2ELyWx18L+2UytnB7O1L/6/rdcFnrHssINtIPE51GD8QUUEmzYIrYlnPtxh8TXKBRifBdNEL70BdV0fUjm5G2HKgoA5y3/JpK0To+ARsxkrTT2G47EVnCZA0fINcIRmlmNRVKZArCRHCXXvYpTwKokvIO1bQb6q/IzTKOH77qlmC2/lKH3OSElnJ+DxyPyVxhMoKrCRewWsLoD9Cj5lcH6VEtP9GQ+fzX/nw9/H3sZ54+XTDYFnJNN21gK5hQn1bA9xdk+9Ho/aCg6tr8ZKLSs6kjPjHwbd5PbeWM1suzST5T+X/TzWkGDzuPZVeNugFsw9KeSV7/RZuusfugwCVBJX9byWMU98s6ydfusb6fgCbt8lPEDjesP8trt3s1QNwPHHk+2HP/6ohxGavfrpZMlOcctO7sH5T3bbMg92NiJCfp21AQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199015)(86362001)(36756003)(38350700002)(6512007)(8936002)(44832011)(41300700001)(5660300002)(66556008)(66476007)(8676002)(66946007)(6916009)(316002)(4326008)(2906002)(2616005)(52116002)(83380400001)(38100700002)(186003)(478600001)(26005)(6666004)(6506007)(1076003)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1IYx3Aa99MVqmSh08Ig5Aq457Sw4GyCuuj3GLFm+yiVmUWvY3Ah10WE5/AVy?=
 =?us-ascii?Q?rsJMEio7AEj4/UIDPcA4TWzD52PTypXwLQ/ipf6161/KRDGFEwr4efJg+7n8?=
 =?us-ascii?Q?QGxyUDVCJ+tNuX1KG/YaZdeAJ1rngAulKV6VD1ylWQ9zgEAc7uryPzdeeZNP?=
 =?us-ascii?Q?LIdiNmhrhso+IMYupjV5xguZV4LJ9H1kngZkOqrTt6SmDW1dtdOLgv8DFkNY?=
 =?us-ascii?Q?aVlCVPMglYUMTDAbwoWS71dmkVcB7e60In9grVf4idM2j9K3HKTOqokK9O4T?=
 =?us-ascii?Q?7534H79jvhFnZsp3ulAC1VtiQenq4/zpeEBDkK56D1iO2DnRYOFaHN5vUiNm?=
 =?us-ascii?Q?ezak3Oh+rPP/GlcNx4HUwcnX2y/LbGZtXdAtozCmmsgdWcAmr5gpU6DzDNTK?=
 =?us-ascii?Q?GInoAn+SRe9fzIGH/mZI3Ib9HCN6+zkLOQj/en3gsh8fl0Q8Iv1PR0OanX1f?=
 =?us-ascii?Q?jhjmzRcu/wfMGBeEmrDE2eQJFyc/zH/7PquBwXBzYkkftP4G8GbEO+U2LEGe?=
 =?us-ascii?Q?k0/PA5dAXDTLkvqdVA6hY4isVv0AyKeM/FJF6jFxOUdVPLrnveWNnFOPO4Id?=
 =?us-ascii?Q?J5BoFiHrLQgRx504wiwykadnBeTOWKWWUpQwAi17GWfkbJTyZFkzIQXzToJB?=
 =?us-ascii?Q?mrvP0JBsQR3tHfqBu/MnR6kWYlTMt9M6eJNyq1I6G1GyyKzSFvR5f9zI/9e4?=
 =?us-ascii?Q?7h7YnonzWJKkuqWETJ6Ws+QcWjhiVUMxEhGwiGC2AyFWTCNxxS4noUDquqH1?=
 =?us-ascii?Q?i/knW2qMM0T0HBpOMkdTmYXG7HWAaPjpudDG4MN1EiqRMOuRaYpkRCyn/7qw?=
 =?us-ascii?Q?Ut1CvoYsxb392MIlKK3kRHkiuaFzkt78zk2r991zYt3/AX11F7UcKnlvces3?=
 =?us-ascii?Q?dQWDCtLSiW2i3vmFfUqPkC/j4eb6S1wdDVd1njAgiuzkiIeItwmZaHPvqWmH?=
 =?us-ascii?Q?LTSlOa/Nb/pAWGzRlfaQvx8CfAjrLK+3T8MaislaBewlIZ1EAmE6Ol4O7YA7?=
 =?us-ascii?Q?nwtBuGxmeBR9gcJGaP/KnAkGQI2/HmbUJXWsYFBcJVd8yvBMmSLcTEgsSuo5?=
 =?us-ascii?Q?7If5TbKGR9Vct3mcZ6g8xR/STfvOJB+v9FfkT3llPpwATgHzBC3NtaJ5GLGo?=
 =?us-ascii?Q?7lQGTT+5cU6thWd7KH5i7/qrH842uC4ist/nyYXuMjCNsNARwNsM3+ePyNkS?=
 =?us-ascii?Q?+1xgWxzxGuyk66PN94tMNPsNiCu0gC/ILTH3k4cImf5diXxrJsxA5gOaZVdn?=
 =?us-ascii?Q?DOb/CAmmXq9NqUUjpv9sjKemRvpZx8B4wkzm5c7GloC6qlIOVGu9gq7N7Dx+?=
 =?us-ascii?Q?WtC4u4ecP6x0E8Mmf8P55AM5d/GPukimdfVG8L2eQpNdMWYWEHGPMJK0axXM?=
 =?us-ascii?Q?It8l1N219V+Y2lYORen8rP8dz3XhW1P8PEyJn3Aa2kGOSHu99KWGxJzhPiyp?=
 =?us-ascii?Q?IpYHTwqSteAzji/HZ+HMG4kFaQziG6ir81GHy1T+5gNSVatO0eyuMnVxOzUN?=
 =?us-ascii?Q?8acWZVFmtk5hvb7PFrKK2hJikVGQvB+DOEOJy1wyifWOi+HQYHJsLLP6poov?=
 =?us-ascii?Q?VsA4Zi+ssm/kUHFuh7OzSaTv60z0dhmYM0YHuxZnYa1GfC4CUDY4RwRvknre?=
 =?us-ascii?Q?5w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63e3f6b4-55e9-423e-30a1-08daf8df071d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 23:03:21.0532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ygY9EaXjBoJJo4WkXJwq59fmFdlAGNx5EPAlgH32THu+q5WWzrISs0dPn+T+gbHewToOTm2s/6kvfYLJNsD7uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6808
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow the convention from this driver, which is to name "struct
net_device *" as "ndev", and the convention from other drivers, to name
"struct netdev_bpf *" as "bpf".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 16 ++++++++--------
 drivers/net/ethernet/freescale/enetc/enetc.h |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index dc54fe7b4e86..ce3319f55573 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2586,10 +2586,10 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	return 0;
 }
 
-static int enetc_setup_xdp_prog(struct net_device *dev, struct bpf_prog *prog,
+static int enetc_setup_xdp_prog(struct net_device *ndev, struct bpf_prog *prog,
 				struct netlink_ext_ack *extack)
 {
-	struct enetc_ndev_priv *priv = netdev_priv(dev);
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct bpf_prog *old_prog;
 	bool is_up;
 	int i;
@@ -2597,9 +2597,9 @@ static int enetc_setup_xdp_prog(struct net_device *dev, struct bpf_prog *prog,
 	/* The buffer layout is changing, so we need to drain the old
 	 * RX buffers and seed new ones.
 	 */
-	is_up = netif_running(dev);
+	is_up = netif_running(ndev);
 	if (is_up)
-		dev_close(dev);
+		dev_close(ndev);
 
 	old_prog = xchg(&priv->xdp_prog, prog);
 	if (old_prog)
@@ -2617,16 +2617,16 @@ static int enetc_setup_xdp_prog(struct net_device *dev, struct bpf_prog *prog,
 	}
 
 	if (is_up)
-		return dev_open(dev, extack);
+		return dev_open(ndev, extack);
 
 	return 0;
 }
 
-int enetc_setup_bpf(struct net_device *dev, struct netdev_bpf *xdp)
+int enetc_setup_bpf(struct net_device *ndev, struct netdev_bpf *bpf)
 {
-	switch (xdp->command) {
+	switch (bpf->command) {
 	case XDP_SETUP_PROG:
-		return enetc_setup_xdp_prog(dev, xdp->prog, xdp->extack);
+		return enetc_setup_xdp_prog(ndev, bpf->prog, bpf->extack);
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index fd161a60a797..6a87aa972e1e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -415,7 +415,7 @@ struct net_device_stats *enetc_get_stats(struct net_device *ndev);
 void enetc_set_features(struct net_device *ndev, netdev_features_t features);
 int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd);
 int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data);
-int enetc_setup_bpf(struct net_device *dev, struct netdev_bpf *xdp);
+int enetc_setup_bpf(struct net_device *ndev, struct netdev_bpf *bpf);
 int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 		   struct xdp_frame **frames, u32 flags);
 
-- 
2.34.1

