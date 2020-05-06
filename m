Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7AB51C70F1
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 14:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgEFMz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728681AbgEFMzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 08:55:22 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEF8C061A41
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 05:55:21 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e16so2069771wra.7
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 05:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FvXoRuhTO+OxNF0cbAiPa+Gek9SWWsXi4MoNMSh2OYs=;
        b=Xd8Rqi9daAx3iYnyrr5t/LQBsjNXCh6OSPWaI9M/K3s+TxH5LqpakcBYtZsTyKM4uE
         Jy2pmxpnXS4RaOha9xrU2R7MpdTkjacg9UQ9k7Iq0txMc59CSIDTA/CL2LmWwXeJjJye
         bLmHzddGCL5J474DqbL+cG22404VPn7/ldIwU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FvXoRuhTO+OxNF0cbAiPa+Gek9SWWsXi4MoNMSh2OYs=;
        b=p6VME61wZdwYx43P8AMoUc0Xv+exBJWqt7XwgiZxiFx6kPWvz2m9uhJGpiErYrHW7k
         3rdTmHcZf2h+4rKP6kfeBrye7fBgGCPqFZ9/8cqjLH58LCHxDnX0u3ZkZxVH07iyBvcZ
         U5hU0YIOzl5PRHN7BVtDU8mk9ekQ1JaKctabPc2NyGsBI/s4USktP6hfMzyiUKUo/g0k
         I+QVyukwW4O3nJqIXwM4JojoJsyrup/nBzyw23J9AfdbUiSmBtv5Xl1pt88BiIoM83Tb
         NEgSq5VC/pfN6VwJkPKJrjc5nVH0nZXUlj1ONXXXScy8YSAcBXbO9MtBDMeDBM4oGGnT
         y3gQ==
X-Gm-Message-State: AGi0PubiFxBJIAKn3V492lm7PQAnnnXB6gB8/fcUbrfJD9RWGdZK51wr
        +3dxsRQWn89MIJ4wJMLWG8lbv/5WU+w=
X-Google-Smtp-Source: APiQypIw9GWmg8+jYFghcU+u+Ul8dI8H/abrLQvalKNXzcXrvflItoBKf5rx8JTbnK9RGVPl9Mggyw==
X-Received: by 2002:a05:6000:1209:: with SMTP id e9mr8969813wrx.45.1588769720299;
        Wed, 06 May 2020 05:55:20 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id i1sm2647901wrx.22.2020.05.06.05.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 05:55:19 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     dccp@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 03/17] inet: Store layer 4 protocol in inet_hashinfo
Date:   Wed,  6 May 2020 14:54:59 +0200
Message-Id: <20200506125514.1020829-4-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200506125514.1020829-1-jakub@cloudflare.com>
References: <20200506125514.1020829-1-jakub@cloudflare.com>
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

