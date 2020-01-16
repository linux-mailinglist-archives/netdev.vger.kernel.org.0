Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 257D513EAA3
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406143AbgAPRpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:45:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:36822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406125AbgAPRpO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:45:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24A7524782;
        Thu, 16 Jan 2020 17:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196713;
        bh=TLRigZLEMBxv/4Ur70nzzxOwCvGXq8R+1qUa6DFFK34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFbbPCmBW5emEDBq2h46KawHcqJvas2u3omYqjNJ6nClNYDX8qgvNAAk19foA9LMO
         0CTt8Ph27VHpjUbYOO58ODysvp/1VCeT7eLPpIW0esiitmFw9BwKY/4K18r2fQOjGp
         xeAiz5RRbsBUfe8fIledD2Wrxd9VFp5gecLxhgGM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 102/174] net/af_iucv: always register net_device notifier
Date:   Thu, 16 Jan 2020 12:41:39 -0500
Message-Id: <20200116174251.24326-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 06996c1d4088a0d5f3e7789d7f96b4653cc947cc ]

Even when running as VM guest (ie pr_iucv != NULL), af_iucv can still
open HiperTransport-based connections. For robust operation these
connections require the af_iucv_netdev_notifier, so register it
unconditionally.

Also handle any error that register_netdevice_notifier() returns.

Fixes: 9fbd87d41392 ("af_iucv: handle netdev events")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/af_iucv.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 5984cc35d508..3edffb7bf2a4 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2392,6 +2392,13 @@ static int afiucv_iucv_init(void)
 	return err;
 }
 
+static void afiucv_iucv_exit(void)
+{
+	device_unregister(af_iucv_dev);
+	driver_unregister(&af_iucv_driver);
+	pr_iucv->iucv_unregister(&af_iucv_handler, 0);
+}
+
 static int __init afiucv_init(void)
 {
 	int err;
@@ -2425,11 +2432,18 @@ static int __init afiucv_init(void)
 		err = afiucv_iucv_init();
 		if (err)
 			goto out_sock;
-	} else
-		register_netdevice_notifier(&afiucv_netdev_notifier);
+	}
+
+	err = register_netdevice_notifier(&afiucv_netdev_notifier);
+	if (err)
+		goto out_notifier;
+
 	dev_add_pack(&iucv_packet_type);
 	return 0;
 
+out_notifier:
+	if (pr_iucv)
+		afiucv_iucv_exit();
 out_sock:
 	sock_unregister(PF_IUCV);
 out_proto:
@@ -2443,12 +2457,11 @@ static int __init afiucv_init(void)
 static void __exit afiucv_exit(void)
 {
 	if (pr_iucv) {
-		device_unregister(af_iucv_dev);
-		driver_unregister(&af_iucv_driver);
-		pr_iucv->iucv_unregister(&af_iucv_handler, 0);
+		afiucv_iucv_exit();
 		symbol_put(iucv_if);
-	} else
-		unregister_netdevice_notifier(&afiucv_netdev_notifier);
+	}
+
+	unregister_netdevice_notifier(&afiucv_netdev_notifier);
 	dev_remove_pack(&iucv_packet_type);
 	sock_unregister(PF_IUCV);
 	proto_unregister(&iucv_proto);
-- 
2.20.1

