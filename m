Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 669F05C47A
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfGAUsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:48:33 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:49177 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfGAUsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:48:33 -0400
Received: by mail-vk1-f201.google.com with SMTP id o202so3912199vko.16
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 13:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ui36edJNM3/6IjeIVND2MQix6moGekKCtsBACidEA/M=;
        b=VGY723StJzrK9t8YiEB5wDVfMpdF4fwFBKBmZoc6pqe5JQKIRWLt1HkTSSKLVTpOr2
         hJe/a1WitmlmqHqcutZMVhO7Dn/H8jqbZ3x5sSkcyuVypZeKUCrwv8xbePGIbQlFOygF
         oEs5avSEXib1Cw+ZUTRPctS6UGlCKn374xQNi2s53vTBjq1/peeoYETFRAtz/y/8cZ+R
         crecRNE8pV9vEzCol2KZErp0GdmDCwFs5WGfx8lMmhCJK6NKYv8SKncT08LuPve+WfGE
         RqtkCmV1azc1Z1+ZmwlY57r258pzQ9DYccekPyfOh1foekiCPUvmpxUn+zaPB11d/xR8
         0/5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ui36edJNM3/6IjeIVND2MQix6moGekKCtsBACidEA/M=;
        b=ZP1zWrm11ExGDAVWDI9EinMdY29ow++E8J1tjWOJQHZP0eNV4zQu+vnMzCx+Eog8/y
         chfV6vHeznoa2/7u4aJYIQrfFWJ48c6kbuhm8f3gu/2RKJ9xNNxHGXYsFBVe8ZwNGAjv
         cAyHVcmdveaEa7A7iNEkuErcVzdRTg0p8Yh4wBP9vnHGeE0C4PLX0rje35z6i46Usyvz
         S/2LpX//E8Sv7xjeqhOa4LqwTiOQlj8LECl7IKmpXi0zqCPf2s1Cwj3JFioqmC//Q+gw
         7rQyEeX+t/L86KnyMVRDhBBZEgQgEBnnXI3JZ9EtEThglVhTgKvv6sb8YDwFJFspv8Te
         su7A==
X-Gm-Message-State: APjAAAV5P3Uf/uKdG87fACajF8MGVdl51qzEaeJdJGMSAIZLANuvxukL
        r2sJdOTo4Vzo0Ik3fnJAXLl+GIEgYDTTHdAjHSEl0PP6UrTAC8kZQIgqF4lwDdsNr+6N239rA8M
        26T63yt3YJBCcE7CmJNIsLyHoF5/Gep3Sp3gweOBP/2upKQpL+BXnEQ==
X-Google-Smtp-Source: APXvYqz1j05bbTYjKaalEkRRRtnzGI/FV26vhPEruhaVGkWZtKihNpM/0iIRkyHLcQFlr58Tz1+Qxmw=
X-Received: by 2002:a67:c113:: with SMTP id d19mr15895270vsj.89.1562014111849;
 Mon, 01 Jul 2019 13:48:31 -0700 (PDT)
Date:   Mon,  1 Jul 2019 13:48:16 -0700
In-Reply-To: <20190701204821.44230-1-sdf@google.com>
Message-Id: <20190701204821.44230-4-sdf@google.com>
Mime-Version: 1.0
References: <20190701204821.44230-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next 3/8] bpf: add dsack_dups/delivered{,_ce} to bpf_tcp_sock
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

