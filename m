Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC09E496EE6
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 01:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235780AbiAWAPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 19:15:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38464 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235785AbiAWAOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 19:14:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A1CA60F77;
        Sun, 23 Jan 2022 00:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CC9C340E4;
        Sun, 23 Jan 2022 00:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896850;
        bh=fXf8Fd4OrvDlxT5Apz9FOpWMoCpLeg9hl45JTALhEj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jYuM55LB6qXalLDuLOY40kN/wouOxTM4m97Csnk4vtZIiScLjsqlOUnT5FH0Wwx/d
         v7LECX/9BTL2w+2BxklG8ngyuObSrvSQNBu13/kR7cmeaVMidnvL+0e/RmyvTAtnfv
         Z1qNZLFBfN+xCCCrLkfVTstXmGb64/tFuAgb5prB82T+CwyuyTyZz3E/t7p4MsxNTP
         Q6Ap+8ugeq3V99kMdh46iRwtuRJI5mzIOWsspE+zkcEte+qFxT4YcvTtI/o4vLytRM
         Fs5If+0qPoLUOJsSlvsCNZqiBXWqwKOoIUhzFB9YQhF/CkfrCdkoCIPBaNgk7mmTJm
         SATeaEKrrtmSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 5/5] vhost/test: fix memory leak of vhost virtqueues
Date:   Sat, 22 Jan 2022 19:13:51 -0500
Message-Id: <20220123001353.2460870-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001353.2460870-1-sashal@kernel.org>
References: <20220123001353.2460870-1-sashal@kernel.org>
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
index 55090d9f9de0d..2d6abe1c0dbec 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -167,6 +167,7 @@ static int vhost_test_release(struct inode *inode, struct file *f)
 	/* We do an extra flush before freeing memory,
 	 * since jobs can re-queue themselves. */
 	vhost_test_flush(n);
+	kfree(n->dev.vqs);
 	kfree(n);
 	return 0;
 }
-- 
2.34.1

