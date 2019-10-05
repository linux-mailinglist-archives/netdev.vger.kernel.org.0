Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC24CCCFB
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 00:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbfJEWFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 18:05:37 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36266 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfJEWFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 18:05:37 -0400
Received: by mail-pg1-f195.google.com with SMTP id 23so5830462pgk.3;
        Sat, 05 Oct 2019 15:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wMdnRrOTU2CPivpJ8e4AUiay63xgWFU0Eh0sVZPpASc=;
        b=PXyr/deDTtZ/qPQGlH79o3Z72KMrIniG8nTh81X4+1ELiiHKpY923XfzYvuQ1ILrJ9
         Fg0n3qCLNle+CZ5dBkZzy0hJ/+mXn4iHDedomDzdv3bSWV6FWdamZd/Y3rkzKOGLITHX
         N05zD9xRBt/MnqPa3TXPOuYfKWrAupRDcxYFq2pnmuT/h3odOMRxKaWJLcP0coDduKB4
         BuAUWjn8/gXOFjT+6OPdMbOMytpgj7MAEoBqplHwjpd9CBCIzv2wT81CwfxI3O1f1d09
         qoMwN0GFQejMfnF4VnuDgJuC7d0wzm9hRsJP8Ss+DB6n9In3my07WVl2sktDDUGHdL9R
         0C0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wMdnRrOTU2CPivpJ8e4AUiay63xgWFU0Eh0sVZPpASc=;
        b=XtzcAueVfF1UdL8Cdsc9BV/LVnIzfrZOWXajwKR63L02x2VoKvMZVxztYm5VqZlhxr
         St01WqB9wX5wxIPGpp3/nGIO5hfookaa84m1KC0AcznJUcgFuRnEv+uHQcfU0mEduSsr
         mvwRVAv6wx045m3VgO/Vx3jmxMWp8lfwOpe6kT45GLu85WP/T0w6QLOe+WGwizzKlS3k
         s3hkLqzTp3IsHXqrkgVqofXht+nrw0rf18+m1/0Fy2gt+4eErr/J46FKbzWGrEVs6ERF
         2O5A+6au2kqodc/l6wgy4/z4cEUA1KL1I3FkX+S2PVgu5f4x0t/7j6GIL+7638bx4zjg
         Y3LA==
X-Gm-Message-State: APjAAAUbZPPlVwxuk/Sy7FwHr7K9zmeDDzJdg2NzJgGORXZIAXaz9Fsw
        cT5PpsS6Ee1RjCO91h7t+g0EmG8M
X-Google-Smtp-Source: APXvYqx69mBvNIOOPk4tWTJtD+p8MPh8GSYPL7Zx+/tgS+l6/wPsaplXW57K7GEFJZv9bmeKvMP/4A==
X-Received: by 2002:a63:2006:: with SMTP id g6mr22335071pgg.287.1570313136391;
        Sat, 05 Oct 2019 15:05:36 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 195sm13989120pfz.103.2019.10.05.15.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 15:05:35 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: b53: Do not clear existing mirrored port mask
Date:   Sat,  5 Oct 2019 15:05:18 -0700
Message-Id: <20191005220518.14008-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clearing the existing bitmask of mirrored ports essentially prevents us
from capturing more than one port at any given time. This is clearly
wrong, do not clear the bitmask prior to setting up the new port.

Reported-by: Hubert Feurstein <h.feurstein@gmail.com>
Fixes: ed3af5fd08eb ("net: dsa: b53: Add support for port mirroring")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 526ba2ab66f1..cc3536315eff 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1845,7 +1845,6 @@ int b53_mirror_add(struct dsa_switch *ds, int port,
 		loc = B53_EG_MIR_CTL;
 
 	b53_read16(dev, B53_MGMT_PAGE, loc, &reg);
-	reg &= ~MIRROR_MASK;
 	reg |= BIT(port);
 	b53_write16(dev, B53_MGMT_PAGE, loc, reg);
 
-- 
2.17.1

