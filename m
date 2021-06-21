Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD4E3AEA52
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhFUNuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbhFUNuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:50:09 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4372FC061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 06:47:54 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id a21so133227ljj.1
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 06:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SASi1YpFpMUkJ64Le8/IeFITdE8GbmoDrnszDTrRUTI=;
        b=aBc54gnr5XtmaWmVkd4hlWEkZ+4fhLfJtwGg3IeYBRd5YtULORrA7vKI/F1fbmKIm3
         5u5ys6cowunQGbGkMru2OIpHQa399dusgkO64u20iptSLnRba9/zEOwO/9gYfSolqO6l
         C9bWITX1qQq6PYEKe+EHaKN3f4veLbd33lV+UrxQvUhOxzpRTYFTO8eLx/t4FePtJ/OE
         r3oWW9ZKqgy3VJcKKyUcs90PP7kaPWnRiZ0VJtJ0uDS97vueceB/SrjyKVJB5/41qDt4
         fNd5ULhz3nxtXcUTjBY9NdxJhVONQa5uHo0rjx5KeFuYju1LV5e40VKEC3b4ULaxdvo/
         dp2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SASi1YpFpMUkJ64Le8/IeFITdE8GbmoDrnszDTrRUTI=;
        b=WvAO6O+lhNkFYCWtbeYyQJ36VwUF4hS/1ja59YqnMHY+O7E7KHEf0sPNcxMAsjP85j
         aeF70tHpxxL+MydPqUjJKJfz6csE+WtrgGRcs9HT5hiLAc6ZEbuh+fEMIoH5W8ReVtUz
         PjTa89Dnkhl951idk4QUDVSMb+CD5lC3JB0nhGKVDcbesv1LXE0D9eKtRfka19O0iEt2
         Jf6tScaJc2y3cpTx0XKC+jOVaYlNnHza8ovIxZLJW2siGNDXV0q39HgISBWwAMl+Q4tR
         c4QwX2hsFme7DLiUQg4HdlRpX8mb7U0XmyiQyfvOgOfHS8qJ/uAI8+CVObmdg70i1qHr
         iJ1Q==
X-Gm-Message-State: AOAM530OvHTEjTHaeFJHoHUqugLK5XSDg2jxL+zfQnqCPM1SPcvFOEef
        SrL1AhCBr1472vZtt4cvfiqoKwrUnfJ8PA==
X-Google-Smtp-Source: ABdhPJyQEqrL0DF0IbYQuL+V91Sfnjp29S09tbhqm+z6Hi9EJSRxf61Uc9/f+R+VZHgJlg33kBrlYw==
X-Received: by 2002:a05:651c:a0a:: with SMTP id k10mr21469922ljq.22.1624283272352;
        Mon, 21 Jun 2021 06:47:52 -0700 (PDT)
Received: from localhost.localdomain ([185.6.236.169])
        by smtp.googlemail.com with ESMTPSA id e21sm2192283ljl.26.2021.06.21.06.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:47:51 -0700 (PDT)
From:   Eldar Gasanov <eldargasanov2@gmail.com>
Cc:     netdev@vger.kernel.org, Eldar Gasanov <eldargasanov2@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v4 net] net: dsa: mv88e6xxx: Fix adding VLAN 0
Date:   Mon, 21 Jun 2021 16:47:03 +0300
Message-Id: <20210621134703.33933-1-eldargasanov2@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

8021q module adds vlan 0 to all interfaces when it starts.
When 8021q module is loaded it isn't possible to create bond
with mv88e6xxx interfaces, bonding module dipslay error
"Couldn't add bond vlan ids", because it tries to add vlan 0
to slave interfaces.

There is unexpected behavior in the switch. When a PVID
is assigned to a port the switch changes VID to PVID
in ingress frames with VID 0 on the port. Expected
that the switch doesn't assign PVID to tagged frames
with VID 0. But there isn't a way to change this behavior
in the switch.

Signed-off-by: Eldar Gasanov <eldargasanov2@gmail.com>
Fixes: 57e661aae6a8 ("net: dsa: mv88e6xxx: Link aggregation support")
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index eca285aaf72f..961fa6b75cad 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1618,9 +1618,6 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_vtu_entry vlan;
 	int i, err;
 
-	if (!vid)
-		return -EOPNOTSUPP;
-
 	/* DSA and CPU ports have to be members of multiple vlans */
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		return 0;
@@ -2109,6 +2106,9 @@ static int mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
 	u8 member;
 	int err;
 
+	if (!vlan->vid)
+		return 0;
+
 	err = mv88e6xxx_port_vlan_prepare(ds, port, vlan);
 	if (err)
 		return err;
-- 
2.25.1

