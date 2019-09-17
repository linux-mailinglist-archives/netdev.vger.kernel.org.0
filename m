Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 639D9B9E4F
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 17:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437993AbfIUPHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 11:07:22 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39472 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390272AbfIUPHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 11:07:22 -0400
Received: by mail-pg1-f196.google.com with SMTP id u17so5495879pgi.6
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 08:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Adz7ETSL9HNcfFWHxlTFlNte0nN39g7TshCMmbAUHEo=;
        b=j06KTtyHiTTUCVnh2wEMHNjr5oF7DsOB58OluFQ2U509M5//oIS7b1MY1o1npQLdOP
         5AN9Ux1OthvRwBo5D8IhYlKIRGLTPIzZmyIBuzbxW83AdChzhhGHvSg+CEbvF4GpviSM
         oY1OWohA3aBb5tzka1jiyzfpGzO122b7G0hYGMN6FhcfJrsmCuQttLxm6Mx+9m9LkQ3p
         GGLSSU5BVvN1tM5F2kaOENtJ+Ka8Lvru5uATdvc0lrrgfwYWyErfWYIgQirNzjMS/HUT
         rHIHnDTH62aV+3bvHdpioQ6bjQSJeFXXIQ5EZ73cYg0VGUuasUR41bJ7+vUyEJILqbo2
         RuqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Adz7ETSL9HNcfFWHxlTFlNte0nN39g7TshCMmbAUHEo=;
        b=rMS+RJyVLrPCWsZuNLltquQpQ7AliV9Qe0shT3X7atpdasbcPsfVF6HgX5eMCO2fpE
         RMRy+/d/E6ShWT4HUlIW7doaw2JnxgPr80IOjkGg7Z2zEW0c7hu3N5dxncsyEWFg+AjQ
         ONIDntDPpZO+hWDMOMFKAHdogZwPhc8nZmzrLwA/+fjQePbCCD2TCRZOqZlI249aV/Sa
         5z7Yzqcf9o81jnxKP2deZ9aQggxITKWF89wULZCKbHO1D7tHFB3A0otYUOXneKOGqnHA
         hGkiQExoleZYQ2POz3z1OjGTXdHx5bpbtzFRz4ecgIHHcYUZHH5RTBLZv1NG4S1Uk4oA
         P8nQ==
X-Gm-Message-State: APjAAAXVslO93X8FK/G1uF5POKqJbC1LtOoCstw6bKXom9QZ61/KsjZA
        A1qFQ8seXyzDtS3aDT1jxFwFkyyM
X-Google-Smtp-Source: APXvYqxW3vcqea7zY2ti9AsaP5YwwlvirMFIxNb3sn/C7dhQ9HvqpnWVuMfAfpHmraiDFm2+XxOi5w==
X-Received: by 2002:aa7:84d5:: with SMTP id x21mr22872886pfn.253.1569078441457;
        Sat, 21 Sep 2019 08:07:21 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.142.144.23])
        by smtp.gmail.com with ESMTPSA id g12sm8757271pfb.97.2019.09.21.08.07.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Sep 2019 08:07:20 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH net] net: openvswitch: fix possible memleak on create vport fails
Date:   Tue, 17 Sep 2019 23:40:08 +0800
Message-Id: <1568734808-42628-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

If we register a net device which name is not valid
(dev_get_valid_name), register_netdevice will return err
codes and will not run dev->priv_destructor. The memory
will leak. This patch adds check in ovs_vport_free and
set the vport NULL.

Fixes: 309b66970ee2 ("net: openvswitch: do not free vport if register_netdevice() is failed.")
Cc: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/vport-internal_dev.c | 8 ++------
 net/openvswitch/vport.c              | 9 +++++++++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index d2437b5..074c43f 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -159,7 +159,6 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
 	struct internal_dev *internal_dev;
 	struct net_device *dev;
 	int err;
-	bool free_vport = true;
 
 	vport = ovs_vport_alloc(0, &ovs_internal_vport_ops, parms);
 	if (IS_ERR(vport)) {
@@ -190,10 +189,8 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
 
 	rtnl_lock();
 	err = register_netdevice(vport->dev);
-	if (err) {
-		free_vport = false;
+	if (err)
 		goto error_unlock;
-	}
 
 	dev_set_promiscuity(vport->dev, 1);
 	rtnl_unlock();
@@ -207,8 +204,7 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
 error_free_netdev:
 	free_netdev(dev);
 error_free_vport:
-	if (free_vport)
-		ovs_vport_free(vport);
+	ovs_vport_free(vport);
 error:
 	return ERR_PTR(err);
 }
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 3fc38d1..281259a 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -157,11 +157,20 @@ struct vport *ovs_vport_alloc(int priv_size, const struct vport_ops *ops,
  */
 void ovs_vport_free(struct vport *vport)
 {
+	/* We should check whether vport is NULL.
+	 * We may free it again, for example in internal_dev_create
+	 * if register_netdevice fails, vport may have been freed via
+	 * internal_dev_destructor.
+	 */
+	if (unlikely(!vport))
+		return;
+
 	/* vport is freed from RCU callback or error path, Therefore
 	 * it is safe to use raw dereference.
 	 */
 	kfree(rcu_dereference_raw(vport->upcall_portids));
 	kfree(vport);
+	vport = NULL;
 }
 EXPORT_SYMBOL_GPL(ovs_vport_free);
 
-- 
1.8.3.1

