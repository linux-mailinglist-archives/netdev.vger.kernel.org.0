Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F40264F2C
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbgIJTgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgIJTgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:36:01 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA3AC061795
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:35:43 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id db4so3951365qvb.4
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sbLrAjHEicejYQwCS7LtXSjDNtzl79GZWNsQFcCLCUc=;
        b=KoJqjh90741y0xJ6Orny3csrEmvi3uFlCBat90ZGtWvfMc/gcHOsPLbTfxJRFkSVZ4
         Z/kS9vlLBKW3P0ffGxfwl64xiBv0zv1pmwjraq1tByjGzRSnM1hdvS5YyTisCGyJ3IR5
         LMVlC/4IjI1QQk7GIso9YVnpAHok0l32YD9hGUaaP5hGkQVPOl0AzeAWHT30oP0sIA3Q
         GYQ7F386PIFnmrCk3A2Q7NhsMaeCY9hepyodAAHwBsft0qxgJ/7YdUr17dktlipIMz8O
         HsUDXkEDGex9sTIXh0+mmMKhMqVGPgfcu7qWS31EBMLlV4Gg91MpvYnJko1Vj4FUo/+6
         KETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sbLrAjHEicejYQwCS7LtXSjDNtzl79GZWNsQFcCLCUc=;
        b=A+izVfv/Tw38+5C+5m7vIeGKVrsTZWm8qZ0XUZQUlh2pnr7Ek3Rvex9DDqy0eS0iwu
         hilqyaBSQZGGyrxJzL8tzsciaOcvIdcrGkFJacdF3Z5FcF6uTF1tl2BCtbNmlSGw7GN/
         QIvVJA6RNa5ltt+Tg8jJbP2WUR/DHxF9IesUeXfa0d0+0lg5e7Hm57OWz1lUm1q4BZgQ
         je6C7fQiYT+C4OB+NQK6GHOs6LoSWEJhCR1M2S15nxD7PWjVpV92TfoKnqGkhbfB4YOd
         4xjpUxrXOeeh9GQbNF37j93DO+vTSrrgDsv6AKqCKsyYSlMMhSjnp/epR3sQn5pyScFM
         Mo9A==
X-Gm-Message-State: AOAM53161lCvm+6PmfaikdNZCqNh40K4mYZBjHfyX3xE0+y4659wxd6/
        2wk1XpV/NNlKAj/gmwlYkFM=
X-Google-Smtp-Source: ABdhPJwslwe1CWWUgBDfRofmYx6ztM259qUlz7amMNyGU08b8BKwriKqcK3DuyE78avTM3YOBpnBIg==
X-Received: by 2002:a0c:c492:: with SMTP id u18mr9916090qvi.18.1599766543234;
        Thu, 10 Sep 2020 12:35:43 -0700 (PDT)
Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
        by smtp.gmail.com with ESMTPSA id f13sm7735484qko.122.2020.09.10.12.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 12:35:42 -0700 (PDT)
From:   Neal Cardwell <ncardwell.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>
Subject: [PATCH bpf-next v3 5/5] tcp: simplify tcp_set_congestion_control() load=false case
Date:   Thu, 10 Sep 2020 15:35:36 -0400
Message-Id: <20200910193536.2980613-6-ncardwell.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200910193536.2980613-1-ncardwell.kernel@gmail.com>
References: <20200910193536.2980613-1-ncardwell.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

Simplify tcp_set_congestion_control() by removing the initialization
code path for the !load case.

There are only two call sites for tcp_set_congestion_control(). The
EBPF call site is the only one that passes load=false; it also passes
cap_net_admin=true. Because of that, the exact same behavior can be
achieved by removing the special if (!load) branch of the logic. Both
before and after this commit, the EBPF case will call
bpf_try_module_get(), and if that succeeds then call
tcp_reinit_congestion_control() or if that fails then return EBUSY.

Note that this returns the logic to a structure very similar to the
structure before:
  commit 91b5b21c7c16 ("bpf: Add support for changing congestion control")
except that the CAP_NET_ADMIN status is passed in as a function
argument.

This clean-up was suggested by Martin KaFai Lau.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Suggested-by: Martin KaFai Lau <kafai@fb.com>
Cc: Lawrence Brakmo <brakmo@fb.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Kevin Yang <yyd@google.com>
---
 net/ipv4/tcp_cong.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index a9b0fb52a1ec..db47ac24d057 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -362,21 +362,14 @@ int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
 		goto out;
 	}
 
-	if (!ca) {
+	if (!ca)
 		err = -ENOENT;
-	} else if (!load) {
-		if (bpf_try_module_get(ca, ca->owner)) {
-			tcp_reinit_congestion_control(sk, ca);
-		} else {
-			err = -EBUSY;
-		}
-	} else if (!((ca->flags & TCP_CONG_NON_RESTRICTED) || cap_net_admin)) {
+	else if (!((ca->flags & TCP_CONG_NON_RESTRICTED) || cap_net_admin))
 		err = -EPERM;
-	} else if (!bpf_try_module_get(ca, ca->owner)) {
+	else if (!bpf_try_module_get(ca, ca->owner))
 		err = -EBUSY;
-	} else {
+	else
 		tcp_reinit_congestion_control(sk, ca);
-	}
  out:
 	rcu_read_unlock();
 	return err;
-- 
2.28.0.618.gf4bc123cb7-goog

