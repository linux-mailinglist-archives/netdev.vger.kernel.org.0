Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2101AA18B
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 14:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370066AbgDOMml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 08:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897532AbgDOLnm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 07:43:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 381CD2173E;
        Wed, 15 Apr 2020 11:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951022;
        bh=gAifPt66qkW3tv2T57UG0FcJWamVbpl1k2rRwDdvNXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwyJ4Bw5+sH8N9/lkbE8ZOx6pBJPFIyV18cQq3+J0PxiaXJLHJoVPDq+8ie7kAf1M
         yXW+RWzb1rZSS7dO50wu9Kd7nv8OIQY9b5DOgFKFNMbAIaYCdFkZvi0GhOGieK+g+L
         OWRzIXeMSuQYrsmkBGk72zMRM9/uA+5txQaJ1EJA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 062/106] tun: Don't put_page() for all negative return values from XDP program
Date:   Wed, 15 Apr 2020 07:41:42 -0400
Message-Id: <20200415114226.13103-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit bee348907d19d654e8524d3a946dcd25b693aa7e ]

When an XDP program is installed, tun_build_skb() grabs a reference to
the current page fragment page if the program returns XDP_REDIRECT or
XDP_TX. However, since tun_xdp_act() passes through negative return
values from the XDP program, it is possible to trigger the error path by
mistake and accidentally drop a reference to the fragments page without
taking one, leading to a spurious free. This is believed to be the cause
of some KASAN use-after-free reports from syzbot [1], although without a
reproducer it is not possible to confirm whether this patch fixes the
problem.

Ensure that we only drop a reference to the fragments page if the XDP
transmit or redirect operations actually fail.

[1] https://syzkaller.appspot.com/bug?id=e76a6af1be4acd727ff6bbca669833f98cbf5d95

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
CC: Eric Dumazet <edumazet@google.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Fixes: 8ae1aff0b331 ("tuntap: split out XDP logic")
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 35e884a8242d9..6d3317d868d23 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1715,8 +1715,12 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 			alloc_frag->offset += buflen;
 		}
 		err = tun_xdp_act(tun, xdp_prog, &xdp, act);
-		if (err < 0)
-			goto err_xdp;
+		if (err < 0) {
+			if (act == XDP_REDIRECT || act == XDP_TX)
+				put_page(alloc_frag->page);
+			goto out;
+		}
+
 		if (err == XDP_REDIRECT)
 			xdp_do_flush_map();
 		if (err != XDP_PASS)
@@ -1730,8 +1734,6 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 
 	return __tun_build_skb(tfile, alloc_frag, buf, buflen, len, pad);
 
-err_xdp:
-	put_page(alloc_frag->page);
 out:
 	rcu_read_unlock();
 	local_bh_enable();
-- 
2.20.1

