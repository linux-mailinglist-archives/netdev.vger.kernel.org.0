Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D5E4DBD52
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 04:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240548AbiCQDDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 23:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiCQDDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 23:03:13 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5CF201BC;
        Wed, 16 Mar 2022 20:01:58 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id o6-20020a17090a9f8600b001c6562049d9so4281282pjp.3;
        Wed, 16 Mar 2022 20:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bW9+q/9DwRXDLHNrIZZ/P9kRXSJfYeSaV3DA8Q5JRv4=;
        b=b1peUcfkYv9TPtgx1X3WqhvxAvkvLBXzLgo3imFWUVeEneSj5cJkwjJpfKC7cH62cK
         kBYhIDxUtoDhnEgQPxXvhmvrxwZE7eLAhd7ks1WzWBTvoiffZry/F1Lmi26i7czxJEw1
         wierKAuzuPU4eactCjcfxeRyQ+ark5rLYRRGXv/XLDGXky8yMv32FdQ0rvHEQdpA7coB
         xCaW2k2VE1FUPnk0ddzd2FoCrt9JjpirMvqPZ+8RMNIlKslGqjxDZITktHsQnJH8/wY7
         FV59ZHK4Y2i8m6mGvqerQcAtwVY07lpY+e9vK81Yt2iZhhXgzW0LWxIQ4G9ZtMbDmrhF
         4iWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bW9+q/9DwRXDLHNrIZZ/P9kRXSJfYeSaV3DA8Q5JRv4=;
        b=lb2B+nnULV2+f2nkqjImX8KhSqKz5bYMtVMNJzkBWblN/Yq7t0iOQqXWKvqCrBGHQ4
         sTpRX3G0Y3iAav1wYBxL232N5kgp2Gsn7dOXhFMpKhox8bIM1Os1muNwitpNbYtvCtCW
         6otbIRMcl0JMZALgO6ihd3bSsV2Yk65XQTiY6BUoNs6uTgRiU48FXVdgYkxnZHXAK5zL
         XhH2JlKY0e3xf9L8Jr7c7i7ob26QYEntsLMIsJ4yH3kgayeXBm/AEwE1FjlkH9jKt/ut
         DliaeBh5bzYztXziSnhEWy9Q1czUCkPgDKZCKfjPQzutYQRC0YlMO4YG4LqFoyd+6U3u
         A8rw==
X-Gm-Message-State: AOAM531TwHMm38viV0yDZxxex57ehTuL7ixIg2g35cgSo+5YOElbUR9k
        88rINK3MUyfuWKQcP9+Dk9U=
X-Google-Smtp-Source: ABdhPJyvTCaZCTHpNlEIYKI142s3jeY3M0F8Ct/E1H/vK+HfB5ZhmJSy60u3kauO3RfFra6p4VWznw==
X-Received: by 2002:a17:90b:1bc1:b0:1bf:7dc6:bc78 with SMTP id oa1-20020a17090b1bc100b001bf7dc6bc78mr2928126pjb.122.1647486118027;
        Wed, 16 Mar 2022 20:01:58 -0700 (PDT)
Received: from slim.das-security.cn ([103.84.139.54])
        by smtp.gmail.com with ESMTPSA id o5-20020a056a0015c500b004f7988f16c3sm5015705pfu.30.2022.03.16.20.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 20:01:57 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     rcsekar@samsung.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] can: m_can: fix a possible use after free in m_can_tx_handler()
Date:   Thu, 17 Mar 2022 11:01:43 +0800
Message-Id: <20220317030143.14668-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
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

can_put_echo_skb will clone skb then free the skb. It is better to avoid using
skb after can_put_echo_skb.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 drivers/net/can/m_can/m_can.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 1a4b56f6fa8c..98be5742f4f5 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1607,6 +1607,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 	u32 cccr, fdflags;
 	int err;
 	int putidx;
+	unsigned int len = skb->len;
 
 	cdev->tx_skb = NULL;
 
@@ -1642,7 +1643,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD) {
 			cccr = m_can_read(cdev, M_CAN_CCCR);
 			cccr &= ~CCCR_CMR_MASK;
-			if (can_is_canfd_skb(skb)) {
+			if (len == CANFD_MTU) {
 				if (cf->flags & CANFD_BRS)
 					cccr |= FIELD_PREP(CCCR_CMR_MASK,
 							   CCCR_CMR_CANFD_BRS);
-- 
2.25.1

