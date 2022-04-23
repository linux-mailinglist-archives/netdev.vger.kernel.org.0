Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2289E50CAEE
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 16:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbiDWOFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 10:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235918AbiDWOEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 10:04:54 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C7B10C;
        Sat, 23 Apr 2022 07:01:57 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c12so16969802plr.6;
        Sat, 23 Apr 2022 07:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HKd8MWnlnuD/FmR2TVsh0A9QLvXI3gP9ygTddKfsav0=;
        b=gLc4YTYbgH2yWP8OyFtOEQHmrzbWlhNrQnLsz3fMZtG0dNBwWcw1+E+rGMHbK09mg0
         G4MvHrg0jy487dHk5JA+xOcUfmabicqzW79wx6e9dlK1yDeNS+boVwiT2khGH6kCua/m
         CvPOodV+KAS8Iep+8L6lJzNLym6+mv+xXORd6QNOMFO2sUtc87CYgyvrGcgsF8OlqlWk
         Vg3WnYVSzWkSUa63nxk4hr7GeaZ2/UkcmO+k/mQY+PRSj9ROXddh9eggRgPx3GJ8XkNY
         nrDVa16qB0u0vPmGVEsA6Jp7Bgdsd6cNLk5BnYoATChhJrDWJ9xd+NIJpfemzKml13iz
         Ckwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HKd8MWnlnuD/FmR2TVsh0A9QLvXI3gP9ygTddKfsav0=;
        b=Q0siR4V7zUq3BRZFV6Wiqb1UgkhsgyD51MaE2agSSkrF9xHggrONIBoFsRS0wqFYSV
         p4ba8jReL/R4hWvSO6Dsqlr7akaZwhGjreLEoIwtwzJz96zJROmfW6jP8PuiP/HzYTsp
         dcoz7lMUegil4oQfB81nOUUItvHnzAwI+CFX+fFgMa3piP4CIT0FL483PxthuE/2PocC
         GUeUfeda8F8ywJAQ1JGP6zG+bEegG4EAJ1UGr2Q5XxI54fZhh5/zODYb5WTg+RZxUMOZ
         LuHFxeuapoVbxKalv3kLo0tR1R6yBfqbs+KT9Q2IvYEnVdGxbRu17/9Q3IKwWCnsAj9j
         +h+g==
X-Gm-Message-State: AOAM533hgpY9Lp6nlrrVJXzGueQlTGm46XCZCjGF9JfRRBU9luubIWpl
        EqP/QUBxdxrgf25U+MvWsx0=
X-Google-Smtp-Source: ABdhPJy3aX/bCc3L9DqkAH8iI5awvyqxYVYma+5NLl1gXK/fRZJj4eXRElHmEaT8wLG5vYR3keItCw==
X-Received: by 2002:a17:902:d2d1:b0:158:dd22:9922 with SMTP id n17-20020a170902d2d100b00158dd229922mr9748181plc.2.1650722517212;
        Sat, 23 Apr 2022 07:01:57 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:1e2f:5400:3ff:fef5:fd57])
        by smtp.gmail.com with ESMTPSA id e6-20020a17090a77c600b001cd4989fedcsm9282071pjs.40.2022.04.23.07.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 07:01:56 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 2/4] libbpf: Add helpers for pinning bpf prog through bpf object skeleton
Date:   Sat, 23 Apr 2022 14:00:56 +0000
Message-Id: <20220423140058.54414-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220423140058.54414-1-laoar.shao@gmail.com>
References: <20220423140058.54414-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently there're helpers for allowing to open/load/attach BPF object
through BPF object skeleton. Let's also add helpers for pinning through
BPF object skeleton. It could simplify BPF userspace code which wants to
pin the progs into bpffs.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/lib/bpf/libbpf.c   | 59 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |  4 +++
 tools/lib/bpf/libbpf.map |  2 ++
 3 files changed, 65 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 13fcf91e9e0e..e7ed6c53c525 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -12726,6 +12726,65 @@ void bpf_object__detach_skeleton(struct bpf_object_skeleton *s)
 	}
 }
 
+int bpf_object__pin_skeleton_prog(struct bpf_object_skeleton *s,
+				  const char *path)
+{
+	struct bpf_link *link;
+	int err;
+	int i;
+
+	if (!s->prog_cnt)
+		return libbpf_err(-EINVAL);
+
+	if (!path)
+		path = DEFAULT_BPFFS;
+
+	for (i = 0; i < s->prog_cnt; i++) {
+		char buf[PATH_MAX];
+		int len;
+
+		len = snprintf(buf, PATH_MAX, "%s/%s", path, s->progs[i].name);
+		if (len < 0) {
+			err = -EINVAL;
+			goto err_unpin_prog;
+		} else if (len >= PATH_MAX) {
+			err = -ENAMETOOLONG;
+			goto err_unpin_prog;
+		}
+
+		link = *s->progs[i].link;
+		if (!link) {
+			err = -EINVAL;
+			goto err_unpin_prog;
+		}
+
+		err = bpf_link__pin(link, buf);
+		if (err)
+			goto err_unpin_prog;
+	}
+
+	return 0;
+
+err_unpin_prog:
+	bpf_object__unpin_skeleton_prog(s);
+
+	return libbpf_err(err);
+}
+
+void bpf_object__unpin_skeleton_prog(struct bpf_object_skeleton *s)
+{
+	struct bpf_link *link;
+	int i;
+
+	for (i = 0; i < s->prog_cnt; i++) {
+		link = *s->progs[i].link;
+		if (!link || !link->pin_path)
+			continue;
+
+		bpf_link__unpin(link);
+	}
+}
+
 void bpf_object__destroy_skeleton(struct bpf_object_skeleton *s)
 {
 	if (!s)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 3784867811a4..af44b0968cca 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -1427,6 +1427,10 @@ bpf_object__open_skeleton(struct bpf_object_skeleton *s,
 LIBBPF_API int bpf_object__load_skeleton(struct bpf_object_skeleton *s);
 LIBBPF_API int bpf_object__attach_skeleton(struct bpf_object_skeleton *s);
 LIBBPF_API void bpf_object__detach_skeleton(struct bpf_object_skeleton *s);
+LIBBPF_API int
+bpf_object__pin_skeleton_prog(struct bpf_object_skeleton *s, const char *path);
+LIBBPF_API void
+bpf_object__unpin_skeleton_prog(struct bpf_object_skeleton *s);
 LIBBPF_API void bpf_object__destroy_skeleton(struct bpf_object_skeleton *s);
 
 struct bpf_var_skeleton {
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 82f6d62176dd..4e3e37b84b3a 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -55,6 +55,8 @@ LIBBPF_0.0.1 {
 		bpf_object__unload;
 		bpf_object__unpin_maps;
 		bpf_object__unpin_programs;
+		bpf_object__pin_skeleton_prog;
+		bpf_object__unpin_skeleton_prog;
 		bpf_perf_event_read_simple;
 		bpf_prog_attach;
 		bpf_prog_detach;
-- 
2.17.1

