Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A9D20777B
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 17:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404508AbgFXPe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 11:34:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404323AbgFXPe2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 11:34:28 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB68E206FA;
        Wed, 24 Jun 2020 15:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593012868;
        bh=1pJytwJejZQnTfJpmOAYaRgg4T3M4iz5/khnbm9cSqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCMy2tLT0yO/uBTDu5EF0+Oz5xWZ4+K0BndtlYUCdrOpTE4+4YKFJGdFJLbfqX2xP
         sqGCxQAZXo6/jwhY6yn40nhVweJwUWiB7uez08nTBH7xb2sB3PEiu2/SV/bnYuSjEu
         wVc4AtT/i99+I79qyFoeT+W4ZCjYqNBBfvJzz8Ao=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, toke@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org, andrii.nakryiko@gmail.com
Subject: [PATCH v4 bpf-next 1/9] cpumap: use non-locked version __ptr_ring_consume_batched
Date:   Wed, 24 Jun 2020 17:33:50 +0200
Message-Id: <91807e9d58de5d48521631548ec4586f0090399b.1593012598.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1593012598.git.lorenzo@kernel.org>
References: <cover.1593012598.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

Commit 77361825bb01 ("bpf: cpumap use ptr_ring_consume_batched") changed
away from using single frame ptr_ring dequeue (__ptr_ring_consume) to
consume a batched, but it uses a locked version, which as the comment
explain isn't needed.

Change to use the non-locked version __ptr_ring_consume_batched.

Fixes: 77361825bb01 ("bpf: cpumap use ptr_ring_consume_batched")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 kernel/bpf/cpumap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index bd8658055c16..323c91c4fab0 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -259,7 +259,7 @@ static int cpu_map_kthread_run(void *data)
 		 * kthread CPU pinned. Lockless access to ptr_ring
 		 * consume side valid as no-resize allowed of queue.
 		 */
-		n = ptr_ring_consume_batched(rcpu->queue, frames, CPUMAP_BATCH);
+		n = __ptr_ring_consume_batched(rcpu->queue, frames, CPUMAP_BATCH);
 
 		for (i = 0; i < n; i++) {
 			void *f = frames[i];
-- 
2.26.2

