Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0DC1136B5A
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 11:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgAJKuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 05:50:44 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37626 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727663AbgAJKun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 05:50:43 -0500
Received: by mail-wm1-f66.google.com with SMTP id f129so1474000wmf.2
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 02:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2zKVR4JK400AZUZJfaWp3jgqxUvpHxPxixzv590qtQE=;
        b=bH3LTB5fIYlUYIDu3IfcbrK0leeQjRZSx9avBmU7IRoGCP+DDV8FkkicXONpGwSR2g
         ya4XGVgRlb/eRqyCogSmrHJ28nqSYx4FR+WUPeosGEbQOp+jp0jYh+NqQUzkI5HhmI6z
         oEmEAn4MhZr57/3oPr1HeW9lGddkgE1s0dvU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2zKVR4JK400AZUZJfaWp3jgqxUvpHxPxixzv590qtQE=;
        b=DPX98/6nY02X7w1b82m04xW/NOLtB4qVdIQYcowAOTT4V9aS7WC5jhPh74JUPNCRnR
         cEYggYJvFP6m+FzffKNwLjIMG/vfXEu6KVMBiURyMOoTiAkP17GOpXr+emqZVOAz/CNw
         sjZNDog8baXvFPVhQ8s/IDwQuk61uyZS7hJFSLnuhTkHSvuAXNxIdTa/7nTFs+ZdMwq5
         URv+lZf6yo3B+IpuWblQMOyOTQ6BmI9H06lTrZGQPP3TjcvAbExtxfwc9Ql3kMp47GP5
         AWIsPFYLIgdWSyZinPw+WEXklPn35Ud6wUD1ueWbtjgR3duQDziZzja9lIMT/A2M38yx
         RgMA==
X-Gm-Message-State: APjAAAUxddc6PWly8s4VQbNWAsBlpvdxUD87ciHzblZH1BSVH0FzQmty
        J2Ij6gW9BEeMmFjwpX6gey5jSg==
X-Google-Smtp-Source: APXvYqymxvd4mELtc512J4u+9hMmyaYNeQsZvoQzfuWDy2Nh+6g1dN4DDR4jG/K2ZM03OdVDTFly9Q==
X-Received: by 2002:a7b:ce8b:: with SMTP id q11mr3524883wmj.100.1578653441760;
        Fri, 10 Jan 2020 02:50:41 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id b18sm1745422wru.50.2020.01.10.02.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 02:50:41 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v2 09/11] bpf: Allow selecting reuseport socket from a SOCKMAP
Date:   Fri, 10 Jan 2020 11:50:25 +0100
Message-Id: <20200110105027.257877-10-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110105027.257877-1-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SOCKMAP now supports storing references to listening sockets. Nothing keeps
us from using it as an array of sockets to select from in SK_REUSEPORT
programs.

Whitelist the map type with the BPF helper for selecting socket.

The restriction that the socket has to be a member of a reuseport group
still applies. Socket from a SOCKMAP that does not have sk_reuseport_cb set
is not a valid target and we signal it with -EINVAL.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 kernel/bpf/verifier.c |  6 ++++--
 net/core/filter.c     | 15 ++++++++++-----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f5af759a8a5f..0ee5f1594b5c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3697,7 +3697,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		if (func_id != BPF_FUNC_sk_redirect_map &&
 		    func_id != BPF_FUNC_sock_map_update &&
 		    func_id != BPF_FUNC_map_delete_elem &&
-		    func_id != BPF_FUNC_msg_redirect_map)
+		    func_id != BPF_FUNC_msg_redirect_map &&
+		    func_id != BPF_FUNC_sk_select_reuseport)
 			goto error;
 		break;
 	case BPF_MAP_TYPE_SOCKHASH:
@@ -3778,7 +3779,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
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
index a702761ef369..c79c62a54167 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8677,6 +8677,7 @@ struct sock *bpf_run_sk_reuseport(struct sock_reuseport *reuse, struct sock *sk,
 BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 	   struct bpf_map *, map, void *, key, u32, flags)
 {
+	bool is_sockarray = map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY;
 	struct sock_reuseport *reuse;
 	struct sock *selected_sk;
 
@@ -8685,12 +8686,16 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
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

