Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46A02E0797
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 17:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732500AbfJVPjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 11:39:39 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:39106 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730141AbfJVPji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 11:39:38 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CC28C14007A;
        Tue, 22 Oct 2019 15:39:36 +0000 (UTC)
Received: from cim-opti7060.uk.solarflarecom.com (10.17.20.154) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 22 Oct 2019 16:39:31 +0100
From:   Charles McLachlan <cmclachlan@solarflare.com>
Subject: [PATCH net-next 6/6] sfc: add XDP counters to ethtool stats.
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <brouer@redhat.com>
References: <05b72fdb-165c-1350-787b-ca8c5261c459@solarflare.com>
Message-ID: <59a8fde3-7e07-4b90-b332-349c41ad030f@solarflare.com>
Date:   Tue, 22 Oct 2019 16:39:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <05b72fdb-165c-1350-787b-ca8c5261c459@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.154]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24994.003
X-TM-AS-Result: No-3.640600-8.000000-10
X-TMASE-MatchedRID: NWSsFFuu76tbbYRuf3nrh7sHVDDM5xAP1JP9NndNOkVZXO8zVe6AWnnU
        bFaXoymefGzuoVn0Vs6PQi9XuOWoOHI/MxNRI7UkiwmGIOAfkmEKogTtqoQiBuD0a1g8E91LNOo
        nVn0dhPcvGKSWy7bk6ABHRU9VJ7rBUneYLfqI2oh1e7Xbb6Im2mf6wD367VgtUjFJwpdmcrQ2m2
        uVGloE8VWrn6UBj2xcWfXwCgkDovjHx0bvkFFh/r6EJGSqPePTB4Id7CiQcz/J2YQ3RSF2RHm5f
        Qprv+BB4HEFwUDiSZ6NwXNpr2GcsKPFjJEFr+olfeZdJ1XsorjMA6TEdjm6mAtuKBGekqUpOlxB
        O2IcOBYlYNA+GjhW/PrQsvxcjE5aVgm6rOOoUFUiEBUmoAWH72FH1esu8zcC/KMyXACubzk13/6
        NGCvuG8mhH9CqlTigpv802F2SMbQXxY6mau8LG3IJh4dBcU42f4hpTpoBF9JqxGCSzFD9MrDMWv
        XXz1lrlExlQIQeRG0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.640600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24994.003
X-MDID: 1571758778-qZ2vPRubCVBh
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Count XDP packet drops, error drops, transmissions and redirects and
expose these counters via the ethtool stats command.

Signed-off-by: Charles McLachlan <cmclachlan@solarflare.com>
---
 drivers/net/ethernet/sfc/ethtool.c    | 25 +++++++++++++++++++++++++
 drivers/net/ethernet/sfc/net_driver.h |  8 ++++++++
 drivers/net/ethernet/sfc/rx.c         |  6 ++++++
 3 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 86b965875540..8db593fb9699 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -83,6 +83,10 @@ static const struct efx_sw_stat_desc efx_sw_stat_desc[] = {
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_frm_trunc),
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_merge_events),
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_merge_packets),
+	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_drops),
+	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_bad_drops),
+	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_tx),
+	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_redirect),
 };
 
 #define EFX_ETHTOOL_SW_STAT_COUNT ARRAY_SIZE(efx_sw_stat_desc)
@@ -399,6 +403,19 @@ static size_t efx_describe_per_queue_stats(struct efx_nic *efx, u8 *strings)
 			}
 		}
 	}
+	if (efx->xdp_tx_queue_count && efx->xdp_tx_queues) {
+		unsigned short xdp;
+
+		for (xdp = 0; xdp < efx->xdp_tx_queue_count; xdp++) {
+			n_stats++;
+			if (strings) {
+				snprintf(strings, ETH_GSTRING_LEN,
+					 "tx-xdp-cpu-%hu.tx_packets", xdp);
+				strings += ETH_GSTRING_LEN;
+			}
+		}
+	}
+
 	return n_stats;
 }
 
@@ -509,6 +526,14 @@ static void efx_ethtool_get_stats(struct net_device *net_dev,
 			data++;
 		}
 	}
+	if (efx->xdp_tx_queue_count && efx->xdp_tx_queues) {
+		int xdp;
+
+		for (xdp = 0; xdp < efx->xdp_tx_queue_count; xdp++) {
+			data[0] = efx->xdp_tx_queues[xdp]->tx_packets;
+			data++;
+		}
+	}
 
 	efx_ptp_update_stats(efx, data);
 }
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 4a38f1fdf8a0..ca273b8fdfad 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -451,6 +451,10 @@ enum efx_sync_events_state {
  *	lack of descriptors
  * @n_rx_merge_events: Number of RX merged completion events
  * @n_rx_merge_packets: Number of RX packets completed by merged events
+ * @n_rx_xdp_drops: Count of RX packets intentionally dropped due to XDP
+ * @n_rx_xdp_bad_drops: Count of RX packets dropped due to XDP errors
+ * @n_rx_xdp_tx: Count of RX packets retransmitted due to XDP
+ * @n_rx_xdp_redirect: Count of RX packets redirected to a different NIC by XDP
  * @rx_pkt_n_frags: Number of fragments in next packet to be delivered by
  *	__efx_rx_packet(), or zero if there is none
  * @rx_pkt_index: Ring index of first buffer for next packet to be delivered
@@ -504,6 +508,10 @@ struct efx_channel {
 	unsigned int n_rx_nodesc_trunc;
 	unsigned int n_rx_merge_events;
 	unsigned int n_rx_merge_packets;
+	unsigned int n_rx_xdp_drops;
+	unsigned int n_rx_xdp_bad_drops;
+	unsigned int n_rx_xdp_tx;
+	unsigned int n_rx_xdp_redirect;
 
 	unsigned int rx_pkt_n_frags;
 	unsigned int rx_pkt_index;
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index f5febec9acc4..c1e4e4246043 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -676,6 +676,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 			netif_err(efx, rx_err, efx->net_dev,
 				  "XDP is not possible with multiple receive fragments (%d)\n",
 				  channel->rx_pkt_n_frags);
+		channel->n_rx_xdp_bad_drops++;
 		return false;
 	}
 
@@ -734,6 +735,9 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 			if (net_ratelimit())
 				netif_err(efx, rx_err, efx->net_dev,
 					  "XDP redirect failed (%d)\n", rc);
+			channel->n_rx_xdp_bad_drops++;
+		} else {
+			channel->n_rx_xdp_redirect++;
 		}
 		break;
 
@@ -742,10 +746,12 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 		/* Fall through */
 	case XDP_ABORTED:
 		efx_free_rx_buffers(rx_queue, rx_buf, 1);
+		channel->n_rx_xdp_bad_drops++;
 		break;
 
 	case XDP_DROP:
 		efx_free_rx_buffers(rx_queue, rx_buf, 1);
+		channel->n_rx_xdp_drops++;
 		break;
 	}
 
