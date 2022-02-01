Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0D44A63FE
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 19:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240640AbiBASfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 13:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233694AbiBASfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 13:35:22 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1C8C061714;
        Tue,  1 Feb 2022 10:35:22 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id e9so16126114pgb.3;
        Tue, 01 Feb 2022 10:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pz4b+3hAzSNvbeySYsUx19b9eBiW1i8lIctlQ7uzXAg=;
        b=eUP+P7e2hUdpYsLP3G9fGpdBbMh7sB3G9ATGmOgGcpVIBMPT51kzL8J6WQBwKx7sKk
         SVvRNLwRUOVggbE4J5cD9kH/EWDu04w/eWbgIgXCJPmSLocpjuwuL9f6dxSNvZKl9zY7
         LHoZS/zQ+G44gpOT7BuAUfHh2oI+dmzTPqNLA9pU+aYHsXdkC20mL7nj/TYdvi4fBq1o
         WwUuXw90Rg7gHWeLE3x5KJtEocbVkXO4jQ5eRGnGytyMBwo5I+J97TtEux6ig91umBae
         kCF4i+j32YK3fLkmHN4kEU+wX7tLhOdLAc2a4T9w5cxONdp624GWBa2U3A7hCmFUchIg
         KZ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pz4b+3hAzSNvbeySYsUx19b9eBiW1i8lIctlQ7uzXAg=;
        b=LXS1fhETbcdhPK28S617X5GT9eH6a7xF4edMqhtheg44lJ7Com56D7bR3Zo+i4NtAm
         YfPaKaYKMf2kgQuQFeHJCnyK/0qTGyGTPhSbGy3vVKErt0G11jB+AtG0ExRwcShUVxl8
         tikG/9XwVM08DA+vXreBS915H3qKqbNzHI3a0tAyPUFDi/FVjS0WUcsmaq3C76Di097D
         pbUSTc7WKul33qYjkfLbvVE2TQiZW1JsbcNzHlCPBvce/FhQL7sQR8BIizxHWEX5tL0K
         2lfYGDGokVyJPSs7WUA8dB6gxTJCR1V7Nl1HZGqlTi7UCtWLRo9jIukCPfmFe2JR6Igg
         nSaw==
X-Gm-Message-State: AOAM5317nUPqt02q7MxrGDy20qBdb1N3kKBnbVXeHmPGwVeJA4znDo/L
        n88iEekeic8kLKsEC9IMU61SvIXtDj4=
X-Google-Smtp-Source: ABdhPJwHNocghgY7wqhxp8332XY4hVlzmVW5zO7Aj/MN+AM0ddZEfsY+BxF6uQJixXS/r7Znuoa5Pw==
X-Received: by 2002:a63:2a86:: with SMTP id q128mr22276483pgq.552.1643740521406;
        Tue, 01 Feb 2022 10:35:21 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:a654:25ee:f962:92ca])
        by smtp.gmail.com with ESMTPSA id q8sm3815687pfl.143.2022.02.01.10.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 10:35:20 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH bpf-next] RFC: bpf hashmap - improve iteration in the presence of concurrent delete operations
Date:   Tue,  1 Feb 2022 10:35:14 -0800
Message-Id: <20220201183514.3235495-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

by resuming from the bucket the key would be in if it still existed

Note: AFAICT this an API change that would require some sort of guard...

bpf map iteration was added all the way back in v3.18-rc4-939-g0f8e4bd8a1fc
but behaviour of find first key with NULL was only done in v4.11-rc7-2042-g8fe45924387b
(before that you'd get EFAULT)

this means previously find first key was done by calling with a non existing key
(AFAICT this was hoping to get lucky, since if your non existing key actually existed,
it wouldn't actually iterate right, since you couldn't guarantee your magic value was
the first one)

ie. do we need a BPF_MAP_GET_NEXT_KEY2 or a sysctl? some other approach?

Not-Signed-off-by-Yet: Maciej Żenczykowski <maze@google.com>
---
 kernel/bpf/hashtab.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index d29af9988f37..0d61a9a54279 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -780,7 +780,7 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	key_size = map->key_size;
 
 	if (!key)
-		goto find_first_elem;
+		goto find_first_elem_this_bucket;
 
 	hash = htab_map_hash(key, key_size, htab->hashrnd);
 
@@ -790,7 +790,7 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	l = lookup_nulls_elem_raw(head, hash, key, key_size, htab->n_buckets);
 
 	if (!l)
-		goto find_first_elem;
+		goto find_first_elem_next_bucket;
 
 	/* key was found, get next key in the same bucket */
 	next_l = hlist_nulls_entry_safe(rcu_dereference_raw(hlist_nulls_next_rcu(&l->hash_node)),
@@ -802,11 +802,12 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 		return 0;
 	}
 
+find_first_elem_next_bucket:
 	/* no more elements in this hash list, go to the next bucket */
 	i = hash & (htab->n_buckets - 1);
 	i++;
 
-find_first_elem:
+find_first_elem_this_bucket:
 	/* iterate over buckets */
 	for (; i < htab->n_buckets; i++) {
 		head = select_bucket(htab, i);
-- 
2.35.0.rc2.247.g8bbb082509-goog

