Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC9F1B1CCF
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 05:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgDUD2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 23:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728345AbgDUD2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 23:28:03 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109A5C061A0F;
        Mon, 20 Apr 2020 20:28:03 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id a8so4170823edv.2;
        Mon, 20 Apr 2020 20:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4ZMzRuAjHXle1eKL+z9RKqBJOHZRk98XiZ1AhmO1964=;
        b=A1+3PuHU5HU9VsfgZkik167p+kdv1QRz5lPfs3o1OlFsmK+EciwtnA/4paUulpKEI4
         AQEOBAJVRAUgI8wa5cPNbLbk/U9xsqUo/ebtBr5xWdHnJu2yev+8+zgTBrhkMrmhd4rT
         iaEHiB90azE5mqnCn5CDYsktHI7i46Xp7J7GPVfT6dgPgN6Z6Zo/a6qdWjTSuViVid3V
         4whXqhf7BnpfumOgVJC0/hyjCu03VlgT/HdN+miNA+JSZZ8Uoh/F2xfBk7Vo+rYVah/l
         7td9IO4KTDTiVOZuw/hS2+JS85n9Sd0+PaM3Ta4cMinA4OWg8AIGp08Fsut4KgRBXCgT
         sNaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4ZMzRuAjHXle1eKL+z9RKqBJOHZRk98XiZ1AhmO1964=;
        b=um8aT48da9Xtb3A5RdKk3PcDkmmefFTpR5psKmQevS+jzyzJw2VmG0v3rqaumJiLBT
         Ix82RerdZy9xEB3dlyRT4elGpQwVnjFNA/65U9v5RnOtUE1n1b8A8GSn6O3kyTXkFH71
         UlfcL++S3BBEtdTQNLMPZH/xwLCBvNTnt4FVx8XnNNg7iOCXT5RU3N+6/X84JsBYc+2/
         qNVVpDQVvxF+9ASiOiG50VtT3JiBLLuikmHVQL5D3a2c2SX7UPqc1Mao5eu5/kJrImXy
         H+UQGjRGNnglxc3On/IABm3w/JrEiNrEv9KWwdBJi5wAIgHoUefn7hN1S4BXPWA908Mu
         EvHQ==
X-Gm-Message-State: AGi0PuY+JMQv0asi1AxG50HDYTpNMYUp6EWYf8Xmr/zwxsYNq7p1fmiV
        J6XIFW2qgKEOimoyYZdlKuQvX9Td
X-Google-Smtp-Source: APiQypJtCaFRTCEUBZ/1GSc+tuVo8GV1Gn4qe+LnB1vE0ntUFI/XfnojSfowGcEGi+scQDpin0Og9A==
X-Received: by 2002:a05:6402:b17:: with SMTP id bm23mr17645499edb.137.1587439681543;
        Mon, 20 Apr 2020 20:28:01 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9sm216836edl.67.2020.04.20.20.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 20:28:00 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org (open list), davem@davemloft.net,
        kuba@kernel.org
Subject: [PATCH net v2 5/5] net: dsa: b53: b53_arl_rw_op() needs to select IVL or SVL
Date:   Mon, 20 Apr 2020 20:26:55 -0700
Message-Id: <20200421032655.5537-6-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200421032655.5537-1-f.fainelli@gmail.com>
References: <20200421032655.5537-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flip the IVL_SVL_SELECT bit correctly based on the VLAN enable status,
the default is to perform Shared VLAN learning instead of Individual
learning.

Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 4 ++++
 drivers/net/dsa/b53/b53_regs.h   | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 8cb41583bbad..c283593bef17 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1474,6 +1474,10 @@ static int b53_arl_rw_op(struct b53_device *dev, unsigned int op)
 		reg |= ARLTBL_RW;
 	else
 		reg &= ~ARLTBL_RW;
+	if (dev->vlan_enabled)
+		reg &= ~ARLTBL_IVL_SVL_SELECT;
+	else
+		reg |= ARLTBL_IVL_SVL_SELECT;
 	b53_write8(dev, B53_ARLIO_PAGE, B53_ARLTBL_RW_CTRL, reg);
 
 	return b53_arl_op_wait(dev);
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index 14f617e9173d..c90985c294a2 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -292,6 +292,7 @@
 /* ARL Table Read/Write Register (8 bit) */
 #define B53_ARLTBL_RW_CTRL		0x00
 #define    ARLTBL_RW			BIT(0)
+#define    ARLTBL_IVL_SVL_SELECT	BIT(6)
 #define    ARLTBL_START_DONE		BIT(7)
 
 /* MAC Address Index Register (48 bit) */
-- 
2.17.1

