Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0203615C5
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237585AbhDOXDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234949AbhDOXD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 19:03:28 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5F6C061574;
        Thu, 15 Apr 2021 16:03:04 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id cu16so10907902pjb.4;
        Thu, 15 Apr 2021 16:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VEsA/vSJtUoYWrO4uAbtIW1LBwaGDshRVIPmviTWMZg=;
        b=sTY43m/J0eQ1mveMQ0MibuFp5oZf0LZCRmqg4cCRYn0G2Su5DkBrOctoP1pYz2RDYk
         BOPrfaZ60KA9xirVL7WeZms9PlqikmRhClL26Od4u0I0VjIt0Y8p7JWId+JHC0F4f8Ux
         dKvvKixr6qsJqVuQ2eobuojielaJfhM8b3A5yNBlURA0Og7OFB+oIvIoXp426W2GOYv5
         6A/T2XYmKE4gQXAjJd8iES7zbennj5VdzUGlwry8O5ZSVk+0duoacUarPlIrfOpWwaMu
         0VK84C8hyAz8ms0f4LHRMMZVEV7xw29dQzWhZacgIW5J7gFtCA7jUoiM0n2o2PkYF47A
         IPDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VEsA/vSJtUoYWrO4uAbtIW1LBwaGDshRVIPmviTWMZg=;
        b=uZOqDaLcLsz9z2hFVWEtewPphW0PSX1sRHjACPXcxf0ZYL35WzUpD9hRDz3dvLgYqr
         dCJslDdgfs69TagF1udKWnXeSvT4JU2uYSyBOMPOzaHbZh2J9E54twJVpwHDrwSRy66l
         srU3+AeU+haFZBjdCHjPFCiJDAfvEzY8fZfg/JiO27ZO7xpbNrZQHrwyMO2TST34PonB
         64u+lNMXGh0/yqhcMOTgcMOcjNOV2eiwl0PLaY7n2h82OqAjRJWM6eknVpIPUGs6KBKn
         krX1u8G4kTv9Kz3Z4FcrvY6rgT2wIO9Stfcjiimh7xTRm2pMx5UTAFS8z9Jry3P8YkO7
         VxPw==
X-Gm-Message-State: AOAM530XdI1JMHWcViiMzv4SZYQm5+XXy5ZvztA+869N4je1xTERWHNz
        DkUI8rN+4+cqbvPBpdAYtuQ=
X-Google-Smtp-Source: ABdhPJzvCvR+LUagBVcV1BGlfgoA/0OIIsUcxnNmR0cY9uYIsczoVfDFBbwaGep2Kn8Hf1LBAOsx6A==
X-Received: by 2002:a17:902:8504:b029:e9:ab75:3938 with SMTP id bj4-20020a1709028504b02900e9ab753938mr6536729plb.24.1618527783953;
        Thu, 15 Apr 2021 16:03:03 -0700 (PDT)
Received: from ilya-fury.hpicorp.net ([2602:61:7344:f100::b87])
        by smtp.gmail.com with ESMTPSA id e23sm3004019pfd.48.2021.04.15.16.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 16:03:03 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next] net: ethernet: mediatek: ppe: fix busy wait loop
Date:   Thu, 15 Apr 2021 16:02:34 -0700
Message-Id: <20210415230234.14895-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The intention is for the loop to timeout if the body does not succeed.
The current logic calls time_is_before_jiffies(timeout) which is false
until after the timeout, so the loop body never executes.

time_is_after_jiffies(timeout) will return true until timeout is less
than jiffies, which is the intended behavior here.

Fixes: ba37b7caf1ed ("net: ethernet: mtk_eth_soc: add support for initializing the PPE")
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 71e1ccea6e72..af3c266297aa 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -46,7 +46,7 @@ static int mtk_ppe_wait_busy(struct mtk_ppe *ppe)
 {
 	unsigned long timeout = jiffies + HZ;
 
-	while (time_is_before_jiffies(timeout)) {
+	while (time_is_after_jiffies(timeout)) {
 		if (!(ppe_r32(ppe, MTK_PPE_GLO_CFG) & MTK_PPE_GLO_CFG_BUSY))
 			return 0;
 
-- 
2.31.1

