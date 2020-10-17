Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEDB290F2E
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 07:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411666AbgJQF3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 01:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411627AbgJQF3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 01:29:43 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00015C05BD31;
        Fri, 16 Oct 2020 22:19:57 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g29so2676948pgl.2;
        Fri, 16 Oct 2020 22:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g4S8FiM9+SxQFJfjVdY05B6e4/CplxY8Vc+xso0Pvpo=;
        b=pLQmnZgsHQKbiHvccGpmqSLOBP1t0JBScHmZpTP8fieLT0xtiqRzdxWWuy/f1t0fGr
         5LArsmGCFrawy4UfJ/H4obnCYzSqvU+o1BTv0bvlTVnmqyl+hAh3O2y2zR3jMlmne2pF
         vWT38/wo6I2u22NfUvNKgMaaTKutrpSL4t7iJXKMNGZaGkso6jJO32iWAKVxnUz/zZMO
         jUkltvVMTB0SGYwyI86GNwRKcZ2/EDo4ZLX8wmR3Xir4xV42wzexjbkeuAMaITaNQXJL
         +00NFqpKooO33yetRM9JvKKw1dx2kPng/CVSElw+cBPgi4tzHykLaaGfTt8sqY4JEZG5
         wCbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g4S8FiM9+SxQFJfjVdY05B6e4/CplxY8Vc+xso0Pvpo=;
        b=Vt07i00Aku+s5ZPvo6CwcDBls9dUbs/V2JNV3JVTeN398C0C+8kbyOd0M80YI5WEN+
         mZteijuf/awSRFENlO4LnQVsmJqbKnNBZTc3Cn9uRrgrUeSeHzTmW00M0kb3Ho5cqtu8
         CUtbDVqoDgdmkgj8oPK1JTfImjRI2QXR5un6BRUwNnqqGYlbfV+Jd9fpQeuP4BJr2AeB
         /N01xu2jRU/bHJLNNy1LC/NazXN6M/YkAEuII95PLfh5OGJ9Mu1oGXHh+FHY2t9d+q57
         zKp8driIKV6olfzGN+PpjPWY0RSAfw9PvEE9r3UJiqilcSStnotXxRMZ9cTl0VvXt6hx
         475w==
X-Gm-Message-State: AOAM532nnVIXYboVG4VFhmYwOaELEUtIoLnWEkNmQj8BMAZqwpHr44f1
        HYgshNS/BcDUmcbkPaOwIPo=
X-Google-Smtp-Source: ABdhPJznEamAzPXJ2wEqNHW/F+jzs/N80l47ArH5F+tK1caxmbDoCwbEdT08bhsVMLhkHoKx8iHznA==
X-Received: by 2002:a63:fc08:: with SMTP id j8mr5910099pgi.138.1602911997313;
        Fri, 16 Oct 2020 22:19:57 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:dd8e:b5f2:63bf:1e61])
        by smtp.gmail.com with ESMTPSA id q81sm4623784pfc.36.2020.10.16.22.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 22:19:56 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next] drivers/net/wan/hdlc_fr: Improve fr_rx and add support for any Ethertype
Date:   Fri, 16 Oct 2020 22:19:51 -0700
Message-Id: <20201017051951.363514-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Change the fr_rx function to make this driver support any Ethertype
when receiving. (This driver is already able to handle any Ethertype
when sending.)

Originally in the fr_rx function, the code that parses the long (10-byte)
header only recognizes a few Ethertype values and drops frames with other
Ethertype values. This patch replaces this code to make fr_rx support
any Ethertype. This patch also creates a new function fr_snap_parse as
part of the new code.

2. Change the use of the "dev" variable in fr_rx. Originally we do
"dev = something", and then at the end do "if (dev) skb->dev = dev".
Now we do "if (something) skb->dev = something", then at the end do
"dev = skb->dev".

This is to make the logic of our code consistent with eth_type_trans
(which we call). The eth_type_trans function expects a non-NULL pointer
as a parameter and assigns it directly to skb->dev.

3. Change the initial skb->len check in fr_fx from "<= 4" to "< 4".
At first we only need to ensure a 4-byte header is present. We indeed
normally need the 5th byte, too, but it'd be more logical to check its
existence when we actually need it.

Also add an fh->ea2 check to the initial checks in fr_fx. fh->ea2 == 1
means the second address byte is the final address byte. We only support
the case where the address length is 2 bytes.

4. Use "goto rx_drop" whenever we need to drop a valid frame.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 119 +++++++++++++++++++++++---------------
 1 file changed, 73 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 409e5a7ad8e2..e95efc14bc97 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -871,6 +871,45 @@ static int fr_lmi_recv(struct net_device *dev, struct sk_buff *skb)
 	return 0;
 }
 
+static int fr_snap_parse(struct sk_buff *skb, struct pvc_device *pvc)
+{
+	/* OUI 00-00-00 indicates an Ethertype follows */
+	if (skb->data[0] == 0x00 &&
+	    skb->data[1] == 0x00 &&
+	    skb->data[2] == 0x00) {
+		if (!pvc->main)
+			return -1;
+		skb->dev = pvc->main;
+		skb->protocol = *(__be16 *)(skb->data + 3); /* Ethertype */
+		skb_pull(skb, 5);
+		skb_reset_mac_header(skb);
+		return 0;
+
+	/* OUI 00-80-C2 stands for the 802.1 organization */
+	} else if (skb->data[0] == 0x00 &&
+		   skb->data[1] == 0x80 &&
+		   skb->data[2] == 0xC2) {
+		/* PID 00-07 stands for Ethernet frames without FCS */
+		if (skb->data[3] == 0x00 &&
+		    skb->data[4] == 0x07) {
+			if (!pvc->ether)
+				return -1;
+			skb_pull(skb, 5);
+			if (skb->len < ETH_HLEN)
+				return -1;
+			skb->protocol = eth_type_trans(skb, pvc->ether);
+			return 0;
+
+		/* PID unsupported */
+		} else {
+			return -1;
+		}
+
+	/* OUI unsupported */
+	} else {
+		return -1;
+	}
+}
 
 static int fr_rx(struct sk_buff *skb)
 {
@@ -880,9 +919,9 @@ static int fr_rx(struct sk_buff *skb)
 	u8 *data = skb->data;
 	u16 dlci;
 	struct pvc_device *pvc;
-	struct net_device *dev = NULL;
+	struct net_device *dev;
 
-	if (skb->len <= 4 || fh->ea1 || data[2] != FR_UI)
+	if (skb->len < 4 || fh->ea1 || !fh->ea2 || data[2] != FR_UI)
 		goto rx_error;
 
 	dlci = q922_to_dlci(skb->data);
@@ -904,8 +943,7 @@ static int fr_rx(struct sk_buff *skb)
 		netdev_info(frad, "No PVC for received frame's DLCI %d\n",
 			    dlci);
 #endif
-		dev_kfree_skb_any(skb);
-		return NET_RX_DROP;
+		goto rx_drop;
 	}
 
 	if (pvc->state.fecn != fh->fecn) {
@@ -931,63 +969,52 @@ static int fr_rx(struct sk_buff *skb)
 	}
 
 	if (data[3] == NLPID_IP) {
+		if (!pvc->main)
+			goto rx_drop;
 		skb_pull(skb, 4); /* Remove 4-byte header (hdr, UI, NLPID) */
-		dev = pvc->main;
+		skb->dev = pvc->main;
 		skb->protocol = htons(ETH_P_IP);
+		skb_reset_mac_header(skb);
 
 	} else if (data[3] == NLPID_IPV6) {
+		if (!pvc->main)
+			goto rx_drop;
 		skb_pull(skb, 4); /* Remove 4-byte header (hdr, UI, NLPID) */
-		dev = pvc->main;
+		skb->dev = pvc->main;
 		skb->protocol = htons(ETH_P_IPV6);
+		skb_reset_mac_header(skb);
 
-	} else if (skb->len > 10 && data[3] == FR_PAD &&
-		   data[4] == NLPID_SNAP && data[5] == FR_PAD) {
-		u16 oui = ntohs(*(__be16*)(data + 6));
-		u16 pid = ntohs(*(__be16*)(data + 8));
-		skb_pull(skb, 10);
-
-		switch ((((u32)oui) << 16) | pid) {
-		case ETH_P_ARP: /* routed frame with SNAP */
-		case ETH_P_IPX:
-		case ETH_P_IP:	/* a long variant */
-		case ETH_P_IPV6:
-			dev = pvc->main;
-			skb->protocol = htons(pid);
-			break;
-
-		case 0x80C20007: /* bridged Ethernet frame */
-			if ((dev = pvc->ether) != NULL)
-				skb->protocol = eth_type_trans(skb, dev);
-			break;
-
-		default:
-			netdev_info(frad, "Unsupported protocol, OUI=%x PID=%x\n",
-				    oui, pid);
-			dev_kfree_skb_any(skb);
-			return NET_RX_DROP;
+	} else if (data[3] == FR_PAD) {
+		if (skb->len < 5)
+			goto rx_error;
+		if (data[4] == NLPID_SNAP) { /* A SNAP header follows */
+			skb_pull(skb, 5);
+			if (skb->len < 5) /* Incomplete SNAP header */
+				goto rx_error;
+			if (fr_snap_parse(skb, pvc))
+				goto rx_drop;
+		} else {
+			goto rx_drop;
 		}
+
 	} else {
 		netdev_info(frad, "Unsupported protocol, NLPID=%x length=%i\n",
 			    data[3], skb->len);
-		dev_kfree_skb_any(skb);
-		return NET_RX_DROP;
+		goto rx_drop;
 	}
 
-	if (dev) {
-		dev->stats.rx_packets++; /* PVC traffic */
-		dev->stats.rx_bytes += skb->len;
-		if (pvc->state.becn)
-			dev->stats.rx_compressed++;
-		skb->dev = dev;
-		netif_rx(skb);
-		return NET_RX_SUCCESS;
-	} else {
-		dev_kfree_skb_any(skb);
-		return NET_RX_DROP;
-	}
+	dev = skb->dev;
+	dev->stats.rx_packets++; /* PVC traffic */
+	dev->stats.rx_bytes += skb->len;
+	if (pvc->state.becn)
+		dev->stats.rx_compressed++;
+	netif_rx(skb);
+	return NET_RX_SUCCESS;
 
- rx_error:
+rx_error:
 	frad->stats.rx_errors++; /* Mark error */
+rx_drop:
+	frad->stats.rx_dropped++;
 	dev_kfree_skb_any(skb);
 	return NET_RX_DROP;
 }
-- 
2.25.1

