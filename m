Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890BF312B2C
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 08:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhBHHiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 02:38:09 -0500
Received: from antares.kleine-koenig.org ([94.130.110.236]:45690 "EHLO
        antares.kleine-koenig.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhBHHh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 02:37:58 -0500
Received: by antares.kleine-koenig.org (Postfix, from userid 1000)
        id D6E77AF36FF; Mon,  8 Feb 2021 08:37:16 +0100 (CET)
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To:     Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: [PATCH v2 1/2] mei: bus: simplify mei_cl_device_remove()
Date:   Mon,  8 Feb 2021 08:37:04 +0100
Message-Id: <20210208073705.428185-2-uwe@kleine-koenig.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208073705.428185-1-uwe@kleine-koenig.org>
References: <20210208073705.428185-1-uwe@kleine-koenig.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver core only calls a bus' remove function when there is actually
a driver and a device. So drop the needless check and assign cldrv earlier.

(Side note: The check for cldev being non-NULL is broken anyhow, because
to_mei_cl_device() is a wrapper around container_of() for a member that is
not the first one. So cldev only can become NULL if dev is (void *)0xc
(for archs with 32 bit pointers) or (void *)0x18 (for archs with 64 bit
pointers).)

Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>
---
 drivers/misc/mei/bus.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 2907db260fba..50d617e7467e 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -878,13 +878,9 @@ static int mei_cl_device_probe(struct device *dev)
 static int mei_cl_device_remove(struct device *dev)
 {
 	struct mei_cl_device *cldev = to_mei_cl_device(dev);
-	struct mei_cl_driver *cldrv;
+	struct mei_cl_driver *cldrv = to_mei_cl_driver(dev->driver);
 	int ret = 0;
 
-	if (!cldev || !dev->driver)
-		return 0;
-
-	cldrv = to_mei_cl_driver(dev->driver);
 	if (cldrv->remove)
 		ret = cldrv->remove(cldev);
 
-- 
2.29.2

