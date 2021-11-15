Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B7344FDF8
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 05:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhKOEnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 23:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbhKOEnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 23:43:31 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC2BC061746;
        Sun, 14 Nov 2021 20:40:35 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id v15-20020a9d604f000000b0056cdb373b82so17338276otj.7;
        Sun, 14 Nov 2021 20:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+bY8zoDBGmAZ5JhkVO0FyviJGk8GGq89OvF/QGwbrsY=;
        b=nFaiYKlCZ8uJIWneAfCTqafTpDTKG4RRnimTkR36nGDVsIxENUJYLa8qrcmPlIwDlJ
         MIk1U1Jn1ZhAuTRL/56pTGipoTvvGA9eQsGIy3qQcVyYVxOCeBfE7MlY1AG4E81cBRUc
         qavfOBQEWwZIetKIJqlUIk6PRzcxCqUmQjEVwj1FtcOCLFEz6YU0kQd6P4zS7uytFwsQ
         5e0h49Ez8LEl82ZHGMM+CEMs4w+J+K4kGZcrd/5pyxEcVrbRe3z8o9geVvVaEnuwnii+
         Ac2apiCrJ6XSmLEra/CkIZqVvRoY1b6h1lPdRr2WOu0MmNZzbB5RZFL+nYvttKPTgmQE
         dSUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+bY8zoDBGmAZ5JhkVO0FyviJGk8GGq89OvF/QGwbrsY=;
        b=gwccRzUJQCYsfUR/SpPOeV4yHKu1Z9+KpdHMvxAivU/kJIPA+fJEvSHDYqAa3XCsTX
         vuSkVnCuOBDk80Tx0HYGw4k7v78LiexEDFcAfINGtuKD9/4mPpjMbnA1mV+miD8kv3KS
         posTIf1Tzk6lHTBqChqisXkLRk3XFoOrN0yi8rknUFni2JUaXekhJq7yw8K74h2l0oCL
         +uqkKSAbqpJms0QiiL9HhEo7W+Zove7k0CpgxE3p+MOLg5VzGq0M2nU5X0u0PLW28e9x
         5AZ+LC2n3stYw8zCxuP1EU8isB2LgiJDoSn0QQDjAwcUovyvgiqeOiwteMAVf0g3Dv5z
         WkZA==
X-Gm-Message-State: AOAM530S5gaR9Th3S8mFoIMsOaxSiQLvHi+OVngO61UXu92LgvzMPh0y
        K4WVP3QWK6glscDNeLiqrT67orHY9p8=
X-Google-Smtp-Source: ABdhPJyzLO4hkN/axWgYZAMGsqS5pXChkDcQjl0j7N1kGj3A/zA8264dowu+MZooNtRfkVjzfwU46A==
X-Received: by 2002:a9d:63d2:: with SMTP id e18mr15314572otl.28.1636951234665;
        Sun, 14 Nov 2021 20:40:34 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:ad6a:87ab:d49f:b943])
        by smtp.gmail.com with ESMTPSA id u40sm910501oiw.56.2021.11.14.20.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Nov 2021 20:40:34 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [RESEND PATCH bpf] udp: validate checksum in udp_read_sock()
Date:   Sun, 14 Nov 2021 20:40:06 -0800
Message-Id: <20211115044006.26068-1-xiyou.wangcong@gmail.com>
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
Acked-by: John Fastabend <john.fastabend@gmail.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/ipv4/udp.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 319dd7bbfe33..8bcecdd6aeda 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1807,6 +1807,17 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
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

