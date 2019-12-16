Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C581120EFA
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfLPQNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:13:44 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41282 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfLPQNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:13:35 -0500
Received: by mail-pf1-f193.google.com with SMTP id s18so5832411pfd.8;
        Mon, 16 Dec 2019 08:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/eKB5BFeJfRdmn41SHhLehXOoB64pxGUNe4mkcGImqM=;
        b=Y+3wckfYyMEyn71AnrgOX9btDhXZIFI1TrwAoq32zzQhR69dYkp2m8O8iauPXSgMMQ
         +eVX+X+SOe4ITXq0fsqVPiesdl7/3xRPuH5QlgdC+A6N7zHd9F6gh1eiByz2fiqg919I
         xrN99JmIHiSmIMTpSMwPC3yKbj9537GxCAhQksKaKgz2uB0U6udEMQy+CnqAiPRVa7Ea
         iDa+z2z+CQ6Tgv1lwXO11fzguuau+2xw+E6yogPzbMIELyeWv9sYxyFEylvggw2LGTVo
         LiRPKt3rr9PoX0zXc3uFV9GilSBFyc3YJFrX4Pk+19fZaIqI20hrCHSNQf90ujAkFMql
         R0oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/eKB5BFeJfRdmn41SHhLehXOoB64pxGUNe4mkcGImqM=;
        b=j89LJ9C/2K1Fp0DA68wkB9CZw5e8Wrhr2aSQvXGCTFMfadjlo7PEqdwUBpAQZ72kYN
         1uzx/44L8swtVsEATEuTbLd+9BUeJLnFoUML3FzdDQEJKSr3IGjr+LV/AgtqGlkTJzok
         yc2CKKI4L5Zb3EKOsH+jal/8DS0jAcjrF3U8pTbk6Pv7v7OAMS5bbSOgEPxvRtvMFkXj
         tR3kEceWjlvnagb67/jqk1mDQgXWwq42pp4bGAByssEOGtUN3AJM6bl/I7+aeCp2Emll
         oXWkSuSKqDbxwsleqJSO643/Q5bznRNPe9iNSpppT7iewhVqvwckrPEJ4PO9WYHhF4l9
         0rtQ==
X-Gm-Message-State: APjAAAUjqgl2wQyIGfwgtP5dqmjurPA7ouGf9a8oBwxkm7x+NFyftRnK
        /Frp3vdPR2774LiqrJPOQ/uQ+aiL
X-Google-Smtp-Source: APXvYqxd0hCkXnTCFNPhK5iFLebPHDHKqTptX6o/rJkqgMvWx0D4o7rgvmPHqW+YHqqLwx2zFLZzGA==
X-Received: by 2002:a63:5525:: with SMTP id j37mr18920854pgb.180.1576512814454;
        Mon, 16 Dec 2019 08:13:34 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 83sm23478433pgh.12.2019.12.16.08.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 08:13:33 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V6 net-next 04/11] net: ethtool: Use the PHY time stamping interface.
Date:   Mon, 16 Dec 2019 08:13:19 -0800
Message-Id: <b4c9c4aa3dc766fc8cd82ad027a2e639d5d1e168.1576511937.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576511937.git.richardcochran@gmail.com>
References: <cover.1576511937.git.richardcochran@gmail.com>
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

