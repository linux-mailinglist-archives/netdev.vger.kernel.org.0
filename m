Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9F429D952
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389529AbgJ1WuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389459AbgJ1WtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:49:16 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FABC0613CF;
        Wed, 28 Oct 2020 15:49:16 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id h6so734269pgk.4;
        Wed, 28 Oct 2020 15:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xlNmuHQ+BurcadNmXEhYfuLEuxMLXCWKJpkTUb50b+g=;
        b=PKxE3xP/JzhxCXC9xc9VcOMaEeH41Fp1vAVLYXvbr/UcZa6AvEhiC5PrvPmfb4oSPu
         YFq64YKVHoZewsVowHUwvsLgYA9ILCEmkB/iN5uKHtzrO2YUjkH7RzyiZPxxc0mxhePV
         jv1dpbV+8fujEh5BKZPbed279Rx1IRsLNZdSqk5h1YiL0oYeMfT5CL/aronCy8OllAAD
         VttxFU4i+Mh+wKMUK6VOr8UR7Ias1+dyWicGygRqurCePrCLIvcTHXraF22KEju5t6W0
         fIAsXJ9l9oKdJ+yhWhfhjK9Tg07iNeAGj3NW9hNnMdSsWSO/R7OQnhxaCymC5yfoaagl
         41Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xlNmuHQ+BurcadNmXEhYfuLEuxMLXCWKJpkTUb50b+g=;
        b=XmE+6htB6VkfTPTdMCPzQWk8PkTu10LWKrk7LXW+IMemuOEIdpHpUqatswV62UAu1+
         nBXPMqWEDbhXxYpGfPnxgmr3yN0qokF709n8MQrjLP2wz7O5EMdnjxaILQL/NYDIFw1I
         Y7Qb7np+p1C2yPAdDN5TWjg0/DSt6WBias6nJkzg3qUUILf3PGl2pXRpjTLNEsIQN3vd
         5JiBhK4W/cpV71MpEBp0NsOWakMqAa6XUBXck7187zB1zdrSDGfzXoL0Fjq93t+5cqsG
         vcQ0Kg5CmkjA2cAU7ifL5iqya273OvkmSg2B1v4+S+hNuoKGqj0psQA/nDYn5Vw/R8L+
         FbOA==
X-Gm-Message-State: AOAM531KPPJqmexK9+HkIt/jk2W8ehytFrBOjBFpHFRtZwBWKZJDp50z
        0hCF7m2HOfZlULT/nDBSXI2ny3e5QUM=
X-Google-Smtp-Source: ABdhPJzR/50Cvki4QOdiAEIFpTQPSl3W+0IduE+iI0wuY7/YptCUkm0sFcZnU/njVHopJ6z9v/eAgw==
X-Received: by 2002:a17:902:9695:b029:d3:8b4f:558c with SMTP id n21-20020a1709029695b02900d38b4f558cmr6797176plp.27.1603882670711;
        Wed, 28 Oct 2020 03:57:50 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:a46c:8b86:395a:7a3d])
        by smtp.gmail.com with ESMTPSA id 65sm557863pge.37.2020.10.28.03.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 03:57:50 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next 1/4] net: hdlc_fr: Simpify fr_rx by using "goto rx_drop" to drop frames
Date:   Wed, 28 Oct 2020 03:57:02 -0700
Message-Id: <20201028105705.460551-2-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201028105705.460551-1-xie.he.0141@gmail.com>
References: <20201028105705.460551-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the fr_rx function drops a received frame (because the protocol type
is not supported, or because the PVC virtual device that corresponds to
the DLCI number and the protocol type doesn't exist), the function frees
the skb and returns.

The code for freeing the skb and returning is repeated several times, this
patch uses "goto rx_drop" to replace them so that the code looks cleaner.

Also add code to increase the stats.rx_dropped count whenever we drop a
frame.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 409e5a7ad8e2..c774eff44534 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -904,8 +904,7 @@ static int fr_rx(struct sk_buff *skb)
 		netdev_info(frad, "No PVC for received frame's DLCI %d\n",
 			    dlci);
 #endif
-		dev_kfree_skb_any(skb);
-		return NET_RX_DROP;
+		goto rx_drop;
 	}
 
 	if (pvc->state.fecn != fh->fecn) {
@@ -963,14 +962,12 @@ static int fr_rx(struct sk_buff *skb)
 		default:
 			netdev_info(frad, "Unsupported protocol, OUI=%x PID=%x\n",
 				    oui, pid);
-			dev_kfree_skb_any(skb);
-			return NET_RX_DROP;
+			goto rx_drop;
 		}
 	} else {
 		netdev_info(frad, "Unsupported protocol, NLPID=%x length=%i\n",
 			    data[3], skb->len);
-		dev_kfree_skb_any(skb);
-		return NET_RX_DROP;
+		goto rx_drop;
 	}
 
 	if (dev) {
@@ -982,12 +979,13 @@ static int fr_rx(struct sk_buff *skb)
 		netif_rx(skb);
 		return NET_RX_SUCCESS;
 	} else {
-		dev_kfree_skb_any(skb);
-		return NET_RX_DROP;
+		goto rx_drop;
 	}
 
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

