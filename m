Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA86A1CCC68
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgEJQox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729057AbgEJQnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:43:32 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B2CC061A0E;
        Sun, 10 May 2020 09:43:31 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id h4so15411882wmb.4;
        Sun, 10 May 2020 09:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=i3xdQfNNhGs9x7KATPUsqJauaICpGQwRxOGD+fuAb3E=;
        b=WDOd1kaFFfF1lWYkOl5N2PcGLxEpbfz7Esm+tYr4fNIZKYYKI0JOhhjTECCi7QjL4L
         08Su9U7PR5HLZ4qojIQymZE7k/0yRKQCl7FVJhb9P79x/yueTtR1I808yr8YquSmP1tX
         wSsZgdns1vTP1pWWEOTyXRIIrUoN5qELGV2t/5enTI+MNU/qznCX4ZLwFfoTbcccnQNu
         ZcNb+xNnOjW4x3bjMfa9/ksBfxXAoHisxsdADVYZ35nVbTaXT96OVkgdtl6KwjYZPckw
         NdsOc1u+kqyfgcZab3saHgIXv+5vTA5VLzB1jSsyp4s+YRaRMsnozEMxtjm6Zt7y3N5q
         tkmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=i3xdQfNNhGs9x7KATPUsqJauaICpGQwRxOGD+fuAb3E=;
        b=rSTGcxm0+mJHt+4SUwIkDurgcsMCmK9gq0eovf10134etlzapMKX+OaUYS4sbqK5Zr
         ss9gfmfv/bLuF1k0VTYSgnJXIiZRlvSSEqntTCD6mjYhsRZpqzqqUzIDmSCb9dcebfnd
         uNd5la3yaDx7RNY854zElQcN8gRyaGOqi687J6w7Y7Wmwk4CY1ZwzCmTgwOaOKjVfggD
         c+dtIzHXXZqRIES0LrAgRrGrtVwtNonDxbvsb5tdCDRHAVUecKM+b0UkGqJEbY1b48+2
         JCS4TSP3FJ8z9koly8aclXLUP7bbW/p91DE7J3jKF5u7JbyyEjyhR6dTtVws+OYc6+ed
         CJpQ==
X-Gm-Message-State: AGi0PubSK/nHHNPcEGGTbB1wd1N4Bx1iOwPUWdFRkLOzSm3o8zLLIU6N
        HN0RnRfneFJ8mjY+KQmQo5XjZoUk
X-Google-Smtp-Source: APiQypIEeFJc0XI3zCN/4DAndO81GyyjKAPeqV2gSbg+qYMYSWvIL/M3C690waMQ+nrRhSZBZl6iLw==
X-Received: by 2002:a7b:cc83:: with SMTP id p3mr9078882wma.156.1589129010592;
        Sun, 10 May 2020 09:43:30 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id i1sm13390916wrx.22.2020.05.10.09.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 09:43:30 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 02/15] net: dsa: tag_8021q: introduce a vid_is_dsa_8021q helper
Date:   Sun, 10 May 2020 19:42:42 +0300
Message-Id: <20200510164255.19322-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200510164255.19322-1-olteanv@gmail.com>
References: <20200510164255.19322-1-olteanv@gmail.com>
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

