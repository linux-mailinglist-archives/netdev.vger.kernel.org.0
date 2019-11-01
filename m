Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1BBEEC0D0
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 10:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbfKAJxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 05:53:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55586 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727666AbfKAJxB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 05:53:01 -0400
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C22B783F42
        for <netdev@vger.kernel.org>; Fri,  1 Nov 2019 09:53:00 +0000 (UTC)
Received: by mail-lj1-f200.google.com with SMTP id r29so1656698ljd.1
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 02:53:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=LPiWhS+g/ovqClLwPSMJfIyTqzArOrHKO9TMIvpx0NE=;
        b=fZszIa4ixn5LEq3RR9DFZpYjl8aS742Dz2x4iZnH8+s/9fU9nT8ApyUyeiIPW4LvvD
         fY6dgIs9K5Was+ZEp/zugSU0ZUopxY6PybM6Am7pFlidoCWI16xd8tuwFRg7PEt9Kg5l
         5rhwExCoLrW5RA+ZEOxhAFhbbBUSpJ4usa+kB1hkUjjh6WHrmmVIo08pcMz9HrpiKImG
         H4eqVZXmBFy0D0ofH73pokBvPTR9qamxigH1bhbzlwTjGPZaBcZkzk7B+FDEjQNynF1p
         W4srili8XItF7vitawohqR5hNu8z81U1IMLd3NPPymViPbyMNJAPVBm6SvIHjFbH1pHH
         3M4w==
X-Gm-Message-State: APjAAAVtYx/INYznXFOGOeHkiqwHfoQWIFl1zwjooqmjdC26bycsFUog
        NGymnZ7xLJ6XZLYrEetXIlkeADGK20Gm8uWx3LoVfqwCS1RMQjrW40hl2SHgBsBtgS7h6sDMy0u
        7CT0ODzPyP01OKC5l
X-Received: by 2002:a2e:9a9a:: with SMTP id p26mr2755121lji.164.1572601979123;
        Fri, 01 Nov 2019 02:52:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxTJWY/eKdr47xq3OwOc1hxUXj2ATogaaQlMIR/ar6+bh9CUyfuK/khRhBAVTl11eBQLc/Lng==
X-Received: by 2002:a2e:9a9a:: with SMTP id p26mr2755104lji.164.1572601978986;
        Fri, 01 Nov 2019 02:52:58 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id j2sm2600198lfb.77.2019.11.01.02.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 02:52:58 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B037F1818B6; Fri,  1 Nov 2019 10:52:57 +0100 (CET)
Subject: [PATCH bpf-next v5 1/5] libbpf: Fix error handling in
 bpf_map__reuse_fd()
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 01 Nov 2019 10:52:57 +0100
Message-ID: <157260197757.335202.2270188893036283879.stgit@toke.dk>
In-Reply-To: <157260197645.335202.2393286837980792460.stgit@toke.dk>
References: <157260197645.335202.2393286837980792460.stgit@toke.dk>
User-Agent: StGit/0.20
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

bpf_map__reuse_fd() was calling close() in the error path before returning
an error value based on errno. However, close can change errno, so that can
lead to potentially misleading error messages. Instead, explicitly store
errno in the err variable before each goto.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index d71631a01926..ce5ef3ddd263 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1916,16 +1916,22 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd)
 		return -errno;
 
 	new_fd = open("/", O_RDONLY | O_CLOEXEC);
-	if (new_fd < 0)
+	if (new_fd < 0) {
+		err = -errno;
 		goto err_free_new_name;
+	}
 
 	new_fd = dup3(fd, new_fd, O_CLOEXEC);
-	if (new_fd < 0)
+	if (new_fd < 0) {
+		err = -errno;
 		goto err_close_new_fd;
+	}
 
 	err = zclose(map->fd);
-	if (err)
+	if (err) {
+		err = -errno;
 		goto err_close_new_fd;
+	}
 	free(map->name);
 
 	map->fd = new_fd;
@@ -1944,7 +1950,7 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd)
 	close(new_fd);
 err_free_new_name:
 	free(new_name);
-	return -errno;
+	return err;
 }
 
 int bpf_map__resize(struct bpf_map *map, __u32 max_entries)

