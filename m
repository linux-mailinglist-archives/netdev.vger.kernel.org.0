Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45819B6665
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 16:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731333AbfIROtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 10:49:04 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40790 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731111AbfIROtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 10:49:03 -0400
Received: by mail-wm1-f68.google.com with SMTP id b24so366224wmj.5;
        Wed, 18 Sep 2019 07:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A0d08PO1mbBAQV27/6jcUxiyHxWp50nHFe2WMLWAri8=;
        b=dlPzyTteJ6zHFjoC6R7dU6FygFyfOMpFCsAjTjpR8alw1LhvrKeTarp2lDiyU2z7xi
         vM2pPiUUs4eAVTgkUe1euTLflbgX6KOTYZ18uipIy2yAB/UVWMaWxNafnCnHHdDHPz4h
         uqKATpAKzmqOPgxTPUJFkTwHW509jlnJwBm5q1zlEBadZCXRMvJgWfzbv10d5sRhqg5c
         ad/PNgaYKwWjv8ImbOPObInM4MB5A9NIvMBPr5GMK5XF0mIqGCDp8v0qcgZMZBL3qkOL
         N1mSTB1yxUrXwsIKZkUV200KAf5AAC3K5Zi/sLg3x//VqxTvLnW8dDLxdQQQD6f/nU1/
         A49w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A0d08PO1mbBAQV27/6jcUxiyHxWp50nHFe2WMLWAri8=;
        b=plj9ud8rxiI2CduquQcfc04BD2U5DDc1vu8y2UcxWUu21oIdEPYQIGi5+Ee2UMZm+Q
         oITDazac1QHe6+GG5E0gtRwUyTztepRr58uz9dGcmzA9+EBkIWyvtpfQvQqSk7gwHjP7
         AbfqHKNl503+mJ9qch3AHXthRdMHmm02eJnLmPqSAZrXuDxde1ao1aOGQnWJYEzq1g61
         25g2dxCp9MHrfzmrr4mgUlYvQGgczzvmVKMZ9bI4AOl/ph+NTkVA72cUFV6yyL7VK95Z
         kV7oTZOUOu+up15Mn7BaFk5JcdooNpkpx92HJAi1nu8trk2sZdHsPrqkT6ujXXB8XFK2
         QruQ==
X-Gm-Message-State: APjAAAUxOySpDKdZWy6A8DEFHfIJz3VUASf+HlJCi8gwmE4GnZgbzo5h
        RxgC4aF8kG2L4r3CsyWyQA070eYyTLM=
X-Google-Smtp-Source: APXvYqyf3LNriMKfasPngh5OIUAdXGxnH1DhEb6bjDuXB562oIJFdbfU58+20+r9ShjHzt8DLQlb9g==
X-Received: by 2002:a1c:9dc1:: with SMTP id g184mr3155278wme.77.1568818142182;
        Wed, 18 Sep 2019 07:49:02 -0700 (PDT)
Received: from bfk-3-vm8-e4.cs.niisi.ras.ru (t109.niisi.ras.ru. [193.232.173.109])
        by smtp.gmail.com with ESMTPSA id 33sm9592203wra.41.2019.09.18.07.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 07:49:01 -0700 (PDT)
From:   Peter Mamonov <pmamonov@gmail.com>
To:     andrew@lunn.ch
Cc:     Peter Mamonov <pmamonov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1] net/phy: fix DP83865 10 Mbps HDX loopback disable function
Date:   Wed, 18 Sep 2019 17:48:25 +0300
Message-Id: <20190918144825.23285-1-pmamonov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918141931.GK9591@lunn.ch>
References: <20190918141931.GK9591@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the DP83865 datasheet "The 10 Mbps HDX loopback can be
disabled in the expanded memory register 0x1C0.1." The driver erroneously
used bit 0 instead of bit 1.

Signed-off-by: Peter Mamonov <pmamonov@gmail.com>
---
 drivers/net/phy/national.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/national.c b/drivers/net/phy/national.c
index 2addf1d3f619..3aa910b3dc89 100644
--- a/drivers/net/phy/national.c
+++ b/drivers/net/phy/national.c
@@ -110,14 +110,17 @@ static void ns_giga_speed_fallback(struct phy_device *phydev, int mode)
 
 static void ns_10_base_t_hdx_loopack(struct phy_device *phydev, int disable)
 {
+	u16 lb_dis = BIT(1);
+
 	if (disable)
-		ns_exp_write(phydev, 0x1c0, ns_exp_read(phydev, 0x1c0) | 1);
+		ns_exp_write(phydev, 0x1c0,
+			     ns_exp_read(phydev, 0x1c0) | lb_dis);
 	else
 		ns_exp_write(phydev, 0x1c0,
-			     ns_exp_read(phydev, 0x1c0) & 0xfffe);
+			     ns_exp_read(phydev, 0x1c0) & ~lb_dis);
 
 	pr_debug("10BASE-T HDX loopback %s\n",
-		 (ns_exp_read(phydev, 0x1c0) & 0x0001) ? "off" : "on");
+		 (ns_exp_read(phydev, 0x1c0) & lb_dis) ? "off" : "on");
 }
 
 static int ns_config_init(struct phy_device *phydev)
-- 
2.23.0

