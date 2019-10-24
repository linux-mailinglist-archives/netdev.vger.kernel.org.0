Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F99E3394
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 15:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502390AbfJXNLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 09:11:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52080 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502375AbfJXNLn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 09:11:43 -0400
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5EFC14E908
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 13:11:42 +0000 (UTC)
Received: by mail-lj1-f199.google.com with SMTP id e3so3988619ljj.16
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 06:11:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9zhT3ZqH6p9xDMTWEere2bPmLSSTfRCLcQSQxZUf50M=;
        b=j8wIUzxDC4rLZuqfGgQjpma2LtiYAf2/J4UK3GOmf7w1hHSVjlvs1XcQ6qGr9682YT
         uhqYqlnJY7u6+wxbb0AV6wNslOOvIJHslcR4c0vrPVSx74sfg0Zl07kEG+bjt/K8jqBn
         fiw31g94nCrrHLdwjl4TxSTzxbRIWaQE1Vfhj2WyWW1IZKkafwKPf34B7tre6reMMrEQ
         f34fW7/2RdtF7WCL4ZvQXfJEuXqvkHmeUYbF1ZB6ZPtz7sAW3ywa/4gY7zYSpcPsTFny
         nHzqQ3UK+JuGQDCaBVLoFQ2UBJH7DOPiSBH3VLUiTsN81Ml5MMDvSAJFxQseC+S9swTO
         5QLw==
X-Gm-Message-State: APjAAAXRHddpkX8Pr+UrTF4EJcATGTtzhhA8xPv1YRMAbh2oW0zmQQgC
        uJPU6wtWWljJOJvsgIAzaCHsVPa46fHGKHRxBwmDRK2OdkcR+hf3AHiqrQzw5tX8yC1bP+YGvTr
        8Kdv6BrvJYVzPk0FB
X-Received: by 2002:a2e:8e87:: with SMTP id z7mr17215282ljk.45.1571922700569;
        Thu, 24 Oct 2019 06:11:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqydsS27YK/Wh0Kh5WpZ56be+YvH8HOt6S/+7g5P8Y496HT6gukI2sOGDF4+RZTFiTuaArNsWg==
X-Received: by 2002:a2e:8e87:: with SMTP id z7mr17215269ljk.45.1571922700393;
        Thu, 24 Oct 2019 06:11:40 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id 12sm1595923lje.92.2019.10.24.06.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 06:11:39 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9F7981804B6; Thu, 24 Oct 2019 15:11:38 +0200 (CEST)
Subject: [PATCH bpf-next v2 1/4] libbpf: Fix error handling in
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
Date:   Thu, 24 Oct 2019 15:11:38 +0200
Message-ID: <157192269854.234778.6284587028332090249.stgit@toke.dk>
In-Reply-To: <157192269744.234778.11792009511322809519.stgit@toke.dk>
References: <157192269744.234778.11792009511322809519.stgit@toke.dk>
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

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index cccfd9355134..a2a7d074ac48 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1918,16 +1918,22 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd)
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
@@ -1946,7 +1952,7 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd)
 	close(new_fd);
 err_free_new_name:
 	free(new_name);
-	return -errno;
+	return err;
 }
 
 int bpf_map__resize(struct bpf_map *map, __u32 max_entries)

