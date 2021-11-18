Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4131045629F
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 19:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhKRSoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 13:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhKRSoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 13:44:06 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CF5C06173E
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 10:41:06 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id np3so5826469pjb.4
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 10:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FMXWh89VZYemVKOC1nOMHXOf0EkNJ7d1gpgnv25tUVA=;
        b=e0gTQuWbEEtIR6jAswuqe+bkuCE6ahVYPnYSdcovJFIrFzZ/E5K/EHyURvZC+zqcR4
         Ud0ZAXqm7TsnXdZci3MKz31N1Wl7VXOcibg3+0aUK3Ajr9vqznw44JW+gKqMiqJYqrur
         yY0Y00qptmYuAtm918Hnbl0GEk/U430JYyiRk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FMXWh89VZYemVKOC1nOMHXOf0EkNJ7d1gpgnv25tUVA=;
        b=Wxi5U/T2WSATUWogqS5O52CQ6135j5z59x3z08H+a0gRn81bijoVd7gWl7hpVI3oMw
         iGqLV+Sw+5+jwuJz0bUxj8E9TunL7UCQzENCoVmuXlytOz/MsBpNhd5c8zWgcd4WLfr6
         b9iKrzPn/hjytsd1GqmL6SXMuSOsvu6EjFHon22hMompCHujvirXllcceMzO2HTovTme
         8YOMwAv84SuS9xTiISqfwtbz48ai+SBL3YVrCrtM8KKVTpwNStFvwAlIehC3kEB4mDsQ
         pZUP23wB2xXiYxW+gvUgJo2Ezzh6Xz13Ow95o39dyCy7ySKSqFIVDEoKtkCK5Jw5k+U6
         JH6Q==
X-Gm-Message-State: AOAM533fPEtNTgwEjD32oJArTHbqIrIIJGB9nzaY4c7LCAOIir7PYdx9
        NKphSQCk3GmhfjybD5IeSc704Q==
X-Google-Smtp-Source: ABdhPJzW+zKuM2db9SP+myHZwjczhP0UwUeIL3sioy/PloyCYSpO2ZFN4/7xzppaWZPkVNuT6wdSfQ==
X-Received: by 2002:a17:902:9047:b0:143:6e5f:a480 with SMTP id w7-20020a170902904700b001436e5fa480mr69200036plz.66.1637260865870;
        Thu, 18 Nov 2021 10:41:05 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y4sm316063pfi.178.2021.11.18.10.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:41:05 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] libertas: Use struct_group() for memcpy() region
Date:   Thu, 18 Nov 2021 10:41:04 -0800
Message-Id: <20211118184104.1283637-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2740; h=from:subject; bh=aefCoJhV9lyPmgKpvdOWTp1eHgAAy3wtBLWPOfGvPCw=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhlp4/xcQA7hFiK/M9yqFXiZTlrkWV9wESsqNUkUC3 ENS25TmJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZaePwAKCRCJcvTf3G3AJpVQD/ 9sfbXlovmw71iDiRDrMna0brdH2vsTbqkC/68UeZ2f5OthAyzd5wKbCPrZMdk8rRAwTgObYWAY+Hpu M3FLiHgD0jkpiyx5wHMTVKlmqSb6hin9nXuWshmEIIAcKh+PJcGgLAVjLa+g/QCyJPzH9dkSUt/7Yk Y8eXABrgwWnvNUvQc6sikL8b2jgJMR0Nr5yV44SxTstHd1OwFSi8FIk/q0nFcmk2hH3q46R2YlLV/Y 24aF3/ryOhyXvagYXYvxsi8g12kUXh0xVR98IcF/R29YNsEv/ZxrNUK8rIakUfuBi1LguyHjEFgyNc KGa0XOdHCCZ9EeLvIltgNYTUkgnS2yirWlBqOweZoLOd14b3NRhHYOdB9jMHt/m85Kas0rokjzikHZ 5SSg4mNgvAGuhST54qxVm5CYjI2R+8Yofr30tjtMJq0kYfjjdEH7YagXkzawvV5eVkwagv124BYBbh MB0avOFv7P3J170sM8LqUU+7QxF0TiIVUqCeaw3eNIeYWfB5bl4amU5sOxBFx7LajLHnQpnhwhe/hq jJgA4LFryoMmXs0vcgmRq/+n5EjpmVJvajEsP6PNO6fcnx15h0ozpmKelxVzynP9+FKZ6D7tILJG28 DYW0f65jkCsw8PJzgaZhPYdEABv1NMAVcQEXN9E+I8K8vuUztRSnjGha+0Vg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use struct_group() in struct txpd around members tx_dest_addr_high
and tx_dest_addr_low so they can be referenced together. This will
allow memcpy() and sizeof() to more easily reason about sizes, improve
readability, and avoid future warnings about writing beyond the end
of queue_id.

"pahole" shows no size nor member offset changes to struct txpd.
"objdump -d" shows no object code changes.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/marvell/libertas/host.h | 10 ++++++----
 drivers/net/wireless/marvell/libertas/tx.c   |  5 +++--
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/host.h b/drivers/net/wireless/marvell/libertas/host.h
index dfa22468b14a..af96bdba3b2b 100644
--- a/drivers/net/wireless/marvell/libertas/host.h
+++ b/drivers/net/wireless/marvell/libertas/host.h
@@ -308,10 +308,12 @@ struct txpd {
 	__le32 tx_packet_location;
 	/* Tx packet length */
 	__le16 tx_packet_length;
-	/* First 2 byte of destination MAC address */
-	u8 tx_dest_addr_high[2];
-	/* Last 4 byte of destination MAC address */
-	u8 tx_dest_addr_low[4];
+	struct_group(tx_dest_addr,
+		/* First 2 byte of destination MAC address */
+		u8 tx_dest_addr_high[2];
+		/* Last 4 byte of destination MAC address */
+		u8 tx_dest_addr_low[4];
+	);
 	/* Pkt Priority */
 	u8 priority;
 	/* Pkt Trasnit Power control */
diff --git a/drivers/net/wireless/marvell/libertas/tx.c b/drivers/net/wireless/marvell/libertas/tx.c
index aeb481740df6..27304a98787d 100644
--- a/drivers/net/wireless/marvell/libertas/tx.c
+++ b/drivers/net/wireless/marvell/libertas/tx.c
@@ -113,6 +113,7 @@ netdev_tx_t lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	p802x_hdr = skb->data;
 	pkt_len = skb->len;
 
+	BUILD_BUG_ON(sizeof(txpd->tx_dest_addr) != ETH_ALEN);
 	if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR) {
 		struct tx_radiotap_hdr *rtap_hdr = (void *)skb->data;
 
@@ -124,10 +125,10 @@ netdev_tx_t lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		pkt_len -= sizeof(*rtap_hdr);
 
 		/* copy destination address from 802.11 header */
-		memcpy(txpd->tx_dest_addr_high, p802x_hdr + 4, ETH_ALEN);
+		memcpy(&txpd->tx_dest_addr, p802x_hdr + 4, ETH_ALEN);
 	} else {
 		/* copy destination address from 802.3 header */
-		memcpy(txpd->tx_dest_addr_high, p802x_hdr, ETH_ALEN);
+		memcpy(&txpd->tx_dest_addr, p802x_hdr, ETH_ALEN);
 	}
 
 	txpd->tx_packet_length = cpu_to_le16(pkt_len);
-- 
2.30.2

