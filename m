Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD1B42A4A0
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 14:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236472AbhJLMjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 08:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236464AbhJLMjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 08:39:06 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85876C061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 05:37:04 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id d3so52937359edp.3
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 05:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xeVLhBRyOBspSRG3UIrAmdPV82MS6FstyLV9tssi1Dw=;
        b=RX7Og1JZuqe3FFBh/d5Y+Fctg5kEWRL1VzcgwNZWjsbGK41slNSiB/iK0+nBzp/7Dn
         SjE4OZysJh06VxXD/gAV9yARLUs+J/a9+P/TwTWnibvEx1yTxSD+BvU5J7BaLDvIMPSS
         KoLZA0UJ39DiuXp5uVqI/defqoStJeEkfLGJs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xeVLhBRyOBspSRG3UIrAmdPV82MS6FstyLV9tssi1Dw=;
        b=PIsVXQ7nGPQHnOexqaZir6g+lZ/dtmC28AbBS/DkQr6IVPcfoc7vc2rQUV+wgCoXwM
         YTTcBsrRKAHatwYp7T8mYweLf02O//pc8CZ7Gsoa9bm4segDgW8e/PSFTyBFLek6/l+v
         UZdpDZ7MSWDYbpjUPrt0dm8Oinfrdp9lqrcfd3C2BiwktE46afoy+tzzMJuaqKMG7Tny
         yKwJUO3Bln6CxQUDtTZqXLlNqA4HVQucMv3fyj+1uqvfplMxpBfbXoDA5m0M9/ipE/eV
         AzjY1XEOvkGW+xB0vC/rKxPaA7U//aHXgwdITb1WXQNHJ9eOB9ZpF4QRfSRkakOeOQg8
         QZ4w==
X-Gm-Message-State: AOAM533oy9EycX/E/8+uAQMoCuycm5Al3eyNK2jA2Wm1tRKcSVTKg9hS
        jPNB7TtdW9s7UYTipT2oTou+0w==
X-Google-Smtp-Source: ABdhPJxDHvfwbq9bRjGMaMvVHxJMNedzxgx3Z+TVxfZuJaisWVL0MOe89Btc65I2i6CkhBEE9yNJXQ==
X-Received: by 2002:aa7:db85:: with SMTP id u5mr50211385edt.234.1634042223115;
        Tue, 12 Oct 2021 05:37:03 -0700 (PDT)
Received: from capella.. (27-reverse.bang-olufsen.dk. [193.89.194.27])
        by smtp.gmail.com with ESMTPSA id b5sm5763629edu.13.2021.10.12.05.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 05:37:02 -0700 (PDT)
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
Subject: [PATCH net-next 1/6] ether: add EtherType for proprietary Realtek protocols
Date:   Tue, 12 Oct 2021 14:35:50 +0200
Message-Id: <20211012123557.3547280-2-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211012123557.3547280-1-alvin@pqrs.dk>
References: <20211012123557.3547280-1-alvin@pqrs.dk>
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
---

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

