Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67AA8128209
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 19:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfLTSPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 13:15:31 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45597 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727666AbfLTSPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 13:15:30 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so5618787pfg.12;
        Fri, 20 Dec 2019 10:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DoQW9BA/1gf5ukcuID84UVgaHHJxMgZVvcdn3G8I6x4=;
        b=c+aTlRc20puuvO2zQ8GREDwWuFb++qG4//Nn6bh6x4bX8DVgvXEpSG31+m4OOXYkuI
         RAiZSTn8z2dv6AuOcn4ZzGQH8z7AVQ/cx7yLh8aCrOv7bNh0TEkEm9ReITgKyBdVoqQS
         8JudKUp29E5EF1T3pDeiifdacZFUqm+cefKMc5Tv44tiy6v9a7RbCu2TUQlmjXDtHRKe
         ORsK3smoCtkLnhfyXDXGbnvzxa4Pfg6sJW+r5+lpcG2f2hAYNhtw9p/v+jkE8hUs5RqN
         YL663gi1yKNkvpr8s28c9Gvn1LE0HcFTcpGeRKwprp+444J4j6EIyLiIN75IDXY9W2Lr
         Zz+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DoQW9BA/1gf5ukcuID84UVgaHHJxMgZVvcdn3G8I6x4=;
        b=fvHHOYlbstalP5r8fFmdr5SnrJO9L5kJ3dl9Iq1HL6IYKDeaAzXOVbtIm1gxpj2q1i
         uuPLL/WhLw5tCRPc4JW/gWcbYFCMfqGmicB16oolDS8CubRp0JPsv3yAcvkWyim26lC+
         ixAaEUmNzZKAfvAtzmardy4wspKqIAM/fQoNqw40ME+vX7bohK3/BdKhnc7rSgVtF2wi
         3KdkZHF81Rk1aQJOaFY2QrNBG36hNHYzjIp8TPwjwErRvPbNfUz9HDHpNxTHdjoR7GiD
         zOoMEQmds6GirSomDGPsqOtCbdntxze5lUSxaCJEvE444oYAQ2b4/0Mn73qwnXsZ22lc
         cVeA==
X-Gm-Message-State: APjAAAXajdA/CFhVtOKRN1fBXiIXP/Y5qw3KRASWplwUt6Q2RO0dPqbQ
        1Y4/pWaiMtd993GUeHDyQrs+NXLh
X-Google-Smtp-Source: APXvYqxllbQmPBr0KoNY/H3fsTYSuEBSuZsVknZvhBdjpvO8+vug1QfrzUByQ8apvNiuh42bCEbtWg==
X-Received: by 2002:a65:48cb:: with SMTP id o11mr16433037pgs.313.1576865728908;
        Fri, 20 Dec 2019 10:15:28 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id j28sm11833869pgb.36.2019.12.20.10.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 10:15:28 -0800 (PST)
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
Subject: [PATCH V7 net-next 03/11] net: vlan: Use the PHY time stamping interface.
Date:   Fri, 20 Dec 2019 10:15:12 -0800
Message-Id: <99795ca57ffa9f5ef8aa49cda730df29dad9822e.1576865315.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576865315.git.richardcochran@gmail.com>
References: <cover.1576865315.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vlan layer tests fields of the phy_device in order to determine
whether to invoke the PHY's tsinfo ethtool callback.  This patch
replaces the open coded logic with an invocation of the proper
methods.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 net/8021q/vlan_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index e5bff5cc6f97..5ff8059837b4 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -646,8 +646,8 @@ static int vlan_ethtool_get_ts_info(struct net_device *dev,
 	const struct ethtool_ops *ops = vlan->real_dev->ethtool_ops;
 	struct phy_device *phydev = vlan->real_dev->phydev;
 
-	if (phydev && phydev->drv && phydev->drv->ts_info) {
-		 return phydev->drv->ts_info(phydev, info);
+	if (phy_has_tsinfo(phydev)) {
+		return phy_ts_info(phydev, info);
 	} else if (ops->get_ts_info) {
 		return ops->get_ts_info(vlan->real_dev, info);
 	} else {
-- 
2.20.1

