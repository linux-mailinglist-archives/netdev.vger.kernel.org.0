Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECDD40D96E
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238957AbhIPMFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238947AbhIPMFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 08:05:33 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE89C061764
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 05:04:12 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id g1so17517833lfj.12
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 05:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tavpQkYuy52OCAShN3NPMI9ZYShoBfhaEMeVmVE/1KY=;
        b=q4C25UGJusCW19Pdj64ThhcZXC5vfuDrZ7zSXxrVqsAJzJk5wbqi4wEwMaeM/0vvNW
         BmokrpXJMxgFe4BhzA2Oy4dbwIcR+ytRpSVydQrPXxx0OlFM0gETqmKDiYTfiNTzTkeF
         dgtBv6F4B05p+90fk2z9QGw53alXLBACbKzv25Htr/LE0uEvSrEfQtvDXsg+USyy+eeq
         tQa4DSQMpPIcYUS9ZH5SVWhoU7Hr7HhBtg5BtjVLi+1D01yLzCsq2GP95BNw+BwAvkSt
         JjbdHc6tD8jqzT+U4E923nPL5cU3hGlVX/jh+gqCSEJn3x7M8hnnujNCzG6uxrEXATIT
         ng2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tavpQkYuy52OCAShN3NPMI9ZYShoBfhaEMeVmVE/1KY=;
        b=rFF4ppYKeYA4koMshOEwbqE5Inp+uTxa5nZ9cfs8VBLkGZttaFZnOiUHQp5FA4EOw7
         8VyPh+idP9V50yqHQ0gPeHqn0BgM3dMkUjNVuFELzDlK8dpUzCfHBXc9C6PRM4SwmF1A
         QulIirNp8uUdowqmgMcqXrXr7A/zoBtCUi1ecd48xqYbt28XIJwv5CojEkjzz4b8aIXi
         Ma0UMPOTVhtJOfqQ6ZC45eXvC7NaPdrsYDQrJgKJZ1DMqDHtXTWy/uQGefnfBKXsorge
         MR6+BXUk04qYjVMXJWSsSYtsnO7xy0dYIVPNSjU2wFh2YK4HGmSC5wGBVmZPnvRgzlvz
         8slg==
X-Gm-Message-State: AOAM533ik4H/zIZcpwYQIzO/2nd2UahM1KLvcs2OyxkcerF+MLVwndBf
        4/JZcXGWNgGCP/GZpxpm84Q=
X-Google-Smtp-Source: ABdhPJzv8hMzTMEzdoWAXEan6debKSfQfFlUSqr0dtebLdfPBHgNGQOFk4cPXXTUpP2175cNXy0CXw==
X-Received: by 2002:a19:6b13:: with SMTP id d19mr3766848lfa.344.1631793850747;
        Thu, 16 Sep 2021 05:04:10 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id h8sm243010lfk.227.2021.09.16.05.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 05:04:10 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next 3/4] net: dsa: b53: Improve flow control setup on BCM5301x
Date:   Thu, 16 Sep 2021 14:03:53 +0200
Message-Id: <20210916120354.20338-4-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210916120354.20338-1-zajec5@gmail.com>
References: <20210916120354.20338-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

According to the Broadcom's reference driver flow control needs to be
enabled for any CPU switch port (5, 7 or 8 - depending on which one is
used). Current code makes it work only for the port 5. Use
dsa_is_cpu_port() which solved that problem.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index ca84e32baca0..13f337a102ba 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1222,7 +1222,7 @@ static void b53_adjust_link(struct dsa_switch *ds, int port,
 		return;
 
 	/* Enable flow control on BCM5301x's CPU port */
-	if (is5301x(dev) && port == dev->cpu_port)
+	if (is5301x(dev) && dsa_is_cpu_port(ds, port))
 		tx_pause = rx_pause = true;
 
 	if (phydev->pause) {
-- 
2.26.2

