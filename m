Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCEF5D405
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfGBQOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:14:15 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:37190 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbfGBQOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:14:14 -0400
Received: by mail-pg1-f201.google.com with SMTP id s5so1167243pgr.4
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 09:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MIl+bJMRAhkIbRpU6BNMIRoV4pzAnJmzDzmuTUxvK3U=;
        b=DkdUph+lQV4EIVIzGAQPOMt0QqStjm2N/xo3mHSg5drHLYkWOwU6bHruYftk+RHlUH
         pgkzE9Yp+v0T6CNoc27X7ZEml6Qh4CXa8XyscSCdhuzu+qKDaGzCrGpWipbtJRGJRmCU
         3wf2+W5DLFFyveyLgBU/4DhZAWpOIVmuVocms5qFKRAiJ+1uWVBj+MqulGAgcZKz6p7I
         /n9sU7kaHAA1ctkjdiSFheap+pkQdU8F/ToT0ARHDlqq8qRiEMtoZzGYEMC41feQxLim
         HITJR1LQXP5i1kIvgvPeqYENPtT5XH/eAYYDt7qLOJh/N9d23tk7kBm/vIRiKa841N3V
         oYsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MIl+bJMRAhkIbRpU6BNMIRoV4pzAnJmzDzmuTUxvK3U=;
        b=RqYjzsu+jFN/gvPX5HF3wPQEzPOKMQZyLsXhm2Vg/5BnRoIGtpn92mZF68tJMCBOAo
         4HMTevnozybHjQ8QNhNxUKjY/IUsa2d9g8apjUt/Dr1C0KtkjOkSGPOJKnkPu94bcBUw
         hHzWL9U5I7CwFh7aphmk7k4WZAJSH18hChZMgTfCTlAqgPPbR9RHwIpWS8gvEEA77WhF
         HHCp/J+z08ewUt+6HhPnjK7FMlODZvOgrnnyKjFn2gD2/l1dBVK/9TLdBJX4J9DLoAu0
         jmVll/hmO9Unof665Km/e1TsBh3GV4m5/tRLhMn4NKUIsqbDmPENk/OvRE5RTVKUjppJ
         jVWw==
X-Gm-Message-State: APjAAAVG9kRMRAFW1RntJH/B/F4UQASPllX9cp0d2TX9toGfGnIyIIIC
        JE4KVIHExwdtZjJj9CtipQ8DF/95u+yloMD9ofo37TDxhXDNTVoHzKHufVhm794a/uFlGXMSxWB
        p+OasZosbISiqgKSb190Wz33mI3sk+IEnUS0xNy5wEZxj8vAEBThJ7g==
X-Google-Smtp-Source: APXvYqwtPsl5I74GSmFxLhdpk8DVcdB9Mkc6pbp8YGo/RHWhLu/dyjQNFnSdqXumZgqA0ECOM0URXak=
X-Received: by 2002:a63:f817:: with SMTP id n23mr31759307pgh.35.1562084053797;
 Tue, 02 Jul 2019 09:14:13 -0700 (PDT)
Date:   Tue,  2 Jul 2019 09:13:58 -0700
In-Reply-To: <20190702161403.191066-1-sdf@google.com>
Message-Id: <20190702161403.191066-4-sdf@google.com>
Mime-Version: 1.0
References: <20190702161403.191066-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v2 3/8] bpf: add dsack_dups/delivered{,_ce} to bpf_tcp_sock
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add more fields to bpf_tcp_sock that might be useful for debugging
congestion control issues.

Cc: Eric Dumazet <edumazet@google.com>
Cc: Priyaranjan Jha <priyarjha@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/uapi/linux/bpf.h |  5 +++++
 net/core/filter.c        | 11 ++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 9cdd0aaeba06..bfb0b1a76684 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3073,6 +3073,11 @@ struct bpf_tcp_sock {
 				 * sum(delta(snd_una)), or how many bytes
 				 * were acked.
 				 */
+	__u32 dsack_dups;	/* RFC4898 tcpEStatsStackDSACKDups
+				 * total number of DSACK blocks received
+				 */
+	__u32 delivered;	/* Total data packets delivered incl. rexmits */
+	__u32 delivered_ce;	/* Like the above but only ECE marked packets */
 };
 
 struct bpf_sock_tuple {
diff --git a/net/core/filter.c b/net/core/filter.c
index ad908526545d..3da4b6c38b46 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5544,7 +5544,7 @@ static const struct bpf_func_proto bpf_sock_addr_sk_lookup_udp_proto = {
 bool bpf_tcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 				  struct bpf_insn_access_aux *info)
 {
-	if (off < 0 || off >= offsetofend(struct bpf_tcp_sock, bytes_acked))
+	if (off < 0 || off >= offsetofend(struct bpf_tcp_sock, delivered_ce))
 		return false;
 
 	if (off % size != 0)
@@ -5652,6 +5652,15 @@ u32 bpf_tcp_sock_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct bpf_tcp_sock, bytes_acked):
 		BPF_TCP_SOCK_GET_COMMON(bytes_acked);
 		break;
+	case offsetof(struct bpf_tcp_sock, dsack_dups):
+		BPF_TCP_SOCK_GET_COMMON(dsack_dups);
+		break;
+	case offsetof(struct bpf_tcp_sock, delivered):
+		BPF_TCP_SOCK_GET_COMMON(delivered);
+		break;
+	case offsetof(struct bpf_tcp_sock, delivered_ce):
+		BPF_TCP_SOCK_GET_COMMON(delivered_ce);
+		break;
 	}
 
 	return insn - insn_buf;
-- 
2.22.0.410.gd8fdbe21b5-goog

