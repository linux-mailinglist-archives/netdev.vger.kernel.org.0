Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871F82A1225
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725446AbgJaAt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgJaAt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 20:49:26 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3F7C0613D5;
        Fri, 30 Oct 2020 17:49:26 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id e7so6687820pfn.12;
        Fri, 30 Oct 2020 17:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cjMCdG09ajCIeGjE6JAeqeJcdXO8wcIf1ld4hrAVODI=;
        b=kacWA0sZ8POUDiEBWao8MwtlPpE6rQS55B5KMXefLuvui5CLrhXgf8qwPz2gT7EvSc
         HSqR9aFTqlDmRPoVExgP7m0x+bxMNUq0pKGJbdkP6ARetVgDFTKsquvhloHoe2B+gkAL
         yCZueTyIWOLb9BP+gB77dpkDuF2gj16B0E9ZjOSWuahy3jmiMqf5/C7EenJSi4XDYIe+
         oTUpMtz02Id7aSHP7tAtnGpfFy8tsxAaq77woeGhwA4YLIh0TxGM8kJPLlpYwoKVv56A
         wEpDbET/XvTGXavUcSO6zwtGGH/kroaewUEJIZtH7XN+k0c+e4lP/0C/hAktzrt/TCGu
         LvjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cjMCdG09ajCIeGjE6JAeqeJcdXO8wcIf1ld4hrAVODI=;
        b=s8RNUWaxWUIDMBMXrFgZKZMlZY3mQdrPwZ0r2j7qlzB5HijhesH3kIILbgN7TI6JTB
         rw0ejOIz3gqtru+NkqH3GWcis6CTk50PC8JWEkSRO2I1xOcNRfc/RTJjx/2CCU37eOk1
         mz2F2TSWyKThgUONBRRSBIbFPvR2lG0MM0InrMULez5Ip40ZBVaQz0W+RK6xbS8+E+14
         JwPC8fpXBb/o8F3/burmRVE5C3TL+6zPb2nRjRl4mt3fv4Bp/qoGdJyfC5ctTKCIbBJM
         xfrFP27o/aUlea25KHtzp/vHrRiQJt8wpMnX+HDq4AFsh0h1uat3d863vIkuZViHfQ/X
         AspQ==
X-Gm-Message-State: AOAM531P7lKh1y9vjTgA1yNqhers0UM07cb0BLbEUbiTLjsjXTEc5O2y
        YcWuPMMHh9WoXyCcF4c38nI=
X-Google-Smtp-Source: ABdhPJxrVWbCTmTRWoxCktTa4fEfrM1pUb5OyFqBptFLh4a7EHskHnWBYUOEp9GoHH8Wz7wQK3Vmtw==
X-Received: by 2002:aa7:9e4a:0:b029:152:54d1:bffa with SMTP id z10-20020aa79e4a0000b029015254d1bffamr11592683pfq.6.1604105366362;
        Fri, 30 Oct 2020 17:49:26 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:48fd:1408:262f:a64b])
        by smtp.gmail.com with ESMTPSA id w10sm4466634pjy.57.2020.10.30.17.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 17:49:25 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v6 1/5] net: hdlc_fr: Simpify fr_rx by using "goto rx_drop" to drop frames
Date:   Fri, 30 Oct 2020 17:49:14 -0700
Message-Id: <20201031004918.463475-2-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031004918.463475-1-xie.he.0141@gmail.com>
References: <20201031004918.463475-1-xie.he.0141@gmail.com>
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

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
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

