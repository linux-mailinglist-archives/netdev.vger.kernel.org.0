Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3E62A1201
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgJaAio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgJaAim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 20:38:42 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7424C0613D5;
        Fri, 30 Oct 2020 17:38:42 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 133so6694970pfx.11;
        Fri, 30 Oct 2020 17:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cjMCdG09ajCIeGjE6JAeqeJcdXO8wcIf1ld4hrAVODI=;
        b=gdcZPv+uFueEpQohSYWQNByAbTVm0ck9UEzSpmQcVx4O0KQ+T9Gbwn0BLk/ND2FE8B
         p5dwfYA1cYB23UMXc159mY9JV3ZUJr/q2UkDMsm1nof+lb3VyPNQGG5IC5Ny8e0nkVNy
         RQyUCJwzsGUYEZGXzfBLxYX4L2evdpZZN77+wWE1xMdG6BUQh8oa8j8fHB8cWTwHPSfi
         JE+uGngD4L5peDj3KjJWlmruww1hPpmdwg9E/4sHg5S3fDCl99wZ6M6E1SFzqmxmtAfD
         WE9ok7MPjHOZZbQE41v3XjqOHWvOsNeIdxqBcphPk5YFz3MOD44+gpRCfTKkDPhQSbJv
         39Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cjMCdG09ajCIeGjE6JAeqeJcdXO8wcIf1ld4hrAVODI=;
        b=FrNkqgP7E+h81z6XAT+jNgJCCPWOzAQMLnm55PoGse1tjPe2xLtlqOZK1SBjioPCsP
         eb8UHvn1zuxXy3vrKu3yNntlupGwEQMQMEuhVK1UbfwvjnO9R3dMghq9QYRloUxVhwY/
         HhJgzSXr3IFKW3ijjPlf9eJhk0A9RE1ntcWNskfdm340uInLUNoe91gSs9H/Ux1Hthw1
         A3sfq+T4FxKolv670WT9fUC5tzhQvddHyDz4QRMoA1sJNZ/wHdXZdJZ3QUiDjP99SsMr
         6ExqvCi20sHtOEvIdoF3/oguuEoMtxwdhKHoaq0cy4GTUXY66+AGKNa9D/FxT8PmkNJC
         Mczw==
X-Gm-Message-State: AOAM530kkm7+1J+rWyZLsJW/OF1JCeGF7MWX0HSD0+0plJvYCTuyvMVp
        Ide0UVzMdBTsY6zOF1jIP0g=
X-Google-Smtp-Source: ABdhPJwzIshB5hKVZrESSfs4Ybl92hgrCXUjqrqkeN7akwhaDH5GYqGmyeW+Tj1h83hdetXiqMvZUg==
X-Received: by 2002:a63:e642:: with SMTP id p2mr4231347pgj.79.1604104722318;
        Fri, 30 Oct 2020 17:38:42 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:48fd:1408:262f:a64b])
        by smtp.gmail.com with ESMTPSA id ch21sm4596888pjb.24.2020.10.30.17.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 17:38:41 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v5 1/5] net: hdlc_fr: Simpify fr_rx by using "goto rx_drop" to drop frames
Date:   Fri, 30 Oct 2020 17:37:27 -0700
Message-Id: <20201031003731.461437-2-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031003731.461437-1-xie.he.0141@gmail.com>
References: <20201031003731.461437-1-xie.he.0141@gmail.com>
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

