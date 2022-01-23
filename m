Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E00496F33
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 01:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbiAWARO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 19:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236125AbiAWAPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 19:15:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4A2C061774;
        Sat, 22 Jan 2022 16:14:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C61F60FE3;
        Sun, 23 Jan 2022 00:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DA6C340E2;
        Sun, 23 Jan 2022 00:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896871;
        bh=B4b/v8rgLAQzM1fDet8n5dlholfeAY0dB3jJ34q97cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjzLE2KLkv6R63GH8JvIazeZ33btUg1HyaUncmlDdlbtXoGym9zWGlUmgzt+rID8O
         l2kfeU2o2J0F3PMmwl8ZPVh3csZVjFcEJa/4zahxrfiH1xXsKAkgvTvk0g2sVGxuQt
         kz66hc03lPSdtMwl38d4BWCkXQQCQK/sPY8aj8XV726MKXhFzvsZgQ1ogwW1+02U9F
         qrgFWyGsZrKvfLm3SPd5lbRXcb/7hDJ4wk5dCuzxoNmk55r1oXkT6lHTtVxj6ca81J
         DRYEN9F4u5NnIXhyRIlkLZYh3d0lkn8luoOcBCwhOBSvQlJw8jfvMj+2s8XXZRveiD
         RvjrKyAdRDxDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 4/4] vhost/test: fix memory leak of vhost virtqueues
Date:   Sat, 22 Jan 2022 19:14:21 -0500
Message-Id: <20220123001423.2461009-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001423.2461009-1-sashal@kernel.org>
References: <20220123001423.2461009-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xianting Tian <xianting.tian@linux.alibaba.com>

[ Upstream commit 080063920777af65105e5953e2851e036376e3ea ]

We need free the vqs in .release(), which are allocated in .open().

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
Link: https://lore.kernel.org/r/20211228030924.3468439-1-xianting.tian@linux.alibaba.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 682fc58e1f752..3abe6833be88e 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -166,6 +166,7 @@ static int vhost_test_release(struct inode *inode, struct file *f)
 	/* We do an extra flush before freeing memory,
 	 * since jobs can re-queue themselves. */
 	vhost_test_flush(n);
+	kfree(n->dev.vqs);
 	kfree(n);
 	return 0;
 }
-- 
2.34.1

