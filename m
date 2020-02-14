Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B4B15F2FA
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730895AbgBNPvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:51:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:57152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730878AbgBNPvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:51:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1495A2465D;
        Fri, 14 Feb 2020 15:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695512;
        bh=Ff9aojnCxvJNKh/uQrHeECcEeScxqOiWDzlfY4OG+x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pP/cZCgOXDKB5DYJH45SRukx5ZBMnC69Yhi2v9WcS4wC5/dJuD432BItKq7ApAjEB
         tSPy4fGkdDezFx2Ujhird/sTer0qCBHrwgttiRUTkKtsx0bFeRAOWlyUKOJdUG2rI/
         qkWxxwADLtd9pokIhXL2SYosVerfMBIEFysVuVlQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 136/542] bpf: Improve bucket_log calculation logic
Date:   Fri, 14 Feb 2020 10:42:08 -0500
Message-Id: <20200214154854.6746-136-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <kafai@fb.com>

[ Upstream commit 88d6f130e5632bbf419a2e184ec7adcbe241260b ]

It was reported that the max_t, ilog2, and roundup_pow_of_two macros have
exponential effects on the number of states in the sparse checker.

This patch breaks them up by calculating the "nbuckets" first so that the
"bucket_log" only needs to take ilog2().

In addition, Linus mentioned:

  Patch looks good, but I'd like to point out that it's not just sparse.

  You can see it with a simple

    make net/core/bpf_sk_storage.i
    grep 'smap->bucket_log = ' net/core/bpf_sk_storage.i | wc

  and see the end result:

      1  365071 2686974

  That's one line (the assignment line) that is 2,686,974 characters in
  length.

  Now, sparse does happen to react particularly badly to that (I didn't
  look to why, but I suspect it's just that evaluating all the types
  that don't actually ever end up getting used ends up being much more
  expensive than it should be), but I bet it's not good for gcc either.

Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Link: https://lore.kernel.org/bpf/20200207081810.3918919-1-kafai@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/bpf_sk_storage.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 458be6b3eda97..3ab23f698221c 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -643,9 +643,10 @@ static struct bpf_map *bpf_sk_storage_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-ENOMEM);
 	bpf_map_init_from_attr(&smap->map, attr);
 
+	nbuckets = roundup_pow_of_two(num_possible_cpus());
 	/* Use at least 2 buckets, select_bucket() is undefined behavior with 1 bucket */
-	smap->bucket_log = max_t(u32, 1, ilog2(roundup_pow_of_two(num_possible_cpus())));
-	nbuckets = 1U << smap->bucket_log;
+	nbuckets = max_t(u32, 2, nbuckets);
+	smap->bucket_log = ilog2(nbuckets);
 	cost = sizeof(*smap->buckets) * nbuckets + sizeof(*smap);
 
 	ret = bpf_map_charge_init(&smap->map.memory, cost);
-- 
2.20.1

