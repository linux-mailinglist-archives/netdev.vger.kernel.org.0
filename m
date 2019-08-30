Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32681A2ED8
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 07:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfH3FXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 01:23:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58806 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbfH3FXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 01:23:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C3CDB61B23; Fri, 30 Aug 2019 05:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567142616;
        bh=wU9LXwwrtw6Y4MVGV8bKagIYuC69Nr8gtbRGHP9Xxdc=;
        h=From:To:Cc:Subject:Date:From;
        b=PqDJH57KabhIo8olx0gJWDRR1PfxGVuTau+v8sHE27aHqp0xGRNYtXV9Ox4vMaES7
         Eu7wVk2Ge1MOG0TmwZptRdBHievFGm1Vb90bEfjrX7UzNyyYZLhLgoGBTmMWnUU3WX
         rsfTxW7ul6wFI8hga5NggULVLDInWD77PxNbh1g0=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 39FD861D46;
        Fri, 30 Aug 2019 05:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567142615;
        bh=wU9LXwwrtw6Y4MVGV8bKagIYuC69Nr8gtbRGHP9Xxdc=;
        h=From:To:Cc:Subject:Date:From;
        b=n7bbfyrlMI6XCkgwiKMjxl6KkdjzziI9lBuhZmDXTc6nx/vrz1o6d18aPvamkrXoi
         WxA+dF/7elKFb5HXp/JgGoiOSNfKZnvCCXS4iyJ1U9KhP2PKvyVFRwv+jF9nWCJRiE
         9H+x5lyeElVXzowSeDAkvOnV59f0yaJ4+vjzeHVE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 39FD861D46
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     eric.dumazet@gmail.com, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: [PATCH net] dev: Delay the free of the percpu refcount
Date:   Thu, 29 Aug 2019 23:23:16 -0600
Message-Id: <1567142596-25923-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While running stress-ng on an ARM64 kernel, the following oops
was observedi -

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

Prior to this, it appeared as if some of the inet6_dev allocations
were failing. From the memory dump, the last operation performed
was dev_put(), however the pcpu_refcnt was NULL while the
reg_state = NETREG_RELEASED. Effectively, the refcount memory was
freed in free_netdev() before the last reference was dropped.

Fix this by freeing the memory after all references are dropped and
before the dev memory itself is freed.

Fixes: 29b4433d991c ("net: percpu net_device refcount")
Cc: Sean Tranchetti <stranche@codeaurora.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 net/core/dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 49589ed..bce40d8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9128,6 +9128,9 @@ void netdev_freemem(struct net_device *dev)
 {
 	char *addr = (char *)dev - dev->padded;
 
+	free_percpu(dev->pcpu_refcnt);
+	dev->pcpu_refcnt = NULL;
+
 	kvfree(addr);
 }
 
@@ -9272,9 +9275,6 @@ void free_netdev(struct net_device *dev)
 	list_for_each_entry_safe(p, n, &dev->napi_list, dev_list)
 		netif_napi_del(p);
 
-	free_percpu(dev->pcpu_refcnt);
-	dev->pcpu_refcnt = NULL;
-
 	/*  Compatibility with error handling in drivers */
 	if (dev->reg_state == NETREG_UNINITIALIZED) {
 		netdev_freemem(dev);
-- 
1.9.1

