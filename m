Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63D75E7F4C
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiIWQJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiIWQJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:09:47 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE04320F55
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 09:09:44 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso567538pjd.4
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 09:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=5b0lcyvGiCvGIzb/yyAvFGoWTM0zeGk0O2VHYckO0AI=;
        b=eWN5ep2QCd26H9ilXv52manfMyJSKOvW/WzpxDG5YmzpBEVBo1HcEBJPjPVh1IAFvg
         O2KnFh1oat7lCVqNTT/bcGiJ1BMz4RntWKSuv5+Jm3P1BisFJiwcswO4cDoM+gethlAK
         MIAISnnecRya23sCr5lHVqtmLFhbezJAExrP1Uws0hAINYqLe8v10UGkYPJhYgCRHaI1
         2ZyCS8lTU2aTJOLZ455hvm8Nli9Lge5Vv8zIWDA0H8fDLyEeAfgj0C//pQftus5MqknM
         gLyvGvK3IO0wUl7/iuvhbX3JEgD9RqxBsnbgvFGdLfT50FCXeFVwFDVCvbWDfP2JyX74
         FFTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=5b0lcyvGiCvGIzb/yyAvFGoWTM0zeGk0O2VHYckO0AI=;
        b=VbcgBOlA3c10IjQpXmFEUckxzW2BQ3JsCT+r8vR4cMF/nStnyBP0UpQoulPD6/n3A6
         /LzYRaYmcW+XsYUDBiEsdAlBbf9XUApsEEPUDxHmn6FFzoJ9hmtRWh7l4uy9KOVvHCRt
         71HaGehiJPrHSoxk7iyJnlC3i7VebbBEBzJL72mvFol7z4TSFg6PM5Mb9IVdO6FN2mJ0
         VGbyMSaEwBFksuR/JtVA7qQzK5/JPTJCGFpZVsKwa6F22qCS0UkzI2f6A/LHBcj6wxfb
         HuzTFO57cgBoGbUDk4EVm/1NHRhhJYeyx5EdhCH+m58jHavuludhHPsn9VlyN1mmthmK
         ut9A==
X-Gm-Message-State: ACrzQf0zs3GL5CeZDefT5rJjPXoqwLyVIKTvzq369BmlxtYgDA00nxva
        UNpUefH4dXuPSxeryI9KOpd7xR9dPR+QkxA2
X-Google-Smtp-Source: AMsMyM4vEJLeOV2zcb0JM7GW9V1R/JV5Sb5gZWsuryX8O9Emak6CBrSDhBu/KObsFSaIWWmI49CmLg==
X-Received: by 2002:a17:90b:1b0b:b0:205:9926:3a6b with SMTP id nu11-20020a17090b1b0b00b0020599263a6bmr363715pjb.139.1663949383875;
        Fri, 23 Sep 2022 09:09:43 -0700 (PDT)
Received: from kvm.. ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id g10-20020a656cca000000b004351358f056sm5718334pgw.85.2022.09.23.09.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 09:09:43 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     netdev@vger.kernel.org, simon.horman@corigine.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Cc:     skhan@linuxfoundation.org, Juhee Kang <claudiajkang@gmail.com>
Subject: [PATCH net-next 1/3] net: use netdev_unregistering instead of open code
Date:   Sat, 24 Sep 2022 01:09:35 +0900
Message-Id: <20220923160937.1912-1-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The open code is defined as a helper function(netdev_unregistering)
on netdev.h, which the open code is dev->reg_state == NETREG_UNREGISTERING.
Thus, netdev_unregistering() replaces the open code. This patch doesn't
change logic.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 net/core/dev.c       | 9 ++++-----
 net/core/net-sysfs.c | 2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d66c73c1c734..f3f9394f0b5a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2886,8 +2886,7 @@ int netif_set_real_num_tx_queues(struct net_device *dev, unsigned int txq)
 	if (txq < 1 || txq > dev->num_tx_queues)
 		return -EINVAL;
 
-	if (dev->reg_state == NETREG_REGISTERED ||
-	    dev->reg_state == NETREG_UNREGISTERING) {
+	if (dev->reg_state == NETREG_REGISTERED || netdev_unregistering(dev)) {
 		ASSERT_RTNL();
 
 		rc = netdev_queue_update_kobjects(dev, dev->real_num_tx_queues,
@@ -5786,7 +5785,7 @@ static void flush_backlog(struct work_struct *work)
 
 	rps_lock_irq_disable(sd);
 	skb_queue_walk_safe(&sd->input_pkt_queue, skb, tmp) {
-		if (skb->dev->reg_state == NETREG_UNREGISTERING) {
+		if (netdev_unregistering(skb->dev)) {
 			__skb_unlink(skb, &sd->input_pkt_queue);
 			dev_kfree_skb_irq(skb);
 			input_queue_head_incr(sd);
@@ -5795,7 +5794,7 @@ static void flush_backlog(struct work_struct *work)
 	rps_unlock_irq_enable(sd);
 
 	skb_queue_walk_safe(&sd->process_queue, skb, tmp) {
-		if (skb->dev->reg_state == NETREG_UNREGISTERING) {
+		if (netdev_unregistering(skb->dev)) {
 			__skb_unlink(skb, &sd->process_queue);
 			kfree_skb(skb);
 			input_queue_head_incr(sd);
@@ -10708,7 +10707,7 @@ void free_netdev(struct net_device *dev)
 	 * handling may still be dismantling the device. Handle that case by
 	 * deferring the free.
 	 */
-	if (dev->reg_state == NETREG_UNREGISTERING) {
+	if (netdev_unregistering(dev)) {
 		ASSERT_RTNL();
 		dev->needs_free_netdev = true;
 		return;
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index d61afd21aab5..ec929bf15268 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1711,7 +1711,7 @@ netdev_queue_update_kobjects(struct net_device *dev, int old_num, int new_num)
 	 * unregistered, but solely to remove queues from qdiscs. Any path
 	 * adding queues should be fixed.
 	 */
-	WARN(dev->reg_state == NETREG_UNREGISTERING && new_num > old_num,
+	WARN(netdev_unregistering(dev) && new_num > old_num,
 	     "New queues can't be registered after device unregistration.");
 
 	for (i = old_num; i < new_num; i++) {
-- 
2.34.1

