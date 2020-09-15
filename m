Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3CA26B58D
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgIOXrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 19:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgIOXpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 19:45:54 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A41C061797
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 16:45:49 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id a2so4451318qkg.19
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 16:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=2zAlitpz1bSHaXpmOBe1sEwQjxsIHDKKWn1soexKc5A=;
        b=jX2EHABnTF/zKy7dy9pWQ+vvvHxshCHxrKjT8OYU7KHefup5xZAWJY/FmiLosxqLNN
         sZWq9NVyJCYWN3MC3mRbNEvTzI74lg2izQhOOTNOr5L/bfMZ0y+XlRgdf8ULhb8SJJ0v
         +FHdWBf6RxJiEWZrCMCd5+ciWheB698sA9OVlikTGKRch7F+FVKTI8VnEet4Jv3m5iQ8
         GL5TIKsGVBO/U5+NXYW7B5ye9mwi2/OWrfINfCUvy3LeiiKkSgytV1ZLO5tnl09ZKrdw
         xwrgyhfbfTNzwfj8Y4wAh2oCovbxEz3PnQayuGkNsZV/Y3jFfPNMxJsENq07hvUsVFbM
         0uAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2zAlitpz1bSHaXpmOBe1sEwQjxsIHDKKWn1soexKc5A=;
        b=LCoBxa2AobxbG+OsobEaiJ4pw7b/wQ3WsiwA2UlGyzMOcnWstFWF9kfMPoITTfx2kj
         vGDUbfFUSNmpWNjR9snHuVfHTRTh11kFzPtfvfD6fPGyIjMHLMhpXXC6IuZzgZduVIfY
         SSU4Fqceo7EvITfv/jm1n08dKM9oZ7vFrM5Y90e8ch/ObrejxdKog+RqXIas5se3DPjU
         33XpgwkMo6OryK7qpTTzPDgQElM8f+k09O9bWOiaWXBZLuHifXvbBH1I63Exm0L10oTS
         mjkwV4jh+/dLfHoNSBXWIfmbxRQXrHwIhEESrEqUBYkgDBentDnbWRHEeo49B2gr749d
         n4fA==
X-Gm-Message-State: AOAM533UadL24HsHBaJFoByIbN3hvqSJ+Cx/qLSfic8NUBms8FT+c/iK
        mrj+HR8EyoAeXREKBW0XMiFVAaszI3nyzY77OY0lfRcHLofYgMa+ezBstzcJly7vSx566xAF9PE
        XmWXXmjYn53HAD4c/UH8SaaqO6MtTqNn96vZD6AXSDUfpUmn9hEjEsQ==
X-Google-Smtp-Source: ABdhPJxoH3lkhhMlmtoNrebqMPDbgJmQKZvR6/SrHw8LwfZ2rPqoKfyf2gd6tDrcoSaJyVsE+NgTvXY=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:ad4:4527:: with SMTP id l7mr21049200qvu.2.1600213548790;
 Tue, 15 Sep 2020 16:45:48 -0700 (PDT)
Date:   Tue, 15 Sep 2020 16:45:40 -0700
In-Reply-To: <20200915234543.3220146-1-sdf@google.com>
Message-Id: <20200915234543.3220146-3-sdf@google.com>
Mime-Version: 1.0
References: <20200915234543.3220146-1-sdf@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH bpf-next v6 2/5] bpf: Add BPF_PROG_BIND_MAP syscall
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Andrii Nakryiko <andriin@fb.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YiFei Zhu <zhuyifei@google.com>

This syscall binds a map to a program. Returns success if the map is
already bound to the program.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Cc: YiFei Zhu <zhuyifei1999@gmail.com>
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/uapi/linux/bpf.h       |  7 ++++
 kernel/bpf/syscall.c           | 63 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  7 ++++
 3 files changed, 77 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 7dd314176df7..a22812561064 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -124,6 +124,7 @@ enum bpf_cmd {
 	BPF_ENABLE_STATS,
 	BPF_ITER_CREATE,
 	BPF_LINK_DETACH,
+	BPF_PROG_BIND_MAP,
 };
 
 enum bpf_map_type {
@@ -658,6 +659,12 @@ union bpf_attr {
 		__u32		flags;
 	} iter_create;
 
+	struct { /* struct used by BPF_PROG_BIND_MAP command */
+		__u32		prog_fd;
+		__u32		map_fd;
+		__u32		flags;		/* extra flags */
+	} prog_bind_map;
+
 } __attribute__((aligned(8)));
 
 /* The description below is an attempt at providing documentation to eBPF
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index a67b8c6746be..2ce32cad5c8e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4161,6 +4161,66 @@ static int bpf_iter_create(union bpf_attr *attr)
 	return err;
 }
 
+#define BPF_PROG_BIND_MAP_LAST_FIELD prog_bind_map.flags
+
+static int bpf_prog_bind_map(union bpf_attr *attr)
+{
+	struct bpf_prog *prog;
+	struct bpf_map *map;
+	struct bpf_map **used_maps_old, **used_maps_new;
+	int i, ret = 0;
+
+	if (CHECK_ATTR(BPF_PROG_BIND_MAP))
+		return -EINVAL;
+
+	if (attr->prog_bind_map.flags)
+		return -EINVAL;
+
+	prog = bpf_prog_get(attr->prog_bind_map.prog_fd);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	map = bpf_map_get(attr->prog_bind_map.map_fd);
+	if (IS_ERR(map)) {
+		ret = PTR_ERR(map);
+		goto out_prog_put;
+	}
+
+	mutex_lock(&prog->aux->used_maps_mutex);
+
+	used_maps_old = prog->aux->used_maps;
+
+	for (i = 0; i < prog->aux->used_map_cnt; i++)
+		if (used_maps_old[i] == map)
+			goto out_unlock;
+
+	used_maps_new = kmalloc_array(prog->aux->used_map_cnt + 1,
+				      sizeof(used_maps_new[0]),
+				      GFP_KERNEL);
+	if (!used_maps_new) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	memcpy(used_maps_new, used_maps_old,
+	       sizeof(used_maps_old[0]) * prog->aux->used_map_cnt);
+	used_maps_new[prog->aux->used_map_cnt] = map;
+
+	prog->aux->used_map_cnt++;
+	prog->aux->used_maps = used_maps_new;
+
+	kfree(used_maps_old);
+
+out_unlock:
+	mutex_unlock(&prog->aux->used_maps_mutex);
+
+	if (ret)
+		bpf_map_put(map);
+out_prog_put:
+	bpf_prog_put(prog);
+	return ret;
+}
+
 SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
 {
 	union bpf_attr attr;
@@ -4294,6 +4354,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	case BPF_LINK_DETACH:
 		err = link_detach(&attr);
 		break;
+	case BPF_PROG_BIND_MAP:
+		err = bpf_prog_bind_map(&attr);
+		break;
 	default:
 		err = -EINVAL;
 		break;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 7dd314176df7..a22812561064 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -124,6 +124,7 @@ enum bpf_cmd {
 	BPF_ENABLE_STATS,
 	BPF_ITER_CREATE,
 	BPF_LINK_DETACH,
+	BPF_PROG_BIND_MAP,
 };
 
 enum bpf_map_type {
@@ -658,6 +659,12 @@ union bpf_attr {
 		__u32		flags;
 	} iter_create;
 
+	struct { /* struct used by BPF_PROG_BIND_MAP command */
+		__u32		prog_fd;
+		__u32		map_fd;
+		__u32		flags;		/* extra flags */
+	} prog_bind_map;
+
 } __attribute__((aligned(8)));
 
 /* The description below is an attempt at providing documentation to eBPF
-- 
2.28.0.618.gf4bc123cb7-goog

