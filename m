Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC5CC8C97F
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfHNCLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727533AbfHNCLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:11:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCD3220843;
        Wed, 14 Aug 2019 02:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748694;
        bh=H7yId5Cjt3grtQ1JdVrFZniPce+PtmDRZEBY7dKBYSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=no1MXWG11J8C0V7C7mHdb3vpzIIFoV54k7oD1Xxvsygwso0sxMLtlBrh7qdtYqkMr
         5vQl2D6IW6bZepJ2iDocnkg+dovLx0uwNFCXekemjLBUuakxQyRTZUD7hAyC6RfOWm
         R6zgar5pNSq1uGg9vc/MjKtL+9C0hmQTlTj4lYxs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 025/123] bpf: sockmap, sock_map_delete needs to use xchg
Date:   Tue, 13 Aug 2019 22:09:09 -0400
Message-Id: <20190814021047.14828-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 45a4521dcbd92e71c9e53031b40e34211d3b4feb ]

__sock_map_delete() may be called from a tcp event such as unhash or
close from the following trace,

  tcp_bpf_close()
    tcp_bpf_remove()
      sk_psock_unlink()
        sock_map_delete_from_link()
          __sock_map_delete()

In this case the sock lock is held but this only protects against
duplicate removals on the TCP side. If the map is free'd then we have
this trace,

  sock_map_free
    xchg()                  <- replaces map entry
    sock_map_unref()
      sk_psock_put()
        sock_map_del_link()

The __sock_map_delete() call however uses a read, test, null over the
map entry which can result in both paths trying to free the map
entry.

To fix use xchg in TCP paths as well so we avoid having two references
to the same map entry.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index be6092ac69f8a..1d40e040320d2 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -281,16 +281,20 @@ static int __sock_map_delete(struct bpf_stab *stab, struct sock *sk_test,
 			     struct sock **psk)
 {
 	struct sock *sk;
+	int err = 0;
 
 	raw_spin_lock_bh(&stab->lock);
 	sk = *psk;
 	if (!sk_test || sk_test == sk)
-		*psk = NULL;
+		sk = xchg(psk, NULL);
+
+	if (likely(sk))
+		sock_map_unref(sk, psk);
+	else
+		err = -EINVAL;
+
 	raw_spin_unlock_bh(&stab->lock);
-	if (unlikely(!sk))
-		return -EINVAL;
-	sock_map_unref(sk, psk);
-	return 0;
+	return err;
 }
 
 static void sock_map_delete_from_link(struct bpf_map *map, struct sock *sk,
-- 
2.20.1

