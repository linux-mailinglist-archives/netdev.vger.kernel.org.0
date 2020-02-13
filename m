Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB07015CAED
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 20:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgBMTKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 14:10:21 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45028 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbgBMTKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 14:10:21 -0500
Received: by mail-pg1-f194.google.com with SMTP id g3so3477078pgs.11;
        Thu, 13 Feb 2020 11:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=snIqUR+QE2uKworbxIA/qYCXQeKEt8y43OgAWwv7Q2I=;
        b=H9nk8HLzwr4eGcN++cA7WOiFE/aWxpLmRG6LTMNmzOtQythT5lf31PRL+utx5kkwoQ
         oYpQD0vy1cpvgayJ8y8vnwmciPR2i1Aa+yzFJHHsvzpQxCqyTNCT9mll0T+K5xcedOik
         Xb8Lh2gSGJJPi0Nhm2ZOR5TVtL64MgvKrGOm5cO6WJIMK7U9aTmmV+Ssc5EZBAh6M+ID
         ovoDLj28Vno0Qsw6xz/mUZheGP4gBUPduRqa9K4ho/FkounIyFIXqlWgy9+JIznD+ED2
         LXduTccSD19UMuTjbDz0iG6xl4IFtj6vLRrBiCWgYTmdpmDCChvcQzk6Yi+o22O3Utn0
         cQqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=snIqUR+QE2uKworbxIA/qYCXQeKEt8y43OgAWwv7Q2I=;
        b=j2dH3vNnbG8Qiqy6uDpoIHRK/jmM2Lc6besAunkAvP4S+whKxYkpVdbdDbWd7qrLEw
         M5JobKN+SVyW/fEapwdQYGx5ZsdHkWplhbtD/C4Y0Xb+ZS75uDYDiXhF8Z+f7KMrk40b
         XVBxh4M1jG3w/YEQj7CCwpxYbGMe777uGWATEkEtws73+sOCU99601mbEAS5wLaVj9X7
         CbDzi1FUZn9ZecQ7COSvWtVI3MxqIRxKOIk3mzqHRmTtgToZF3BWqvmvYNWvKqvK6RX6
         sa2jo2r+XLMiZoEVFqBeigQGq5XkDH8dNA7bCjnkSfjXFRPFcL8XaEWVtOJVaap1IOul
         WbSw==
X-Gm-Message-State: APjAAAWEIVSvJQz8F9ujPWtugG9iJtf6a6Sa9u/s+Tb6AUiClgCkBQYc
        4sNI/5Zvj5C8GzLJQUSNDHcT9TDB
X-Google-Smtp-Source: APXvYqzfKeSyv/svECtIW+P7QZ1HXaqecMPVPLXlbTR1wKj4sLm4uhCxPEaXg/D3Yol7xxvwuSNT1g==
X-Received: by 2002:a63:3e8f:: with SMTP id l137mr19072237pga.360.1581621020274;
        Thu, 13 Feb 2020 11:10:20 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm3708194pfh.158.2020.02.13.11.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 11:10:19 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: b53: Ensure the default VID is untagged
Date:   Thu, 13 Feb 2020 11:10:15 -0800
Message-Id: <20200213191015.7150-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to ensure that the default VID is untagged otherwise the switch
will be sending frames tagged frames and the results can be problematic.
This is especially true with b53 switches that use VID 0 as their
default VLAN since VID 0 has a special meaning.

Fixes: fea83353177a ("net: dsa: b53: Fix default VLAN ID")
Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 449a22172e07..f25c43b300d4 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1366,6 +1366,9 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
 
 		b53_get_vlan_entry(dev, vid, vl);
 
+		if (vid == b53_default_pvid(dev))
+			untagged = true;
+
 		vl->members |= BIT(port);
 		if (untagged && !dsa_is_cpu_port(ds, port))
 			vl->untag |= BIT(port);
-- 
2.17.1

