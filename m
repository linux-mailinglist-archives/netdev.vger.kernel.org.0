Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C62FB107E26
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 12:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfKWLIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 06:08:05 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39801 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfKWLIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 06:08:04 -0500
Received: by mail-lj1-f196.google.com with SMTP id e10so1135701ljj.6
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 03:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RxMAa2iOTtRkT8FRp26jq90HvEuBpMxInXLJsam4QfI=;
        b=zEvKCwp4MD5fVn/qVLnuhj3XM5qQtwKvZlW8/6NuIcqkU4Aelr0fbGjNAinNAuc8ci
         5S9sxy7RZOEl3Qa23CjJczLIHvgyE7+srDhH28RqZkFzsIcrmOySleu9z926qlqlQBKg
         Mo8KaC1ODKyECgoqg7NROA0Ae6x3Tll/xJ7JA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RxMAa2iOTtRkT8FRp26jq90HvEuBpMxInXLJsam4QfI=;
        b=UADb61lySESkQ2G8eT/QcBCjoZMlDr36Q9raW76oVDZM6KRUEail8NbgLkDZNnx3an
         jPbw3ev7mGl+x1T6xomfhI/0fM2eBqbbGi4YqAVxom4Mnhoq0J1ItuGoxivDbqhqMylr
         vYyjjbtn2s/LV318ZIwSRnCiMu9G7sIbkmtR37NTfgiCtHC+OqhPl0F1PcQOo98Ve/Di
         lOO9iEg+suqe20Bo0o6CHBL+vbB33kE75v8f6WzyDtGSulV/m0wnOUHuYw1sRj3yGY+t
         +hS26pmGI2+9j9bq2dqpR2wbFcthTLpVx1spoK2DjS4Col/Ahe1d9AjGpGQC+guCZcix
         vXVA==
X-Gm-Message-State: APjAAAVPhatLjosfeOt0kKUDSYaevKeWJ9klHRJD8hxaYw3xFRlwbSAY
        OrLHwBTYyOICb/p8Dk0WG5geSQ==
X-Google-Smtp-Source: APXvYqwlG8CLf+7V2QhjICvLInHx3UsWhjvsNoA2rW7NZbxfikD1k7W99cq2EGnGQEo6rak+gpC7yg==
X-Received: by 2002:a05:651c:87:: with SMTP id 7mr15911788ljq.20.1574507280699;
        Sat, 23 Nov 2019 03:08:00 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id q124sm596852ljq.93.2019.11.23.03.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 03:08:00 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next 5/8] bpf: Allow selecting reuseport socket from a SOCKMAP
Date:   Sat, 23 Nov 2019 12:07:48 +0100
Message-Id: <20191123110751.6729-6-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191123110751.6729-1-jakub@cloudflare.com>
References: <20191123110751.6729-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SOCKMAP now supports storing references to listening sockets. Nothing keeps
us from using it as an array of sockets to select from in SK_REUSEPORT
programs.

Whitelist the map type with the BPF helper for selecting socket. However,
impose a restriction that the selected socket needs to be a listening TCP
socket or a bound UDP socket (connected or not).

The only other map type that works with the BPF reuseport helper,
REUSEPORT_SOCKARRAY, has a corresponding check in its update operation
handler.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 kernel/bpf/verifier.c | 6 ++++--
 net/core/filter.c     | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a0482e1c4a77..111a1eb543ab 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3685,7 +3685,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		if (func_id != BPF_FUNC_sk_redirect_map &&
 		    func_id != BPF_FUNC_sock_map_update &&
 		    func_id != BPF_FUNC_map_delete_elem &&
-		    func_id != BPF_FUNC_msg_redirect_map)
+		    func_id != BPF_FUNC_msg_redirect_map &&
+		    func_id != BPF_FUNC_sk_select_reuseport)
 			goto error;
 		break;
 	case BPF_MAP_TYPE_SOCKHASH:
@@ -3766,7 +3767,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 			goto error;
 		break;
 	case BPF_FUNC_sk_select_reuseport:
-		if (map->map_type != BPF_MAP_TYPE_REUSEPORT_SOCKARRAY)
+		if (map->map_type != BPF_MAP_TYPE_REUSEPORT_SOCKARRAY &&
+		    map->map_type != BPF_MAP_TYPE_SOCKMAP)
 			goto error;
 		break;
 	case BPF_FUNC_map_peek_elem:
diff --git a/net/core/filter.c b/net/core/filter.c
index 49ded4a7588a..e3fb77353248 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8723,6 +8723,8 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 	selected_sk = map->ops->map_lookup_elem(map, key);
 	if (!selected_sk)
 		return -ENOENT;
+	if (!sock_flag(selected_sk, SOCK_RCU_FREE))
+		return -EINVAL;
 
 	reuse = rcu_dereference(selected_sk->sk_reuseport_cb);
 	if (!reuse)
-- 
2.20.1

