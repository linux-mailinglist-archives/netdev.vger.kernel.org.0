Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C993A4066E4
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 07:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhIJFlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 01:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbhIJFlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 01:41:07 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551CBC061574;
        Thu,  9 Sep 2021 22:39:57 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q68so833208pga.9;
        Thu, 09 Sep 2021 22:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vbOH6ll+rNRptf5bFlhufPxCFK/dpsvHD3JWD57fqWc=;
        b=WGMmLd9Ckc6BmriCW8TMj9Nn19IF1+iwy9YH/ZeaLqX7IyTcJhfhg9SNrX1mWPVUMg
         Pzn0DJMKOCA4NRNmwGpu01gYvZMf1XYoCPbkg2LgiFLCt7/0Ie6feJbOiDx+JE1qe4SW
         Qpx8ifaZh79NGsqkPLgeJlFJZTVUKfSkjg5umE4xpTj+MxMxB45Knl6KwCDN0T6X8Qud
         a2TngecUDOBQa47O7rTXn6hPL/I3ivBy9IZMZn69tEbdORJXvR3Ff1avNHjWrbyqRe0p
         aUXRVkKC9GqtMaxYfKcMMoVW51Vvgu1uVuL3B/XUt3SrlFZcxqWLIEWN2fjgEJRdIxON
         anSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vbOH6ll+rNRptf5bFlhufPxCFK/dpsvHD3JWD57fqWc=;
        b=SF18NOqXTScRiRNTeiNiGzv4uqgbeMAlNuTWGEpgLw4RIkV/lw0XXETohfU3nAC2bt
         KQF/py+JXg6wc8a+KwUs2+x1VD+I1iHu96o4SpvvDJkkJInsPchHNuAyJla0Ly1AxZvk
         lildeOPjoqCeW4MfEXhhC25eD+XytJyV3pvonhjRAh3IHuj7FZxKyxrhSz2PVtETbx+P
         bJ4AEhxY+1FsJpA0dHrQfFlLbU0Nsmy36UpJx8RO2yX2JwQLSuzjeVfZXToi9OrcZWoo
         O4L5DO4ct0fDz5X4Y/Ov8yBnEWiOsb7GGLSHMxKFHDJ0LqY6E0B5PKk6+fW0RK9DMrGU
         JmsQ==
X-Gm-Message-State: AOAM533yZSoizai63KvhUYsTuaXMKkE0UAgJuj49KH2jlviBtue00Xzg
        s/0KcfWUQAjCRbiiE+mgLq4=
X-Google-Smtp-Source: ABdhPJwUp+hfHZCdHLBtXqHfk98qf4zhS80c0Fy1ZmZrMzoiU0SnfoJUXK6JF+1qENKyylogv39+XQ==
X-Received: by 2002:aa7:9282:0:b0:3e2:800a:b423 with SMTP id j2-20020aa79282000000b003e2800ab423mr6378282pfa.21.1631252396876;
        Thu, 09 Sep 2021 22:39:56 -0700 (PDT)
Received: from linux-VirtualBox.. ([203.205.141.115])
        by smtp.gmail.com with ESMTPSA id c24sm3980295pfd.145.2021.09.09.22.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 22:39:56 -0700 (PDT)
From:   Xingbang Liu <liu.airalert@gmail.com>
To:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com
Cc:     ryder.lee@mediatek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Xingbang Liu <liu.airalert@gmail.com>
Subject: [PATCH] mt76: move spin_lock_bh to spin_lock in tasklet
Date:   Fri, 10 Sep 2021 13:39:28 +0800
Message-Id: <20210910053928.7254-1-liu.airalert@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

as you are already in a tasklet, it is unnecessary to call spin_lock_bh.

Signed-off-by: Xingbang Liu <liu.airalert@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index b50084bbe83d..00b9d9efc5a9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -53,7 +53,7 @@ static void mt76x02_pre_tbtt_tasklet(struct tasklet_struct *t)
 		mt76_skb_set_moredata(data.tail[i], false);
 	}
 
-	spin_lock_bh(&q->lock);
+	spin_lock(&q->lock);
 	while ((skb = __skb_dequeue(&data.q)) != NULL) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 		struct ieee80211_vif *vif = info->control.vif;
@@ -61,7 +61,7 @@ static void mt76x02_pre_tbtt_tasklet(struct tasklet_struct *t)
 
 		mt76_tx_queue_skb(dev, q, skb, &mvif->group_wcid, NULL);
 	}
-	spin_unlock_bh(&q->lock);
+	spin_unlock(&q->lock);
 }
 
 static void mt76x02e_pre_tbtt_enable(struct mt76x02_dev *dev, bool en)
-- 
2.30.2

