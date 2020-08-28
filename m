Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9102256167
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 21:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgH1Tgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 15:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgH1TgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 15:36:17 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B59C061237
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 12:36:13 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b127so263362ybh.21
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 12:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc:content-transfer-encoding;
        bh=ntqqP+oTxa4ovownU4E037j4DkCLhsnQeuQG8e3plIM=;
        b=AYSFWGB0h2DV9xVaVkEI26P9ljTv1zdH+jfmkkGrSfczvU46QdPGP64IbKG5HNWTJE
         dCVk8FL1csrb5vKbFrQ2qkmmBr1Jk82ZGpJBBMIixBCZ9GyOzs8qypRzfFUOpNm24IRo
         R71ayaswh4D3Xv2a3Dyid+gYLiD9heFR8AcgQyKKIO3zTZDd7SSvp2SsjxNunoGkB2Sf
         /gsyI+3tJ7PEThFvyD2NGjM+MB+zIwmn76B9MxlxMaf1ey0GJoSJz+RHztC+jQPeBh4M
         eFbMQNy1/ImaMSRU658oZTTTEgeel0S6AGhlL3oIQ0KO91SblE4q9StCI6ZoMLIza+NV
         DTnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=ntqqP+oTxa4ovownU4E037j4DkCLhsnQeuQG8e3plIM=;
        b=SLoRnr0MRxoz7prKAeAIEBx9zHftJBCSwkR0w3RoFQZaQ70XMLK1jJUIux1YQ40uRw
         GtqGGR1d0UeK8KpcQG/iAfaogiohz+qBUs5qFaCYQSgTA+p6Yy3kZEv5HPQQmXt6tXin
         Jl03xVKEKzLpKlSyESeHtn05eoAhA4vSTpU6SANfGzKV8iPwgJZ846zRWLzr1mqiCGqq
         sO8aTj2eUoAm5+nmllf3zZY7i7gwhKIRFCyMYOtebVtOoT5FsYEzHwReo2eFGGXX4w8q
         3T3/w30uzPz8pWucthigL/9twTII7Vp3DtZhPtz93MJFgLsBZSORd8UaTL+D42Ghjt9E
         FR/A==
X-Gm-Message-State: AOAM531Bi083yU4RstvySz25Mji/tmZERA8bvjC1OYwKWgjLQ/Ve7pAG
        ma8wfOTMLPSJJLEm9s5ti9jFFtOmRLgB67tjhBLxYwF12+JnjYFue5l7fWLEljj0OcQv1zhxXNX
        kG9Tl/FB+C2ZB8QgwYhynbQH82NnaNPKD2w4kIYqDttKzViPmW8yJDA==
X-Google-Smtp-Source: ABdhPJx1IsJHBHlIzxza1al3CcA+8QFR4gJT1AnNn6Andp0lI5xEqPTU0Sat/qun+98IJbgmrVY3GFI=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:1fd5:: with SMTP id f204mr4340421ybf.142.1598643373098;
 Fri, 28 Aug 2020 12:36:13 -0700 (PDT)
Date:   Fri, 28 Aug 2020 12:35:59 -0700
In-Reply-To: <20200828193603.335512-1-sdf@google.com>
Message-Id: <20200828193603.335512-5-sdf@google.com>
Mime-Version: 1.0
References: <20200828193603.335512-1-sdf@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH bpf-next v3 4/8] libbpf: implement bpf_prog_find_metadata
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        "=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?=" <toke@redhat.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a low-level function (hence in bpf.c) to find out the metadata
map id for the provided program fd.
It will be used in the next commits from bpftool.

Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
Cc: YiFei Zhu <zhuyifei1999@gmail.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/lib/bpf/bpf.c      | 74 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/bpf.h      |  1 +
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 76 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 5f6c5676cc45..01c0ede1625d 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -885,3 +885,77 @@ int bpf_prog_bind_map(int prog_fd, int map_fd,
=20
 	return sys_bpf(BPF_PROG_BIND_MAP, &attr, sizeof(attr));
 }
+
+int bpf_prog_find_metadata(int prog_fd)
+{
+	struct bpf_prog_info prog_info =3D {};
+	struct bpf_map_info map_info;
+	__u32 prog_info_len;
+	__u32 map_info_len;
+	int saved_errno;
+	__u32 *map_ids;
+	int nr_maps;
+	int map_fd;
+	int ret;
+	int i;
+
+	prog_info_len =3D sizeof(prog_info);
+
+	ret =3D bpf_obj_get_info_by_fd(prog_fd, &prog_info, &prog_info_len);
+	if (ret)
+		return ret;
+
+	if (!prog_info.nr_map_ids)
+		return -1;
+
+	map_ids =3D calloc(prog_info.nr_map_ids, sizeof(__u32));
+	if (!map_ids)
+		return -1;
+
+	nr_maps =3D prog_info.nr_map_ids;
+	memset(&prog_info, 0, sizeof(prog_info));
+	prog_info.nr_map_ids =3D nr_maps;
+	prog_info.map_ids =3D ptr_to_u64(map_ids);
+	prog_info_len =3D sizeof(prog_info);
+
+	ret =3D bpf_obj_get_info_by_fd(prog_fd, &prog_info, &prog_info_len);
+	if (ret)
+		goto free_map_ids;
+
+	ret =3D -1;
+	for (i =3D 0; i < prog_info.nr_map_ids; i++) {
+		map_fd =3D bpf_map_get_fd_by_id(map_ids[i]);
+		if (map_fd < 0) {
+			ret =3D -1;
+			goto free_map_ids;
+		}
+
+		memset(&map_info, 0, sizeof(map_info));
+		map_info_len =3D sizeof(map_info);
+		ret =3D bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len);
+		saved_errno =3D errno;
+		close(map_fd);
+		errno =3D saved_errno;
+		if (ret)
+			goto free_map_ids;
+
+		if (map_info.type !=3D BPF_MAP_TYPE_ARRAY)
+			continue;
+		if (map_info.key_size !=3D sizeof(int))
+			continue;
+		if (map_info.max_entries !=3D 1)
+			continue;
+		if (!map_info.btf_value_type_id)
+			continue;
+		if (!strstr(map_info.name, ".metadata"))
+			continue;
+
+		ret =3D map_ids[i];
+		break;
+	}
+
+
+free_map_ids:
+	free(map_ids);
+	return ret;
+}
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 8c1ac4b42f90..8982ffa7cfd2 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -251,6 +251,7 @@ struct bpf_prog_bind_opts {
=20
 LIBBPF_API int bpf_prog_bind_map(int prog_fd, int map_fd,
 				 const struct bpf_prog_bind_opts *opts);
+LIBBPF_API int bpf_prog_find_metadata(int prog_fd);
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 529b99c0c2c3..b7a40f543b2b 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -307,4 +307,5 @@ LIBBPF_0.2.0 {
 		perf_buffer__buffer_fd;
 		perf_buffer__epoll_fd;
 		perf_buffer__consume_buffer;
+		bpf_prog_find_metadata;
 } LIBBPF_0.1.0;
--=20
2.28.0.402.g5ffc5be6b7-goog

