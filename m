Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3903129FB44
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 03:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgJ3CaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgJ3CaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 22:30:00 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB70C0613CF;
        Thu, 29 Oct 2020 19:29:58 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g12so3921120pgm.8;
        Thu, 29 Oct 2020 19:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EFNt3m3IFv4Esg6Z6+NQabAOK7nwYfSwuit4QZ/gwa8=;
        b=baJ1KikzA9uMG56fIb1/ZLdJzwk2jWFBf7i0T/YJLq9NUHO2wipQcN5zcPsq1M5k/7
         CF66BLCN27cY+F/GCdZA0w1qbkwl7PVIH5EgF0eQnGaFVAe9Nbz+v5b+7+2xd65vjXk0
         Jg1GeBzqIEXX5QU7atrKLf78Zu9yACySm7Os3rKCopB75H3b2jt460/8Ebhek5fIr3k9
         foZC2Ofa6kCgVzOFxtcMzv1vRxiZEaTR2rIFn7wFNkwjgAE/QOTAYyaG8G1qCXbH62wE
         H87MS8vU3AOL2Y/PdTe54YlNSYJacaAfmvK8mwqiK5eLKIIcE+DpfaKCVc4ySyHqhspa
         SV6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EFNt3m3IFv4Esg6Z6+NQabAOK7nwYfSwuit4QZ/gwa8=;
        b=JMs/p7HAbamY74UybvzaFK/TPhoEuMYA+JeRc5tOOPQBC4K4uLeB09Ie6MaUmq/Vyq
         Nvz5+z/bvs1mMYBlgnW0WB5k1DuAqSLBHQeMeIT0lTEUTBJDoWuA4HxqkweRYk215O3T
         ZFDL7o6BtmPrFNBEEhUGZxEW6RKyLSINCq9x/0wctzJV7DFD3x3ALpTbpn0ppe2nsCSr
         PgZYm8G9tMgefIK47KJQApZeDhZnwTXL/HT5QIS6gtfoJjRGUniAckWpJ/a9NVEh9N6i
         JOWVbQzos9yYoGB+5ao/yWfwAWjVcBLvVNJ9IFSds76qHDZEqYNF/WZQra0Xx2Z0KVU1
         xEHw==
X-Gm-Message-State: AOAM533avcMMxAxSYT9FaxdckUnA0EWcilJYpYiggLSHetnFk7o3lF3u
        Jjdn9LqNk4Le4GWN1UlGAv4=
X-Google-Smtp-Source: ABdhPJx6cpLARbPfA5Jl9Rr+XlUV2zIIzzvvdDTsivaAbU/KuQnJ3mFr//fr5bDkVo9nj/bQ1xJSXQ==
X-Received: by 2002:a17:90a:d983:: with SMTP id d3mr128592pjv.144.1604024998182;
        Thu, 29 Oct 2020 19:29:58 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:dd13:d62a:9d03:9a42])
        by smtp.gmail.com with ESMTPSA id i24sm4216588pfd.7.2020.10.29.19.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 19:29:57 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v4 1/5] net: hdlc_fr: Simpify fr_rx by using "goto rx_drop" to drop frames
Date:   Thu, 29 Oct 2020 19:28:35 -0700
Message-Id: <20201030022839.438135-2-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201030022839.438135-1-xie.he.0141@gmail.com>
References: <20201030022839.438135-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1.
When the fr_rx function drops a received frame (because the protocol type
is not supported, or because the PVC virtual device that corresponds to
the DLCI number and the protocol type doesn't exist), the function frees
the skb and returns.

The code for freeing the skb and returning is repeated several times, this
patch uses "goto rx_drop" to replace them so that the code looks cleaner.

2.
Add code to increase the stats.rx_dropped count whenever we drop a frame.
Increase the stats.rx_dropped count both after "goto rx_drop" and after
"goto rx_error" because I think we should increase this value whenever an
skb is dropped.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
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
2.27.0

