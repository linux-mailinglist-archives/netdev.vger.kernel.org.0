Return-Path: <netdev+bounces-6343-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FA36715D6C
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC6AD281125
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 479B717FE2;
	Tue, 30 May 2023 11:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC7017AD7
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:40:20 +0000 (UTC)
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8617DB0;
	Tue, 30 May 2023 04:40:19 -0700 (PDT)
Received: from vefanov-Precision-3650-Tower.intra.ispras.ru (unknown [10.10.2.69])
	by mail.ispras.ru (Postfix) with ESMTPSA id 7398E44C100D;
	Tue, 30 May 2023 11:40:16 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 7398E44C100D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1685446816;
	bh=xfu3uFYPCa0mI19qMfmeJz1jquM9eNx9AbVYikppbu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Or6shdGE1tqZfXHhKNT99XR84T92eJk7L9U1L+PgI/iDvAViNNlmguPSl00lhxNvT
	 xOcYXS0JVKtY/2QVC9ZG2jfh7PE5t8rvHrzFujOxxqkXnA+jRKdDWp8WlneWfn0SW3
	 fEhq6rMnwQhHgvIIZ5srRf/KeFfb1JF9BbFEV3CA=
From: Vladislav Efanov <VEfanov@ispras.ru>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Vladislav Efanov <VEfanov@ispras.ru>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH v2] udp6: Fix race condition in udp6_sendmsg & connect
Date: Tue, 30 May 2023 14:39:41 +0300
Message-Id: <20230530113941.1674072-1-VEfanov@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <27614af23cd7ae4433b909194062c553a6ae16ac.camel@redhat.com>
References: 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Syzkaller got the following report:
BUG: KASAN: use-after-free in sk_setup_caps+0x621/0x690 net/core/sock.c:2018
Read of size 8 at addr ffff888027f82780 by task syz-executor276/3255

The function sk_setup_caps (called by ip6_sk_dst_store_flow->
ip6_dst_store) referenced already freed memory as this memory was
freed by parallel task in udpv6_sendmsg->ip6_sk_dst_lookup_flow->
sk_dst_check.

          task1 (connect)              task2 (udp6_sendmsg)
        sk_setup_caps->sk_dst_set |
                                  |  sk_dst_check->
                                  |      sk_dst_set
                                  |      dst_release
        sk_setup_caps references  |
        to already freed dst_entry|

The reason for this race condition is: sk_setup_caps() keeps using
the dst after transferring the ownership to the dst cache.

Found by Linux Verification Center (linuxtesting.org) with syzkaller.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Vladislav Efanov <VEfanov@ispras.ru>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v2: Move sk_dst_set() call in sk_setup_caps() as
Paolo Abeni <pabeni@redhat.com> suggested.
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 5440e67bcfe3..24f2761bdb1d 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2381,7 +2381,6 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 {
 	u32 max_segs = 1;
 
-	sk_dst_set(sk, dst);
 	sk->sk_route_caps = dst->dev->features;
 	if (sk_is_tcp(sk))
 		sk->sk_route_caps |= NETIF_F_GSO;
@@ -2400,6 +2399,7 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 		}
 	}
 	sk->sk_gso_max_segs = max_segs;
+	sk_dst_set(sk, dst);
 }
 EXPORT_SYMBOL_GPL(sk_setup_caps);
 
-- 
2.34.1


