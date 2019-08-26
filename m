Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE049CB7F
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 10:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730556AbfHZI0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 04:26:01 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34951 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729803AbfHZI0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 04:26:00 -0400
Received: by mail-pf1-f194.google.com with SMTP id d85so11343122pfd.2
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 01:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=89CjOhJwfFAgUmBqiTl380lOymHc8jjeDJPPlsPo5w4=;
        b=fqeWKa3/CWVkk4a0jGm058v0tzQO+VR92TlPm8cNc+ucpm8d42qGaDeiTprlaBb6F1
         Z7O5MP+/Ww139VTIg8IeNX2kZoXvhvF+8iTM/9eqTk0YXR7MPShAcsV9bnY6hYThI0Ow
         XTi9J2yjHpQcrCvGSQbkYezTw2/7f61nteyUzaf2E9MleoCkclGrTHvv8uEIja7IBjl8
         jYCDDgW+Wj+DpQV19oVF9eoDDj8NeBxhYJMdcEy2QKzpXyDNhWi/MlCAQSFEugWcRzAH
         dWzzoyRkZI4H9edF5Xa8ajIMldiKrbyeLNDFGRknI4gYT+y1WaWp055R+iATEBvzM64Q
         Tv4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=89CjOhJwfFAgUmBqiTl380lOymHc8jjeDJPPlsPo5w4=;
        b=bhL0iZZzjB9O+Jd1DlXywi35sOz4ZITDgsbeT/WovDW93hA6iP7UjCGUcjCkbmwSKF
         J6UE2vWp3cTm6MUTy7I9wI7K8iAMYCplc4rKla2x3R14UAvcL2tqBh9L3MIFHcjSdmg6
         5i6mNk8WQKBrq5TNWGuIPBYXo2ylWzUBI1VPUHtQjBYgwL0VBtqYhQ4mQrn4U7BOQgyS
         uZ4wlResdSM+EdbfSjtXEiOKWbVoc2i+aPSpj+eqPt28JKKjd3vAbBCwFXrcRCX587Xg
         8XU3alQQ/GtGhew69Ebieza7dMUn+UpywI4xGOrm9PBWcpgzv3mXoFYjQC2E0LvD0uNQ
         TkSw==
X-Gm-Message-State: APjAAAW8wkkcfmoLzTNjzi+7xkYoaGpqwfEDziOoeSEMBAq7egb0Dm4k
        N8wRS9BSmiRvrNzPDfRY/oytWR7pLvc=
X-Google-Smtp-Source: APXvYqyC9UJWr8bTelnAFeEjr9d0s2310b2uAoQ7Jfp1OGrq/snWIh4l15V1MOMDD/ds0dP/H9AJ/g==
X-Received: by 2002:a17:90a:c204:: with SMTP id e4mr17934051pjt.110.1566807959447;
        Mon, 26 Aug 2019 01:25:59 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x17sm10716924pff.62.2019.08.26.01.25.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 01:25:58 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net] xfrm: remove the unnecessary .net_exit for xfrmi
Date:   Mon, 26 Aug 2019 16:25:51 +0800
Message-Id: <120f5509a5c9292b437041e8a4193653adb9a019.1566807951.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The xfrm_if(s) on each netns can be deleted when its xfrmi dev is
deleted. xfrmi dev's removal can happen when:

  1. Its phydev is being deleted and NETDEV_UNREGISTER event is
     processed in xfrmi_event() from my last patch.
  2. netns is being removed and all xfrmi devs will be deleted.
  3. rtnl_link_unregister(&xfrmi_link_ops) in xfrmi_fini() when
     xfrm_interface.ko is being unloaded.

So there's no need to use xfrmi_exit_net() to clean any xfrm_if up.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_interface.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index f3de1f5..3420c71 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -738,30 +738,7 @@ static struct rtnl_link_ops xfrmi_link_ops __read_mostly = {
 	.get_link_net	= xfrmi_get_link_net,
 };
 
-static void __net_exit xfrmi_destroy_interfaces(struct xfrmi_net *xfrmn)
-{
-	struct xfrm_if *xi;
-	LIST_HEAD(list);
-
-	xi = rtnl_dereference(xfrmn->xfrmi[0]);
-	if (!xi)
-		return;
-
-	unregister_netdevice_queue(xi->dev, &list);
-	unregister_netdevice_many(&list);
-}
-
-static void __net_exit xfrmi_exit_net(struct net *net)
-{
-	struct xfrmi_net *xfrmn = net_generic(net, xfrmi_net_id);
-
-	rtnl_lock();
-	xfrmi_destroy_interfaces(xfrmn);
-	rtnl_unlock();
-}
-
 static struct pernet_operations xfrmi_net_ops = {
-	.exit = xfrmi_exit_net,
 	.id   = &xfrmi_net_id,
 	.size = sizeof(struct xfrmi_net),
 };
-- 
2.1.0

