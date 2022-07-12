Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6C6570E93
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 02:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiGLAFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 20:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiGLAFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 20:05:39 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB76B61
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 17:05:38 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id u24-20020a63d358000000b004119798494fso2486085pgi.18
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 17:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1JpwXxBfHL+adQw1k/M4Xx4GgPy74dDIIx1BqOfF6HE=;
        b=qdJg+sV1ZLY12NdCbWtFBRr9HAPtVRoRvyYrjzWV5P4xFPENTKzw4kkMuCxv8lkuUi
         /B5kQ+fqovXQvljejTKCF0jeYXsS2p6J7khkTKAYhg99QjaOx3b7BTUDSe7/sbkdqkWh
         74Ex8ZdqJ3HX6T1LMVG2pzp06jJabgMAmjomYh9tLZ1f+QFtK4B4f7edSEzxie1HMwrP
         lOh9Et7UzZkKXQ9bRards3gFFNzLuIezTHcOGIHFtAnMmpV7FIuuL2ITptWZM27N9ZKQ
         k7OUnqswKWMn0vb8WyzvdOdHOS9/x/eqY2ytET2xYjaJfUMiXFu0lcBXVqmgEHGp2jPN
         SHrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1JpwXxBfHL+adQw1k/M4Xx4GgPy74dDIIx1BqOfF6HE=;
        b=L7Qk/e5zfdhtm3Gew3tn14K1M1xM/xgerEeBb/+kJodrtXuhFo/Kjebs9h3q6+sAhC
         yCLtUn162KbD+vDzYCP8S+NybadevZ5qA3s0DjvU6MH1wG2h0G1ACg1CpO1LNEr6h0W4
         Lh85Bb/HZk7/Mvvbuw9vpcTq0S5z0ZX9PmZbJ7m0JQ0S3ANaCQXj9wmRZ2dwviIAuEZO
         OtWy53FY8aj73ZiuzM7T7/EYGHBgdwxBBWpwrKRyU4Ykx7p5ZkDxfXS+dOLNsHFil2xK
         qnxqz5BPO7PQ3J7K40BfPxTzcZAV77qEVkMDiciC5Sq54ioTPICXF4t1VkHnLqXdzT3Q
         Yoyg==
X-Gm-Message-State: AJIora+8BKBrzCpo1ifaLgBcpk7mCNGKUEJ+fPa/CG7dtJQu+lNGfkvg
        vg0Nn/3nWt3c5lijeUJ+UlSLBfzLYdDa
X-Google-Smtp-Source: AGRyM1uGAR/JbTrCYF7Tx9Cdkawj0T2Adl/a47tKgYYcay8WPmViBUBPkz1Kd7e+gWfuSLW7XDoOkMwdD3/7
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a17:90a:bc04:b0:1f0:506d:78b9 with SMTP id
 w4-20020a17090abc0400b001f0506d78b9mr1065616pjr.4.1657584338428; Mon, 11 Jul
 2022 17:05:38 -0700 (PDT)
Date:   Mon, 11 Jul 2022 17:05:30 -0700
In-Reply-To: <20220712000530.2531197-1-jiangzp@google.com>
Message-Id: <20220711170515.kernel.v2.1.Ia489394ab4176efa5a39ce8d08bb4c4b7bee23b9@changeid>
Mime-Version: 1.0
References: <20220712000530.2531197-1-jiangzp@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [kernel PATCH v2 1/1] Bluetooth: hci_sync: Fix resuming scan after
 suspend resume
From:   Zhengping Jiang <jiangzp@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     Zhengping Jiang <jiangzp@google.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After resuming, remove setting scanning_paused to false, because it is
checked and set to false in hci_resume_scan_sync. Also move setting
the value to false before updating passive scan, because the value is
used when resuming passive scan.

Fixes: 3b42055388c30 (Bluetooth: hci_sync: Fix attempting to suspend with
unfiltered passive scan)

Signed-off-by: Zhengping Jiang <jiangzp@google.com>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

Changes in v2:
- Reduce title length

Changes in v1:
- Fix updating passive scan after suspend resume

 net/bluetooth/hci_sync.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 7cb3100518799..212b0cdb25f5e 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5063,13 +5063,13 @@ static int hci_resume_scan_sync(struct hci_dev *hdev)
 	if (!hdev->scanning_paused)
 		return 0;
 
+	hdev->scanning_paused = false;
+
 	hci_update_scan_sync(hdev);
 
 	/* Reset passive scanning to normal */
 	hci_update_passive_scan_sync(hdev);
 
-	hdev->scanning_paused = false;
-
 	return 0;
 }
 
@@ -5088,7 +5088,6 @@ int hci_resume_sync(struct hci_dev *hdev)
 		return 0;
 
 	hdev->suspended = false;
-	hdev->scanning_paused = false;
 
 	/* Restore event mask */
 	hci_set_event_mask_sync(hdev);
-- 
2.37.0.144.g8ac04bfd2-goog

