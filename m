Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B5D42A342
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbhJLLaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236188AbhJLLaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 07:30:21 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27DCC061745
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 04:28:18 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g10so79053058edj.1
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 04:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=US79hu+z+ZmdLEx+n+35ycCt5zvqCoMc3ZuPWPCa08M=;
        b=bCiELY98sLaojn9ni1TPwcJLqGrrcs3c6I73IRDj87HQ3umlmaTTrk8z8bL6gZFfRJ
         MiBTF8VnwMkjQ4p8Gw+txhBfpewI8btttI3iG/Err+xH0qOYjQtzK4WWlw84yBlZv1nt
         eb8OgeiZ0ZssVcGm0Pl8JtdZCUQO10i0se5k0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=US79hu+z+ZmdLEx+n+35ycCt5zvqCoMc3ZuPWPCa08M=;
        b=7cc85rqPZUUsbgNgLl8hRUVWN7RvQ4/daARFNlK/54LGOJT75MC0GHEFSPKy2MJDYc
         pXRkX+MemBmmJuppVn97zrpyYmfZR1hYcITNbk/NnvdGylc3Tq1YdGQqz4c3H0Wtyw+D
         E2oZGfFkK2HTaKw6V3TXTWodShvOaAE6wVaR7nruZT1w5cv23UhRHQXXpEjBdHWA2Rr3
         q3vp+0gqWA/O6zvV6iywJKp9HUABlpzLvVBdqEMqR/+b3Rky47LHU0A2HKULEh9AaCwH
         XcEd9gtdI9Ts6Ahd8lU8pjEWF+OPh6Vk5zDg3zD7HMh9VCu5+lF3HSM57xA/5cu7x0Gz
         czuQ==
X-Gm-Message-State: AOAM532+L6qF8chrhMtlEdAa1Td40vNL9lzEQpeGN8ldi4NfAZy0L4T1
        amTaOfjHjBBUkalP0b7sjCR2Cg==
X-Google-Smtp-Source: ABdhPJxQ45z4bpotHt+faDAEC4K9YSTTreIpriQ2hOLazabT4yd8gpqWYqX2i8l6lMQxyElfvhHdLA==
X-Received: by 2002:a50:9d8e:: with SMTP id w14mr49589825ede.74.1634038096916;
        Tue, 12 Oct 2021 04:28:16 -0700 (PDT)
Received: from capella.. (27-reverse.bang-olufsen.dk. [193.89.194.27])
        by smtp.gmail.com with ESMTPSA id l5sm4637862ejx.76.2021.10.12.04.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 04:28:16 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: dsa: fix spurious error message when unoffloaded port leaves bridge
Date:   Tue, 12 Oct 2021 13:27:31 +0200
Message-Id: <20211012112730.3429157-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Flip the sign of a return value check, thereby suppressing the following
spurious error:

  port 2 failed to notify DSA_NOTIFIER_BRIDGE_LEAVE: -EOPNOTSUPP

... which is emitted when removing an unoffloaded DSA switch port from a
bridge.

Fixes: d371b7c92d19 ("net: dsa: Unset vlan_filtering when ports leave the bridge")
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 net/dsa/switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 1c797ec8e2c2..6466d0539af9 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -168,7 +168,7 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 		if (extack._msg)
 			dev_err(ds->dev, "port %d: %s\n", info->port,
 				extack._msg);
-		if (err && err != EOPNOTSUPP)
+		if (err && err != -EOPNOTSUPP)
 			return err;
 	}
 
-- 
2.32.0

