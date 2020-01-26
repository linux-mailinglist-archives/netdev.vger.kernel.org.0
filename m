Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88FB4149C96
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 20:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgAZTuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 14:50:12 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45276 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgAZTuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 14:50:12 -0500
Received: by mail-wr1-f66.google.com with SMTP id j42so8360027wrj.12;
        Sun, 26 Jan 2020 11:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IzokdTn8xHJq417mKTUutSBXkWIrdbd8a0vBGM9PALk=;
        b=tUPl+VtrH1Pl/A4cENMw5jkqUIZaLlSp5ydlxs2eEZZYc0n/n4fR4W4bE4nBs2A8pP
         Eq/VlMeWDee0oCrFbAG7gD1v886V1jwQtLuks601G9XeR3ZTk7lNhJ/99ZhkMG+NsXCK
         ysP8CUIZEnJGxYeIU2SZhWv88j2lt91x07GGd8vA24i5BGLLg+H7T0g/QPPrDCwvObEb
         OquqVrA10a9s100NTWjoa/2flZM3aaMSajkhidYsw6WFl98LGMNiH9PJCCyvME/e3z7L
         3OJc5x5ES8uEK01+odOH9ZpOe+YibQtCzJDWkbsFSEuujhaASncos/am4Ad8vsEf0YeT
         U43g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IzokdTn8xHJq417mKTUutSBXkWIrdbd8a0vBGM9PALk=;
        b=P1biF30aLcEtih7TsYISdY4oILC5dZ99p+HxhImf92cSruMW4r6h1M6ncyJjbR5lJZ
         jYY8RW0a8YmdOWE5DuSu4gLuuzcHtcr6m3wl3DeE1FLy1Rde8nLVgCxVaY68b2RDUab8
         5kOsXWczhEd8BI10t5jq4Tfk32yJQxSOssgQFvUrIWg1aNzWJfaJ9+Jc7/UB1qJp3tmk
         BYVGj4Jzbl4KcZea8yxa9IbaiFFtJxqr7DQg9QWaaqMH9lsJIZbUvBnvsF1kzGprZsrK
         BISrGi6Bfu59o6C2DtmvDqRNZMqaFOPhOedgoioclGfQzs3ti6LQWDrzvPPVPvkLYje0
         2lqw==
X-Gm-Message-State: APjAAAVFFKb+asat9bl3SzEElKXlVaDUhDnM1ZMLbAZIsdMAqOqox1GZ
        ZkT+5Ncj9dxqhYpk4JE8suI=
X-Google-Smtp-Source: APXvYqyhEHf2NIuKRy19vEIN59z5o3oawzaNdznPSkQo8rWN9kw2aTBuGC9d37PH10pj80bWiOQUmQ==
X-Received: by 2002:a5d:4b45:: with SMTP id w5mr16918742wrs.224.1580068209319;
        Sun, 26 Jan 2020 11:50:09 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id v22sm15313301wml.11.2020.01.26.11.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jan 2020 11:50:08 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org, devicetree@vger.kernel.org
Cc:     leoyang.li@nxp.com, claudiu.manoil@nxp.com, robh+dt@kernel.org,
        pavel@denx.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH] ARM: dts: ls1021a: Restore MDIO compatible to gianfar
Date:   Sun, 26 Jan 2020 21:49:50 +0200
Message-Id: <20200126194950.31699-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The difference between "fsl,etsec2-mdio" and "gianfar" has to do with
the .get_tbipa function, which calculates the address of the TBIPA
register automatically, if not explicitly specified. [ see
drivers/net/ethernet/freescale/fsl_pq_mdio.c ]. On LS1021A, the TBIPA
register is at offset 0x30 within the port register block, which is what
the "gianfar" method of calculating addresses actually does.

Luckily, the bad "compatible" is inconsequential for ls1021a.dtsi,
because the TBIPA register is explicitly specified via the second "reg"
(<0x0 0x2d10030 0x0 0x4>), so the "get_tbipa" function is dead code.
Nonetheless it's good to restore it to its correct value.

Background discussion:
https://www.spinics.net/lists/stable/msg361156.html

Fixes: c7861adbe37f ("ARM: dts: ls1021: Fix SGMII PCS link remaining down after PHY disconnect")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 arch/arm/boot/dts/ls1021a.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/ls1021a.dtsi b/arch/arm/boot/dts/ls1021a.dtsi
index 2f6977ada447..63d9f4a066e3 100644
--- a/arch/arm/boot/dts/ls1021a.dtsi
+++ b/arch/arm/boot/dts/ls1021a.dtsi
@@ -728,7 +728,7 @@
 		};
 
 		mdio0: mdio@2d24000 {
-			compatible = "fsl,etsec2-mdio";
+			compatible = "gianfar";
 			device_type = "mdio";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -737,7 +737,7 @@
 		};
 
 		mdio1: mdio@2d64000 {
-			compatible = "fsl,etsec2-mdio";
+			compatible = "gianfar";
 			device_type = "mdio";
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.17.1

