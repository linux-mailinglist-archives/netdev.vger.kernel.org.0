Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B60454CBD
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 19:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239819AbhKQSGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 13:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239811AbhKQSGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 13:06:11 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741BCC061570;
        Wed, 17 Nov 2021 10:03:12 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id i12so3406694pfd.6;
        Wed, 17 Nov 2021 10:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ki7oDcer0hanM/3ps/ZmeqDwU/z18POamk7geDjoU+I=;
        b=CzyftHD9anWYfkAlCvClfjigbgbYXlUJKX8yJPB8va5eKzmLEyoSJoHs5memXi+Mj5
         cJpkiA8/s3X7bJF6prk3dPPrhwcFFKr2Vhg5AnNplX89vGaBVe3Z0T3moXacGFWl4vEM
         r6ePF7UzZgo/9+1LNT0gXgZjHQACKAS9PY50cm3W5SxpHV+gPGH4E52f/SRdlNOqcBbs
         ZEVKveShJGEloxDyKQ9PDdGYoIkG+57DrQs9Jc6Cn33Ui4VemYX9KPc6vD+JnG5rsRt9
         zKfksZMai7DEYU2T5TGDo4fCSiPpWMZps8KACNb4/O0X1vozrICY3D0mGSlvlMKp8h/C
         zCyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ki7oDcer0hanM/3ps/ZmeqDwU/z18POamk7geDjoU+I=;
        b=hCM1NgVxv9h+5s0H7TdGua+vy77MmM3Ry7a60am1jWamUFdyIqLlLGXUMfkwCcRhx7
         OkPQzWcBpmHV9hlbXS2uTYr+c/x34aUjQy2hx7ZRkijwWjaJ3g1rRGibvLSzrOFcaqE0
         9PRqSuBKU6MEBGpjTpeEGlQ6MJw7r2Fm8pOiG3yvkBsh5pcBdrIR8lof9W67hqUKumQE
         fHQuSExsonjDsYCbbRL5tbmITOPKXNDBOXHHSC9bvog7T2ERMuyzUspExSSG54NsF/5g
         MujVkATXAf/UiS8pc2qfS+rw4Pobzel0J9Eg4dhXUCIBEcfTjhb/yZsHoMFgHcE6awVT
         rzhA==
X-Gm-Message-State: AOAM5333mrGPFC2OLO6LC1nPNY9Mko9xbGon4jH5DrcQFJvCOvqMXnGg
        bgVmA1owGoUtZUlXoSP2W9D9vMVFi9k=
X-Google-Smtp-Source: ABdhPJxHcZMZwRJ82mGzIrAFp3rFX9tqrLkZi6sheylPGht17RzQ8wYBPJFzMk4ud1w5G28BA2QSkA==
X-Received: by 2002:a63:5401:: with SMTP id i1mr3552650pgb.356.1637172191494;
        Wed, 17 Nov 2021 10:03:11 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z7sm292739pfe.77.2021.11.17.10.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 10:03:10 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org (open list:ETHERNET PHY LIBRARY),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH stable 4.9] net: mdio-mux: fix unbalanced put_device
Date:   Wed, 17 Nov 2021 10:03:08 -0800
Message-Id: <20211117180309.2737514-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Corentin Labbe <clabbe.montjoie@gmail.com>

commit 60f786525032432af1b7d9b8935cb12936244ccd upstream

mdio_mux_uninit() call put_device (unconditionally) because of
of_mdio_find_bus() in mdio_mux_init.
But of_mdio_find_bus is only called if mux_bus is empty.
If mux_bus is set, mdio_mux_uninit will print a "refcount_t: underflow"
trace.

This patch add a get_device in the other branch of "if (mux_bus)".

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Note: this patch did not get any fixes tag, but it does fix issues
introduced by  fdf3b78df4d2 ("mdio: mux: Correct mdio_mux_init error
path issues").

Thanks!

 drivers/net/phy/mdio-mux.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/mdio-mux.c b/drivers/net/phy/mdio-mux.c
index 599ce24c514f..456b64248e5d 100644
--- a/drivers/net/phy/mdio-mux.c
+++ b/drivers/net/phy/mdio-mux.c
@@ -117,6 +117,7 @@ int mdio_mux_init(struct device *dev,
 	} else {
 		parent_bus_node = NULL;
 		parent_bus = mux_bus;
+		get_device(&parent_bus->dev);
 	}
 
 	pb = devm_kzalloc(dev, sizeof(*pb), GFP_KERNEL);
@@ -182,9 +183,7 @@ int mdio_mux_init(struct device *dev,
 
 	devm_kfree(dev, pb);
 err_pb_kz:
-	/* balance the reference of_mdio_find_bus() took */
-	if (!mux_bus)
-		put_device(&parent_bus->dev);
+	put_device(&parent_bus->dev);
 err_parent_bus:
 	of_node_put(parent_bus_node);
 	return ret_val;
@@ -202,7 +201,6 @@ void mdio_mux_uninit(void *mux_handle)
 		cb = cb->next;
 	}
 
-	/* balance the reference of_mdio_find_bus() in mdio_mux_init() took */
 	put_device(&pb->mii_bus->dev);
 }
 EXPORT_SYMBOL_GPL(mdio_mux_uninit);
-- 
2.25.1

