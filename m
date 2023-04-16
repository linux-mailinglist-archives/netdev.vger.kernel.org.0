Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87B16E35D8
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 09:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjDPHqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 03:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjDPHqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 03:46:23 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2058.outbound.protection.outlook.com [40.107.7.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F1E139;
        Sun, 16 Apr 2023 00:46:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AR5cfhxjYrw681AdJnClBZmG+cJ6PjZFtDnxt9YpjwQt9XSh+wRJUFEWxB+z3mcXJl+IswmVMz7oVD2uDUfO64jmmL4lqPHbY5cs67di49j1BMAGs8Ekq+kFWwCUpI5Sx+ysMf1lvavP1xKdotQ1kP7PQkqgZcNW15bwkD377D0qq2AdzhVPQZtm9snOE/07SGIL+rvw/537Dtyr+DSRTysJ5f/rSd4Adyd3j17p2t50pVPG7E6am7vklKAZw/1rA9qLfDkB+WznasSsShS5YiUU7IaMAvJkKsqbcVg7u7y5f2Y/sl6w1N5tvukJadtQ4RZTst5kToinIcAAIM5RYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VoF2+3n9Q7bW8egga9DXHQVXoNzzkhO/YBdxNz0PPCw=;
 b=fK1X1kxmwgJmsN1LVV7LqjiCSU+fQwmV4l3lbNrNpHLNH+ZLqYRHYFqJIiDM+UDawmrcvoTShBODuzbooUmmwkNg97EsQLoDFKBIVwzTfHgMWrGDWAN6BIP27Pe9+YeN5qVso3Im46l7qC6TLlQ1AKhk0LCELyQ1FpSNS9PpN9Jlg4qEckzc1dhXfFSRbQGL7RSPWo+DIkX4rt8XJHzxxhhuW4mdzaZWtKpA8ZuoI6y+Qbh+3RSr3Xh69wQxthxKqzcUhaEEjqkKS9NpvUSQE7/i3c2Yxdv0AfM4LsFOFkQiX5v+9ILPCTAcsUO2kIMNiwdnkEv4G/YZb0ep1jW2KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VoF2+3n9Q7bW8egga9DXHQVXoNzzkhO/YBdxNz0PPCw=;
 b=qpqOlNCVIOrOwPq4rnNTHLulnX7WyMJeasIdYfUEh3wJHL2T4gLoJ7pLu/XsU6RAmebbU21kzZOl6+QX8jvu7Dzosfv7OL9GQcpiFkrMJR6zO5s4ZE3ouNhoUZyaeOcF89gV/tOliGsSBG012Lv3oiZEU37KGiz5TwVhCgTiB3k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by DBBPR04MB7740.eurprd04.prod.outlook.com (2603:10a6:10:1ee::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sun, 16 Apr
 2023 07:46:16 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977%5]) with mapi id 15.20.6298.030; Sun, 16 Apr 2023
 07:46:16 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alvaro Karsz <alvaro.karsz@solid-run.com>
Subject: [PATCH net] virtio-net: reject small vring sizes
Date:   Sun, 16 Apr 2023 10:46:07 +0300
Message-Id: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR2P278CA0046.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:53::19) To AM0PR04MB4723.eurprd04.prod.outlook.com
 (2603:10a6:208:c0::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB4723:EE_|DBBPR04MB7740:EE_
X-MS-Office365-Filtering-Correlation-Id: b85441f2-0206-4b3a-7cbf-08db3e4ea8ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nqy/+GIdFozcjyW4AiMyX+xQNpWo/xZiWxdQipm90uG8YgDzUMzVFkRmmC9jeDuJYUmRX5luO/UhQU/J34FLZlbXP0JUvhkDidOO9kjsXmcD/HC3Hd90NRX1+pHcqMRSuQC78xP0a5EXX60RFeX7f49Ef4x4ikR2fd+OtZbhvV9a5N1HLXkz+Kq83Xc4djVvk79DsDHRBxi776fj4ptZw7S4T0rMkGdxwJZdOrXWV/uNaNMKExzCVhDgb9zyBRHJfoJD39ekoFPC9zla3H0uWJmJ/FYalmG3QX26/z+pTdtTJD3fnI/75Bwvxizurg/H4dpEGwNkACd5Ok0ZVxeR/90RsZxskgLNqOOzcw5kCv80kanxyfVryuxHO6Jwf/GAoCgFCwfaaYwnuSrB21Jaj775z8l8oC0Re+QDygmN0kbEUjNydgtIJpmeAb9WP3/mlsuvg/m9J8FJA27h2UU4XEGAqt4yNQ1BO4YocNtX5zBxQcTsyM+QdDcKcL0rEu/Akr9jpXK66VVTEsICLYGUAYP8WhvtvpSN8ppDXEvTOWnPlYJeGlF3C5Mv3IKqdyOpQ+TppoihJXL+v2VSveiIr/S7DlJ6bhiUC6QACYRgJrL0E1IMfyLriAMQwmhbWkDa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(39830400003)(346002)(136003)(366004)(451199021)(83380400001)(107886003)(6512007)(6506007)(186003)(26005)(1076003)(478600001)(2906002)(8936002)(8676002)(41300700001)(5660300002)(2616005)(44832011)(66556008)(38350700002)(4326008)(38100700002)(66946007)(66476007)(86362001)(316002)(6486002)(52116002)(6666004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sChBIsXmL16FRWXflpLaD+ZnqN4Ebgw1SRZuFLIB76ek7pVrphkt/QVZk6pI?=
 =?us-ascii?Q?5HHtvEauMgPYpN3teZcG0AUSoPpODEKLtY+2Zkd9XgcyLGbqxIOVz65kTBmu?=
 =?us-ascii?Q?GSjdMABuAPaEYryHuC7yJn5UVYRo2X73TmGIYv7LkChX3mFEv4+al0WLmVBS?=
 =?us-ascii?Q?RyTiKSQ/chzL3z2i57LAiJxA/JRqHvhLBHPVBZ9y9FnIvXopKEePt/eoIu9W?=
 =?us-ascii?Q?79Oqtqwh0vr2aCEmNK3JGs+UqxQFby3kWxmLPXJ140RTO6xyDGWBZEb0N0FO?=
 =?us-ascii?Q?26qX6CJyEGAGsGvSjToul9wjl3GdveZAOaY/ZvFeaNTt1RNA70kb3fym4FI8?=
 =?us-ascii?Q?HU/3Kj4TrPwUvlYMCvClsMSUjCvHZmUGmHNg17hXaZcLy6v6dGAR6+ubhGnz?=
 =?us-ascii?Q?+amvaS/W/yJ6q4T70pL46egB084n58+nsgQ64j8tiEtllMbHe0ed6mf4D0jd?=
 =?us-ascii?Q?AJMaP9TopwNElRNiPA2WhVx3TARIsHr9LjD75TUdy4eLiCCD1uIMZ3FZpFQn?=
 =?us-ascii?Q?xtaUlAoRz+8GNEFZXMpCdCXjNooJgVfq3AEI/Ff3qYZaDLKXzcKOXmyWRcRK?=
 =?us-ascii?Q?nguRg8ZCzVxyFMg4HIFzRYf1kVrG13caVopovtIAAlMJW51k3chDPa2Vww7Y?=
 =?us-ascii?Q?sBIy1nOJbxcqwW3LNIIajAFzgI3l6qraqBLwovD1cGUfaGcBBnskllu9zRr+?=
 =?us-ascii?Q?jzz5eIH3OsCtcPgDpBnz5SEo+iOppxwU2mXGqGfLHvXjQG2tR0oSldAjteqN?=
 =?us-ascii?Q?GHOb/hscBdyzpYYZ3lb2CrM08bOudsQ/0ZvxIBFgjVbyzllhn7LZl5r7EA6i?=
 =?us-ascii?Q?IxIwBdAMq4jYmlNikN7ijXuIp635RuiOaP2Zv1dkB/lFjqqvwLU4v81WbNA9?=
 =?us-ascii?Q?vhn59Hq8N8j/oImJvFunDN72Yurx0X1XhXgfieuhdzKZVEApK1nKi4Ztlbsn?=
 =?us-ascii?Q?ilnDbhzyq/68FR6eS49nvcqJyF4XY5erDqb3F6UERN44n1N2fur6a75KuiGe?=
 =?us-ascii?Q?5lkD5yXd7+nBgWYhCOyNOvjI/CSxRlPfR9CXmZ+N8TRa2fxTkJCoPqcwzOQJ?=
 =?us-ascii?Q?ZN+wooDAq5aGoN+RVb0AmKF0wjiwelpb479mcT01XbFuQHdQYSZPfp0fVAO2?=
 =?us-ascii?Q?rshrrvIXzwRHtD9ETuY5DMOf9idyK9VefBGRpXnbTgqYugxmhZbG6DQHgeur?=
 =?us-ascii?Q?LDXmj1YlSyL1UqF12sUSkpwjacBG/BsPanftd3TNzB+PhqpDAS8uAux/b9MK?=
 =?us-ascii?Q?vKupoan/ZmrA1nIVvsAMxdsK4NNTKtf9HwdGu/thCWD/ux/odPDSXgz1N5f4?=
 =?us-ascii?Q?+Pf1tkBuEn+2+eF0kYfuMXlQ7EiJ9YQr0ENu9AWcVjJc/evnY//PUzVFp2DW?=
 =?us-ascii?Q?cWfxhq+Qe1t9MZGyoM9DuZfHLgPZssbQixJXfs7wPJAKsoV398EWc61TOsLw?=
 =?us-ascii?Q?w4/f+mxDHX3wxJlwRWQY8nd1c5yV7E/CvIQoEvS4N3oOFEyfY5HwVDqOdIMw?=
 =?us-ascii?Q?qRYNOL9YA+AyrvDA4r00gJH6U+6FsGZ/cfM5oIzowWPAX4xTmsnPb5U4gA87?=
 =?us-ascii?Q?cjFu+i3uzYmYAgfwtdYA+AkspaNu4v3OIZvurPdvY6Tftvisl8WE4JLtupqc?=
 =?us-ascii?Q?Xg=3D=3D?=
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b85441f2-0206-4b3a-7cbf-08db3e4ea8ca
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2023 07:46:16.5135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: voL46CbftVUf1G3rXGq0RWdxcMRmBhL9yiCfXr+SLXE53lHl+pr8OaQNeJTuM5/5eyyoRBfRouubq9Z9eO1SwgIGYM+cQ8Z8IZnhXBH0he4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7740
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check vring size and fail probe if a transmit/receive vring size is
smaller than MAX_SKB_FRAGS + 2.

At the moment, any vring size is accepted. This is problematic because
it may result in attempting to transmit a packet with more fragments
than there are descriptors in the ring.

Furthermore, it leads to an immediate bug:

The condition: (sq->vq->num_free >= 2 + MAX_SKB_FRAGS) in
virtnet_poll_cleantx and virtnet_poll_tx always evaluates to false,
so netif_tx_wake_queue is not called, leading to TX timeouts.

Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
---
 drivers/net/virtio_net.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2396c28c012..59676252c5c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3745,6 +3745,26 @@ static int init_vqs(struct virtnet_info *vi)
 	return ret;
 }
 
+static int virtnet_validate_vqs(struct virtnet_info *vi)
+{
+	u32 i, min_size = roundup_pow_of_two(MAX_SKB_FRAGS + 2);
+
+	/* Transmit/Receive vring size must be at least MAX_SKB_FRAGS + 2
+	 * (fragments + linear part + virtio header)
+	 */
+	for (i = 0; i < vi->max_queue_pairs; i++) {
+		if (virtqueue_get_vring_size(vi->sq[i].vq) < min_size ||
+		    virtqueue_get_vring_size(vi->rq[i].vq) < min_size) {
+			dev_warn(&vi->vdev->dev,
+				 "Transmit/Receive virtqueue vring size must be at least %u\n",
+				 min_size);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_SYSFS
 static ssize_t mergeable_rx_buffer_size_show(struct netdev_rx_queue *queue,
 		char *buf)
@@ -4056,6 +4076,10 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (err)
 		goto free;
 
+	err = virtnet_validate_vqs(vi);
+	if (err)
+		goto free_vqs;
+
 #ifdef CONFIG_SYSFS
 	if (vi->mergeable_rx_bufs)
 		dev->sysfs_rx_queue_group = &virtio_net_mrg_rx_group;
-- 
2.34.1

