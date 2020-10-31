Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943FC2A1934
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgJaSLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgJaSLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 14:11:20 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20353C0617A6;
        Sat, 31 Oct 2020 11:11:20 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id r10so7537977pgb.10;
        Sat, 31 Oct 2020 11:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kgjTZ7AtCZGnMu7reRKzrJNKspD5ReY/6YK7OXZaldU=;
        b=eLzZ0AwCNFLsBFfwc8wDaxDh9stLAj2iJ18DsxYB/ojqQJjoSbuy0ISnXTphd35ovz
         CJgSQDhs5MrQL3h/Q91QyVeR5lVcBXx5n7WyXKQL3siMRM7Y/uFO2EEFZv6PIyIVgQpz
         iRq7H2+ktsrJZZvGd4hlVkVaBP8pBMT0W9SeHcAPMoG8RYNA+PA3oDV5Znbu5MSW2S3I
         YeHj2pXkB2pA9+OzTlm3zlyeA015xK50D/nvkdBOlIoIGJWPLiAAs1tx52cNu0XRcy6h
         rcxIfc9Lf1qM+m0N8f+DmjJnVys2zYprjs8pZa3NKxN/795y+CZON+AeOKJTU18PuhcY
         Rp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kgjTZ7AtCZGnMu7reRKzrJNKspD5ReY/6YK7OXZaldU=;
        b=X6I01qz4zLvRjzA7E7+q1pXmTIFMlYfEiU0kTdaiBikyzIRwS9Sy/x3cqc3uZ3JaVg
         DdRaEz2azNxppJvW5Dc4OX1VmnijC406Bcv1eATw/MbbfUEhvalaKKgdMGAIdpW0p8X/
         /IgUFMfLzM6OpW/c8Bmzg0a0HUhN9CocduKLuiSksd58XmxbcFRWn/VynlDauEVyAwPt
         6/2uVKE34+lcSbTBxix1cwgyBRZkrwE0nru/e7Ey8WLetbDleSCmon2mzpgddR658+X5
         HcZcR4o1tAkTsT7O5XK5w3LQ0DAMUA7cJgJXrxRYXv7crNRlLBnzg/iRN8fCo0ZdJSpk
         NvvQ==
X-Gm-Message-State: AOAM530csj88G4x0sUPD1IwqvJE2bYYpvBtjBa3CRLRK4dxFgWURGMPc
        jxoEZ9kW+DnwByYaVqdE0UM=
X-Google-Smtp-Source: ABdhPJwuu95auB3fJKNZFFXvW7jTyWVqcJb3o7Mf+EO1juTlf8iuYGw4FtzJC71hy5tB94kzf1Pu0w==
X-Received: by 2002:a63:5421:: with SMTP id i33mr7314056pgb.316.1604167879672;
        Sat, 31 Oct 2020 11:11:19 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:32f8:16e7:6105:7fb5])
        by smtp.gmail.com with ESMTPSA id n6sm6967137pjj.34.2020.10.31.11.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 11:11:19 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v7 1/5] net: hdlc_fr: Simpify fr_rx by using "goto rx_drop" to drop frames
Date:   Sat, 31 Oct 2020 11:10:39 -0700
Message-Id: <20201031181043.805329-2-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031181043.805329-1-xie.he.0141@gmail.com>
References: <20201031181043.805329-1-xie.he.0141@gmail.com>
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

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 409e5a7ad8e2..4db0e01b96a9 100644
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
@@ -982,12 +979,12 @@ static int fr_rx(struct sk_buff *skb)
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
 	dev_kfree_skb_any(skb);
 	return NET_RX_DROP;
 }
-- 
2.27.0

