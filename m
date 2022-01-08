Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F604883D1
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 14:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbiAHNrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 08:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiAHNrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 08:47:46 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3F6C061574;
        Sat,  8 Jan 2022 05:47:46 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id c9-20020a17090a1d0900b001b2b54bd6c5so15259586pjd.1;
        Sat, 08 Jan 2022 05:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qsUWdMgA9ejz0BZRd8Puzaib+oj52HzmXgBvzo1KBR0=;
        b=p/pAZ/Uh9NMDrSM/f/xu062O+luIjHGPAbnTMQBLKR9Ke3lbS+nFQy6rLGhMth13e6
         bfnsF+y/GiOqafUqGqTBhKEMIlBw3yat638sYpTMsUmtyHVhINk1qzuQZxG9Ris9kgJX
         CY0AlHCPY7AfkQNqdCaDRBh0aEL7rIgHgnVZG92Oh/feEUTd7Gp1z3qCK5dUeJhyQGmT
         Tlo9S0iiFn5ZbhLKUYR1jDxICsJ0EkcTv3/rfIvxFi1vFHkd3D0xS8ZHl/WvR6ObzrhA
         sk9lqVCJQdvR4d7vVEU4YTH/EvCpCXVkjtdzVjiHXvhl875gPUacbXeX0Xq4zLumHOSK
         tX5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qsUWdMgA9ejz0BZRd8Puzaib+oj52HzmXgBvzo1KBR0=;
        b=KVanOgCe/EiDZ5Olvm8v1Jm2C7elu5fscoxbK6GYQEWE2lSRMHFfTx+FPnCEZRUZIV
         hfUPR88NmCEahF3tFDM8rDEh0YRcmWkefYvqPxQKNyawcb6c044s4inoTDDBxCe8g+4S
         PKlJ9rUxJQ0b+0MI8WOG6EBl29MUXJYWL+XthfHGiPpqzKejfofWzbA5FfgwLZQOZcYB
         cWCgV/6Flce3L7/8uNqzIPjAK2lWpwHnmqY9wjp6U7xOpflzeelo22ngmPhFZLq0au8l
         l2rhCiQ+19WMvTb/+vLI9BkNFJhJ8NQb/QIWTnD1kmla6/JY0IfUduykJNJ7918Sj9k8
         3GUQ==
X-Gm-Message-State: AOAM532ErBZYBt4UqfDZstREJZKFhcMg5JjeN/2H3uuG0xfS+792PL3r
        meZCorbBdwSJ/HuTA0YQF57Q9+9l799DGUuk
X-Google-Smtp-Source: ABdhPJw6Jl6rbMyXJN32M97irwNVtyHKxzHNpSzggX71MJLoEex5dLBxVUvY8b5Z0x0qopfKBg1DDg==
X-Received: by 2002:a17:902:8345:b0:14a:1a98:4288 with SMTP id z5-20020a170902834500b0014a1a984288mr1820391pln.79.1641649665694;
        Sat, 08 Jan 2022 05:47:45 -0800 (PST)
Received: from vultr.guest ([45.76.74.237])
        by smtp.gmail.com with ESMTPSA id d14sm2102811pfl.132.2022.01.08.05.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 05:47:45 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH] libbpf: fix possible NULL pointer dereference when destroy skelton
Date:   Sat,  8 Jan 2022 13:47:39 +0000
Message-Id: <20220108134739.32541-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When I checked the code in skelton header file generated with my own bpf
prog, I found there may be possible NULL pointer derefence when destroy
skelton. Then I checked the in-tree bpf progs, finding that is a common
issue. Let's take the generated samples/bpf/xdp_redirect_cpu.skel.h for
example. Below is the generated code in
xdp_redirect_cpu__create_skeleton(),
	xdp_redirect_cpu__create_skeleton
		struct bpf_object_skeleton *s;
		s = (struct bpf_object_skeleton *)calloc(1, sizeof(*s));
		if (!s)
			goto error;
		...
	error:
		bpf_object__destroy_skeleton(s);
		return  -ENOMEM;

After goto error, the NULL 's' will be deferenced in
bpf_object__destroy_skeleton().

We can simply fix this issue by just adding a NULL check in
bpf_object__destroy_skeleton().

Fixes: d66562fba ("libbpf: Add BPF object skeleton support")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7c74342bb668..a07fbd59e4b8 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -11464,6 +11464,9 @@ void bpf_object__detach_skeleton(struct bpf_object_skeleton *s)
 
 void bpf_object__destroy_skeleton(struct bpf_object_skeleton *s)
 {
+	if (!s)
+		return;
+
 	if (s->progs)
 		bpf_object__detach_skeleton(s);
 	if (s->obj)
-- 
2.17.1

