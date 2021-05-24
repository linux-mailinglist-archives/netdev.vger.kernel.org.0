Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A4738F34F
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 20:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbhEXSxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 14:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbhEXSxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 14:53:43 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D70C061574;
        Mon, 24 May 2021 11:52:15 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id s1-20020a4ac1010000b02901cfd9170ce2so6578453oop.12;
        Mon, 24 May 2021 11:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Daf1G/gpAf8iGGAjpv9KN6rnLg9Pa7V61LQOWzgNB+w=;
        b=g3qLbkd3cQSS3UaDqWxauHf1F1WlNBVZsBD+Ve62BK+SWldMgrztWNjYgccHKe4GkF
         KvkXkne50LyFCE8xbjk71JEd4Tm7fBe8P315lZEEdSv60s2XfzGs7nxaHXIH/s9uhfJQ
         A115/ndMTNRXAVNGfKKXcIabdr4co8gkHwuCmfkgARtW+iscj7Pe2k5IbrpEguD9o4GY
         8BRqP6L869t6C5UtJOpamDhm4AMsotwHtmiZvyWeR/HYKOKz4wQq11m58dWtoiGIcfob
         8MW2cnpBqb9UnxfE+nB1DKlB2F/0+iwZmedjnyL01fBgYmMs09rsRFMRcH93F4pl74dJ
         nFdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Daf1G/gpAf8iGGAjpv9KN6rnLg9Pa7V61LQOWzgNB+w=;
        b=S8JK1Dk/JHDiq4Gntly2LvshTFi5qxgn15ehqMn/gziMpIMpKJBDu+5YoIL9/d/G58
         /B8V1+pMcsu9PLtUmATu6ocY3pwWBeMQAAXla1pyqMzpTpfw+IWSNX96TahQ3Ozy2l1q
         MoZkVlC2IkC9WMnSw/B23ZFPcqSQocKfxtrzg0JNc2ChNyoFS9/iP1EeszhJ6NLpmMFn
         agIzoGAJnYpyk99hB/WSrpazFH6/nDRg5oyke5RVQAkaM47Mz1bFD+/OK+Wb0NugdY1X
         j/jLsCC6GruYFSz41zxwS/Svpp9+8CTmbpmaiddkhAp08okfgzJnesfg5BfmPHk2Y6k/
         dMVQ==
X-Gm-Message-State: AOAM531qWwmVSemhoKxKWok7q9yL4rTz9AvzYGntrg39XSoC8CWUgD4g
        +HQV+UmenGuEtPUHj5tt87bNETvkdNie
X-Google-Smtp-Source: ABdhPJylrt4O8bwLShCnp3u8P904I8V+lvajSCv7MFxGwgQd/Wl1ZHiNgylmeZVP0XkDVvCOhRXD9g==
X-Received: by 2002:a4a:97ed:: with SMTP id x42mr19236008ooi.40.1621882334354;
        Mon, 24 May 2021 11:52:14 -0700 (PDT)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id y7sm3264564oto.60.2021.05.24.11.52.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 May 2021 11:52:13 -0700 (PDT)
From:   George McCollister <george.mccollister@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Wang Hai <wanghai38@huawei.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Andreas Oetken <andreas.oetken@siemens.com>,
        Marco Wenzel <marco.wenzel@a-eberle.de>,
        linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net] net: hsr: fix mac_len checks
Date:   Mon, 24 May 2021 13:50:54 -0500
Message-Id: <20210524185054.65642-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2e9f60932a2c ("net: hsr: check skb can contain struct hsr_ethhdr
in fill_frame_info") added the following which resulted in -EINVAL
always being returned:
	if (skb->mac_len < sizeof(struct hsr_ethhdr))
		return -EINVAL;

mac_len was not being set correctly so this check completely broke
HSR/PRP since it was always 14, not 20.

Set mac_len correctly and modify the mac_len checks to test in the
correct places since sometimes it is legitimately 14.

Fixes: 2e9f60932a2c ("net: hsr: check skb can contain struct hsr_ethhdr in fill_frame_info")
Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 net/hsr/hsr_device.c  |  2 ++
 net/hsr/hsr_forward.c | 30 +++++++++++++++++++++---------
 net/hsr/hsr_forward.h |  8 ++++----
 net/hsr/hsr_main.h    |  4 ++--
 net/hsr/hsr_slave.c   | 11 +++++------
 5 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index bfcdc75fc01e..26c32407f029 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -218,6 +218,7 @@ static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (master) {
 		skb->dev = master->dev;
 		skb_reset_mac_header(skb);
+		skb_reset_mac_len(skb);
 		hsr_forward_skb(skb, master);
 	} else {
 		atomic_long_inc(&dev->tx_dropped);
@@ -259,6 +260,7 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master)
 		goto out;
 
 	skb_reset_mac_header(skb);
+	skb_reset_mac_len(skb);
 	skb_reset_network_header(skb);
 	skb_reset_transport_header(skb);
 
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 6852e9bccf5b..ceb8afb2a62f 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -474,8 +474,8 @@ static void handle_std_frame(struct sk_buff *skb,
 	}
 }
 
-void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
-			 struct hsr_frame_info *frame)
+int hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
+			struct hsr_frame_info *frame)
 {
 	struct hsr_port *port = frame->port_rcv;
 	struct hsr_priv *hsr = port->hsr;
@@ -483,20 +483,26 @@ void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
 	/* HSRv0 supervisory frames double as a tag so treat them as tagged. */
 	if ((!hsr->prot_version && proto == htons(ETH_P_PRP)) ||
 	    proto == htons(ETH_P_HSR)) {
+		/* Check if skb contains hsr_ethhdr */
+		if (skb->mac_len < sizeof(struct hsr_ethhdr))
+			return -EINVAL;
+
 		/* HSR tagged frame :- Data or Supervision */
 		frame->skb_std = NULL;
 		frame->skb_prp = NULL;
 		frame->skb_hsr = skb;
 		frame->sequence_nr = hsr_get_skb_sequence_nr(skb);
-		return;
+		return 0;
 	}
 
 	/* Standard frame or PRP from master port */
 	handle_std_frame(skb, frame);
+
+	return 0;
 }
 
-void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
-			 struct hsr_frame_info *frame)
+int prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
+			struct hsr_frame_info *frame)
 {
 	/* Supervision frame */
 	struct prp_rct *rct = skb_get_PRP_rct(skb);
@@ -507,9 +513,11 @@ void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
 		frame->skb_std = NULL;
 		frame->skb_prp = skb;
 		frame->sequence_nr = prp_get_skb_sequence_nr(rct);
-		return;
+		return 0;
 	}
 	handle_std_frame(skb, frame);
+
+	return 0;
 }
 
 static int fill_frame_info(struct hsr_frame_info *frame,
@@ -519,9 +527,10 @@ static int fill_frame_info(struct hsr_frame_info *frame,
 	struct hsr_vlan_ethhdr *vlan_hdr;
 	struct ethhdr *ethhdr;
 	__be16 proto;
+	int ret;
 
-	/* Check if skb contains hsr_ethhdr */
-	if (skb->mac_len < sizeof(struct hsr_ethhdr))
+	/* Check if skb contains ethhdr */
+	if (skb->mac_len < sizeof(struct ethhdr))
 		return -EINVAL;
 
 	memset(frame, 0, sizeof(*frame));
@@ -548,7 +557,10 @@ static int fill_frame_info(struct hsr_frame_info *frame,
 
 	frame->is_from_san = false;
 	frame->port_rcv = port;
-	hsr->proto_ops->fill_frame_info(proto, skb, frame);
+	ret = hsr->proto_ops->fill_frame_info(proto, skb, frame);
+	if (ret)
+		return ret;
+
 	check_local_dest(port->hsr, skb, frame);
 
 	return 0;
diff --git a/net/hsr/hsr_forward.h b/net/hsr/hsr_forward.h
index b6acaafa83fc..206636750b30 100644
--- a/net/hsr/hsr_forward.h
+++ b/net/hsr/hsr_forward.h
@@ -24,8 +24,8 @@ struct sk_buff *prp_get_untagged_frame(struct hsr_frame_info *frame,
 				       struct hsr_port *port);
 bool prp_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port);
 bool hsr_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port);
-void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
-			 struct hsr_frame_info *frame);
-void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
-			 struct hsr_frame_info *frame);
+int prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
+			struct hsr_frame_info *frame);
+int hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
+			struct hsr_frame_info *frame);
 #endif /* __HSR_FORWARD_H */
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 8f264672b70b..53d1f7a82463 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -186,8 +186,8 @@ struct hsr_proto_ops {
 					       struct hsr_port *port);
 	struct sk_buff * (*create_tagged_frame)(struct hsr_frame_info *frame,
 						struct hsr_port *port);
-	void (*fill_frame_info)(__be16 proto, struct sk_buff *skb,
-				struct hsr_frame_info *frame);
+	int (*fill_frame_info)(__be16 proto, struct sk_buff *skb,
+			       struct hsr_frame_info *frame);
 	bool (*invalid_dan_ingress_frame)(__be16 protocol);
 	void (*update_san_info)(struct hsr_node *node, bool is_sup);
 };
diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index c5227d42faf5..b70e6bbf6021 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -60,12 +60,11 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 		goto finish_pass;
 
 	skb_push(skb, ETH_HLEN);
-
-	if (skb_mac_header(skb) != skb->data) {
-		WARN_ONCE(1, "%s:%d: Malformed frame at source port %s)\n",
-			  __func__, __LINE__, port->dev->name);
-		goto finish_consume;
-	}
+	skb_reset_mac_header(skb);
+	if ((!hsr->prot_version && protocol == htons(ETH_P_PRP)) ||
+	    protocol == htons(ETH_P_HSR))
+		skb_set_network_header(skb, ETH_HLEN + HSR_HLEN);
+	skb_reset_mac_len(skb);
 
 	hsr_forward_skb(skb, port);
 
-- 
2.11.0

