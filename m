Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369403118F7
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhBFCwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbhBFCmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:42:47 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E664C08ECA4
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:34:13 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id s3so10771594edi.7
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mG/+7SuFXmevfrnANGa5Jna6PHbCifVjbjq7yXHqSpE=;
        b=J/+sm7PoHCT+sgGsGKWwK2W/wG0ckNAZqcHZawLkWiiL9jr2heghJkRl4V4cgU7TqQ
         /I5yKbdA/j+wdwaln5/6GChmxHSfnuuwgUOMCSUOOU/1ka23B0iW/tmz26TMiKq23dWH
         uH12yZp/Xv82GLRWkn96TYtR0OxJqC2E/YwYWcTKNtRopTgjAcKFOcD1XJgnkqmeI7Ez
         IZmMEP9iutKzLFuj52aJs9+SYm16PGfw5s76U4dXybt7U1tRIL/Q1aMdF5zG55+oKsrw
         xKSCZ9zNb0ISpr1kl+9PCFECF9I6cnE263oQcWxFPeqE3D3EHa9lZsI2Y6oPmzlEPsTH
         /XsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mG/+7SuFXmevfrnANGa5Jna6PHbCifVjbjq7yXHqSpE=;
        b=JhZRYpPWaBEebZLawti5zl1YyS3usfxeb/6k3nUFKpL+dE45z3gXq6hv901YVvj1tC
         2VbVONqW3T44G7ggIjNNG1B0BgpOErWkPLIG0tqa4eVqWuvL9oNrh55iXxecLYunirsc
         Qe8wrXRdyC4piufKFtqQZJj6eyCAyH8F5fcY20KdyyAddM2xQn6Su6gF57DB5BJUeGmC
         iCnubAJ0U0ZMuTf4WAftWADzaPNxQfJlU9noTQvTmIp7ZUf2zfkny4Ea1UOze13tLwGa
         OeNP13OjCBkCyW0GAU6SiQ4vUIOzNv7TNW7/d24cyrytMgc0GNpLb90Q8NbKZ1oBNbHo
         n7XQ==
X-Gm-Message-State: AOAM5333YU5r13YfkokpIdcEygviDqxYCTtchxQxYVfEykbuYNs4qp7g
        tQ4aNMIZRS0Z7HJqzd6qS24=
X-Google-Smtp-Source: ABdhPJyX85W4tmXDmclm3hIC7wNdK1COeftfwlnKJf2NgG1IkZLmyXc16SjT004hM/uytrAssz4k0w==
X-Received: by 2002:aa7:cd87:: with SMTP id x7mr6002633edv.210.1612564451960;
        Fri, 05 Feb 2021 14:34:11 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t11sm4569992edd.1.2021.02.05.14.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:34:11 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next] net: dsa: allow port mirroring towards foreign interfaces
Date:   Sat,  6 Feb 2021 00:33:55 +0200
Message-Id: <20210205223355.298049-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

To a DSA switch, port mirroring towards a foreign interface is the same
as mirroring towards the CPU port, since all non-DSA interfaces are
reachable through that. Tell the hardware to send the packets to the CPU
port and let the mirred action deal with them in software.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index b0571ab4e5a7..913a4a5e32a9 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -936,19 +936,19 @@ dsa_slave_add_cls_matchall_mirred(struct net_device *dev,
 	if (!act->dev)
 		return -EINVAL;
 
-	if (!dsa_slave_dev_check(act->dev))
-		return -EOPNOTSUPP;
-
 	mall_tc_entry = kzalloc(sizeof(*mall_tc_entry), GFP_KERNEL);
 	if (!mall_tc_entry)
 		return -ENOMEM;
 
+	if (dsa_slave_dev_check(act->dev))
+		to_dp = dsa_slave_to_port(act->dev);
+	else
+		to_dp = dp->cpu_dp;
+
 	mall_tc_entry->cookie = cls->cookie;
 	mall_tc_entry->type = DSA_PORT_MALL_MIRROR;
 	mirror = &mall_tc_entry->mirror;
 
-	to_dp = dsa_slave_to_port(act->dev);
-
 	mirror->to_local_port = to_dp->index;
 	mirror->ingress = ingress;
 
-- 
2.25.1

