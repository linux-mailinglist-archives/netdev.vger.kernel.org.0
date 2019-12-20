Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B25B12820B
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 19:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbfLTSPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 13:15:33 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36244 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727655AbfLTSPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 13:15:31 -0500
Received: by mail-pf1-f194.google.com with SMTP id x184so5646842pfb.3;
        Fri, 20 Dec 2019 10:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TcvRIVL58/Wrslq4wgkwmr+PHpaCP0NUptuhETgxDYo=;
        b=I6Glo38/PmAOS9XrTTevZW1OjhyPjXr19w4bkkfqjMY37e7xyJpnNV/yA4iQSzqpGE
         RiWSPRl1YWbno31Mgef0beUFTcwRUTj33CzAIk1bDcQC8OkBBu0ZdIE83h/VzS63X9rQ
         m4WOCW9fw0pc3IPMTY8yw+f170dCd9xAXvbNHps8C1ls937u3N/1t0gOQcXK9THzXgAo
         H3+udlRH0KfxtsTCjjxBDWsPFcg6NdOBM+mNjgpMOgmiKq2n7x53yXx+ewbm5+4gGnKw
         Zvq+Oy+bf9t/7l9QYnROPLuju4y2LVD1jin9r9Zp8MZoLSLZNeTcPKjgHrb3yg1fv/o0
         L/Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TcvRIVL58/Wrslq4wgkwmr+PHpaCP0NUptuhETgxDYo=;
        b=bASxeKwqw2hxfN0gJnXhC8PomjBNbRMbvO5abeTH8vCwVYwEBJqn+g88iSADhnBQEO
         bShCz7zhaNrGaSx9ZYQaP9k/mkkedJiCilogbiB43vJDMYgpE3V6ueq2j6aEWnJFgAQz
         5M9++TM8/YMoRV+sr4QhzvPx13BaQiyXT3zehzmg/K7Cp4hZ6w3qqUumE+YfcIspWZ/9
         HzYmdvCLY53DLQVR9juZ6Za2cYddFL9y37eb8HCaUyO46xg0+yCOTanDJBYD3yVgVqN0
         lJlFEimKa0DwI30yuz/PdTjI0oMBJF7LxRzrEnsr85/h7x/ZQm5BZHE58OYYk6Rx1mtU
         guoQ==
X-Gm-Message-State: APjAAAWk6jbZZHDo+JTArIKjbArbnXlY8oqA1Y7rEagZvs+/xxkfvZkr
        v3h77Y28vWpWM2QMuld8DjvIVUtI
X-Google-Smtp-Source: APXvYqzM21oFt0KLmGlY9SkgfFMDI5eSiDaUkxLa5WCV1MWgMFwcOw1+4ZkF9PL4UM6pu9vhcQynXg==
X-Received: by 2002:a62:5bc4:: with SMTP id p187mr17871574pfb.255.1576865730579;
        Fri, 20 Dec 2019 10:15:30 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id j28sm11833869pgb.36.2019.12.20.10.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 10:15:29 -0800 (PST)
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
Subject: [PATCH V7 net-next 04/11] net: ethtool: Use the PHY time stamping interface.
Date:   Fri, 20 Dec 2019 10:15:13 -0800
Message-Id: <f4b3781c226e0f7e22e0f69761cacb4b106876fc.1576865315.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576865315.git.richardcochran@gmail.com>
References: <cover.1576865315.git.richardcochran@gmail.com>
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

