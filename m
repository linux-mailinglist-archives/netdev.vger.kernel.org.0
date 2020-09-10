Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793D1264E41
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgIJTHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgIJTFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:05:17 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726E7C061756
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:05:17 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id f12so4880480qtq.5
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=YeYgC+wnXE5WPKMChfHCba+wXVDxaxMd+TOtN5nzHHE=;
        b=WiRGqWfov9kwUNINermxnB/QkSIn7D6S9ynHb2Eiorv6y6o9z/BlDahZQqsoNbGQpg
         FoD4bsTSCoNWWTBknJhkroB7vgWaepGwpAVDBVo8oe5CbE46YWCejcwAiwC1/lbC+XaP
         OG3bYfhUU1aBUNTRrRhRGmOfMFENRYQe8UeMZgnbmrZUHiTt+BkTgQjdTFVaztUpQ7II
         jjdLJestf2kzGG1A8BYbdABs0uMR+g0DLvvsYaxLrptVWnoFCvqLOjOeBkUataSAH6ti
         ZEp3WQxE/gUHmPrZGhKQW3j7IZJFcyS9c/YiLglrl0FloEs0tjFg3y8qP6mxeWhRF0p+
         lW0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=YeYgC+wnXE5WPKMChfHCba+wXVDxaxMd+TOtN5nzHHE=;
        b=Qk/sFJXdg0fCo+zpslR9obU5OQOii1bx50/oSvXfruO2dlLVVHBxFYxAXOfBa4k5vO
         HtAeTSjxCQp0Cel7cRi7+95FUrOCpinJDRm+Ir1V2b2vNmHQFovzSLY5Sq4pijw6m+q6
         Hxpoqj6xupJWmhIKZU0K0ZJFt3+9kKLF4IzYzTqUVSMWXIvAsopiRwV3CBH5ht+OVte1
         wEA0d5m6IBVqt3eg2EeriDMRcw+7VlOpuT82IpaK1aLWdeLikCrIOqpCqRf2IQg6utvG
         C8ZB92Ry+Zp0XGCPrY6N7q5kOO1jZ1p/45Nxux9OhYUU1lo6WNrZ+4O0q++TL+AtXcLk
         NaQg==
X-Gm-Message-State: AOAM533qjUspyFFqALa2pVNgck6rtbjiHT9Rn462WD0kKUWAlAobzlM9
        53wNE1k7mZ5oWkdWvKyYp+xRM5lIM4y7
X-Google-Smtp-Source: ABdhPJx/B5q6d8zO08WfVKwINiALJEH/HQ/qTEaXeiRZTxgl6xgQI4S3QhFJYeUzQlQv37OVfDwAYHQGL5IZ
X-Received: from lucyyan-linux.svl.corp.google.com ([2620:15c:2c5:3:1ea0:b8ff:fe73:6d39])
 (user=lucyyan job=sendgmr) by 2002:a0c:d848:: with SMTP id
 i8mr9890275qvj.31.1599764716606; Thu, 10 Sep 2020 12:05:16 -0700 (PDT)
Date:   Thu, 10 Sep 2020 12:05:09 -0700
Message-Id: <20200910190509.81755-1-lucyyan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net] net: dec: de2104x: Increase receive ring size for Tulip
From:   Lucy Yan <lucyyan@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Moritz Fischer <mdf@kernel.org>,
        Lucy Yan <lucyyan@google.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Increase Rx ring size to address issue where hardware is reaching
the receive work limit.

Before:

[  102.223342] de2104x 0000:17:00.0 eth0: rx work limit reached
[  102.245695] de2104x 0000:17:00.0 eth0: rx work limit reached
[  102.251387] de2104x 0000:17:00.0 eth0: rx work limit reached
[  102.267444] de2104x 0000:17:00.0 eth0: rx work limit reached

Signed-off-by: Lucy Yan <lucyyan@google.com>
---
 drivers/net/ethernet/dec/tulip/de2104x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index cb116b530f5e..2610efe4f873 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -85,7 +85,7 @@ MODULE_PARM_DESC (rx_copybreak, "de2104x Breakpoint at which Rx packets are copi
 #define DSL			CONFIG_DE2104X_DSL
 #endif
 
-#define DE_RX_RING_SIZE		64
+#define DE_RX_RING_SIZE		128
 #define DE_TX_RING_SIZE		64
 #define DE_RING_BYTES		\
 		((sizeof(struct de_desc) * DE_RX_RING_SIZE) +	\
-- 
2.28.0.526.ge36021eeef-goog

