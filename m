Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B2F3B6BB7
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 02:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbhF2AcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 20:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbhF2AcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 20:32:03 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE72EC061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 17:29:35 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bu12so33158311ejb.0
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 17:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KORehOK4WOMSJSyCcBUoH60fOJezcrogsSxtZqobNEY=;
        b=Skr4PqmS/6QlUfEFSFq6UXlf7CY3yfDtP0SwV194Tmy25ZaX+umRJnCHQSZhvx4TvC
         KBsjXNZcUXJ/Ho+10amsnuDac8mfVODSaImKf5ardQfU3kyh0h8byaa4l9RuNzB/fova
         bKmUkSUeBdjuAgwQK2Q2e4PEZU+KEruj2p1H+vzguiWsO+NHxeCWU1jbFPWw1TsKco0M
         fZ0jrdUK35Obs78KegUtVt6USNbHVojE1V/LrvpuWCtND+ydGItCo6fB5RV4KeNmrby6
         kAeMzbwSqdqmVrJI2GxUXZ8DXMhL+pEtfQXXDfaN/ZuYBApnZ4gVISePyD5i09TcP3rw
         BVvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KORehOK4WOMSJSyCcBUoH60fOJezcrogsSxtZqobNEY=;
        b=fIOT3ndItv5++ZsvDPQgbkahSmz1i/vDPTiH4CPRy6A7nsvXt6r9A9wPbInwadhhYl
         6V9F3BvbBEh9G+9uS6CEEnqnv16R5WNarTABR9MEe7HxMDy2Lza75GR6Yuas7D1Pkle7
         rDjVMqrIwgjSCqa2IX30nDYWYHeMqClln1g5LQN5miHWM3oplyHxlXeNXd+wmIAn1fDs
         /+LPi3Lnsc+qqYsCpXZ3kw5q3WhoVA7EMkXOpBf9eg1FrC2pxLFZ7a0/ZSJXNmdDZsME
         lXQ4EpONkF9PKU3OVGy7UdGY3aZke3am5op7gslFwLiKh5G+ZqEdB1/plwEzoEmuoVpA
         tcrA==
X-Gm-Message-State: AOAM530Y4Hr3yv/23f+or674NzdGfzQXdNEgKt1Iw5GRpQ+U8WDq2Zct
        o+QBne/m/bnJTinm+S3vpVKKPBWkLtk=
X-Google-Smtp-Source: ABdhPJyUQQU/WE4dF6H6FF0KyzO+NP3vBOQNbMLBpUp3ENwkkfx+C5+7fOY+oOezwRVPtkCSY51nxQ==
X-Received: by 2002:a17:907:1ca0:: with SMTP id nb32mr26224543ejc.105.1624926574283;
        Mon, 28 Jun 2021 17:29:34 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s7sm7749913ejd.88.2021.06.28.17.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 17:29:34 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 1/2] net: use netdev_info in ndo_dflt_fdb_{add,del}
Date:   Tue, 29 Jun 2021 03:29:25 +0300
Message-Id: <20210629002926.1961539-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210629002926.1961539-1-olteanv@gmail.com>
References: <20210629002926.1961539-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Use the more modern printk helper for network interfaces, which also
contains information about the associated struct device, and results in
overall shorter line lengths compared to printing an open-coded
dev->name.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/rtnetlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 745965e49f78..ab11c9d5002b 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3947,12 +3947,12 @@ int ndo_dflt_fdb_add(struct ndmsg *ndm,
 	 * implement its own handler for this.
 	 */
 	if (ndm->ndm_state && !(ndm->ndm_state & NUD_PERMANENT)) {
-		pr_info("%s: FDB only supports static addresses\n", dev->name);
+		netdev_info(dev, "FDB only supports static addresses\n");
 		return err;
 	}
 
 	if (vid) {
-		pr_info("%s: vlans aren't supported yet for dev_uc|mc_add()\n", dev->name);
+		netdev_info(dev, "vlans aren't supported yet for dev_uc|mc_add()\n");
 		return err;
 	}
 
@@ -4086,7 +4086,7 @@ int ndo_dflt_fdb_del(struct ndmsg *ndm,
 	 * implement its own handler for this.
 	 */
 	if (!(ndm->ndm_state & NUD_PERMANENT)) {
-		pr_info("%s: FDB only supports static addresses\n", dev->name);
+		netdev_info(dev, "FDB only supports static addresses\n");
 		return err;
 	}
 
-- 
2.25.1

