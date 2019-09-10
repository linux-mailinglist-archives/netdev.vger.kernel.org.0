Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 300CEAF225
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 22:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbfIJUDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 16:03:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36388 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfIJUDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 16:03:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 459066050D; Tue, 10 Sep 2019 20:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568145801;
        bh=rTk2AboRcVI9XJV9xBDexev/F1Ui4aP17kbTJ96p26o=;
        h=From:To:Cc:Subject:Date:From;
        b=ApS9vCdQGO0c8MjsixY2DVkSagQ/8IbMy7BgBvRjhMAZMSFvBtOytvqVhBkHYE/Jz
         sLw2NkuKolyj7+5MljQYc4GTq1pdvVwGA+CwAVXgyeDohkLFWyasoSxfykab9dxeUi
         9jBA3E+QZiqhQT+JNN38h0TwF+nmcu8Pioh+M/h4=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 04F826050D;
        Tue, 10 Sep 2019 20:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568145800;
        bh=rTk2AboRcVI9XJV9xBDexev/F1Ui4aP17kbTJ96p26o=;
        h=From:To:Cc:Subject:Date:From;
        b=Rp9wm8YcewZjEEzZer2XmPBTw1nQCd+a2aJzRJFv6MCgM2OvBSO/HwWyEj6N6Z+9d
         FqS+V/tSFCIH2SArAuk5XrkbqAP98iy3ayVwIOKqy8btjjf3BRFIFdVDGjmB3pGaUA
         o5TOPfkQ1vXP9WqwiKHxkQiqBUTEFrPvh6ZVWS0c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 04F826050D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     dlezcano@fr.ibm.com, eric.dumazet@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: [PATCH net] net: Fix null de-reference of device refcount
Date:   Tue, 10 Sep 2019 14:02:57 -0600
Message-Id: <1568145777-29480-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In event of failure during register_netdevice, free_netdev is
invoked immediately. free_netdev assumes that all the netdevice
refcounts have been dropped prior to it being called and as a
result frees and clears out the refcount pointer.

However, this is not necessarily true as some of the operations
in the NETDEV_UNREGISTER notifier handlers queue RCU callbacks for
invocation after a grace period. The IPv4 callback in_dev_rcu_put
tries to access the refcount after free_netdev is called which
leads to a null de-reference-

44837.761523:   <6> Unable to handle kernel paging request at
                    virtual address 0000004a88287000
44837.761651:   <2> pc : in_dev_finish_destroy+0x4c/0xc8
44837.761654:   <2> lr : in_dev_finish_destroy+0x2c/0xc8
44837.762393:   <2> Call trace:
44837.762398:   <2>  in_dev_finish_destroy+0x4c/0xc8
44837.762404:   <2>  in_dev_rcu_put+0x24/0x30
44837.762412:   <2>  rcu_nocb_kthread+0x43c/0x468
44837.762418:   <2>  kthread+0x118/0x128
44837.762424:   <2>  ret_from_fork+0x10/0x1c

Fix this by waiting for the completion of the call_rcu() in
case of register_netdevice errors.

Fixes: 93ee31f14f6f ("[NET]: Fix free_netdev on register_netdev failure.")
Cc: Sean Tranchetti <stranche@codeaurora.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 49589ed..c7463c9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8796,6 +8796,8 @@ int register_netdevice(struct net_device *dev)
 	ret = notifier_to_errno(ret);
 	if (ret) {
 		rollback_registered(dev);
+		rcu_barrier();
+
 		dev->reg_state = NETREG_UNREGISTERED;
 	}
 	/*
-- 
1.9.1

