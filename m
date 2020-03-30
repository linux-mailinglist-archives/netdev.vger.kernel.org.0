Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4278D1980A6
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgC3QMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:12:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgC3QMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 12:12:41 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41FDD2072E;
        Mon, 30 Mar 2020 16:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585584761;
        bh=aGvwRHVGkfCwUwyFQ1NwD3TIR1jMPKBWli5lctMi03A=;
        h=From:To:Cc:Subject:Date:From;
        b=cOyl4qF1nqSnhTT458HYnCkYRTGr0Y0u/itgXt8V2OwSLH82KbyfSX6NAYexbwDrw
         +IjVNh+I0R5+Gd50deJgpMKJA9R9q27UZu7uWsrTpOtFNXyxXS55fA8cGyb7DaQMaz
         AziioY8InHhg5w6clw0hKSIYvjiuAmlMrwIpKrt8=
From:   Will Deacon <will@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@android.com, Will Deacon <will@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [RFC PATCH] tun: Don't put_page() for all negative return values from XDP program
Date:   Mon, 30 Mar 2020 17:12:34 +0100
Message-Id: <20200330161234.12777-1-will@kernel.org>
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
Cc: Jason Wang <jasowang@redhat.com>
CC: Eric Dumazet <edumazet@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---

Sending as RFC because I've not been able to confirm that this fixes anything.

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
2.26.0.rc2.310.g2932bb562d-goog

