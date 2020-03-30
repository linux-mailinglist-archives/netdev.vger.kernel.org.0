Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8AC1986B4
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgC3VjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:39:06 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40651 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728626AbgC3VjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:39:05 -0400
Received: by mail-wm1-f67.google.com with SMTP id a81so434067wmf.5
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 14:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R8sj6WVyZB8rITepGXiyyokfdAE916pRlQveHEX+0jU=;
        b=O/rJfnzxLnx5pQ3QVzbk5BvnbuYLoXCuJ/XImWwW/5zDgBhjll4iwiaLzw7PTDEaXP
         LZUeRqLBwQ2MOMT3yWO3PX4PNqp9FEcIXs7/EFKQnhlcSjNyxKcV/qwgjesUhxY+0imW
         bcLFTZCDLLsrV2ytqTZCEq5Z9bXYRH/lF+oESmG5YhljBJBp0LObkdrFE7Ui1UoIHADv
         kmIa6DyfAbnqT8pbiNsOH4jurLm3keoj7YauQbLm+PzIWozzRp2OtWnp/N8rmpyDbn0J
         ZClUbUXcXaZhqD5WuNQgXzzttfASP/BkgRZFqj+YgV7JkBQHsbcjAIU2X4Ejqb6dH9ov
         uq0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R8sj6WVyZB8rITepGXiyyokfdAE916pRlQveHEX+0jU=;
        b=Q5rv8aN9Dz4O8GSI9lPrnFh1i3KB8J1vFynRkJg7hRS8KQkct8jpnA39QwgDR3eatV
         OZ06s/AgcHmXSON2+Yh2l+441jRWCRdb+X8DghSjLtrgfHIVPw+YkAzoKcssqsQiGNlY
         8Eqzli1A5db4UXK8ZOGM+4+7KiJJcrWRn3STy/xK6Vh29plm13fHF+5ATUW29yndV70B
         2DD/kT9QJWznUwSCI7LfBN0Exgs14H2PBGEyftIVBIlYmn2bHGMM3P2R3gd+XA2U0hFi
         MyMXD4bbT0iAe7Tck8vs96MBPtCOjK7KnST1lcIaIk9usnheJdCORBe3Xm5HxHlZobLq
         bEmQ==
X-Gm-Message-State: ANhLgQ27VilQZ4ZGvEAqMCn/fISYtcclgIwpCTCo0Vk2OQ2qwrxX4Gsf
        wWx+LKy/THzztgqJGNtNtnSiY+59
X-Google-Smtp-Source: ADFU+vuqmEejl2lFHdjUjOWHDEhvHL+sFtMQR46o4fc1jA+UDKMGdZcJSvk2Qpn+51A3va1tVxZVFA==
X-Received: by 2002:a1c:dfd5:: with SMTP id w204mr83775wmg.153.1585604342067;
        Mon, 30 Mar 2020 14:39:02 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r17sm23600853wrx.46.2020.03.30.14.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 14:39:01 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next v2 1/9] net: dsa: bcm_sf2: Fix overflow checks
Date:   Mon, 30 Mar 2020 14:38:46 -0700
Message-Id: <20200330213854.4856-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330213854.4856-1-f.fainelli@gmail.com>
References: <20200330213854.4856-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit f949a12fd697 ("net: dsa: bcm_sf2: fix buffer overflow doing
set_rxnfc") tried to fix the some user controlled buffer overflows in
bcm_sf2_cfp_rule_set() and bcm_sf2_cfp_rule_del() but the fix was using
CFP_NUM_RULES, which while it is correct not to overflow the bitmaps, is
not representative of what the device actually supports. Correct that by
using bcm_sf2_cfp_rule_size() instead.

The latter subtracts the number of rules by 1, so change the checks from
greater than or equal to greater than accordingly.

Fixes: f949a12fd697 ("net: dsa: bcm_sf2: fix buffer overflow doing set_rxnfc")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2_cfp.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index 1962c8330daa..f9785027c096 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -882,17 +882,14 @@ static int bcm_sf2_cfp_rule_set(struct dsa_switch *ds, int port,
 	     fs->m_ext.data[1]))
 		return -EINVAL;
 
-	if (fs->location != RX_CLS_LOC_ANY && fs->location >= CFP_NUM_RULES)
+	if (fs->location != RX_CLS_LOC_ANY &&
+	    fs->location > bcm_sf2_cfp_rule_size(priv))
 		return -EINVAL;
 
 	if (fs->location != RX_CLS_LOC_ANY &&
 	    test_bit(fs->location, priv->cfp.used))
 		return -EBUSY;
 
-	if (fs->location != RX_CLS_LOC_ANY &&
-	    fs->location > bcm_sf2_cfp_rule_size(priv))
-		return -EINVAL;
-
 	ret = bcm_sf2_cfp_rule_cmp(priv, port, fs);
 	if (ret == 0)
 		return -EEXIST;
@@ -973,7 +970,7 @@ static int bcm_sf2_cfp_rule_del(struct bcm_sf2_priv *priv, int port, u32 loc)
 	struct cfp_rule *rule;
 	int ret;
 
-	if (loc >= CFP_NUM_RULES)
+	if (loc > bcm_sf2_cfp_rule_size(priv))
 		return -EINVAL;
 
 	/* Refuse deleting unused rules, and those that are not unique since
-- 
2.17.1

