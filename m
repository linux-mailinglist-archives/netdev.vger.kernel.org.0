Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61247256160
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 21:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgH1Tgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 15:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgH1TgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 15:36:11 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E77C061234
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 12:36:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p138so290959yba.12
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 12:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=tu9rQycvDFHsopcgF1sWVBo36uc1asKlJZljej9AH7o=;
        b=JNfXcrsJfkiEjNwP0c2+O4/OWDT/PBBaJEL0UNxjmry8plnpyG3ntTpKG8u3oEJsLO
         YKz/FVKFDdArVRXuahnKbPkL+dX7x3Ht4qOpgndVT9l7vd+DoQWXiGrbY26T3Xu3M/aa
         fa2V9YQQcp/D4DmYs2g2OkSvW9IuGwCJpjeJZUYw3XZ6t1NPsIiNvvg+da15oOvwjpmQ
         GTus8jXRpMiC4a07eZzmhmQwnzZ2Ddt4wyU1J6IdIv9fAABtRxwnfEqK6JmRvkL4Tda4
         65QnT4a3Vb4uzY3bYK7yAMKmfkSMjG9Nrsc7FHReB5hvCZki7j4FEZ5G2RygSBYzJ1VF
         KLCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tu9rQycvDFHsopcgF1sWVBo36uc1asKlJZljej9AH7o=;
        b=KaulBQjtug5q5Wx49542RXn6gTunh8xRp02M5CSs5zVlPX8MrzxaFoX6RoKQcKK2IR
         u/OR/PK8PhuA/HwJ88cUmOhsKaxUbWDF5OA4FQji/8Oy3nDLgn2pSeHypMCzvMe4u05A
         t1BB0zOQWKS6EOJHdOjtEVzMTkeW6PQsVlPiwZDEHiHt/20U4zcp1l8SEyoOpAv4gYpo
         xhV6uBqjzVWgRTV3L0s5TAGFcHBbMVd9ipJdXIDvrf2dl6xIc4sgLmLi+2gRXIKJuZPJ
         3Q1SzKVE3NXrIh/Y09TnNju7M7yc70RCxMAVbjAyuSF5iQq9/EZqZNPXDjZZaX7/rPCG
         HhAw==
X-Gm-Message-State: AOAM531npy04tSG7AYpJ8IdrcJGwtAlh4eZD5ZWskz1XccflkazjrKXH
        f0agWIBs54UAl/GPHi/SFm2IXRkLueF+2i5D6qHuUSS5Hn4Mr9ZUEIeyrWIscCfFff2DcKhJSLN
        SDZ3LDtsO1aVGtvgRNbGH2YQKcy65LY/FGkhEF+w9bhJTsBvjgm88UQ==
X-Google-Smtp-Source: ABdhPJzpvTUIFX4E5Amy6cqWb6cIo3TsgFzY8ls1/bpAhA4PFUMkyKP1SXUTctAwtqMVV02ubw55klU=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:cc12:: with SMTP id l18mr4803916ybf.224.1598643369167;
 Fri, 28 Aug 2020 12:36:09 -0700 (PDT)
Date:   Fri, 28 Aug 2020 12:35:57 -0700
In-Reply-To: <20200828193603.335512-1-sdf@google.com>
Message-Id: <20200828193603.335512-3-sdf@google.com>
Mime-Version: 1.0
References: <20200828193603.335512-1-sdf@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH bpf-next v3 2/8] bpf: Add BPF_PROG_BIND_MAP syscall
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YiFei Zhu <zhuyifei@google.com>

This syscall binds a map to a program. -EEXIST if the map is
already bound to the program.

Cc: YiFei Zhu <zhuyifei1999@gmail.com>
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/uapi/linux/bpf.h       |  7 ++++
 kernel/bpf/syscall.c           | 65 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  7 ++++
 3 files changed, 79 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ef7af384f5ee..d232c71c4560 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -124,6 +124,7 @@ enum bpf_cmd {
 	BPF_ENABLE_STATS,
 	BPF_ITER_CREATE,
 	BPF_LINK_DETACH,
+	BPF_PROG_BIND_MAP,
 };
 
 enum bpf_map_type {
@@ -650,6 +651,12 @@ union bpf_attr {
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
index c9b8a97fbbdf..8c1fad2826d1 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4154,6 +4154,68 @@ static int bpf_iter_create(union bpf_attr *attr)
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
+		if (used_maps_old[i] == map) {
+			ret = -EEXIST;
+			goto out_unlock;
+		}
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
@@ -4287,6 +4349,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
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
index ef7af384f5ee..d232c71c4560 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -124,6 +124,7 @@ enum bpf_cmd {
 	BPF_ENABLE_STATS,
 	BPF_ITER_CREATE,
 	BPF_LINK_DETACH,
+	BPF_PROG_BIND_MAP,
 };
 
 enum bpf_map_type {
@@ -650,6 +651,12 @@ union bpf_attr {
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
2.28.0.402.g5ffc5be6b7-goog

