Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA15C6EA37
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731328AbfGSRbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 13:31:06 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46121 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728674AbfGSRbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 13:31:04 -0400
Received: by mail-qk1-f193.google.com with SMTP id r4so23737145qkm.13
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 10:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ybR7/gj4/DkvEmMT6/QJs1sBMwkRv51hpYWIGESVpo=;
        b=hUrbqEVh0YNQX97tZU8U6GR4ks6Bc0ZNekSwGPSfJa6jPK+k7LkfmEHc48k7kRjqJb
         x7LLZI9cWpaKEa601OsXqkoZ+yWTjqxhTBGJlF8hRscIwQsF5a5FoXZwRBLE+EQrgoK3
         H5Xh6zCbx8CNd6+DCw5dbrXsRoHnyGDqxLARNxl6uYG1Q7YWG6QTeOuJ0/mh73cc5olq
         OX8rz8SonFQ9lV9mh/Ev7OxbPdQlm+7v+h0prAl2qpYBYUlQoSKz23bWPp5l+EoWAA8p
         zBveoikAFf6F90vjkcdqSr0yIxyKojBr9HBpYg3qlaLnSzC3Zua7aiCw2iMLxKB1rL6g
         UMgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ybR7/gj4/DkvEmMT6/QJs1sBMwkRv51hpYWIGESVpo=;
        b=Z8aAnnAhowCJpp4ojJFhvt0ASS0+hQ4omQKH1sGw1bbIFH4p6FN8rVC26P1k3yjjbi
         Mv8Si2Rvgp+Cr+E8zxDxqRd72DCzWO0E4QmiVdThKqoq1H6ris80R2+U699Dv7D+oB+Y
         OWlyUDPt3mMBJ16KaBNQJN6Q3R5FxsYmxksdJ/W1WNDKxxf+Q8l2AXdzguL3LLUqrMOs
         jMZCcRzr5Z3ZOkkXLD8cfAma7BcFIqHloHEQgnFG182jZKk9HtmyYVI+vIyf7ewodiFx
         6aLH6tWje5uHmn9CB4NGufyxrsR7xysJ6lr2Pb2GTJvA4x2xm06fAHuDWulGIELFc/yn
         14Rg==
X-Gm-Message-State: APjAAAW27IvqQI/khSHOHjw75a8t/nKYwLH0ILa2A+WX5o0PkV6LBGKJ
        ZM+33ph4t/JQ6XVnxsJrBFRmAA==
X-Google-Smtp-Source: APXvYqw8c7q2FerMN7vf6wc7OcvsoMGqb/K36a04jUYPGHS8Q2Fvq1oPspR6sH6d4IZl5u9Kvi5Xhw==
X-Received: by 2002:a05:620a:10bc:: with SMTP id h28mr36035378qkk.289.1563557463707;
        Fri, 19 Jul 2019 10:31:03 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm15568509qtj.46.2019.07.19.10.31.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 10:31:03 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     edumazet@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH bpf v4 02/14] net/tls: don't call tls_sk_proto_close for hw record offload
Date:   Fri, 19 Jul 2019 10:29:15 -0700
Message-Id: <20190719172927.18181-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719172927.18181-1-jakub.kicinski@netronome.com>
References: <20190719172927.18181-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The deprecated TOE offload doesn't actually do anything in
tls_sk_proto_close() - all TLS code is skipped and context
not freed. Remove the callback to make it easier to refactor
tls_sk_proto_close().

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 85a9d7d57b32..7ab682ed99fa 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -271,9 +271,6 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 	lock_sock(sk);
 	sk_proto_close = ctx->sk_proto_close;
 
-	if (ctx->tx_conf == TLS_HW_RECORD && ctx->rx_conf == TLS_HW_RECORD)
-		goto skip_tx_cleanup;
-
 	if (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE) {
 		free_ctx = true;
 		goto skip_tx_cleanup;
@@ -766,7 +763,6 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 	prot[TLS_HW_RECORD][TLS_HW_RECORD] = *base;
 	prot[TLS_HW_RECORD][TLS_HW_RECORD].hash		= tls_hw_hash;
 	prot[TLS_HW_RECORD][TLS_HW_RECORD].unhash	= tls_hw_unhash;
-	prot[TLS_HW_RECORD][TLS_HW_RECORD].close	= tls_sk_proto_close;
 }
 
 static int tls_init(struct sock *sk)
-- 
2.21.0

