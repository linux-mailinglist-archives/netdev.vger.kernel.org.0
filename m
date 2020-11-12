Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AC02AFF89
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 07:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgKLGMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 01:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbgKLGMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 01:12:20 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C549CC0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 22:12:20 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id w6so3562956pfu.1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 22:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FHs6zieQRsrlBczzhIrz4lwm76YMszXTvMnFZ/QAhwo=;
        b=nDwsCVFqt6o2XS9meXwElwWZaK7GSFxgU6ZX/w1JzBhLqjFEbatjDBWuf6tBBoCOwe
         DA/A6USTGhvy4G5aCGY2v4+kvqqT97gKu70SwdPqO01UTNBfYauXKtygcqqKY0bSqx7O
         I/PWFlAI7zgMNrDEHr+CUwunDQuibRlcWthrw8ZveEKT20UHkWEv+HycQKOwKAPLbQeV
         Kc56zRP1gpeLLDf+P+XoLAv+ix4m8U7ziibtxxi8J0H7nl5wGJ1gonIVQgwUBXH2vqDV
         i6BnpZbF3F4Eiygn+L+Ove1xFcxrRs7vY6fWsZ86wSoXSArOPwSa2LD/qh9q51ZYCeNH
         sycQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=FHs6zieQRsrlBczzhIrz4lwm76YMszXTvMnFZ/QAhwo=;
        b=hXGmyLcLQACqUalTr9uNL4PAKl13if0Kc1K479q8RlzCe0fVZZqzN/H7zaldUZdr5g
         XLY7WsOTg03oZmj4ywzulQ5MGvxYgRAt7/MQUWVeWFIKjZZYMHhOzNt+Mj7UsdTC/5DH
         E6Wywwd5sGgI+EIjQA4Jq17L7+vH3R16VUco0kIEwlLERkYSdI49xxk0kjMaqdzrnMW3
         AcWP7y8JzgzoRCEF+ZlVBja0Dob4lZ5TE9vXgkhI6MW/9LrXzgHrSa7hddxQk+GhxaM8
         B9SgEpuDqweIm01al4e8zgHMcn5b3c8IZ/a+KZuYUjnR+1Qp+27ps8GYkgxLnSY7Sgcs
         6gew==
X-Gm-Message-State: AOAM532QYhPThZigsvyIjV8DDA3KD8KpxHRbUHCrTNFFVWthV1+WGGbh
        js2ZLmDtuInIEUdxvyIc0K7zeBpu5VcfhbrU
X-Google-Smtp-Source: ABdhPJySRUxwya3lW7eirK3Z96lqaFS+smXiv+MRqNuY/kW/Ceie3YaDt8hElvJeuyodCTseZrae3Q==
X-Received: by 2002:a17:90b:188b:: with SMTP id mn11mr2193367pjb.125.1605161540288;
        Wed, 11 Nov 2020 22:12:20 -0800 (PST)
Received: from localhost.localdomain ([45.124.203.14])
        by smtp.gmail.com with ESMTPSA id n64sm4906564pfn.134.2020.11.11.22.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 22:12:19 -0800 (PST)
Sender: "joel.stan@gmail.com" <joel.stan@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Jeffery <andrew@aj.id.au>, netdev@vger.kernel.org
Subject: [PATCH v2] net/ncsi: Fix netlink registration
Date:   Thu, 12 Nov 2020 16:42:10 +1030
Message-Id: <20201112061210.914621-1-joel@jms.id.au>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a user unbinds and re-binds a NC-SI aware driver the kernel will
attempt to register the netlink interface at runtime. The structure is
marked __ro_after_init so registration fails spectacularly at this point.

 # echo 1e660000.ethernet > /sys/bus/platform/drivers/ftgmac100/unbind
 # echo 1e660000.ethernet > /sys/bus/platform/drivers/ftgmac100/bind
  ftgmac100 1e660000.ethernet: Read MAC address 52:54:00:12:34:56 from chip
  ftgmac100 1e660000.ethernet: Using NCSI interface
  8<--- cut here ---
  Unable to handle kernel paging request at virtual address 80a8f858
  pgd = 8c768dd6
  [80a8f858] *pgd=80a0841e(bad)
  Internal error: Oops: 80d [#1] SMP ARM
  CPU: 0 PID: 116 Comm: sh Not tainted 5.10.0-rc3-next-20201111-00003-gdd25b227ec1e #51
  Hardware name: Generic DT based system
  PC is at genl_register_family+0x1f8/0x6d4
  LR is at 0xff26ffff
  pc : [<8073f930>]    lr : [<ff26ffff>]    psr: 20000153
  sp : 8553bc80  ip : 81406244  fp : 8553bd04
  r10: 8085d12c  r9 : 80a8f73c  r8 : 85739000
  r7 : 00000017  r6 : 80a8f860  r5 : 80c8ab98  r4 : 80a8f858
  r3 : 00000000  r2 : 00000000  r1 : 81406130  r0 : 00000017
  Flags: nzCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment none
  Control: 00c5387d  Table: 85524008  DAC: 00000051
  Process sh (pid: 116, stack limit = 0x1f1988d6)
 ...
  Backtrace:
  [<8073f738>] (genl_register_family) from [<80860ac0>] (ncsi_init_netlink+0x20/0x48)
   r10:8085d12c r9:80c8fb0c r8:85739000 r7:00000000 r6:81218000 r5:85739000
   r4:8121c000
  [<80860aa0>] (ncsi_init_netlink) from [<8085d740>] (ncsi_register_dev+0x1b0/0x210)
   r5:8121c400 r4:8121c000
  [<8085d590>] (ncsi_register_dev) from [<805a8060>] (ftgmac100_probe+0x6e0/0x778)
   r10:00000004 r9:80950228 r8:8115bc10 r7:8115ab00 r6:9eae2c24 r5:813b6f88
   r4:85739000
  [<805a7980>] (ftgmac100_probe) from [<805355ec>] (platform_drv_probe+0x58/0xa8)
   r9:80c76bb0 r8:00000000 r7:80cd4974 r6:80c76bb0 r5:8115bc10 r4:00000000
  [<80535594>] (platform_drv_probe) from [<80532d58>] (really_probe+0x204/0x514)
   r7:80cd4974 r6:00000000 r5:80cd4868 r4:8115bc10

Jakub pointed out that ncsi_register_dev is obviously broken, because
there is only one family so it would never work if there was more than
one ncsi netdev.

Fix the crash by registering the netlink family once on boot, and drop
the code to unregister it.

Fixes: 955dc68cb9b2 ("net/ncsi: Add generic netlink family")
Signed-off-by: Joel Stanley <joel@jms.id.au>
---
v2: Implement Jakub's suggestion
 - drop __ro_after_init change
 - register netlink with subsys_intcall
 - remove unregister function

 net/ncsi/ncsi-manage.c  |  5 -----
 net/ncsi/ncsi-netlink.c | 22 +++-------------------
 net/ncsi/ncsi-netlink.h |  3 ---
 3 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index f1be3e3f6425..a9cb355324d1 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -1726,9 +1726,6 @@ struct ncsi_dev *ncsi_register_dev(struct net_device *dev,
 	ndp->ptype.dev = dev;
 	dev_add_pack(&ndp->ptype);
 
-	/* Set up generic netlink interface */
-	ncsi_init_netlink(dev);
-
 	pdev = to_platform_device(dev->dev.parent);
 	if (pdev) {
 		np = pdev->dev.of_node;
@@ -1892,8 +1889,6 @@ void ncsi_unregister_dev(struct ncsi_dev *nd)
 	list_del_rcu(&ndp->node);
 	spin_unlock_irqrestore(&ncsi_dev_lock, flags);
 
-	ncsi_unregister_netlink(nd->dev);
-
 	kfree(ndp);
 }
 EXPORT_SYMBOL_GPL(ncsi_unregister_dev);
diff --git a/net/ncsi/ncsi-netlink.c b/net/ncsi/ncsi-netlink.c
index adddc7707aa4..bb5f1650f11c 100644
--- a/net/ncsi/ncsi-netlink.c
+++ b/net/ncsi/ncsi-netlink.c
@@ -766,24 +766,8 @@ static struct genl_family ncsi_genl_family __ro_after_init = {
 	.n_small_ops = ARRAY_SIZE(ncsi_ops),
 };
 
-int ncsi_init_netlink(struct net_device *dev)
+static int __init ncsi_init_netlink(void)
 {
-	int rc;
-
-	rc = genl_register_family(&ncsi_genl_family);
-	if (rc)
-		netdev_err(dev, "ncsi: failed to register netlink family\n");
-
-	return rc;
-}
-
-int ncsi_unregister_netlink(struct net_device *dev)
-{
-	int rc;
-
-	rc = genl_unregister_family(&ncsi_genl_family);
-	if (rc)
-		netdev_err(dev, "ncsi: failed to unregister netlink family\n");
-
-	return rc;
+	return genl_register_family(&ncsi_genl_family);
 }
+subsys_initcall(ncsi_init_netlink);
diff --git a/net/ncsi/ncsi-netlink.h b/net/ncsi/ncsi-netlink.h
index 7502723fba83..39a1a9d7bf77 100644
--- a/net/ncsi/ncsi-netlink.h
+++ b/net/ncsi/ncsi-netlink.h
@@ -22,7 +22,4 @@ int ncsi_send_netlink_err(struct net_device *dev,
 			  struct nlmsghdr *nlhdr,
 			  int err);
 
-int ncsi_init_netlink(struct net_device *dev);
-int ncsi_unregister_netlink(struct net_device *dev);
-
 #endif /* __NCSI_NETLINK_H__ */
-- 
2.28.0

