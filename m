Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988A645F5B9
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 21:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbhKZUWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 15:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240250AbhKZUUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 15:20:05 -0500
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B65C0613F7
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 12:14:22 -0800 (PST)
Received: by mail-vk1-xa36.google.com with SMTP id 70so6668811vkx.7
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 12:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cnyYg0oNUcfsFuinF9v5fR9llU64pXeaHW/hgjWtFrE=;
        b=mz0tRhfcm5k5sZ+RqGB/sdHZwe+Mw67tp7J2qOtdlZ+RBOGqDE+ACXyv4gdrB38n/j
         IJaEIBBbQaFHbFah9/DHloOv19QL3ImV62s79IA+LmDwDdotKR54G5UbiE4vs92nlhLr
         49rVyM7Tv128bc1XSExZIZ7X1AJfN6fs61IXllOZBoNctkg8UjF+MQwJim4E1tFq/KV1
         ABrg8RamWKq38E7eAQbok68hbaM9jIspwPRlBd4O/0Uyp2KB6OvuTgBsfNxP5kN1yFqp
         N/4esJ05hJurxyNurE5Tv4An8VP86ZzJQcU3R7WO3SzuhJ3MDJ7NTY5irRuMKSeSTKC4
         FDPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cnyYg0oNUcfsFuinF9v5fR9llU64pXeaHW/hgjWtFrE=;
        b=w0EfTQkG+tePdPzNt+dGGclNSrFNOPwTEB8hlhxmnJYtBrqft9m/W9kV2QJnuMzDfm
         cbOOiVObLIGbsGcC/dx6z4IOqkO+5my9atKdnTP8N0lqva/hRpd3Ov8l32jzKqv2BUoC
         /JroY62j9cICNhuylGYY+Aa+71V4jGEcWptSQSIEXJQ9CdBvDlWPF7jCSWx1BOn843cx
         4QvgFsM62fB88DfeF3zt8k4csAoCk2ANGxjGmxeLeG2ri7pJvY73atqnbaGZ6zDGoWL/
         fUM1+Uvj+Z1Yb73LxwiWvWe8GlQyMx4jUk9Pfqj1XtmL2w3nnLS4myZNdEPQOcn2RoZ9
         8UoQ==
X-Gm-Message-State: AOAM532yiIMc+VMD7YRPw788mFr1GHYyinqNsbl1WCPA879scirpbZvM
        3hEm+nWOjqxHLmlfrmMoV96psnGnvjw=
X-Google-Smtp-Source: ABdhPJyFM8DxbGrwf5DkHaASFO0KofqNVGSupFkSjn4jTBSKDc+VMrD1jtb0AD7WbP8VtMJWSoeERg==
X-Received: by 2002:a1f:18cb:: with SMTP id 194mr22249085vky.16.1637957660409;
        Fri, 26 Nov 2021 12:14:20 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id 15sm4086766vkj.49.2021.11.26.12.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 12:14:19 -0800 (PST)
From:   luizluca@gmail.com
To:     netdev@vger.kernel.org
Cc:     alsi@bang-olufsen.dk,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net v3] net: dsa: realtek-smi: fix indirect reg access for ports>3
Date:   Fri, 26 Nov 2021 17:13:55 -0300
Message-Id: <20211126201355.5791-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211126081123.32219-1-luizluca@gmail.com>
References: <20211126081123.32219-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

This switch family can have up to 8 UTP ports {0..7}. However,
INDIRECT_ACCESS_ADDRESS_PHYNUM_MASK was using 2 bits instead of 3,
dropping the most significant bit during indirect register reads and
writes. Reading or writing ports 4, 5, 6, and 7 registers was actually
manipulating, respectively, ports 0, 1, 2, and 3 registers.

This is not sufficient but necessary to support any variant with more
than 4 UTP ports, like RTL8367S.

rtl8365mb_phy_{read,write} will now returns -EINVAL if phy is greater
than 7.

Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC")
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/rtl8365mb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8365mb.c b/drivers/net/dsa/rtl8365mb.c
index baaae97283c5..078ca4cd7160 100644
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
@@ -679,6 +680,9 @@ static int rtl8365mb_phy_read(struct realtek_smi *smi, int phy, int regnum)
 	u16 val;
 	int ret;
 
+	if (phy > RTL8365MB_PHYADDRMAX)
+		return -EINVAL;
+
 	if (regnum > RTL8365MB_PHYREGMAX)
 		return -EINVAL;
 
@@ -704,6 +708,9 @@ static int rtl8365mb_phy_write(struct realtek_smi *smi, int phy, int regnum,
 	u32 ocp_addr;
 	int ret;
 
+	if (phy > RTL8365MB_PHYADDRMAX)
+		return -EINVAL;
+
 	if (regnum > RTL8365MB_PHYREGMAX)
 		return -EINVAL;
 
-- 
2.33.1

