Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52F82AC002
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731754AbgKIPhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:37:32 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.171]:35257 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729919AbgKIPhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:37:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1604936240;
        s=strato-dkim-0002; d=hartkopp.net;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=ecLj+raN9lp+p+BbOBNexizerl00vA8Zu20B0jMAA4Q=;
        b=OLnUP4d1Nof67INrY7vyiexvjw7JKqEl1oxcaUE13dJP+PNeI5ghFiTYK0q7R+liyQ
        eNn87QksCnIM+ero28Ed77sRYghbPtQ6pNEemVsEMkoVa2GHHFs2ReEwx65We+XvKsWR
        9XvHwn2WC8RZoroJ6Rp0Rihw5h8iv1YV+ouDUgjyITj8lV5SdWXQPUhrYxuDf4ebHQ9y
        xpc3ZgGW9DXsWsU/B3tSrLms7DNfh08O2dXOPmksX5nG9GgnD13wDSqIgX4bqJldBJ8L
        PdMSB0H+DQa7wEd2L1Bbty8KJ/zoMO1UtFklOEVi6TC56EoFcXPTm+QachuCHCIEBZuY
        83XQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0lu8GW272ZqqIaA=="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 47.3.3 DYNA|AUTH)
        with ESMTPSA id V0298cwA9FbE85d
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 9 Nov 2020 16:37:14 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org, mkl@pengutronix.de,
        mailhol.vincent@wanadoo.fr
Cc:     netdev@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH v5 7/8] can-dev: introduce helpers to access Classical CAN DLC values
Date:   Mon,  9 Nov 2020 16:36:56 +0100
Message-Id: <20201109153657.17897-8-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201109153657.17897-1-socketcan@hartkopp.net>
References: <20201109153657.17897-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

can_get_len8_dlc: get value to fill len8_dlc at frame reception time
can_get_cc_dlc: get DLC value to be written into CAN controller

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 include/linux/can/dev.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index e767a96ae075..f25558609d09 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -168,10 +168,29 @@ static inline bool can_is_canfd_skb(const struct sk_buff *skb)
 {
 	/* the CAN specific type of skb is identified by its data length */
 	return skb->len == CANFD_MTU;
 }
 
+/* helper to handle len8_dlc value for Classical CAN raw DLC access */
+static inline u8 can_check_len8_dlc(u32 ctrlmode, u8 len, u8 dlc, u8 ret)
+{
+	/* return value for len8_dlc only if all conditions apply */
+	if ((ctrlmode & CAN_CTRLMODE_CC_LEN8_DLC) &&
+	    (len == CAN_MAX_DLEN) &&
+	    (dlc > CAN_MAX_DLEN && dlc <= CAN_MAX_RAW_DLC))
+		ret = dlc;
+
+	/* no valid len8_dlc value -> return provided default value */
+	return ret;
+}
+
+/* get value to fill len8_dlc in struct can_frame at frame reception time */
+#define can_get_len8_dlc(cm, len, dlc) can_check_len8_dlc(cm, len, dlc, 0)
+
+/* get DLC value to be written into Classical CAN controller at tx time */
+#define can_get_cc_dlc(cm, len, dlc) can_check_len8_dlc(cm, len, dlc, len)
+
 /* helper to define static CAN controller features at device creation time */
 static inline void can_set_static_ctrlmode(struct net_device *dev,
 					   u32 static_mode)
 {
 	struct can_priv *priv = netdev_priv(dev);
-- 
2.28.0

