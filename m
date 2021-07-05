Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6453BBD60
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 15:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbhGENQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 09:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhGENQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 09:16:22 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA02EC061574;
        Mon,  5 Jul 2021 06:13:44 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id h4so18253189pgp.5;
        Mon, 05 Jul 2021 06:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wFmAr/8kD/4DnJeP0k0Om9P2bTmcS4/IENh/FR70ReU=;
        b=eO1L2aKpwY2CCfPM/UQZcmfKJaylanS0BZAQbHSNM0KtuNbmpUZzBsl/TGptzoT4Fm
         izUBqQy4qS7SeA6NR1dbtMaLJyF2luIsziceDnbgjxLWrbn3e1R2gqhqpeF4f5Mtr2cW
         yNhcV3Z21CovXQ4TG4KcLMTIhHP7bnzCr10zXlPVCSFZccJ98C4/wZIBejT1VkdCUfus
         6VUKPGBb3qdVgEAniVoXLnoSEdXbEngy1aSYEp0iVPEFmM/3QgX3ah/o2b02GL1lFHQr
         cJI3oe0BT7xMq6W/BCXmouTDq1wZjKVXwc16T0xZzJz5LPyei9to38PIGEwM6U2X5ZLi
         EwcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wFmAr/8kD/4DnJeP0k0Om9P2bTmcS4/IENh/FR70ReU=;
        b=CB3bYUaSTJky4T6Zz6dJv2tcMpbAiakVmm2z82YS4Eye+29wUuK4tWfvLmVs5fCKTq
         zSNjb/LIMFBE8aa7va7re248IsUem2sjJbQeoJA4ZbdKQZ+BONNKkin+Pt2UTH4KCcul
         Qn1974cXfhT1NFP3NJAblgbVMMIQ6r6+SbZHhrVvG9FUJzXZbKpd5Qdyt+HLpyRsDevJ
         lCkGVGPhhLOtVBWd2h5Zna2hKEOY5so3ivii32o681a5VvD+GbTJvjMoZwdKIyHAIwWA
         ERClhk6VJn2aHYpQ92pfexKuxUOZ7tAoHcf+GlbvRzp/TeZTQuqrLUqhEQYonBMsqsjq
         bzTA==
X-Gm-Message-State: AOAM531I7c6xoZ0xPk4WyHBCNzKu4XL2WEPclMtP2Xl0uLKPlec22hwt
        rMRDlhCylstQgJQad/kNVk0=
X-Google-Smtp-Source: ABdhPJx9A2kcwStu6d8y6Vi0qpz3Y2owioRqVMIYcD264kII+3mQGLQWUYA3gALoexJHddnf+2gLxw==
X-Received: by 2002:aa7:959d:0:b029:31a:8c2c:e91d with SMTP id z29-20020aa7959d0000b029031a8c2ce91dmr11889870pfj.64.1625490824349;
        Mon, 05 Jul 2021 06:13:44 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.93])
        by smtp.gmail.com with ESMTPSA id y9sm12326191pfn.182.2021.07.05.06.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 06:13:43 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        Alexander Aring <aring@mojatatu.com>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ieee802154: hwsim: fix GPF in hwsim_set_edge_lqi
Date:   Mon,  5 Jul 2021 21:13:20 +0800
Message-Id: <20210705131321.217111-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE,
MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID and MAC802154_HWSIM_EDGE_ATTR_LQI
must be present to fix GPF.

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index ebc976b7fcc2..cae52bfb871e 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -528,14 +528,14 @@ static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *info)
 	u32 v0, v1;
 	u8 lqi;
 
-	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] &&
+	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] ||
 	    !info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE])
 		return -EINVAL;
 
 	if (nla_parse_nested_deprecated(edge_attrs, MAC802154_HWSIM_EDGE_ATTR_MAX, info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE], hwsim_edge_policy, NULL))
 		return -EINVAL;
 
-	if (!edge_attrs[MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID] &&
+	if (!edge_attrs[MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID] ||
 	    !edge_attrs[MAC802154_HWSIM_EDGE_ATTR_LQI])
 		return -EINVAL;
 
-- 
2.25.1

