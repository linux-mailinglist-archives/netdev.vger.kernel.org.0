Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29037264F27
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgIJTgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgIJTfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:35:43 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51CFC061786
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:35:42 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id d20so7333972qka.5
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U+cpNIidHQ6fxKEUVmKluxGPC89GnSlzBt16B2787xM=;
        b=nqSDpCsh41lrb9OEGALmxFWRmbGN+D5oWaV0BsTWKe5AeTf00ATTTXWtRQMMeXgjJa
         Sc+qlrI2zKpJWENpFaRHj/CK1BC8mhIxnVgYZJ4q2vhL/znEmIooxKwD/42raeSfxNLJ
         /1UkIMW+8XEZ/gSwUGvijfjQrhxYDYIA/hcwvr3QLA2nub/gyiPNxN+FkKIAYBG4I338
         prZWRUx2cv1KEQbhllXQHJHNNp2vvxbi3HNx7R3a+h5RIzh9LsbTkTTc+uZYfrfZ+mRH
         xduXonFZ9poyBt2BsZ9srgLp28wVrVOKcjrXxK7CrOVm2a9E2GncSDGPou7TV187fXzl
         YZ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U+cpNIidHQ6fxKEUVmKluxGPC89GnSlzBt16B2787xM=;
        b=aBbzb6iXWs6NvztqinO2t4QpZ/k/pxGtMXaWP0303jCS7KmT+1Z6ILgSsHs3Oa8sDe
         /hZDe2cCmQkc1J2rxPdAKyGwyMiL5/ZO8B5aOywfrZGIIQsPFHT2DxxHnEwusXreHvXb
         n4KAOnlNBoJt4naZpAGIfbhj2xYxh2HGsWQ2YDRu2wtGtmf8WfCE+nFe43lmWmlFZBKn
         ssxMaAaSeT2panVYbEgNaRxmC+1e2c8e932Iv1TbOI7M7JTLAGa6FKrFnGl8Jhr8l1Q9
         o7Y14zNo5TkKFpb1tJVwlGG7OAfoBIJt7xnH3Qy+BmjbeBTq6DIlSgR0ZwGka60Zrz6t
         fUFA==
X-Gm-Message-State: AOAM531SLNhRErZKXJtSd+WCXbCp7IqqODIsXZr4aw09odfMLOm+ZlFy
        5YMFE+dKs7pquEJX2B9DGsFGZ805FPX4NMi9
X-Google-Smtp-Source: ABdhPJxc9ZOAG1Zttk1zkLw3nZQAKTcNdudW6exk7fxALIXc1/4rUa3MaFHXmbod6H6VzIs0ycRFww==
X-Received: by 2002:a37:62c3:: with SMTP id w186mr9754082qkb.227.1599766542226;
        Thu, 10 Sep 2020 12:35:42 -0700 (PDT)
Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
        by smtp.gmail.com with ESMTPSA id f13sm7735484qko.122.2020.09.10.12.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 12:35:41 -0700 (PDT)
From:   Neal Cardwell <ncardwell.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>
Subject: [PATCH bpf-next v3 4/5] tcp: simplify _bpf_setsockopt(): remove flags argument
Date:   Thu, 10 Sep 2020 15:35:35 -0400
Message-Id: <20200910193536.2980613-5-ncardwell.kernel@gmail.com>
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
2.28.0.618.gf4bc123cb7-goog

