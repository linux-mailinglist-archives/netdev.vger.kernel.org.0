Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B11E3F15C9
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 13:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731302AbfKFMGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 07:06:33 -0500
Received: from mail-m974.mail.163.com ([123.126.97.4]:40188 "EHLO
        mail-m974.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbfKFMGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 07:06:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=Vr1zZkluBVeJrHuU4L
        oH+uAdM8J2JP009UinrAaYrkk=; b=IH/zE42XaquMymAOrs1ebHEYcAmTE4V0td
        2QaFDYohsYAVraIkL8Ij8gboyNEepR1Cu4kbQbB/DZRVP1bM4JOGSthfiGh5Rmi2
        zXrtu+rkZzk0KTgx2HVUHjBazoaJNKAzcFZWgScOV62qvPy6BULZ106ClyoT15I8
        iN/7Cg1lg=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp4 (Coremail) with SMTP id HNxpCgDXHMQft8Jdb7mVBQ--.101S3;
        Wed, 06 Nov 2019 20:05:54 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Jilayne Lovejoy <opensource@jilayne.com>,
        Steve Winslow <swinslow@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Young Xiao <92siuyang@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: [PATCH] netlink: fix double drop dev reference
Date:   Wed,  6 Nov 2019 20:05:43 +0800
Message-Id: <1573041943-9316-1-git-send-email-bianpan2016@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: HNxpCgDXHMQft8Jdb7mVBQ--.101S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrKw17Zr1xuF4kXr1ktFy3XFb_yoW3KFgEy3
        4rtr4UWrs8X393JanFkw4UAF9Ivw12qr4xAF4SkrWxZay5Xan8uw4kZ39xAry7uw43AFW7
        X3WkJrW8t347XjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1bTmJUUUUU==
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/1tbiVAJlclUMK-Z-5gAAsc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function nfc_put_device(dev) is called twice to drop the reference
to dev when there is no associated local llcp. Remove one of them to fix
the bug.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 net/nfc/netlink.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 17e6ca62f1be..afde0d763039 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1099,7 +1099,6 @@ static int nfc_genl_llc_set_params(struct sk_buff *skb, struct genl_info *info)
 
 	local = nfc_llcp_find_local(dev);
 	if (!local) {
-		nfc_put_device(dev);
 		rc = -ENODEV;
 		goto exit;
 	}
@@ -1159,7 +1158,6 @@ static int nfc_genl_llc_sdreq(struct sk_buff *skb, struct genl_info *info)
 
 	local = nfc_llcp_find_local(dev);
 	if (!local) {
-		nfc_put_device(dev);
 		rc = -ENODEV;
 		goto exit;
 	}
-- 
2.7.4

