Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539F0229CF0
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730813AbgGVQR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728299AbgGVQR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 12:17:26 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124F5C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:17:26 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id z24so3100856ljn.8
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z/vrIiZMIRo5/cj1woXZIrQCk0a6lQc+EnEXLrdvZDY=;
        b=nGO92wwI6A9aKT66SCiThO3sDJZCJxa7fVpdgCzIw9xhQ+B5DLTpyiMD/ZgmjPwUHe
         nStizFhG99wuFIulTOAiIxJm6wNWqcTMPkVJSJX8XfEEhXOLQt+tXoDf1QmAEGiOKMTj
         wRdRj1YgACsQBncBSLgf1QkNBpFkmcp8uvMOo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z/vrIiZMIRo5/cj1woXZIrQCk0a6lQc+EnEXLrdvZDY=;
        b=hoSc354QwSklVZqtrt1d+1XLH2mu7Gz+a239d8k9W3kAWThnckLiV5D7abYbdIpGtj
         gZGXN9jZ8k79Znf1/vG2+ijGzhs+dJddKPUkYhOcwmTJDQI/p8K83cfIkBPgf7gXBiOs
         HLiqaFbJJDo11dPBsZlu/j6vfxqUMmbdb0elZXD83dQMauj/IOTTP96eXuWrmzahLhRe
         i5ZHKtauS0/CswrBANz4DkCL36XFtnIeLAwK5Xg/CyOc9eGMS/S+ZPIX8i2eExYvQwgD
         RE5YdSG6gBSbI/QBV1akG796Gs6Lhz/U/pK6dUQ/qiuAXkYf4uSJsov3OqpyqNRd/scj
         gyuQ==
X-Gm-Message-State: AOAM530eBf8Tvu2Uol/22Xg/qBp31VEc41z/Op3tHBwHcd9X+VHzqkNJ
        habRCLSd2cs+q8KXGpQmY3t8jg==
X-Google-Smtp-Source: ABdhPJx+ynMKTKOhOxISF52y6PBHe5A50p4EnDunQPBRVF2AgtvHY9OnRSh0hYVujv35fl9YEksNXQ==
X-Received: by 2002:a2e:96d6:: with SMTP id d22mr6495ljj.67.1595434644460;
        Wed, 22 Jul 2020 09:17:24 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id t4sm313045ljg.11.2020.07.22.09.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 09:17:23 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next 1/2] udp: Don't discard reuseport selection when group has connections
Date:   Wed, 22 Jul 2020 18:17:19 +0200
Message-Id: <20200722161720.940831-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200722161720.940831-1-jakub@cloudflare.com>
References: <20200722161720.940831-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When BPF socket lookup prog selects a socket that belongs to a reuseport
group, and the reuseport group has connected sockets in it, the socket
selected by reuseport will be discarded, and socket returned by BPF socket
lookup will be used instead.

Modify this behavior so that the socket selected by reuseport running after
BPF socket lookup always gets used. Ignore the fact that the reuseport
group might have connections because it is only relevant when scoring
sockets during regular hashtable-based lookup.

Fixes: 72f7e9440e9b ("udp: Run SK_LOOKUP BPF program on socket lookup")
Fixes: 6d4201b1386b ("udp6: Run SK_LOOKUP BPF program on socket lookup")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/ipv4/udp.c | 5 +----
 net/ipv6/udp.c | 5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index b5231ab350e0..487740d0088c 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -421,9 +421,6 @@ static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
 		hash = udp_ehashfn(net, daddr, hnum, saddr, sport);
 		reuse_sk = reuseport_select_sock(sk, hash, skb,
 						 sizeof(struct udphdr));
-		/* Fall back to scoring if group has connections */
-		if (reuseport_has_conns(sk, false))
-			return NULL;
 	}
 	return reuse_sk;
 }
@@ -447,7 +444,7 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 		if (score > badness) {
 			result = lookup_reuseport(net, sk, skb,
 						  saddr, sport, daddr, hnum);
-			if (result)
+			if (result && !reuseport_has_conns(sk, false))
 				return result;
 
 			badness = score;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index ff8be202726a..8fd8eb04994c 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -155,9 +155,6 @@ static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
 		hash = udp6_ehashfn(net, daddr, hnum, saddr, sport);
 		reuse_sk = reuseport_select_sock(sk, hash, skb,
 						 sizeof(struct udphdr));
-		/* Fall back to scoring if group has connections */
-		if (reuseport_has_conns(sk, false))
-			return NULL;
 	}
 	return reuse_sk;
 }
@@ -180,7 +177,7 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 		if (score > badness) {
 			result = lookup_reuseport(net, sk, skb,
 						  saddr, sport, daddr, hnum);
-			if (result)
+			if (result && !reuseport_has_conns(sk, false))
 				return result;
 
 			result = sk;
-- 
2.25.4

