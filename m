Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6CEA0A03
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 20:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfH1Sz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 14:55:28 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37616 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfH1Sz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 14:55:28 -0400
Received: by mail-qk1-f195.google.com with SMTP id s14so723476qkm.4
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 11:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8jn8d8Sr8FJm5/vwBvSpAeewGZNyVJk20gWzQv/2P4U=;
        b=Vlec94GczdOPUcafwEUrUVMSKzoM3IhyE2jRApJ27CiSGKIJ8Y7b2zoPI5hAN8qs37
         oGDtlrcz9KH39ECfR/Bz6cy26npjQUAgYxipfBVH1vS8EktMgV1L77dODnFE94D0Bicf
         PAVPEPsbdrpb7/mjaQ1I7E2tygLB/mh/FIkx/brqRoMIRcEVpwYqLBGRTxNFGNTfG9dC
         RB4nPEmmig8x+u5lAPFMnqXojRPkjfdykasy4+nHBCTsqA+J8gDYoIb65Q8AwfP7AAvy
         Wzy974cbceLZf9izy6SGgtvKl4R2OGax8vr8yGvQINqoaulP12q9te4R5uyn0mh0butB
         Hffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8jn8d8Sr8FJm5/vwBvSpAeewGZNyVJk20gWzQv/2P4U=;
        b=bW7VroWQvR2wzQzutsdBsEc4e/Y0n8F71plsIee2JLW75ZB8unhP75hNlRTLaiqn0r
         sW3eZiU0jaESxhLiFa7MO33s+/8c27a0Mlw0Rqv6qAsOqjyKvKbpR6clupFQLR8YYXcm
         6daSgYKSt6AAXyk1MHJ14BQejIbPo6JQRQR4dVKJcEv51nwhIDbT3oBkt59oo0YyTDr1
         otXDdGAuTAq1bPvgSYaoDNSEgEpxONIwk/ROp1TanZ6bON5SsDKfFEaAaRm00MbQ5SvO
         uuJbTr3RntzUXMREcC39nB+X16Zmfan8zZNY8Oe5Ch47RRmkJnHfEGg4Woa1v6euy3vE
         xqXw==
X-Gm-Message-State: APjAAAWhmzAnJ6Qv9UyOavRy+WhsQNwqMYyaOrt0unnCHejt0DUBjJQe
        7DBNLK4PbidgPasfF2tz89Cwiq8b
X-Google-Smtp-Source: APXvYqwNTphTR59FVjMtEXig9ZKq2IFacXkJ3FjEj6wA7t1WQTUC+iCUh7cyEQ5UijUz6g2ytZ9XHg==
X-Received: by 2002:a37:3c4:: with SMTP id 187mr5280654qkd.406.1567018527282;
        Wed, 28 Aug 2019 11:55:27 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id u22sm37684qtq.13.2019.08.28.11.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 11:55:26 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: fix freeing unused SERDES IRQ
Date:   Wed, 28 Aug 2019 14:55:11 -0400
Message-Id: <20190828185511.21956-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now mv88e6xxx does not enable its ports at setup itself and let
the DSA core handle this, unused ports are disabled without being
powered on first. While that is expected, the SERDES powering code
was assuming that a port was already set up before powering it down,
resulting in freeing an unused IRQ. The patch fixes this assumption.

Fixes: b759f528ca3d ("net: dsa: mv88e6xxx: enable SERDES after setup")
Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 6525075f6bd3..c648f9fbfa59 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2070,7 +2070,8 @@ static int mv88e6xxx_serdes_power(struct mv88e6xxx_chip *chip, int port,
 		if (chip->info->ops->serdes_irq_setup)
 			err = chip->info->ops->serdes_irq_setup(chip, port);
 	} else {
-		if (chip->info->ops->serdes_irq_free)
+		if (chip->info->ops->serdes_irq_free &&
+		    chip->ports[port].serdes_irq)
 			chip->info->ops->serdes_irq_free(chip, port);
 
 		err = chip->info->ops->serdes_power(chip, port, false);
-- 
2.23.0

