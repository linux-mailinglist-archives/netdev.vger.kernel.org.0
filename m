Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F188A264E8D
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgIJTSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbgIJTSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:18:41 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F48C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:18:40 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id w16so7255584qkj.7
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YGm/soZLl1bn+sbVRybjYRZ/1L0c9JD9QdtdQnC5uSA=;
        b=RZTd/hTzvCAOXXKWq+3RHc7eTDwyVhdsrfB1xz9CONVK+V+hobTP3Vazx0ZSxxNtrc
         SIOhOO4LB0LKUO8b/0/j6dUMrPDSnoI5tND7ouNxwtG1NmgZaTvwfjGZ1GboE7ktoru6
         qjk5G25oQjnC3iILTTdlFGJQndEuZ6YFzqGWLUKPhlZ2aQZJtwDi8pfe7Vl0+I1UjWc0
         6+dzzUPst/uD8NT3xnI7afsxn7Kkw77MMIVy2gQKXIMy/VZ02PaFbOf5BtIrtr5u5uFs
         llsMOV5Va2Yruyj6JBlWeGLFhPce3Zg3DNNwez5gHR1PONO8d3QpVD2qRAN9uOs0zgEL
         sK/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YGm/soZLl1bn+sbVRybjYRZ/1L0c9JD9QdtdQnC5uSA=;
        b=QzptseK8iTHEZEcEh4QLbO74nr0jfijiC3ko9A9Z74bRx0xM9RYahdtBGLc9bhdqn+
         iC/QwUC4O78yaKOXn4PPBgKuhESmjnci1+ICvd/IpKy+tl7j6v0Qo8ngjncGeAL9R9Wx
         obTEESWjRD6dlo6HJJLxIzjE7Mndx0eCGnSQIN+qORvpWaXiI3wNgzTiZsrPL5eQH2PE
         VX7yNSIWzOvgKNer7Vv15+3fAsW9C+gBOJYoob0v4bw0QCGV9HtSS1tIFIBBKG+og21e
         YYRTu+w5+3GuFDnxsIq09Vjzz84MVInkGwPKwBxLEeNH9AcnMstMPpPRnNvg5Atneipe
         BD3g==
X-Gm-Message-State: AOAM532M04fH+QR7Nj16Y/oRNYcrmNV90kfDyZ0f6lctaB5bbJRZSkI+
        AiMJd51U5vBf9ldLJ3u3ntIP4hjYO5rUEnDy
X-Google-Smtp-Source: ABdhPJwTeRj+TKOR65/XXRHtkYAAyWNQjucG72kH1t685JlG/yJVknwFI65siofuJjk1vPjy/FyyBA==
X-Received: by 2002:a37:a88a:: with SMTP id r132mr9073929qke.270.1599765520131;
        Thu, 10 Sep 2020 12:18:40 -0700 (PDT)
Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
        by smtp.gmail.com with ESMTPSA id v131sm1917623qkb.15.2020.09.10.12.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 12:18:39 -0700 (PDT)
From:   Neal Cardwell <ncardwell.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>
Subject: [PATCH bpf-next v2 4/5] tcp: simplify _bpf_setsockopt(): remove flags argument
Date:   Thu, 10 Sep 2020 15:18:38 -0400
Message-Id: <20200910191838.2870445-1-ncardwell.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

Now that the previous patches have removed the code that uses the
flags argument to _bpf_setsockopt(), we can remove that argument.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Kevin Yang <yyd@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Lawrence Brakmo <brakmo@fb.com>
---
 net/core/filter.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index e89d6d7da03c..d266c6941967 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4314,7 +4314,7 @@ static const struct bpf_func_proto bpf_get_socket_uid_proto = {
 };
 
 static int _bpf_setsockopt(struct sock *sk, int level, int optname,
-			   char *optval, int optlen, u32 flags)
+			   char *optval, int optlen)
 {
 	char devname[IFNAMSIZ];
 	int val, valbool;
@@ -4611,9 +4611,7 @@ static int _bpf_getsockopt(struct sock *sk, int level, int optname,
 BPF_CALL_5(bpf_sock_addr_setsockopt, struct bpf_sock_addr_kern *, ctx,
 	   int, level, int, optname, char *, optval, int, optlen)
 {
-	u32 flags = 0;
-	return _bpf_setsockopt(ctx->sk, level, optname, optval, optlen,
-			       flags);
+	return _bpf_setsockopt(ctx->sk, level, optname, optval, optlen);
 }
 
 static const struct bpf_func_proto bpf_sock_addr_setsockopt_proto = {
@@ -4647,9 +4645,7 @@ static const struct bpf_func_proto bpf_sock_addr_getsockopt_proto = {
 BPF_CALL_5(bpf_sock_ops_setsockopt, struct bpf_sock_ops_kern *, bpf_sock,
 	   int, level, int, optname, char *, optval, int, optlen)
 {
-	u32 flags = 0;
-	return _bpf_setsockopt(bpf_sock->sk, level, optname, optval, optlen,
-			       flags);
+	return _bpf_setsockopt(bpf_sock->sk, level, optname, optval, optlen);
 }
 
 static const struct bpf_func_proto bpf_sock_ops_setsockopt_proto = {
-- 
2.28.0.526.ge36021eeef-goog

