Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5EE3DC810
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 21:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhGaTuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 15:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbhGaTuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 15:50:50 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273FFC0613D3;
        Sat, 31 Jul 2021 12:50:43 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id w10so8988712qtj.3;
        Sat, 31 Jul 2021 12:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ayu4vfMndlZW5WGCrw1rqSAOKk0P76YB/xav7o1Hf+4=;
        b=Gr8FORc3YngmE8XFwKNWzyx7+LfvuctYkr6XFIFq4pL6UqJEJKNAzGdc7tbKIWiuon
         Gt8LgM1PxZ+cY2N0VtpWYzPmbMYRI5P3wEDggePi8xnjdidQyqXcSOcsDTJvpiJk0nqV
         KkO22ASLFjwzIxBNtJObYKMqLwI+iqlN4OhtglYBR2uwYmyemez3KCvdGKl+s8Rt1mLm
         mruS9S/24lX2VetFUP4ddNX/ftTmDzgxaMXHTMsFWEQgjzNVVztcF6T+MNlrSncV8FqJ
         I4Ab3qwvdlHXOKa3vMScxt6al7K7TmyypL/F4xvi/PxSR9UFUOmNdl1/jGWqDqz8KmqX
         WiAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ayu4vfMndlZW5WGCrw1rqSAOKk0P76YB/xav7o1Hf+4=;
        b=KnBICpUC1ojjWS9IZbOq6INQMxY/aYHFy/AymZZrh8gCBDlPXiFO0CNNfl/g9LXdwS
         AKZBrO/LkHXVW1HqfurrvKWTIw4ITV/wI1iHMDphhxHmgco+QxT5ArgwZRxF5lGf9a12
         imM+p7oeA/GM2dwCQsKG9ybYDWxKT4B//fIE4MLrnV3sLKoxiedLAMXSB3eRXi9LAABq
         peo9fUDWlDtJe4PailLV53wuMKDQ9vsvjJvch/RQh3poZVo1AI58dzqxsOyAMOkshqol
         Bik26U9OHZXQIhH+wgKrWRSTcICbYZc9+pmG8vpHKrUtq7TaMBtsyawFHagoHEP7rfUF
         9ckg==
X-Gm-Message-State: AOAM531dPigIdZB7+rMxeNG85nrFCw6KVOLLY6eVV0QHpa209AX+k5Rr
        i14KiptTJ7WV4TENvzlcojmeAxXGyJc=
X-Google-Smtp-Source: ABdhPJy1c04UXayGOUV1H6N2NwXEhgX84PdssGW4fAZRNCeCGj6Fjm5HG5ocZjv6CaPoT0Z60V3Ang==
X-Received: by 2002:ac8:5401:: with SMTP id b1mr7700344qtq.112.1627761042160;
        Sat, 31 Jul 2021 12:50:42 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:6537:b4e6:3746:97a9])
        by smtp.gmail.com with ESMTPSA id d129sm2984823qkf.136.2021.07.31.12.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 12:50:41 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next] unix_bpf: check socket type in unix_bpf_update_proto()
Date:   Sat, 31 Jul 2021 12:50:38 -0700
Message-Id: <20210731195038.8084-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

As of now, only AF_UNIX datagram socket supports sockmap.
But unix_proto is shared for all kinds of AF_UNIX sockets,
so we have to check the socket type in
unix_bpf_update_proto() to explicitly reject other types,
otherwise they could be added into sockmap too.

Fixes: c63829182c37 ("af_unix: Implement ->psock_update_sk_prot()")
Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/unix/unix_bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index 177e883f451e..20f53575b5c9 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -105,6 +105,9 @@ static void unix_bpf_check_needs_rebuild(struct proto *ops)
 
 int unix_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 {
+	if (sk->sk_type != SOCK_DGRAM)
+		return -EOPNOTSUPP;
+
 	if (restore) {
 		sk->sk_write_space = psock->saved_write_space;
 		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
-- 
2.27.0

