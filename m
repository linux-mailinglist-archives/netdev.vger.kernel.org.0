Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAED23558B
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 07:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgHBFH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 01:07:27 -0400
Received: from bmailout2.hostsharing.net ([83.223.78.240]:56537 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgHBFH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 01:07:26 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 8860F28001567;
        Sun,  2 Aug 2020 07:07:21 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 4FF59497F9; Sun,  2 Aug 2020 07:07:21 +0200 (CEST)
Message-Id: <086b426f44bc24360cc89476fe18d2758a2652af.1596344622.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Sun, 2 Aug 2020 07:06:51 +0200
Subject: [PATCH] appletalk: Fix atalk_proc_init() return path
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vincent Duvert <vincent.ldev@duvert.net>,
        Christopher KOBAYASHI <chris@disavowed.jp>,
        Doug Brown <doug@downtowndougbrown.com>,
        Yue Haibing <yuehaibing@huawei.com>, netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Duvert <vincent.ldev@duvert.net>

Add a missing return statement to atalk_proc_init so it doesn't return
-ENOMEM when successful.  This allows the appletalk module to load
properly.

Fixes: e2bcd8b0ce6e ("appletalk: use remove_proc_subtree to simplify procfs code")
Link: https://www.downtowndougbrown.com/2020/08/hacking-up-a-fix-for-the-broken-appletalk-kernel-module-in-linux-5-1-and-newer/
Reported-by: Christopher KOBAYASHI <chris@disavowed.jp>
Reported-by: Doug Brown <doug@downtowndougbrown.com>
Signed-off-by: Vincent Duvert <vincent.ldev@duvert.net>
[lukas: add missing tags]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v5.1+
Cc: Yue Haibing <yuehaibing@huawei.com>
---
 net/appletalk/atalk_proc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/appletalk/atalk_proc.c b/net/appletalk/atalk_proc.c
index 550c6ca..9c12412 100644
--- a/net/appletalk/atalk_proc.c
+++ b/net/appletalk/atalk_proc.c
@@ -229,6 +229,8 @@ int __init atalk_proc_init(void)
 				     sizeof(struct aarp_iter_state), NULL))
 		goto out;
 
+	return 0;
+
 out:
 	remove_proc_subtree("atalk", init_net.proc_net);
 	return -ENOMEM;
-- 
2.27.0

