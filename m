Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91257EAD60
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 11:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfJaKYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 06:24:33 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:34468 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726913AbfJaKYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 06:24:33 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9B977980053;
        Thu, 31 Oct 2019 10:24:31 +0000 (UTC)
Received: from cim-opti7060.uk.solarflarecom.com (10.17.20.154) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 31 Oct 2019 10:24:26 +0000
From:   Charles McLachlan <cmclachlan@solarflare.com>
Subject: [PATCH net-next v4 6/6] sfc: add XDP counters to ethtool stats
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <brouer@redhat.com>
References: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
Message-ID: <1d36bf21-f9d0-c464-1886-ef4ac1ed7557@solarflare.com>
Date:   Thu, 31 Oct 2019 10:24:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.154]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25012.003
X-TM-AS-Result: No-2.817000-8.000000-10
X-TMASE-MatchedRID: As0DhXnwvkdbbYRuf3nrh7sHVDDM5xAP1JP9NndNOkVZXO8zVe6AWnnU
        bFaXoymefGzuoVn0Vs6PQi9XuOWoOHI/MxNRI7UkiwmGIOAfkmEKogTtqoQiBuD0a1g8E91LNOo
        nVn0dhPcvGKSWy7bk6ABHRU9VJ7rBUneYLfqI2oh1e7Xbb6Im2mf6wD367VgtUjFJwpdmcrQ2m2
        uVGloE8VWrn6UBj2xcWfXwCgkDovjHx0bvkFFh/r6EJGSqPePTB4Id7CiQcz/J2YQ3RSF2REcqj
        CyI/1gNbXRjJgWvj8tf3B3TCH0gItMsGRKm0bkEzNIobH2DzGHrixWWWJYrH01+zyfzlN7yvaMR
        kAFPKY2tIWznhjjBtfoLR4+zsDTt+GYUedkXNWrDwRlVKYTqhQqv6RYqUunntxL0bNKc4kEHHKY
        s/hkM9MShshNOfu2M1sAV2HFW6Zpf2Tsd8RnhwJahDd8y7PVEXQ90N6gfeDrtfQ1SPvnqTJqVXU
        XjGsjz2F+vBZls4K+yaqc7gc0b5cNrTE0oNMe+
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.817000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25012.003
X-MDID: 1572517472-p1mpveFBau-l
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
 drivers/net/ethernet/sfc/rx.c         |  9 +++++++++
 3 files changed, 42 insertions(+)

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
index 505ddc060e64..04e49eac7327 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -453,6 +453,10 @@ enum efx_sync_events_state {
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
@@ -506,6 +510,10 @@ struct efx_channel {
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
index 91f6d5b9ceac..a7d9841105d8 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -677,6 +677,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 			netif_err(efx, rx_err, efx->net_dev,
 				  "XDP is not possible with multiple receive fragments (%d)\n",
 				  channel->rx_pkt_n_frags);
+		channel->n_rx_xdp_bad_drops++;
 		return false;
 	}
 
@@ -722,6 +723,9 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 			if (net_ratelimit())
 				netif_err(efx, rx_err, efx->net_dev,
 					  "XDP TX failed (%d)\n", err);
+			channel->n_rx_xdp_bad_drops++;
+		} else {
+			channel->n_rx_xdp_tx++;
 		}
 		break;
 
@@ -732,12 +736,16 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 			if (net_ratelimit())
 				netif_err(efx, rx_err, efx->net_dev,
 					  "XDP redirect failed (%d)\n", err);
+			channel->n_rx_xdp_bad_drops++;
+		} else {
+			channel->n_rx_xdp_redirect++;
 		}
 		break;
 
 	default:
 		bpf_warn_invalid_xdp_action(xdp_act);
 		efx_free_rx_buffers(rx_queue, rx_buf, 1);
+		channel->n_rx_xdp_bad_drops++;
 		break;
 
 	case XDP_ABORTED:
@@ -745,6 +753,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 		/* Fall through */
 	case XDP_DROP:
 		efx_free_rx_buffers(rx_queue, rx_buf, 1);
+		channel->n_rx_xdp_drops++;
 		break;
 	}
 
