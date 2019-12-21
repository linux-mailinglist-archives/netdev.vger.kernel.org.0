Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96127128B1A
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 20:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfLUTgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 14:36:49 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41973 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfLUTgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 14:36:48 -0500
Received: by mail-pl1-f193.google.com with SMTP id bd4so5534161plb.8;
        Sat, 21 Dec 2019 11:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qdiVljbiL8yD+9AexClzPzh6XW5pK8fMUd89Hf0ztvQ=;
        b=JWCyDuteLY7rdO/0kmySTegc3VO54aYSr/KZXA8bCLh0Xqy3ZABzEfW2mS/iMz2cAI
         kOfwPM5IWtqdU/quo5cNwBZMvFqxRCg6F6Ydjc0x3ntRiZfts0Q2HmGTzlEhDbmc6fI9
         BA/B7QSEw+wHVH9jfRZ5KzM5sV8KmswYUkRjmceIHzpbQM+MT8koEw4pIgwRAzfJ4jSc
         rbba8FcXtXaxm0rphcIdVrpVnzqNDXgTzHa3XENFMD5120Hvivt/Ti4gPp+/PnlUhDVb
         RD1u2OP1DXQLngeHiQA/WGYe6ixfkZZ0AfsBJKbgzyi5IcloUN5TMqYG5uXGURBy8ctj
         EmDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qdiVljbiL8yD+9AexClzPzh6XW5pK8fMUd89Hf0ztvQ=;
        b=nes1JDdlnalwHx4sk/rO+We4RUeVWUVLfou3JFAS27JurMBD2ggLJDMLXVCR+HIY3f
         WczFFRZ87hJ+KW7nUErA84KDb1W/RZ/c8QoVnmVCIuk0LrjB+1sBelG4rR2gF69IeHSQ
         fgGMQ2aQ3/z5tgURU94xI2W2/ZMTMru8GUmAmNC4mFEVGKKDHTdYV/IlqTqvWG2ed3dO
         wUbiQBXhKlBEJls7Db81MdiXwsMRlvUMA2vglosS3O/DSiRjbxhkH7vFSSkohqe/vFRB
         b6FPEpJZIipZe2o5Nz/cgujdkwB/4tD45L0ZjIi0LKfwrB6Qw+n3Ht9h+Gm1Lfb3nfML
         xj4w==
X-Gm-Message-State: APjAAAVcyUHDGGkFR+D1oMpx2kNtOI3vDHsf8FJY4WZkWAqSkNZ0i2S4
        DQQyU3ysD/MNCoACvar/7Kcvg1or
X-Google-Smtp-Source: APXvYqyC2g6qvEgsRkqOdN0HiECDlYAABfwx33kVk0U6KryuAIi2gB8Q79TgEF9TecKgf1hBl4+2yg==
X-Received: by 2002:a17:902:724a:: with SMTP id c10mr22890345pll.39.1576957006941;
        Sat, 21 Dec 2019 11:36:46 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id y197sm18512603pfc.79.2019.12.21.11.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 11:36:46 -0800 (PST)
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
Subject: [PATCH V8 net-next 04/12] net: ethtool: Use the PHY time stamping interface.
Date:   Sat, 21 Dec 2019 11:36:30 -0800
Message-Id: <6dbc095ff1744a2ddeecf98912faddab828affd4.1576956342.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576956342.git.richardcochran@gmail.com>
References: <cover.1576956342.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ethtool layer tests fields of the phy_device in order to determine
whether to invoke the PHY's tsinfo ethtool callback.  This patch
replaces the open coded logic with an invocation of the proper
methods.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/ethtool/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index aed2c2cf1623..88f7cddf5a6f 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2096,8 +2096,8 @@ static int ethtool_get_ts_info(struct net_device *dev, void __user *useraddr)
 	memset(&info, 0, sizeof(info));
 	info.cmd = ETHTOOL_GET_TS_INFO;
 
-	if (phydev && phydev->drv && phydev->drv->ts_info) {
-		err = phydev->drv->ts_info(phydev, &info);
+	if (phy_has_tsinfo(phydev)) {
+		err = phy_ts_info(phydev, &info);
 	} else if (ops->get_ts_info) {
 		err = ops->get_ts_info(dev, &info);
 	} else {
-- 
2.20.1

