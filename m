Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2011A725A
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 06:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405156AbgDNEQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 00:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405132AbgDNEQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 00:16:41 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803A8C0A3BDC;
        Mon, 13 Apr 2020 21:16:41 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id v5so12678111wrp.12;
        Mon, 13 Apr 2020 21:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8ZHo8nuCU2prFO6a0wHqdAORRc77VESrTV3m8kVENuc=;
        b=h8VLOfONi+HCNEJbMV0g/g0kBmMIUjcMScFOJD8Zz0BrQz5kb0mhJUcHPNvP5qOc6q
         ghhWjmFxqbejR1GXEib0BmzTyZ1wev9phsjESUcuMdf4w+tlZXPseHVEE0DSKDOaUkNQ
         UFJJX8Zni3qqsuKd/8L6W1N7ksJevfK16XdhoHdx1rAkT+cvSkbs7XfPfVPfpScsSLGM
         pgMdo1/NAyhPIw/YlCtNIvhj3gR9y1lj9CIFgXsIPBPtTweyHW4dV0Cx6YxEMkj/pnpy
         Ol3UFX9Y33nEbOl0rverY0optTPbeXAnAry7plOmdo3aL9Xg6kXHphcCm36cngbNsIX8
         +vbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8ZHo8nuCU2prFO6a0wHqdAORRc77VESrTV3m8kVENuc=;
        b=tljC+I2z0aFQ5WmguX63LFCGC+M69u/EP7k/QDUWZTau6tO/2rzcczXQuY4nWm4fKy
         8osieopBeDhGdSSIKH9tjGuugVWRmwoZvWzYXHAqcaA/pVF/bcqtLMhC3E/4yRdaOaNl
         EZ6URM1h0nRdsms04Tm/Kw2SNTZwLREmzo8LaKcxY26bhlTmlR16LBdWL+X5Ip2hE04I
         P3/dKlJVtHwNf6i1Qmq6TYO79HELfLLngvAyPZmtVFOpYrdPv8MCbTEqCgmQd2WDlhV7
         eFso+i8nD7OatooQKchIPA0qrcmz4hn68CLjcGGdwlqyNgn2fWVR3rUMY9TVRuZrv+re
         SMuw==
X-Gm-Message-State: AGi0PuYiNAHv+SF+eRrlnmip+tyvAA/LhROdL/um98JPty+JzYVT9GoG
        YA/b0X8q1hJU4LPIpKWbbhR7nfjv
X-Google-Smtp-Source: APiQypISIynqKF3g83bs883DMXiK0XscB04n4Zx3/7FME9sXDrpR1o5qNeCbFm3FyxBi5jtHUuwu1Q==
X-Received: by 2002:adf:bb94:: with SMTP id q20mr23508423wrg.105.1586837800044;
        Mon, 13 Apr 2020 21:16:40 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n4sm16704471wmi.20.2020.04.13.21.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 21:16:39 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        linux-kernel@vger.kernel.org (open list), davem@davemloft.net,
        kuba@kernel.org
Subject: [PATCH net 1/4] net: dsa: b53: Lookup VID in ARL searches when VLAN is enabled
Date:   Mon, 13 Apr 2020 21:16:27 -0700
Message-Id: <20200414041630.5740-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200414041630.5740-1-f.fainelli@gmail.com>
References: <20200414041630.5740-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When VLAN is enabled, and an ARL search is issued, we also need to
compare the full {MAC,VID} tuple before returning a successful search
result.

Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 68e2381694b9..fa9b9aca7b56 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1505,6 +1505,9 @@ static int b53_arl_read(struct b53_device *dev, u64 mac,
 			continue;
 		if ((mac_vid & ARLTBL_MAC_MASK) != mac)
 			continue;
+		if (dev->vlan_enabled &&
+		    ((mac_vid >> ARLTBL_VID_S) & ARLTBL_VID_MASK) != vid)
+			continue;
 		*idx = i;
 	}
 
-- 
2.17.1

