Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F3D34C1D
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 17:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbfFDPYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 11:24:13 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43268 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbfFDPYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 11:24:13 -0400
Received: by mail-ed1-f65.google.com with SMTP id w33so959693edb.10
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 08:24:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=dqpMLEv4Au/4xGqHjBf1UkeVwsEXZXrnU9o554Wq0bQ=;
        b=l1OjILN6G45Nj/3jVtxsLPbDaedeJFl1PIgIdPh6uIcdFhzqJhv2/ckfSsX9TQF5ZT
         cU9J1WGyCUsvvNNmQxYimyxzkQZi4uOiL01ZiPdMzeB8THRYSf4tHKgcFebgI5l4o0fg
         FWVu5/FXMMxAcpt7wzq2VW9fmdAeQnWichelwVpMaew/Rpdr2F3GpXoxs0Ma0DUDqFi4
         OSZUQdzbVDiJgb9bae+OieWqsQbcrwWwbpDkW8l1FzxjsDS2mLo4QyWLkaDUm3n+J5Hv
         VpWfUHzh6yuvppE9Er+h6BZ90S1Vz3WTHViyWgVdIw1m2abkv9yspuytPHs3cUTW/HRq
         gdnw==
X-Gm-Message-State: APjAAAVVK2VLqvyf1Hli4fmcOCRnleBsA1GQU44aF1vhRRx4OTZjiQ9K
        v1Rdv8CBNLVK6ODG73ZUWRHnvA==
X-Google-Smtp-Source: APXvYqznk8TzAOuwE6rI5aQiKPIOX7anCFNuuWM+s9ev+LXUWXIhBO4WnO9/aAJefB7E2GB6YViLFA==
X-Received: by 2002:a50:f410:: with SMTP id r16mr21086498edm.169.1559661851915;
        Tue, 04 Jun 2019 08:24:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id p60sm4971705edp.93.2019.06.04.08.24.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 08:24:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CD5261802E7; Tue,  4 Jun 2019 17:24:10 +0200 (CEST)
Subject: [PATCH net-next 2/2] devmap: Allow map lookups from eBPF
From:   Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Date:   Tue, 04 Jun 2019 17:24:10 +0200
Message-ID: <155966185078.9084.7775851923786129736.stgit@alrua-x1>
In-Reply-To: <155966185058.9084.14076895203527880808.stgit@alrua-x1>
References: <155966185058.9084.14076895203527880808.stgit@alrua-x1>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't currently allow lookups into a devmap from eBPF, because the map
lookup returns a pointer directly to the dev->ifindex, which shouldn't be
modifiable from eBPF.

However, being able to do lookups in devmaps is useful to know (e.g.)
whether forwarding to a specific interface is enabled. Currently, programs
work around this by keeping a shadow map of another type which indicates
whether a map index is valid.

To allow lookups, simply copy the ifindex into a scratch variable and
return a pointer to this. If an eBPF program does modify it, this doesn't
matter since it will be overridden on the next lookup anyway. While this
does add a write to every lookup, the overhead of this is negligible
because the cache line is hot when both the write and the subsequent read
happens.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/devmap.c   |    8 +++++++-
 kernel/bpf/verifier.c |    7 ++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 5ae7cce5ef16..830650300ea4 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -65,6 +65,7 @@ struct xdp_bulk_queue {
 struct bpf_dtab_netdev {
 	struct net_device *dev; /* must be first member, due to tracepoint */
 	struct bpf_dtab *dtab;
+	int ifindex_scratch;
 	unsigned int bit;
 	struct xdp_bulk_queue __percpu *bulkq;
 	struct rcu_head rcu;
@@ -375,7 +376,12 @@ static void *dev_map_lookup_elem(struct bpf_map *map, void *key)
 	struct bpf_dtab_netdev *obj = __dev_map_lookup_elem(map, *(u32 *)key);
 	struct net_device *dev = obj ? obj->dev : NULL;
 
-	return dev ? &dev->ifindex : NULL;
+	if (dev) {
+		obj->ifindex_scratch = dev->ifindex;
+		return &obj->ifindex_scratch;
+	}
+
+	return NULL;
 }
 
 static void dev_map_flush_old(struct bpf_dtab_netdev *dev)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5c2cb5bd84ce..7128a9821481 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2893,12 +2893,9 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		if (func_id != BPF_FUNC_get_local_storage)
 			goto error;
 		break;
-	/* devmap returns a pointer to a live net_device ifindex that we cannot
-	 * allow to be modified from bpf side. So do not allow lookup elements
-	 * for now.
-	 */
 	case BPF_MAP_TYPE_DEVMAP:
-		if (func_id != BPF_FUNC_redirect_map)
+		if (func_id != BPF_FUNC_redirect_map &&
+		    func_id != BPF_FUNC_map_lookup_elem)
 			goto error;
 		break;
 	/* Restrict bpf side of cpumap and xskmap, open when use-cases

