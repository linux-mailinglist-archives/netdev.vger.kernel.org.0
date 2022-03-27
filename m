Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616854E867B
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 09:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbiC0H2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 03:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiC0H2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 03:28:52 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F2C1AA;
        Sun, 27 Mar 2022 00:27:14 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mp6-20020a17090b190600b001c6841b8a52so15914664pjb.5;
        Sun, 27 Mar 2022 00:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=n9/pEZe4CVIlbTMI+5XnBEGK7G61xg7386/V4aygmpk=;
        b=AC0WM2AVMdygcMQI3kxiOA8DrMyQGAHIMbqEmMfQjs0SVXcbPOgbxB9yGoGQj4QxNB
         IsD/aOLdn0QIScg+l9Zw9WlaWOg/FuyS79K8XFIkXchRQIZbSmhfyvDTHIxsgtgM5+Bz
         uE6WQL3KB5DUxLXAkYBMB06BiGQZosxrn8Zr7+NM+6qBCqpJAE6h/f3Vap5+J8Kw8kqt
         ScAKizIZVDPLi5Ma4p9F9IwRqQuOq1Au7kGcOfxw8UAkih+AMMryNTmraT7vWjzGu0xR
         ekst2gz8wUZbuqAAKeY4OZ0ja3+vXZwPzKyicR0nJZt/0rYb/UL2hXsa0rycuI7zCcro
         6ygQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=n9/pEZe4CVIlbTMI+5XnBEGK7G61xg7386/V4aygmpk=;
        b=1UbyxYhWVCKwuPp7YT1EDs6uctRbElBnfBGKkzDCpelLpY62RhyrVUaxd9S3Sxp9B3
         UHB4rt1BggqRaaNGxdzTWok6MQDm5RHtEYW/k6d9RU9tQ/vaofZrmjzyLhTJx2KadhnO
         CkfoZQD5V+/h4O+QVZuUuIUoK9k9Jxg5TFfkH7xVc92Cf3+L6IkdrGPYQTMw+897/quc
         Sx0ZKGRKfBZBo9yywCr3xVaRYT8xxyfRxDjpPyTAvsDTDXQ8FrvFj+ZZfknggFjPNUU+
         72evfvjMaDgfJeEMhdMU8tWm0wVJIjKKko0cbOFCbBfgKw5tU9D+WvLEj3jZdn2Eq3/4
         yRxg==
X-Gm-Message-State: AOAM532Ik5yovLVYpaqSHoTPrGrCTJFbLxMErJTCoZlTA1SpdFxyH8ub
        uNFryaNGtqqdlG64fMZCZLB9XLc3Ttw=
X-Google-Smtp-Source: ABdhPJyh7pdLOYjp9eQBvLX4DKW/kDutV8c/qbXO0yCtGASPAWv3+GsXvqTbznbRNkKlK8SS49Ztjw==
X-Received: by 2002:a17:902:b705:b0:154:a806:5325 with SMTP id d5-20020a170902b70500b00154a8065325mr20279246pls.30.1648366034359;
        Sun, 27 Mar 2022 00:27:14 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id x7-20020a056a00188700b004fae6f0d3e5sm12463742pfh.175.2022.03.27.00.27.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 00:27:13 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     chunkeey@googlemail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] carl9170: main: fix an incorrect use of list iterator
Date:   Sun, 27 Mar 2022 15:27:02 +0800
Message-Id: <20220327072702.10572-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bug is here:
	rcu_assign_pointer(ar->tx_ampdu_iter,
		(struct carl9170_sta_tid *) &ar->tx_ampdu_list);

The 'ar->tx_ampdu_iter' is used as a list iterator variable
which point to a structure object containing the list HEAD
(&ar->tx_ampdu_list), not as the HEAD itself.

The only use case of 'ar->tx_ampdu_iter' is as a base pos
for list_for_each_entry_continue_rcu in carl9170_tx_ampdu().
If the iterator variable holds the *wrong* HEAD value here
(has not been modified elsewhere before), this will lead to
an invalid memory access.

Using list_entry_rcu to get the right list iterator variable
and reassign it, to fix this bug.
Note: use 'ar->tx_ampdu_list.next' instead of '&ar->tx_ampdu_list'
to avoid compiler error.

Cc: stable@vger.kernel.org
Fixes: fe8ee9ad80b28 ("carl9170: mac80211 glue and command interface")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/net/wireless/ath/carl9170/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 49f7ee1c912b..a287937bf666 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1756,6 +1756,7 @@ static const struct ieee80211_ops carl9170_ops = {
 
 void *carl9170_alloc(size_t priv_size)
 {
+	struct carl9170_sta_tid *tid_info;
 	struct ieee80211_hw *hw;
 	struct ar9170 *ar;
 	struct sk_buff *skb;
@@ -1815,8 +1816,9 @@ void *carl9170_alloc(size_t priv_size)
 	INIT_DELAYED_WORK(&ar->stat_work, carl9170_stat_work);
 	INIT_DELAYED_WORK(&ar->tx_janitor, carl9170_tx_janitor);
 	INIT_LIST_HEAD(&ar->tx_ampdu_list);
-	rcu_assign_pointer(ar->tx_ampdu_iter,
-			   (struct carl9170_sta_tid *) &ar->tx_ampdu_list);
+	tid_info = list_entry_rcu(ar->tx_ampdu_list.next,
+				struct carl9170_sta_tid, list);
+	rcu_assign_pointer(ar->tx_ampdu_iter, tid_info);
 
 	bitmap_zero(&ar->vif_bitmap, ar->fw.vif_num);
 	INIT_LIST_HEAD(&ar->vif_list);
-- 
2.17.1

