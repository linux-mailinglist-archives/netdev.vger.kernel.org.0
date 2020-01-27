Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD50D14A4A8
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgA0NLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:11:21 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39787 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbgA0NLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:11:15 -0500
Received: by mail-lj1-f193.google.com with SMTP id o11so10605956ljc.6
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5TGuskX+oyn2N1Rk9g6dmvecHvmmmyDhj23M/Fkvjgg=;
        b=hUubQOgD1A8wW3G4SG8OtnwE0UXfT8Et01uje65pSxZtzuW07kQp1cUhjEAdBNQV1/
         PsvIiLJXI+KrVtc8BtjQQjktVTGFvH9w3g46t7Pyo+rbNfTB8S+Kvvx7pnFPvHK2V1OS
         j8r4OABR/3ApICrWyJXdUhWeuZ2UqJNLyo7xM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5TGuskX+oyn2N1Rk9g6dmvecHvmmmyDhj23M/Fkvjgg=;
        b=bHFw191ScimrrSNTJoXWY+22/EqXRHzfk4/ecK/p+UIW247n9JUwBXnP/5mPaeazIt
         l3Sy3sin/RDYCPy/opFAX13Pvu8yk001QiCPODEPGh9QYMp3Jxkmr7/kDwcYrb9mWLhe
         0QJIqixcrN5XNjmYO/KMMhihhQ/Avrng7S0CyYYowL6TdiJfUrJtQu7ZGPg+15Wfu4ym
         djk9IP7S/WbKgk2PKxIQWHNW33g0QoUQR824d4NSlmNsMbyfFuGbOrfugW6swMHmQEiQ
         qk7RHRjGqHc8STAVfFMa6bFeA2nvCpuCWAiEaLdhIkgtrUDITfE8NIX6Ry4hYnVF1mn4
         bYXA==
X-Gm-Message-State: APjAAAWaRCjlzI7XRJszW+5/W/uMsM3TF4OlckZhcJS2NV+PrVQTu1qa
        xgVT1U6i7YPHZuUDDzyv0p/6Ng==
X-Google-Smtp-Source: APXvYqzx2oIIpFKX9YaBOhmANhhJp+rR76NLtWj8rIokv4jFI4cMeYlUDVrdUD/GckUmRJf7V9VD5g==
X-Received: by 2002:a2e:9c0b:: with SMTP id s11mr9877137lji.11.1580130672553;
        Mon, 27 Jan 2020 05:11:12 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id a8sm2505066ljn.74.2020.01.27.05.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 05:11:11 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v6 09/12] bpf: Allow selecting reuseport socket from a SOCKMAP
Date:   Mon, 27 Jan 2020 14:10:54 +0100
Message-Id: <20200127131057.150941-10-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200127131057.150941-1-jakub@cloudflare.com>
References: <20200127131057.150941-1-jakub@cloudflare.com>
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
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 kernel/bpf/verifier.c |  6 ++++--
 net/core/filter.c     | 15 ++++++++++-----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1cc945daa9c8..9def066e6847 100644
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
index 792e3744b915..6922f1a55383 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8620,6 +8620,7 @@ struct sock *bpf_run_sk_reuseport(struct sock_reuseport *reuse, struct sock *sk,
 BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 	   struct bpf_map *, map, void *, key, u32, flags)
 {
+	bool is_sockarray = map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY;
 	struct sock_reuseport *reuse;
 	struct sock *selected_sk;
 
@@ -8628,12 +8629,16 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
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

