Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53503CB9A9
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 17:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240842AbhGPPZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 11:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240251AbhGPPZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 11:25:19 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CABDC06175F;
        Fri, 16 Jul 2021 08:22:24 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id t2so13049665edd.13;
        Fri, 16 Jul 2021 08:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N8bkFF5p3b8ynQNRAkxev5NHQlLvryoP4qlYhGqFBjc=;
        b=YYBLC0FKuFQE+AMrZG+egLBpSZ3nXAtpNpXYXUYdi8IpU528hZGQcV7zIn1nKWoh+3
         ECyIhmFYi64mRz+5ITsg1Kq1G4JwxpP/2qxmSwtzbSPTD4WY1ofx6g823TNKblAgbtKD
         Vm3Np+TXmneBi2ovKHlAs3v1iSr6ESk4Y2u3I2DtafYU1AXM+teTsF/yQ975MYxNs1bf
         5eHl72YV5JLHoNuCDW7JQqGN/ZESv3loLUE3Ftd5FgAkf47WQis+YzCBoXzeF6TBbva8
         dtnyDMq1L/yUKka8DECO/5KJ3qyjO/q7LnogwycDjmLkyMkQ0fwTmgdW7355cCVEu+PY
         TB4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N8bkFF5p3b8ynQNRAkxev5NHQlLvryoP4qlYhGqFBjc=;
        b=mdGdYAD0RPVltanxVI01vU2H3vXbsN0uMwO4xx5PJJSF08UR8QrhXubWIdL3gm9Mbz
         gSOIuOTa5mdh6tmLsa45LebLdnbnUPhklQuE7/aS/mNwJ8wYqolG65d1DpFb7aLvxZKe
         IIExsjraQEVFkH/alO3ZhKKbsW6r/LEUPG8CvRdt2s80HPZXpIX+XhXkckN0vkkCo1f9
         3sK3IAKGUr04+sm07uiC8WBZAMOTKfgDxt9r2kPLdz2+2SXgmoxwwDb+F2/ihdpIb/Hm
         G4w86i5BPoJg5vDiJKsz6t4Dq5ySQxalBrIN1Z2jPcdktPFyuxmJZ6jnKsbU1mmYXCyV
         eI3Q==
X-Gm-Message-State: AOAM53217LIrfE7GMs6yBvsvIg5+sEkN2SVWB148cYB6rfNOfegHJIsu
        8zU0DP8F9ntd8yoFDLQoEq0=
X-Google-Smtp-Source: ABdhPJxwoY9sX8skN/GsQiNXCI54N8UYo1l0znh40dUm/vmIQlVyUttGmaINiqSWefaAYlOdseJ/wA==
X-Received: by 2002:a05:6402:b8f:: with SMTP id cf15mr15279163edb.286.1626448943269;
        Fri, 16 Jul 2021 08:22:23 -0700 (PDT)
Received: from BLUE.mydomain.example (83-87-52-217.cable.dynamic.v4.ziggo.nl. [83.87.52.217])
        by smtp.googlemail.com with ESMTPSA id i11sm3876648edu.97.2021.07.16.08.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 08:22:22 -0700 (PDT)
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
Cc:     Eric Woudstra <37153012+ericwoud@users.noreply.github.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt7530 fix mt7530_fdb_write vid missing ivl bit
Date:   Fri, 16 Jul 2021 17:22:11 +0200
Message-Id: <20210716152213.4213-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Woudstra <37153012+ericwoud@users.noreply.github.com>

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

Signed-off-by: Eric Woudstra <37153012+ericwoud@users.noreply.github.com>
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

