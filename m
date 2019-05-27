Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 936822BC69
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 01:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfE0X47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 19:56:59 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:43534 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfE0X47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 19:56:59 -0400
Received: by mail-yb1-f201.google.com with SMTP id o145so6288767ybc.10
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 16:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=izA++VxkIHztgaXeH1A/Pm4IZe3y3qxRmX4i/idAuiI=;
        b=qR6LfazGvpGkqIurCyMcevHOjmiy9q6gsXUBaxDEtRNLqkUyl2JWEHB6V8zlSJJHlc
         n5yPnAOyd7vflraCfvoKraOMGJnEx8x8Elsh6Gus7bBAE8GEGMyAJIANbzHwiCU1Q28w
         d6U9rwi+gFEB+i8lY533B2WAWIFXIOgHXp9B7MtlWJuL+hx0v0M7C8EZGmEyzeEg2OIW
         E80DJTNS+9at6M84h6HjDu203oNNZRNxGLgOmXIJTUYjlfI8/158RNbhKAugzON+x+lu
         EGLixOhrer806u8QwVwdB+dcjZxG5tZZId+LRKVUgddEArzsP260OYoLglL8F1pAWd2H
         Db3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=izA++VxkIHztgaXeH1A/Pm4IZe3y3qxRmX4i/idAuiI=;
        b=BR/et39RoD2ctZ4jV8ElPPkN0oFbDFH3Isk6gdKn2PDR/V3w+f7NYJRtTE1YmY5ki2
         Lh6MW6ZDmeALhZPeQEb33/YZMaVxbKhQhDC2d+lG12PAICWCyWd2bu88M95E4e8zqxEb
         vwdd499AJhSSWr6YdGWUOE12f9MOaaVTpTFfdheTOqdypFduqLFWTR54u6xVJaIrwjMu
         59dyVaas4OBRWGVREN4K2mcFTGTYBqMk2euwySbc6Wmz8t2xqjH/shAZwjhYukbTIwko
         6Oe7iSFDn0UyjXFWR2j14+ACWGfjVJJIUzOm2TFDGzrcyx17IOjCTt3CUGkNFAKukf8X
         lcQw==
X-Gm-Message-State: APjAAAVjb2hjfulHmEQ/Dp7nTVsMCgfSDclyKlA4AJYHQ9ERBSdQxVa3
        7+sNsa850Eb7CJkFOAYvcxXHZpiJ0lbT2g==
X-Google-Smtp-Source: APXvYqyR6v5fgbggov4RYew6EyQhbZi7ViwpLKrxbj15yd7pn0On2lzNnt+Ud+IssXk2u9Nx+IxjUekFgoMB6g==
X-Received: by 2002:a81:70d0:: with SMTP id l199mr5019087ywc.397.1559001418000;
 Mon, 27 May 2019 16:56:58 -0700 (PDT)
Date:   Mon, 27 May 2019 16:56:47 -0700
In-Reply-To: <20190527235649.45274-1-edumazet@google.com>
Message-Id: <20190527235649.45274-2-edumazet@google.com>
Mime-Version: 1.0
References: <20190527235649.45274-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next 1/3] inet: frags: uninline fqdir_init()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fqdir_init() is not fast path and is getting bigger.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_frag.h  | 20 +-------------------
 net/ipv4/inet_fragment.c | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 002f23c1a1a7126e146f596300aee0e52b6cafc6..94092b1ef22e9729d99d56323a77faf1ea4c92a6 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -109,25 +109,7 @@ struct inet_frags {
 int inet_frags_init(struct inet_frags *);
 void inet_frags_fini(struct inet_frags *);
 
-static inline int fqdir_init(struct fqdir **fqdirp, struct inet_frags *f,
-			     struct net *net)
-{
-	struct fqdir *fqdir = kzalloc(sizeof(*fqdir), GFP_KERNEL);
-	int res;
-
-	if (!fqdir)
-		return -ENOMEM;
-	fqdir->f = f;
-	fqdir->net = net;
-	res = rhashtable_init(&fqdir->rhashtable, &fqdir->f->rhash_params);
-	if (res < 0) {
-		kfree(fqdir);
-		return res;
-	}
-	*fqdirp = fqdir;
-	return 0;
-}
-
+int fqdir_init(struct fqdir **fqdirp, struct inet_frags *f, struct net *net);
 void fqdir_exit(struct fqdir *fqdir);
 
 void inet_frag_kill(struct inet_frag_queue *q);
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 6ca9523374dab03737cd073a1aa990130c4a87ca..7c07aae969e6c84d4f0345b5c4852b2e37d088f6 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -154,6 +154,25 @@ static void fqdir_rwork_fn(struct work_struct *work)
 	kfree(fqdir);
 }
 
+int fqdir_init(struct fqdir **fqdirp, struct inet_frags *f, struct net *net)
+{
+	struct fqdir *fqdir = kzalloc(sizeof(*fqdir), GFP_KERNEL);
+	int res;
+
+	if (!fqdir)
+		return -ENOMEM;
+	fqdir->f = f;
+	fqdir->net = net;
+	res = rhashtable_init(&fqdir->rhashtable, &fqdir->f->rhash_params);
+	if (res < 0) {
+		kfree(fqdir);
+		return res;
+	}
+	*fqdirp = fqdir;
+	return 0;
+}
+EXPORT_SYMBOL(fqdir_init);
+
 void fqdir_exit(struct fqdir *fqdir)
 {
 	fqdir->high_thresh = 0; /* prevent creation of new frags */
-- 
2.22.0.rc1.257.g3120a18244-goog

