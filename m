Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA4650B1AC
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 09:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444849AbiDVHeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 03:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386165AbiDVHd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 03:33:59 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA2350456;
        Fri, 22 Apr 2022 00:31:06 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d15so9024431pll.10;
        Fri, 22 Apr 2022 00:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RKXep+OukE4SdMu+cRqxBY4lHOeFUaKFcve1sEKphTA=;
        b=NApdQprPkR9X5KsKrlEItbVibHuWQMkdC6R6dIz1a0f8v08lro3Bt24bmFnX9gcIUx
         c/CvMMP1C6TE4xFIq4EpE5DIOaTjyjH6xH5joQX9P6/5DJZ+IbV+IvM0ol6mB2xYZlhG
         ZTyVvc5ig+But+NxDHgUFqIMABOyzzpBRgumMgBNEQCyAcFoDVvB5Y3PX8Ksc90G1FVm
         Pt8yRgXMrkTN4XFq3qouYGABgtD26N572duYyZbbeU6OL3GSkiuET0oTQYqIl9l3ZWEt
         FBd2MdLEjvpOMkA7XjU06fb3qigQP1aSyhn1W/PkkQe0fsN1gQRQkuCWl/iTdyYTVmxE
         x1Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RKXep+OukE4SdMu+cRqxBY4lHOeFUaKFcve1sEKphTA=;
        b=KU7llvZbey2rou858586wRlm8nYbG8c3azN1u6BTNoWTydRKK1UPWPi+PufUpXURYj
         itk9jvHYpPvBbHYKEtcGZHtggZPPQakoGMPjAZBHfASbpuEddXtQX6WyX+GUd89aHtZE
         WhNdnogjdQVS3yp6ytJk60pxQv/eDpZGakpKUdUqnhxOZtJOgt/NDiHKSKyN1H9JjqtI
         Ql5gUKDGuciHmqoGtPwK/+bwPVw71gwGYgZXwvEiGgK61e8OJzLM3zI+83ZC52KVo7rR
         SAWumqdPlCVusUbQ53OkrgVUxwRch3BJgeWrKxL7K/+p6DO23VcXoMOUz0KQpXRTrlE/
         QuUA==
X-Gm-Message-State: AOAM5305GOs+YkzJnw+TNPTmF3JTw4uBw77lTTyIvp0syscMhpWBAfUJ
        1sMIivioDoIIHyiC2I2f4b0=
X-Google-Smtp-Source: ABdhPJwiJ6sRVKvla0sQE/4lcm4QNy8KLY5artA5wt36MqIypf9P32Jf5A47gdWp+q1ok87ey6bU9w==
X-Received: by 2002:a17:902:d50c:b0:159:3fa:266 with SMTP id b12-20020a170902d50c00b0015903fa0266mr3311422plg.132.1650612666216;
        Fri, 22 Apr 2022 00:31:06 -0700 (PDT)
Received: from localhost ([58.251.76.82])
        by smtp.gmail.com with ESMTPSA id l25-20020a635719000000b0039da6cdf82dsm1287484pgb.83.2022.04.22.00.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 00:31:05 -0700 (PDT)
From:   Yunbo Yu <yuyunbo519@gmail.com>
To:     nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, yuyunbo519@gmail.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] mt76:mt7603: move spin_lock_bh() to spin_lock()
Date:   Fri, 22 Apr 2022 15:31:02 +0800
Message-Id: <20220422073102.426739-1-yuyunbo519@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is unnecessary to call spin_lock_bh(), for you are already in a tasklet.

Signed-off-by: Yunbo Yu <yuyunbo519@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
index 5d4522f440b7..b5e8308e0cc7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
@@ -82,12 +82,12 @@ void mt7603_pre_tbtt_tasklet(struct tasklet_struct *t)
 	__skb_queue_head_init(&data.q);
 
 	q = dev->mphy.q_tx[MT_TXQ_BEACON];
-	spin_lock_bh(&q->lock);
+	spin_lock(&q->lock);
 	ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
 		IEEE80211_IFACE_ITER_RESUME_ALL,
 		mt7603_update_beacon_iter, dev);
 	mt76_queue_kick(dev, q);
-	spin_unlock_bh(&q->lock);
+	spin_unlock(&q->lock);
 
 	/* Flush all previous CAB queue packets */
 	mt76_wr(dev, MT_WF_ARB_CAB_FLUSH, GENMASK(30, 16) | BIT(0));
@@ -117,7 +117,7 @@ void mt7603_pre_tbtt_tasklet(struct tasklet_struct *t)
 		mt76_skb_set_moredata(data.tail[i], false);
 	}
 
-	spin_lock_bh(&q->lock);
+	spin_lock(&q->lock);
 	while ((skb = __skb_dequeue(&data.q)) != NULL) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 		struct ieee80211_vif *vif = info->control.vif;
@@ -126,7 +126,7 @@ void mt7603_pre_tbtt_tasklet(struct tasklet_struct *t)
 		mt76_tx_queue_skb(dev, q, skb, &mvif->sta.wcid, NULL);
 	}
 	mt76_queue_kick(dev, q);
-	spin_unlock_bh(&q->lock);
+	spin_unlock(&q->lock);
 
 	for (i = 0; i < ARRAY_SIZE(data.count); i++)
 		mt76_wr(dev, MT_WF_ARB_CAB_COUNT_B0_REG(i),
-- 
2.25.1

