Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5EA4B588C
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 18:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244982AbiBNRc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 12:32:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238624AbiBNRcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 12:32:55 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4445065406;
        Mon, 14 Feb 2022 09:32:46 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id v12so28125573wrv.2;
        Mon, 14 Feb 2022 09:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hptSBMKt9IKU4INC+fVfwFIMnoNyAn21o8ZVMp5gKAY=;
        b=iNRKLvIPYB87xGwXyPBV7ueJX2pIL+OQ+ad9WyTyI/i5DIs57p08UIKXvEhmqchtIk
         HKgQ3CfxJnZyDP5D58rvmkWv+KpTxtXkFY8Drr+BuVz0WeW9A0zi7zYAwA+VkiMhMn9l
         XtT7Mx0O5ZcqOTEW5gP43UWzfsb47DgDLg/+3E/OLi09JeptW8FEMUC9hD00DR4uyE9g
         +cotBCIY1iJh2Vijh6PMPzG3iNurpTGVLVrNakPUiV7l9+YMn3nDPPRRn5eYQWRynom7
         pS/2kWv8e3864DAS3NAapts5WG3VqWFvaMO0Du76Cq7uwgSmTmvcfFJGhOuKSMreBRYG
         6XIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hptSBMKt9IKU4INC+fVfwFIMnoNyAn21o8ZVMp5gKAY=;
        b=2fBMMHPnpXaGkCwCPfD9iGcK8EEYQmMKCV3M7uLM2B1GSwLH40e4xiU9hQqcwfM9wG
         QX2/FW2nmQMGuDARz69ojnqby4yOphaaPW4FW/bUMHebhVYJkBxOgXihQn88D6MvEGWt
         W4sLfjrVLCGfOBm73YHMdaxTTHCYKhA49yklkLh/TXHELY+CC1f8rFNGqHlngytEtzOI
         kjinWm6VLnlf3ZCMhp8Rix993Nja4CWGE0QC26LAE1UGC9Qrte2NwcUYsJsGK5aR0siz
         lDYHq+HVGZm4RkmwO+Odba0l659y2zk6XRNgI9ythYMdwQhEQvVIipeebRlFDg/20Doe
         siJg==
X-Gm-Message-State: AOAM530yttr/3a8I3A5kwRoih8VHKbSnwmGNVKqD4PuMD/S68WgvY7B1
        VlJf/O9rGyWAQMGXfOI+bMNfY+nh2fmgMQ==
X-Google-Smtp-Source: ABdhPJy0+4MMhFyDRD81SLmmOEANHZ/y98v/g3IHCQ7+IXmwjkyG8WbdFOV12AKcRWQ0BRgLP6n32g==
X-Received: by 2002:adf:e68a:: with SMTP id r10mr72416wrm.498.1644859964823;
        Mon, 14 Feb 2022 09:32:44 -0800 (PST)
Received: from syracuse.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id p4sm7039125wmq.40.2022.02.14.09.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 09:32:44 -0800 (PST)
From:   Nicolas Escande <nico.escande@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Michal Kazior <michal.kazior@tieto.com>,
        Thomas Pedersen <thomas@cozybit.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nicolas Escande <nico.escande@gmail.com>,
        Remi Pommarel <repk@triplefau.lt>
Subject: [PATCH] mac80211: fix forwarded mesh frames AC & queue selection
Date:   Mon, 14 Feb 2022 18:32:14 +0100
Message-Id: <20220214173214.368862-1-nico.escande@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two problems with the current code that have been highlighted
with the AQL feature that is now enbaled by default.

First problem is in ieee80211_rx_h_mesh_fwding(),
ieee80211_select_queue_80211() is used on received packets to choose
the sending AC queue of the forwarding packet although this function
should only be called on TX packet (it uses ieee80211_tx_info).
This ends with forwarded mesh packets been sent on unrelated random AC
queue. To fix that, AC queue can directly be infered from skb->priority
which has been extracted from QOS info (see ieee80211_parse_qos()).

Second problem is the value of queue_mapping set on forwarded mesh
frames via skb_set_queue_mapping() is not the AC of the packet but a
hardware queue index. This may or may not work depending on AC to HW
queue mapping which is driver specific.

Both of these issues lead to improper AC selection while forwarding
mesh packets but more importantly due to improper airtime accounting
(which is done on a per STA, per AC basis) caused traffic stall with
the introduction of AQL.

Fixes: cf44012810cc ("mac80211: fix unnecessary frame drops in mesh fwding")
Fixes: d3c1597b8d1b ("mac80211: fix forwarded mesh frame queue mapping")
Co-developed-by: Remi Pommarel <repk@triplefau.lt>
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
---
 net/mac80211/rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8885d3923bed..ca7e1f99a8c0 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2923,13 +2923,13 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	    ether_addr_equal(sdata->vif.addr, hdr->addr3))
 		return RX_CONTINUE;
 
-	ac = ieee80211_select_queue_80211(sdata, skb, hdr);
+	ac = ieee802_1d_to_ac[skb->priority];
 	q = sdata->vif.hw_queue[ac];
 	if (ieee80211_queue_stopped(&local->hw, q)) {
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_congestion);
 		return RX_DROP_MONITOR;
 	}
-	skb_set_queue_mapping(skb, q);
+	skb_set_queue_mapping(skb, ac);
 
 	if (!--mesh_hdr->ttl) {
 		if (!is_multicast_ether_addr(hdr->addr1))
-- 
2.35.1

