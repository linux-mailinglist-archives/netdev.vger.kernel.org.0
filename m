Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85CAC91862
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 19:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfHRRgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 13:36:19 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34619 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbfHRRgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 13:36:17 -0400
Received: by mail-qk1-f193.google.com with SMTP id m10so8851100qkk.1
        for <netdev@vger.kernel.org>; Sun, 18 Aug 2019 10:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/UuntiUswigxL/qZS/xre5V6ROUFPHw/WGDSh/miRMw=;
        b=VaZ3kXrSvWZ47wkC3OkpBsbaZIitjLC69qOlqws+5H/JIcqZEg2CIOIGnwqn3guxne
         +NE1GGUHDh6H+ja4EJov80tmtycmz6/ZMbrjjbhRHzcUxuYI/h2a7jV4BadXGSrRTtC5
         acGroLH/X2ox32TW6VJdz1zPbLi29aXuK2PtD+vcsUHOF27G8AGcpeNiS5jlCK1ZJYjs
         MtzbDmpm5vPpmCnEHEXt2JmhHGygF39cog+6k01LPP0YD2hpfWRLBgbBqsNW4/zGWKZC
         P216/xWgGI+0SjUeRLpX37D4d6Hvztj9XO088Y2DP7bVYYa0WqUOs8JcGLKLbA42oZcd
         Etww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/UuntiUswigxL/qZS/xre5V6ROUFPHw/WGDSh/miRMw=;
        b=pdygE+EbU2Gb5S42iehbqVp+efIUOqAB/NZKBkfyKXBAYSpnA8sL/Jsg+YY7sUDwlb
         //AMKQ8jO51qPa1C4/xmCEpkupNLmKJpAbmzePGJ1/QV4xK55r7wAFDZjPPzCce0IxGp
         AkNTNOfExCDLc/GAQ+FI3dh/856I7nJbU+X20JGQNWosbgu/FS5xA1nNjxSFzR8v/mo6
         aj8stWbiKg5b0C+U1xhAe3uCaHapFjwCxpe700nLrQKT7qibg/371zqLV3YvjQ/+d/Nr
         LXF4bwDGNScJHLUECyKJU8BJybATW90mzaefoOb2RgxcmgP/rlaMorOxX+FRZl7ZuocS
         +/3Q==
X-Gm-Message-State: APjAAAUCPAL81PyX+/c9wFwak3GYin25UO3hB8SNrDROOiqVme0aoS9N
        USM5qQmW4kxpdfZrozDMEvd+LTns
X-Google-Smtp-Source: APXvYqy69XMhEt0JCQVp1PX7PVKJI0w8ArLrNROzyHVuIEfn7QRLYl96gRRfO+WYh2rZFkssqhbMkw==
X-Received: by 2002:a37:4cd3:: with SMTP id z202mr17871257qka.203.1566149776715;
        Sun, 18 Aug 2019 10:36:16 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 136sm6182009qkg.96.2019.08.18.10.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2019 10:36:16 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     marek.behun@nic.cz, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 4/6] net: dsa: mv88e6xxx: do not change STP state on port disabling
Date:   Sun, 18 Aug 2019 13:35:46 -0400
Message-Id: <20190818173548.19631-5-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190818173548.19631-1-vivien.didelot@gmail.com>
References: <20190818173548.19631-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When disabling a port, that is not for the driver to decide what to
do with the STP state. This is already handled by the DSA layer.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
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

