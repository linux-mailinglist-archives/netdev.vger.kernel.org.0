Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A92724997E
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 11:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgHSJid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 05:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbgHSJh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 05:37:56 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D425C06134D
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 02:37:53 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g75so1459372wme.4
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 02:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ue3HR4wod0zNE7CrQUQ6Ehp/OR8t+fJlFQGIBrnJpsQ=;
        b=Rfhvso3NOUQY38ai/WyXwxP2YDeNCMIDRXmyKlgbLBMHkJMlOQqpezKRmyPSc8yE5l
         AByj7j2lupGigIB1Sbv2NCH5gmhw9szstkADVs3B8XOOH4xvAL/1WJbu6Y1Q492zCM3C
         Kga7QxNepaIpc5TzhWJpd+NO3oPe+g4sBseQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ue3HR4wod0zNE7CrQUQ6Ehp/OR8t+fJlFQGIBrnJpsQ=;
        b=N9RHCMQEUO/cW49sQA3e3JpTjK/JVPZy8VATCU2S/A8tupDbDYhgHZf8nSwU2dAWE2
         ra2vGh5tLK3tYAUUDzyrDjZAdxXItWeLbzeULTsVQDDqAqkOHNn9IBGJ8Dkghi/N1NEn
         eJwldPoRKM159pgdZa8JkV7Hu4d10nz+wOXJtwxot3/ROFGJiGKjDB2ofIwhrEDjS8RE
         YbXJxm/+qRGDihhJim+Hp1bb2cx+YUk5nmK/P/rNJs1M/jFhZAHtpgBR7vWhcBkdsdvi
         Vtkv9KO/46xtt7BIcG7cmwjysk6gjFbb3SvCiT50bU9I7GAob/DxwxMN5e/dIYk6GmgO
         p1dg==
X-Gm-Message-State: AOAM530IKOH3Uhd+snyBkQoa4CfTShGDOuFgqCyn1GIduKP2Ivv7xOd7
        T/W51RyMe19tUsBAf2dwyYGdco+jMD384ApS
X-Google-Smtp-Source: ABdhPJyfOTr3NfoG4pa7vgJMAO71CXb8trGz1d/9B8xOJxYcpPa2cnYahVhVGBZH7ZVo9P+QPxqnTA==
X-Received: by 2002:a1c:4e10:: with SMTP id g16mr3787777wmh.146.1597829872125;
        Wed, 19 Aug 2020 02:37:52 -0700 (PDT)
Received: from antares.lan (c.d.0.4.4.2.3.3.e.9.1.6.6.d.0.6.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:60d6:619e:3324:40dc])
        by smtp.gmail.com with ESMTPSA id 3sm4204565wms.36.2020.08.19.02.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 02:37:51 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     jakub@cloudflare.com, john.fastabend@gmail.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 5/6] bpf: sockmap: allow update from BPF
Date:   Wed, 19 Aug 2020 10:24:35 +0100
Message-Id: <20200819092436.58232-6-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819092436.58232-1-lmb@cloudflare.com>
References: <20200819092436.58232-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow calling bpf_map_update_elem on sockmap and sockhash from a BPF
context. The synchronization required for this is a bit fiddly: we
need to prevent the socket from changing it's state while we add it
to the sockmap, since we rely on getting a callback via
sk_prot->unhash. However, we can't just lock_sock like in
sock_map_sk_acquire because that might sleep. So instead we disable
softirq processing and use bh_lock_sock to prevent further
modification.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 kernel/bpf/verifier.c |  6 ++++--
 net/core/sock_map.c   | 24 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 47f9b94bb9d4..421fccf18dea 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4254,7 +4254,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		    func_id != BPF_FUNC_map_delete_elem &&
 		    func_id != BPF_FUNC_msg_redirect_map &&
 		    func_id != BPF_FUNC_sk_select_reuseport &&
-		    func_id != BPF_FUNC_map_lookup_elem)
+		    func_id != BPF_FUNC_map_lookup_elem &&
+		    func_id != BPF_FUNC_map_update_elem)
 			goto error;
 		break;
 	case BPF_MAP_TYPE_SOCKHASH:
@@ -4263,7 +4264,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		    func_id != BPF_FUNC_map_delete_elem &&
 		    func_id != BPF_FUNC_msg_redirect_hash &&
 		    func_id != BPF_FUNC_sk_select_reuseport &&
-		    func_id != BPF_FUNC_map_lookup_elem)
+		    func_id != BPF_FUNC_map_lookup_elem &&
+		    func_id != BPF_FUNC_map_update_elem)
 			goto error;
 		break;
 	case BPF_MAP_TYPE_REUSEPORT_SOCKARRAY:
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 018367fb889f..b2c886c34566 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -603,6 +603,28 @@ int sock_map_update_elem_sys(struct bpf_map *map, void *key,
 	return ret;
 }
 
+static int sock_map_update_elem(struct bpf_map *map, void *key,
+				void *value, u64 flags)
+{
+	struct sock *sk = (struct sock *)value;
+	int ret;
+
+	if (!sock_map_sk_is_suitable(sk))
+		return -EOPNOTSUPP;
+
+	local_bh_disable();
+	bh_lock_sock(sk);
+	if (!sock_map_sk_state_allowed(sk))
+		ret = -EOPNOTSUPP;
+	else if (map->map_type == BPF_MAP_TYPE_SOCKMAP)
+		ret = sock_map_update_common(map, *(u32 *)key, sk, flags);
+	else
+		ret = sock_hash_update_common(map, key, sk, flags);
+	bh_unlock_sock(sk);
+	local_bh_enable();
+	return ret;
+}
+
 BPF_CALL_4(bpf_sock_map_update, struct bpf_sock_ops_kern *, sops,
 	   struct bpf_map *, map, void *, key, u64, flags)
 {
@@ -687,6 +709,7 @@ const struct bpf_map_ops sock_map_ops = {
 	.map_free		= sock_map_free,
 	.map_get_next_key	= sock_map_get_next_key,
 	.map_lookup_elem_sys_only = sock_map_lookup_sys,
+	.map_update_elem	= sock_map_update_elem,
 	.map_delete_elem	= sock_map_delete_elem,
 	.map_lookup_elem	= sock_map_lookup,
 	.map_release_uref	= sock_map_release_progs,
@@ -1180,6 +1203,7 @@ const struct bpf_map_ops sock_hash_ops = {
 	.map_alloc		= sock_hash_alloc,
 	.map_free		= sock_hash_free,
 	.map_get_next_key	= sock_hash_get_next_key,
+	.map_update_elem	= sock_map_update_elem,
 	.map_delete_elem	= sock_hash_delete_elem,
 	.map_lookup_elem	= sock_hash_lookup,
 	.map_lookup_elem_sys_only = sock_hash_lookup_sys,
-- 
2.25.1

