Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAFC0427278
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 22:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhJHUsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 16:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242880AbhJHUsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 16:48:13 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BE8C061570;
        Fri,  8 Oct 2021 13:46:17 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id bk7so1702677qkb.13;
        Fri, 08 Oct 2021 13:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yeXdBzjPTjeK537chbgl6+lX0okf4V+APYUQp2bV9TQ=;
        b=eNonqiffOBwhrc90BZbMDMDxWZ5WuEvvZj54Usg2tVi6oWDqEACsAHfQFXyxb7UT41
         pANGnPLJ9oVUkenmzGWfTf4hnwaa/2YiQd/jUJUjPy+7i2gPlCc6KP6g/aIawuKElxm7
         exf8kUNCazbnzCmteqVJzAChUZ00p4iKZ0frYyg/A/QA/JYcb8K3uY/+QO3mmgpmVir0
         uTeyIctQS8IXNd4bklfUj/XTZqVLK15yqD8TztH70/uSnNy18i2XVU0t803F+uyxedaX
         5J5+SAIZ9k1hDkfLXWDEFX5BYmiczQ3qDEqRtz9iVFIIqZ/pASsmGMAspOPQu5N2yxP3
         eb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yeXdBzjPTjeK537chbgl6+lX0okf4V+APYUQp2bV9TQ=;
        b=3UprDopQjcMfVUQP2SvelOX2F3au0frdfxC8KoSmFFSGHxpD0NblsTWNAbRF00hzhA
         eM55fLU9qkN9Db+Toorf2TLNM0KvwLpO8RLmAY+ymogHLdeYbjtoC7W1a4HoYtXAKIvF
         zsTnEwMpiKaHd9R3cu0iH3e1yH5AIDznw2qsUwv9NBFjrLrUlNz+I4chwEGpbUnKz+BM
         2NrPmboQTRbd6VX6WFh/+/uMWM1br/izTetAMqUz/sk5vAdwP9Qyzo7xWObPit7ufllc
         U8sK7/CAJ/9GeGKGevjpva6SX3n7Tc/li3xqTddWXO6d7D488nGOa9Rs33WVIzaXuCSx
         RC/g==
X-Gm-Message-State: AOAM531E0HU5WfWV4lsbCG+u5oFsO3oSYSlHXKwuDGG7jebvfH2vWJCi
        Vawpm4a757ZVIdvL3iLebpnTdfp7GLg=
X-Google-Smtp-Source: ABdhPJw2mK3EWS10+imvu/+cOQTFxAAkcODuCiM7J5StmwybizEyj3w1GDReEhKPBEghTv8ergRnaA==
X-Received: by 2002:a37:b087:: with SMTP id z129mr4754612qke.392.1633725976515;
        Fri, 08 Oct 2021 13:46:16 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:795f:367d:1f1e:4801])
        by smtp.gmail.com with ESMTPSA id q19sm384322qkj.60.2021.10.08.13.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:46:16 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf] udp: validate checksum in udp_read_sock()
Date:   Fri,  8 Oct 2021 13:46:04 -0700
Message-Id: <20211008204604.38014-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

It turns out the skb's in sock receive queue could have
bad checksums, as both ->poll() and ->recvmsg() validate
checksums. We have to do the same for ->read_sock() path
too before they are redirected in sockmap.

Fixes: d7f571188ecf ("udp: Implement ->read_sock() for sockmap")
Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Reported-by: John Fastabend <john.fastabend@gmail.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/ipv4/udp.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 8536b2a7210b..0ae8ab5e05b4 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1808,6 +1808,17 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		skb = skb_recv_udp(sk, 0, 1, &err);
 		if (!skb)
 			return err;
+
+		if (udp_lib_checksum_complete(skb)) {
+			__UDP_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS,
+					IS_UDPLITE(sk));
+			__UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS,
+					IS_UDPLITE(sk));
+			atomic_inc(&sk->sk_drops);
+			kfree_skb(skb);
+			continue;
+		}
+
 		used = recv_actor(desc, skb, 0, skb->len);
 		if (used <= 0) {
 			if (!copied)
-- 
2.30.2

