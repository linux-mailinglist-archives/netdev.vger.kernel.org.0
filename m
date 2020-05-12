Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9A71CFBF9
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 19:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbgELRUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 13:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgELRUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 13:20:47 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0E9C061A0F;
        Tue, 12 May 2020 10:20:47 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id l11so10608416wru.0;
        Tue, 12 May 2020 10:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/fw4EsIwrMwPtxEV+OIPK3/PfvmehVKJ2UDr9HB0vNI=;
        b=kIVnjQK1z4KoJOv/wvc3wvJpkE7DT284Hjg4bSGoJwi24FrxFDtWCCJuCFEBKyd378
         Au3D9MXEVcC/U03ctdME+oxgArPxqYdzLhKUOrG9bh3W+hK0WrrP54lHwx7QSBCE1jaP
         dKaWVUcIzlLv8XS28rjFbApkRzFAD0d2KV97/VEr/owvhitMB31Ksu7f86Flit3j/xHP
         nA5QdhQI11JTCpbaLMBO9n8fO3nJZ8Oq5WfMh1i0c4QIJRB3K/Wh6MHYVVb4OJD0pa/9
         HsS4uZ4j4aZgswjE3LOlDs3eYPt5Qb/mzKFC1B1wqS6j4Ynd518+v8vlPy3qqq3arQLM
         JjTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/fw4EsIwrMwPtxEV+OIPK3/PfvmehVKJ2UDr9HB0vNI=;
        b=KTO3QwcARnAR+Id9lAQd3jciKsEr7S05xxfjDv8ed/wk4JeOQbranvB5SZbJ+r8Pzq
         sC78k47J/Oiq2tWdqsT+MqSl1h60FWwCOIwEuL9KkCO/L4rRwpZLUiah+n9pHm2r0L3K
         OJzH3el1vaXr/h9d4ZCtgw25DeIen0M1Pqj8rRkWSDZXaCYOTkgj4p+Pf1m0VNKVzbGS
         Eikhu91m0Ry+DrhDlRyMkL11jlO6D2fFfmRvqrEtnwLEESkqFdOj6ZspRh3kT4myrcKU
         1ngdW2SmOuNqgSuezct1MQkPLd0uLvsQ9VXO4PsbnU+ToVgFD1QbxZRW9SCDqBu6ndR/
         kC9w==
X-Gm-Message-State: AGi0PuYAyUB9LlhECtXWzkw/Da+qEMbRXxiKgbAjpTciJmKHrqhKgRli
        VfnHtJ7EDCMEQ+RFaeuRGk4=
X-Google-Smtp-Source: APiQypKF8lYICldbP0tmbeo9fFtbiGgoUpGF7n+9fdt3ISeRr0mx+MI8NPBg7MSS/DqR25xv6fpO1A==
X-Received: by 2002:adf:e751:: with SMTP id c17mr27603174wrn.351.1589304046278;
        Tue, 12 May 2020 10:20:46 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id a15sm23999743wrw.56.2020.05.12.10.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 10:20:45 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 02/15] net: dsa: tag_8021q: introduce a vid_is_dsa_8021q helper
Date:   Tue, 12 May 2020 20:20:26 +0300
Message-Id: <20200512172039.14136-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512172039.14136-1-olteanv@gmail.com>
References: <20200512172039.14136-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This function returns a boolean denoting whether the VLAN passed as
argument is part of the 1024-3071 range that the dsa_8021q tagging
scheme uses.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

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

