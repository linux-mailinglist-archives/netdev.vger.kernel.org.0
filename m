Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B6A15FA83
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgBNX00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:26:26 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33037 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727620AbgBNX0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 18:26:25 -0500
Received: by mail-pl1-f195.google.com with SMTP id ay11so4289086plb.0;
        Fri, 14 Feb 2020 15:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0pOEyVByCTDyiQAMRCIXIloWjhHgR5P3WmjBtTquYqs=;
        b=RZL/rz4CXBf5ZzBp3K/YIh1W0m8bTL6PXTU1Eo5LpAe3p9tBExQLMQv3dlTg0Wcq8H
         +/hvjTzxJfudx+BnNorRe3aTdyqLZ1V68G7cTE37OoeXvIGnEQfTK5A7lwNmQSlgXMwU
         B8zUMb5D6aRMZaphHeVSVuUTC+b41sLlY3d9wGwT/79mUkYnaHDcOC2iZRgSR867aBrc
         DYHbUN7WNjNWw6UuwF7sNPHm3zPQDpiv6Bg+oNTGMpth/swXPxfrAjf8gZ2DEZJY8bn0
         V/00TThhL0fpnx3CA0AeB+ZUghPYb5I8vTep28w0qIayj49BiX9TvydXT/Nc24vfqb8R
         B+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0pOEyVByCTDyiQAMRCIXIloWjhHgR5P3WmjBtTquYqs=;
        b=cA8jAo0I8xe9hgOXw+htaUsVA0TtM0g5kzTOakMkDBqdNSqEtI03y6ZomeLPZKibyp
         ForvDoDY+WWtR/GSFtsLoW61h69tvaJakW3SHv75NIZsaPD0y/+vBPYZZDDnKIT2WJHC
         F4a13SvRw9239rox+vGLLrq+fxXH5026GWkSfU24bRETOyp2dwTPXzoUMUh3OOUqIPzw
         KAtJcFO8oaN4nTqmfUxOPn7VJqsroLw7Zb2iBtecyQReLwL3os70V/qTx0b6H8O/dgS4
         Tp1xWxCSRikd6rqE6g75sPZ+bscVKx+rf4i88K9wgycWJ2qbWwJnO71GWu7pqVF2rtG/
         lyvA==
X-Gm-Message-State: APjAAAXSHg/Ea/NTSCLBjsjemVrGHcKkCTh1FW2zz4o0hsKZq886isyS
        reMUp9e+73sSnWzE3pLNdxOIJpk8
X-Google-Smtp-Source: APXvYqygexJ7s5G2dS2Kbxi2oH/XFfImlAkcA13Q91qz3SyVWhKlIQgnuf624fh9i6GvRqbn0rKKiQ==
X-Received: by 2002:a17:902:8a8d:: with SMTP id p13mr5458323plo.159.1581722784442;
        Fri, 14 Feb 2020 15:26:24 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d4sm7404120pjg.19.2020.02.14.15.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 15:26:23 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net v2] net: dsa: b53: Ensure the default VID is untagged
Date:   Fri, 14 Feb 2020 15:26:19 -0800
Message-Id: <20200214232619.26482-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to ensure that the default VID is untagged otherwise the switch
will be sending tagged frames and the results can be problematic. This
is especially true with b53 switches that use VID 0 as their default
VLAN since VID 0 has a special meaning.

Fixes: fea83353177a ("net: dsa: b53: Fix default VLAN ID")
Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 449a22172e07..1a69286daa8d 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1366,6 +1366,9 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
 
 		b53_get_vlan_entry(dev, vid, vl);
 
+		if (vid == 0 && vid == b53_default_pvid(dev))
+			untagged = true;
+
 		vl->members |= BIT(port);
 		if (untagged && !dsa_is_cpu_port(ds, port))
 			vl->untag |= BIT(port);
-- 
2.17.1

