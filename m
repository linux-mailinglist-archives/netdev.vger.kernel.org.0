Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F254F724A
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 04:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239558AbiDGCuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 22:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239551AbiDGCua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 22:50:30 -0400
Received: from m15113.mail.126.com (m15113.mail.126.com [220.181.15.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B21D9F3A6D;
        Wed,  6 Apr 2022 19:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=QXnRa
        D7mRT0jT5JH9It4+OfYC4DGL6dfmM1/qPq2+Ok=; b=GFjZyxJWdOnBxqH6x29/u
        rBrwbpoMkh0owWV5DX7XXW6bnyCk4YBQiVJETAsO6dYmtwU/4pu9mXiCyXrEHwcM
        J57OHJ/Zfl44Qc5HGIq7Tg2vhrfyKCCrPjkNdHXHCeyoOj1ULBKpRjfSRe5f4m/0
        hvm0zXJ8R61jD6HJWtZCWE=
Received: from localhost.localdomain (unknown [39.99.236.58])
        by smtp3 (Coremail) with SMTP id DcmowAB33ACKUE5ieqMuAA--.45798S2;
        Thu, 07 Apr 2022 10:46:35 +0800 (CST)
From:   Hongbin Wang <wh_bin@126.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     roopa@nvidia.com, edumazet@google.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vxlan: fix error return code in vxlan_fdb_append
Date:   Wed,  6 Apr 2022 22:46:22 -0400
Message-Id: <20220407024622.185179-1-wh_bin@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcmowAB33ACKUE5ieqMuAA--.45798S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFy5uF18Zr4rtFy5ZF1UZFb_yoW3XFg_C3
        Z29r17GFWYqwnrKr4UXFW3Zr90ya1F9F1vq3Za93y3Jr429r4qqr1xZFn3Xw1DGa1fA34x
        GFs3Ar93ArWYkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0oGQ3UUUUU==
X-Originating-IP: [39.99.236.58]
X-CM-SenderInfo: xzkbuxbq6rjloofrz/1tbi7gvboltC9xuPNQAAsT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kmalloc and dst_cache_init failed,
should return ENOMEM rather than ENOBUFS.

Signed-off-by: Hongbin Wang <wh_bin@126.com>
---
 drivers/net/vxlan/vxlan_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index de97ff98d36e..8a5e3a6d32d7 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -651,11 +651,11 @@ static int vxlan_fdb_append(struct vxlan_fdb *f,
 
 	rd = kmalloc(sizeof(*rd), GFP_ATOMIC);
 	if (rd == NULL)
-		return -ENOBUFS;
+		return -ENOMEM;
 
 	if (dst_cache_init(&rd->dst_cache, GFP_ATOMIC)) {
 		kfree(rd);
-		return -ENOBUFS;
+		return -ENOMEM;
 	}
 
 	rd->remote_ip = *ip;
-- 
2.25.1

