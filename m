Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7D6259EF9
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 21:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731567AbgIATJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 15:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgIATJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 15:09:44 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F89C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 12:09:43 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id s205so2882328lja.7
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 12:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=id0mJz9CTwcZW+yxfbEEsDFsQOXvdONt8oYCbKFSTvs=;
        b=DUoBC24HALG+kr5oX0JldkWc+SYqQ++h064lEMN3h6dY6nTq5fZi81kS7Mm/RSivJC
         zESWeGusMOaGCG+bsZeTe45UaXFza8F/umkuzq/r2hmf0xTU8l1yfpfwKYWIN/vqyge/
         MZ/psTEy1LwWFsb3NVagUFBAW6veY1bHzbcWDYOoUx2KtvlNeQwuinAPrnCEJ7tEZM3B
         TSIpydJYihLA6yAScP0edjRlyDM7qH32frLga/pcEK9cNLPA90b29xd/6swwUyFccXLY
         f/fVBjQRZBdyJk5nRLoBr8y/cfFbLMQWm1RAdqMaGuPB1qjX+1AmklBGyePzqHrWDa6O
         591w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=id0mJz9CTwcZW+yxfbEEsDFsQOXvdONt8oYCbKFSTvs=;
        b=G1Q/VleD4eSgX8q+nrbx3j/+lNZpuqp0e5XGjvBzIB7kaSiKTklc7UfyXNJbgLLRIQ
         ipJKIHyaJjtAhiD5F2zomMC8U98TSVu/h6N/9AVlbxhlh1VukSLkBdSzJ/ey72UScKfi
         l5XqhSHwYKykjvqLDhdriSkM8JwEiYjAlWsngQzWewoOWmOzhiRFlbU9sTsQ1/8KyVYF
         Xz3RSKpk2q+t7aG8QcSoc3GoBUBd4RIKT/byRbeJoUxEZ0ByLCO9gQ3jFrSCmPqWvzsw
         1qPZUBTRLGPjM0ju79b8kpqHhl2qp+PpR06ijNpQsywjavYuc/Lul9LvPEU/Da85Ay2F
         09Fg==
X-Gm-Message-State: AOAM531dgfnKy7gzYKUXdQnt+j9nUt/iYGRXes2PVmIHij6fmI2OXhm0
        LIpfdddMLZWNlMdROxoaf2WOLQ==
X-Google-Smtp-Source: ABdhPJx2iaDfn3JADpM57vSzoQyYobo9XNhxxuyNUZLUVxpkErbuyBq7YEfe3WFfmGGdbvO4mMZ9lw==
X-Received: by 2002:a05:651c:554:: with SMTP id q20mr1424649ljp.348.1598987382121;
        Tue, 01 Sep 2020 12:09:42 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id j12sm256945lfj.5.2020.09.01.12.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 12:09:41 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH 1/2 v2] net: dsa: rtl8366: Check validity of passed VLANs
Date:   Tue,  1 Sep 2020 21:08:53 +0200
Message-Id: <20200901190854.15528-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200901190854.15528-1-linus.walleij@linaro.org>
References: <20200901190854.15528-1-linus.walleij@linaro.org>
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

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
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

