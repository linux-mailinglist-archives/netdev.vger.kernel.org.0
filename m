Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0A0496EB4
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 01:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235714AbiAWANx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 19:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235509AbiAWANH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 19:13:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59A7C061763;
        Sat, 22 Jan 2022 16:12:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62F1660F9F;
        Sun, 23 Jan 2022 00:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC00CC004E1;
        Sun, 23 Jan 2022 00:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896726;
        bh=94AMPHSOMB0HPZgdjyDj+IRBX/Gt+wzDLbqEMbirc/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rwrJd8KLZSnIzRgkjXd3GfgjzYubVes9RhCi6gigpRvb1LR/hVt9yvC75/+XyckEN
         NWebGCH6zlNmGKaDw2o8hudWR9bLdb3UxTYWqA7LY31jOOTY6UlY5SATD8E4TtcP2V
         +1lE6lJn9yiq25ZrULC9ioTQr4crNLjcGCZbxqvuE74fy9ukkHtYTguMFITYpMkVoJ
         KfDHK+hGOYaabQwNq6DDF2tAO9XwbS23kHYK900edcmUOET2LFUTa42hQOwWhzMFBw
         XnZcAVCrE0/XR1s5YUS60V5T4dpjbrIvU3dtttwTJHPyOFi+xen7hjbi5TN+wr8Klk
         pWn4rWrF2Ja9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 15/19] vhost/test: fix memory leak of vhost virtqueues
Date:   Sat, 22 Jan 2022 19:11:08 -0500
Message-Id: <20220123001113.2460140-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001113.2460140-1-sashal@kernel.org>
References: <20220123001113.2460140-1-sashal@kernel.org>
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
index a09dedc79f682..05740cba1cd89 100644
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

