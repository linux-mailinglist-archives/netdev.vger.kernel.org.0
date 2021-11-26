Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D14B45E90E
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 09:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359312AbhKZIS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 03:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345932AbhKZIQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 03:16:26 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C419C061574;
        Fri, 26 Nov 2021 00:13:14 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id b125so5427162vkb.9;
        Fri, 26 Nov 2021 00:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jGr4SQOtI3OKR7URJguRef34t+2i0vrpPA6yb0Sp7wg=;
        b=lL5ABMGDw2KPlAzr0zNHdmvR+f/wSP+8JlCDRXY+8alLFVUNY1zpJMAeLyl3CUbtQ/
         8SNHORpC3PFTJGVzlktPpVvLWBzimxIutr82BZy502Omi48IWV1J8ECVwg+htrAN2kyY
         nUx+7Nu0BiA25KFxuhsdnPoQDXrKJC/JXDpjxokjIuAZQJqVwfHE5uyDCnckYERO25RP
         IvDcTWlsqckD3LCT7bl2Cq6mm60XeVoGtcXXrOHmZOQ4e5UF4wSsC5w+NgZI/Ps2Ps3e
         nFWjavJ7eNurZVYxR6L+2l/e9tCrocvxuxjWpRntZEQF6oEMJj2FupkyAGFRGZOdzz/T
         pEEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jGr4SQOtI3OKR7URJguRef34t+2i0vrpPA6yb0Sp7wg=;
        b=PuKVVwCGCStjznnfbWTyqNPH7nRatjCbMftSrG1c6Pxgt44exqQ8tRB1rg6ME4nee6
         n596DDbcLO65aLC7ZyhFDBvzfiCjVC8y2NRZPRTsgsPg3BY6fygiDloKtbDMf9XoYoAK
         OXNEC0xEIpHiuo5fQ29IRL/V442FV9r0cp0FMWDd6jT8RZuqr7IellqmGiuFRgli0FWk
         C24c9VyQ5nBS7fgrby92vZs1fELbn/0/i34DqDuN9L5Vs25qYe+YwMCEs24Fw5yGGv9+
         Y10esD1JXZIoB1trC3bSo8bT+aHovxkSeH5rLlbB8hYpIFqPwtsglu5KvyEejs7nnXs1
         CyHw==
X-Gm-Message-State: AOAM530OzhA9fWMbqQJv6OSBN+8wJkLIaN2GJu2neGTRQx7clNIi4dJs
        YFqjKdvUVUEhaBNA3pqjIyKKcno2pS4=
X-Google-Smtp-Source: ABdhPJytWfThRfinZNAeMgC9ZghoceJGAe0EgyCtL+tkrVk/LEmxpObnRkJiYt3cGZI6tEqWMzcGog==
X-Received: by 2002:a1f:3807:: with SMTP id f7mr17662328vka.28.1637914393161;
        Fri, 26 Nov 2021 00:13:13 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id r24sm3231509vsn.1.2021.11.26.00.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 00:13:12 -0800 (PST)
From:   luizluca@gmail.com
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alsi@bang-olufsen.dk,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH v2] net: dsa: realtek-smi: fix indirect reg access for ports>3
Date:   Fri, 26 Nov 2021 05:12:52 -0300
Message-Id: <20211126081252.32254-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211126063645.19094-1-luizluca@gmail.com>
References: <20211126063645.19094-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

This switch family can have up to 8 ports {0..7}. However,
INDIRECT_ACCESS_ADDRESS_PHYNUM_MASK was using 2 bits instead of 3,
dropping the most significant bit during indirect register reads and
writes. Reading or writing ports 4, 5, 6, and 7 registers was actually
manipulating, respectively, ports 0, 1, 2, and 3 registers.

rtl8365mb_phy_{read,write} will now returns -EINVAL if phy is greater
than 7.

v2:
- fix affected ports in commit message

Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC")
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/rtl8365mb.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8365mb.c b/drivers/net/dsa/rtl8365mb.c
index baaae97283c5..f4414ac74b61 100644
--- a/drivers/net/dsa/rtl8365mb.c
+++ b/drivers/net/dsa/rtl8365mb.c
@@ -107,6 +107,7 @@
 #define RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC	2112
 
 /* Family-specific data and limits */
+#define RTL8365MB_PHYADDRMAX	7
 #define RTL8365MB_NUM_PHYREGS	32
 #define RTL8365MB_PHYREGMAX	(RTL8365MB_NUM_PHYREGS - 1)
 #define RTL8365MB_MAX_NUM_PORTS	(RTL8365MB_CPU_PORT_NUM_8365MB_VC + 1)
@@ -176,7 +177,7 @@
 #define RTL8365MB_INDIRECT_ACCESS_STATUS_REG			0x1F01
 #define RTL8365MB_INDIRECT_ACCESS_ADDRESS_REG			0x1F02
 #define   RTL8365MB_INDIRECT_ACCESS_ADDRESS_OCPADR_5_1_MASK	GENMASK(4, 0)
-#define   RTL8365MB_INDIRECT_ACCESS_ADDRESS_PHYNUM_MASK		GENMASK(6, 5)
+#define   RTL8365MB_INDIRECT_ACCESS_ADDRESS_PHYNUM_MASK		GENMASK(7, 5)
 #define   RTL8365MB_INDIRECT_ACCESS_ADDRESS_OCPADR_9_6_MASK	GENMASK(11, 8)
 #define   RTL8365MB_PHY_BASE					0x2000
 #define RTL8365MB_INDIRECT_ACCESS_WRITE_DATA_REG		0x1F03
@@ -679,6 +680,8 @@ static int rtl8365mb_phy_read(struct realtek_smi *smi, int phy, int regnum)
 	u16 val;
 	int ret;
 
+	if (phy > RTL8365MB_PHYADDRMAX)
+		return -EINVAL;
 	if (regnum > RTL8365MB_PHYREGMAX)
 		return -EINVAL;
 
@@ -704,6 +707,8 @@ static int rtl8365mb_phy_write(struct realtek_smi *smi, int phy, int regnum,
 	u32 ocp_addr;
 	int ret;
 
+	if (phy > RTL8365MB_PHYADDRMAX)
+		return -EINVAL;
 	if (regnum > RTL8365MB_PHYREGMAX)
 		return -EINVAL;
 
-- 
2.33.1

