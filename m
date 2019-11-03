Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2D0CED190
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 04:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbfKCDNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 23:13:38 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37869 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727366AbfKCDNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 23:13:37 -0400
Received: by mail-wm1-f67.google.com with SMTP id q130so12628867wme.2;
        Sat, 02 Nov 2019 20:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1kt8Pfq43g42ZTuGel3KWUrOcZMTLFPWxdZ8oxo4qCo=;
        b=FM8f0LnvjmH/XGjLXTFQiiWB/EtzR9p2kaOHqiNKAzqY8dcMMqZpUa6DT+J+JQfvkU
         SgOYuHSZzbun2RSKqhOK2WR+jy8BNyNDQg/+rcmWnv6j6djzef74vGPYW/ZDCCyg2Lr5
         V+kVG/3G9O5gtVcVLspvqb6t+8S+a4NXGkR77eZj0CCOgTOs/EFkReWTc+hud5VxfGcV
         bMbV1HkEcFkBJ+IQ9K5W9CgDf0xiQ8KWLmAMq4tSvExI16txiq2ljLe5nV21kTrM7NaF
         C0eU+LjtcRzlvuuOEvji7gEGr3GbWw5BsWGxiJrbE/QUQnWO5reE1B4JXGTl186vos9f
         H9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1kt8Pfq43g42ZTuGel3KWUrOcZMTLFPWxdZ8oxo4qCo=;
        b=a/2OoHJrPBFGtDneJOcIg7OAcxAtKwjpRnLZuoaV0ZAihhCFHDtV1MrQf3+o0Iu9xY
         fUuMRngx1//R75zbdJ/oEOI+qzdCjBA9kaN8sVb64mpOlLVqi9jNwwmlIOYCIIdG5whc
         jaH84CBzfxXZEjVLRwx2eKl0yplI9rSoGeuSe3xs4cGB6HqgDGVTaRGQOvVZm0MqduHT
         D49N3y2dOm6GPCOATInkQAXkke1I4pI67DDMz5+xc38uL6OEuTpHs8P98aexYITx2vdI
         /LfltlE4Nq2EghzTxZRLa9hSTfaXZie86GJrO3WptyoAOq/Ahn5VhnhoBWU8dGi6AfvE
         qx5w==
X-Gm-Message-State: APjAAAWikBTND1ya2rHExI1kO4hsTx70isS5UjZ6V7c+GTKjD3YrwZbF
        orIfyIl0i/ByLNr38Fof1Z8+y4w9
X-Google-Smtp-Source: APXvYqzYfG+JKg2xuVbDM8OMxU8T7UcEeqrcbyMbkNKvMQc0nZqYr3tGLtKpju6t0Sdg8a3vEQlNkA==
X-Received: by 2002:a05:600c:2904:: with SMTP id i4mr13221721wmd.113.1572750815493;
        Sat, 02 Nov 2019 20:13:35 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w10sm532649wmd.26.2019.11.02.20.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Nov 2019 20:13:34 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     rmk+kernel@armlinux.org.uk, hkallweit1@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: Fix use after free in dsa_switch_remove()
Date:   Sat,  2 Nov 2019 20:13:26 -0700
Message-Id: <20191103031326.26873-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The order in which the ports are deleted from the list and freed and the
call to dsa_tree_remove_switch() is done is reversed, which leads to an
use after free condition. Reverse the two: first tear down the ports and
switch from the fabric, then free the ports associated with that switch
fabric.

Fixes: 05f294a85235 ("net: dsa: allocate ports on touch")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/dsa2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index ff2fa3950c62..9ef2caa13f27 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -874,12 +874,13 @@ static void dsa_switch_remove(struct dsa_switch *ds)
 	struct dsa_switch_tree *dst = ds->dst;
 	struct dsa_port *dp, *next;
 
+	dsa_tree_teardown(dst);
+
 	list_for_each_entry_safe(dp, next, &dst->ports, list) {
 		list_del(&dp->list);
 		kfree(dp);
 	}
 
-	dsa_tree_teardown(dst);
 	dsa_tree_put(dst);
 }
 
-- 
2.17.1

