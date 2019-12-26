Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1795A12A99B
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfLZCQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:16:29 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54152 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfLZCQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:16:26 -0500
Received: by mail-pj1-f66.google.com with SMTP id n96so2747707pjc.3;
        Wed, 25 Dec 2019 18:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ORrC0T+zd9DLceUTGoVwHDDyI0A9+B1dcciiqwr3CkI=;
        b=MDeul3j2rTeg8/ocMh5LD+51TBdlOjAdiXkN/DLjMbBw6dpoI1hM9dwFzcDJTZF0ND
         vYlbM5nMdJ9mIuDtwHh3Sd44NdevsnP6AVsgHvMP5JwuQBdc9R//jAOAnh3Z8Tvx9D1s
         P3ZuyqiRmhVOczH4omjoL3uWctL6Tex53t/V0hwrdlIIXcv18qVGGE8/2ImGDqOVBi/6
         7BOHthHyLZjx9IU1lvuCD68vSFWuP/k1ONV6wI4W7JFWzTJ6BrYepo+2mpNdWVMQusuE
         UDCivAU5V84hcrXwGqX90s8BftWmtkDIXS1pgGGXwtK0P+67ywz0SBr8sPmIX9aQY+qF
         s6UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ORrC0T+zd9DLceUTGoVwHDDyI0A9+B1dcciiqwr3CkI=;
        b=cI38IXP5KhqeUk7vGvMx0uFoDo6HeWPyKIzfULJ1uO2h/ghjp0PIBeI5f+i2rsKB5p
         nBfGQK42NB1HjtzAd0NM+Tv0yMim2ZuwBweZOoKMSxNXCdcQn5LnD3+Ct1ZpKplx6wvs
         2HkJ/ReZFqtOaXHDdJoxok1+9BnTj5tS1ttBHIs/9a8VbPHApnDgWcHo3tQUhAP0kJfw
         MWy2kuhGIa11e/r3NJadcGTNbRtyBkQFflkW4SLd0pjgd4Ir112W6WlrgOMLOeMxMD67
         Y7fzpvLlRns1R987UpVr4Ho2Ef3n5RRduT1HzBTPRshrhBEjtMkNTbe7FGD2XIA0sy0y
         gibA==
X-Gm-Message-State: APjAAAXHjAqq+Y6uf1ZeJiSgScsTQap7FLq+RHWjuc1kOdcuSVWA1Wib
        EALXjiVUTU1hMmMfr7XKI16FvTHy
X-Google-Smtp-Source: APXvYqxjgLj8s9ORx5uA1EiK8vt0reG+VWX5Je4hreQ+z2wsqvDEiKh/9bVZDaCSPAHCc1geKZAiGQ==
X-Received: by 2002:a17:90a:660b:: with SMTP id l11mr16237798pjj.47.1577326585248;
        Wed, 25 Dec 2019 18:16:25 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b65sm31880723pgc.18.2019.12.25.18.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:16:24 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V9 net-next 02/12] net: macvlan: Use the PHY time stamping interface.
Date:   Wed, 25 Dec 2019 18:16:10 -0800
Message-Id: <de05fb4ca400758bac3c3930dec47841f3fcba9b.1577326042.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1577326042.git.richardcochran@gmail.com>
References: <cover.1577326042.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The macvlan layer tests fields of the phy_device in order to determine
whether to invoke the PHY's tsinfo ethtool callback.  This patch
replaces the open coded logic with an invocation of the proper
methods.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/macvlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 05631d97eeb4..d066cf58c926 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1036,8 +1036,8 @@ static int macvlan_ethtool_get_ts_info(struct net_device *dev,
 	const struct ethtool_ops *ops = real_dev->ethtool_ops;
 	struct phy_device *phydev = real_dev->phydev;
 
-	if (phydev && phydev->drv && phydev->drv->ts_info) {
-		 return phydev->drv->ts_info(phydev, info);
+	if (phy_has_tsinfo(phydev)) {
+		return phy_ts_info(phydev, info);
 	} else if (ops->get_ts_info) {
 		return ops->get_ts_info(real_dev, info);
 	} else {
-- 
2.20.1

