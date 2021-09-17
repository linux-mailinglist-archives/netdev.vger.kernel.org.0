Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1F340F502
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 11:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241178AbhIQJox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 05:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbhIQJou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 05:44:50 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC1EC061574;
        Fri, 17 Sep 2021 02:43:28 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d18so5793620pll.11;
        Fri, 17 Sep 2021 02:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rjUsrgKAG842TTdbvaYfjn7xP48jRXz0AO+9is4lw+4=;
        b=eshssGgeztlgeR06W0sS7LaYwmch7gTNshpRHn6lJDAs/tqnzRp/VHfCf0CbRdIOd+
         ZOdw5CZ1Bc/qeGUvButzESvlt1M4NYiOtEHWsgOiS5mpjOMwbriGn8AbsgGcJfyIBtT0
         /9SmqWSwxjgpLRySOMoB4aAmDDfXpuw7S9/M3rRo5UovQssSVtOdnvYGQaoR9EtefT0f
         JYYp6notUeG0LBmLXyiMfkwtDNKUXavCLWt9F3bARIaGA/KQmvf2bIhDo+oCY4zA/1p6
         o4iDL/Drk3NO9aZTW9SBaFOjiMD6UHfD4cbKzXfwv9WfalzTbiqpns3Tqbi86CFv6swi
         Xx7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rjUsrgKAG842TTdbvaYfjn7xP48jRXz0AO+9is4lw+4=;
        b=44+Sfmbtgc3ZxOxX+ltA355pyY/G1O4Pa9Y82twrZ46Wg51pcaP3RbSuGYYrBuxWuc
         sw2cw/D0WK4q8+Zh/UX0G2lrOIcLPA0C3VpzUKPqSU3kpG4kO/x2JNhImJ2CV/IcYi5i
         iGOWmzdk/h4jYoeU7l8f02AK7BiVB3Y2rJaESI3C9BuoXGLTuFPaZlQ24ZHvBG2y9NdP
         Fh/jkzAeoJtfLSKr3eOrt+fO2kMpVu9NBjURE0FOCWbbXApCxYwe0JCeK8c/hucM05Bh
         ZwBNfG2jvkcZ1SzlaWAlqfJ6DGUnYTPECg0p9s/nGp1di3AGI1vKtj04GOz8AZK1uLN+
         U7NA==
X-Gm-Message-State: AOAM531Q2Gp2pUOoYIv4druiFJybrTgLPtW9eD1TsUOl7xHSVbjXWfze
        JQCybuRbzCYh1i2Eux/jVpc=
X-Google-Smtp-Source: ABdhPJz7M8K2pr6rL0bZaDgbAka6otCz9P9JWfANr9cLlx5Gik3+t6bxDvJ4GTDuwYmfAp5DyMJYsg==
X-Received: by 2002:a17:90a:53:: with SMTP id 19mr19608028pjb.159.1631871808183;
        Fri, 17 Sep 2021 02:43:28 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id b17sm5871260pgl.61.2021.09.17.02.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 02:43:27 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     m.chetan.kumar@intel.com
Cc:     linuxwwan@intel.com, loic.poulain@linaro.org,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] net: wwan: iosm: use kmemdup instead of kzalloc and memcpy
Date:   Fri, 17 Sep 2021 09:42:41 +0000
Message-Id: <20210917094241.232168-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Fixes coccicheck warning: WARNING opportunity for kmemdup
in "./drivers/net/wwan/iosm/iosm_ipc_flash.c"

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/net/wwan/iosm/iosm_ipc_flash.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_flash.c b/drivers/net/wwan/iosm/iosm_ipc_flash.c
index a43aafc70168..3d2f1ec6da00 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_flash.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_flash.c
@@ -430,11 +430,10 @@ int ipc_flash_boot_psi(struct iosm_devlink *ipc_devlink,
 	int ret;
 
 	dev_dbg(ipc_devlink->dev, "Boot transfer PSI");
-	psi_code = kzalloc(fw->size, GFP_KERNEL);
+	psi_code = kmemdup(fw->data, fw->size, GFP_KERNEL);
 	if (!psi_code)
 		return -ENOMEM;
 
-	memcpy(psi_code, fw->data, fw->size);
 	ret = ipc_imem_sys_devlink_write(ipc_devlink, psi_code, fw->size);
 	if (ret) {
 		dev_err(ipc_devlink->dev, "RPSI Image write failed");
-- 
2.25.1

