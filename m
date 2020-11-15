Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CD82B3372
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 11:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgKOKav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 05:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgKOKau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 05:30:50 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A080C0613D1
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 02:30:50 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id gi3so2595104pjb.3
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 02:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KlwQ+OPkLjCj9iFIqiqcLbQaiUChWFXgMezNPIm11mc=;
        b=loEGtqmIaIq4NrW+BzLwIHrdGuYO7+1hK95d1T1hN8kn34kEiMbD98SQW9e2O3nUaG
         Suig8l+2S9pBIJZfkj6oAMcP+xHNRbhoILjkGlSYPeE7OxrS+euzAPsCVcYU/3i/+BTS
         egJyOw//s/kNhNX7KjHYVCUEuEVR5MF+O/qeL5N3AUGnEuatLH11Ank6mCI7cyshUjFT
         6RmKt/XnYGavyMQRxD7E8CtwlpCHjo86MsFHo/vywB3o3Q4QylI5kogitf/iV/qx4a+B
         uJlVGlZHOFel3GPG3qHGrk+9quvJcTV9NgoRj4QHujo7mO8E+zvkX9HI4aeNuETyOfjY
         m4Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KlwQ+OPkLjCj9iFIqiqcLbQaiUChWFXgMezNPIm11mc=;
        b=VPAM8Yj7L/U5ZErqM797AetYxq11GjwjmcLievjluL2GWNH4CALVJMAB8j0BVlIIKQ
         PzAd40qURKqoP2nyFp1qHZV56pZz3CPA8QSsrP1z5sVSa2iwpduciTIVjS0JowOiTuV/
         COtkcLtgnzrc5zrrS2y0A4tzklnv5MzHE2Ew17tbnwV4ptPq0lQrKYoroByR5wOoxYYq
         VT/rap+uIP/I+bbRJmYZ0T44rQ2y7UloOhIJE3bv3zQgHX0CON8Wyuf/C6AmJsmMqd2F
         BUcLCNlMTEivrgknw2L6av+8FOqFyC5CtF0oWPHaUmWtt+Y2I0L9WRpkRSrIv5xNItEo
         Zy1g==
X-Gm-Message-State: AOAM5337DssfL5DctWhDo1Sn2N1uwVA3NP17lWobimLfdmfqo7y3pyaU
        1ubJvD6Z3wfh6SZ+ZlZ02Ck=
X-Google-Smtp-Source: ABdhPJxtgVJ6oPKaQ9m6iMBCkKN0Em8tP/S9CHw8vxji97KmmpLszcmoIG8mxCvrdJKmWVxov13o/Q==
X-Received: by 2002:a17:90a:9385:: with SMTP id q5mr11064117pjo.20.1605436249997;
        Sun, 15 Nov 2020 02:30:49 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.44])
        by smtp.gmail.com with ESMTPSA id h11sm14892144pfo.69.2020.11.15.02.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 02:30:49 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH v3 net] netdevsim: set .owner to THIS_MODULE
Date:   Sun, 15 Nov 2020 10:30:41 +0000
Message-Id: <20201115103041.30701-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 82c93a87bf8b ("netdevsim: implement couple of testing devlink health reporters")
Fixes: 424be63ad831 ("netdevsim: add UDP tunnel port offload support")
Fixes: 4418f862d675 ("netdevsim: implement support for devlink region and snapshots")
Fixes: d3cbb907ae57 ("netdevsim: add ACL trap reporting cookie as a metadata")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v3:
 - Separate from one big series

v2:
 - Change headline
 - Squash patches into per-driver/subsystem

 drivers/net/netdevsim/dev.c         | 2 ++
 drivers/net/netdevsim/health.c      | 1 +
 drivers/net/netdevsim/udp_tunnels.c | 1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index d07061417675..e7972e88ffe0 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -96,6 +96,7 @@ static const struct file_operations nsim_dev_take_snapshot_fops = {
 	.open = simple_open,
 	.write = nsim_dev_take_snapshot_write,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t nsim_dev_trap_fa_cookie_read(struct file *file,
@@ -188,6 +189,7 @@ static const struct file_operations nsim_dev_trap_fa_cookie_fops = {
 	.read = nsim_dev_trap_fa_cookie_read,
 	.write = nsim_dev_trap_fa_cookie_write,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
diff --git a/drivers/net/netdevsim/health.c b/drivers/net/netdevsim/health.c
index 62958b238d50..21e2974660e7 100644
--- a/drivers/net/netdevsim/health.c
+++ b/drivers/net/netdevsim/health.c
@@ -261,6 +261,7 @@ static const struct file_operations nsim_dev_health_break_fops = {
 	.open = simple_open,
 	.write = nsim_dev_health_break_write,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 int nsim_dev_health_init(struct nsim_dev *nsim_dev, struct devlink *devlink)
diff --git a/drivers/net/netdevsim/udp_tunnels.c b/drivers/net/netdevsim/udp_tunnels.c
index 6ab023acefd6..02dc3123eb6c 100644
--- a/drivers/net/netdevsim/udp_tunnels.c
+++ b/drivers/net/netdevsim/udp_tunnels.c
@@ -124,6 +124,7 @@ static const struct file_operations nsim_udp_tunnels_info_reset_fops = {
 	.open = simple_open,
 	.write = nsim_udp_tunnels_info_reset_write,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 int nsim_udp_tunnels_info_create(struct nsim_dev *nsim_dev,
-- 
2.17.1

