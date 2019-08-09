Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9905E87950
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 14:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406412AbfHIMEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 08:04:53 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:51710 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfHIMEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 08:04:52 -0400
Received: by mail-qt1-f202.google.com with SMTP id m25so88320545qtn.18
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 05:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=YjLWoQ8boi4yWsgBCXm+EzlUJLl3Ao5UHq6/ynOluDc=;
        b=LlEuQ/DdJ0DWgNmJLyqt1WccA/7EWSB/wKz5i+e/Mi0JvX0o/emQGrr4+X5ypT39HT
         0r+KO8IpgfHqwtHVGqUF2LolOeElPios7G2FycrxG2l3dJM5bMJt+91TQzheawOguWsr
         sYgvVw6UcaTrH2cKwmBqk01jKGMJPg666+GckjhZfAGxLD0/BHiipuEUBHwQlbyGej0y
         +hxv0H9hxg2Hvnbsj7ZRvJAs/COEjg3DUCOmvy2JpetQn7my7uc51XAcgv/dJSa7iTco
         h8DYtq2iGwLhXzwZ8lapTOhWzkMHo88by9cVyc8mnrRdRgHT0mO6Pt9V4JyBl7h1yYkG
         6Lkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=YjLWoQ8boi4yWsgBCXm+EzlUJLl3Ao5UHq6/ynOluDc=;
        b=hDvfhBb2sErXUNersDQ+6nwbM5LQvFBpRvCzis5XgFgxZeGRWP1kM0L8NG6xLMHSGy
         nwY6nFK+mmI6I879HeF1RltnxzbOdmL8w5tX5IQ2AEsfDYIueWO2/uPy+QvjqdOG1a4z
         c9bQLXVpxoLYOrXQjJt1TZMaqjezyEz9lIO9oCfqZITIpgh3AMM7+VMk9NpM1uoec/CP
         4eCaLk5HbxBavC7sbOjuPSv3UCPW+FFksFRLJe3Hi8KJ1GjNkGi5BpbgDbjdGmqKgdce
         1I3d++WYj8KnC06GfDTU3KXGuau/HGAceo6XaceAnLFU7P5ID49GCA+gAef8ubSlo1gJ
         t/sA==
X-Gm-Message-State: APjAAAVPuAbdZR3k2CLAF+r41PcSvgomd72xLSntDKws6qHLZpQ2NwnG
        57otDnwiM/tERjqyD+3GHE+qOBSyNIIIxg==
X-Google-Smtp-Source: APXvYqwBdhU7WZgVClYWicS2d6Kf67WgzUFQK707eV9JzUdwqw/MmlcwHXbkDndu3pHCAxM5HgmGofy4rIKtbg==
X-Received: by 2002:ac8:4a02:: with SMTP id x2mr16997859qtq.329.1565352291613;
 Fri, 09 Aug 2019 05:04:51 -0700 (PDT)
Date:   Fri,  9 Aug 2019 05:04:47 -0700
Message-Id: <20190809120447.93591-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH net-next] tcp: batch calls to sk_flush_backlog()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Starting from commit d41a69f1d390 ("tcp: make tcp_sendmsg() aware of socket backlog")
loopback flows got hurt, because for each skb sent, the socket receives an
immediate ACK and sk_flush_backlog() causes extra work.

Intent was to not let the backlog grow too much, but we went a bit too far.

We can check the backlog every 16 skbs (about 1MB chunks)
to increase TCP over loopback performance by about 15 %

Note that the call to sk_flush_backlog() handles a single ACK,
thanks to coalescing done on backlog, but cleans the 16 skbs
found in rtx rb-tree.

Reported-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a0a66321c0ee99918b2080219dbaefcf3c398e13..f8fa1686f7f3e64f5d4ea8163e7f87538cc0d672 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1162,7 +1162,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	struct sockcm_cookie sockc;
 	int flags, err, copied = 0;
 	int mss_now = 0, size_goal, copied_syn = 0;
-	bool process_backlog = false;
+	int process_backlog = 0;
 	bool zc = false;
 	long timeo;
 
@@ -1254,9 +1254,10 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			if (!sk_stream_memory_free(sk))
 				goto wait_for_sndbuf;
 
-			if (process_backlog && sk_flush_backlog(sk)) {
-				process_backlog = false;
-				goto restart;
+			if (unlikely(process_backlog >= 16)) {
+				process_backlog = 0;
+				if (sk_flush_backlog(sk))
+					goto restart;
 			}
 			first_skb = tcp_rtx_and_write_queues_empty(sk);
 			skb = sk_stream_alloc_skb(sk, 0, sk->sk_allocation,
@@ -1264,7 +1265,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			if (!skb)
 				goto wait_for_memory;
 
-			process_backlog = true;
+			process_backlog++;
 			skb->ip_summed = CHECKSUM_PARTIAL;
 
 			skb_entail(sk, skb);
-- 
2.23.0.rc1.153.gdeed80330f-goog

