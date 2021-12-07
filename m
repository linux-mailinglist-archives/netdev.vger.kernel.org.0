Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DB446AFD9
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351791AbhLGBfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351719AbhLGBet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:34:49 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68F5C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 17:31:19 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id s137so12186167pgs.5
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 17:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5ugRFVe8tqZ8TG93H3WVUo6sMVqhA3hDza9SvXzL6EE=;
        b=YIiMjErUQuImCLb6v4ZU2iGnj+Zs9/oXrRdmPf/Up+NQFSuD5mc7gKRI9CjFKx/jkW
         1Lz6JRFdqaLBBsBF8KhSQsUZ26cYHhtW0M2K57iRACMgEQW6GRrHueSesl9Ylne/3mrK
         Wu1FJ7e6YRhd8zCMjdw/XAgiQRpqRLWDiJPxf8sGe/flvyoJ/LktnpsxiU5nBFRFKvCC
         YPhdnj7W1ggpEo0Lh4UH5ILRHLbakca5pegUNtLUx3fSGF/VIe2uXTUiJcG+ulKSx+Sd
         Tj2xAi1eJwklgk/LnQRGERkBDh8CBS3bmIiMA3vG6ZP7apPSxqEtOUhhzjxeWkIdBORi
         HEew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5ugRFVe8tqZ8TG93H3WVUo6sMVqhA3hDza9SvXzL6EE=;
        b=Q6RH6XMmbB7OD336IqDG6liFhNdjAQWqcsr9vh8PmhRWWrW2eEyxoImWt9+L3zD/Do
         oEw0SE30g/S93L+2L2YYwy2Pmjzlaw2qfV/mbay9X5kcKIuAD4cvR2dsIqFyFfXJdXe3
         uRhsK2rMwboEWX7kq6JyCflxlueh9FULQaUf+1ieBT5aUFlmaHi0ZrZe5leqxhTmQ4Jl
         aKZfOacAZWHXwDlW2JOYt6Ab+3FSC4ndq6QRXfElPla4azgWoHliqKuy6eXLqKxnRjD8
         2zBMoJeeaTf9LclzBBvRltnD1Tp9Z1WYXTpxu9h+CTUAKVkY5mzYbyTxBMMxlOhs/2mq
         cC8A==
X-Gm-Message-State: AOAM532Et4vyGkB/b0Tr7qhNyA9jvs5O9kzuwrJyjWqNvoGq/z77qask
        pkHPEO2PdIRmXCzY2RgXi4c=
X-Google-Smtp-Source: ABdhPJw8jgBpdMqTxJjiVXiEhjWxo0oxNMz/ncAi3TB7G62G9Zcr8S0c6u+xv9e9+sBQ/Kefeqp+tQ==
X-Received: by 2002:a05:6a00:2487:b0:4af:94c7:8aae with SMTP id c7-20020a056a00248700b004af94c78aaemr3026308pfv.31.1638840679337;
        Mon, 06 Dec 2021 17:31:19 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id u6sm13342907pfg.157.2021.12.06.17.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 17:31:19 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 12/13] openvswitch: add net device refcount tracker to struct vport
Date:   Mon,  6 Dec 2021 17:30:38 -0800
Message-Id: <20211207013039.1868645-13-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207013039.1868645-1-eric.dumazet@gmail.com>
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/openvswitch/vport-netdev.c | 8 ++++----
 net/openvswitch/vport.h        | 2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/vport-netdev.c b/net/openvswitch/vport-netdev.c
index c1ad6699b1f89d9f00ba85a9f23c89b1661ec812..b498dac4e1e0046f6a325a1cdf0afa38c95ef722 100644
--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -82,7 +82,7 @@ struct vport *ovs_netdev_link(struct vport *vport, const char *name)
 		err = -ENODEV;
 		goto error_free_vport;
 	}
-
+	netdev_tracker_alloc(vport->dev, &vport->dev_tracker, GFP_KERNEL);
 	if (vport->dev->flags & IFF_LOOPBACK ||
 	    (vport->dev->type != ARPHRD_ETHER &&
 	     vport->dev->type != ARPHRD_NONE) ||
@@ -115,7 +115,7 @@ struct vport *ovs_netdev_link(struct vport *vport, const char *name)
 error_unlock:
 	rtnl_unlock();
 error_put:
-	dev_put(vport->dev);
+	dev_put_track(vport->dev, &vport->dev_tracker);
 error_free_vport:
 	ovs_vport_free(vport);
 	return ERR_PTR(err);
@@ -137,7 +137,7 @@ static void vport_netdev_free(struct rcu_head *rcu)
 {
 	struct vport *vport = container_of(rcu, struct vport, rcu);
 
-	dev_put(vport->dev);
+	dev_put_track(vport->dev, &vport->dev_tracker);
 	ovs_vport_free(vport);
 }
 
@@ -173,7 +173,7 @@ void ovs_netdev_tunnel_destroy(struct vport *vport)
 	 */
 	if (vport->dev->reg_state == NETREG_REGISTERED)
 		rtnl_delete_link(vport->dev);
-	dev_put(vport->dev);
+	dev_put_track(vport->dev, &vport->dev_tracker);
 	vport->dev = NULL;
 	rtnl_unlock();
 
diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
index 8a930ca6d6b17d88c08536083c0d888cce3e99c2..9de5030d9801c7065a4cf5478cfc3778891a6535 100644
--- a/net/openvswitch/vport.h
+++ b/net/openvswitch/vport.h
@@ -58,6 +58,7 @@ struct vport_portids {
 /**
  * struct vport - one port within a datapath
  * @dev: Pointer to net_device.
+ * @dev_tracker: refcount tracker for @dev reference
  * @dp: Datapath to which this port belongs.
  * @upcall_portids: RCU protected 'struct vport_portids'.
  * @port_no: Index into @dp's @ports array.
@@ -69,6 +70,7 @@ struct vport_portids {
  */
 struct vport {
 	struct net_device *dev;
+	netdevice_tracker dev_tracker;
 	struct datapath	*dp;
 	struct vport_portids __rcu *upcall_portids;
 	u16 port_no;
-- 
2.34.1.400.ga245620fadb-goog

