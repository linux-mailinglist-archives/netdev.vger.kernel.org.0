Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F36925A130
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 00:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgIAWKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 18:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgIAWKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 18:10:13 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19252C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 15:10:13 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id v12so3427108ljc.10
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 15:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LDDaWjqMAmjJCv+DLBllDCfHYtS/ARuZmXB94WkBHNY=;
        b=c5/+wK46GqI4jcYHumEXjs732pfdhug8+gwYpL1JalYjSvVAnBqKg+Cn0PaN8ya/qf
         BEdS+humYMo0n0647P/xUqiVe78Y9OD3P+asYibpGArFHfcviLYrlen1TnqZLoEjqifw
         IiMN1zVNLylPWt9zoFNIqci7aKt8z6Mj7JlO1ZrBY0mboLBzWUPTb93f/pLJrxn2sSPW
         r2BUo1BxbNtt9uEVKN0nBMw5iCnKrfP8d/ETPSlTq3sfLdEsJczdwQA/9aVATx1lZOKW
         OqDF4QLOky7kHVN1cyJcz2QEQf9J7pN3Wk3b6eRvaKku+Z6m0UqhZo3sJktbEHjwIsMe
         e3lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LDDaWjqMAmjJCv+DLBllDCfHYtS/ARuZmXB94WkBHNY=;
        b=XLgCSlhBwTLZPk/a5sG/KWYAXfRb5jZRdQZ9RNUUv7yksWlvV7i2h5ydbhDgziaNCR
         rSNU9tusulPyqWkvtbOM8s8AW+Qnixo+XkNUwG/wbbwZu2/+QTNSfmBViVXCsbsgQyjG
         RX9y41RDlEIsAhvfs5uhaRVC6f2s10ag6a7WG5+4pkhAiDgjs0hMATtaFncFRyQYbClj
         RhR3Fn2QQhzc6jabloGx2I41XIdsFja8lZzHigdkl601PF7NGRsRxkOYNw2+gJ+ZgnJY
         mlcK+0jVXxqbVSUaoRudGLO5Wp/Lmb0duhJepuPdFrG2fevq6svObY/Pv1pNDhtQvzzI
         wJ8g==
X-Gm-Message-State: AOAM5329U8RBfzz3M9dvXJE3AA/kXKsCZYkb9FFJK8u4I5pQiHE3F2ZP
        S4hc3vJEfCC5IdAW6DjpbFupKA==
X-Google-Smtp-Source: ABdhPJxVT2FUz5CNRdvbhZtWtQ3x2BIOc5YSahXar0rS4qoG/sQgAu4hoaL9VsesqZEP0V9Fy9OE7A==
X-Received: by 2002:a2e:545:: with SMTP id 66mr1707844ljf.469.1598998211497;
        Tue, 01 Sep 2020 15:10:11 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id z7sm568979lfc.59.2020.09.01.15.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 15:10:10 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH 1/2 v3] net: dsa: rtl8366: Check validity of passed VLANs
Date:   Wed,  2 Sep 2020 00:09:34 +0200
Message-Id: <20200901220935.45524-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200901220935.45524-1-linus.walleij@linaro.org>
References: <20200901220935.45524-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rtl8366_set_vlan() and rtl8366_set_pvid() get invalid
VLANs tossed at it, especially VLAN0, something the hardware
and driver cannot handle. Check validity and bail out like
we do in the other callbacks.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Resending with the other patch.
- Collect Florian's review tag.
ChangeLog v1->v2:
- Resending with the other patch.
---
 drivers/net/dsa/rtl8366.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 8f40fbf70a82..7c34c991c834 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -43,6 +43,9 @@ int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
 	int ret;
 	int i;
 
+	if (!smi->ops->is_vlan_valid(smi, vid))
+		return -EINVAL;
+
 	dev_dbg(smi->dev,
 		"setting VLAN%d 4k members: 0x%02x, untagged: 0x%02x\n",
 		vid, member, untag);
@@ -118,6 +121,9 @@ int rtl8366_set_pvid(struct realtek_smi *smi, unsigned int port,
 	int ret;
 	int i;
 
+	if (!smi->ops->is_vlan_valid(smi, vid))
+		return -EINVAL;
+
 	/* Try to find an existing MC entry for this VID */
 	for (i = 0; i < smi->num_vlan_mc; i++) {
 		ret = smi->ops->get_vlan_mc(smi, i, &vlanmc);
-- 
2.26.2

