Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7347C1CC563
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 01:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgEIXps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 19:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726209AbgEIXps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 19:45:48 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ABCC061A0C;
        Sat,  9 May 2020 16:45:48 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id r14so2901338pfg.2;
        Sat, 09 May 2020 16:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=crdP2tN+7nK5nK8+EdCmx+ONI5XbzqOYoFu/3nqOihQ=;
        b=UlGfhXiqI/DCNydBA7vcaeO73tgWeq3fFtmKX8VfBkURAK6tOgK3qUpb31CwIDlU+6
         pkK0ohm0vQiUBM7UTtCZcAOhXjGvvFZSbmmtgDun5zjrYLc78U0x2BZXL1m/RKViA3aY
         4wsNaxhccMYtSSHPW4WVjglAjEqHeo3U5YJMVno1G75nmr8PPT/W1ftBYAADvt3t4LL/
         EdxbfpWkVrQ79socDsbJLBmRfAJCjhLcf08nv1r+8z5HBNm+d8cJ0/psg7D6DCcEP3QO
         p5U3Jmfug2JsaBQ0jHlhWzApkDE+QE/7mwNVEZ12PnnANH3xqx0S1IbBuk10BDfSyiE2
         2V0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=crdP2tN+7nK5nK8+EdCmx+ONI5XbzqOYoFu/3nqOihQ=;
        b=aoz0ZAqMvovd04WcVSXkkI4HF+ireEdPJRJE8pcxbZCeNWKNAwHpto8+S3wM1TG+dw
         kNdV8jNHMkf1MDdoZSyWD0ZerZSoxkx+Fwt8LSSQNWEEm2Pum6msiAQZfvHEb2vyZT19
         f576L6O7PjL99I2LeXwu+/3K4/Sfl3sqqb+1ThdJkUZSi27DpR6PmH0jReM6Lp6i/XiJ
         noIJCehvwkr74uhpghrs0elqkF+2ES8YYD+dR2KLnv6ErX/4tfIUOz2kYkrUZdNofSBc
         S+YBEbF8A3KnlB5Jxhx2jfoMzHGaafqrFn39iGrkOtMU1FgmnmOpMNctg20i/8gnyNPP
         MvUg==
X-Gm-Message-State: AGi0Pub2cuV70NXrozEX6I3odtWJxmKYn5YKN+YaH+8ZJ24ruhvHp1bL
        NAhGsuYjYKTmsjSjX4GvnCAY3Rhb
X-Google-Smtp-Source: APiQypJvT7t/yFC77G4E81nrRp5dMLZFFcv/Enc7XbA/12fCsRFheVtWkjZnj9onCg3TPAPjvruo5A==
X-Received: by 2002:a62:7c16:: with SMTP id x22mr9680949pfc.267.1589067947319;
        Sat, 09 May 2020 16:45:47 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h13sm5369203pfk.86.2020.05.09.16.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2020 16:45:46 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: loop: Add module soft dependency
Date:   Sat,  9 May 2020 16:45:44 -0700
Message-Id: <20200509234544.17088-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a soft dependency against dsa_loop_bdinfo.ko which sets up the
MDIO device registration, since there are no symbols referenced by
dsa_loop.ko, there is no automatic loading of dsa_loop_bdinfo.ko which
is needed.

Fixes: 98cd1552ea27 ("net: dsa: Mock-up driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/dsa_loop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index fdcb70b9f0e4..400207c5c7de 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -360,6 +360,7 @@ static void __exit dsa_loop_exit(void)
 }
 module_exit(dsa_loop_exit);
 
+MODULE_SOFTDEP("pre: dsa_loop_bdinfo");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Florian Fainelli");
 MODULE_DESCRIPTION("DSA loopback driver");
-- 
2.17.1

