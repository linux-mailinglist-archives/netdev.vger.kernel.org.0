Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE1A23ADE8
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbgHCUEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728714AbgHCUEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:04:01 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6763C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 13:04:01 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id q17so21456990pls.9
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 13:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YVPszMbwLuPAYUh6gtr8v5TkolvvDU333qnxOlVp1Sg=;
        b=oBIsRWXRuMFgeiJIimoFC5QisEjNJkhqvL7ikXhCZAuYX8wj+4IGa5hyFweng4+trp
         oDqGLejN5W/vAWIhzM2kGIQTE3V8wYjtYz6ZLpCFJ68VghsMAgGWLchCMMBSxGNe/J8T
         wf2zxTomvp0ldgVa/40v3L5b+cIw9z6Po5C6n+7AB9CsAr9PrFqnfKKBas9f94s33HaM
         IaUpqPzQWvOgWJfdaGBsfjVq1K4LjK3sm71AJ9i8IGv8GmyxuovekPEX5hHyALkeEDEW
         OjsDDla0yKfNvBSikO8r6HL5GRyoHf6U13novQ8YEVutrxI/d4Tl97YpUKwNYkvuj8Cv
         6YSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YVPszMbwLuPAYUh6gtr8v5TkolvvDU333qnxOlVp1Sg=;
        b=mBEL8brGNxV6Mcsri0PLQGIceCB73eRA0+Qd0/FEp4iAFKNebjbMt7bKIoQ+HOT1Dw
         3QcQYtazaaWeWjdBFa0ZqYypwUdP/O90MC31NS8jfkp1PGKJJ1QqqRUJYIuBC1zS0idJ
         9vD7othgvVYC2Vl/Ip1gKFXBik1VwEtWzm1k2zkabifbKan+d+Vpj/iz1kQ5wCgLSEPF
         JlDvB3BKUs89GoYvunr6ROAG8dEXkJ0egUGc4dKdT11WHGYtPziFyJGP8z+Jym0ZZ5bs
         U5Sr8r2FPfiUcxk1j0yjWLe1b68zAlYvwYbaMnTLtR7e2UEkPBAx0JjDohGDqIEXqUQX
         yZPA==
X-Gm-Message-State: AOAM53243ZFiHmmNgiSOIqHYCt02CBRJs+HOtVGRsnMGMkABKVPhbsQw
        I2R0hivfvnUr8eq0DOsp7+kMBONC
X-Google-Smtp-Source: ABdhPJyUq/ZpvCUE7+MPrdYX430X7MNrrsxF/4EeXlFlQwYpjRQsV0lFtGfI+suD+fhmHxJ5DpvRMA==
X-Received: by 2002:a17:902:b943:: with SMTP id h3mr16680350pls.38.1596485040924;
        Mon, 03 Aug 2020 13:04:00 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u24sm20017521pfm.211.2020.08.03.13.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 13:04:00 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/5] net: dsa: loop: Support 4K VLANs
Date:   Mon,  3 Aug 2020 13:03:51 -0700
Message-Id: <20200803200354.45062-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200803200354.45062-1-f.fainelli@gmail.com>
References: <20200803200354.45062-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allocate a 4K array of VLANs instead of limiting ourselves to just 5
which is arbitrary.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/dsa_loop.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index 4a57238cdfd8..6e97b44c6f3f 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -48,12 +48,10 @@ struct dsa_loop_port {
 	u16 pvid;
 };
 
-#define DSA_LOOP_VLANS	5
-
 struct dsa_loop_priv {
 	struct mii_bus	*bus;
 	unsigned int	port_base;
-	struct dsa_loop_vlan vlans[DSA_LOOP_VLANS];
+	struct dsa_loop_vlan vlans[VLAN_N_VID];
 	struct net_device *netdev;
 	struct dsa_loop_port ports[DSA_MAX_PORTS];
 };
@@ -191,7 +189,7 @@ dsa_loop_port_vlan_prepare(struct dsa_switch *ds, int port,
 	/* Just do a sleeping operation to make lockdep checks effective */
 	mdiobus_read(bus, ps->port_base + port, MII_BMSR);
 
-	if (vlan->vid_end > DSA_LOOP_VLANS)
+	if (vlan->vid_end > ARRAY_SIZE(ps->vlans))
 		return -ERANGE;
 
 	return 0;
-- 
2.25.1

