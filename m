Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF7930CFE3
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 00:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236409AbhBBXcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 18:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233149AbhBBXb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 18:31:57 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDA8C061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 15:31:17 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id z22so24844854edb.9
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 15:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=khS4MnlKJJOb5IU5cgEdX1KQSRwh5T3JBvy3P2Yj38Q=;
        b=aT/Jnrjr4YxzHqqB040VIzwa0xM6F2u2+Tp6gykSLKSwHgAcFG54qAR0jkHxH2xUZ+
         CKWoJwtWDCfcZULiN4jxpCXzkynD/5WpqHsYcklpfuKTDvfg3Rv+5vIk+qIIeJ8GOh0x
         TLVOYI8iur5wVq4PeF8G9sr1+LBbwY0L3a3pYfV8D1NMy427vgIOegIntXSaWWeUDz4m
         eyV0xV902+78geRdNpDLmaD4vcxLgVckS6O0vadDvszgYJadAJn/MoszTNaf09HT8QuI
         86n9CD4wtOYBjKoKUTHJFojzudQBhQVxPzlDsg2kI8D2Mf6vwZPJeGynde2FlFBUjaff
         ENXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=khS4MnlKJJOb5IU5cgEdX1KQSRwh5T3JBvy3P2Yj38Q=;
        b=hZNO7hANql695sUkEoy8AOtfGKMgyQTEnRTmn38G5hdOf85P7pwtINCfZ7o2omrPuy
         of2trVI3lCKCQtDpd/GaNQ2DjXdw80XDpQCJ+fadRweSjPQUgxLDqBcBZhxi12hZGBbp
         mpgdsWlR4GfNxXBp3LphAMyq3SBTVu9KaEwHkSFbYV1/zU5USykVtMRYg3cVYlGtJ744
         AvCiNMyEmIrRcnKwoRtCJglJYdFPc2c0SA7DPPT7lYLo2X9CBX+8yQtjTK5yRtXzBron
         W1shI4H7+Qi+R0+IrfA8Gv7bRheW/HgfnBIKxDGSC+Dm8UpHhOwoBvwZPL32zYqKlb2j
         FYLg==
X-Gm-Message-State: AOAM532WjN87B0UhQ1S25cUGYD3r/MPexb6AWCOFEarkKbMZRJY8e7j9
        bJ6jjfON5IQe5kKR4T8+8sc=
X-Google-Smtp-Source: ABdhPJzYQLq6dFby/7+gnQlhTxhedLDJ2KW9C454H9F1nH2ucC2UuJhYuEJbC767ZfNHkAQxtJob4Q==
X-Received: by 2002:aa7:cdd5:: with SMTP id h21mr459788edw.106.1612308675991;
        Tue, 02 Feb 2021 15:31:15 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id c18sm87763edu.20.2021.02.02.15.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 15:31:15 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net-next] net: dsa: fix SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING getting ignored
Date:   Wed,  3 Feb 2021 01:31:09 +0200
Message-Id: <20210202233109.1591466-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The bridge emits VLAN filtering events and quite a few others via
switchdev with orig_dev = br->dev. After the blamed commit, these events
started getting ignored.

The point of the patch was to not offload switchdev objects for ports
that didn't go through dsa_port_bridge_join, because the configuration
is unsupported:
- ports that offload a bonding/team interface go through
  dsa_port_bridge_join when that bonding/team interface is later bridged
  with another switch port or LAG
- ports that don't offload LAG don't get notified of the bridge that is
  on top of that LAG.

Sadly, a check is missing, which is that the orig_dev is equal to the
bridge device. This check is compatible with the original intention,
because ports that don't offload bridging because they use a software
LAG don't have dp->bridge_dev set.

On a semi-related note, we should not offload switchdev objects or
populate dp->bridge_dev if the driver doesn't implement .port_bridge_join
either. However there is no regression associated with that, so it can
be done separately.

Fixes: 5696c8aedfcc ("net: dsa: Don't offload port attributes on standalone ports")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 2ce46bb87703..1c4ee741b4b8 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -182,7 +182,15 @@ static inline bool dsa_port_offloads_netdev(struct dsa_port *dp,
 	/* Switchdev offloading can be configured on: */
 
 	if (dev == dp->slave)
-		/* DSA ports directly connected to a bridge. */
+		/* DSA ports directly connected to a bridge, and event
+		 * was emitted for the ports themselves.
+		 */
+		return true;
+
+	if (dp->bridge_dev == dev)
+		/* DSA ports connected to a bridge, and event was emitted
+		 * for the bridge.
+		 */
 		return true;
 
 	if (dp->lag_dev == dev)
-- 
2.25.1

