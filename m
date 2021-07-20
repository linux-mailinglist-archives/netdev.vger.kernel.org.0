Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57053CF6C4
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 11:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbhGTIoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 04:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhGTIn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 04:43:57 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AEEC061574;
        Tue, 20 Jul 2021 02:24:35 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id s18so21934079pgg.8;
        Tue, 20 Jul 2021 02:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LIC3VJ/7p/RfZqSca9kn+/FaUQpa8Xxxwn9zVExpIq4=;
        b=B2ZfSmEsNpuJv7WF3/tPy9fbOJIqR9fGdqNgjqFEh/AFq4VbjHBb4OPqSQZYWv+Du9
         v72Av9UlwCzedGdiEAJUvlMIaPFussRW/e//Am8qP5rm+iN3mpDVQ7vw0pE7pOwPNWii
         9XyHrnuuiHSYR59mw9zfpxu65D7q6mxAWhJRZp26hOFUrCrK1p4c/IzR1mq2Dqfe2UCD
         J1tM8Y2Ukz0qgBQVj9D5e+NWfum2Y0guDPDMXD2uTbmOEWPK8dm7lmWPMvwhktxDlQ9w
         N2dlNkyEHrc/Pgb0UCHsOlU15SLhJYC9WWtnty6NgHfOWwJiT8F1aD0dHvzl/O5DQVBA
         YC8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LIC3VJ/7p/RfZqSca9kn+/FaUQpa8Xxxwn9zVExpIq4=;
        b=FBBRfhsIfdos6irt9kuuk5dHbUxxWU17jYu+GFPUnagQofSbw6S4rFu40VcCMUVAcG
         Ty+qPPY/uwsE/4g8vrxWqfFbO/tQFjIuaELS+N7K5i8VmlToW5FH7YBNMei5PmSYD0gv
         3dk3SeId+EWzgVpGE+/jtrNcfByjPPXPvoGfgyjlqj+o7I6WrdNvfNZv2KnoDpLkolTb
         jZBCgdqoKJBP8QBjp1ia0VXlBxNOheBjXlGOrfTsl8SikOjGrBG0XH0IUwY0ZYSK5mWx
         RYUNiFZTxmJ8pwVemuNp2bPXkjJiYNCGCpYSyInUy2Yd+/ZA2Qrwb4dHSVY3gJHUOR1D
         C1Lg==
X-Gm-Message-State: AOAM531+WybNAJXzOMCWOXq/Zhs24cWdt/NjEdcrSlPcwuaRukmn1U+3
        FmcMZs1MdueIuK4F95iC0+c=
X-Google-Smtp-Source: ABdhPJx0pzz9q7hxyJSIGIlOv/KQ5D/4MDmV3CDvymj/WKCbzzNhmZqdObLgGdjRI6wFqjVALqLc4A==
X-Received: by 2002:a63:e841:: with SMTP id a1mr29768144pgk.197.1626773074830;
        Tue, 20 Jul 2021 02:24:34 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id u62sm11353937pfb.19.2021.07.20.02.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 02:24:34 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: dsa: mv88e6xxx: check for address type in port_db_load_purge
Date:   Tue, 20 Jul 2021 17:24:26 +0800
Message-Id: <20210720092426.1998666-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same state value of an ATU entry can mean different states,
depending on the entry's address type.
Check for its address type instead of state, to determine if its
portvec should be overridden.

Fixes: f72f2fb8fb6b ("net: dsa: mv88e6xxx: override existent unicast portvec in port_fdb_add")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index beb41572d04e..dd4d7fa0da8e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1741,7 +1741,7 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
 		if (!entry.portvec)
 			entry.state = 0;
 	} else {
-		if (state == MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC)
+		if (is_unicast_ether_addr(addr))
 			entry.portvec = BIT(port);
 		else
 			entry.portvec |= BIT(port);
-- 
2.25.1

