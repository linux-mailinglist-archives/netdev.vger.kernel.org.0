Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A562827AF
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 02:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgJDAqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 20:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgJDAqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 20:46:33 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0185CC0613D0;
        Sat,  3 Oct 2020 17:46:31 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id m34so3395050pgl.9;
        Sat, 03 Oct 2020 17:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6r6RL9e1qhZOQX0ZPp753geJ25FtPvAxzDPE0jBfeis=;
        b=K6Jt/W7npzsbKy1kiYPFULQm+OrcskutH+CXTtjOhDBbupCaQDQr7+b2MLp1QK1kCD
         CB/QS7YmWUyRCYhLYF9xeNvcnwsRaWqmnqt+ml44pK+5ZGyjnEH0ov94tz1FtY9J6mKj
         1/U9z5Ygk9y2r6/WAcViCVaTR9N1sXEz+VLWbrde6yaL/i/2Mh1bui85Y8IGJWO5V+hs
         vGbLLNOnHn24qtJ/ljmSd51TIlmEJpM5FzndFgi9YH+tCiljG36Ou7+UnjWt5mwkEEqX
         oc75mWpLETztAfYlrQMU3pfIeLL+sxCrZ22PXDs3Fzbx5EZWGAyLeSNUHOg1aD5bUgI9
         S5tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6r6RL9e1qhZOQX0ZPp753geJ25FtPvAxzDPE0jBfeis=;
        b=RhuUVSeSPhgxaOvH8cq3xy1oaMpeU/JqryFG/fsIW6B3Q7o2h8wa8sFaIpMEGPcB4s
         06rjmQqUZJzTyY1OKuFpSYX4EWaWPI/orlc2itxFB2uEpCSF9WSXk8NEljt/zoiUaOBr
         HC9pHHwKEPY+maCwmtIXYP20cFjHt8n/4EwEpdkq2InwOmHTCbFAcMwBFlw+vvR/nRd6
         Zf0f+0GNIgTemcvWRFrq1kyrO2wZ5909yZb27OJbAyNdb/5OOGAwqtL0jBvYMeh7n0PU
         Imx2AygWJ4+hdal67rEZrTw+zqyisogqa2u4ncqQjLFQrMDEh1+QkKkaX4WcxddUw0uc
         7k1A==
X-Gm-Message-State: AOAM530pLK33dF223ay21m4XbeqKjebgc7aEepj/k74N/1RFrM2oA97A
        NCK7xjMoqpVw9+351CnsD0GFTR1PNx4=
X-Google-Smtp-Source: ABdhPJxB2EmK27kfOusQ6Yx6b0BgJOnrVIHAEIDYIBRbxS7SYpO1CHZLpMdKGUQHD942ExlR0g0Z/Q==
X-Received: by 2002:a62:6287:0:b029:142:2501:3982 with SMTP id w129-20020a6262870000b029014225013982mr9499022pfb.71.1601772391415;
        Sat, 03 Oct 2020 17:46:31 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:12f:64be:90c0:b4c2])
        by smtp.gmail.com with ESMTPSA id k4sm7556973pfp.189.2020.10.03.17.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 17:46:30 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net] drivers/net/wan: lapb: Replace the skb->len checks with pskb_may_pull
Date:   Sat,  3 Oct 2020 17:46:19 -0700
Message-Id: <20201004004619.291065-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of these skb->len checks in these drivers is to ensure that
there is a header in the skb available to be read and pulled.

However, we already have the pskb_may_pull function for this purpose.

The pskb_may_pull function also correctly handles non-linear skbs.

(Also delete the word "check" in the comments because pskb_may_pull may
do things other than simple checks in the case of non-linear skbs.)

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_x25.c  | 4 ++--
 drivers/net/wan/lapbether.c | 4 ++--
 drivers/net/wan/x25_asy.c   | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index f52b9fed0593..891a7a918b29 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -108,9 +108,9 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 	int result;
 
 	/* There should be a pseudo header of 1 byte added by upper layers.
-	 * Check to make sure it is there before reading it.
+	 * Make sure it is there before reading it.
 	 */
-	if (skb->len < 1) {
+	if (!pskb_may_pull(skb, 1)) {
 		kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index b6be2454b8bd..e0cf692357d6 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -158,9 +158,9 @@ static netdev_tx_t lapbeth_xmit(struct sk_buff *skb,
 		goto drop;
 
 	/* There should be a pseudo header of 1 byte added by upper layers.
-	 * Check to make sure it is there before reading it.
+	 * Make sure it is there before reading it.
 	 */
-	if (skb->len < 1)
+	if (!pskb_may_pull(skb, 1))
 		goto drop;
 
 	switch (skb->data[0]) {
diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
index c418767a890a..b935a3e1d5f6 100644
--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/net/wan/x25_asy.c
@@ -308,9 +308,9 @@ static netdev_tx_t x25_asy_xmit(struct sk_buff *skb,
 	}
 
 	/* There should be a pseudo header of 1 byte added by upper layers.
-	 * Check to make sure it is there before reading it.
+	 * Make sure it is there before reading it.
 	 */
-	if (skb->len < 1) {
+	if (!pskb_may_pull(skb, 1)) {
 		kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
-- 
2.25.1

