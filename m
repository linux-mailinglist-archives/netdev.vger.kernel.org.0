Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B7C39D347
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 05:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhFGDKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 23:10:50 -0400
Received: from m12-18.163.com ([220.181.12.18]:33842 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230127AbhFGDKq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Jun 2021 23:10:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=NJyv4
        cJvzWTV0Z6UppUARpGUFXFp+OeC5caDPgArcl4=; b=Dm+0O/73UR+TxReruze0h
        2Ptm/HOqAB637CF7sIZB72cy/QAlfk8TDBd2e/kzzKeOkUXSB9mKRQIJ+D7OVHQ2
        FUGbc/hxaStqTQHrKvBeK4yqKjhNm7WBqNPUXqDu+ckyZCqMbRaQQ70DcsEZiLMA
        ekMjmXeeaTH9v6TLPtNAEo=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp14 (Coremail) with SMTP id EsCowAB3feW7jb1gKwrcnw--.39184S2;
        Mon, 07 Jun 2021 11:08:44 +0800 (CST)
From:   13145886936@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] vlan: Avoid crashing the kernel
Date:   Sun,  6 Jun 2021 20:08:39 -0700
Message-Id: <20210607030839.374323-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowAB3feW7jb1gKwrcnw--.39184S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruF1kZF15Zw18urW8KF17KFg_yoWDArg_W3
        97Kr1UKw4DAan2yw45W3yIvr9rAw109r4xX3WxArW7try8ArZ0kr18Z3W3Jr1a9rW8ur9r
        GFn2vr93Cr97tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUeGFAJUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiQhyqg1aD-Kmt2QAAsD
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Avoid crashing the kernel, try using WARN_ON & recovery code
rather than BUG() or BUG_ON().

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/8021q/vlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 4cdf8416869d..6e784fd8795b 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -97,7 +97,7 @@ void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
 	ASSERT_RTNL();
 
 	vlan_info = rtnl_dereference(real_dev->vlan_info);
-	BUG_ON(!vlan_info);
+	WARN_ON(!vlan_info);
 
 	grp = &vlan_info->grp;
 
@@ -163,7 +163,7 @@ int register_vlan_dev(struct net_device *dev, struct netlink_ext_ack *extack)
 
 	vlan_info = rtnl_dereference(real_dev->vlan_info);
 	/* vlan_info should be there now. vlan_vid_add took care of it */
-	BUG_ON(!vlan_info);
+	WARN_ON(!vlan_info);
 
 	grp = &vlan_info->grp;
 	if (grp->nr_vlan_devs == 0) {
-- 
2.25.1


