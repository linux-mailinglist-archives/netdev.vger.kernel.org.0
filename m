Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93CDD1454CE
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbgAVNGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:06:18 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35817 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729240AbgAVNGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 08:06:06 -0500
Received: by mail-lj1-f193.google.com with SMTP id j1so6733622lja.2
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 05:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SBPO+HqnCTACPCYMS/LgCLu6FHz6w4VqNpcj8+EqcPY=;
        b=HELWQEDHIeztsXOy3EwiKvTGCxJ8VsuGggXK+QmVRL47GAw7vx8csVKnVDgpKH32ZP
         Y/waBDPZzzW9yXVldMTJiZR/3gau9IEmM8l9uHExMR1/MJMNu2BxMBh14LSEx0ysHJRD
         SzkbA3K6gW9rGWc6NTUT0oqGUcKH59haZpdmc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SBPO+HqnCTACPCYMS/LgCLu6FHz6w4VqNpcj8+EqcPY=;
        b=AdZkpA+UaT3pNoLAd5BhUvYcp9JM/rxi8XIvW2A4wdPSwaN3xq1Lu2NDZBf6dXO/eJ
         DvD+FP1koewxrKEuxFKgkBGg7F3RRES5VP8u5HNERJyNh0prK5o/ZQuyplhUKf5IeiX2
         guJrD8gsH+VCKPe0bFIGuv1E36mr+b4dS051fe0NuiroO8f3SdgkZQOnYPlhMrnZU+u1
         AZVFySL0mVCHMu991gs+Yd/P4xaemvEZ2WFZDsZ85xtr4a9ir7YUZEaOn41+PympYI0v
         toMxbltgE3zqfDM/oIkPqz9aarsCx405my5kYxO9Hh9lEJODSZurq1q6XsagGWbzwxEc
         fkPw==
X-Gm-Message-State: APjAAAX0sV9lwV2sQ9v70AldVTafpW3eXEWSfpYrv48iSd77N7oY+ccE
        Q9bTR1maeH4OeVYB9IPNw3w45cWfwoK6+w==
X-Google-Smtp-Source: APXvYqwmqIGpSOVMxbCbXphbmVKHDviZernmAC1TY3JApxiJmI8uPQ7qbvhsKdJss6zJk9NGl25mEA==
X-Received: by 2002:a2e:809a:: with SMTP id i26mr19707102ljg.108.1579698364867;
        Wed, 22 Jan 2020 05:06:04 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id q13sm19957047ljm.68.2020.01.22.05.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 05:06:04 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v3 09/12] bpf: Allow selecting reuseport socket from a SOCKMAP
Date:   Wed, 22 Jan 2020 14:05:46 +0100
Message-Id: <20200122130549.832236-10-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122130549.832236-1-jakub@cloudflare.com>
References: <20200122130549.832236-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SOCKMAP now supports storing references to listening sockets. Nothing keeps
us from using it as an array of sockets to select from in BPF reuseport
programs. Whitelist the map type with the bpf_sk_select_reuseport helper.

The restriction that the socket has to be a member of a reuseport group
still applies. Socket from a SOCKMAP that does not have sk_reuseport_cb set
is not a valid target and we signal it with -EINVAL.

This lifts the restriction that SOCKARRAY imposes, if SOCKMAP is used with
reuseport BPF, the listening sockets can exist in more than one BPF map at
the same time.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 kernel/bpf/verifier.c |  6 ++++--
 net/core/filter.c     | 15 ++++++++++-----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ca17dccc17ba..99fd7f4e0a1f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3693,7 +3693,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		if (func_id != BPF_FUNC_sk_redirect_map &&
 		    func_id != BPF_FUNC_sock_map_update &&
 		    func_id != BPF_FUNC_map_delete_elem &&
-		    func_id != BPF_FUNC_msg_redirect_map)
+		    func_id != BPF_FUNC_msg_redirect_map &&
+		    func_id != BPF_FUNC_sk_select_reuseport)
 			goto error;
 		break;
 	case BPF_MAP_TYPE_SOCKHASH:
@@ -3774,7 +3775,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
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
index 17de6747d9e3..e20f076ab9b0 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8625,6 +8625,7 @@ struct sock *bpf_run_sk_reuseport(struct sock_reuseport *reuse, struct sock *sk,
 BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 	   struct bpf_map *, map, void *, key, u32, flags)
 {
+	bool is_sockarray = map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY;
 	struct sock_reuseport *reuse;
 	struct sock *selected_sk;
 
@@ -8633,12 +8634,16 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 		return -ENOENT;
 
 	reuse = rcu_dereference(selected_sk->sk_reuseport_cb);
-	if (!reuse)
-		/* selected_sk is unhashed (e.g. by close()) after the
-		 * above map_lookup_elem().  Treat selected_sk has already
-		 * been removed from the map.
+	if (!reuse) {
+		/* reuseport_array has only sk with non NULL sk_reuseport_cb.
+		 * The only (!reuse) case here is - the sk has already been
+		 * unhashed (e.g. by close()), so treat it as -ENOENT.
+		 *
+		 * Other maps (e.g. sock_map) do not provide this guarantee and
+		 * the sk may never be in the reuseport group to begin with.
 		 */
-		return -ENOENT;
+		return is_sockarray ? -ENOENT : -EINVAL;
+	}
 
 	if (unlikely(reuse->reuseport_id != reuse_kern->reuseport_id)) {
 		struct sock *sk;
-- 
2.24.1

