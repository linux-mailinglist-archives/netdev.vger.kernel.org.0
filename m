Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D276D3D6544
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240429AbhGZQcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240338AbhGZQcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 12:32:43 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F6BC0AC0CE;
        Mon, 26 Jul 2021 09:53:26 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id f11so12706754ioj.3;
        Mon, 26 Jul 2021 09:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UZifGDj0i72OMHcbWcN8+M1mnLi/8e3/AA0xyn+AGvc=;
        b=TzZ18Hrex36L87kF89E++KSxz80ImxqbtHqCQN0JTyYoUKl/zCtD5nAP6WDyZwk5+N
         aEGGlEB0V+nZB+kAoPKbBnFcqO3/f5Bi9z0Ful9XJ2q3ru1kQ1kr0GTGZ6vfCMtG8JDP
         vtXU10KZ6Gnp3SpRhYFMOxSOmi5/sL9IETUR0pqN8YJC6Fn61PSIEh8m8Het2rfZqL1S
         fFCT3uCMZCuHxYrX1H1CxbBA/nGw2ueOMHq63v0NbkNqox2rhW/E38FJHpy+tqu+4ErT
         /wBKRRbtGvi3uerEQS6GJWXglv663L/FVCr9iV8QBMWA8/BpMPbYyjFk2Ve4qHYkVqH9
         cNdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UZifGDj0i72OMHcbWcN8+M1mnLi/8e3/AA0xyn+AGvc=;
        b=I+46nEUSKIGZHaF5nucuWHijmzP4oIR5zSQtsAYbYUitubmCWOFSBLIw2onQyXeicl
         ZcpmsVfD7BzEgoOaQBcKtl2uPvDPbBCypXN+NuxCTQ70CebaYQnR1wWpqM6pFkw/YSRv
         BKbRW9apEmPtP+UoPgaCmCF5+a/kKKGWkg5Mh3/J+wzUzhLKnRXii75lDWjb9/UUlmfJ
         amK2G4O+6KBBB2Idbx6TomNyy2S/hnM1oFHRTN74zmSe69DlDpWfy2Cz+D0JAu1TKcav
         4SjkYRjWV5qoYLH+8gDKDZo24yjU96n5iFiHdZHA9w0EOtnwuYHgc+hLH0x0UB5V6u4X
         UZDg==
X-Gm-Message-State: AOAM530P9TUkwijJxA4Cxz4rn9jHrsWxv4gLXwqPoQBlpprrj7Vp/tSb
        KqRGOxe4TPuAF29O8zoKy1c=
X-Google-Smtp-Source: ABdhPJyGvspgt+x6J3NGSFAp7FJMoJEQqq1Uk5zVCenOgzzZLJevUjY+3JczGSkvylObgZag4Utqpg==
X-Received: by 2002:a02:9626:: with SMTP id c35mr17274763jai.84.1627318405617;
        Mon, 26 Jul 2021 09:53:25 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id r198sm254483ior.7.2021.07.26.09.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 09:53:25 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net,
        xiyou.wangcong@gmail.com, alexei.starovoitov@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        john.fastabend@gmail.com
Subject: [PATCH bpf v2 1/3] bpf, sockmap: zap ingress queues after stopping strparser
Date:   Mon, 26 Jul 2021 09:53:02 -0700
Message-Id: <20210726165304.1443836-2-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726165304.1443836-1-john.fastabend@gmail.com>
References: <20210726165304.1443836-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't want strparser to run and pass skbs into skmsg handlers when
the psock is null. We just sk_drop them in this case. When removing
a live socket from map it means extra drops that we do not need to
incur. Move the zap below strparser close to avoid this condition.

This way we stop the stream parser first stopping it from processing
packets and then delete the psock.

Fixes: a136678c0bdbb ("bpf: sk_msg, zap ingress queue on psock down")
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 15d71288e741..28115ef742e8 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -773,8 +773,6 @@ static void sk_psock_destroy(struct work_struct *work)
 
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 {
-	sk_psock_stop(psock, false);
-
 	write_lock_bh(&sk->sk_callback_lock);
 	sk_psock_restore_proto(sk, psock);
 	rcu_assign_sk_user_data(sk, NULL);
@@ -784,6 +782,8 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 		sk_psock_stop_verdict(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
 
+	sk_psock_stop(psock, false);
+
 	INIT_RCU_WORK(&psock->rwork, sk_psock_destroy);
 	queue_rcu_work(system_wq, &psock->rwork);
 }
-- 
2.25.1

