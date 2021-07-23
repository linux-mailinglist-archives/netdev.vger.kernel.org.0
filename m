Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BA23D4054
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 20:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhGWR4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 13:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWR4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 13:56:06 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82069C061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 11:36:39 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id x3so2272118qkl.6
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 11:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MgpkbrkPyqtMsta3sa24prf5Mg2KVDOa5e8dADYTvY0=;
        b=N6BL3bHbZ04FesySB26HGHIMOm9MAPndXYr0G/quzew9sqjebx61ZwTmgtcxt3XNVq
         wRY3u6cUjM8/DvqxIA1UG50RSzp0GlmrpvY/QFhykqp4oVn0C2axUuuX82i5vITI/YI1
         +98t+N+1oILWig1Uj7azrrIcP3HH5uEBLaxrMiL8W5E98gPLP2VKMQJ3/6F+/dET7zS/
         uHyCFRCHKIPqCSUzQylSdQH7a+abu+73JtFNyFluZKAvIMNdioqksZgSbQP5NzLglN5X
         8E4WCni0iJjEQ1G7ZYqYbFwyKwenrGyeYWSQGVSMSYopqj5VXFGUyqAAn6VDY4JICxR+
         hvuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MgpkbrkPyqtMsta3sa24prf5Mg2KVDOa5e8dADYTvY0=;
        b=eyc702qtgf8l9N7wCPMGhz4tL6+BmOy67LI2SyqBzl6C9QppFX/2iQJ805+7kbQuBU
         3FBc6FCHjYipOP95U4AoHNldblnfJI8Ky097Tb+9AOrycBH1Q0Wz27lQgzOAc+7cbB4w
         kcNWVLvasb61cAJEygci11UCeA/sRENGn6NCkZfwHqanvwF5JuAsHccbkER3XBbQxE4T
         s2EcJeB3Y5a63X2snCcASFknXT/j65KRfdgtEWA8L3BeLA8feFkxUQF2lkF5kUdu7xoG
         zplvIgp6Okn7RPIC2b9LFTe9NvOhG8ZX6eLgLZtdReZ8k0avo1A/l7rJBmytbXMq8poq
         TUlw==
X-Gm-Message-State: AOAM530FGIq+CeGJKs/BtTRoKqmgBNroWp2CcqzT68/5hGThngwvCDME
        MTd63eMkOJH4F0naeLMtYMMKKWLFUyE=
X-Google-Smtp-Source: ABdhPJxkbd3SYHG9EN1vWmTE9BGUdX9E1M5Zbeunfb4cid6WeiQhqc7EuU65xYdx/odCVYd/eqeLyg==
X-Received: by 2002:a05:620a:5f9:: with SMTP id z25mr5854703qkg.108.1627065398591;
        Fri, 23 Jul 2021 11:36:38 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id x28sm12609592qtm.71.2021.07.23.11.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 11:36:38 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next] unix_bpf: fix a potential deadlock in unix_dgram_bpf_recvmsg()
Date:   Fri, 23 Jul 2021 11:36:30 -0700
Message-Id: <20210723183630.5088-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

As Eric noticed, __unix_dgram_recvmsg() may acquire u->iolock
too, so we have to release it before calling this function.

Fixes: 9825d866ce0d ("af_unix: Implement unix_dgram_bpf_recvmsg()")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/unix/unix_bpf.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index db0cda29fb2f..b07cb30e87b1 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -53,8 +53,9 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 	mutex_lock(&u->iolock);
 	if (!skb_queue_empty(&sk->sk_receive_queue) &&
 	    sk_psock_queue_empty(psock)) {
-		ret = __unix_dgram_recvmsg(sk, msg, len, flags);
-		goto out;
+		mutex_unlock(&u->iolock);
+		sk_psock_put(sk, psock);
+		return __unix_dgram_recvmsg(sk, msg, len, flags);
 	}
 
 msg_bytes_ready:
@@ -68,13 +69,13 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 		if (data) {
 			if (!sk_psock_queue_empty(psock))
 				goto msg_bytes_ready;
-			ret = __unix_dgram_recvmsg(sk, msg, len, flags);
-			goto out;
+			mutex_unlock(&u->iolock);
+			sk_psock_put(sk, psock);
+			return __unix_dgram_recvmsg(sk, msg, len, flags);
 		}
 		copied = -EAGAIN;
 	}
 	ret = copied;
-out:
 	mutex_unlock(&u->iolock);
 	sk_psock_put(sk, psock);
 	return ret;
-- 
2.27.0

