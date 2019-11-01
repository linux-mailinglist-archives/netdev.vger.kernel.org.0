Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED7C9ECC00
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 00:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfKAXmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 19:42:52 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32841 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727751AbfKAXmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 19:42:51 -0400
Received: by mail-pg1-f193.google.com with SMTP id u23so7422665pgo.0
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 16:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dfPNTDY25iXafSsdsY8mCqVBS33B17BqM3bXcxL/u94=;
        b=vo9/xEZM+g0yjPGxOCeNIAVhXdNELocM4842O/B0qI6IxIimtsqY4nf+IVxxdwKa3j
         XUmV2shpsCcSu9J0IZ44QuhVyWrIbK0Mm79AhBuGq+tgYgAFaTXBBBuWZ5V3wiuemnmS
         RywbPSYThTS4B75/76vtkqrqPbbZO6Fci5cAycX8jy/StbzqTwvjftg+hAeWUBYL8RZu
         J7Pp89OCEvGix1wtM7W77g3YW1yKUyHj2GFx7rJ/oQi6/N3ILPeN0zErhW3VokvlRlQZ
         RoMZJMIlkUaaAqP6mN/USJsQiF7ClchxacfYKHEHyMSqSHhw6rgImDQvjDW3Ua2TtGFb
         fNSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dfPNTDY25iXafSsdsY8mCqVBS33B17BqM3bXcxL/u94=;
        b=Q1WVbH25gLYkK5au6Yllq1v4qExsgBnUpQ6KweE5drJ0TMyKHVXLNOlnApbM2CAVxB
         C/C1Qu7L2NzTgB1jk6hoedfoVbgbR2G3zmxLFPzLpTVAgDmJJqmNnEG+KwloNR5f688r
         hmvHlZLP6TxPCCU6dSO0YnZlMk3KcsCgrQcHCoQHh+yG90oKFDPWXJzNzEgwDIHT4cUr
         8ehGuVHBGtRSo6eGNa5bChgelNx8eUAMEc5/c1hkONJ7yf8eD5fceAyd9yLC8ijLBTdO
         t47m2iKbPxI/KOfwDU0eZWdB89SmhWxt+9Jr0loIyLJp5UedfWBmsfrRudUXUn2/MPZI
         0GLg==
X-Gm-Message-State: APjAAAUA9EKr0JTwq+0A5qPAR8ZI7dfH9pC3j6qMmMGC/ZzMo/nn3fw4
        O871aNEaXmFmjAe4gW96NDnWTA==
X-Google-Smtp-Source: APXvYqxSGMQv2GOZt8yrFMAEfsytU8cuJsXV8Pl4F/ge/oqC+/dTypOkEtY9wWDDRsJpjPd50Np4Cg==
X-Received: by 2002:a17:90a:37e4:: with SMTP id v91mr18795873pjb.8.1572651769728;
        Fri, 01 Nov 2019 16:42:49 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id c19sm7948128pfn.44.2019.11.01.16.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 16:42:48 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     davem@davemloft.net, haiyangz@microsoft.com, kys@microsoft.com,
        sashal@kernel.org
Cc:     netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>
Subject: [PATCH net-next 2/2] hv_netvsc: record hardware hash in skb
Date:   Fri,  1 Nov 2019 16:42:38 -0700
Message-Id: <20191101234238.23921-3-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191101234238.23921-1-stephen@networkplumber.org>
References: <20191101234238.23921-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <sthemmin@microsoft.com>

Since RSS hash is available from the host, record it in
the skb.

Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h   | 1 +
 drivers/net/hyperv/netvsc_drv.c   | 4 ++++
 drivers/net/hyperv/rndis_filter.c | 8 +++++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 670ef682f268..4209d1cf57f6 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -853,6 +853,7 @@ struct multi_recv_comp {
 struct nvsc_rsc {
 	const struct ndis_pkt_8021q_info *vlan;
 	const struct ndis_tcp_ip_checksum_info *csum_info;
+	const u32 *hash_info;
 	u8 is_last; /* last RNDIS msg in a vmtransfer_page */
 	u32 cnt; /* #fragments in an RSC packet */
 	u32 pktlen; /* Full packet length */
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index fa56fcde9f8b..01b0d15ac681 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -766,6 +766,7 @@ static struct sk_buff *netvsc_alloc_recv_skb(struct net_device *net,
 	const struct ndis_pkt_8021q_info *vlan = nvchan->rsc.vlan;
 	const struct ndis_tcp_ip_checksum_info *csum_info =
 						nvchan->rsc.csum_info;
+	const u32 *hash_info = nvchan->rsc.hash_info;
 	struct sk_buff *skb;
 	int i;
 
@@ -802,6 +803,9 @@ static struct sk_buff *netvsc_alloc_recv_skb(struct net_device *net,
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 
+	if (hash_info)
+		skb_set_hash(skb, *hash_info, PKT_HASH_TYPE_L4);
+
 	if (vlan) {
 		u16 vlan_tci = vlan->vlanid | (vlan->pri << VLAN_PRIO_SHIFT) |
 			(vlan->cfi ? VLAN_CFI_MASK : 0);
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index abaf8156d19d..c06178380ac8 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -358,6 +358,7 @@ static inline
 void rsc_add_data(struct netvsc_channel *nvchan,
 		  const struct ndis_pkt_8021q_info *vlan,
 		  const struct ndis_tcp_ip_checksum_info *csum_info,
+		  const u32 *hash_info,
 		  void *data, u32 len)
 {
 	u32 cnt = nvchan->rsc.cnt;
@@ -368,6 +369,7 @@ void rsc_add_data(struct netvsc_channel *nvchan,
 		nvchan->rsc.vlan = vlan;
 		nvchan->rsc.csum_info = csum_info;
 		nvchan->rsc.pktlen = len;
+		nvchan->rsc.hash_info = hash_info;
 	}
 
 	nvchan->rsc.data[cnt] = data;
@@ -385,6 +387,7 @@ static int rndis_filter_receive_data(struct net_device *ndev,
 	const struct ndis_tcp_ip_checksum_info *csum_info;
 	const struct ndis_pkt_8021q_info *vlan;
 	const struct rndis_pktinfo_id *pktinfo_id;
+	const u32 *hash_info;
 	u32 data_offset;
 	void *data;
 	bool rsc_more = false;
@@ -411,6 +414,8 @@ static int rndis_filter_receive_data(struct net_device *ndev,
 
 	csum_info = rndis_get_ppi(rndis_pkt, TCPIP_CHKSUM_PKTINFO, 0);
 
+	hash_info = rndis_get_ppi(rndis_pkt, NBL_HASH_VALUE, 0);
+
 	pktinfo_id = rndis_get_ppi(rndis_pkt, RNDIS_PKTINFO_ID, 1);
 
 	data = (void *)msg + data_offset;
@@ -441,7 +446,8 @@ static int rndis_filter_receive_data(struct net_device *ndev,
 	 * rndis_pkt->data_len tell us the real data length, we only copy
 	 * the data packet to the stack, without the rndis trailer padding
 	 */
-	rsc_add_data(nvchan, vlan, csum_info, data, rndis_pkt->data_len);
+	rsc_add_data(nvchan, vlan, csum_info, hash_info,
+		     data, rndis_pkt->data_len);
 
 	if (rsc_more)
 		return NVSP_STAT_SUCCESS;
-- 
2.20.1

