Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80C531A662
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 22:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhBLU6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 15:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbhBLU6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 15:58:22 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4F1C06178B;
        Fri, 12 Feb 2021 12:57:38 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id t25so462457pga.2;
        Fri, 12 Feb 2021 12:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QAC/y8sQa5RfLFD743kGq2IsbDwySZBznMp15D5eqJY=;
        b=X9W2nDhAFT8XR+PPkPiuvTuLdH2zSQGnzk5lupJ44NkRCNzW6ieWj3pLUDaCEBM4qc
         S+LEcejNG+1Cpc4v6JnE4x89xZA3sv2afN0Ocs9YTuB8J145lW0+EafVM7uGQTC07Dl4
         XUjsIwaMEjgupXwHUNWPYwbqEYSzprhWfV2u8urqWEWvSL/67WwnUZA+hlMYwr8QTTfN
         CYM71LwSv1f0VpjSE14Ms2OLK7IBCV520Gaoz6zuefcmQ0L/km/oOExJoSUVcDZJgAMA
         0jXixaAU6cTSUJYFzkcFvl3UWbqoFQTMak0zps7BDp9ME1Xt564+hNri5HhhB6zgP13t
         FNUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QAC/y8sQa5RfLFD743kGq2IsbDwySZBznMp15D5eqJY=;
        b=NZCSEVk30ga610LotpCVP03GqUG/F7GTbkoWP5yw9DVI83gNOsu/wmBh+rifktG2ls
         AZP61AQ9DbjPAd/+Eg1hNVYoZVL1+ri9HrbBjwvh8CvOyXOiZQpq8xZmsEmva9IbK10+
         hGngXK+MjCa8zL1/6CyXL3ru64RZ6bFsWzsyjYm6Oqd0RNn3QWyhDlD8pUkXFIryw4x/
         HXR4KePflMF849HXqWKt1Fq2GS3JuXrb5r1FfMeE1GlIq3C+oQspTnl69n55Nu4nD5HJ
         rKrHTApMSeDADn22m4PkZ3NaGlsNm75kTKl6umCjkmEzJ4OVnx3JUwbhm8NJfSTjW8vu
         lG/Q==
X-Gm-Message-State: AOAM531OoR3lsOMxYsdKGrFTW2ZPkGRgw5d7qYA4WOihN/iOqinOGhQl
        Rbx2K/yYt7UPlqUiYrWbJNe9ymoCt1A=
X-Google-Smtp-Source: ABdhPJxIRDOAhPuW8Giqdgbw8KoKpeuSVjezG41t58E5DjxUzk5fUrMPdQigZYjLeHkeLpmxK3ql5w==
X-Received: by 2002:a05:6a00:1342:b029:1ba:5263:63c3 with SMTP id k2-20020a056a001342b02901ba526363c3mr4756322pfu.2.1613163457695;
        Fri, 12 Feb 2021 12:57:37 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a141sm9891628pfa.189.2021.02.12.12.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 12:57:37 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list),
        olteanv@gmail.com, michael@walle.cc
Subject: [PATCH net-next 2/3] net: phy: broadcom: Fix RXC/TXC auto disabling
Date:   Fri, 12 Feb 2021 12:57:20 -0800
Message-Id: <20210212205721.2406849-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212205721.2406849-1-f.fainelli@gmail.com>
References: <20210212205721.2406849-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When support for optionally disabling the TXC was introduced, bit 2 was
used to do that operation but the datasheet for 50610M from 2009 does
not show bit 2 as being defined. Bit 8 is the one that allows automatic
disabling of the RXC/TXC auto disabling during auto power down.

Fixes: 52fae0837153 ("tg3 / broadcom: Optionally disable TXC if no link")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/brcmphy.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index da7bf9dfef5b..3dd8203cf780 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -193,7 +193,7 @@
 #define BCM54XX_SHD_SCR3		0x05
 #define  BCM54XX_SHD_SCR3_DEF_CLK125	0x0001
 #define  BCM54XX_SHD_SCR3_DLLAPD_DIS	0x0002
-#define  BCM54XX_SHD_SCR3_TRDDAPD	0x0004
+#define  BCM54XX_SHD_SCR3_TRDDAPD	0x0100
 
 /* 01010: Auto Power-Down */
 #define BCM54XX_SHD_APD			0x0a
-- 
2.25.1

