Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F85E3D8180
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbhG0VQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbhG0VQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:16:51 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26172C061764
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:16:51 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id ca5so1833270pjb.5
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SpZy1pS0Gg8JkmXUmGaVpmtafp37Y0lKYW1g3lNxRk4=;
        b=A77Hsrv/P1e/41H8BKtZ/n0QSSgOO6Ga9sE1GvbFMi+bKpQp87VSkYvioAmaQfpcBq
         eFv2yBCpv4YJQqBwgjjL2xdq+4FEL936SYjayprWVPJRoYxxFAc4biq4dgch9TexI5GE
         mBiaRsvTzv7gcKjwpSanM5FnLNXazFefox4os=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SpZy1pS0Gg8JkmXUmGaVpmtafp37Y0lKYW1g3lNxRk4=;
        b=f7BtLSANfnlZxDLut5WuKdlskexAE+CTkdJ4w2LhBNklviQ8YLIdVVeBODMiwgM7Wk
         oaKbTamHCciYoZstnwgxsKeW1aqLcNtPIXfr0z3pL37YHHGdDRQkB7JpJEPH6qVCXOEl
         jcAOfkb4mVt1DEn2Gotk9eLp5hlWJ/3P4DT8eVnF0EPjKpZTE+rUh4Pi2CejLlzhl/ca
         VN1xD46Or4EhvgMXtvMC35iwPqwnnKC3yRMRvY9wi4xARP9SQeL1KZWaQVAZnB1Uux4q
         JbESgVbvOfidh74BVRiOgKbbzz4tgTN8mPbzF1RgwBY3wzGMdqlSu1eA4c/p8G6GgoZM
         ecog==
X-Gm-Message-State: AOAM533/JchM1SKRm28XZuuFDsMR4gJnpiS5iuWx/7lEqeoWTSunlx01
        whb9HXC2Ksn+UvN4nnZ5+z40rQ==
X-Google-Smtp-Source: ABdhPJwJ5EsyyNwvu2BT/c057PIAzBypfNfC2iNOI+D8sMRvi2xP5fAmx2yzmyvWvNgjy2aoBfHqEw==
X-Received: by 2002:a63:cd4b:: with SMTP id a11mr25635035pgj.273.1627420610673;
        Tue, 27 Jul 2021 14:16:50 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q5sm3971112pjo.7.2021.07.27.14.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:16:50 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 57/64] netfilter: conntrack: Use struct_group() to zero struct nf_conn
Date:   Tue, 27 Jul 2021 13:58:48 -0700
Message-Id: <20210727205855.411487-58-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2310; h=from:subject; bh=s7DyCBPDaCq4d9JSsWLJ8+EongifST6biZFyx2UX6q8=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHONWBiPiNzo/t8OW3Ns6kZ2l8riv+DL/V9XSJtK Xd5HzDuJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzjQAKCRCJcvTf3G3AJsz7D/ 42pKBLJYcyHNJwO4YohbAAmhcoXAY8bmybN4HQPzp0zeFLNZqc2Mjb4rl3swZnOVaOVIL3tdvOiDgh i8NP+ht5TIItplmx8kwQTDPnNvvzlkJ82eWDHbvlZo9L/KkG3tB6q0ZoB5wyDwJ/WtKkX+tNlUGMRP OkokNS0HmTNz9ICaj7b7j9osXWGi57NUaXBtDDH/qH8MsT0lOJRU2Z4gVtlmQ4R2LKaBHTKEt6BHyM 60WMlTbzjKwmlSHB2aAoSUxJeN+xflQRuXnp9Z6gejpjykNWv/FHyosJTO5fvOqyY7fnbG5IP18fDs 13RH/EqMrXXtaC08nbTDiHc7xZZd07xjYusHaAykXGZ1M93N5Yyv4Ki7pupKpuLMhmBe3mMJ6R9V/9 uGqhRuL79KG+FrjRZBGe6WhgC/PPRmNIQiKGNNqoLP4kHNzZGslITSZJ/dhW1VxfIJC4CSyVjW5cgL prwEVJwtrbEMjXtHxTTF6YTc9ktMv2sS2o53nA9MrdPsxA9UV/yGCIxScUw8rTkzsu8Mk49on1WZf9 QEGh/Zy6T4S+lmbbiyXk3M1IAIDUYvs9WGAIYNlGzCMyk8XCDW9FUvuYcOQEU7XduJJ/wAhIG6MGew +7Dpxb4bbGybSLftmpNT3cPqKZ0HD+6F3Nbr82t0S06MwdOE0b2kHOrmjCYg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Replace the empty __nfct_init_offset member with a struct_group() to
mark the region of struct nf_conn that should be initialized to zero,
allowing memset() to correctly reason about the size of the write.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/net/netfilter/nf_conntrack.h | 20 ++++++++++----------
 net/netfilter/nf_conntrack_core.c    |  4 +---
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index cc663c68ddc4..51004fce2937 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -101,24 +101,24 @@ struct nf_conn {
 	struct hlist_node	nat_bysource;
 #endif
 	/* all members below initialized via memset */
-	struct { } __nfct_init_offset;
-
-	/* If we were expected by an expectation, this will be it */
-	struct nf_conn *master;
+	struct_group(init,
+		/* If we were expected by an expectation, this will be it */
+		struct nf_conn *master;
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
-	u_int32_t mark;
+		u_int32_t mark;
 #endif
 
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
-	u_int32_t secmark;
+		u_int32_t secmark;
 #endif
 
-	/* Extensions */
-	struct nf_ct_ext *ext;
+		/* Extensions */
+		struct nf_ct_ext *ext;
 
-	/* Storage reserved for other modules, must be the last member */
-	union nf_conntrack_proto proto;
+		/* Storage reserved for other modules, must be the last member */
+		union nf_conntrack_proto proto;
+	);
 };
 
 static inline struct nf_conn *
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 5c03e5106751..b05eb64ec788 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1527,9 +1527,7 @@ __nf_conntrack_alloc(struct net *net,
 	ct->status = 0;
 	ct->timeout = 0;
 	write_pnet(&ct->ct_net, net);
-	memset(&ct->__nfct_init_offset, 0,
-	       offsetof(struct nf_conn, proto) -
-	       offsetof(struct nf_conn, __nfct_init_offset));
+	memset(&ct->init, 0, sizeof(ct->init));
 
 	nf_ct_zone_add(ct, zone);
 
-- 
2.30.2

