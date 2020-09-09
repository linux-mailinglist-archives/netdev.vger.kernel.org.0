Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A372635DE
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgIISYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgIISYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:24:13 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42C5C0613ED
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:24:12 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l186so3063557ybf.3
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 11:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=wrs5tTFvO5nOXIR9odme+YldJdrsZs7qf8oEEh0e1H4=;
        b=EATmsmUfcw3oCCGqfzBW0xR80zZZWlpyrxskdBohqg0RyaFgaHOECkvX3c3Spi9pDQ
         wq+tWLlpZsjr5irfo+N5W/gAQ9FjkGmqDjrxlC+d7mBjmvnNx+7RnXS9N/5QwUxmEQC0
         pINbVyB1RsLpw1saWFhk7/2FLSGBnUJd22aKRwJZ7XP9n+QLtYGvgRH+Mx1u/pNuIHGi
         tTcCe5ToEY+8M8hgmBpuwkax562M8b/HZ9z9zxCqXbzmjDNdd23mi50TxC34e/z6ZCbK
         Y0h0Rr6nYW2XORa3ZSfrR2F1ub81hHhs6CcgQAQD0RhAJ8zJpSuBgWUqdWmHNgwiih+m
         7rfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wrs5tTFvO5nOXIR9odme+YldJdrsZs7qf8oEEh0e1H4=;
        b=LVNimSJPPkDcjv1WicAiTWuGfIcg5mfsK5QODfn0kZRGqenW1mAqOyOvuMOAKX4GE0
         jp5vYOtvZXHigqRvK2flKFBmWr6fCe7f0ts5vEcW+19z7mE834jp4+EJalLepLeJbeKL
         oaQVu8USIABc0S8ApIhORP2I/MQd/ZYHORAKGN+q0+rjzWtX8z8k1uGqMSllUE+DkiPZ
         lUQdO4BjTrmFumUd5GpMJuylfpWc9WtOEpQlqVvuWbw3XHOvObzW7Xf5oWyKDyvZYRuz
         M9DXSVaqHOVCdHfQ98fQhg/5u6hnz9tpYWeuM8A/ksDhbsYPdysEOee6tWngyNByDKQl
         eN3Q==
X-Gm-Message-State: AOAM530CsIOMoPzMdC+CAEY3LMRI74yJDO61zx2s4GibpkeL3xSA1dIF
        EekXSDx9bK2WCu7kgan/civVa7x+OX+JKgz82g0u557VCpWRy8dCV+3J49pXxwfuXi/7gdKs1Z9
        A0Y6EeN3XYV133bmf7Q3Sjz8Aoibjozg2XQahcm+gq9UmAo0K2XIHVw==
X-Google-Smtp-Source: ABdhPJwd0jgvk8WmUzYK4JbaKoQgOYuM9EoGEG7NEksIQEKCTshj3hXmK99d1INk+Egu0MOOAW9QUC4=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:cbca:: with SMTP id b193mr8238733ybg.202.1599675851881;
 Wed, 09 Sep 2020 11:24:11 -0700 (PDT)
Date:   Wed,  9 Sep 2020 11:24:03 -0700
In-Reply-To: <20200909182406.3147878-1-sdf@google.com>
Message-Id: <20200909182406.3147878-3-sdf@google.com>
Mime-Version: 1.0
References: <20200909182406.3147878-1-sdf@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH bpf-next v4 2/5] bpf: Add BPF_PROG_BIND_MAP syscall
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

This syscall binds a map to a program. Returns success if the map is
already bound to the program.

Cc: YiFei Zhu <zhuyifei1999@gmail.com>
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/uapi/linux/bpf.h       |  7 ++++
 kernel/bpf/syscall.c           | 63 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  7 ++++
 3 files changed, 77 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 90359cab501d..fed50fa3ad7a 100644
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
index 90359cab501d..fed50fa3ad7a 100644
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
2.28.0.526.ge36021eeef-goog

