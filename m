Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C8B45E7F0
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 07:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358984AbhKZGml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 01:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345573AbhKZGkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 01:40:40 -0500
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16511C06175E;
        Thu, 25 Nov 2021 22:37:28 -0800 (PST)
Received: by mail-vk1-xa36.google.com with SMTP id s17so5328766vka.5;
        Thu, 25 Nov 2021 22:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1xpT3RV99heuUx/ONfQuPNIHfJj6008zQ/R5vdkdv3E=;
        b=FTu97cpX7NvwlAAL5kE7zmY21kEqO65Q8xWojLdoU2HHGbRu93vSmT+lbjbPtODyV8
         kPblNQF8tFJvjMAzJfrQPD4cLNnfhj3zATFOn/F9ZMfwpZECbGgqv8NeBqz7ZrvhX1nn
         uVdDpWORFB4HkzsPt9bTs4B1GqY80vSaqEgd+G2NnjuC4S+xMJXXv1J8DJk3hLITJRzd
         UeiKcDftOuPVSJA5xzBO/nC2LPTK7lCS4yq0pnidogfU8Fdefr4u4glecqN8mlfjzcRV
         nBl4jevsisilJY0Br9aUqkICJmPeBUMtaWhwh1/kx9TyxOPnnH2m4yJZPa0PZ6usdMSj
         KXLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1xpT3RV99heuUx/ONfQuPNIHfJj6008zQ/R5vdkdv3E=;
        b=Lxo62KpHb4twhWJ8BH5HKDi/mQuRX3giTf2/GaZ2MAXeEI2SFAfKoryg/a3aaUqTzY
         /K6T2H+9xT8+TvvieOX4YA9OuPfmzddLkBeaqDRdtJXpEMEsbvgp0v/hUwoVZh2NpDky
         V+IVds62YsFlOXKZwfwInaFP2IzeH7JVcdJABYeU35ANZoFR9ACIsmmG6EpfJeOvNvA6
         fIbuJ58oRRHywD9HhMD014bhjs6jEJCkRdkW8WjvxLMQgVPSSZJKb5QIMqiiC6L4D8Fu
         34O9Lyo8u6z3Z+dvnsTTBZfxdbgvLPLiN6dHkbqDQGa/jaDOElT4XuLactTy+FZm1BnH
         XtNQ==
X-Gm-Message-State: AOAM532Pgr7b9HK8EUZQqfLRMhdo2Bok47mSSKCkcy6fFlmPdH7WyS3y
        Idz1/6dgupPuzxWSUb/eqlKAynE+x94=
X-Google-Smtp-Source: ABdhPJxCCzrNuA97IXzlFBv9MYcGe1BvXV76i3FnSBtG56oib6HP8iawNdBSo8mX00WssKTGITTruw==
X-Received: by 2002:a05:6122:510:: with SMTP id x16mr17928421vko.20.1637908646980;
        Thu, 25 Nov 2021 22:37:26 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id h10sm2989524vsl.34.2021.11.25.22.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 22:37:26 -0800 (PST)
From:   luizluca@gmail.com
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alsi@bang-olufsen.dk,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH] net: dsa: realtek-smi: fix indirect reg access for ports>4
Date:   Fri, 26 Nov 2021 03:36:45 -0300
Message-Id: <20211126063645.19094-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

This switch family can have up to 8 ports {0..7}. However,
INDIRECT_ACCESS_ADDRESS_PHYNUM_MASK was using 2 bits instead of 3,
dropping the most significant bit during indirect register reads and
writes. Reading or writing ports 5, 6, and 7 registers was actually
manipulating, respectively, ports 0, 1, and 2 registers.

rtl8365mb_phy_{read,write} will now returns -EINVAL if phy is greater
than 7.

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

