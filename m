Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE21019D9D8
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 17:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404117AbgDCPN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 11:13:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728213AbgDCPN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Apr 2020 11:13:28 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 294EF2073B;
        Fri,  3 Apr 2020 15:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585926807;
        bh=I/Lij4c63/t1fugS8FYJeh/QU8MNx0FELG2JmOJkUBM=;
        h=From:To:Cc:Subject:Date:From;
        b=kozVUiqbzzOC27RXU2Gn4uoI/0YIM2nu4c0ig/txr/XTvAIKhfAqjzkfliXj9bNvS
         iu1CoUTc1kgSjD+EpJT7qF5ykr4UqoaLcjmD2PtQqP0PmflPS8JbyPYTny1xaOithC
         v4ZouSAp1urCKzuniCO1Y8+PqGLP1Yy1zRcDg3YU=
From:   Will Deacon <will@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@android.com, Will Deacon <will@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH] tun: Don't put_page() for all negative return values from XDP program
Date:   Fri,  3 Apr 2020 16:13:21 +0100
Message-Id: <20200403151321.20166-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---

RFC -> V1: Added Fixes tag and Jason's Ack.

 drivers/net/tun.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 650c937ed56b..9de9b7d8aedd 100644
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
 			xdp_do_flush();
 		if (err != XDP_PASS)
@@ -1730,8 +1734,6 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 
 	return __tun_build_skb(tfile, alloc_frag, buf, buflen, len, pad);
 
-err_xdp:
-	put_page(alloc_frag->page);
 out:
 	rcu_read_unlock();
 	local_bh_enable();
-- 
2.26.0.292.g33ef6b2f38-goog

