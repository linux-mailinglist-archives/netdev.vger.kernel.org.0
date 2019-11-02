Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA3ACECE41
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 12:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfKBLJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 07:09:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52820 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726634AbfKBLJl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 07:09:41 -0400
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 95B26C057F2E
        for <netdev@vger.kernel.org>; Sat,  2 Nov 2019 11:09:40 +0000 (UTC)
Received: by mail-lf1-f71.google.com with SMTP id c13so2373031lfk.23
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 04:09:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=LPiWhS+g/ovqClLwPSMJfIyTqzArOrHKO9TMIvpx0NE=;
        b=o0/xZ/cOjAqcPposHIxQj0uiPfeVke/Ae7jVLZcXWfFY9sIJTy5RfZG5AhW30spGH/
         X+vnKvsBiiTKC51aClBOdc2D5/GpA4Wplna/38n0AbYJ0FlSFp0axmCNLogz9J9/Zv+K
         WS/6hRaFFLk1X2mIVO7XkT6xSDcfe6fh9p7EljlvyUv3JEYd5FzjOTAGrshoKQpGh3e/
         7DJQoz16PAv0xyS/f6Vusp9QBAwd1erl+gOC/xnnpLNcPkjHMX8Z2JWmzHPm6KIPiaGR
         aS2i3QTUDmyWmvBFTOYEybYGZQ3ntEloMxFOPEmyNvKDUhZhsJUSTN6J+QgGdQroZ8ib
         F+6w==
X-Gm-Message-State: APjAAAUV3WGLXBOI7z4rygxgY6VRNUX/g2HEoriTXc5M3KEJfhMCBP7+
        VJl4DtbkKC1jRwtKUlMj6kmvBB+OlNGl8yi8WyqrzO4KoOpWbZuH0GqtMKprgfdOgBxujwOySEI
        n4pecFM5X/JmHk/AR
X-Received: by 2002:a19:f710:: with SMTP id z16mr5074346lfe.47.1572692979214;
        Sat, 02 Nov 2019 04:09:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwqkeJSegYVm4t/jyXZ3fXIJ9i3XLUQcIeWxU31drbml8IiJz0UdXIh7U8jwC+LsyjmiHS4sQ==
X-Received: by 2002:a19:f710:: with SMTP id z16mr5074326lfe.47.1572692978993;
        Sat, 02 Nov 2019 04:09:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id a2sm4013102lfh.73.2019.11.02.04.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Nov 2019 04:09:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BB0E41818B6; Sat,  2 Nov 2019 12:09:37 +0100 (CET)
Subject: [PATCH bpf-next v6 1/5] libbpf: Fix error handling in
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
Date:   Sat, 02 Nov 2019 12:09:37 +0100
Message-ID: <157269297769.394725.12634985106772698611.stgit@toke.dk>
In-Reply-To: <157269297658.394725.10672376245672095901.stgit@toke.dk>
References: <157269297658.394725.10672376245672095901.stgit@toke.dk>
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

