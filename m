Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528D13CB9FE
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 17:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240551AbhGPPkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 11:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234039AbhGPPkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 11:40:00 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F85C061762;
        Fri, 16 Jul 2021 08:37:04 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ga14so15774136ejc.6;
        Fri, 16 Jul 2021 08:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ki2zBfnx3wTm6ja5X0xz1vQES5mUBp96RRpteIatjzg=;
        b=vQQq7D2u8FY3LLbHq3YwlnkcjjL1Lk/MMZ41mUIW99c/wETgAeygsAaEw7ifE69C4m
         yTbde2kxkr/SXaS7HBqt1heZ892uTqcWzU/l6TINtLIdY7A/+15O2iiDPHHyBt1bcg8M
         2cE2y32Ay9DaBhbizhOL51qqSIxJLpLdKnRTzUxXknA2yHUWC8drceG33lZuapMyjlfL
         cWUmH0VVU/WBPLgM3jb7APdaH/LRZOattgkyMLM08SCNUQDAGC0z15kBJZ+mMsYACJuw
         DlKMptd0IHu5iEa2a4hOsEj86OPXodlMOLLwOm/m+YvKeLgjrWCK3SsUjJzRFBIPQRVr
         MCMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ki2zBfnx3wTm6ja5X0xz1vQES5mUBp96RRpteIatjzg=;
        b=SWmhWHL4GFiK+oZQJ9bLxEeC41BVL4N060MTaKMQBKEYd/ELAaxzvWK4NZVfTGxoMT
         aT4UvVEU7ET2GW7ajryM7GllH4/bZs5i7Uraqs4OfDsCoAq6Ict1JGsUwJ+XwkAdGwfu
         wysaXjgbDjPiRdMCcvEwSMKqaXV2kh5zxQItU4TSuq8VMsZZ0aaSO3TtsetmbGeuxg7B
         eCr+SB/3eVVWcuoqr8RGE79no+IZ3MJyZdy1cSlxGc0a58uw7vfRMBrJP5XDg+dC3Dd5
         4NPH9GhSEgWeF66IC9oVx7Qhco9cBO8vXrwmYEuvR96kI94YQMY5JGgPsfmFsqgeapJV
         SUWw==
X-Gm-Message-State: AOAM533lb5q/i0Rkz+EERWaw9MUPlREXKqxXWoNA7n9ofLjSPr8bJvl3
        mE2TVj36ljb/gIig9TiwY0Q=
X-Google-Smtp-Source: ABdhPJzrSkE/YKYvdOFRzAd/CUykoOGwPhF2xo9Ms8bUpMhwmjUaf/lpnzZTc9/LikUI2+IrBZv4Vw==
X-Received: by 2002:a17:906:fb12:: with SMTP id lz18mr12657259ejb.324.1626449823335;
        Fri, 16 Jul 2021 08:37:03 -0700 (PDT)
Received: from BLUE.mydomain.example (83-87-52-217.cable.dynamic.v4.ziggo.nl. [83.87.52.217])
        by smtp.googlemail.com with ESMTPSA id n14sm3913973edo.23.2021.07.16.08.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 08:37:02 -0700 (PDT)
From:   ericwouds@gmail.com
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Eric Woudstra <ericwouds@gmail.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt7530 fix mt7530_fdb_write vid missing ivl bit
Date:   Fri, 16 Jul 2021 17:36:39 +0200
Message-Id: <20210716153641.4678-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Woudstra <ericwouds@gmail.com>

According to reference guides mt7530 (mt7620) and mt7531:

NOTE: When IVL is reset, MAC[47:0] and FID[2:0] will be used to 
read/write the address table. When IVL is set, MAC[47:0] and CVID[11:0] 
will be used to read/write the address table.

Since the function only fills in CVID and no FID, we need to set the
IVL bit. The existing code does not set it.

This is a fix for the issue I dropped here earlier:

http://lists.infradead.org/pipermail/linux-mediatek/2021-June/025697.html

With this patch, it is now possible to delete the 'self' fdb entry
manually. However, wifi roaming still has the same issue, the entry
does not get deleted automatically. Wifi roaming also needs a fix
somewhere else to function correctly in combination with vlan.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 drivers/net/dsa/mt7530.c | 1 +
 drivers/net/dsa/mt7530.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 93136f7e6..9e4df35f9 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -366,6 +366,7 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
 	int i;
 
 	reg[1] |= vid & CVID_MASK;
+	reg[1] |= ATA2_IVL;
 	reg[2] |= (aging & AGE_TIMER_MASK) << AGE_TIMER;
 	reg[2] |= (port_mask & PORT_MAP_MASK) << PORT_MAP;
 	/* STATIC_ENT indicate that entry is static wouldn't
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 334d610a5..b19b389ff 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -79,6 +79,7 @@ enum mt753x_bpdu_port_fw {
 #define  STATIC_EMP			0
 #define  STATIC_ENT			3
 #define MT7530_ATA2			0x78
+#define  ATA2_IVL			BIT(15)
 
 /* Register for address table write data */
 #define MT7530_ATWD			0x7c
-- 
2.25.1

