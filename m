Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488914A7B05
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 23:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbiBBWUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 17:20:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56112 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244848AbiBBWUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 17:20:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A13ACB832BB
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 22:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E9FC004E1;
        Wed,  2 Feb 2022 22:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643840434;
        bh=5XO/olIeWXfdfY/SiNPeeyJHb7sxBh2UNHaTw3PFX/M=;
        h=From:To:Cc:Subject:Date:From;
        b=BY2qfoc/3t8tR1VSIB1x6WORVVgX6G/PGCpUPYQFRtAgQRdCSiX5R9LP49y2HfcDd
         A/zs6FDyKutPKx/FTq3Bf/0prbZFRc0+ZZeiQG6S/oLXn88AwQWP1XYcG2oFMBGDB8
         33pOLPJ7RxS0vK7H4CFUBIrfVOg9F4y5SORcgsQmkNfptjs99K/jA15UoTxZCAQi+9
         xq/HIXVNXWckbSUfVDBWpSZPyh/Atsqkq6RmiAaKSx3kPhaS44CNBkbSEtkDWMxZ8k
         WBl5U5xoLkdtpwLpNvnUPK/5Wlt18yHQTy1LV4X0GfQqOE4GnaJ0efxIsE0rG0EDGS
         /gzxUgXhZ52gg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, viro@zeniv.linux.org.uk, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, kernel-team@fb.com, axboe@kernel.dk,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] tls: cap the output scatter list to something reasonable
Date:   Wed,  2 Feb 2022 14:20:31 -0800
Message-Id: <20220202222031.2174584-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS recvmsg() passes user pages as destination for decrypt.
The decrypt operation is repeated record by record, each
record being 16kB, max. TLS allocates an sg_table and uses
iov_iter_get_pages() to populate it with enough pages to
fit the decrypted record.

Even though we decrypt a single message at a time we size
the sg_table based on the entire length of the iovec.
This leads to unnecessarily large allocations, risking
triggering OOM conditions.

Use iov_iter_truncate() / iov_iter_reexpand() to construct
a "capped" version of iov_iter_npages(). Alternatively we
could parametrize iov_iter_npages() to take the size as
arg instead of using i->count, or do something else..

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/uio.h | 17 +++++++++++++++++
 net/tls/tls_sw.c    |  3 ++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 1198a2bfc9bf..739285fe5a2f 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -273,6 +273,23 @@ static inline void iov_iter_reexpand(struct iov_iter *i, size_t count)
 	i->count = count;
 }
 
+static inline int
+iov_iter_npages_cap(struct iov_iter *i, int maxpages, size_t max_bytes)
+{
+	size_t shorted = 0;
+	int npages;
+
+	if (iov_iter_count(i) > max_bytes) {
+		shorted = iov_iter_count(i) - max_bytes;
+		iov_iter_truncate(i, max_bytes);
+	}
+	npages = iov_iter_npages(i, INT_MAX);
+	if (shorted)
+		iov_iter_reexpand(i, iov_iter_count(i) + shorted);
+
+	return npages;
+}
+
 struct csum_state {
 	__wsum csum;
 	size_t off;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index efc84845bb6b..0024a692f0f8 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1433,7 +1433,8 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 
 	if (*zc && (out_iov || out_sg)) {
 		if (out_iov)
-			n_sgout = iov_iter_npages(out_iov, INT_MAX) + 1;
+			n_sgout = 1 +
+				iov_iter_npages_cap(out_iov, INT_MAX, data_len);
 		else
 			n_sgout = sg_nents(out_sg);
 		n_sgin = skb_nsg(skb, rxm->offset + prot->prepend_size,
-- 
2.34.1

