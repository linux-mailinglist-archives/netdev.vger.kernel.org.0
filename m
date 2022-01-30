Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950694A3611
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 12:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354722AbiA3LzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 06:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236399AbiA3LzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 06:55:23 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1ABC061714
        for <netdev@vger.kernel.org>; Sun, 30 Jan 2022 03:55:22 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id z20so15573978ljo.6
        for <netdev@vger.kernel.org>; Sun, 30 Jan 2022 03:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pW0HJO+D1Fw6jhblBLImzq7tz0T2dvMaNsNBAeCsUSA=;
        b=LnsiT5QTgsVFMwEGS4dq1HVWNktIzrht5NOm+55QgGyTyVbUog0IIRiP7HB0VEcW0H
         MrHIy3pjpzDC3vslRL4YRsw2oDSa/GbtWBTO1xY45LfZovc1hhkslJJtE66Zhhq4kqQ5
         +c8CBK8e3ELxWI7Ssp88Bk63ckpfKuOD1GgPM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pW0HJO+D1Fw6jhblBLImzq7tz0T2dvMaNsNBAeCsUSA=;
        b=5Sf+rCF6mLZHYmC2u1smXBCVX0Z6sg4JYM1wWj0Unc54bc9cxtOPtr1glxnWNeGxx8
         JhsRlXctkOWyE+7i088/7emYRfI8MkE5Ay9Gwkq1SU3+U0biQlFIwdTcagUGurTksHMC
         CRciADvu4jWaVjDz4Q0sviIb/phi7OKUjjqCk1jkMj/FaNy17dETbT7bBK1YigK+gH7w
         SAOlJFVoi4jmF591zpcZQ9Bvw+12IMqcgTRakmEhQWHeL+HLRDtLaNPm0kRWC9FTUwQq
         7Gx3No3pLiSRn4pCaXVubtvyXvph0tLedcC/c9NNZJ2Hj6cFzTcyuOt2BTdPR/zyWPsL
         mmxg==
X-Gm-Message-State: AOAM530ottZWO5W+XHe/LRseYdF23IpQJVi4wqb8/eljeePyTgE4Bvuy
        swBStCA8RVEmTarmyNJg0y3u5hLOGMcMbg==
X-Google-Smtp-Source: ABdhPJxLxdjVQTnA+gLsUhDPnrXA0zNWFdlIN26U0EKO0e/hIiBDSsBaEsChwvgVfKc4QgAT6VS+ug==
X-Received: by 2002:a2e:a786:: with SMTP id c6mr10333403ljf.385.1643543721036;
        Sun, 30 Jan 2022 03:55:21 -0800 (PST)
Received: from cloudflare.com (2a01-110f-4809-d800-0000-0000-0000-0e00.aa.ipv6.supernova.orange.pl. [2a01:110f:4809:d800::e00])
        by smtp.gmail.com with ESMTPSA id f11sm2339618lfg.132.2022.01.30.03.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 03:55:20 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v2 1/2] bpf: Make dst_port field in struct bpf_sock 16-bit wide
Date:   Sun, 30 Jan 2022 12:55:17 +0100
Message-Id: <20220130115518.213259-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220130115518.213259-1-jakub@cloudflare.com>
References: <20220130115518.213259-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Menglong Dong reports that the documentation for the dst_port field in
struct bpf_sock is inaccurate and confusing. From the BPF program PoV, the
field is a zero-padded 16-bit integer in network byte order. The value
appears to the BPF user as if laid out in memory as so:

  offsetof(struct bpf_sock, dst_port) + 0  <port MSB>
                                      + 8  <port LSB>
                                      +16  0x00
                                      +24  0x00

32-, 16-, and 8-bit wide loads from the field are all allowed, but only if
the offset into the field is 0.

32-bit wide loads from dst_port are especially confusing. The loaded value,
after converting to host byte order with bpf_ntohl(dst_port), contains the
port number in the upper 16-bits.

Remove the confusion by splitting the field into two 16-bit fields. For
backward compatibility, allow 32-bit wide loads from offsetof(struct
bpf_sock, dst_port).

While at it, allow loads 8-bit loads at offset [0] and [1] from dst_port.

Reported-by: Menglong Dong <imagedong@tencent.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/uapi/linux/bpf.h |  3 ++-
 net/core/filter.c        | 10 +++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4a2f7041ebae..a7f0ddedac1f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5574,7 +5574,8 @@ struct bpf_sock {
 	__u32 src_ip4;
 	__u32 src_ip6[4];
 	__u32 src_port;		/* host byte order */
-	__u32 dst_port;		/* network byte order */
+	__be16 dst_port;	/* network byte order */
+	__u16 :16;		/* zero padding */
 	__u32 dst_ip4;
 	__u32 dst_ip6[4];
 	__u32 state;
diff --git a/net/core/filter.c b/net/core/filter.c
index a06931c27eeb..99a05199a806 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8265,6 +8265,7 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 			      struct bpf_insn_access_aux *info)
 {
 	const int size_default = sizeof(__u32);
+	int field_size;
 
 	if (off < 0 || off >= sizeof(struct bpf_sock))
 		return false;
@@ -8276,7 +8277,6 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 	case offsetof(struct bpf_sock, family):
 	case offsetof(struct bpf_sock, type):
 	case offsetof(struct bpf_sock, protocol):
-	case offsetof(struct bpf_sock, dst_port):
 	case offsetof(struct bpf_sock, src_port):
 	case offsetof(struct bpf_sock, rx_queue_mapping):
 	case bpf_ctx_range(struct bpf_sock, src_ip4):
@@ -8285,6 +8285,14 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 	case bpf_ctx_range_till(struct bpf_sock, dst_ip6[0], dst_ip6[3]):
 		bpf_ctx_record_field_size(info, size_default);
 		return bpf_ctx_narrow_access_ok(off, size, size_default);
+	case bpf_ctx_range(struct bpf_sock, dst_port):
+		field_size = size == size_default ?
+			size_default : sizeof_field(struct bpf_sock, dst_port);
+		bpf_ctx_record_field_size(info, field_size);
+		return bpf_ctx_narrow_access_ok(off, size, field_size);
+	case offsetofend(struct bpf_sock, dst_port) ...
+	     offsetof(struct bpf_sock, dst_ip4) - 1:
+		return false;
 	}
 
 	return size == size_default;
-- 
2.31.1

