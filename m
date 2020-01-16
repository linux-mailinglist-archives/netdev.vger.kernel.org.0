Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF3BF13F438
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392961AbgAPSsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:48:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389758AbgAPRJv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38CAB205F4;
        Thu, 16 Jan 2020 17:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194590;
        bh=6Wvt9vJWgQlGcJlbt5KEJbH/p4c5jmdOeNTFfjihnc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7sqlYPKkRtZgf/dbgK55YcuEHNqq3xlwFlpDrh34AFB8h9YOsOHGQf/6L/8K2m5r
         ON9V2Kcs4qptgGVMN1ej6YfppoQym3eI73U+TJBTH7WfMYGp7UiFXNw4VYyifAvBRQ
         PG6/cAO7ySyj04kKvE4NGUx443byLq2if+Kslmbg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Maximets <i.maximets@samsung.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 461/671] xdp: fix possible cq entry leak
Date:   Thu, 16 Jan 2020 12:01:39 -0500
Message-Id: <20200116170509.12787-198-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilya Maximets <i.maximets@samsung.com>

[ Upstream commit 675716400da6f15b9d3db04ef74ee74ca9a00af3 ]

Completion queue address reservation could not be undone.
In case of bad 'queue_id' or skb allocation failure, reserved entry
will be leaked reducing the total capacity of completion queue.

Fix that by moving reservation to the point where failure is not
possible. Additionally, 'queue_id' checking moved out from the loop
since there is no point to check it there.

Fixes: 35fcde7f8deb ("xsk: support for Tx")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Tested-by: William Tu <u9012063@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 547fc4554b22..c90854bc3048 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -218,6 +218,9 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
 
 	mutex_lock(&xs->mutex);
 
+	if (xs->queue_id >= xs->dev->real_num_tx_queues)
+		goto out;
+
 	while (xskq_peek_desc(xs->tx, &desc)) {
 		char *buffer;
 		u64 addr;
@@ -228,12 +231,6 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
 			goto out;
 		}
 
-		if (xskq_reserve_addr(xs->umem->cq))
-			goto out;
-
-		if (xs->queue_id >= xs->dev->real_num_tx_queues)
-			goto out;
-
 		len = desc.len;
 		skb = sock_alloc_send_skb(sk, len, 1, &err);
 		if (unlikely(!skb)) {
@@ -245,7 +242,7 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
 		addr = desc.addr;
 		buffer = xdp_umem_get_data(xs->umem, addr);
 		err = skb_store_bits(skb, 0, buffer, len);
-		if (unlikely(err)) {
+		if (unlikely(err) || xskq_reserve_addr(xs->umem->cq)) {
 			kfree_skb(skb);
 			goto out;
 		}
-- 
2.20.1

