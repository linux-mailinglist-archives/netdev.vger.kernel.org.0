Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D157431AE51
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 23:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhBMWjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 17:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbhBMWjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 17:39:04 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1282DC061788
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 14:38:24 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id jj19so5428321ejc.4
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 14:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TKIbHpceU1DnPC7QTpKX8KQCC6z684N0eyQ2c4Qn/H4=;
        b=FM2uHeAGMdClLVAgk264CxbEmpExgOYDdqkxi8c8vujJc7lQQtlnNse+Y9TGeMFgEa
         CsPq8rL0PjqQ/ddZZxugxiRQh82CpOJprH1VTScXZMTBF5crRoSjnbz8Y9TsqE3p6tdh
         PZeAQaWBVKOsxD/ia3daMjbU7iVcQrd86UP22ywQhjklTsKAYJUgbdCujfv5VHSXZlDb
         bv/xZONNWN+lHxrzp/v1I3eY+OeK+SA3AJrnGR96jveD/EOPqiCZUevpyYczg2p8mUu4
         wiBoy6kYRlet5kz6Va0KxFD0VqD2UI3FJO560VLU5uQxUnfs39RY0k4b9UYRC7vgXTOC
         mNMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TKIbHpceU1DnPC7QTpKX8KQCC6z684N0eyQ2c4Qn/H4=;
        b=XuVn94p37z453BP6fW1KOEvKwku4ixOFKNdHklgtQXBP5dkMRghyQyCNlDqSc/WmXD
         XqwaVBBPSi5gblPtH3fyqz/m4o2lB7R63xC58GBupSwgmOHQzpy6MMYUg9f/qvar56dd
         5W2pdwTNTHakpsJ7P2XQN/fo4AA24VhqLE1cpVheyN6hXWpqhcaRKEGqdyLN1SdXLVqh
         Jb302eLhvE/CqhIaY0Y/MBor/5MfhZ/ChHp1WRmfaRcPhtfrr4eaxSYMwvhH3A07dUoK
         YC1gM5jDIW/8mHHQBY1b4UIeuPDgI0OxSkG8ph6/9HSBsSZens3z8JUKllRmlwj8lWGs
         WiFA==
X-Gm-Message-State: AOAM5330Hx6l9A0qkQi3wnC0uOeviQ1yRcIoluEwpgQqFta0CqITnEay
        JLiKDKB3guA91EHpHcHCaZU=
X-Google-Smtp-Source: ABdhPJwbX1veDeGICNubjHDV/RrPIgX1l3v5mrf++2CW7ivjVTdfrnph/1ztf+I+hbiqePwibuVBVg==
X-Received: by 2002:a17:906:2743:: with SMTP id a3mr9236504ejd.378.1613255902777;
        Sat, 13 Feb 2021 14:38:22 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h3sm7662582edw.18.2021.02.13.14.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 14:38:22 -0800 (PST)
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
Subject: [PATCH v2 net-next 04/12] net: mscc: ocelot: use DIV_ROUND_UP helper in ocelot_port_inject_frame
Date:   Sun, 14 Feb 2021 00:37:53 +0200
Message-Id: <20210213223801.1334216-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213223801.1334216-1-olteanv@gmail.com>
References: <20210213223801.1334216-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This looks a bit nicer than the open-coded "(x + 3) % 4" idiom.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

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

