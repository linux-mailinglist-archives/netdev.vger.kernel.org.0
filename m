Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE0E94EA5
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 22:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbfHSUBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 16:01:14 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41473 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbfHSUBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 16:01:13 -0400
Received: by mail-qt1-f195.google.com with SMTP id i4so3310037qtj.8
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 13:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R/FI5oIlFJRVUf4lmDq5kF0kP0VOj8za1EyGQpT3edY=;
        b=OWBLtOJ5rOx+sdBQBGgAw25yIM313k1sxiXMzyj/yPdql00cz+PdKtzQWYyUcowC6q
         VG54rBy6LeY3kmrLZUiuG+ywne681b2t1/4Cy/nfTKKDs0e75jtcWsYqcmCk44AMeQUZ
         P9iAI6z05GhH4w1TEX7yJAwY5kYrIAgArIohANUXas7S6NkBMgjcAeEP7btt7nEH7OP0
         YU+T/2Bo9Vn9iSM3kuKiH7vP9EKxN6bRl/T7krY+TJmx0DMmhPu0/+CXXxBRnes+R/25
         A0j/MysMJlQJVMohmxtfmBlI2HnC8LM9H87AHk0x4qakqB5jVFoF+t/FgUuc0VrEiUnu
         uDiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R/FI5oIlFJRVUf4lmDq5kF0kP0VOj8za1EyGQpT3edY=;
        b=PStgZZwDacnsDP19zVHb8YJ6io3AkD2bQL66q6wJalJYyHE6RVaB3D67nC4U0Mb6S9
         LtAi39WhXllwFQL1eYBilqPmatSjsIr1OvRR85uE8U0X/kq15BsKiyTln2aSO6PSggGO
         z0LGVJm+m79f2hoaoE+zLIyjaBMwIEjWmEEpTEVtfV4nKoG8k7sCOuVijI7qRKe0MUd+
         CQ6K0+/wzNV+OlcfRCMH+B7ICs0gJYu93IYtksZUCvbwb+eL/Y3r2rEf6Bn+ZBcFbthQ
         lzoz0doNb0SgmiMnWS4KTAs1BiTCIdFYn1mBiycjZ1l2HaXEq3a0fbEtYhiJLUy4kKn9
         ELig==
X-Gm-Message-State: APjAAAVxYtJGfdXrFLvtrAEkkcjl3Bm4QgEMAwRFSx7QiKmQlFPePZeq
        IM2SvWpAwbvDUD6yOT+czdgquj8WK5E=
X-Google-Smtp-Source: APXvYqxWC7K4DnMZTabIdkd6DzARvMt00D/C747KYUH/BPHYTsmWSQDw2NWa0EJy1AU4Z8PlOlfxdg==
X-Received: by 2002:ad4:4974:: with SMTP id p20mr11614257qvy.29.1566244872447;
        Mon, 19 Aug 2019 13:01:12 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id a67sm7588341qkb.15.2019.08.19.13.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 13:01:11 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     marek.behun@nic.cz, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next v2 4/6] net: dsa: mv88e6xxx: do not change STP state on port disabling
Date:   Mon, 19 Aug 2019 16:00:51 -0400
Message-Id: <20190819200053.21637-5-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190819200053.21637-1-vivien.didelot@gmail.com>
References: <20190819200053.21637-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When disabling a port, that is not for the driver to decide what to
do with the STP state. This is already handled by the DSA layer.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5e557545df6d..27e1622bb03b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2291,9 +2291,6 @@ static void mv88e6xxx_port_disable(struct dsa_switch *ds, int port)
 
 	mv88e6xxx_reg_lock(chip);
 
-	if (mv88e6xxx_port_set_state(chip, port, BR_STATE_DISABLED))
-		dev_err(chip->dev, "failed to disable port\n");
-
 	if (chip->info->ops->serdes_irq_free)
 		chip->info->ops->serdes_irq_free(chip, port);
 
-- 
2.22.0

