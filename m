Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 305A0100B2F
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 19:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfKRSNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 13:13:30 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42400 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfKRSNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 13:13:30 -0500
Received: by mail-wr1-f68.google.com with SMTP id a15so20669152wrf.9
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 10:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0pa/aJarLITlUmNjpHODH7uAP47qszaGNrqiKWRIgfk=;
        b=u06WBXtYlVUg227K/cBC91PSe2rmvc+TX1937h4zrkQqWYXFCiNk3V1yDSwuVi74Nw
         Awl3jABgR3EPnXWq5cEkozn83P6IVptGZHrAvZnmMcOIJHJzH47X70ExgmLNCpKTw5TZ
         AM86IuWYQDOIPTYLm0kVt4sklIE62mqgRboFowqpGTQLnMinzK5SFRtI7pqaSStxOAe4
         ChOoEc49HB9rBDYFWvZsBXXYhscgfE5rUOjsVvnwteodPkwVE88DGcBi3iGx0W3VRJMS
         zJj9s/PMvIf7rm+OH2z/fHzHozbxJXjGztp3hvQMkN/NP2tR0Nc1oU0t22CTRzXhj62u
         Oxow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0pa/aJarLITlUmNjpHODH7uAP47qszaGNrqiKWRIgfk=;
        b=BKFj2OHta1m07Z0rh0IC5I07wXUfQ0pXudkZnUfXRNCEYdp2zWcyqToWF37uTXHScj
         ml4EteMJW6TAojge9tSbPMVh1z5/HnYegUYoCTfFx912ASZakMwr59jmGUb7gsmIGPqw
         PtFoF7y+UI2mjkNZZLtF+K8O1T8gH1NSdsnI1EaPcSOB4swhvfmu+KfuGjvTCgSe7gUA
         icuprcVd7F6NQev7VLylbdPjUkPaA9UQhOIb3+rKUIoydSiWMLdWjuB4gUu6NsB0S3/o
         wmJtvZJke5dhhl8e1FRfl7GsK4UbEvDJPH6Lfe+M/QDdnM/KNGVfzHaba1adlyf5OlMe
         bmvg==
X-Gm-Message-State: APjAAAXMiEaHx6QU9gJVMYgFKtUIInk63ZkO9ezAeBijzmtaYqg6UZxd
        ugAYkpeMae9UwD2JRjixm+w=
X-Google-Smtp-Source: APXvYqy4qQmUSgNt/HqmxR2DssiXXldA+CQFpyVoyiZwaMds0Gc7jHAWpd3tnMrtwym2DY9Yf+Y5Ng==
X-Received: by 2002:a5d:4445:: with SMTP id x5mr33902526wrr.341.1574100808596;
        Mon, 18 Nov 2019 10:13:28 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id w7sm23341302wru.62.2019.11.18.10.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 10:13:28 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, linux@armlinux.org.uk,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 1/2] net: mscc: ocelot: treat SPEED_UNKNOWN as SPEED_10
Date:   Mon, 18 Nov 2019 20:10:29 +0200
Message-Id: <20191118181030.23921-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191118181030.23921-1-olteanv@gmail.com>
References: <20191118181030.23921-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

One can claim there may be a power consumption gain for ports with no
carrier, but the main benefit of this patch is getting rid of this
warning message when unplugging a cable:

Unsupported PHY speed on port 0: -1

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 90c46ba763d7..7fd85767aa8e 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -413,6 +413,7 @@ void ocelot_adjust_link(struct ocelot *ocelot, int port,
 	int speed, mode = 0;
 
 	switch (phydev->speed) {
+	case SPEED_UNKNOWN:
 	case SPEED_10:
 		speed = OCELOT_SPEED_10;
 		break;
-- 
2.17.1

