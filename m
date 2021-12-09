Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE2246F6BF
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 23:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbhLIW2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 17:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbhLIW2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 17:28:32 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEDEC061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 14:24:58 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id bi37so14775329lfb.5
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 14:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=8/lJUfE2Eb9wUoTdVhk9oEZvVo0vf8+dPRjd5cHmykw=;
        b=lKQIwCFo7oIF5x5xQ5iHYZh8ysqPHvYGuCAFOrnvSILesk1VOgeE0wPOTI7LHNIMUq
         UAgXkWTSg4KjIJj5XAxoNSLW99L2ML7hTDuRJsywKhYzxHKXbui6dnYP0NbAACGnDGqZ
         2vGQkWmfR1HsLmP3lejWkceuPY38L1cbJtZ8c/jeMKQx1cy61h/Ol884nujgDu5o54eU
         ZFfjpZ3kWuKQHUbqM1SQvAw3r/6PlCNtIpU8ZXWjUFcvrSAhKBqtCI5/Izcr1QKEcaBl
         VvCypj8r/F7lv+o3QsLtnKmYAdTT3H5QaG0X0N3Gz0AFeU2y4kErQl0Cld8i2UF03BWU
         1vNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=8/lJUfE2Eb9wUoTdVhk9oEZvVo0vf8+dPRjd5cHmykw=;
        b=JXDJVkw9IxLyp4QTkoM17eCLMmeNy6DRak5kSv1FoOEJx3r99GM1AV4nEDJ6duqEcg
         1kT40GzQbzJ0pjuAPn6fd4k/7g4s9pM4oucK1PtvLzrH1zHpSvbNKimOhyz4wev4Aj3L
         KKXFSBOgwT4xVrakhBgoP+iwo+DBDZpD9mcUbn9sCYBTuKE0l0LKRHPDy10f4ZHLekWe
         bpg5kBzHz3FByb0HPwAE5L2jLt5UkVnMJQ94x+t9Rvz4t7eG62kIMic34WE8+YVwxhgw
         RH4q8jRJ+rjYhUuShcsXDtibgmCYaRF1Vs3VOIK8h01p/w9PRh00AQVhFO+x+Q4h3Iy/
         Cq4Q==
X-Gm-Message-State: AOAM530yQzvfjcx+F+JsX93Ys9rPHtXY3b93+1IJG+ClCygt98XDGq5l
        IPwaoEln9NTLDbZjvLLc4xQkgtYkNJHX+g==
X-Google-Smtp-Source: ABdhPJyO+TRRz4/r2zgcCuSwbUv8z7r0wj0+J7ao7xiohGGNPAAVssje4Y9LRKcK2n931Ju7X/PUKA==
X-Received: by 2002:a05:6512:2ef:: with SMTP id m15mr8839939lfq.268.1639088696853;
        Thu, 09 Dec 2021 14:24:56 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v7sm121355ljd.31.2021.12.09.14.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 14:24:56 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: mv88e6xxx: Add tx fwd offload PVT on intermediate devices
Date:   Thu,  9 Dec 2021 23:24:24 +0100
Message-Id: <20211209222424.124791-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a typical mv88e6xxx switch tree like this:

  CPU
   |    .----.
.--0--. | .--0--.
| sw0 | | | sw1 |
'-1-2-' | '-1-2-'
    '---'

If sw1p{1,2} are added to a bridge that sw0p1 is not a part of, sw0
still needs to add a crosschip PVT entry for the virtual DSA device
assigned to represent the bridge.

Fixes: ce5df6894a57 ("net: dsa: mv88e6xxx: map virtual bridges with forwarding offload in the PVT")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---

Though this is a bugfix, it still targets net-next as it depends on
the recent work done by Vladimir here:

https://lore.kernel.org/netdev/20211206165758.1553882-1-vladimir.oltean@nxp.com/

 drivers/net/dsa/mv88e6xxx/chip.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7fadbf987b23..85f5a35340d7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2522,6 +2522,7 @@ static int mv88e6xxx_crosschip_bridge_join(struct dsa_switch *ds,
 
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_pvt_map(chip, sw_index, port);
+	err = err ? : mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num);
 	mv88e6xxx_reg_unlock(chip);
 
 	return err;
@@ -2537,7 +2538,8 @@ static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
 		return;
 
 	mv88e6xxx_reg_lock(chip);
-	if (mv88e6xxx_pvt_map(chip, sw_index, port))
+	if (mv88e6xxx_pvt_map(chip, sw_index, port) ||
+	    mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num))
 		dev_err(ds->dev, "failed to remap cross-chip Port VLAN\n");
 	mv88e6xxx_reg_unlock(chip);
 }
-- 
2.25.1

