Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 920ED161CE9
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 22:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbgBQVmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 16:42:08 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38816 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729334AbgBQVmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 16:42:08 -0500
Received: by mail-wm1-f66.google.com with SMTP id a9so785058wmj.3;
        Mon, 17 Feb 2020 13:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cjeh9v8Xhl5vf17zgEZjFCMDibT7UUm5HC0X2z/QhaI=;
        b=ZsgD0lTYfz6ieZ6SfUvJ/p5AMCoN0HZB0R3wrR1lkZtiJYUYhBwgxKD6jt3sVs+vde
         y1gUNDIqje/eC5MhrCkPN0UCkS3w01yk3kXnqnwseXCZzQdHPYl/WNwtxhj4r5cn1HvT
         g7lqanx+8IhSWoKvTDTJA45Lafothcj5oqlo5a+d3NY6Rv5eBAmHhMNLNnhIAOXj5/LM
         C9XicF4XzqLrnj48nZNw1cHSWWypGK842GeyAgiIoZys23xqjyOhaHXakoaBYBeS6BRR
         rxOheD6EedwIrmLcwAhs/6+tYYdMdF3rqJSXU2HHC8SWmwZdWmsZ04PqpuvXlLfPFqwb
         B9Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cjeh9v8Xhl5vf17zgEZjFCMDibT7UUm5HC0X2z/QhaI=;
        b=HEq/HbScAgQP3MQzQnTHotO9w6QMXRPYTncuMgFqUuVeilE6mDOI307YrwkyYJpOGN
         wXRMMIa7uA8+h8FqUzUMiZ87Qs3VtXIx9cJ8P3FX8/RzMBIlxSve3EeJuFnRHO6PNPYl
         2B/R0Sx7gChjrKuPfwSMl6IEjuk0X3r4G+CW9TUrjMND9bM7svjbTUw7aQJU7m9N2wTz
         BGMMG2k1iACgCmWevgalmoOz4f659reQxjhYCAmaTEKeNhhnZ3Wmqe8X9eyA8U3FUYmi
         SGqL9YW2D5tx/xlskb1/h95zal7CjRQ1hvrdt8WpCQoXUwALQ/J6ulffQbG9mXJXqlCN
         Ia4Q==
X-Gm-Message-State: APjAAAVbTfAnni3pGIc4XdGzwIFdeynLw7Mwhfz8AcxWrsCdG/IE5Aym
        3eZzfdZBNsFFbXJk54IIUyXiPCja5JQ=
X-Google-Smtp-Source: APXvYqxEQPgZsTWSmVdE5H03b38/6KYJiWeSoWc+PwoUuRcAQGUl+NXdpwv0LoPkKmNamG9313L54Q==
X-Received: by 2002:a05:600c:21c5:: with SMTP id x5mr995220wmj.72.1581975724312;
        Mon, 17 Feb 2020 13:42:04 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:41c6:31a6:d880:888? (p200300EA8F29600041C631A6D8800888.dip0.t-ipconnect.de. [2003:ea:8f29:6000:41c6:31a6:d880:888])
        by smtp.googlemail.com with ESMTPSA id q124sm1510675wme.2.2020.02.17.13.42.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 13:42:03 -0800 (PST)
Subject: [PATCH net-next 3/3] net: use new helper tcp_v6_gso_csum_prep
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Parvi Kaustubhi <pkaustub@cisco.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Guo-Fu Tseng <cooldavid@cooldavid.org>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Timur Tabi <timur@kernel.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, linux-hyperv@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
References: <76cd6cfc-f4f3-ece7-203a-0266b7f02a12@gmail.com>
Message-ID: <9270ae4b-feb1-6a4d-8a22-fbe5e47b7617@gmail.com>
Date:   Mon, 17 Feb 2020 22:42:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <76cd6cfc-f4f3-ece7-203a-0266b7f02a12@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new helper tcp_v6_gso_csum_prep in additional network drivers.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/atheros/alx/main.c       |  5 +---
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  6 ++---
 drivers/net/ethernet/brocade/bna/bnad.c       |  7 +----
 drivers/net/ethernet/cisco/enic/enic_main.c   |  3 +--
 drivers/net/ethernet/intel/e1000/e1000_main.c |  6 +----
 drivers/net/ethernet/intel/e1000e/netdev.c    |  5 +---
 drivers/net/ethernet/jme.c                    |  7 +----
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  5 +---
 drivers/net/ethernet/qualcomm/emac/emac-mac.c |  7 ++---
 drivers/net/ethernet/socionext/netsec.c       |  6 +----
 drivers/net/hyperv/netvsc_drv.c               |  5 +---
 drivers/net/usb/r8152.c                       | 26 ++-----------------
 drivers/net/vmxnet3/vmxnet3_drv.c             |  5 +---
 13 files changed, 16 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 1dcbc486e..3e0215887 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1416,10 +1416,7 @@ static int alx_tso(struct sk_buff *skb, struct alx_txd *first)
 							 0, IPPROTO_TCP, 0);
 		first->word1 |= 1 << TPD_IPV4_SHIFT;
 	} else if (skb_is_gso_v6(skb)) {
-		ipv6_hdr(skb)->payload_len = 0;
-		tcp_hdr(skb)->check = ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-						       &ipv6_hdr(skb)->daddr,
-						       0, IPPROTO_TCP, 0);
+		tcp_v6_gso_csum_prep(skb, true);
 		/* LSOv2: the first TPD only provides the packet length */
 		first->adrl.l.pkt_len = skb->len;
 		first->word1 |= 1 << TPD_LSO_V2_SHIFT;
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 4c0b1f855..482e18d0d 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2025,10 +2025,8 @@ static int atl1c_tso_csum(struct atl1c_adapter *adapter,
 						"IPV6 tso with zero data??\n");
 				goto check_sum;
 			} else
-				tcp_hdr(skb)->check = ~csum_ipv6_magic(
-						&ipv6_hdr(skb)->saddr,
-						&ipv6_hdr(skb)->daddr,
-						0, IPPROTO_TCP, 0);
+				tcp_v6_gso_csum_prep(skb, false);
+
 			etpd->word1 |= 1 << TPD_LSO_EN_SHIFT;
 			etpd->word1 |= 1 << TPD_LSO_VER_SHIFT;
 			etpd->pkt_len = cpu_to_le32(skb->len);
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index 01a50a4b2..c301ad736 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -2504,12 +2504,7 @@ bnad_tso_prepare(struct bnad *bnad, struct sk_buff *skb)
 					   IPPROTO_TCP, 0);
 		BNAD_UPDATE_CTR(bnad, tso4);
 	} else {
-		struct ipv6hdr *ipv6h = ipv6_hdr(skb);
-
-		ipv6h->payload_len = 0;
-		tcp_hdr(skb)->check =
-			~csum_ipv6_magic(&ipv6h->saddr, &ipv6h->daddr, 0,
-					 IPPROTO_TCP, 0);
+		tcp_v6_gso_csum_prep(skb, true);
 		BNAD_UPDATE_CTR(bnad, tso6);
 	}
 
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index ddf60dc9a..683c628ef 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -696,8 +696,7 @@ static void enic_preload_tcp_csum(struct sk_buff *skb)
 		tcp_hdr(skb)->check = ~csum_tcpudp_magic(ip_hdr(skb)->saddr,
 			ip_hdr(skb)->daddr, 0, IPPROTO_TCP, 0);
 	} else if (skb->protocol == cpu_to_be16(ETH_P_IPV6)) {
-		tcp_hdr(skb)->check = ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-			&ipv6_hdr(skb)->daddr, 0, IPPROTO_TCP, 0);
+		tcp_v6_gso_csum_prep(skb, false);
 	}
 }
 
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 2bced34c1..0664985e8 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -2715,11 +2715,7 @@ static int e1000_tso(struct e1000_adapter *adapter,
 			cmd_length = E1000_TXD_CMD_IP;
 			ipcse = skb_transport_offset(skb) - 1;
 		} else if (skb_is_gso_v6(skb)) {
-			ipv6_hdr(skb)->payload_len = 0;
-			tcp_hdr(skb)->check =
-				~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-						 &ipv6_hdr(skb)->daddr,
-						 0, IPPROTO_TCP, 0);
+			tcp_v6_gso_csum_prep(skb, true);
 			ipcse = 0;
 		}
 		ipcss = skb_network_offset(skb);
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index db4ea58ba..7dda7d407 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5462,10 +5462,7 @@ static int e1000_tso(struct e1000_ring *tx_ring, struct sk_buff *skb,
 		cmd_length = E1000_TXD_CMD_IP;
 		ipcse = skb_transport_offset(skb) - 1;
 	} else if (skb_is_gso_v6(skb)) {
-		ipv6_hdr(skb)->payload_len = 0;
-		tcp_hdr(skb)->check = ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-						       &ipv6_hdr(skb)->daddr,
-						       0, IPPROTO_TCP, 0);
+		tcp_v6_gso_csum_prep(skb, true);
 		ipcse = 0;
 	}
 	ipcss = skb_network_offset(skb);
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 2e4975572..cde9be497 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2077,12 +2077,7 @@ jme_tx_tso(struct sk_buff *skb, __le16 *mss, u8 *flags)
 								IPPROTO_TCP,
 								0);
 		} else {
-			struct ipv6hdr *ip6h = ipv6_hdr(skb);
-
-			tcp_hdr(skb)->check = ~csum_ipv6_magic(&ip6h->saddr,
-								&ip6h->daddr, 0,
-								IPPROTO_TCP,
-								0);
+			tcp_v6_gso_csum_prep(skb, false);
 		}
 
 		return 0;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index e452f4242..3d8469d97 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -632,10 +632,7 @@ static int ionic_tx_tcp_pseudo_csum(struct sk_buff *skb)
 					   ip_hdr(skb)->daddr,
 					   0, IPPROTO_TCP, 0);
 	} else if (skb->protocol == cpu_to_be16(ETH_P_IPV6)) {
-		tcp_hdr(skb)->check =
-			~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-					 &ipv6_hdr(skb)->daddr,
-					 0, IPPROTO_TCP, 0);
+		tcp_v6_gso_csum_prep(skb, false);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/qualcomm/emac/emac-mac.c b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
index bebe38d74..01bcc5e68 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-mac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
@@ -1288,11 +1288,8 @@ static int emac_tso_csum(struct emac_adapter *adpt,
 			memset(tpd, 0, sizeof(*tpd));
 			memset(&extra_tpd, 0, sizeof(extra_tpd));
 
-			ipv6_hdr(skb)->payload_len = 0;
-			tcp_hdr(skb)->check =
-				~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-						 &ipv6_hdr(skb)->daddr,
-						 0, IPPROTO_TCP, 0);
+			tcp_v6_gso_csum_prep(skb, true);
+
 			TPD_PKT_LEN_SET(&extra_tpd, skb->len);
 			TPD_LSO_SET(&extra_tpd, 1);
 			TPD_LSOV_SET(&extra_tpd, 1);
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index e8224b543..d7a033053 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1148,11 +1148,7 @@ static netdev_tx_t netsec_netdev_start_xmit(struct sk_buff *skb,
 				~tcp_v4_check(0, ip_hdr(skb)->saddr,
 					      ip_hdr(skb)->daddr, 0);
 		} else {
-			ipv6_hdr(skb)->payload_len = 0;
-			tcp_hdr(skb)->check =
-				~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-						 &ipv6_hdr(skb)->daddr,
-						 0, IPPROTO_TCP, 0);
+			tcp_v6_gso_csum_prep(skb, true);
 		}
 
 		tx_ctrl.tcp_seg_offload_flag = true;
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 65e12cb07..f41e48634 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -638,10 +638,7 @@ static int netvsc_xmit(struct sk_buff *skb, struct net_device *net, bool xdp_tx)
 		} else {
 			lso_info->lso_v2_transmit.ip_version =
 				NDIS_TCP_LARGE_SEND_OFFLOAD_IPV6;
-			ipv6_hdr(skb)->payload_len = 0;
-			tcp_hdr(skb)->check =
-				~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-						 &ipv6_hdr(skb)->daddr, 0, IPPROTO_TCP, 0);
+			tcp_v6_gso_csum_prep(skb, true);
 		}
 		lso_info->lso_v2_transmit.tcp_header_offset = skb_transport_offset(skb);
 		lso_info->lso_v2_transmit.mss = skb_shinfo(skb)->gso_size;
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 78ddbaf64..4ad2a1d42 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1948,29 +1948,6 @@ static void r8152_csum_workaround(struct r8152 *tp, struct sk_buff *skb,
 	}
 }
 
-/* msdn_giant_send_check()
- * According to the document of microsoft, the TCP Pseudo Header excludes the
- * packet length for IPv6 TCP large packets.
- */
-static int msdn_giant_send_check(struct sk_buff *skb)
-{
-	const struct ipv6hdr *ipv6h;
-	struct tcphdr *th;
-	int ret;
-
-	ret = skb_cow_head(skb, 0);
-	if (ret)
-		return ret;
-
-	ipv6h = ipv6_hdr(skb);
-	th = tcp_hdr(skb);
-
-	th->check = 0;
-	th->check = ~tcp_v6_check(0, &ipv6h->saddr, &ipv6h->daddr, 0);
-
-	return ret;
-}
-
 static inline void rtl_tx_vlan_tag(struct tx_desc *desc, struct sk_buff *skb)
 {
 	if (skb_vlan_tag_present(skb)) {
@@ -2016,10 +1993,11 @@ static int r8152_tx_csum(struct r8152 *tp, struct tx_desc *desc,
 			break;
 
 		case htons(ETH_P_IPV6):
-			if (msdn_giant_send_check(skb)) {
+			if (skb_cow_head(skb, 0)) {
 				ret = TX_CSUM_TSO;
 				goto unavailable;
 			}
+			tcp_v6_gso_csum_prep(skb, false);
 			opts1 |= GTSENDV6;
 			break;
 
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 18f152fa0..92c2ecf3f 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -942,10 +942,7 @@ vmxnet3_prepare_tso(struct sk_buff *skb,
 		tcph->check = ~csum_tcpudp_magic(iph->saddr, iph->daddr, 0,
 						 IPPROTO_TCP, 0);
 	} else if (ctx->ipv6) {
-		struct ipv6hdr *iph = ipv6_hdr(skb);
-
-		tcph->check = ~csum_ipv6_magic(&iph->saddr, &iph->daddr, 0,
-					       IPPROTO_TCP, 0);
+		tcp_v6_gso_csum_prep(skb, false);
 	}
 }
 
-- 
2.25.0


