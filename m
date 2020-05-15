Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE671D569B
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgEOQuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 12:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726551AbgEOQuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 12:50:18 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20D2C05BD0B
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 09:50:18 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id r18so3236867ybg.10
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 09:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=BlBgjK5xziAM5vwiVDuTtOoE4PbK5TxWadJH4JBlKYM=;
        b=uwjR9RDmlKmjmScHj3v7Ni5ICzuU//nG6viIyAoAF/WkjBrWDIARVrcYd7aEu8mHOq
         cNl9et0QdfJz+zPaPLpyymL5L7phhW0iMu5HrtI05joIngtoKv05HP/dSZ5NmfWwLYxY
         O2Zkkem36vWYls2D49elB9STe2MbzOJRZ72i1jM+ioGkVCtqvJd4K3PXvhb3N1usK0b3
         f9xg+VxC8fEqgM3rDXEx2mqpfRdkXxVf8LdL8Md7vCG66TIfYwRPYq3znv0sv3tZXs+v
         Z7g/XVFAbGKcqoFK3I33p7T4Fwxt1ISxUpT0Qt23vOU1gRxqIrmpvdVcpc2Rh2U5biYx
         Oeqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=BlBgjK5xziAM5vwiVDuTtOoE4PbK5TxWadJH4JBlKYM=;
        b=W5Z+NeZOzBQUTBQuREFYvvQ96240uRrATzz7tVprZQdbwK5JXXBs82Bzc23nb4Iu2Y
         nvlcwIH2dtqqyplU+hXDPoLvgKFmfATWRuxbPojFOh8UJwIHh6hkQ/iF1AgHIfYzGZGp
         4B91Yj4McIylf4EkXb+lTiPKxEM+pM6LVUpl2384iOOGKP27ItnK6QDOOova5ScIHAbM
         AFvm2vlX2lisDaAajXvW06HqRwCzKEdcTIeJ0s0lveefKMb59YxHtMBqfnG0C2jl26ld
         GyLotRIzbHDKkbXghIsZ2W5KIjQ2MIUJkG7/SzFjlwoaMRvVai/pzVCZVsI4AAGsuqI+
         glig==
X-Gm-Message-State: AOAM530fEJWa0wcAkXKeO/pIO/kr58Fr0aK5qrIo/JwTOn8ogoLlIGx9
        fFJ2P4U+uqh3Hywr8loGrnZgO8iwsIG9
X-Google-Smtp-Source: ABdhPJzrDFvQNIcFMi0Solen5ZfhZvieWElQgZDit3xL+BENKdhSdyY5DiSL/W90JbqHijIdRCyezZEgBUmU
X-Received: by 2002:a5b:7c8:: with SMTP id t8mr6515278ybq.223.1589561417932;
 Fri, 15 May 2020 09:50:17 -0700 (PDT)
Date:   Fri, 15 May 2020 09:50:03 -0700
In-Reply-To: <20200515165007.217120-1-irogers@google.com>
Message-Id: <20200515165007.217120-4-irogers@google.com>
Mime-Version: 1.0
References: <20200515165007.217120-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH v2 3/7] libbpf hashmap: Fix signedness warnings
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following warnings:

hashmap.c: In function =E2=80=98hashmap__clear=E2=80=99:
hashmap.h:150:20: error: comparison of integer expressions of different sig=
nedness: =E2=80=98int=E2=80=99 and =E2=80=98size_t=E2=80=99 {aka =E2=80=98l=
ong unsigned int=E2=80=99} [-Werror=3Dsign-compare]
  150 |  for (bkt =3D 0; bkt < map->cap; bkt++)        \

hashmap.c: In function =E2=80=98hashmap_grow=E2=80=99:
hashmap.h:150:20: error: comparison of integer expressions of different sig=
nedness: =E2=80=98int=E2=80=99 and =E2=80=98size_t=E2=80=99 {aka =E2=80=98l=
ong unsigned int=E2=80=99} [-Werror=3Dsign-compare]
  150 |  for (bkt =3D 0; bkt < map->cap; bkt++)        \

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/lib/bpf/hashmap.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/hashmap.c b/tools/lib/bpf/hashmap.c
index cffb96202e0d..a405dad068f5 100644
--- a/tools/lib/bpf/hashmap.c
+++ b/tools/lib/bpf/hashmap.c
@@ -60,7 +60,7 @@ struct hashmap *hashmap__new(hashmap_hash_fn hash_fn,
 void hashmap__clear(struct hashmap *map)
 {
 	struct hashmap_entry *cur, *tmp;
-	int bkt;
+	size_t bkt;
=20
 	hashmap__for_each_entry_safe(map, cur, tmp, bkt) {
 		free(cur);
@@ -100,8 +100,7 @@ static int hashmap_grow(struct hashmap *map)
 	struct hashmap_entry **new_buckets;
 	struct hashmap_entry *cur, *tmp;
 	size_t new_cap_bits, new_cap;
-	size_t h;
-	int bkt;
+	size_t h, bkt;
=20
 	new_cap_bits =3D map->cap_bits + 1;
 	if (new_cap_bits < HASHMAP_MIN_CAP_BITS)
--=20
2.26.2.761.g0e0b3e54be-goog

