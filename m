Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CB329CBDC
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374827AbgJ0WQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:16:26 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44160 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374823AbgJ0WQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 18:16:26 -0400
Received: by mail-ed1-f68.google.com with SMTP id t20so3063759edr.11
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 15:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NOIDTRFCD+4gLa0iV6oczkhHHisCeCf4dMyrXVdDhjA=;
        b=rcUXZcPLjKSubOTKbGxtJ2Ec3857UkKCJVn7vm2k6U+lq62TMjXybsloLIvIyVS9aV
         zWtKlagwwQ4JmHp67/mpwuY6En1jvuKu3PQMg6c0CzHVEQh8UEvzBTrweTGS+ruNV0/A
         5I+yUHqaBEqJRPvInXORsnPEHcsiHAnMnfL9laXCP66Jxq6rHqZyB7TyZjFph4vQji9w
         ftVRffNJ/9QqawWMHD9GtTubCG0S6mMoTHTYLPJJmglw7a9Ql4KMdHgCwWm7z+0iDSc3
         JswOWraLeP13df2ODjqfGiqrsvBLvQBOJdUctGwPeDH2yJC0GYBOp0Bb6psE+nIXlKbQ
         BEdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NOIDTRFCD+4gLa0iV6oczkhHHisCeCf4dMyrXVdDhjA=;
        b=cJf0p/8L3k/X05hN0L9UlZuGVXExJHzq/WjJ1vnIFJBaZBHr74MpP5W3q288kpiyGR
         YCM5+gLvsERsv682ZkacfB8bC2oNvxoEG8VPZkCkl5TGwTiBioLwQQUPAKFoHO/8XiNs
         CufysaEn/OZzreKbI3NxwmbfP8ZWzzZG6VuQGPotQgvce0QgPDjeyzrdXaJ+Wly80B6z
         mhKkoLmSuUPk6muah+qbruyseDcI8Cc9YItcIPhbX7PHX/io/PtFSaBY2MXNbsoWqKPH
         JBljyTi/M/bwgNL6m85tY9TyBETwa4ptuBYCx2cxVMZY7csK7uynhtxB57PvcNgm+0Qi
         zX5Q==
X-Gm-Message-State: AOAM532ziZTJinqy2Z4aYks/iHbuU3gQ9qBuAALpg4LlSrY6UnC81WhE
        0IuVKegfZoC7NIayPZxc3kg29Q==
X-Google-Smtp-Source: ABdhPJwq5e0F2RFpd5QVVLLtqJegZnMqaRVmZ9iGU9NG1j77209AW1rmjf4+lmNS5bKOD3BHDlE6Tw==
X-Received: by 2002:a05:6402:1bc9:: with SMTP id ch9mr4702603edb.386.1603836924972;
        Tue, 27 Oct 2020 15:15:24 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:689e:3400:b894:bc77:ad21:b2db])
        by smtp.gmail.com with ESMTPSA id s25sm1668289ejc.29.2020.10.27.15.15.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2020 15:15:24 -0700 (PDT)
From:   David Verbeiren <david.verbeiren@tessares.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Verbeiren <david.verbeiren@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH bpf v2] bpf: zero-fill re-used per-cpu map element
Date:   Tue, 27 Oct 2020 23:13:24 +0100
Message-Id: <20201027221324.27894-1-david.verbeiren@tessares.net>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201023123754.30304-1-david.verbeiren@tessares.net>
References: <20201023123754.30304-1-david.verbeiren@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-fill element values for all other cpus than current, just as
when not using prealloc. This is the only way the bpf program can
ensure known initial values for all cpus ('onallcpus' cannot be
set when coming from the bpf program).

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

Notes:
    v2:
      - Moved memset() to separate pcpu_init_value() function,
        which replaces pcpu_copy_value() but delegates to it
        for the cases where no memset() is needed (Andrii).
      - This function now also avoids doing the memset() for
        the current cpu for which the value must be set
        anyhow (Andrii).
      - Same pcpu_init_value() used for per-cpu LRU map
        (Andrii).
    
      Note that I could not test the per-cpu LRU other than
      by running the bpf selftests. lru_map and maps tests
      passed but for the rest of the test suite, I don't
      think I know how to spot problems...
    
      Question: Is it ok to use raw_smp_processor_id() in
      these contexts? bpf prog context should be fine, I think.
      Is it also ok in the syscall context?

 kernel/bpf/hashtab.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 1815e97d4c9c..1fccba6e88c4 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -821,6 +821,32 @@ static void pcpu_copy_value(struct bpf_htab *htab, void __percpu *pptr,
 	}
 }
 
+static void pcpu_init_value(struct bpf_htab *htab, void __percpu *pptr,
+			    void *value, bool onallcpus)
+{
+	/* When using prealloc and not setting the initial value on all cpus,
+	 * zero-fill element values for other cpus (just as what happens when
+	 * not using prealloc). Otherwise, bpf program has no way to ensure
+	 * known initial values for cpus other than current one
+	 * (onallcpus=false always when coming from bpf prog).
+	 */
+	if (htab_is_prealloc(htab) && !onallcpus) {
+		u32 size = round_up(htab->map.value_size, 8);
+		int current_cpu = raw_smp_processor_id();
+		int cpu;
+
+		for_each_possible_cpu(cpu) {
+			if (cpu == current_cpu)
+				bpf_long_memcpy(per_cpu_ptr(pptr, cpu), value,
+						size);
+			else
+				memset(per_cpu_ptr(pptr, cpu), 0, size);
+		}
+	} else {
+		pcpu_copy_value(htab, pptr, value, onallcpus);
+	}
+}
+
 static bool fd_htab_map_needs_adjust(const struct bpf_htab *htab)
 {
 	return htab->map.map_type == BPF_MAP_TYPE_HASH_OF_MAPS &&
@@ -891,7 +917,7 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 			}
 		}
 
-		pcpu_copy_value(htab, pptr, value, onallcpus);
+		pcpu_init_value(htab, pptr, value, onallcpus);
 
 		if (!prealloc)
 			htab_elem_set_ptr(l_new, key_size, pptr);
@@ -1183,7 +1209,7 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 		pcpu_copy_value(htab, htab_elem_get_ptr(l_old, key_size),
 				value, onallcpus);
 	} else {
-		pcpu_copy_value(htab, htab_elem_get_ptr(l_new, key_size),
+		pcpu_init_value(htab, htab_elem_get_ptr(l_new, key_size),
 				value, onallcpus);
 		hlist_nulls_add_head_rcu(&l_new->hash_node, head);
 		l_new = NULL;
-- 
2.29.0

