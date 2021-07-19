Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E523CEDBA
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 22:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386772AbhGSTiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 15:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382997AbhGSRne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 13:43:34 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D654C061574;
        Mon, 19 Jul 2021 11:10:09 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id x17so25224918edd.12;
        Mon, 19 Jul 2021 11:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GTDmJR1iOKfFDErDtsKNCTnZp6PtcbXsQw6WcF7pPvg=;
        b=PslpkDnKg2RGc5dTIe6QuEL/PdAGxOH50++K7jvEb9AsGJdQuVgPVF16udXIHkm3Eh
         RJAGJnEk/SiAeWLydlAUKUXo2LaEKYa343WuDHHxcHAm5v5q993uIppkXag01cLPAKn6
         CoA5HEp9yGZ6xiWQMnMRmicUtM8jzTE2sV0Ug5qhEns+rYT29TVonMfMUlofC6l6rQv0
         N8uQhqJQ6+dYfdH2BsCeeL/x9RjaHesC6jJ+Jicl9bafGk2pQcuNN5IFdNFCOFC65n0o
         s8eshhOUrzf1gKVKFlOeZ27hSBcK333DopwqEJDxN1zEjmNE3Yni2v32gC0iREDkEo6n
         dnjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GTDmJR1iOKfFDErDtsKNCTnZp6PtcbXsQw6WcF7pPvg=;
        b=WpfIYwND6qNhDnD12S3kL6i0hBP59usxUP+sOdgGslvfa6Gk1AlNDZrGLcpLowE9Tg
         6tRtJSQ6ysXasA+mIU4zVvERGjnzcnt0ci9Cuv4nejMJilq/eH3cedOTJB/IpvK4Mbpb
         nOwZS01amEPWjoKwIuVbq4v+mT0F4OZvp51DK+LHIzjBMuzUOJ3eHzU4LLiiisZFfZu/
         NTZTzGyobfxzxWdV2NXCqWm5CPg+FcAiFIFBVpm2D0+Tmq6/HP5jQ1gZ7wpiRSXgRsR/
         b6VfBAsrayjlptShJG0+imlwUeTTccIJZ38g7Mj+EibfFPLrddAe3h5WaELZlyXR+b5D
         4tuw==
X-Gm-Message-State: AOAM533cpj5ism/QsGcBBn4JzYvl5YUbMTzFoT0BA0XM/0DEYNIfp4zL
        4MmGCtKM0elmQi3Nyyy4QZo=
X-Google-Smtp-Source: ABdhPJyBB/iddbcYz2BAUsZkG8o/nGJccjkPG2a5IDIKGpHrQVAsLya06VIBhGkUOwYbpC0eV881ig==
X-Received: by 2002:a05:6402:692:: with SMTP id f18mr36595704edy.327.1626719051135;
        Mon, 19 Jul 2021 11:24:11 -0700 (PDT)
Received: from BLUE.mydomain.example (83-87-52-217.cable.dynamic.v4.ziggo.nl. [83.87.52.217])
        by smtp.googlemail.com with ESMTPSA id i10sm8082141edf.12.2021.07.19.11.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 11:24:10 -0700 (PDT)
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
Subject: [PATCH net] mt7530 mt7530_fdb_write only set ivl bit vid larger than 1
Date:   Mon, 19 Jul 2021 20:23:57 +0200
Message-Id: <20210719182359.5262-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Woudstra <ericwouds@gmail.com>

Fixes my earlier patch which broke vlan unaware bridges.

The IVL bit now only gets set for vid's larger than 1.

Fixes: 11d8d98cbeef ("mt7530 fix mt7530_fdb_write vid missing ivl bit")
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 drivers/net/dsa/mt7530.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 9e4df35f9..69f21b716 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -366,7 +366,8 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
 	int i;
 
 	reg[1] |= vid & CVID_MASK;
-	reg[1] |= ATA2_IVL;
+	if (vid > 1)
+		reg[1] |= ATA2_IVL;
 	reg[2] |= (aging & AGE_TIMER_MASK) << AGE_TIMER;
 	reg[2] |= (port_mask & PORT_MAP_MASK) << PORT_MAP;
 	/* STATIC_ENT indicate that entry is static wouldn't
-- 
2.25.1

