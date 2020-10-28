Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D0529D66F
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731258AbgJ1WPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731169AbgJ1WO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:14:58 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16679C0613CF;
        Wed, 28 Oct 2020 15:14:58 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id f7so1216033oib.4;
        Wed, 28 Oct 2020 15:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xlNmuHQ+BurcadNmXEhYfuLEuxMLXCWKJpkTUb50b+g=;
        b=OMer9PgudM2qrnbUBtpwUrHKq3k0ysrbxREBqVzxytSi+h1XUebQZKhGd8T1a21x/7
         KLLr8uJLR3LWoZqz0ohhgd6mE/aFUso3eocvUB3kuRCwnTRz8vlfgjMY0U2Pv0pCLSHw
         oZ2As9OT8T3o0ewzcovm0oY5SQCzimZyfF4pmrDKazKL2OCDGZ6Tpd8daQqs/8uCPxgn
         fSoRDIoG2v9hH0xw1lqJkPazOjaPUz/YFDUPKyGwnLXkZbfB2n8ZAc0f4MMBXGAjlLuC
         r0lq/VjBn2+ys+/oJ7lP6oeYcq+GdZqQxGQ8fdoDR9scy6AugICXe3a1r4r0Szfz6ZbP
         LIzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xlNmuHQ+BurcadNmXEhYfuLEuxMLXCWKJpkTUb50b+g=;
        b=pAaZoG49tZNQgHobAbtXbS1EITe2yegMMncS/fZ8zSMD/1Aa6pMhFA4XezScUKPQlc
         T3P045Ndmfi8RUhcyzeyzxrAsrcYprWItQ98bP4bpSih30xN89mloN/Bay9o1K5AyfOB
         NADMnM/YaQYY0RAaE4vUMHwfuW1Fz7+wRhvrsMw/FJN/AD61wlhMRabdapz/OxRapek7
         Kh5ggqxAklg1e8Ybv8cRh8cEK3uy/HcLyd4vmGKITwqKZqmsxCD5zugTOGIMGqFWkRo3
         WYYB4oYBUvO/NbXZl76jgMucV/x3RG8vHkKGPej9X9KWrrrJV5bQ2rrUiF3zCP0XUd5u
         PfAw==
X-Gm-Message-State: AOAM532lTD1nl46diOGX/1kjfYA5gj/OMzyhml6Uav9s9JlbenqPqclx
        M+fgHpHA9Lh9v8qkDSoPTktPLAbDpZU=
X-Google-Smtp-Source: ABdhPJzcQJwRp+BDmVFqn5LbXNMh8FhmEkJagKVbZ7eeJAu5pfxzsGivllrVnXFTHF0W6gLfgteIow==
X-Received: by 2002:a17:90a:ba8d:: with SMTP id t13mr6655997pjr.38.1603891181528;
        Wed, 28 Oct 2020 06:19:41 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:6d80:dec8:7340:3009])
        by smtp.gmail.com with ESMTPSA id r8sm7058032pgn.30.2020.10.28.06.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 06:19:40 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v2 1/4] net: hdlc_fr: Simpify fr_rx by using "goto rx_drop" to drop frames
Date:   Wed, 28 Oct 2020 06:18:04 -0700
Message-Id: <20201028131807.3371-2-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201028131807.3371-1-xie.he.0141@gmail.com>
References: <20201028131807.3371-1-xie.he.0141@gmail.com>
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

