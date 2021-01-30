Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F09E30957B
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 14:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhA3Noc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 08:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbhA3Noa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 08:44:30 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A7BC061573;
        Sat, 30 Jan 2021 05:43:50 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id j2so6881180pgl.0;
        Sat, 30 Jan 2021 05:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pXf19g1065wNWBhJVun5K/h2HFDi9av6GCTtkJcQ4oQ=;
        b=EPP7VyKD6pGX2BXlfpgYQt/Sxl7Cpo8UUvOPjWSJt9KxinW86pRGQ6EoHoG7fJDFAR
         W68G0/v+ENMjmLux1nD41PzcsDvRkcWNoFv5YyPotn928MUJuNHm0UDoseDFGxJ7vFXj
         QRpV0UuQWi3MmA/jqs+/pHsId20erXNjIArr886ahpQta2VxYb8VleMo+quURkN04KEX
         WC1EKGimnKiJkDt6GveKT4NyLMQVsUqzRm+yDoF5wmnuWr7bMVWfEu8zEtXQ2UuvO6du
         Mzc4boKUV/VT34HwaIhKC568/IuG7fu2l203fQiq8O2tMGmcvZYqPhy43Xz8v0j92Zmp
         lfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pXf19g1065wNWBhJVun5K/h2HFDi9av6GCTtkJcQ4oQ=;
        b=RHNJ5ISoHflw+qH98s8Lry+IaprNaE9wdyzrlYsugqmXYVnZv3A7UcTbyOydFIWfym
         hxOqRFQ4hDWrrYULmYJK53MZeILlIAlV+pP62AMM/2z9pad/KjOsQ7PKfZM+VnDdDkkd
         s4lX3tx20YyUopfeFSw3WxpUXOi5CmA0SdAu0xf9+EiHMrWh25N7JaKnq32UwZdAfAZI
         793oJLneq0EgvFH0ITDrXXOCVhN/L6IYJzQU66B2v9Yox65OHKWYi9nXNMygqwyAr2OB
         Kogkn5aIqrJWMvwBrgm5luFJiIJJP91SVqM/uHEkUG5adj6Wcec9eLiLOWqQwjHr0IA1
         PNOQ==
X-Gm-Message-State: AOAM533BJk3WQ8KBoxvZDaU2NDgY83M1+v+Fzfo4vFroznNxyo+x9YCd
        zfKAotKlffifdRYkoZKbIl0=
X-Google-Smtp-Source: ABdhPJyjOqOrKJn3U6OZnWdz9JlOCbFbj3wVfa56C6FQj73gwwRIj/uAKgPn9ZYZetiSC5N1yj3B0Q==
X-Received: by 2002:a63:50a:: with SMTP id 10mr8731220pgf.273.1612014229346;
        Sat, 30 Jan 2021 05:43:49 -0800 (PST)
Received: from container-ubuntu.lan ([61.188.25.180])
        by smtp.gmail.com with ESMTPSA id c3sm12171253pfj.105.2021.01.30.05.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 05:43:48 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net] net: dsa: mv88e6xxx: override existent unicast portvec in port_fdb_add
Date:   Sat, 30 Jan 2021 21:43:34 +0800
Message-Id: <20210130134334.10243-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Having multiple destination ports for a unicast address does not make
sense.
Make port_db_load_purge override existent unicast portvec instead of
adding a new port bit.

Fixes: 884729399260 ("net: dsa: mv88e6xxx: handle multiple ports in ATU")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b99f27b8c084..ae0b490f00cd 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1686,7 +1686,11 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
 		if (!entry.portvec)
 			entry.state = 0;
 	} else {
-		entry.portvec |= BIT(port);
+		if (state == MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC)
+			entry.portvec = BIT(port);
+		else
+			entry.portvec |= BIT(port);
+
 		entry.state = state;
 	}
 
-- 
2.25.1
