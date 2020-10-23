Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE4E296F7B
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 14:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S463954AbgJWMir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 08:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373146AbgJWMiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 08:38:46 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E37CC0613CE
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 05:38:46 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id v19so1378817edx.9
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 05:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eF+Zn7DuYonjJ2ozfYY/h+K5gxMSAwDfp+BFrCzRIuw=;
        b=vnmgR7jMik8VcE2F0syGrUlVzA+SUtan5fTxvEjAcue5GzUVKzg78Vd/p50H2dov2t
         S/Mjf3/8tQ9zzGmUbO7vjnDoA8GgROZ60QltXRWayxT2QM9X9atWa56o7kpgMrykoc9q
         +UH1EmzXlpyDRv8SzJAOoCArdNKo5ozeKN6mSf23Lm4HDKRu342B+YHmLR0zEB4N8qN/
         KTPh2S77imP2a5Wh1+zt8DkpAdMumLbVRprr5fTW6uDKVbwMbQKfWoPvCNHdULIliLxN
         uL8cz0V4ejWXlGaqepioe7pyB0xVVtifyosRH1pE4Ghq/JUcBmqvM6WKGxyLJNz4+5ju
         0QYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eF+Zn7DuYonjJ2ozfYY/h+K5gxMSAwDfp+BFrCzRIuw=;
        b=XcC0W/B5EdlfR4eFDTikJwjqOrsEGKkUK+QhaOJ/KBVuttUbaZhBSeuBNIfmiTGOWV
         aKLM80yy4UcyndHdCuML02vXfi7aEgIxJcGZlzStwa0Ts9O81Ixpa/QiJU/RjVGHLKrH
         /zOgIptaPmtYAa8U+qo5GHRvwS/t5NxVurpLdaUfcmXa6HAkR1VCqVORsFA60ZPwqdhh
         /AkjiHC86fwoME0zCSRG3WWv/rSdkxrk4u4NWwBHBPRv+L6fY7FIB266fcUxscb4oBgg
         M7eY9Vo+cF+niCxnDC89f2TidNm7I6/b3f93pzzTaASnfnqDUqGiiRQV3CFDTEE0vdWo
         SqKA==
X-Gm-Message-State: AOAM533Jjk1bOzI/lMAEr0+efyta8ENnnwG9eIL99XUrXDSmPqF9G/sJ
        olg1TSav8k+QrQgSbJ2ekJOfNg==
X-Google-Smtp-Source: ABdhPJwUmLFSubZ4FH13AoDvRQGFrfwJbB2l1oc4tAHuuIgyNAEAFwZBDYXxAHqxeG0y5rXsdSdOgw==
X-Received: by 2002:a50:d517:: with SMTP id u23mr1966767edi.338.1603456725142;
        Fri, 23 Oct 2020 05:38:45 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:689e:3400:b894:bc77:ad21:b2db])
        by smtp.gmail.com with ESMTPSA id ds7sm799682ejc.83.2020.10.23.05.38.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Oct 2020 05:38:44 -0700 (PDT)
From:   David Verbeiren <david.verbeiren@tessares.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        David Verbeiren <david.verbeiren@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH bpf] bpf: zero-fill re-used per-cpu map element
Date:   Fri, 23 Oct 2020 14:37:54 +0200
Message-Id: <20201023123754.30304-1-david.verbeiren@tessares.net>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-fill element values for all cpus, just as when not using
prealloc. This is the only way the bpf program can ensure known
initial values for cpus other than the current one ('onallcpus'
cannot be set when coming from the bpf program).

The scenario is: bpf program inserts some elements in a per-cpu
map, then deletes some (or userspace does). When later adding
new elements using bpf_map_update_elem(), the bpf program can
only set the value of the new elements for the current cpu.
When prealloc is enabled, previously deleted elements are re-used.
Without the fix, values for other cpus remain whatever they were
when the re-used entry was previously freed.

Fixes: 6c9059817432 ("bpf: pre-allocate hash map elements")
Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David Verbeiren <david.verbeiren@tessares.net>
---
 kernel/bpf/hashtab.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 1815e97d4c9c..667553cce65a 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -836,6 +836,7 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 	bool prealloc = htab_is_prealloc(htab);
 	struct htab_elem *l_new, **pl_new;
 	void __percpu *pptr;
+	int cpu;
 
 	if (prealloc) {
 		if (old_elem) {
@@ -880,6 +881,17 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 		size = round_up(size, 8);
 		if (prealloc) {
 			pptr = htab_elem_get_ptr(l_new, key_size);
+
+			/* zero-fill element values for all cpus, just as when
+			 * not using prealloc. Only way for bpf program to
+			 * ensure known initial values for cpus other than
+			 * current one (onallcpus=false when coming from bpf
+			 * prog).
+			 */
+			if (!onallcpus)
+				for_each_possible_cpu(cpu)
+					memset((void *)per_cpu_ptr(pptr, cpu),
+					       0, size);
 		} else {
 			/* alloc_percpu zero-fills */
 			pptr = __alloc_percpu_gfp(size, 8,
-- 
2.29.0

