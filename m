Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388B026D1DE
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 05:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgIQDnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 23:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgIQDnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 23:43:21 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB1BC06174A
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 20:43:20 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id f1so372854plo.13
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 20:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0jBSINtr9O+E9pgdDAZJjv+jIULVmr7XFj4jHhF2iv4=;
        b=dKrJ89fTQ2CKP9zDLPV75AM6k3f+kkRo/rw8tylb01g3030CNkIJB8KfWs9iZFV2m5
         ZSQownHN0gvjsAskvq7JF4vTiVZd+zgMGH82zIZP6qvYEAyN5BOVEZwXc0ow9q31lZ5W
         cpKNiHYZkT/f2gL+Gcyded/+88lgSRYXwUuyv4XKlJWJqx13mTcYrVnvFU0sC4JDIMmo
         W4OktGumPfZWVFNGu+qLMB7cmezsW7ben9TVxoDFLPDYZ/BljwWnleCm2Bl1TrJT2eIs
         DBT5dxVHciLjz7weMxCB4+nOOuMiEFqfolAGVwhik9ZYjuWHJV3sFD8LjmiB2gGNeUq0
         M+Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0jBSINtr9O+E9pgdDAZJjv+jIULVmr7XFj4jHhF2iv4=;
        b=Yc7L0vusB8pbVWCbLKBVS9cE9ckpx2XKvVcOmUMyCx5pNnkBFIcfI6qoXXJE0jJ3hs
         L6zV2LiQhY4kOQ3ZoDcjSS3Tukt8LlldIXfZ/D706vQvr1MHepmhxHExRRpDEkVTxMLD
         95BeBzoiZSoXg5C0bftkHceE/j6V3vKFPnkb/CEDvt30z2WAIu0zXexw/ZcFWlOfZBir
         TA1N3nq0LiN0Kuc4gTqIeuy/qPz/qVk8TN73zo77uaN00Isnl7oiH+V4BcDgLU26QX0z
         ZQkHO2+RmE/kAGFBLQ8bKiT/UPFBhwDEgDZ2/FO04TPenm6Pe6MdDFN/PQVxyZz3Xy2s
         /7FA==
X-Gm-Message-State: AOAM533v3dJh2jjQKDN2NEdQy3AHNp6OvsAbjLdXoa+QuecZrZBsfuzC
        PqTq6JKLlLAFzplRFsQFLjF2Tdn7iT2new==
X-Google-Smtp-Source: ABdhPJw7VBivhtOlRn97QZ6FWndhCwyiGxe4Fd/LaIq1oUqxgv+JY8PTq1VXa0Yjy3n4+UGLm1KATg==
X-Received: by 2002:a17:902:d913:b029:d1:f388:9fa6 with SMTP id c19-20020a170902d913b02900d1f3889fa6mr4333486plz.67.1600314199890;
        Wed, 16 Sep 2020 20:43:19 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i187sm15810116pgd.82.2020.09.16.20.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 20:43:19 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH net 2/2] net: phy: Do not warn in phy_stop() on PHY_DOWN
Date:   Wed, 16 Sep 2020 20:43:10 -0700
Message-Id: <20200917034310.2360488-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200917034310.2360488-1-f.fainelli@gmail.com>
References: <20200917034310.2360488-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When phy_is_started() was added to catch incorrect PHY states,
phy_stop() would not be qualified against PHY_DOWN. It is possible to
reach that state when the PHY driver has been unbound and the network
device is then brought down.

Fixes: 2b3e88ea6528 ("net: phy: improve phy state checking")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 735a806045ac..8947d58f2a25 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -996,7 +996,7 @@ void phy_stop(struct phy_device *phydev)
 {
 	struct net_device *dev = phydev->attached_dev;
 
-	if (!phy_is_started(phydev)) {
+	if (!phy_is_started(phydev) && phydev->state != PHY_DOWN) {
 		WARN(1, "called from state %s\n",
 		     phy_state_to_str(phydev->state));
 		return;
-- 
2.25.1

