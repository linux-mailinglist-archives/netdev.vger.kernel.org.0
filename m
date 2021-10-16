Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9F9430422
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 20:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236771AbhJPSWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 14:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234320AbhJPSWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 14:22:45 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B505C061765;
        Sat, 16 Oct 2021 11:20:36 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id g2so4955754wme.4;
        Sat, 16 Oct 2021 11:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lipIEZ+n1vyEC0IkcC3jv40a0eLLrhXH63M7mDRpB6I=;
        b=eYT8t574M05uVS1H1EfgJk/5BEpGNyusvh4tDe2wGvBLCueBhSscEjrIC9gSXjfplS
         UWiv4BH+iBcmmj7kaiA/9VXTBDQbo9rIRhSkdr1UjqbhKSbPGfFHnWFn5QW6kKql+xnL
         xVoEw6Piz4a7XRswSPLxJbvlHh/BB+tQH2gMvtOVoITGvUPtTWbE0jloBwXayqY3e89I
         XCm8o3dI7Hyy8OQsT/b/hN7mjAJnVe4Jvfj00v6ohzAq+VKqmGQPfDRHNxM3kzm3Foyr
         ywPiBLx+m0o1fa8xIL7/yQJdikW29dA766rJ5uApIzdcjrAsnqey9g3B5O3bltVr8AXh
         BGrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lipIEZ+n1vyEC0IkcC3jv40a0eLLrhXH63M7mDRpB6I=;
        b=IZQdiEwP03GcWrKQCoBAoBladHDs6ec7JEDeY49a+zMM1TLLazZrduk3K0usHkzdUy
         hXjwfkuSru5TZyDyq7uOCtgCCBHsEDlmPXHFPz1GDkG+B75yxJaTdzP3cxa18BPdA7De
         rBJbW0LUPQmeuivqB1ujjVdixi4lMSlCPVvJB5+xdCnVhPPnggvakwnJr2h4nMvlE24y
         OgJTeNLa47kGmGERvaNmo7UjVPPY/Rt2cjbMiQYtS1iwzj47B/pTBvy6pkKq8V3PHCzP
         vBmr2D2sJkuTWZeM85iEdmCpMwRylAoYkDQ45HG2u7h6563vy0Pup2kfRSZViQqkm12d
         u6Fg==
X-Gm-Message-State: AOAM530XMks9d0z5yKJ9iuhBHmiU4gGgvXJNEuRZhsNh+ihSCkgLoCsQ
        MWfE1IjOJhoBNSLMznW8wWg=
X-Google-Smtp-Source: ABdhPJwBHG8OptDZ0NKxN0FDnaRmx+SErG5UvPOrK5Bg4V0AE1f8go5bVzGWSHIe+NM7ApQvb0BVmw==
X-Received: by 2002:a05:600c:354a:: with SMTP id i10mr33401008wmq.70.1634408434928;
        Sat, 16 Oct 2021 11:20:34 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id g1sm14746049wmk.2.2021.10.16.11.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Oct 2021 11:20:34 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH] net: dsa: qca8k: fix delay applied to wrong cpu in parse_port_config
Date:   Sat, 16 Oct 2021 20:20:24 +0200
Message-Id: <20211016182024.25037-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix delay settings applied to wrong cpu in parse_port_config. The delay
values is set to the wrong index as the cpu_port_index is incremented
too early. Start the cpu_port_index to -1 so the correct value is
applied to address also the case with invalid phy mode and not available
port.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index ba0411d4c5ae..ee51186720d2 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -976,7 +976,7 @@ qca8k_setup_of_pws_reg(struct qca8k_priv *priv)
 static int
 qca8k_parse_port_config(struct qca8k_priv *priv)
 {
-	int port, cpu_port_index = 0, ret;
+	int port, cpu_port_index = -1, ret;
 	struct device_node *port_dn;
 	phy_interface_t mode;
 	struct dsa_port *dp;
-- 
2.32.0

