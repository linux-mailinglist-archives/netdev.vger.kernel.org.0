Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432B44D5559
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344040AbiCJX2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbiCJX2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:28:30 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C7F986D8
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:27:28 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id h13so8934461ede.5
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=26IQVuHEFaKpO4gayxdHJfhPwDXTt6igV+9aB32qMoQ=;
        b=g9nQUOz+zhqZvUhzv1XZf9uma+RT20XXkOGEdHk/LfCKdbyuLakfpkqq42Ly1q/k3Z
         NjdkzBmCCmvOAq1NE+PyYwvduAl2xnfR9eZ4cYLbm9FZ/xus0NtKc1V1btnjbaBgYmDQ
         DufmWOSE9JCTTOBkVG67a325khAxl5FWy55nMq0tPS9von/mwkIGAF5uD2r9jqeEQvmj
         ykZyn05onykERQIopw/p97DVvuiSltDTPWGdL/Hkh8Yy9u5vTLEHET/weikiHxGG9M28
         R1Z4u/KNemoCbzMgMzBkAtbVO2tKX+yNUth1wAJuD9NEeVLRYoRHfUKr+zP8act9He0E
         09Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=26IQVuHEFaKpO4gayxdHJfhPwDXTt6igV+9aB32qMoQ=;
        b=WxEhGrJKAnGQh5Qbx1YitYba/Qc+I1VXER5LJ3D+Ict8mP8GLkHCRNounqF4UBI0MA
         ltPWoI7GmMqrUXL47nXcaOqOMiIGYmc18NNs+oMJMiaZKf9Ak1A/UBGr14rsPI2TMv+S
         j72SoPWQoL/Yaq6PSmlwtL5rrWcOa6ekPD6vK7Lr4/EXxawc9R7xicsYdjcmiqOES9Yd
         +9noAgIbgPFRdm/TncQV2Qi4H5sPoUtFAP0raNKQXPRFrmcNJsR3hlZeg44Y/BvR4B1F
         Hi5BvCnpVYpsnuG2wL4sDSMJ2nMFokidO69h+Tp8ioOnZblG0weN9tcK0ghIOt+oKbpM
         p0nA==
X-Gm-Message-State: AOAM530UHFu+dNRBcyMMgNanl1I+Bons/Hqow7QPklIhFNtZ7sBSE1gO
        hu59BfG5u5h4q9banwsXb7U1hjRJgQiYww==
X-Google-Smtp-Source: ABdhPJzi07Fm7bk05k/uKnWDUhkme7BoUc3kAp/kp1+TyX7+a/blENUc+YpyHCdCwFvXVc1JtF7VRA==
X-Received: by 2002:a05:6402:1341:b0:407:cece:49f8 with SMTP id y1-20020a056402134100b00407cece49f8mr6739676edw.152.1646954846721;
        Thu, 10 Mar 2022 15:27:26 -0800 (PST)
Received: from nlaptop.localdomain (ptr-dtfv0poj8u7zblqwbt6.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:f2b6:6987:9238:41ca])
        by smtp.gmail.com with ESMTPSA id f22-20020a170906739600b006db726290dcsm2072828ejl.217.2022.03.10.15.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 15:27:26 -0800 (PST)
From:   Niels Dossche <dossche.niels@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Niels Dossche <dossche.niels@gmail.com>
Subject: [PATCH v2] alx: acquire mutex for alx_reinit in alx_change_mtu
Date:   Fri, 11 Mar 2022 00:27:08 +0100
Message-Id: <20220310232707.44251-1-dossche.niels@gmail.com>
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

alx_reinit has a lockdep assertion that the alx->mtx mutex must be held.
alx_reinit is called from two places: alx_reset and alx_change_mtu.
alx_reset does acquire alx->mtx before calling alx_reinit.
alx_change_mtu does not acquire this mutex, nor do its callers or any
path towards alx_change_mtu.
Acquire the mutex in alx_change_mtu.

The issue was introduced when the fine-grained locking was introduced
to the code to replace the RTNL. The same commit also introduced the
lockdep assertion.

Fixes: 4a5fe57e7751 ("alx: use fine-grained locking instead of RTNL")
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
---

Changes in v2:
 - Added Fixes tag and explainer

 drivers/net/ethernet/atheros/alx/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 4ad3fc72e74e..a89b93cb4e26 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1181,8 +1181,11 @@ static int alx_change_mtu(struct net_device *netdev, int mtu)
 	alx->hw.mtu = mtu;
 	alx->rxbuf_size = max(max_frame, ALX_DEF_RXBUF_SIZE);
 	netdev_update_features(netdev);
-	if (netif_running(netdev))
+	if (netif_running(netdev)) {
+		mutex_lock(&alx->mtx);
 		alx_reinit(alx);
+		mutex_unlock(&alx->mtx);
+	}
 	return 0;
 }
 
-- 
2.35.1

