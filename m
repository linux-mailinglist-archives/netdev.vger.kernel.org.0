Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF47D198591
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 22:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbgC3Uku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 16:40:50 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35181 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729239AbgC3Ukt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 16:40:49 -0400
Received: by mail-wm1-f68.google.com with SMTP id i19so328053wmb.0
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 13:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qT+47dcAyE4FeqNRbbRmYfLu9VafKPGS/umwRMdzQd8=;
        b=TvWAgqjfGC9/SFkLRXQL/B+1MEeCyMUVQc89SZc6fjJ6VSXZq6ZAJv6FkCAF9xMMMe
         x1MkTTea/WI1a2pEc+qWdgMz0JJoDvvdeqPHUg6oe/F6EswW+oiCCrjk55XfCH0nHP77
         BsKmVnsbx7Tat/n0VHAi5m9g/8vSCrLW4Gtzbcj2Z4BTywS3TF64wcs1r2nzmJ6rVXn6
         9HZTUulRpfUQM3Bpkp4vBIhuF5vczOleldSaP/jKK6Neal208y4z0CMuHHpA4ZWPXlc2
         gvE4lfhRLQV4J/hF+7pknsSIP+kY9a5dbf0xcaw8p/fIyFL86yvH8qSgXPK0aJ5Isaf5
         PCeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qT+47dcAyE4FeqNRbbRmYfLu9VafKPGS/umwRMdzQd8=;
        b=CygDkEKsOaNADh2ko6z0saHr1TzOTZrpP3nS8WArO9bXKGcJSaek2rJE4JMKB3ib2D
         4PsMBgYLCsErFrf9VL6rn7C/u2t4j51tdT/vt/4VZTnpfQw4vnJ5+OPf9XO/1X6Opbx5
         hUezAXHM7qSKYOOcsst8btFIXjArmC4ZRQoAxhOtR66/FAbuziaKZ2ORiahd7V97HRwF
         n8lTKzdV4DoPTckdcyvqtTZIRO+GWl1zKM1azXlLznTgx0YHY58vlhZcmhiK33Rebb/X
         E/xFT4bRt+hB0ibNAR4W53nAt/Ps3FGO7aPO7rh5ab2SI5RoBPrqaj0XWudaK/pQjy08
         0XYw==
X-Gm-Message-State: ANhLgQ3uRLzdIQQxf+oC+Fkiw2okkp1d87jkdvcnB7ex27lmEu+XU2fh
        PyGCW6wmTwua+NZuNR+oL3+cXdYq
X-Google-Smtp-Source: ADFU+vt/lpWUjJ37PCWzoDzdoMmhaELQcKkqpV9FRo2WlDvfrK+zqAuEMlimPv5Ufgo+kwa+8NgIJA==
X-Received: by 2002:a7b:c1da:: with SMTP id a26mr1064524wmj.89.1585600846981;
        Mon, 30 Mar 2020 13:40:46 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o16sm23371109wrs.44.2020.03.30.13.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 13:40:46 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next 3/9] net: dsa: b53: Prevent tagged VLAN on port 7 for 7278
Date:   Mon, 30 Mar 2020 13:40:26 -0700
Message-Id: <20200330204032.26313-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330204032.26313-1-f.fainelli@gmail.com>
References: <20200330204032.26313-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7278, port 7 of the switch connects to the ASP UniMAC which is not
capable of processing VLAN tagged frames. We can still allow the port to
be part of a VLAN, and we may want it to be untagged on egress on that
VLAN because of that limitation.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 5cb678e8b9cd..42c41b091682 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1355,6 +1355,14 @@ int b53_vlan_prepare(struct dsa_switch *ds, int port,
 	if ((is5325(dev) || is5365(dev)) && vlan->vid_begin == 0)
 		return -EOPNOTSUPP;
 
+	/* Port 7 on 7278 connects to the ASP's UniMAC which is not capable of
+	 * receiving VLAN tagged frames at all, we can still allow the port to
+	 * be configured for egress untagged.
+	 */
+	if (dev->chip_id == BCM7278_DEVICE_ID && port == 7 &&
+	    !(vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED))
+		return -EINVAL;
+
 	if (vlan->vid_end > dev->num_vlans)
 		return -ERANGE;
 
-- 
2.17.1

