Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7424A162BB6
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgBRRKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:10:42 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34289 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbgBRRKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:10:40 -0500
Received: by mail-wr1-f65.google.com with SMTP id n10so22942941wrm.1
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 09:10:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+hHczpFOnRi8oqlcy0FJMK8gVbFRbon0m2h2qz/AdmU=;
        b=WiPp6nqRPcgq/c/6hjAnV6AK064/mpAnBTnUNg/9CIE1RD+Dlpp7Y9KWIXZF1TKOvL
         YU/xlma7AKotwzbKbYIf+exk/tAdsEAXyWtF+ScqFTyjo3jukMOf7cCZocEHJj/jKJbj
         XHaRnm55qLHbGJ2t7f0NPl9serkpLM7rEECWw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+hHczpFOnRi8oqlcy0FJMK8gVbFRbon0m2h2qz/AdmU=;
        b=VUzD5KMR6hQhm9HKtXnQhvkp2kNx1vWrjOw/xmyxnGdXGdrGYj3eyUl64M3YDbb3ER
         6Q8L8Ix1LJhWKPjrcvvFShwclajjCA+suU58NSclCj449auWXhy4P2gArHhaOAle4sMm
         T5amGls5/R8u89pEzTbjqzvgCEAuJu2HO+Glj7Z1ec5urinldu+SdWIApWUn1uvrAA43
         1WcfupjCUcTxT37I9qolAboeDyqPcCF2Kviw+xlZySBGntPHl2pDfu7b42OzB6NmVDcT
         nO0jlrIAe4muT5XxYd7wIrKULSp+OKa2t1EjTzGuDVEXVqkM+THAL9vuwpyXa1qirqHI
         L8+Q==
X-Gm-Message-State: APjAAAVxJ9IS0vrCiEeqJZlOpdrZ9PKZwhTNMTmyMrk2FV0MCpiBqf0F
        DKIPv9+jSbYlpY/RY4K9MKuSvw==
X-Google-Smtp-Source: APXvYqwq07vTUR4t2WFUXgfpq6iK4qqQBcBtbjVb/5CZf6CJvRGBMdTeQkq8b44s3fcYInTLtBuPZg==
X-Received: by 2002:a05:6000:114f:: with SMTP id d15mr4420341wrx.130.1582045838326;
        Tue, 18 Feb 2020 09:10:38 -0800 (PST)
Received: from cloudflare.com ([88.157.168.82])
        by smtp.gmail.com with ESMTPSA id e1sm6892176wrt.84.2020.02.18.09.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 09:10:37 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v7 08/11] bpf: Allow selecting reuseport socket from a SOCKMAP/SOCKHASH
Date:   Tue, 18 Feb 2020 17:10:20 +0000
Message-Id: <20200218171023.844439-9-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218171023.844439-1-jakub@cloudflare.com>
References: <20200218171023.844439-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SOCKMAP & SOCKHASH now support storing references to listening
sockets. Nothing keeps us from using these map types a collection of
sockets to select from in BPF reuseport programs. Whitelist the map types
with the bpf_sk_select_reuseport helper.

The restriction that the socket has to be a member of a reuseport group
still applies. Sockets in SOCKMAP/SOCKHASH that don't have sk_reuseport_cb
set are not a valid target and we signal it with -EINVAL.

The main benefit from this change is that, in contrast to
REUSEPORT_SOCKARRAY, SOCK{MAP,HASH} don't impose a restriction that a
listening socket can be just one BPF map at the same time.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 kernel/bpf/verifier.c | 10 +++++++---
 net/core/filter.c     | 15 ++++++++++-----
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1cc945daa9c8..6d15dfbd4b88 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3693,14 +3693,16 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		if (func_id != BPF_FUNC_sk_redirect_map &&
 		    func_id != BPF_FUNC_sock_map_update &&
 		    func_id != BPF_FUNC_map_delete_elem &&
-		    func_id != BPF_FUNC_msg_redirect_map)
+		    func_id != BPF_FUNC_msg_redirect_map &&
+		    func_id != BPF_FUNC_sk_select_reuseport)
 			goto error;
 		break;
 	case BPF_MAP_TYPE_SOCKHASH:
 		if (func_id != BPF_FUNC_sk_redirect_hash &&
 		    func_id != BPF_FUNC_sock_hash_update &&
 		    func_id != BPF_FUNC_map_delete_elem &&
-		    func_id != BPF_FUNC_msg_redirect_hash)
+		    func_id != BPF_FUNC_msg_redirect_hash &&
+		    func_id != BPF_FUNC_sk_select_reuseport)
 			goto error;
 		break;
 	case BPF_MAP_TYPE_REUSEPORT_SOCKARRAY:
@@ -3774,7 +3776,9 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 			goto error;
 		break;
 	case BPF_FUNC_sk_select_reuseport:
-		if (map->map_type != BPF_MAP_TYPE_REUSEPORT_SOCKARRAY)
+		if (map->map_type != BPF_MAP_TYPE_REUSEPORT_SOCKARRAY &&
+		    map->map_type != BPF_MAP_TYPE_SOCKMAP &&
+		    map->map_type != BPF_MAP_TYPE_SOCKHASH)
 			goto error;
 		break;
 	case BPF_FUNC_map_peek_elem:
diff --git a/net/core/filter.c b/net/core/filter.c
index c180871e606d..77d2f471b3bb 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8620,6 +8620,7 @@ struct sock *bpf_run_sk_reuseport(struct sock_reuseport *reuse, struct sock *sk,
 BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 	   struct bpf_map *, map, void *, key, u32, flags)
 {
+	bool is_sockarray = map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY;
 	struct sock_reuseport *reuse;
 	struct sock *selected_sk;
 
@@ -8628,12 +8629,16 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 		return -ENOENT;
 
 	reuse = rcu_dereference(selected_sk->sk_reuseport_cb);
-	if (!reuse)
-		/* selected_sk is unhashed (e.g. by close()) after the
-		 * above map_lookup_elem().  Treat selected_sk has already
-		 * been removed from the map.
+	if (!reuse) {
+		/* reuseport_array has only sk with non NULL sk_reuseport_cb.
+		 * The only (!reuse) case here is - the sk has already been
+		 * unhashed (e.g. by close()), so treat it as -ENOENT.
+		 *
+		 * Other maps (e.g. sock_map) do not provide this guarantee and
+		 * the sk may never be in the reuseport group to begin with.
 		 */
-		return -ENOENT;
+		return is_sockarray ? -ENOENT : -EINVAL;
+	}
 
 	if (unlikely(reuse->reuseport_id != reuse_kern->reuseport_id)) {
 		struct sock *sk;
-- 
2.24.1

