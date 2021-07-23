Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D743D32E0
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 05:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbhGWDSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 23:18:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234222AbhGWDSF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 23:18:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9456360F44;
        Fri, 23 Jul 2021 03:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012718;
        bh=Fvu85sAjs319dWKeZiap0oOOGT1ZpqeMqQ0Tf/uMgwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIK+dZq53yswn3+rdKLeCFNr2Vow2DHhVxK7M99eGzQFptczoR5SaOvfzs+k8a0GU
         hHRV8bfHjsWOpepI+13ckn6Eeid4Er6r8gEMPCaCfzKouV+cbwGFhhSxeqoU3zYz5b
         HIgk8h19derExlWAo1Q2IvFAhQLHmsmixkziFqhEc9uhrMV33aPoitlLdcnp01yCHe
         ncdiJ5kOZ+xRWRkbCdHneehTG7mcspjPzSpkSzDmCN4txqEullY3JStWGTuP8inGlP
         s+orgVZTei/X9zXcwMRL06CUQ5/p35Y1hkS1dsd4EuTm2fs7gja4lM25ncGY5mUAcC
         jCMZQtoKMBW4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/11] net/802/garp: fix memleak in garp_request_join()
Date:   Thu, 22 Jul 2021 23:58:26 -0400
Message-Id: <20210723035835.532148-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035835.532148-1-sashal@kernel.org>
References: <20210723035835.532148-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 42ca63f980842918560b25f0244307fd83b4777c ]

I got kmemleak report when doing fuzz test:

BUG: memory leak
unreferenced object 0xffff88810c909b80 (size 64):
  comm "syz", pid 957, jiffies 4295220394 (age 399.090s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 08 00 00 00 01 02 00 04  ................
  backtrace:
    [<00000000ca1f2e2e>] garp_request_join+0x285/0x3d0
    [<00000000bf153351>] vlan_gvrp_request_join+0x15b/0x190
    [<0000000024005e72>] vlan_dev_open+0x706/0x980
    [<00000000dc20c4d4>] __dev_open+0x2bb/0x460
    [<0000000066573004>] __dev_change_flags+0x501/0x650
    [<0000000035b42f83>] rtnl_configure_link+0xee/0x280
    [<00000000a5e69de0>] __rtnl_newlink+0xed5/0x1550
    [<00000000a5258f4a>] rtnl_newlink+0x66/0x90
    [<00000000506568ee>] rtnetlink_rcv_msg+0x439/0xbd0
    [<00000000b7eaeae1>] netlink_rcv_skb+0x14d/0x420
    [<00000000c373ce66>] netlink_unicast+0x550/0x750
    [<00000000ec74ce74>] netlink_sendmsg+0x88b/0xda0
    [<00000000381ff246>] sock_sendmsg+0xc9/0x120
    [<000000008f6a2db3>] ____sys_sendmsg+0x6e8/0x820
    [<000000008d9c1735>] ___sys_sendmsg+0x145/0x1c0
    [<00000000aa39dd8b>] __sys_sendmsg+0xfe/0x1d0

Calling garp_request_leave() after garp_request_join(), the attr->state
is set to GARP_APPLICANT_VO, garp_attr_destroy() won't be called in last
transmit event in garp_uninit_applicant(), the attr of applicant will be
leaked. To fix this leak, iterate and free each attr of applicant before
rerturning from garp_uninit_applicant().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/802/garp.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/802/garp.c b/net/802/garp.c
index 7f50d47470bd..8e19f51833d6 100644
--- a/net/802/garp.c
+++ b/net/802/garp.c
@@ -206,6 +206,19 @@ static void garp_attr_destroy(struct garp_applicant *app, struct garp_attr *attr
 	kfree(attr);
 }
 
+static void garp_attr_destroy_all(struct garp_applicant *app)
+{
+	struct rb_node *node, *next;
+	struct garp_attr *attr;
+
+	for (node = rb_first(&app->gid);
+	     next = node ? rb_next(node) : NULL, node != NULL;
+	     node = next) {
+		attr = rb_entry(node, struct garp_attr, node);
+		garp_attr_destroy(app, attr);
+	}
+}
+
 static int garp_pdu_init(struct garp_applicant *app)
 {
 	struct sk_buff *skb;
@@ -612,6 +625,7 @@ void garp_uninit_applicant(struct net_device *dev, struct garp_application *appl
 
 	spin_lock_bh(&app->lock);
 	garp_gid_event(app, GARP_EVENT_TRANSMIT_PDU);
+	garp_attr_destroy_all(app);
 	garp_pdu_queue(app);
 	spin_unlock_bh(&app->lock);
 
-- 
2.30.2

