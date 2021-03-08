Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17E533065E
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 04:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbhCHD0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 22:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbhCHD0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 22:26:17 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADDFC06174A;
        Sun,  7 Mar 2021 19:26:06 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id f124so8055727qkj.5;
        Sun, 07 Mar 2021 19:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1CJsuQH6dNuHiZ5PJsDIdikWw3G3ly1EQuliBwvuFzM=;
        b=XxKEflz+cBCh0OVj3nYj/i5GexNaAsuHwxPgiL9rYF3wREiNeC3YHIlUrNs/Lpj9c/
         7Hz/79JfR5hLZ4ZDJ12nm8hpgc6RFfBMxTqTZrvxY/TSIEnZsASresqWzRof9Kn3PIUg
         d2z1Cgk7JXJLNtuUw+um7rWa5Yc7KUJUKCyi4umfWNaTUi+VFsOgspwvGK8zxZwhJ4im
         nc4f7CG9GCeg3AllMzE+ASRo68EWwy9to6Hv2yCmRNyfE0L7Rh6B9EY+X6FFDwr7Smja
         3OP4VKsT0SaR0/XEc8vazuotiMM/Re+oyiW91SlIViFrcVugsgZNWSW+Qlanric8G6vN
         F/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1CJsuQH6dNuHiZ5PJsDIdikWw3G3ly1EQuliBwvuFzM=;
        b=rVRU3jm509hH8vy3utQSB70NU/vGFQRQAmkT53TofZAIdIwwltFpTPdrt9y+E/wR3C
         tligupIl30gwT4jU44ZM6LpV2cZGhEY6xdOOl7O0bEGj3VHVsFDx1aIrBhu3KWx+a6NX
         65K6Eom9KYV3XUtJO5CSPr8pIN2DXy6bPxK9lsDLGY5YuX7ZB+Q8bV4LYncfkDfnv3n4
         6u/8piXYybLJfCrVIwYLjf/1MsL+hMUDllnJb1/Q5x5SE4mENIi379BMfW3RQ7G1MEeM
         54nNVYW/fHkcuoQCBDn+AFbN4qEN36lBgn/OO50r8b8Z4/ysRRUIcUR9PLMB216GuZcA
         i53g==
X-Gm-Message-State: AOAM530TpFGT+H0kbLVfr+QyY9HL8mlTiLUW/VANP6HseJDrFPnDX6iX
        pbohUgSK7hZ2bL8Vx2xy8xsXBaIk+5T+jA==
X-Google-Smtp-Source: ABdhPJwNruETUKCni9TMKHQ6WieNN6NBfWJiU8i3CfS7+39NGdA9eof94jRFXEAfJFQySXVLA4rfgA==
X-Received: by 2002:a37:6294:: with SMTP id w142mr12550334qkb.255.1615173965592;
        Sun, 07 Mar 2021 19:26:05 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:99a3:37aa:84df:4276])
        by smtp.googlemail.com with ESMTPSA id r7sm339725qtm.88.2021.03.07.19.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 19:26:05 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ztong0001@gmail.com
Subject: [PATCH 2/3] atm: uPD98402: fix incorrect allocation
Date:   Sun,  7 Mar 2021 22:25:29 -0500
Message-Id: <20210308032529.435224-3-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210308032529.435224-1-ztong0001@gmail.com>
References: <20210308032529.435224-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev->dev_data is set in zatm.c, calling zatm_start() will overwrite this
dev->dev_data in uPD98402_start() and a subsequent PRIV(dev)->lock
(i.e dev->phy_data->lock) will result in a null-ptr-dereference.

I believe this is a typo and what it actually want to do is to allocate
phy_data instead of dev_data.

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/atm/uPD98402.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/uPD98402.c b/drivers/atm/uPD98402.c
index 7850758b5bb8..239852d85558 100644
--- a/drivers/atm/uPD98402.c
+++ b/drivers/atm/uPD98402.c
@@ -211,7 +211,7 @@ static void uPD98402_int(struct atm_dev *dev)
 static int uPD98402_start(struct atm_dev *dev)
 {
 	DPRINTK("phy_start\n");
-	if (!(dev->dev_data = kmalloc(sizeof(struct uPD98402_priv),GFP_KERNEL)))
+	if (!(dev->phy_data = kmalloc(sizeof(struct uPD98402_priv),GFP_KERNEL)))
 		return -ENOMEM;
 	spin_lock_init(&PRIV(dev)->lock);
 	memset(&PRIV(dev)->sonet_stats,0,sizeof(struct k_sonet_stats));
-- 
2.25.1

