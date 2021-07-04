Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED9C3BAE86
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 21:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhGDTFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 15:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhGDTFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 15:05:47 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F677C061762;
        Sun,  4 Jul 2021 12:03:12 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id d1-20020a4ad3410000b029024c4d2ea72aso3933727oos.4;
        Sun, 04 Jul 2021 12:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9uGAz049IX75nMdfOYnDXXm0Hw/xQddkbeLasyfCyVs=;
        b=hjARaeEokkf0nA6tqh1o/fo1F7g+fArZzAEOYbNMIbLTA31RIXn04dsGQzyTPQE98c
         fECw2BdKOmbsbhsNQQ28Lrlpd/9m+IJct99lvfaEiQD++AoJaUTvC6IFQYfumwkrKGVj
         kfifjLQn7E1St4x+Q6BO6p0ncC6O/8ycPJZnk2TW+s/KU6GbgzJxOg2YUMc4k+uLE7IB
         caAR27DcXNM0ixUJ3f3x4LtpHItobRNpAincdXGTavYm+5dllE8E42z2P5GFlsd6emyi
         M8brUSL5fFBtjNydkScuXMAbwukHPaQgKqRvm6P402xehKVGVI7Q5RorjBgdgHqbdSfX
         Xx4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9uGAz049IX75nMdfOYnDXXm0Hw/xQddkbeLasyfCyVs=;
        b=rlHrzf2m4BM9hOy8PQQ5RCffJPZ01o+vxinJf2OFSq3MMTCzmC1vy2GsA+TT7fvLD8
         OCrAuIJHWdYl2KO9pWUskY+Qgi5MAcBYZBZOLRpPIuwdpuryUplldZkHJ1LOhzY9d0E7
         6B/fHYhqLU4OsKfg+thu3We0st4LpBuFu8sjRMZXtZdSgNhhKQAYSg5mBoNnOMPd2wGo
         FmYo7BX1ImHaUHfmlnVzaJ95TBhzCUi8wHEenBYct21lQ8omRcvUeCFQ0jU9xY8y2Ldq
         FgaM0agqM18NUtOUqEV27s/JrXoTzAEItB+GfeUzVrcItSLGBiL/i7JglOgzrzBz5Iaf
         ZBxw==
X-Gm-Message-State: AOAM530B1ujZqG6GOPm/7wKdpDEvcHuv5STaNnrRoyWQ5PKnlxleEMfI
        lOj0L0gpy1pXKBrDo+dT2jVBCLnNS54=
X-Google-Smtp-Source: ABdhPJyLMOCV/opvodDOZnj8qXKd33oXH5bqHfkzRicAiudhBf7sG6rCK3NW7UCN+MAB9ByKiizS8A==
X-Received: by 2002:a4a:d126:: with SMTP id n6mr4773945oor.86.1625425391302;
        Sun, 04 Jul 2021 12:03:11 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id 186sm1865848ooe.28.2021.07.04.12.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 12:03:11 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v5 05/11] af_unix: add a dummy ->close() for sockmap
Date:   Sun,  4 Jul 2021 12:02:46 -0700
Message-Id: <20210704190252.11866-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
References: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Unlike af_inet, unix_proto is very different, it does not even
have a ->close(). We have to add a dummy implementation to
satisfy sockmap. Normally it is just a nop, it is introduced only
for sockmap to replace it.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/unix/af_unix.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 77fb3910e1c3..875eeaaddc07 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -781,10 +781,18 @@ static const struct proto_ops unix_seqpacket_ops = {
 	.show_fdinfo =	unix_show_fdinfo,
 };
 
+static void unix_close(struct sock *sk, long timeout)
+{
+	/* Nothing to do here, unix socket does not need a ->close().
+	 * This is merely for sockmap.
+	 */
+}
+
 static struct proto unix_proto = {
 	.name			= "UNIX",
 	.owner			= THIS_MODULE,
 	.obj_size		= sizeof(struct unix_sock),
+	.close			= unix_close,
 };
 
 static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
@@ -868,6 +876,7 @@ static int unix_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	sk->sk_prot->close(sk, 0);
 	unix_release_sock(sk, 0);
 	sock->sk = NULL;
 
-- 
2.27.0

