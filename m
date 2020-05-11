Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F00B1CE310
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 20:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731192AbgEKSw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 14:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731118AbgEKSw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 14:52:27 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F756C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 11:52:27 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x17so12329792wrt.5
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 11:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FvXoRuhTO+OxNF0cbAiPa+Gek9SWWsXi4MoNMSh2OYs=;
        b=lN6akM13XSE2xICX2oJeLUaQpxpRfD86G5Fg8THYpbFg2B9oM6eP/Qd3dayzo24jbB
         4K66X/3QSxRSboA7ONrOl7m05HVl3UcogusI0fZa+CVwYlg8GmCQ+Ur9lx4noBN24Kr+
         euPFVc1ZMy6yKWbHEzK4AYM1tbHH7IOkHVgrE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FvXoRuhTO+OxNF0cbAiPa+Gek9SWWsXi4MoNMSh2OYs=;
        b=STLt6ZsLd2DSrhcQTjOYtYcZz46ueFvrZbCJJb2O69xaB//021Ldpwa4V4tPFlM16c
         nj+9o8cpWKJqodI3/h7JNyQ9/SZSP1Kr2cs2EGV3ULtVFHW3HfJGCy8XAihBRY9dOdf4
         xcSTsUOd4KIe1wrPSNy6Zka1A04YfqkkGvIaZsDfICm64pK/f+lD4NndJ0KCUuHaj+TK
         uacZXV1q/HNrIQIzzSRCgNGxidpJEecSosOx9Y/Lakif35HKreiPt/PCJmsEXUPh7KG2
         KsSErXfAK9kSD1fBNM0MiqMLWkHqEEhQ5SUkoNefllvtLBBL+gPrbVXkMuTIboY83Qx6
         yFrA==
X-Gm-Message-State: AGi0Pub6M2gRTya/OZhelrZBLwEDnSWrQKT22b8r89qdYHZYA2S7bkAn
        vKGOJw561ZPeCw2b9Ok36JqlUMfS0Yk=
X-Google-Smtp-Source: APiQypJxh99m7yN54Y1joe7NaE8hRQ595h3QhvRwfDoyeebRy9cDyEUuNOjoJTrrz38t1z99ugb66g==
X-Received: by 2002:adf:97d9:: with SMTP id t25mr11823884wrb.176.1589223145799;
        Mon, 11 May 2020 11:52:25 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id p190sm27952831wmp.38.2020.05.11.11.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 11:52:25 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     dccp@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v2 03/17] inet: Store layer 4 protocol in inet_hashinfo
Date:   Mon, 11 May 2020 20:52:04 +0200
Message-Id: <20200511185218.1422406-4-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200511185218.1422406-1-jakub@cloudflare.com>
References: <20200511185218.1422406-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make it possible to identify the protocol of sockets stored in hashinfo
without looking up a socket.

Subsequent patches make use the new field at the socket lookup time to
ensure that BPF program selects only sockets with matching protocol.

Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/inet_hashtables.h | 3 +++
 net/dccp/proto.c              | 2 +-
 net/ipv4/tcp_ipv4.c           | 2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index ad64ba6a057f..6072dfbd1078 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -144,6 +144,9 @@ struct inet_hashinfo {
 	unsigned int			lhash2_mask;
 	struct inet_listen_hashbucket	*lhash2;
 
+	/* Layer 4 protocol of the stored sockets */
+	int				protocol;
+
 	/* All the above members are written once at bootup and
 	 * never written again _or_ are predominantly read-access.
 	 *
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 4af8a98fe784..c826419e68e6 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -45,7 +45,7 @@ EXPORT_SYMBOL_GPL(dccp_statistics);
 struct percpu_counter dccp_orphan_count;
 EXPORT_SYMBOL_GPL(dccp_orphan_count);
 
-struct inet_hashinfo dccp_hashinfo;
+struct inet_hashinfo dccp_hashinfo = { .protocol = IPPROTO_DCCP };
 EXPORT_SYMBOL_GPL(dccp_hashinfo);
 
 /* the maximum queue length for tx in packets. 0 is no limit */
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6c05f1ceb538..77e4f4e4c73c 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -87,7 +87,7 @@ static int tcp_v4_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
 			       __be32 daddr, __be32 saddr, const struct tcphdr *th);
 #endif
 
-struct inet_hashinfo tcp_hashinfo;
+struct inet_hashinfo tcp_hashinfo = { .protocol = IPPROTO_TCP };
 EXPORT_SYMBOL(tcp_hashinfo);
 
 static u32 tcp_v4_init_seq(const struct sk_buff *skb)
-- 
2.25.3

