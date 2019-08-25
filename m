Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD8EC9C5EC
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 21:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfHYTqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 15:46:45 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55545 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbfHYTqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 15:46:44 -0400
Received: by mail-wm1-f65.google.com with SMTP id f72so13472928wmf.5
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 12:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5M8iWETZzE1UPMuJZQkLCc1wMjafEq4lODGl/NSuFrg=;
        b=QYrde/7HBmmTxH8ooLbCOKTj8efsJvfYgVb00mGfZTicclcJT599meNqwLUe968jFd
         nZ5SeoxHXO9a582HEGqxdOsPG2Darg/fZ9h8ceom2fWbeFaXkyChr6BW1LtHGOrtCrhT
         3bbrp52x0rJBN1QCGlLkJQUHBUzEAFfa9n7kdnnhIj919TsrVYFcu2Ai+IJtr/+Xw0EN
         UPqqkFKUjXcsmCS8HmRfcPSIhbFVKYdOul2eYrLpdWRJbzN/LP6qpuPDrGtOMHIsSnyP
         /cddApuY7DwsjLizvzw5yz2RPvgug3n4GYWlO1vTt1fTbAiJG0k5WdBBo58Wa//Q9v9F
         kmew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5M8iWETZzE1UPMuJZQkLCc1wMjafEq4lODGl/NSuFrg=;
        b=HJhbvCevedsGGQu6P82nIfehLRueNh2iOdAE53JgVvc0les8Ir26MYXdy1ORQfVBR0
         dJ5shv7A/EuyT1mopIJ16FliTo+G3MRX92ffUZhroPIpvD6/rJ9NqJ2t0WWkW1Ad15GO
         DBy/H4T1cQ9OggLUGdz8XSjkf6rPEEMqGPFe+t95ATUeTJKEwwdrk5nUT9Mue25HYRLX
         2muTm15gTeHGyO1ScDinTWPdNzA7oIo12DqYO+yrdcXPdF/OxtvHBlykqD7DZ0ZXsfW+
         awoPB1zHU27q2j+EDwBO4+AdS2JeibMRFQCt4Av4EnkK/oaZOTeTogKtrsViq6CtCBIr
         h1Ag==
X-Gm-Message-State: APjAAAVWn7g/QfEjccDY8lOEJsUAFOzz6C+yt0kBaa0kStyTb/aIZD9X
        EXBdfHB8kMm1mLTrkEGP9lE=
X-Google-Smtp-Source: APXvYqwmPJRhyJV6qGByLtt8YGpOwTYcDE0Yh/CxoNJdg7gTtvjFbeWHitAhMk3Zc/ursh/6coMTdg==
X-Received: by 2002:a05:600c:218d:: with SMTP id e13mr17785071wme.29.1566762402830;
        Sun, 25 Aug 2019 12:46:42 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id v124sm19770974wmf.23.2019.08.25.12.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 12:46:42 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/2] net: dsa: Advertise the VLAN offload netdev ability only if switch supports it
Date:   Sun, 25 Aug 2019 22:46:29 +0300
Message-Id: <20190825194630.12404-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190825194630.12404-1-olteanv@gmail.com>
References: <20190825194630.12404-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When adding a VLAN sub-interface on a DSA slave port, the 8021q core
checks NETIF_F_HW_VLAN_CTAG_FILTER and, if the netdev is capable of
filtering, calls .ndo_vlan_rx_add_vid or .ndo_vlan_rx_kill_vid to
configure the VLAN offloading.

DSA sets this up counter-intuitively: it always advertises this netdev
feature, but the underlying driver may not actually support VLAN table
manipulation. In that case, the DSA core is forced to ignore the error,
because not being able to offload the VLAN is still fine - and should
result in the creation of a non-accelerated VLAN sub-interface.

Change this so that the netdev feature is only advertised for switch
drivers that support VLAN manipulation, instead of checking for
-EOPNOTSUPP at runtime.

Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/slave.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d84225125099..9a88035517a6 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1131,11 +1131,11 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	}
 
 	ret = dsa_port_vid_add(dp, vid, 0);
-	if (ret && ret != -EOPNOTSUPP)
+	if (ret)
 		return ret;
 
 	ret = dsa_port_vid_add(dp->cpu_dp, vid, 0);
-	if (ret && ret != -EOPNOTSUPP)
+	if (ret)
 		return ret;
 
 	return 0;
@@ -1164,14 +1164,10 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 			return -EBUSY;
 	}
 
-	ret = dsa_port_vid_del(dp, vid);
-	if (ret == -EOPNOTSUPP)
-		ret = 0;
-
 	/* Do not deprogram the CPU port as it may be shared with other user
 	 * ports which can be members of this VLAN as well.
 	 */
-	return ret;
+	return dsa_port_vid_del(dp, vid);
 }
 
 static const struct ethtool_ops dsa_slave_ethtool_ops = {
@@ -1418,8 +1414,9 @@ int dsa_slave_create(struct dsa_port *port)
 	if (slave_dev == NULL)
 		return -ENOMEM;
 
-	slave_dev->features = master->vlan_features | NETIF_F_HW_TC |
-				NETIF_F_HW_VLAN_CTAG_FILTER;
+	slave_dev->features = master->vlan_features | NETIF_F_HW_TC;
+	if (ds->ops->port_vlan_add && ds->ops->port_vlan_del)
+		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	slave_dev->hw_features |= NETIF_F_HW_TC;
 	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
 	if (!IS_ERR_OR_NULL(port->mac))
-- 
2.17.1

