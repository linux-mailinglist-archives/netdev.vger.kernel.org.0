Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22826C374B
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 16:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfJAO2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 10:28:52 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40983 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbfJAO2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 10:28:52 -0400
Received: by mail-lf1-f67.google.com with SMTP id r2so10027630lfn.8
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 07:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dOnQRHuZg3+A43ZWR1Sh4+B1CBZaubbsu4Cf1B78l2s=;
        b=GCSBgWUhLC1/hacn9w65hkfjd2QAXs7sPy2jFeYGMt8o+ZvKe2D79/hX5I0kPWrpbF
         IciZFYCy/UAURk66OdagJhJjqZqq4BG3vFtdn3PDXS161c9jmnXxh2rW04eRrzdQYxqA
         Wo3C5ureV12bWq5i2QysA1LLjNlxhkq8/sY5SEMlP3xhFMccFifeJ4hd9Kw2XktDplBO
         IUoPvPkpXjmTpnSNxDtQQA9eO+3VhEQHq4KN3NzBS1pEt0xCUlSAiVThMVrMGxbLvBVh
         vFnsWWWosYxENhBoXiJYeoo/H8izmrKnVv/BUGMRhCcv4huvgyevhRACwefz26pmrWUz
         1rVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dOnQRHuZg3+A43ZWR1Sh4+B1CBZaubbsu4Cf1B78l2s=;
        b=KQV9VIHyuiYhJCGFUQ6MbQdnqv5Ea18LbeLcOnbA97AIQntnt9ZgNFxmLSK837o40p
         4hLrtUl3h6JAs9GBJcPa73KHTlLLBGHFd9u/b0Xgrc++0SNQKd01C3MM8yYxNgicwhRP
         6TR2Nk9fTYtBWoz9AQPFPua/PoWGI8V49oFNylW2GM5TfR9Wab86MscUQ0IsmL6mmJcw
         5rSHnjKDOxaSr+cDphhwixFBFAbBSuWB+JGJE452Ty1oB7U9zksOIZKyhFpnDYJBc9oV
         Zuh6YIFYh1D3ROejOpQwrgnU+dNYwMv46Jig7LaoRjEK4Tb2WhumgWOqRlsXWCZPOwDT
         Apgw==
X-Gm-Message-State: APjAAAVaXl6tiAYKD+r1XmS+gS63osZGsG9pNUVoIBl7vQ12EMC6KONa
        dKynhnBG7JSLR/6FEyczd6Xyuw==
X-Google-Smtp-Source: APXvYqxwFPZ7QkplxOnhJ+Ic0QnBXOu9+tb1HRlJ0u4EzkP9Z3iShojRmhp5bVBTlW2lCBl9daqFAg==
X-Received: by 2002:ac2:5966:: with SMTP id h6mr15787019lfp.78.1569940130552;
        Tue, 01 Oct 2019 07:28:50 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id w17sm3921054lfl.43.2019.10.01.07.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 07:28:49 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] net: dsa: rtl8366: Check VLAN ID and not ports
Date:   Tue,  1 Oct 2019 16:28:43 +0200
Message-Id: <20191001142843.10746-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There has been some confusion between the port number and
the VLAN ID in this driver. What we need to check for
validity is the VLAN ID, nothing else.

The current confusion came from assigning a few default
VLANs for default routing and we need to rewrite that
properly.

Instead of checking if the port number is a valid VLAN
ID, check the actual VLAN IDs passed in to the callback
one by one as expected.

Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Fix the iterator to actually check the VLAN ID.
- Use "vid" as variable name.
---
 drivers/net/dsa/rtl8366.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index ca3d17e43ed8..ac88caca5ad4 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -339,10 +339,12 @@ int rtl8366_vlan_prepare(struct dsa_switch *ds, int port,
 			 const struct switchdev_obj_port_vlan *vlan)
 {
 	struct realtek_smi *smi = ds->priv;
+	u16 vid;
 	int ret;
 
-	if (!smi->ops->is_vlan_valid(smi, port))
-		return -EINVAL;
+	for (vid = vlan->vid_begin; vid < vlan->vid_end; vid++)
+		if (!smi->ops->is_vlan_valid(smi, vid))
+			return -EINVAL;
 
 	dev_info(smi->dev, "prepare VLANs %04x..%04x\n",
 		 vlan->vid_begin, vlan->vid_end);
@@ -370,8 +372,9 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 	u16 vid;
 	int ret;
 
-	if (!smi->ops->is_vlan_valid(smi, port))
-		return;
+	for (vid = vlan->vid_begin; vid < vlan->vid_end; vid++)
+		if (!smi->ops->is_vlan_valid(smi, vid))
+			return;
 
 	dev_info(smi->dev, "add VLAN on port %d, %s, %s\n",
 		 port,
-- 
2.21.0

