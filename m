Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9500F8B819
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 14:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbfHMMIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 08:08:14 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39454 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfHMMIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 08:08:13 -0400
Received: by mail-pg1-f195.google.com with SMTP id u17so51159362pgi.6;
        Tue, 13 Aug 2019 05:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sqLnhHvWb1pYJOG96mznxLtUFrCsozUxEBwFZR41qYU=;
        b=R5fPH5jpnlpW2LB0OvQ/09A/ukgivy7W++yiMxJNSrRxSrJDkYNr9XuZ92zwB/NZ4+
         1V1jnzLoQy9E0/3LLbwuHpf94+TPvFrWnMSLY+C+2kfJtTQVX0FslsPaKx40MXPh/Rf1
         VcXisdzkaCJc2/EvgCdwMgNUot4ttsaSuKJb72w+9UG0oRg8pb5QRa7J5Ku/D0qvHasf
         jVOrYo7JwYLG1SCfekONJjdbbfEcEmWsbDgZsv7k9WkudousIbd9mLuTowndMC1vpZDn
         swqfOl6SlZfwDFX8nMqS/tSH8/jtnXWPCyG+N3ZI5kBz1u6wXxv4ERo4RTHd9/U0aAd4
         djbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sqLnhHvWb1pYJOG96mznxLtUFrCsozUxEBwFZR41qYU=;
        b=nPBGkPat7pmuq9u1dSKU+J7EIpJ70DEvy1KtiWMi9KYJujESehJM1bKSvsVc4NwcNQ
         m4V/omG8uBWyEQ/TCtVbWGdw2w1KX88Gm67Sb10KnMwLZbRKQx302CR72A8rA8ngEwXD
         yVuW0jZCPzDzY3nc1VnRC8wjPamRbxlcTM+wGwze3XQF58ldzr2xx2YFYI5PtcVehjGg
         eJUi2zGBG22l5v8BdZcTBOJNARBTbsVZnKWKg3F6018hVg37aVMgHU52wSR32IUOtCBq
         xEW44VuYxi4uJ6/F/vrTjf68qrhGA29v7W69UVRwb/sXPHdddYhZM6URbKgpROAEmLF/
         dDew==
X-Gm-Message-State: APjAAAXGBAr1Ejo00pPDLr6qz0SewxsRKNRLFvsQccVGEz0GhFao5p3D
        BfpPt3jXqCBWjuJ12+PWNlo=
X-Google-Smtp-Source: APXvYqzOLBIpKruIrN+pdC6zB0JrdgpaIcYhgQwPP0Ok4ayQ9LQDTomDipedDKnF0CfXNsMaCp8Tqw==
X-Received: by 2002:a62:1808:: with SMTP id 8mr14528787pfy.177.1565698092949;
        Tue, 13 Aug 2019 05:08:12 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id o9sm73251099pgv.19.2019.08.13.05.08.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 05:08:12 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>
Subject: [RFC PATCH bpf-next 14/14] bpf, hashtab: Compare keys in long
Date:   Tue, 13 Aug 2019 21:05:58 +0900
Message-Id: <20190813120558.6151-15-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

memcmp() is generally slow. Compare keys in long if possible.
This improves xdp_flow performance.
This is included in this series just to demonstrate to what extent
xdp_flow performance can increase.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 kernel/bpf/hashtab.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 22066a6..8b5ffd4 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -417,6 +417,29 @@ static inline struct hlist_nulls_head *select_bucket(struct bpf_htab *htab, u32
 	return &__select_bucket(htab, hash)->head;
 }
 
+/* key1 must be aligned to sizeof long */
+static bool key_equal(void *key1, void *key2, u32 size)
+{
+	/* Check for key1 */
+	BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct htab_elem, key),
+				 sizeof(long)));
+
+	if (IS_ALIGNED((unsigned long)key2 | (unsigned long)size,
+		       sizeof(long))) {
+		unsigned long *lkey1, *lkey2;
+
+		for (lkey1 = key1, lkey2 = key2; size > 0;
+		     lkey1++, lkey2++, size -= sizeof(long)) {
+			if (*lkey1 != *lkey2)
+				return false;
+		}
+
+		return true;
+	}
+
+	return !memcmp(key1, key2, size);
+}
+
 /* this lookup function can only be called with bucket lock taken */
 static struct htab_elem *lookup_elem_raw(struct hlist_nulls_head *head, u32 hash,
 					 void *key, u32 key_size)
@@ -425,7 +448,7 @@ static struct htab_elem *lookup_elem_raw(struct hlist_nulls_head *head, u32 hash
 	struct htab_elem *l;
 
 	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
-		if (l->hash == hash && !memcmp(&l->key, key, key_size))
+		if (l->hash == hash && key_equal(&l->key, key, key_size))
 			return l;
 
 	return NULL;
@@ -444,7 +467,7 @@ static struct htab_elem *lookup_nulls_elem_raw(struct hlist_nulls_head *head,
 
 again:
 	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
-		if (l->hash == hash && !memcmp(&l->key, key, key_size))
+		if (l->hash == hash && key_equal(&l->key, key, key_size))
 			return l;
 
 	if (unlikely(get_nulls_value(n) != (hash & (n_buckets - 1))))
-- 
1.8.3.1

