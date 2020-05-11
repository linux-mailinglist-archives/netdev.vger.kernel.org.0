Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6585E1CDC37
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730319AbgEKNxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730272AbgEKNxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 09:53:48 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64656C061A0C;
        Mon, 11 May 2020 06:53:48 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x17so11093353wrt.5;
        Mon, 11 May 2020 06:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hNG/10B3Pefsb5Q5b7mR38gWX4KHNiMPpYnHL7HYAv4=;
        b=NG+VbLzf7Oakm+iS7a/KPaKSq41iCQs+33U5RK+hhaODDNKuEH9boBQ2NP5EYKldHh
         1J3cz0TboxZ279Jru4JfQ7o+De6yXgetNVHFxlarkiqORbxPjC7PkqK+CrtSSTAHyiVw
         bMC8qaOP9BujpmN89vV7DDVDtX4NqDJB7elQIBS2yYc9XHKU8gw6bF/SF8jRVUK76yob
         mSGiCHV7QVLHf95cgjvE0zjQw15gAkYpZg8/RW2CzTvTL3DM64wQ0qblTOwMyfZrmPHU
         F8o/syKaeA31KZjN+vltZOqWbMVbDY+ERAPMUrcK+wsP2Miq3J2qMP1oTP2abfilx1RC
         UdxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hNG/10B3Pefsb5Q5b7mR38gWX4KHNiMPpYnHL7HYAv4=;
        b=G+1WMFoakISSu42Y+kBfmSRy/Dh3KlWhHqyYKB0OL8sk8hln+PeeKGLPYw0uBDeSqd
         C0iaOf0NGzAT8azm0LVhfGthWnKMqjRoWjhqlcamFZ0dRFe+GU19BByWq+Yyj2jUOJOe
         YekXCPQkl8F6XffN487praUSytwi1BdXK+JRSN7b0Kuad2DaUJRb7+/0mCojUW72atOI
         23iGKfKZe74cMa+iX68u3VKSNS5RMvjdhIWwHX4UVC5zMIo+PQW5OSciLSigWQFeTcyJ
         W39Kx6FHdae7yjRdGbsXlHNxyayLaNGuoqH8c7VIUrr3bQc3Mt8yGswVE+Wtyz8hYMD9
         2RUg==
X-Gm-Message-State: AGi0PuasZk2yAlJiu+XUxJE5RwxywU7/8r2DYmmjMpvR3pVFkr4+mF5N
        gUxS+XLghSdeue9sFyRrCdc=
X-Google-Smtp-Source: APiQypI+wCOUsRpIZmsB/FK4otzax7dVWUZ8H1CWNB5B2rpxks1dtaig6iDqZZbQR81eUMz6R/Kn2Q==
X-Received: by 2002:adf:82b3:: with SMTP id 48mr18843030wrc.223.1589205227194;
        Mon, 11 May 2020 06:53:47 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 2sm17596413wre.25.2020.05.11.06.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 06:53:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 02/15] net: dsa: tag_8021q: introduce a vid_is_dsa_8021q helper
Date:   Mon, 11 May 2020 16:53:25 +0300
Message-Id: <20200511135338.20263-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511135338.20263-1-olteanv@gmail.com>
References: <20200511135338.20263-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This function returns a boolean denoting whether the VLAN passed as
argument is part of the 1024-3071 range that the dsa_8021q tagging
scheme uses.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 include/linux/dsa/8021q.h | 7 +++++++
 net/dsa/tag_8021q.c       | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index b8daaec0896e..ebc245ff838a 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -50,6 +50,8 @@ int dsa_8021q_rx_switch_id(u16 vid);
 
 int dsa_8021q_rx_source_port(u16 vid);
 
+bool vid_is_dsa_8021q(u16 vid);
+
 #else
 
 int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
@@ -107,6 +109,11 @@ int dsa_8021q_rx_source_port(u16 vid)
 	return 0;
 }
 
+bool vid_is_dsa_8021q(u16 vid)
+{
+	return false;
+}
+
 #endif /* IS_ENABLED(CONFIG_NET_DSA_TAG_8021Q) */
 
 #endif /* _NET_DSA_8021Q_H */
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index ff9c5bf64bda..4774ecd1f8fc 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -93,6 +93,13 @@ int dsa_8021q_rx_source_port(u16 vid)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_source_port);
 
+bool vid_is_dsa_8021q(u16 vid)
+{
+	return ((vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_RX ||
+		(vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_TX);
+}
+EXPORT_SYMBOL_GPL(vid_is_dsa_8021q);
+
 static int dsa_8021q_restore_pvid(struct dsa_switch *ds, int port)
 {
 	struct bridge_vlan_info vinfo;
-- 
2.17.1

