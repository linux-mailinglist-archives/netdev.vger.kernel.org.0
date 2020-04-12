Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B1B1A5C60
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 05:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgDLDth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 23:49:37 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42174 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbgDLDtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 23:49:36 -0400
Received: by mail-pg1-f193.google.com with SMTP id g6so2933651pgs.9;
        Sat, 11 Apr 2020 20:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AZDILVGrcKvmYChqNYehZ2onRDlNxnDquPgS6AG9YkA=;
        b=A42g95LqGNwYhESYqnGpreIG4EbnfwMkhHJSaQiGA575hBn/pQPQWgMYj0tw7iJFNj
         rN3AssDNxaB4zrqX0Dx6dZgALJ5CPwKGVnaACxGSk7OdopRaUn5y1EATMmvWSrH/t9Uu
         sVajcAdhvlVkgtP93uksvkAJX7WHNPCNpAZX4HJ2MZyn/GV61aY8oUhJMzYtu+YtzdsR
         YhiIaEcgpa2zwdEe00uHupW2c2aOL1AMMJ5FCXAdHzYAPik9ZClWgNqEjKTz9cdCDkW4
         VapuwljUPCa8x0v+nPFyY7MWhscbaCHQW3VsKmqAy3cjpznvKHab6lD8k1J2fOkIefbP
         GupA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AZDILVGrcKvmYChqNYehZ2onRDlNxnDquPgS6AG9YkA=;
        b=UCBiVVAbHCjrr4I21eyaMdjQF6roSUqdXC1Wv10zlP6tDi2Hyia4ESydYAH7CeIlcS
         yYjU6MJu11rL+LZgLscQc0xc+JyV8jDZpKaH7RjJCneOXC1m8M9RgZNatgBLPUKi0pOD
         KXAFgk55o0se4KdU/cdqr1/K7MmVisl6A7BstfYmM5UqOkPtxNjz7JVYOTEN/PeJ+Lzn
         Zl+wtAFW47avWKkK23RfepkppSDOWxBVzYuO58BnvRr5vs3a9v500ERRFzOjRx7zT4V5
         CR6XCAjvuTTno29VbZagTgwOHJLwoXzKcYj3x/EGPVJbDtaANNbGFz6oCdi08BYS+TUK
         /QUQ==
X-Gm-Message-State: AGi0PuYihP0YAh0iapiCzLY/gVHPqAtcY/qxXZALwDK1looWGJHMjZHo
        LhtEc9deX1zFqIbVMPkT6lkuGQ7L
X-Google-Smtp-Source: APiQypLO0t3hZTP5D7PcbbjFaFd4Pb6oPXH1Y5G0rR7sLuG1LsgDyAfFcEQ7c5W57vgyzeVogfVHXw==
X-Received: by 2002:a63:c44b:: with SMTP id m11mr11839604pgg.313.1586663375996;
        Sat, 11 Apr 2020 20:49:35 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id t7sm1841024pfh.143.2020.04.11.20.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2020 20:49:35 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, mripard@kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com (moderated list:ARM/STM32
        ARCHITECTURE),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/STM32
        ARCHITECTURE), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: stmmac: Guard against txfifosz=0
Date:   Sat, 11 Apr 2020 20:49:31 -0700
Message-Id: <20200412034931.9558-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit bfcb813203e619a8960a819bf533ad2a108d8105 ("net: dsa:
configure the MTU for switch ports") my Lamobo R1 platform which uses
an allwinner,sun7i-a20-gmac compatible Ethernet MAC started to fail
by rejecting a MTU of 1536. The reason for that is that the DMA
capabilities are not readable on this version of the IP, and there is
also no 'tx-fifo-depth' property being provided in Device Tree. The
property is documented as optional, and is not provided.

The minimum MTU that the network device accepts is ETH_ZLEN - ETH_HLEN,
so rejecting the new MTU based on the txfifosz value unchecked seems a
bit too heavy handed here.

Fixes: eaf4fac47807 ("net: stmmac: Do not accept invalid MTU values")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e6898fd5223f..9c63ba6f86a9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3993,7 +3993,7 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 	new_mtu = STMMAC_ALIGN(new_mtu);
 
 	/* If condition true, FIFO is too small or MTU too large */
-	if ((txfifosz < new_mtu) || (new_mtu > BUF_SIZE_16KiB))
+	if ((txfifosz < new_mtu && txfifosz) || (new_mtu > BUF_SIZE_16KiB))
 		return -EINVAL;
 
 	dev->mtu = new_mtu;
-- 
2.19.1

