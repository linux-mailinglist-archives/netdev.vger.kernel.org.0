Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B55731A8A9
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhBMAPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbhBMAPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:15:12 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133D7C061788
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:32 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id jj19so2070760ejc.4
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mHiTxxQCRy3CoxamZrClPaDbPoags3ECN42D6FmtLYk=;
        b=BZxn1KQ9K6L0dGefEoHubZUkRSYF63MldvrtmXbZw6rOUQR3GRv/pxi/2gv7BCVkIf
         dlF5euiCP4vgy28g/ygbNF5okP52hdAfT2HcTax/zIc4Aml+YN5ECzcYkt1q+hyeoG2k
         aoXR4iJjBi2GZcrwqBX/psAt08uUPPrsaK01x1kAcB64xxgs8GoXTyEtB+Dx6x5JUTGI
         oKl0q+ROUGXc6Js+k/t9Udcf8tV2l98r5jghjftNXJKtrJJ0d2sL01O2il3lqAyfgzmm
         HDKEnDeL5GlyzQmyf52yjh8PtV9N9XCeidgRtCLDXy4C/XKu20Lajco6+oACSDt9CvqO
         /Zpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mHiTxxQCRy3CoxamZrClPaDbPoags3ECN42D6FmtLYk=;
        b=VLouCsK9oG95txPKtpaigOHeWVJbGpv7dB5cfiukKPGr5n2ReAZJI7oTBw5JoAROiB
         jQhVMytDJIM3zrpJs9Rnm7mkz2JUoke+FTX/FFKmlrUPY+zDsK4CxxE+v7pYrqRtpFdQ
         gOImcseDyRkF/0niIz+jlMRXwLjiapV36Lyqf2l/cOWQTQpqdQpIqdCT+eOQIcCssjps
         yQS8o+/2Vxtlb4aKKPm8TrwrBWufmkg4KerSJYX5DkfC9iTAnPA44ZztMJeRGIKthTww
         Go7zANtCu/xgoswhnmppyVge92bvYxyZv9tg4Sn8WEumXg8r1goaMmeZxZEFgm4b4rIK
         wNBw==
X-Gm-Message-State: AOAM5326EI3gDPmjdyRabKL5unwNRmqPrd5jR1vaIDE04/mO4X3qzlvr
        C9GkClOVoxN8HUrAWH9T2y4=
X-Google-Smtp-Source: ABdhPJzkq5THGjNFPU8jrBiViYWZ+Ig92HYIgPUH3rPxyn+ErIMdJJAM5vjf2oysc/4QwwwoUR+U+g==
X-Received: by 2002:a17:906:7fca:: with SMTP id r10mr5408522ejs.242.1613175270855;
        Fri, 12 Feb 2021 16:14:30 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id c1sm7015606eja.81.2021.02.12.16.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 16:14:30 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 04/12] net: mscc: ocelot: use DIV_ROUND_UP helper in ocelot_port_inject_frame
Date:   Sat, 13 Feb 2021 02:14:04 +0200
Message-Id: <20210213001412.4154051-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213001412.4154051-1-olteanv@gmail.com>
References: <20210213001412.4154051-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This looks a bit nicer than the open-coded "(x + 3) % 4" idiom.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index b5ffe6724eb7..1ab453298a18 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -563,7 +563,7 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 		ocelot_write_rix(ocelot, (__force u32)cpu_to_be32(ifh[i]),
 				 QS_INJ_WR, grp);
 
-	count = (skb->len + 3) / 4;
+	count = DIV_ROUND_UP(skb->len, 4);
 	last = skb->len % 4;
 	for (i = 0; i < count; i++)
 		ocelot_write_rix(ocelot, ((u32 *)skb->data)[i], QS_INJ_WR, grp);
-- 
2.25.1

