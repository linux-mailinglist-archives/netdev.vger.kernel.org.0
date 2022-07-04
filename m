Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3892564FEF
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 10:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiGDIog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 04:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiGDIoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 04:44:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C16B7FD
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 01:44:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id w2-20020a25ef42000000b0066d68be3fbcso7248725ybm.13
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 01:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=auOTRbYq5IQ7VGf4mWr9uR5suqYTHw8ybacsAeqMeSw=;
        b=EZ9yu2ay5nqh0vsC0uyJNu9nOdm3bB0199Ud/DYqT+taW8LG3i/cnllUoM/dkfb2MQ
         bOVGPXfRj0/NTRTKQDHR1N1ThJUg/6EuzwVzqEowKJ03n5sQ2+ZkdgHGpATbspYkEXcv
         Ow9GV9cLgYl3xQIFhTIbXyIVqKIXzsNplEINpylCBw064LjvNjiGaWVS3XdqayAu6Bxu
         AQSepfMTEchYZLSui8/QWEvyxpNxcUAQk5B1OPp1OR7gt/GAHZ6BaYJiHK1IkKitQPSz
         aM0T679uRunB3hfsEkXuU0F8RXK+xrMWqfIYpbfbFbRPYxuSj4xD6yNwg4RIfIanzYS5
         WJcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=auOTRbYq5IQ7VGf4mWr9uR5suqYTHw8ybacsAeqMeSw=;
        b=il3IpHxIdbQyJPqo3oV1kMGodPw2cyxa6penMcxDiab57R9mLIkHNLyz1g+KjZXUq5
         mXlqvcIcSUvZTBuqMVP9UMsgvOpNLVMy6YmTMdjn28PqfZ8Ya/V0akO+UnOQAj/Jdtou
         kT2Rm5h58H/u+JghKYgIdwNcC/RffZU3CGmnljLyCH+LbeRRDuspK5UV82Xkt41bDXxu
         eKyTVyLfo9/Yn2S/XTqiGL6NqWToYbH2NHcOKyaJsjb6Fh1o/FkzXoXh9cowEVPWKrI2
         KOYcj/kJ20eSN6pktS3P0QjsjsRMZeNrXqWomp3O1uqEY571QvNX4gArTLc/c1nD2E/3
         lBeg==
X-Gm-Message-State: AJIora/ifpRrG78yT0762Qn8zgYkNu27f4OO0FuIx9U+hLT6Ybc3O0xC
        gTxENSc5Doc19R7TnPMmSeVEaXOKAEKi
X-Google-Smtp-Source: AGRyM1uK0OrarQn4Is+pvY7wtJypAuIfqiih90NjOUib0E6p65n3J3/suHZswDlCDVuN6+5Xpy9bEyv9xHYN
X-Received: from jeongik.seo.corp.google.com ([2401:fa00:d:11:b90:150b:7488:26ea])
 (user=jeongik job=sendgmr) by 2002:a25:9ac9:0:b0:66e:4531:d3aa with SMTP id
 t9-20020a259ac9000000b0066e4531d3aamr5178728ybo.182.1656924273211; Mon, 04
 Jul 2022 01:44:33 -0700 (PDT)
Date:   Mon,  4 Jul 2022 17:43:54 +0900
Message-Id: <20220704084354.3556326-1-jeongik@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v1] wifi: mac80211_hwsim: fix race condition in pending packet
From:   Jeongik Cha <jeongik@google.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     adelva@google.com, kernel-team@android.com, jaeman@google.com,
        Jeongik Cha <jeongik@google.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A pending packet uses a cookie as an unique key, but it can be duplicated
because it didn't use atomic operators.

And also, a pending packet can be null in hwsim_tx_info_frame_received_nl
due to race condition with mac80211_hwsim_stop.

For this,
 * Use an atomic type and operator for a cookie
 * Add a lock around the loop for pending packets

Signed-off-by: Jeongik Cha <jeongik@google.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c5bb97b381cf..ea006248ffcd 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -687,7 +687,7 @@ struct mac80211_hwsim_data {
 	bool ps_poll_pending;
 	struct dentry *debugfs;
 
-	uintptr_t pending_cookie;
+	atomic64_t pending_cookie;
 	struct sk_buff_head pending;	/* packets pending */
 	/*
 	 * Only radios in the same group can communicate together (the
@@ -1358,7 +1358,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	int i;
 	struct hwsim_tx_rate tx_attempts[IEEE80211_TX_MAX_RATES];
 	struct hwsim_tx_rate_flag tx_attempts_flags[IEEE80211_TX_MAX_RATES];
-	uintptr_t cookie;
+	u64 cookie;
 
 	if (data->ps != PS_DISABLED)
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
@@ -1427,8 +1427,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 		goto nla_put_failure;
 
 	/* We create a cookie to identify this skb */
-	data->pending_cookie++;
-	cookie = data->pending_cookie;
+	cookie = (u64)atomic64_inc_return(&data->pending_cookie);
 	info->rate_driver_data[0] = (void *)cookie;
 	if (nla_put_u64_64bit(skb, HWSIM_ATTR_COOKIE, cookie, HWSIM_ATTR_PAD))
 		goto nla_put_failure;
@@ -4178,6 +4177,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	const u8 *src;
 	unsigned int hwsim_flags;
 	int i;
+	unsigned long flags;
 	bool found = false;
 
 	if (!info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER] ||
@@ -4205,18 +4205,20 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	}
 
 	/* look for the skb matching the cookie passed back from user */
+	spin_lock_irqsave(&data2->pending.lock, flags);
 	skb_queue_walk_safe(&data2->pending, skb, tmp) {
 		u64 skb_cookie;
 
 		txi = IEEE80211_SKB_CB(skb);
-		skb_cookie = (u64)(uintptr_t)txi->rate_driver_data[0];
+		skb_cookie = (u64)txi->rate_driver_data[0];
 
 		if (skb_cookie == ret_skb_cookie) {
-			skb_unlink(skb, &data2->pending);
+			__skb_unlink(skb, &data2->pending);
 			found = true;
 			break;
 		}
 	}
+	spin_unlock_irqrestore(&data2->pending.lock, flags);
 
 	/* not found */
 	if (!found)
-- 
2.37.0.rc0.161.g10f37bed90-goog

