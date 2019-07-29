Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6C678952
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbfG2KLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:11:30 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33251 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728225AbfG2KLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:11:23 -0400
Received: by mail-pf1-f196.google.com with SMTP id g2so27784238pfq.0
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 03:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MfcWyafkKwZIt4NSkLuv6NJBzsOv82aUUnCAgbvDzww=;
        b=gVNHkJNgsxP7CcIE61Jw/5AdqvDuSNK9kvV+AVL9CcXQ5Yhh0xfM5WP1RpfNnc4dVf
         iYA9RAJuYeM9X6SucrZIB2LkTpCzgIAWcVvXimFeo1v4a6IAfIvi/zNrfgDepsjp/cgX
         vDdy9cv+GEcPCoxeYdphgrbPZ3pPLDRLdbJvA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MfcWyafkKwZIt4NSkLuv6NJBzsOv82aUUnCAgbvDzww=;
        b=l56iX0K5AXD2HtSmWgNrIMJx13s5qWYUYFUszXztqr1bzKkSWuGJFxqiyI0P/8hAJu
         XQ8F3oJPu53RxMzV0khygubw4iLTkpGOFCA1F8NOkkiCHnmL12VWKqvqlXJ+LT6DkF8a
         eu0FzF0cYowJBMhksg/lVidt/Vr+FHU3bzfceecA7Yx9lCMdRGN0zAu1S5fSEPPa1ZUq
         Sp3vLVPx/HfuZQzFG1mnaPNQCwEmdZKX0PV/kx4vRxMu6osFktQOJhftPyqdWDj9gaeQ
         sK7N5snG07AV0o4xPmSLXeo9EFDX1KfRXtQYkCqa5SLNsycIFuId/HUCWCcUpNNX1zBH
         DOjg==
X-Gm-Message-State: APjAAAWuJoTIy+m5zJ5Z2EdcAa3C4w63q+hVTM0lsS4EOMGj4Q5+sdhF
        rPKcU9RTx8hFtzzKxrGfRzB08zVuHIs=
X-Google-Smtp-Source: APXvYqybxD6A2HKqWWOivL3uFz/SdNETFVk2JS0O+J+ipurHtAd0p47QEW0lOwhPb0e+12vtPuGcUA==
X-Received: by 2002:a17:90a:ac11:: with SMTP id o17mr112650906pjq.134.1564395082956;
        Mon, 29 Jul 2019 03:11:22 -0700 (PDT)
Received: from localhost.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e124sm99045812pfh.181.2019.07.29.03.11.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 03:11:22 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 10/16] bnxt_en: Add hardware GRO setup function for 57500 chips.
Date:   Mon, 29 Jul 2019 06:10:27 -0400
Message-Id: <1564395033-19511-11-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
References: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a more optimized hardware GRO function to setup the SKB on 57500
chips.  Some workaround code is no longer needed on 57500 chips and
the pseudo checksum is also calculated in hardware, so no need to
do the software pseudo checksum in the driver.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 33 ++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e5b1477..36b58df 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1359,6 +1359,35 @@ static struct sk_buff *bnxt_gro_func_5731x(struct bnxt_tpa_info *tpa_info,
 	return skb;
 }
 
+static struct sk_buff *bnxt_gro_func_5750x(struct bnxt_tpa_info *tpa_info,
+					   int payload_off, int tcp_ts,
+					   struct sk_buff *skb)
+{
+#ifdef CONFIG_INET
+	u16 outer_ip_off, inner_ip_off, inner_mac_off;
+	u32 hdr_info = tpa_info->hdr_info;
+	int iphdr_len, nw_off;
+
+	inner_ip_off = BNXT_TPA_INNER_L3_OFF(hdr_info);
+	inner_mac_off = BNXT_TPA_INNER_L2_OFF(hdr_info);
+	outer_ip_off = BNXT_TPA_OUTER_L3_OFF(hdr_info);
+
+	nw_off = inner_ip_off - ETH_HLEN;
+	skb_set_network_header(skb, nw_off);
+	iphdr_len = (tpa_info->flags2 & RX_TPA_START_CMP_FLAGS2_IP_TYPE) ?
+		     sizeof(struct ipv6hdr) : sizeof(struct iphdr);
+	skb_set_transport_header(skb, nw_off + iphdr_len);
+
+	if (inner_mac_off) { /* tunnel */
+		__be16 proto = *((__be16 *)(skb->data + outer_ip_off -
+					    ETH_HLEN - 2));
+
+		bnxt_gro_tunnel(skb, proto);
+	}
+#endif
+	return skb;
+}
+
 #define BNXT_IPV4_HDR_SIZE	(sizeof(struct iphdr) + sizeof(struct tcphdr))
 #define BNXT_IPV6_HDR_SIZE	(sizeof(struct ipv6hdr) + sizeof(struct tcphdr))
 
@@ -10877,8 +10906,10 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 #endif
 	if (BNXT_SUPPORTS_TPA(bp)) {
 		bp->gro_func = bnxt_gro_func_5730x;
-		if (BNXT_CHIP_P4_PLUS(bp))
+		if (BNXT_CHIP_P4(bp))
 			bp->gro_func = bnxt_gro_func_5731x;
+		else if (BNXT_CHIP_P5(bp))
+			bp->gro_func = bnxt_gro_func_5750x;
 	}
 	if (!BNXT_CHIP_P4_PLUS(bp))
 		bp->flags |= BNXT_FLAG_DOUBLE_DB;
-- 
2.5.1

