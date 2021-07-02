Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA183B99EE
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 02:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbhGBAOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 20:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbhGBAO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 20:14:29 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD802C061762;
        Thu,  1 Jul 2021 17:11:57 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id g3so8178248ilj.7;
        Thu, 01 Jul 2021 17:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/u4U2tQ+aacHBevuu9MBKUgp3LrIgZs5N/Tklyr9zUo=;
        b=Gc+mfUcIQwE1kpduy/f3CcyfAgaEZRDlyv1iuPxNgDcAjYytjj0lexW9Mbyy5JkHxE
         J9r4PY9P74jJsOVTxPw+GUYpTH2xAHFmpaq4fgEitYHtMxsIna8uRULtAZD+HWA1WXGu
         MOg17Rv+Lg8NQmujy2KQdTxwTrsGsfLOvoyGNHHBKCicpYO/p6EpYVYpUslp9N/2TOfA
         67xf/dEL6ZvNegPsiKWyAodVzsb4UmlEqtZfF7JZrr48JxRgL3B8VpuzXtf6XVBcIeu3
         9icIlRuPoZ4sYTv7tFtKqgkbeHONarna52YAmRiwJVIpgKSMcvbuYHmTOnmSA9uuwO4X
         Gk2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/u4U2tQ+aacHBevuu9MBKUgp3LrIgZs5N/Tklyr9zUo=;
        b=RS4PV5heETrKLppYTqN9eIjbWopDjfsD/ZStXD21nuBxfcMzoauyQBoCagCUM2k/Xt
         abnHF8e7yi8E+nN9xZAvVDO1LJQAHtBwDBg3cjCFYBcY+i2zu+gaJRb4BW91YuR9dGa9
         FhxWk97FvXFzmTeXykwJ6c7WC/NhOLrjA6sHeBGDVG9zP3i8O0zP/SisNv+eumkWvzHT
         FpVw1KOKO6zqgwR6TZJ6xvWj9lSGI0sSRDNlR4eo8ea/q7pPA4JxhWM4kYGKTTSEFA/n
         USdOVawCCdveewhhXB2CThiuHKy1T8aWaRyGw3Em/dRhTd25e4a2h7eZNPridqga+V69
         POBw==
X-Gm-Message-State: AOAM530n2oJxFIs1KH4xRe5zAR7ZOE3zCgd1TxnBjhPm+uNNZZYNlPDG
        yr2OnjZ71ryoahsYEGSe+ZQ=
X-Google-Smtp-Source: ABdhPJyALz1BOitl2Yy7Ktv+QBDy4J1g6+vUha2fX02aXy5zCdvh4m72/nU/WZSDc3SvN2sf0pFFUw==
X-Received: by 2002:a92:3610:: with SMTP id d16mr739552ila.16.1625184717172;
        Thu, 01 Jul 2021 17:11:57 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id c23sm704010ioz.42.2021.07.01.17.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 17:11:56 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        john.fastabend@gmail.com
Subject: [PATCH v2 bpf 2/2] bpf, sockmap: sk_prot needs inuse_idx for proc stats
Date:   Thu,  1 Jul 2021 17:11:23 -0700
Message-Id: <20210702001123.728035-3-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210702001123.728035-1-john.fastabend@gmail.com>
References: <20210702001123.728035-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Proc socket stats use sk_prot->inuse_idx value to record inuse sock stats.
We currently do not set this correctly from sockmap side. The result is
reading sock stats '/proc/net/sockstat' gives incorrect values. The
socket counter is incremented correctly, but because we don't set the
counter correctly when we replace sk_prot we may omit the decrement.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/sock_map.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 60decd6420ca..016ea5460f8f 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -222,6 +222,9 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 	struct bpf_prog *msg_parser = NULL;
 	struct sk_psock *psock;
 	int ret;
+#ifdef CONFIG_PROC_FS
+	int idx;
+#endif
 
 	/* Only sockets we can redirect into/from in BPF need to hold
 	 * refs to parser/verdict progs and have their sk_data_ready
@@ -293,9 +296,15 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 	if (msg_parser)
 		psock_set_prog(&psock->progs.msg_parser, msg_parser);
 
+#ifdef CONFIG_PROC_FS
+	idx = sk->sk_prot->inuse_idx;
+#endif
 	ret = sock_map_init_proto(sk, psock);
 	if (ret < 0)
 		goto out_drop;
+#ifdef CONFIG_PROC_FS
+	sk->sk_prot->inuse_idx = idx;
+#endif
 
 	write_lock_bh(&sk->sk_callback_lock);
 	if (stream_parser && stream_verdict && !psock->saved_data_ready) {
-- 
2.25.1

