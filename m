Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B38370F57
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 23:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbhEBV1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 17:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbhEBV1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 17:27:08 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38295C061756
        for <netdev@vger.kernel.org>; Sun,  2 May 2021 14:26:16 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id a4so3571130wrr.2
        for <netdev@vger.kernel.org>; Sun, 02 May 2021 14:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1f6e8zwd73xcuu+M0+ulI1EAzn/vnTXaP43/udO8Fco=;
        b=wdchoLlFu0oXaP3V0PnhW38ZkiAt7nuUsrOpHgSwaJF/8rYhAHrubm3KUZyhg+0MMF
         tjkSVzSWKToJ1Ir94+PGnRq4xWlNAd3AmW4BSnxolUIVzDf0Iy2R1tC7HGLVkoClcM0G
         pnrPvi/mzZYN/Wb7DFeqvCY2PX3TaobXZ+8jj3ekqD0dz2Fp6UOKvEwXL2ebYUrAYgh7
         7OHSvjM3FA8fwnP6ADiHH6FFkCx8LA0NBU4+jO56Glnm0k4gDopflUdjgtYMu0mjfN5Q
         LDUY+eAHs1td6rUzMJVeu0wtXQ7Xkzfc+c8voSuv6cq8qpFRTXBopAnmtVa/5vjcNELb
         ERfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1f6e8zwd73xcuu+M0+ulI1EAzn/vnTXaP43/udO8Fco=;
        b=tXb1VMthKUy8D71DqK0xCH7YPx2cEmvJQ6HpfZZsBhNZnx9Yxisk7FO/NPVgBK6D9R
         B4ZLX+tg9TXLOyQgZCVFr1GmAWjct0Uy2Z8HY+G/GW4Q5DK0t1RxzDb/OMAbaVMHwlG1
         x9IHHcp3nwHsL/BtWJ2hmftjhEJCKGa8g480f4yTr/SgB1J1ztbXyI46eZ2C7tYrVtWY
         gXmiAmdRhO2UkMQNvO+E8Lldaj0V1RsHRtJ8r8X9760egvJjLOM92cnWR2bKjCoMD4GF
         wXcUrovcxWvh+9Q4PoAJ9AxaI0jhnJDk+t0GMSXYAf9rEq/vxflK6aHiGkyXBbPRe7UP
         4+JQ==
X-Gm-Message-State: AOAM5333GeL1nxv7B66LS1+5UedVvUXriG9rL37lVe8It5B8Kh+XhWx3
        oiaLW7BNZ70G1zCwcSCtvvUpplMcIbzo5PPI
X-Google-Smtp-Source: ABdhPJx9rjrSzGR8PtaSC+fMtO1z+69DtioROXNL7hK61+QY6ntNyOO5lvHBm0ehtACpTVAFopruyQ==
X-Received: by 2002:adf:fd82:: with SMTP id d2mr21415707wrr.218.1619990774860;
        Sun, 02 May 2021 14:26:14 -0700 (PDT)
Received: from localhost.localdomain (2.0.5.1.1.6.3.8.5.c.c.3.f.b.d.3.0.0.0.0.6.1.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:df16:0:3dbf:3cc5:8361:1502])
        by smtp.gmail.com with ESMTPSA id l18sm10084424wrx.96.2021.05.02.14.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 14:26:14 -0700 (PDT)
From:   Phillip Potter <phil@philpotter.co.uk>
To:     kvalo@codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        fw@strlen.de
Subject: [PATCH v2] ath9k: ath9k_htc_rx_msg: return when sk_buff is too small
Date:   Sun,  2 May 2021 22:26:11 +0100
Message-Id: <20210502212611.1818-1-phil@philpotter.co.uk>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the start of ath9k_htc_rx_msg, we check to see if the skb pointer is
valid, but what we don't do is check if it is large enough to contain a
valid struct htc_frame_hdr. We should check for this and return if not,
as the buffer is invalid in this case. Fixes a KMSAN-found uninit-value bug
reported by syzbot at:
https://syzkaller.appspot.com/bug?id=7dccb7d9ad4251df1c49f370607a49e1f09644ee

Reported-by: syzbot+e4534e8c1c382508312c@syzkaller.appspotmail.com
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
---

V2:
* Free skb properly when this problem is detected, as pointed out by
  Florian Westphal.

---
 drivers/net/wireless/ath/ath9k/htc_hst.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 510e61e97dbc..1fe89b068ac4 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -406,6 +406,11 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 	if (!htc_handle || !skb)
 		return;
 
+	if (!pskb_may_pull(skb, sizeof(struct htc_frame_hdr))) {
+		kfree_skb(skb);
+		return;
+	}
+
 	htc_hdr = (struct htc_frame_hdr *) skb->data;
 	epid = htc_hdr->endpoint_id;
 
-- 
2.30.2

