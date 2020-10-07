Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57692285AAF
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 10:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgJGImw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 04:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgJGImw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 04:42:52 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C0BC061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 01:42:52 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id p11so653018pld.5
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 01:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Q16CnlHGrtfGYZdCKG+lnaMu/nDLkqNnG2AimLjwEg=;
        b=Y88P9jrbWFRaqvgCs9YeFg0uLDQ2BNzlpexIZQoOJcsDZUyi2GLhk/gWEI9mpZXKIY
         CNh1ccfNTQrsuJE+vuFv96MbhBM0QPOVInb7tH/2WUWKQIXl5SccECN7hKqJdRdkLkQ8
         qNgEAEY9FJnabGOXYx/Jj4RwIpqxEvHgFoS+kOXIn4V5Yg3bbrE6AfLEShPOiMvLbNpO
         MW94Z78gy8+Hi8XAxdT0oNUjvuwsG/jf+AbMFjCDS14TYCCi4BjlDC1PKKb2a2KIITv2
         DlY2Tquhzy5Vbn6tP0xclx/GHgQRTrgfKOUanrXKWwx3T4YNFB+F+rva7/m6LwUBAZWX
         dgVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Q16CnlHGrtfGYZdCKG+lnaMu/nDLkqNnG2AimLjwEg=;
        b=atpiSmOE0uVhldkl4gIbjoibbdk1k0n2Rb/Vx6PFvScAWy+ztCCIgzRirBpf1DKRYt
         Ltv2o/ljYnIkVwJQj3hFGEhT9GaepJm5zQ0VoZqHaKc1H/6PXforIdHisRTVc2uqdOSa
         VTgCzYq/h7IpQNNshQ14PGIEeEkIKlPNfTZLa0wNFMah2euP0ba/pOFRj0pER5EH4ceV
         twfg1tYbvq3xMLZpAnlauCXqVjXe42HK45y/145zZWUK77sStbIkmk8Vv/4FS3aA1Pea
         Dx/DTuinm2dwlnQ5+be0gT2bFwbc+5lrbTK2G007HB17U1bnMEyH8SJm/XZav+Atwva7
         vwhQ==
X-Gm-Message-State: AOAM530X4zYVMs0JnXSGPII5NztIeZ5okQ/hbXvzhMjLBv4AZWskgyhK
        lVyMCQxBedr4yxQCys9nQjk=
X-Google-Smtp-Source: ABdhPJy70jT7jcagmtD2iEGn+rPElae+M+2RXpBZpCmeEPddBq0CO5XX8FWUsQyWXTekmxK1TrG6xQ==
X-Received: by 2002:a17:90a:7c0c:: with SMTP id v12mr1946080pjf.71.1602060171637;
        Wed, 07 Oct 2020 01:42:51 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id m188sm2175263pfd.56.2020.10.07.01.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 01:42:50 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] macsec: avoid use-after-free in macsec_handle_frame()
Date:   Wed,  7 Oct 2020 01:42:46 -0700
Message-Id: <20201007084246.4068317-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

De-referencing skb after call to gro_cells_receive() is not allowed.
We need to fetch skb->len earlier.

Fixes: 5491e7c6b1a9 ("macsec: enable GRO and RPS on macsec devices")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/macsec.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 9159846b8b9388644bcf8f136231726d8cf297f2..787ac2c8e74ebef65534291aacb6dc5d9b839b27 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1077,6 +1077,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 	struct macsec_rx_sa *rx_sa;
 	struct macsec_rxh_data *rxd;
 	struct macsec_dev *macsec;
+	unsigned int len;
 	sci_t sci;
 	u32 hdr_pn;
 	bool cbit;
@@ -1232,9 +1233,10 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 	macsec_rxsc_put(rx_sc);
 
 	skb_orphan(skb);
+	len = skb->len;
 	ret = gro_cells_receive(&macsec->gro_cells, skb);
 	if (ret == NET_RX_SUCCESS)
-		count_rx(dev, skb->len);
+		count_rx(dev, len);
 	else
 		macsec->secy.netdev->stats.rx_dropped++;
 
-- 
2.28.0.806.g8561365e88-goog

