Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF186EBAEB
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 20:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjDVSyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 14:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjDVSyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 14:54:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07931BEB;
        Sat, 22 Apr 2023 11:54:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41E4460FC6;
        Sat, 22 Apr 2023 18:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7131C4339E;
        Sat, 22 Apr 2023 18:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682189671;
        bh=GgGwscnbolsXdgo21whLHvKroZ3/TfxmEh8fTcbEhLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJo8/tHdmIr7nEOSPrao0aVsH1ZwtLbLe6YIz+qry5NzzukXeZ5DCUtFnbt7/xqeS
         i9wlpsSdLfnfmXSXBYNDKlLLWTzoePmz/wuLprPrN4oziqaNSRBzUfFegl1D7ij5KV
         N3Wkuh1XTjBauVRz6FQJYSsZQ3zuzL+pe1wA32zNx7JLbjDRKkqdCKsGICEFNGqjpx
         n+wAki6joijUK+geQIoONiRzmSbNyOAPENRs5KMjQV4wFx1chRlyWiBrIB5YqjedD+
         Q4FGJtGIHDVmZ4sEisf/GoQdNM/thEyo+gwmSXnRcvgWsigcy+jT2PZmq3iPnP+LOF
         7mBHgeQ81+1pg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hawk@kernel.org, john.fastabend@gmail.com,
        ast@kernel.org, daniel@iogearbox.net
Subject: [PATCH v2 net-next 2/2] net: veth: add page_pool stats
Date:   Sat, 22 Apr 2023 20:54:33 +0200
Message-Id: <dbb4d08e21f453b5778f1271dae3589518726f1b.1682188837.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1682188837.git.lorenzo@kernel.org>
References: <cover.1682188837.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce page_pool stats support to report info about local page_pool
through ethtool

Tested-by: Maryam Tahhan <mtahhan@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/Kconfig |  1 +
 drivers/net/veth.c  | 20 +++++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 368c6f5b327e..d0a1ed216d15 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -403,6 +403,7 @@ config TUN_VNET_CROSS_LE
 config VETH
 	tristate "Virtual ethernet pair device"
 	select PAGE_POOL
+	select PAGE_POOL_STATS
 	help
 	  This device is a local ethernet tunnel. Devices are created in pairs.
 	  When one end receives the packet it appears on its pair and vice
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 35d2285dec25..dce9f9d63e04 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -157,6 +157,8 @@ static void veth_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 			for (j = 0; j < VETH_TQ_STATS_LEN; j++)
 				ethtool_sprintf(&p, "tx_queue_%u_%.18s",
 						i, veth_tq_stats_desc[j].desc);
+
+		page_pool_ethtool_stats_get_strings(p);
 		break;
 	}
 }
@@ -167,7 +169,8 @@ static int veth_get_sset_count(struct net_device *dev, int sset)
 	case ETH_SS_STATS:
 		return ARRAY_SIZE(ethtool_stats_keys) +
 		       VETH_RQ_STATS_LEN * dev->real_num_rx_queues +
-		       VETH_TQ_STATS_LEN * dev->real_num_tx_queues;
+		       VETH_TQ_STATS_LEN * dev->real_num_tx_queues +
+		       page_pool_ethtool_stats_get_count();
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -178,7 +181,8 @@ static void veth_get_ethtool_stats(struct net_device *dev,
 {
 	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
 	struct net_device *peer = rtnl_dereference(priv->peer);
-	int i, j, idx;
+	struct page_pool_stats pp_stats = {};
+	int i, j, idx, pp_idx;
 
 	data[0] = peer ? peer->ifindex : 0;
 	idx = 1;
@@ -197,9 +201,10 @@ static void veth_get_ethtool_stats(struct net_device *dev,
 		} while (u64_stats_fetch_retry(&rq_stats->syncp, start));
 		idx += VETH_RQ_STATS_LEN;
 	}
+	pp_idx = idx;
 
 	if (!peer)
-		return;
+		goto page_pool_stats;
 
 	rcv_priv = netdev_priv(peer);
 	for (i = 0; i < peer->real_num_rx_queues; i++) {
@@ -216,7 +221,16 @@ static void veth_get_ethtool_stats(struct net_device *dev,
 				data[tx_idx + j] += *(u64 *)(base + offset);
 			}
 		} while (u64_stats_fetch_retry(&rq_stats->syncp, start));
+		pp_idx = tx_idx + VETH_TQ_STATS_LEN;
+	}
+
+page_pool_stats:
+	for (i = 0; i < dev->real_num_rx_queues; i++) {
+		if (!priv->rq[i].page_pool)
+			continue;
+		page_pool_get_stats(priv->rq[i].page_pool, &pp_stats);
 	}
+	page_pool_ethtool_stats_get(&data[pp_idx], &pp_stats);
 }
 
 static void veth_get_channels(struct net_device *dev,
-- 
2.40.0

