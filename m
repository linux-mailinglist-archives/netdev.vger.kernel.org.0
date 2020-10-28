Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6C429D4EC
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgJ1Vzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbgJ1Vzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:55:37 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCD7C0613CF;
        Wed, 28 Oct 2020 14:55:37 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id n18so421890vsl.2;
        Wed, 28 Oct 2020 14:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xlNmuHQ+BurcadNmXEhYfuLEuxMLXCWKJpkTUb50b+g=;
        b=ua7p9eUz0VZTYnprfPwzXc9tHlEBxA9jB2z0A5xuUACtbjVQnbEilkQyrxulVgUitI
         6v8ZDuWz0+iueLRNUjGJCvCoJSNVHmE3hG+AAAOmIKox+vn/6D/3Ro+1RdJJTfHOsEx4
         BkdKbv/TTD/oCT+bCdBsxD/3ND6dOB3Mh7i70wG2EH7m3XDbjQQs9Wd4ya77UDIH+oh2
         6h/6Vl2ou1ykIwalJkchaBkIQbj4+JYaF9auLDCf5Vffzooa3+InOEaNtJPoo51y6LAS
         MdA3Z0Yr5c6LbLWFZSz98qGKXk2iX9xRiT8KkSeALGD9fiy5Bkd0s8jY0ZDr36OrxHUV
         RbDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xlNmuHQ+BurcadNmXEhYfuLEuxMLXCWKJpkTUb50b+g=;
        b=V/R16T952+Y3aYzvEbupZuNvDuX0k2ROR1To6hviJDKC3peYb/Dy9m1fyvIZ7RhtlH
         Gkfw/K68nXGK5bWv8OSkTSJz8GWabWrhOm2ikf7Ceb/wwzw4KcDIuWgJn4AkvvFZbdoH
         XQjka5iD4RRnzQjk9WhUA71tPKGw76pHNTFu+TGlop21B3wZEPW6/Vwsko5HfU4a2D4w
         v2yd1sabeLTDKFNE5dOQ1t1gah8SuqYpzEYT5K/i/Z8n/gb5DEBwxpNuvpzaOxu4jNZ8
         MAo65kKKqQCKiUP33wgkSuz9d7whOyRRcULm1ZOGN/GQUcqcnxnOFgfekvmWQtjpKRO0
         XV2w==
X-Gm-Message-State: AOAM530hTv+sWSMD+R3xJLPIZ1CDG4V0WHr7m4hqpUt8LRx/gBNWL+Tl
        J16O8ZntZxbximNuHOenh0SqEyV40Mw=
X-Google-Smtp-Source: ABdhPJyb6BDH2uHq4GsoWPXDBjiwAM1y6GE+lAkFDG1gsPzS/Xnd/5Izu/YUbjYDnTIGKDYpmWMEew==
X-Received: by 2002:a17:902:b217:b029:d6:fba:ddd8 with SMTP id t23-20020a170902b217b02900d60fbaddd8mr606442plr.9.1603910600943;
        Wed, 28 Oct 2020 11:43:20 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:6d80:dec8:7340:3009])
        by smtp.gmail.com with ESMTPSA id y27sm309785pfr.122.2020.10.28.11.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 11:43:20 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v3 1/4] net: hdlc_fr: Simpify fr_rx by using "goto rx_drop" to drop frames
Date:   Wed, 28 Oct 2020 11:43:07 -0700
Message-Id: <20201028184310.7017-2-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201028184310.7017-1-xie.he.0141@gmail.com>
References: <20201028184310.7017-1-xie.he.0141@gmail.com>
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

