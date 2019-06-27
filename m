Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20487575E6
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfF0Adb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727237AbfF0Ada (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:33:30 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94DE020815;
        Thu, 27 Jun 2019 00:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595609;
        bh=Z+shlkBQ8wdolk7PdrDWnw2HVrwoukW1lc4Rr9oYFNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yI3VQ3i/7+Fp7SyqLBPM53mXMPkR4vaX/pU3UZy6YrgiRLlQFjYzl6eK0RJoeqUgb
         YaVjSk6AZfvrwqQCIhlSdmTHrHgZlTyPDS8Fzu2idjBvJRQZpbCB0v1cGG5CUIOTAT
         yVvCSUyyLqiaNCzIVMFLpeMQ1uAPpeYXZMXx6+gc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Maximets <i.maximets@samsung.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 54/95] xdp: check device pointer before clearing
Date:   Wed, 26 Jun 2019 20:29:39 -0400
Message-Id: <20190627003021.19867-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilya Maximets <i.maximets@samsung.com>

[ Upstream commit 01d76b5317003e019ace561a9b775f51aafdfdc4 ]

We should not call 'ndo_bpf()' or 'dev_put()' with NULL argument.

Fixes: c9b47cc1fabc ("xsk: fix bug when trying to use both copy and zero-copy on one queue id")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xdp_umem.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 989e52386c35..2f7e2c33a812 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -143,6 +143,9 @@ static void xdp_umem_clear_dev(struct xdp_umem *umem)
 	struct netdev_bpf bpf;
 	int err;
 
+	if (!umem->dev)
+		return;
+
 	if (umem->zc) {
 		bpf.command = XDP_SETUP_XSK_UMEM;
 		bpf.xsk.umem = NULL;
@@ -156,11 +159,9 @@ static void xdp_umem_clear_dev(struct xdp_umem *umem)
 			WARN(1, "failed to disable umem!\n");
 	}
 
-	if (umem->dev) {
-		rtnl_lock();
-		xdp_clear_umem_at_qid(umem->dev, umem->queue_id);
-		rtnl_unlock();
-	}
+	rtnl_lock();
+	xdp_clear_umem_at_qid(umem->dev, umem->queue_id);
+	rtnl_unlock();
 
 	if (umem->zc) {
 		dev_put(umem->dev);
-- 
2.20.1

