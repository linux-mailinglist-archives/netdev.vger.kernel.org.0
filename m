Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4A29CB7C
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 10:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729803AbfHZIZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 04:25:14 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37608 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfHZIZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 04:25:14 -0400
Received: by mail-pg1-f194.google.com with SMTP id d1so10154731pgp.4
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 01:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=a3BAsKjANcJgcv1scAtK0k8OfbEQOZYPHfYvsXy8e88=;
        b=AdyHdqG/djNoSilQ4T2GDdDFep9ySsey8wbuCbtgBlpT+rfut/qnR5Pf4wk7MLG6Qe
         Dd+4Gd3Yo52QzgzjOBBa07R4DL8pT4GByZQ/RcN90AoF0Q90i7TV4v/r8ENnMBkQtQZj
         s7EiyjkMObVh4Gm1e5ELoQO4hXGB1rJTwPYnFjw0QUjA9KXgv8PNWjqPznBCfrubcjfy
         +FNTTr7tUnaG1gI+IpzyHPfHOHm4UWfLizzmw6JxwKO0m5sswCi7l4bZiLzTnmeYevEl
         fa/i1l2TkUFOCtpFA9/6jRE9Z/hD1nVPKrs4gJIkJgqW/VlXaXHhGokkuYXpc5aNq3gW
         EWJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=a3BAsKjANcJgcv1scAtK0k8OfbEQOZYPHfYvsXy8e88=;
        b=JTxUTcHN51RCf/qk+B/Cjo7sgOcvlXyc3GGZDmTnpntCVcj4LFrz52zL6aoE4O57+o
         SqT8h4a83PoLGI3XiUFLE0+GKVT9EXyjTSmk+JOwMvycKTRUo8YbFdIKAaPu7eobqITE
         5gF0IJtXGA5mHD+5RMwg5BB9VoLou9Q7IURlmzwk0SWnEqmg5PguBZjvCU91e1HDEElQ
         oauKpNalWXHYnEaW3SxuK7XEvNqakshirxYZBlaTyCoxD8FxAztolSzo8IRvNe0eUmGm
         SReWQKQdLPTVL/g+Z9v4NY8WauDodOX2wUSktZnKKGTyPCG9XEgfTqZqGsV/jbqavBeh
         MLBw==
X-Gm-Message-State: APjAAAUSP1EtsbOR6hUOTpgLAIn/G6BQA14zw0oBQO1M+AQtUFRUiAVw
        nl+dotZ5BH5PvvO/Loawr1pOjBYDx2I=
X-Google-Smtp-Source: APXvYqwBQE9wiaRTVYM1/7HExu1am/X/xwaSdVfXt6UWN6uN9KGpyNyFepnXyiyu0E2YPTswxhGUIA==
X-Received: by 2002:a65:48c3:: with SMTP id o3mr15222275pgs.372.1566807913385;
        Mon, 26 Aug 2019 01:25:13 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v67sm16472443pfb.45.2019.08.26.01.25.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 01:25:12 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net] xfrm: add NETDEV_UNREGISTER event process for xfrmi
Date:   Mon, 26 Aug 2019 16:25:05 +0800
Message-Id: <fce85b872c03cee379cb30ae46100ff42bea8e0d.1566807905.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When creating a xfrmi dev, it always holds the phydev. The xfrmi dev should
be deleted when the phydev is being unregistered, so that the phydev can be
put on time. Otherwise the phydev's deleting will get stuck:

  # ip link add dummy10 type dummy
  # ip link add xfrmi10 type xfrm dev dummy10
  # ip link del dummy10

The last command blocks and dmesg shows:

  unregister_netdevice: waiting for dummy10 to become free. Usage count = 1

This patch fixes it by adding NETDEV_UNREGISTER event process for xfrmi.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_interface.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 74868f9..f3de1f5 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -877,6 +877,35 @@ static const struct xfrm_if_cb xfrm_if_cb = {
 	.decode_session =	xfrmi_decode_session,
 };
 
+static int xfrmi_event(struct notifier_block *this, unsigned long e, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct xfrmi_net *xfrmn = net_generic(dev_net(dev), xfrmi_net_id);
+	struct xfrm_if *xi;
+	LIST_HEAD(list);
+
+	if (e != NETDEV_UNREGISTER)
+		return NOTIFY_DONE;
+
+	rcu_read_lock();
+	for_each_xfrmi_rcu(xfrmn->xfrmi[0], xi) {
+		if (xi->phydev != dev)
+			continue;
+		unregister_netdevice_queue(xi->dev, &list);
+	}
+	rcu_read_unlock();
+
+	if (list_empty(&list))
+		return NOTIFY_DONE;
+
+	unregister_netdevice_many(&list);
+	return NOTIFY_OK;
+}
+
+static struct notifier_block xfrmi_notifier = {
+	.notifier_call  = xfrmi_event,
+};
+
 static int __init xfrmi_init(void)
 {
 	const char *msg;
@@ -906,6 +935,7 @@ static int __init xfrmi_init(void)
 		goto rtnl_link_failed;
 
 	xfrm_if_register_cb(&xfrm_if_cb);
+	register_netdevice_notifier(&xfrmi_notifier);
 
 	return err;
 
@@ -922,6 +952,7 @@ static int __init xfrmi_init(void)
 
 static void __exit xfrmi_fini(void)
 {
+	unregister_netdevice_notifier(&xfrmi_notifier);
 	xfrm_if_unregister_cb();
 	rtnl_link_unregister(&xfrmi_link_ops);
 	xfrmi4_fini();
-- 
2.1.0

