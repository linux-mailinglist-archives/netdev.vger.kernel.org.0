Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B899C1B93E9
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 22:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgDZUZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 16:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726179AbgDZUZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 16:25:07 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFCFC061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 13:25:07 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id h69so7620079pgc.8
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 13:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3p13JvitxL6ZUjchuAaJQQISalZ/XH0YQY+hiqxR9cI=;
        b=BuVDqraPxkeZa00Q/Zhsx+IIwqkXKGVkBua8W8979ik797Zbr38MClunOvQkPGI3DG
         7IdJeUOwSVXnefRyQXCbaj+MQwi1zMwTF4yt3jMYUcUDmkJjSkvtZjQqTFyzofgwWlX9
         UZcs0qOag1l2iFfqQIJyl9NGnfZGfujSqhXy4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3p13JvitxL6ZUjchuAaJQQISalZ/XH0YQY+hiqxR9cI=;
        b=YNzNPSXR2B0p0Zz66bU4gctdF/qD/V08qFALlWP1iw54REHC2CJM3sX7aeecaE7t5Z
         8HNw4dsBFo87DzvO/gshmeS4hs8aoXg9uw371oQqdgpNgHNUnIClA3YV73SW8MT7jpFT
         gvEQCwCAihlGkrhjGMGgA/q/N1cWTNYZvvKgLY0sPi77WEtyj+QSAK1jIK05/uNvM7xM
         w0HkbvGY54ZF5Vbgt6UMgT8Ye/5CmPhGr/FQ0LfovI9ndJUrTfH7q2e0r49ryGn4X8Ge
         HfKbAr4Cp4xS+eLO6pSiLlJyMCJZH3/8d/0wsAHsvCDusRqKtG730B1yO+wSWi4GPRJL
         TiCg==
X-Gm-Message-State: AGi0PublNw/gSlhZlyWVeAfH7Lq3OSpfr2Ex1L5s1YzzPfRwHQP8mMsW
        uq1d4t+IUlXleF/pMbNVSEwwjA==
X-Google-Smtp-Source: APiQypJECNjWT0IUH73gLOKuOBdBmZICwtFXJO5WWe3L7K73GnCAy1t5+musVn4HP/G2fvbvmyy58Q==
X-Received: by 2002:a63:f70f:: with SMTP id x15mr17780193pgh.199.1587932706607;
        Sun, 26 Apr 2020 13:25:06 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a136sm10862103pfa.99.2020.04.26.13.25.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Apr 2020 13:25:06 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 2/5] bnxt_en: Reduce BNXT_MSIX_VEC_MAX value to supported CQs per PF.
Date:   Sun, 26 Apr 2020 16:24:39 -0400
Message-Id: <1587932682-1212-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587932682-1212-1-git-send-email-michael.chan@broadcom.com>
References: <1587932682-1212-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Broadcom adapters support only maximum of 512 CQs per PF. If user sets
MSIx vectors more than supported CQs, firmware is setting incorrect value
for msix_vec_per_pf_max parameter. Fix it by reducing the BNXT_MSIX_VEC_MAX
value to 512, even though the maximum # of MSIx vectors supported by adapter
are 1280.

Fixes: f399e8497826 ("bnxt_en: Use msix_vec_per_pf_max and msix_vec_per_pf_min devlink params.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index 95f893f..d5c8bd4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -43,7 +43,7 @@ static inline void bnxt_link_bp_to_dl(struct bnxt *bp, struct devlink *dl)
 #define BNXT_NVM_CFG_VER_BITS		24
 #define BNXT_NVM_CFG_VER_BYTES		4
 
-#define BNXT_MSIX_VEC_MAX	1280
+#define BNXT_MSIX_VEC_MAX	512
 #define BNXT_MSIX_VEC_MIN_MAX	128
 
 enum bnxt_nvm_dir_type {
-- 
2.5.1

