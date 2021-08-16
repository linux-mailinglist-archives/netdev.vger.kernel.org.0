Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346AD3EDECD
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 22:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbhHPUwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 16:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbhHPUwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 16:52:22 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F072CC061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 13:51:50 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id bo18so28571745pjb.0
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 13:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QNjLAMi+CxbQNlMbdfMf25HypiSkR+DmhakI6VpxXA0=;
        b=s7qhenr+bDstqR1GKR+J66HFpXEjg0p/97bIbOkWy9TiVs8Swa9rTHUYH5XbcfMWGB
         N4JytoFqPSFTaFMiF2SouGgxKFnh8+J2mHntp7WrnSpULymUxwMG80f7+oS+LkutABYQ
         TThLdLY3bB60UTvmt6bC0HIGnDKn6LNKWFM4ujw1BvPa+cKHMTxKn2y3ArfX12ka+g60
         tgA/ztqJuREsv+RaAJ1LiODH10sm6EYE6ARECH+xLQ2zxqghjwTbefyCXSiu1CtF9LD/
         0mu8YZuOslFnqpk0mgYx6wbyKk99okGl/Qm37ZwQ8AmbH3nk3uLyCUxVfv9Sw6fkCbX2
         XYIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QNjLAMi+CxbQNlMbdfMf25HypiSkR+DmhakI6VpxXA0=;
        b=C+6k8BQDl2UV3N8ts33X/W3mpD50g4luwgJfdoRm1k6zEfH3VKUb9uYkrzufkeM581
         71a4RcWsqv5p/HquqzDGQp1OgVQQtnyp5d0hzOLMCQKRi7rKRESImNmns4JL0z6vU8tg
         LKt5v/r3uJgV5ZOxXVo6OId95pRKBRWWtB1Kw61WQu+wBqPPjfBMqiJAars5VXaoQfB3
         RtqVrVhXnUXvJR9Y1iPLkhJJMqLa9jtwfeIUuttjp6JwKNexRDZiYuJy+kMa8jkexTMO
         YZXRtz4LlV2mGuYgZu7XB6q3lDDLqnweisY4/b9m6zcOZ2nqyheI/qRCAjAhQC+BK40R
         HNGg==
X-Gm-Message-State: AOAM530JewHkiZ7XhgjDHysinEtKqzcNZ8JsyuaFvdMgIsuvV/7HZ4Al
        3oKkIKWAefXFZXOgRsUHtDxvM9sgoJaBGA==
X-Google-Smtp-Source: ABdhPJwFKavWiZ3Dezs+ZOs3vQX53fXnpVkQ+ckap/TcYSIFVSMwhXM3ayD5hsMMV4I+uej00H+O2A==
X-Received: by 2002:a17:902:9a02:b029:118:307e:a9dd with SMTP id v2-20020a1709029a02b0290118307ea9ddmr51053plp.47.1629147110301;
        Mon, 16 Aug 2021 13:51:50 -0700 (PDT)
Received: from lukehsiao.c.googlers.com.com (190.40.105.34.bc.googleusercontent.com. [34.105.40.190])
        by smtp.gmail.com with ESMTPSA id t30sm64087pgl.47.2021.08.16.13.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 13:51:49 -0700 (PDT)
From:   Luke Hsiao <luke.w.hsiao@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Luke Hsiao <lukehsiao@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next] tcp: enable data-less, empty-cookie SYN with TFO_SERVER_COOKIE_NOT_REQD
Date:   Mon, 16 Aug 2021 20:51:06 +0000
Message-Id: <20210816205105.2533289-1-luke.w.hsiao@gmail.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luke Hsiao <lukehsiao@google.com>

Since the original TFO server code was implemented in commit
168a8f58059a22feb9e9a2dcc1b8053dbbbc12ef ("tcp: TCP Fast Open Server -
main code path") the TFO server code has supported the sysctl bit flag
TFO_SERVER_COOKIE_NOT_REQD. Currently, when the TFO_SERVER_ENABLE and
TFO_SERVER_COOKIE_NOT_REQD sysctl bit flags are set, a server connection
will accept a SYN with N bytes of data (N > 0) that has no TFO cookie,
create a new fast open connection, process the incoming data in the SYN,
and make the connection ready for accepting. After accepting, the
connection is ready for read()/recvmsg() to read the N bytes of data in
the SYN, ready for write()/sendmsg() calls and data transmissions to
transmit data.

This commit changes an edge case in this feature by changing this
behavior to apply to (N >= 0) bytes of data in the SYN rather than only
(N > 0) bytes of data in the SYN. Now, a server will accept a data-less
SYN without a TFO cookie if TFO_SERVER_COOKIE_NOT_REQD is set.

Caveat! While this enables a new kind of TFO (data-less empty-cookie
SYN), some firewall rules setup may not work if they assume such packets
are not legit TFOs and will filter them.

Signed-off-by: Luke Hsiao <lukehsiao@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_fastopen.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 62ba8d0f2c60..59412d6354a0 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -368,8 +368,7 @@ struct sock *tcp_try_fastopen(struct sock *sk, struct sk_buff *skb,
 		return NULL;
 	}

-	if (syn_data &&
-	    tcp_fastopen_no_cookie(sk, dst, TFO_SERVER_COOKIE_NOT_REQD))
+	if (tcp_fastopen_no_cookie(sk, dst, TFO_SERVER_COOKIE_NOT_REQD))
 		goto fastopen;

 	if (foc->len == 0) {
--
2.33.0.rc1.237.g0d66db33f3-goog

