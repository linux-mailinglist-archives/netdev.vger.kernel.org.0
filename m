Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F5B3D2BBF
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 20:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhGVRaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 13:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhGVRaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 13:30:05 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34947C061757
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 11:10:40 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id f9so6855966wrq.11
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 11:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ePG+wUWFKV4MneEDFhxnLHUQf4MdfW7eykx/Xqx/8zw=;
        b=hPkYuV8Oogk8ZL5wms8EaEdZnvHLkb9Vb1yXF00AtxJS+VbnYAmTSmP856xePRYK2f
         mSCj3VrNTY5BDwcdEHjn/eHIWpYm42sy+nQSvZUmkHMTad+8tJpUE8fRBx3oI40T1qIC
         8asgrfvpfKZJP9s2Zd/O9sOqyjcyjbP4eUXo6yg3ANen2UbCd1NkGuMitWfHxIZ96mss
         UmpYduTIucMq8WmNRS7sWC5Wd5hSHQtcKWdQo1gztSIoMl/O4fW9RpNY6ZJ1azx8ZIAd
         V6KpMZ3k/Mz2YWeNblDCemX3yiGx3aTP3GfWB8nEYycDtUBYq1t28Z9/8mpUuJnHkdDK
         L68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ePG+wUWFKV4MneEDFhxnLHUQf4MdfW7eykx/Xqx/8zw=;
        b=MCC0ueW+udGj2KfrEWaK6LsRIU8R3SDW4AVwlnKmp3BxMiFDEIr6dCzA32XLruU1od
         ZBTViKM8WDMOKeMLUuHLXwuoWs/r47pFo4tgF+cF64IXKta3E9M9Jpm0TeqoY0X2PWfz
         DjaJf/me0ALTXURM2YNiJhiypkHgsd2gUpYR018NBTfkZJqWoIeH5Ay5Wq3P9k58y5SH
         KjJ5muue+gl3K9OfJCdyzvEntOjTtkwSYzazzgqrP/aBUKsl0H++WHKEX6vO5Q3VT7Yd
         kEUpTg+z6lFDi8BJZTF/3refFmhv0WLH7lRl1hSMS4itBoa0miwknhDbscI7N3UzzWl3
         bRMw==
X-Gm-Message-State: AOAM531x76hNdppjXb+3bvXQzDjsd1ZqMeG1wfjd44vL3vAdjTGX7OBi
        Ibkiyou8D5//dGnyPnXfWceA4Tb9bhETYkHY
X-Google-Smtp-Source: ABdhPJwgJfKD1t66Mc5UvgMspC/PGsdefCBqfFi8g5QCZ5a3f7q5QpWGliMDaFqQQK3lqouC6iRzDg==
X-Received: by 2002:adf:f74f:: with SMTP id z15mr1269983wrp.54.1626977438148;
        Thu, 22 Jul 2021 11:10:38 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:69b5:b274:5cfc:ef2])
        by smtp.gmail.com with ESMTPSA id b16sm30761779wrw.46.2021.07.22.11.10.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Jul 2021 11:10:37 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     johannes@sipsolutions.net, netdev@vger.kernel.org,
        ryazanov.s.a@gmail.com, Loic Poulain <loic.poulain@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] wwan: core: Fix missing RTM_NEWLINK event for default link
Date:   Thu, 22 Jul 2021 20:21:05 +0200
Message-Id: <1626978065-5239-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A wwan link created via the wwan_create_default_link procedure is
never notified to the user (RTM_NEWLINK), causing issues with user
tools relying on such event to track network links (NetworkManager).

This is because the procedure misses a call to rtnl_configure_link(),
which sets the link as initialized and notifies the new link (cf
proper usage in __rtnl_newlink()).

Cc: stable@vger.kernel.org
Fixes: ca374290aaad ("wwan: core: support default netdev creation")
Suggested-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wwan/wwan_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 3e16c31..674a81d 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -984,6 +984,8 @@ static void wwan_create_default_link(struct wwan_device *wwandev,
 		goto unlock;
 	}
 
+	rtnl_configure_link(dev, NULL); /* Link initialized, notify new link */
+
 unlock:
 	rtnl_unlock();
 
-- 
2.7.4

