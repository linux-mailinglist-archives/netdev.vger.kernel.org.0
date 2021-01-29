Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EA23082CE
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhA2BBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:01:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbhA2BBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 20:01:12 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD11C06174A
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:31 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id ke15so10523360ejc.12
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uIhnvOwqnwIWxm0SHixgB7elVTNnkA/cKlaoIzV6RwE=;
        b=FfybNu28TcyFPW0u1dyvBTgynAH1fLJz+qiFOk019dLsyXU3IH9rzp7oah7UON7aMa
         tBx7Kx/d/623EUE2VZGlFQ26gM6BQlXmIskh/KOPyU4dDekRjX58ohO6DhX7fhUF23K5
         1IHHQUDLB/2O8HbluYr64kEAP/Sq2n2MCARcQwrpmefymGMnBM/N7p7iAr9RUrMs6tMG
         KU6uFVBKWv5EUE1SAewMyzHSOKuEkF8m6K5j4gh9ED6qoriVpKdq5vD66Ev+kH6GPGP1
         NEXnl1Krb+y9Wrwm1+85nhAYon1VRfEcLW41qBqhcp3X5TbLqTB9fcKtToObsVUbKMw0
         D4EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uIhnvOwqnwIWxm0SHixgB7elVTNnkA/cKlaoIzV6RwE=;
        b=MOzz1+aVtuTsdgZRo3Iydl4Cbh6tdwnpOp4Nrd1SGKP8GOh+Q7HGishAp1/nOzcbcg
         8NrWuTR99eRd9v1pqj/YrQHnF8Mop+ExfC7wj37vSfuIusC/sNH+6hjPVLzq3PG3oboW
         0jYlU0agU5MSVvnu8ZQs5b2CJblCgT0LPR5aRA7iDIFV1i4URyGBqnOWg0nebLgrEFns
         7wNuLj0z40mV+Alnpn98Xg/FqV5I7dy7//KWJgk0e4323S1lgOK5mmSkPFi8L9AfNKCN
         FGjMq+WavHvWMH2mQ5dzTG07GWVlmOSkRfyVlEM+/EYBQdMGOvI3yTle6vPGpa6V+BuR
         3ibg==
X-Gm-Message-State: AOAM533tIs5QslxPY386DB0ooJdhn2EPidGiT4OdLfxyIDJZ8pGYVLZZ
        D6FZiAloiwmW7s13K4O+yGI=
X-Google-Smtp-Source: ABdhPJwprKypXPdDMo6pgtLG7mxe3HPrw+uqL3AQd2uevdQijOcQXUC/6+WYS9c7f/kBd7O+0qckzQ==
X-Received: by 2002:a17:906:e84:: with SMTP id p4mr2172980ejf.141.1611882030479;
        Thu, 28 Jan 2021 17:00:30 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id f22sm3049256eje.34.2021.01.28.17.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 17:00:29 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v8 net-next 01/11] net: dsa: tag_8021q: add helpers to deduce whether a VLAN ID is RX or TX VLAN
Date:   Fri, 29 Jan 2021 02:59:59 +0200
Message-Id: <20210129010009.3959398-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129010009.3959398-1-olteanv@gmail.com>
References: <20210129010009.3959398-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The sja1105 implementation can be blind about this, but the felix driver
doesn't do exactly what it's being told, so it needs to know whether it
is a TX or an RX VLAN, so it can install the appropriate type of TCAM
rule.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v8:
None.

Changes in v7:
None.

Changes in v6:
None.

Changes in v5:
None.

Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 include/linux/dsa/8021q.h | 14 ++++++++++++++
 net/dsa/tag_8021q.c       | 15 +++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 88cd72dfa4e0..b12b05f1c8b4 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -64,6 +64,10 @@ int dsa_8021q_rx_source_port(u16 vid);
 
 u16 dsa_8021q_rx_subvlan(u16 vid);
 
+bool vid_is_dsa_8021q_rxvlan(u16 vid);
+
+bool vid_is_dsa_8021q_txvlan(u16 vid);
+
 bool vid_is_dsa_8021q(u16 vid);
 
 #else
@@ -123,6 +127,16 @@ u16 dsa_8021q_rx_subvlan(u16 vid)
 	return 0;
 }
 
+bool vid_is_dsa_8021q_rxvlan(u16 vid)
+{
+	return false;
+}
+
+bool vid_is_dsa_8021q_txvlan(u16 vid)
+{
+	return false;
+}
+
 bool vid_is_dsa_8021q(u16 vid)
 {
 	return false;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 8e3e8a5b8559..008c1ec6e20c 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -133,10 +133,21 @@ u16 dsa_8021q_rx_subvlan(u16 vid)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_subvlan);
 
+bool vid_is_dsa_8021q_rxvlan(u16 vid)
+{
+	return (vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_RX;
+}
+EXPORT_SYMBOL_GPL(vid_is_dsa_8021q_rxvlan);
+
+bool vid_is_dsa_8021q_txvlan(u16 vid)
+{
+	return (vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_TX;
+}
+EXPORT_SYMBOL_GPL(vid_is_dsa_8021q_txvlan);
+
 bool vid_is_dsa_8021q(u16 vid)
 {
-	return ((vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_RX ||
-		(vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_TX);
+	return vid_is_dsa_8021q_rxvlan(vid) || vid_is_dsa_8021q_txvlan(vid);
 }
 EXPORT_SYMBOL_GPL(vid_is_dsa_8021q);
 
-- 
2.25.1

