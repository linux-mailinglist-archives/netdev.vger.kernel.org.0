Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEED542C3EF
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 16:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbhJMOxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 10:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236509AbhJMOwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 10:52:54 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0159C061749
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 07:50:50 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z20so11335783edc.13
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 07:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nf83J1G4eVCARqMFa6zkKQ6aKu2xkOANkKzZx/058z0=;
        b=cDKwZv5QJ3E2LdK8ZqxSt7nHeShCLZKzQbHBFbMqGt1J9pchxflQflh/jtsjBAvq2/
         ImrnoVkoENXVNa8h5BpN6HHPDT36GDQWpB1GSSTo+XqJHZ13FsZyuLRz17ZqOwm47//X
         t5SSYkqFNpE7rzaieCoqnXhP7GEW06OP6lki4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nf83J1G4eVCARqMFa6zkKQ6aKu2xkOANkKzZx/058z0=;
        b=WygzIGX45hRNUt0yoSWqTLROXCU8yJfDfP/io76pchsW0X9mIweoNsURGZgHrYwwRN
         EmOfHIngpsSdfUvX/gZMKOArBcEHrkig9fHPredtNBd969BxuedAo29t4fCm2g8bg1/6
         UzqPcxw+hiO1rHB+SLXV2XL6XVD4Cc3rgwHlkJzY3zFqQZuw943u28OWzRAYXjnow2wJ
         SUKwwc4CBKrPa49aIFLtsR2jA0mBh0JBPJSAOsQGk/X7o1+N69vcIK1vUPCyaOIbfB13
         8Xn8KCE2gABwVjJhdjblJIhzdBDYDYT4sSm0fCcuRHxWf3PpKCyqTYrnFiFMzTdx7yVU
         t/6w==
X-Gm-Message-State: AOAM533Ll3n4YUkr1hfmSE2jHEvxXmmx0UEDKxx4ho8W1l5wzEvle1/H
        NOqHnGJMHT+qUazf6GHGcVs2cg==
X-Google-Smtp-Source: ABdhPJxuc7MXpenFNuj7PzZE6h84Z4WbIqVVcnPZdsomQsWWGyjvfzawcTk4S/G2dJR2SByzyGu+Gw==
X-Received: by 2002:a50:e004:: with SMTP id e4mr10346425edl.246.1634136649524;
        Wed, 13 Oct 2021 07:50:49 -0700 (PDT)
Received: from capella.. (27-reverse.bang-olufsen.dk. [193.89.194.27])
        by smtp.gmail.com with ESMTPSA id nd22sm7535098ejc.98.2021.10.13.07.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 07:50:49 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 1/6] ether: add EtherType for proprietary Realtek protocols
Date:   Wed, 13 Oct 2021 16:50:33 +0200
Message-Id: <20211013145040.886956-2-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013145040.886956-1-alvin@pqrs.dk>
References: <20211013145040.886956-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Add a new EtherType ETH_P_REALTEK to the if_ether.h uapi header. The
EtherType 0x8899 is used in a number of different protocols from Realtek
Semiconductor Corp [1], so no general assumptions should be made when
trying to decode such packets. Observed protocols include:

  0x1 - Realtek Remote Control protocol [2]
  0x2 - Echo protocol [2]
  0x3 - Loop detection protocol [2]
  0x4 - RTL8365MB 4- and 8-byte switch CPU tag protocols [3]
  0x9 - RTL8306 switch CPU tag protocol [4]
  0xA - RTL8366RB switch CPU tag protocol [4]

[1] https://lore.kernel.org/netdev/CACRpkdYQthFgjwVzHyK3DeYUOdcYyWmdjDPG=Rf9B3VrJ12Rzg@mail.gmail.com/
[2] https://www.wireshark.org/lists/ethereal-dev/200409/msg00090.html
[3] https://lore.kernel.org/netdev/20210822193145.1312668-4-alvin@pqrs.dk/
[4] https://lore.kernel.org/netdev/20200708122537.1341307-2-linus.walleij@linaro.org/

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---

v1 -> v2: no change; collect Reviewed-by from Vladimir

RFC -> v1: this patch is new

 include/uapi/linux/if_ether.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index 5f589c7a8382..5da4ee234e0b 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -86,6 +86,7 @@
 					 * over Ethernet
 					 */
 #define ETH_P_PAE	0x888E		/* Port Access Entity (IEEE 802.1X) */
+#define ETH_P_REALTEK	0x8899          /* Multiple proprietary protocols */
 #define ETH_P_AOE	0x88A2		/* ATA over Ethernet		*/
 #define ETH_P_8021AD	0x88A8          /* 802.1ad Service VLAN		*/
 #define ETH_P_802_EX1	0x88B5		/* 802.1 Local Experimental 1.  */
-- 
2.32.0

