Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8D930D28F
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhBCEUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbhBCESc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:18:32 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FD0C0617A9;
        Tue,  2 Feb 2021 20:17:13 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id t25so12038880otc.5;
        Tue, 02 Feb 2021 20:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0wUnpV/obp82NreuLykxFGGqjFKMgAiVjOGGr0jGMcU=;
        b=FaGgsDLSq3mLL5v/I5xuWWu9aBFL39PaQM+K6AwAgWudvaWJ+VlBDlac1u5l/onpmJ
         ph053zX+eODmxz88QrlBV841g/lBt0yPmMfVLIkP/IELFj6ESgOpZxsn/2992HJQaum0
         3+iOF7pL6eQ8BD0XysPsJe9NsgdM0J5lQG5YZKTf4+pDOIyf+kym2OdoK/DRbfL0wh3K
         08qgzQjdVZZ5D48e6jbHALTKGIF3SmZD1Qh+Tgypi9gbr1O3hUmMVpWtmxRcCURwQWbV
         N4lj/wfPfJQ1PppK/6jLrkTobNOAPyWs9TENXO4bhyJfDg/nC/9uDF9R+KiD/GKhMxHo
         Ij7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0wUnpV/obp82NreuLykxFGGqjFKMgAiVjOGGr0jGMcU=;
        b=POci3EdBG34/2xYlS2hVuZCSu1EN+BHa9WGgIhem0k1e4d3wKVPUYxYy5ejV8KLSGC
         9yw4w2Gia5Ve8rlKF6PgLo7OTJk0OzldFMPZUPpiWVa+9UHC+dj7znTwrClo8K8aLGC/
         BWe4fdP7NBBr1alib+SDDAqw6I47/jpiDp/nKx60qxCBPqVw2Um802EXH/LQjRSv3UCh
         Ejyldoecxm/oIaQZTvzO3YIlVzfnvsfKFxL9fX4RntDsdYYJ7DkOttirFkrgbGTeesR0
         etg807B19HhD1TmbkCofxi9VEwqnVvPAt8L89DdkMwQzJwmo0iXq7iz2z5302cL0vz66
         IDbg==
X-Gm-Message-State: AOAM532pFQTEnRmjcX87ZurrEEpsGU5vSUJlPQlCXpxjFfZA+UJB02wH
        sLRDkgLp6Idk4kd1s+LiFUW8X8fuZnG9xg==
X-Google-Smtp-Source: ABdhPJzhbdskf5D/hsrcvveDEXNmR6SeUuWh+YI3Ja+QIejYn7K0rt7S+CsjHPSxLbDWpTqLDWRnMw==
X-Received: by 2002:a9d:6852:: with SMTP id c18mr788253oto.166.1612325833043;
        Tue, 02 Feb 2021 20:17:13 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:90c4:ffea:6079:8a0c])
        by smtp.gmail.com with ESMTPSA id s10sm209978ool.35.2021.02.02.20.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 20:17:12 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next 13/19] af_unix: set TCP_ESTABLISHED for datagram sockets too
Date:   Tue,  2 Feb 2021 20:16:30 -0800
Message-Id: <20210203041636.38555-14-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently only unix stream socket sets TCP_ESTABLISHED,
datagram socket can set this too when they connect to its
peer socket. At least __ip4_datagram_connect() does the same.

This will be used by the next patch to determine whether an
AF_UNIX datagram socket can be redirected in sockmap.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/unix/af_unix.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 4ce12d3c369e..21c4406f879b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1206,6 +1206,8 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		unix_peer(sk) = other;
 		unix_state_double_unlock(sk, other);
 	}
+
+	sk->sk_state = other->sk_state = TCP_ESTABLISHED;
 	return 0;
 
 out_unlock:
@@ -1438,12 +1440,10 @@ static int unix_socketpair(struct socket *socka, struct socket *sockb)
 	init_peercred(ska);
 	init_peercred(skb);
 
-	if (ska->sk_type != SOCK_DGRAM) {
-		ska->sk_state = TCP_ESTABLISHED;
-		skb->sk_state = TCP_ESTABLISHED;
-		socka->state  = SS_CONNECTED;
-		sockb->state  = SS_CONNECTED;
-	}
+	ska->sk_state = TCP_ESTABLISHED;
+	skb->sk_state = TCP_ESTABLISHED;
+	socka->state  = SS_CONNECTED;
+	sockb->state  = SS_CONNECTED;
 	return 0;
 }
 
-- 
2.25.1

