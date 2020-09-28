Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADAF27AE72
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 14:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgI1M5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 08:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbgI1M47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 08:56:59 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE21C061755;
        Mon, 28 Sep 2020 05:56:59 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 197so805215pge.8;
        Mon, 28 Sep 2020 05:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mRYM/ijXhKyqcG0hlYbKfkBIgPJZyqY3iZRUkY2MEAM=;
        b=K2BpzpUGM5K+keY0Wj/FUqJFwjDK4osnAOoEiEuSAPpmlaLnAbYQXKAPpBKZNmme8g
         +NlzUyroaDHcu7YqhUBU98qKgvzFk0YFmyvZe2n3+teCxbuLgA1yafjqlG0/FwM7g2h+
         iNcsaNiFdiwz/Al92fAhMcyFwBvREAJizcJvg8tRYYqG++NAMdxWh4nMdf4pUGr/ieIW
         4p5euwrO5Aqdz/OB/hQc36kmoQOKYV17caUlmaIZ24ucWie72p0/nvLmdYHEK77cMwbi
         poMiwhK2/mT7L6isHqNUbHFTrUksqZxV+V49W7rwV3qfgf2Kg9vKlpduqPIyNErsyqA5
         mJ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mRYM/ijXhKyqcG0hlYbKfkBIgPJZyqY3iZRUkY2MEAM=;
        b=AaCXnG+q9MQqVm4iocn0nDud7YZ3CWcpItDp29hGifNovKp8+X5a2c80vnlG+7oxQA
         tGdxTO5AXYvhbWNf4cWCq+WGqCTjNQ8uQR4I4/IkyxfxtYJnpJiEc+YticFpbZ1y7I7b
         Mnb6zTLtlBbHRMIrHH+LmyzlI94JAZIka3eFejC1IzsYEOWcP5pQTQ0unRTliYNdtXd9
         rN15OvnOllY9uE0M4uIBpFVwDjhKy85RX6ezqV4+G7CvM7UoABPzTtd2BL3CWwU0G58p
         P6PKSg2O/y7xBuAIgG42HKuGonXdIXsaNHQ2mA1muNX+8fjbONVkriFSk3c4ZSBlTp6t
         +uRg==
X-Gm-Message-State: AOAM533RbQUAXm9LvZ2q6Tarw7tIaX30teqmI6DbD851tIve7fW2s4Ml
        0n9GFZVRf9lmrgCvgZYV2QE=
X-Google-Smtp-Source: ABdhPJwx5YX5q+hrrI/wiwlHvD8cQ+jpbLwTzMvdZp15W0n7M8nFP3RT+BaViMrLdTfrhwji76axGg==
X-Received: by 2002:aa7:941a:0:b029:142:2501:35d1 with SMTP id x26-20020aa7941a0000b0290142250135d1mr1279322pfo.49.1601297818865;
        Mon, 28 Sep 2020 05:56:58 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:1405:efe3:1493:1a47])
        by smtp.gmail.com with ESMTPSA id b2sm1686819pfp.3.2020.09.28.05.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 05:56:58 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next] drivers/net/wan/hdlc_fr: Correctly handle special skb->protocol values
Date:   Mon, 28 Sep 2020 05:56:43 -0700
Message-Id: <20200928125643.396575-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fr_hard_header function is used to prepend the header to skbs before
transmission. It is used in 3 situations:
1) When a control packet is generated internally in this driver;
2) When a user sends an skb on an Ethernet-emulating PVC device;
3) When a user sends an skb on a normal PVC device.

These 3 situations need to be handled differently by fr_hard_header.
Different headers should be prepended to the skb in different situations.

Currently fr_hard_header distinguishes these 3 situations using
skb->protocol. For situation 1 and 2, a special skb->protocol value
will be assigned before calling fr_hard_header, so that it can recognize
these 2 situations. All skb->protocol values other than these special ones
are treated by fr_hard_header as situation 3.

However, it is possible that in situation 3, the user sends an skb with
one of the special skb->protocol values. In this case, fr_hard_header
would incorrectly treat it as situation 1 or 2.

This patch tries to solve this issue by using skb->dev instead of
skb->protocol to distinguish between these 3 situations. For situation
1, skb->dev would be NULL; for situation 2, skb->dev->type would be
ARPHRD_ETHER; and for situation 3, skb->dev->type would be ARPHRD_DLCI.

This way fr_hard_header would be able to distinguish these 3 situations
correctly regardless what skb->protocol value the user tries to use in
situation 3.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 98 ++++++++++++++++++++-------------------
 1 file changed, 51 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index d6cfd51613ed..3a44dad87602 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -273,63 +273,69 @@ static inline struct net_device **get_dev_p(struct pvc_device *pvc,
 
 static int fr_hard_header(struct sk_buff **skb_p, u16 dlci)
 {
-	u16 head_len;
 	struct sk_buff *skb = *skb_p;
 
-	switch (skb->protocol) {
-	case cpu_to_be16(NLPID_CCITT_ANSI_LMI):
-		head_len = 4;
-		skb_push(skb, head_len);
-		skb->data[3] = NLPID_CCITT_ANSI_LMI;
-		break;
-
-	case cpu_to_be16(NLPID_CISCO_LMI):
-		head_len = 4;
-		skb_push(skb, head_len);
-		skb->data[3] = NLPID_CISCO_LMI;
-		break;
-
-	case cpu_to_be16(ETH_P_IP):
-		head_len = 4;
-		skb_push(skb, head_len);
-		skb->data[3] = NLPID_IP;
-		break;
-
-	case cpu_to_be16(ETH_P_IPV6):
-		head_len = 4;
-		skb_push(skb, head_len);
-		skb->data[3] = NLPID_IPV6;
-		break;
-
-	case cpu_to_be16(ETH_P_802_3):
-		head_len = 10;
-		if (skb_headroom(skb) < head_len) {
-			struct sk_buff *skb2 = skb_realloc_headroom(skb,
-								    head_len);
+	if (!skb->dev) { /* Control packets */
+		switch (dlci) {
+		case LMI_CCITT_ANSI_DLCI:
+			skb_push(skb, 4);
+			skb->data[3] = NLPID_CCITT_ANSI_LMI;
+			break;
+
+		case LMI_CISCO_DLCI:
+			skb_push(skb, 4);
+			skb->data[3] = NLPID_CISCO_LMI;
+			break;
+
+		default:
+			return -EINVAL;
+		}
+
+	} else if (skb->dev->type == ARPHRD_DLCI) {
+		switch (skb->protocol) {
+		case htons(ETH_P_IP):
+			skb_push(skb, 4);
+			skb->data[3] = NLPID_IP;
+			break;
+
+		case htons(ETH_P_IPV6):
+			skb_push(skb, 4);
+			skb->data[3] = NLPID_IPV6;
+			break;
+
+		default:
+			skb_push(skb, 10);
+			skb->data[3] = FR_PAD;
+			skb->data[4] = NLPID_SNAP;
+			/* OUI 00-00-00 indicates an Ethertype follows */
+			skb->data[5] = 0x00;
+			skb->data[6] = 0x00;
+			skb->data[7] = 0x00;
+			/* This should be an Ethertype: */
+			*(__be16 *)(skb->data + 8) = skb->protocol;
+		}
+
+	} else if (skb->dev->type == ARPHRD_ETHER) {
+		if (skb_headroom(skb) < 10) {
+			struct sk_buff *skb2 = skb_realloc_headroom(skb, 10);
 			if (!skb2)
 				return -ENOBUFS;
 			dev_kfree_skb(skb);
 			skb = *skb_p = skb2;
 		}
-		skb_push(skb, head_len);
+		skb_push(skb, 10);
 		skb->data[3] = FR_PAD;
 		skb->data[4] = NLPID_SNAP;
-		skb->data[5] = FR_PAD;
+		/* OUI 00-80-C2 stands for the 802.1 organization */
+		skb->data[5] = 0x00;
 		skb->data[6] = 0x80;
 		skb->data[7] = 0xC2;
+		/* PID 00-07 stands for Ethernet frames without FCS */
 		skb->data[8] = 0x00;
-		skb->data[9] = 0x07; /* bridged Ethernet frame w/out FCS */
-		break;
+		skb->data[9] = 0x07;
 
-	default:
-		head_len = 10;
-		skb_push(skb, head_len);
-		skb->data[3] = FR_PAD;
-		skb->data[4] = NLPID_SNAP;
-		skb->data[5] = FR_PAD;
-		skb->data[6] = FR_PAD;
-		skb->data[7] = FR_PAD;
-		*(__be16*)(skb->data + 8) = skb->protocol;
+	} else {
+		return -EINVAL;
 	}
 
 	dlci_to_q922(skb->data, dlci);
@@ -425,8 +431,8 @@ static netdev_tx_t pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 				skb_put(skb, pad);
 				memset(skb->data + len, 0, pad);
 			}
-			skb->protocol = cpu_to_be16(ETH_P_802_3);
 		}
+		skb->dev = dev;
 		if (!fr_hard_header(&skb, pvc->dlci)) {
 			dev->stats.tx_bytes += skb->len;
 			dev->stats.tx_packets++;
@@ -494,10 +500,8 @@ static void fr_lmi_send(struct net_device *dev, int fullrep)
 	memset(skb->data, 0, len);
 	skb_reserve(skb, 4);
 	if (lmi == LMI_CISCO) {
-		skb->protocol = cpu_to_be16(NLPID_CISCO_LMI);
 		fr_hard_header(&skb, LMI_CISCO_DLCI);
 	} else {
-		skb->protocol = cpu_to_be16(NLPID_CCITT_ANSI_LMI);
 		fr_hard_header(&skb, LMI_CCITT_ANSI_DLCI);
 	}
 	data = skb_tail_pointer(skb);
-- 
2.25.1

