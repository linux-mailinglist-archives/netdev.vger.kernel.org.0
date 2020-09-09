Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAEE2635B4
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgIISQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbgIISQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:16:18 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FEAC0613ED
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:16:18 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id j19so2366318qtp.19
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 11:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=4Bo8k752TngfvSPwFQPE6LI4lf2Fv96GhXQ3nj1PVkw=;
        b=DUw/b7np9Bf9ygXfRBl+rrBq1IkOF5by/ZsNubDyCERIjjBnGmLf2mvLxmof00oGZn
         zqBWocafLjaCt7msk2DvvI4ZH0K4ChlxFImIvHANIqzvbECEawJpNZCENJzlx+Lv+kN7
         MCxdE9IW52KfjQMpKP7OEF+lt3TnmM9ajsNCWvorx9vJZCn8kJ+h0iiXkDG1O79qm0hx
         1DSQbEfPOBDsR8pKFRMCNEw9sEm9d2JBZbESX0L2/aWD3wg+aVs0RxQTpLrc0/f7CNHL
         9T9O7yZXa1U1sBg+vrl9Uv9a6qEtK328x01VdauGbRzNR1a+cx6yV7NQHkyBXL9Zt9yd
         3u1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4Bo8k752TngfvSPwFQPE6LI4lf2Fv96GhXQ3nj1PVkw=;
        b=kIOqj1YeqX6RD4tFa6UjL4j5oHJPYpPKxL65xr+cOSPRO9Jpg4C/GX7fJDqZ8xNE6t
         i7b+6b7FR5j7qlMbe1WMvvJIwEEjznr0qxEo4hPxbZqfwr0iNquAKuILGq7glFFEeEEJ
         a6N6HLtpmV7Ca02UcoLq7At722DR8t8GnOhjaY8CGi1RgW03vHTbPqZm/jDtuyZGiqY4
         K2GW1iWwVEXCtPlGx2R6Zsqr/CGkVQCp6GS2kxR14+/oReyZ2feaAazqN7My6PhaArL7
         tS0x+Zs666hKIuVGlIgVspPfLOAr3uLxHQxGIY2ASZGy2bI8RsMZCkPrzwHqIMvtLS8y
         cYWw==
X-Gm-Message-State: AOAM530qBJgHAnicekfcvduObZwTRCaLjpB5h2TU1pb/gGWkKBbO8nHF
        dYKQREr+j8Swm6eZvY9Cfaf1hKg91iU1WHk=
X-Google-Smtp-Source: ABdhPJwUbxXyCeWv3K+1MT4XcWK1Ju8Ou35T1SajYleKucusDTOp7vGNdk3hrTJ0ZtvH2Ub9GNgJYJ97xZCScE4=
X-Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
 (user=ncardwell job=sendgmr) by 2002:a05:6214:6e8:: with SMTP id
 bk8mr5467759qvb.18.1599675377148; Wed, 09 Sep 2020 11:16:17 -0700 (PDT)
Date:   Wed,  9 Sep 2020 14:15:56 -0400
In-Reply-To: <20200909181556.2945496-1-ncardwell@google.com>
Message-Id: <20200909181556.2945496-5-ncardwell@google.com>
Mime-Version: 1.0
References: <20200909181556.2945496-1-ncardwell@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net-next 4/4] tcp: simplify _bpf_setsockopt(): remove flags argument
From:   Neal Cardwell <ncardwell@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index 0bd0a97ee951..b393528913f2 100644
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

