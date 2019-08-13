Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 749C88C3A4
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 23:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfHMV04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 17:26:56 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33842 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbfHMV04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 17:26:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id 31so109142085wrm.1
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 14:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4R2X7XXWZdFS74NFa3W4yH/FB95Qwzq5MGc9raa/nRQ=;
        b=koVuxKFIVjBox/QlETGVe/tzwpOEqlrfXAQ0ceW1l0bPM95Nh6mZ+9m4W8hRRG4Gfx
         maIW60jS6PYmTKVOS8MRONXvHDYkxu7e9g1vV2qllOYiHglJynw/8upbCLcuCa3PLDfG
         f7nZzG08wecb9rGSPYPEJxeVHiO3IL+fe7VlziNV8hsUFBURBo1IYYYjG/dVAocsHYdr
         qZ0KqAMb4Lr2vH/HcSas4JChzQ3wGjsWF9pS5VCwXnmC8O9pkUvpG5btVqRKQZbEkWBP
         IXjuFl0voYop1FpM9fY06hasz3JffjglbuIphkQqdGWanbeMPRhPc2FG+zo1baju8Tka
         o67Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4R2X7XXWZdFS74NFa3W4yH/FB95Qwzq5MGc9raa/nRQ=;
        b=nSofYKbeuZ+GNZk8/DfBdYPQbOZzCThcaQaL0lVQ7DuE6IZVpdwVv8KcUnOhfZyuiT
         m1LZq1cqm7xG2XWiPMRxvbBilgKZ51Ep7w9bLWzjTf4BTGDlVq9W77uGckzdorHf+J9s
         XJJFcobULVAKeBXmX/ujqdU4NFfA6HxFdAhAXLDzI/H255TkRcKwiTkKBjXzbYlrwE35
         vQKbz5g4YgQK4yxrV3xNCKhnHsmqo7/hCn2r+MKifkgAO7CSEtoXlCpV2paMnkSyMNJu
         B+4V1nv4TzstnPLVs1TuNUAfLXwrB/KU02naXNxwtMO4Ji4r7ONE15FOJqSLKgBIHHs2
         sYJA==
X-Gm-Message-State: APjAAAVm+gtQZHm3LO3HPi+WAUGsopn7pBmq4guC7e+sx1SU+RffcSvz
        TSv9y0AooWgvHUcfl56JEHlo2WzX
X-Google-Smtp-Source: APXvYqwH16/txejMJudoCwdspo3aoVuZzj7k4pyN9rTEEP2rnfFJcef9d6LxKhqs9ffxKsN/6ZP3mQ==
X-Received: by 2002:a5d:4d81:: with SMTP id b1mr51444197wru.27.1565731613867;
        Tue, 13 Aug 2019 14:26:53 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e1e2:64b7:ee24:2d4a? (p200300EA8F2F3200E1E264B7EE242D4A.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e1e2:64b7:ee24:2d4a])
        by smtp.googlemail.com with ESMTPSA id a19sm47395683wra.2.2019.08.13.14.26.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 14:26:53 -0700 (PDT)
Subject: [PATCH RFC 1/4] net: phy: swphy: emulate register MII_ESTATUS
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marek Behun <marek.behun@nic.cz>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ac3471d5-deb7-b711-6e74-23f59914758a@gmail.com>
Message-ID: <5e3d85cd-43b6-c581-be99-b6b0cf025771@gmail.com>
Date:   Tue, 13 Aug 2019 23:24:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ac3471d5-deb7-b711-6e74-23f59914758a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the genphy driver binds to a swphy it will call
genphy_read_abilites that will try to read MII_ESTATUS if BMSR_ESTATEN
is set in MII_BMSR. So far this would read the default value 0xffff
and 1000FD and 1000HD are reported as supported just by chance.
Better add explicit support for emulating MII_ESTATUS.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/swphy.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/phy/swphy.c b/drivers/net/phy/swphy.c
index dad22481d..53c214a22 100644
--- a/drivers/net/phy/swphy.c
+++ b/drivers/net/phy/swphy.c
@@ -22,6 +22,7 @@ struct swmii_regs {
 	u16 bmsr;
 	u16 lpa;
 	u16 lpagb;
+	u16 estat;
 };
 
 enum {
@@ -48,6 +49,7 @@ static const struct swmii_regs speed[] = {
 	[SWMII_SPEED_1000] = {
 		.bmsr  = BMSR_ESTATEN,
 		.lpagb = LPA_1000FULL | LPA_1000HALF,
+		.estat = ESTATUS_1000_TFULL | ESTATUS_1000_THALF,
 	},
 };
 
@@ -56,11 +58,13 @@ static const struct swmii_regs duplex[] = {
 		.bmsr  = BMSR_ESTATEN | BMSR_100HALF,
 		.lpa   = LPA_10HALF | LPA_100HALF,
 		.lpagb = LPA_1000HALF,
+		.estat = ESTATUS_1000_THALF,
 	},
 	[SWMII_DUPLEX_FULL] = {
 		.bmsr  = BMSR_ESTATEN | BMSR_100FULL,
 		.lpa   = LPA_10FULL | LPA_100FULL,
 		.lpagb = LPA_1000FULL,
+		.estat = ESTATUS_1000_TFULL,
 	},
 };
 
@@ -112,6 +116,7 @@ int swphy_read_reg(int reg, const struct fixed_phy_status *state)
 {
 	int speed_index, duplex_index;
 	u16 bmsr = BMSR_ANEGCAPABLE;
+	u16 estat = 0;
 	u16 lpagb = 0;
 	u16 lpa = 0;
 
@@ -125,6 +130,7 @@ int swphy_read_reg(int reg, const struct fixed_phy_status *state)
 	duplex_index = state->duplex ? SWMII_DUPLEX_FULL : SWMII_DUPLEX_HALF;
 
 	bmsr |= speed[speed_index].bmsr & duplex[duplex_index].bmsr;
+	estat |= speed[speed_index].estat & duplex[duplex_index].estat;
 
 	if (state->link) {
 		bmsr |= BMSR_LSTATUS | BMSR_ANEGCOMPLETE;
@@ -151,6 +157,8 @@ int swphy_read_reg(int reg, const struct fixed_phy_status *state)
 		return lpa;
 	case MII_STAT1000:
 		return lpagb;
+	case MII_ESTATUS:
+		return estat;
 
 	/*
 	 * We do not support emulating Clause 45 over Clause 22 register
-- 
2.22.0


