Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82351F27A5
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 07:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfKGGah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 01:30:37 -0500
Received: from mail-m974.mail.163.com ([123.126.97.4]:55064 "EHLO
        mail-m974.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfKGGah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 01:30:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=v/B2ToBpKvai59daRL
        vVEWSvI0l4Py53TzTQJCqwvY4=; b=ZyzDE7CMx/26AcilhkRkb8FnIdJj+f91rb
        3M7lm5tp2CIoMVz/mzhBkKdupchxo6bfGb7RxmjMNZasOQ/7WnxK9USR6h41npcj
        WsiqUbipL/DAZvskwmA4MCAbQDHiHnDUVY8sksgthZlFoqsdNcB952vNOLTaIWHo
        IiJO7+SW0=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp4 (Coremail) with SMTP id HNxpCgD3dtviucNdteMLBg--.305S3;
        Thu, 07 Nov 2019 14:30:03 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Steve Winslow <swinslow@gmail.com>,
        Young Xiao <92siuyang@gmail.com>,
        Allison Randal <allison@lohutok.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrey Konovalov <andreyknvl@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: [PATCH v2] nfc: netlink: fix double device reference drop
Date:   Thu,  7 Nov 2019 14:29:50 +0800
Message-Id: <1573108190-30836-1-git-send-email-bianpan2016@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: HNxpCgD3dtviucNdteMLBg--.305S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrKw17Zr1xuF47JF4UtF18Zrb_yoWfXFcEy3
        4rtr4UWrn8X3s3Ja12kw4UAF9FywnFqr4xCF4SkrWxZa45Zan8uw4kZ39xAry7uw43AFWj
        q3WkJrW8t347XjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbEoGJUUUUU==
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/xtbBZAtmclQHHg832AAAsW
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function nfc_put_device(dev) is called twice to drop the reference
to dev when there is no associated local llcp. Remove one of them to fix
the bug.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
v2: change subject of the patch
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

