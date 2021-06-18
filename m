Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1D83AD3A8
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 22:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbhFRUgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 16:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232426AbhFRUgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 16:36:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E092D613C2;
        Fri, 18 Jun 2021 20:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624048455;
        bh=5W8Yl37x/lKQbJKp3l0H4IzhQ+LD6ZAEqjkucLg9S9g=;
        h=From:To:Cc:Subject:Date:From;
        b=m4u9sMOiQEZDlL5mQtfnM99lBTPwP6VPJxjke8jQEBDAd9eVsk+8JuDHmN867vvkj
         MFYa73AEmK3czLhfOJPutNOs7o932h3hwQhXqW/Ar0FnQoXCKASJXr+hQITAiL2HgT
         WxtlEHuLQ/LKWbdklWOVsYSSujg+EtCRciSl4rJ02JbFHGnDCZslBtyJmF/8R7d3qS
         GEQ/HSDDAp/ldzmB1PhJ+vjqAiNSFphpDoFSIKrbhu4HEbT/r3QgbVgQLQ8WrqwGPV
         ikqlNJQuhIcCaOEfhHoZ3zyiKY/2mVK8A3Uq7B1QuhVg92jzkdPgtLigqN9wK1fXKr
         e3xvtEaex6PhA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net, davejwatson@fb.com,
        ilyal@mellanox.com, aviadye@mellanox.com,
        Jakub Kicinski <kuba@kernel.org>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH net] tls: prevent oversized sendfile() hangs by ignoring MSG_MORE
Date:   Fri, 18 Jun 2021 13:34:06 -0700
Message-Id: <20210618203406.1437414-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We got multiple reports that multi_chunk_sendfile test
case from tls selftest fails. This was sort of expected,
as the original fix was never applied (see it in the first
Link:). The test in question uses sendfile() with count
larger than the size of the underlying file. This will
make splice set MSG_MORE on all sendpage calls, meaning
TLS will never close and flush the last partial record.

Eric seem to have addressed a similar problem in
commit 35f9c09fe9c7 ("tcp: tcp_sendpages() should call tcp_push() once")
by introducing MSG_SENDPAGE_NOTLAST. Unlike MSG_MORE
MSG_SENDPAGE_NOTLAST is not set on the last call
of a "pipefull" of data (PIPE_DEF_BUFFERS == 16,
so every 16 pages or whenever we run out of data).

Having a break every 16 pages should be fine, TLS
can pack exactly 4 pages into a record, so for
aligned reads there should be no difference,
unaligned may see one extra record per sendpage().

Sticking to TCP semantics seems preferable to modifying
splice, but we can revisit it if real life scenarios
show a regression.

Reported-by: Vadim Fedorenko <vfedorenko@novek.ru>
Reported-by: Seth Forshee <seth.forshee@canonical.com>
Link: https://lore.kernel.org/netdev/1591392508-14592-1-git-send-email-pooja.trivedi@stackpath.com/
Fixes: 3c4d7559159b ("tls: kernel TLS support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 694de024d0ee..74e5701034aa 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1153,7 +1153,7 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 	int ret = 0;
 	bool eor;
 
-	eor = !(flags & (MSG_MORE | MSG_SENDPAGE_NOTLAST));
+	eor = !(flags & MSG_SENDPAGE_NOTLAST);
 	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
 
 	/* Call the sk_stream functions to manage the sndbuf mem. */
-- 
2.31.1

