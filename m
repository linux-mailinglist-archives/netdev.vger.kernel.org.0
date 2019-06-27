Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89E84575F7
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbfF0AeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:34:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727986AbfF0AeO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:34:14 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51F6C21738;
        Thu, 27 Jun 2019 00:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595653;
        bh=BJMI6uh5TXibTvHIsacfwa/jIjDCymJ6D9xIhNW05Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i8BObNMviHg0M6eVzwEtPj+jNHO8Z9zSqHJYZpQ0KbcZdomD4Asp/q5EBOXbLmaiR
         IaD26WwKoB3k08rPAxg9GjSWXA1U9wVi3TbXG9ObnwG1RBcGZj8vP/FSr5SKwhgQ8W
         H0fr/j/BDXfiqQ6CKnQRl7pEWLoaJxtUIvyxkSWk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        xdp-newbies@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 68/95] bpf, devmap: Fix premature entry free on destroying map
Date:   Wed, 26 Jun 2019 20:29:53 -0400
Message-Id: <20190627003021.19867-68-sashal@kernel.org>
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

From: Toshiaki Makita <toshiaki.makita1@gmail.com>

[ Upstream commit d4dd153d551634683fccf8881f606fa9f3dfa1ef ]

dev_map_free() waits for flush_needed bitmap to be empty in order to
ensure all flush operations have completed before freeing its entries.
However the corresponding clear_bit() was called before using the
entries, so the entries could be used after free.

All access to the entries needs to be done before clearing the bit.
It seems commit a5e2da6e9787 ("bpf: netdev is never null in
__dev_map_flush") accidentally changed the clear_bit() and memory access
order.

Note that the problem happens only in __dev_map_flush(), not in
dev_map_flush_old(). dev_map_flush_old() is called only after nulling
out the corresponding netdev_map entry, so dev_map_free() never frees
the entry thus no such race happens there.

Fixes: a5e2da6e9787 ("bpf: netdev is never null in __dev_map_flush")
Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/devmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 1e525d70f833..e001fb1a96b1 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -291,10 +291,10 @@ void __dev_map_flush(struct bpf_map *map)
 		if (unlikely(!dev))
 			continue;
 
-		__clear_bit(bit, bitmap);
-
 		bq = this_cpu_ptr(dev->bulkq);
 		bq_xmit_all(dev, bq, XDP_XMIT_FLUSH, true);
+
+		__clear_bit(bit, bitmap);
 	}
 }
 
-- 
2.20.1

