Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0403542D85
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 19:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405127AbfFLRao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 13:30:44 -0400
Received: from mail-yw1-f73.google.com ([209.85.161.73]:39674 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406395AbfFLRan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 13:30:43 -0400
Received: by mail-yw1-f73.google.com with SMTP id w127so18000007ywe.6
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 10:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=aYBwDRPMLFch8pErCdIVdR1XezeWG6lP+OS+4p/QF+c=;
        b=CpQCaylW6r4KuQiFK2ncRi0OFhoAF4GV8L7k1BLZzapxVl+Frhylr8y2Y3R2qRTIo4
         BbquX9A6+i3MWQ/FW2no1uDA4zc4cUprLSu5f2XAiEma7k4Wrb1qqDkWT3kCeD08tAIY
         EpLbDFfcgRluPaUt2hwGk5Lr1pQENs+1+J/hQL5W50c3OOdGZ/blvI7+jdhipHCXP7Vd
         t5j4Y5TGVmyoFoSY3OtXw/CSIOkkDFHnCgzSoiJofYlKTY/fnnrhRGnt1hI3WCxlhEQ4
         nq75c0i/yISy3tY6rsM0P+lO2bwNd1CVXnazov+L8hYJlgEd4f4BHAzBerePOK2fcLvm
         RumQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=aYBwDRPMLFch8pErCdIVdR1XezeWG6lP+OS+4p/QF+c=;
        b=fT4nI9wSn7RLK0H4xwdWBhJ99ywplIzNbjHOqj8eBUhBTYXTARlpThxQiJEf3i9NpD
         djGnSkQhilnDWOXxxr/DMgG+RXVP4Bx7aJIgObx/wEHE2ZH6nWZECtsEwn4U8yZvzxCw
         rVieCHXZapJc0RC7GQXrFla1ziDbYcFsCYcFp9L+IV1eU/F97gXG4BuTB18qQ4lajD7q
         2DZ0CCctThNt/7cH7NcvgKz+LG+vXBASYrGwvpO9Lg3D3Gm+XdKiTKhMt65CNzx3tO6s
         DGCo7kUchUotC/Rx8Au2ZQN4Lb5L0WbqNf1B3EPsPNSwzqrznsdlpR2K5Uu//8AiB8Fz
         Ys5g==
X-Gm-Message-State: APjAAAWQmZ9MXUnQA2y0SamHJEUsd84YNG5TT9gCHUS+4zu/2MDL8ktV
        gBXSZDVt9YZyIU08Valk89Zimaqy7Oi0DOXFJgQOqYRU0FNvk6XGCIVEgEGz+V7ypJ5HRkzA8R+
        tS9vX7f/+9dhE3w6Qp3uBYuQpoZMjMkZ4rKrlZio2DXTq1DvlYhkv8Q==
X-Google-Smtp-Source: APXvYqwsn4/amuGEz22WG8rYKmA2pTovjkohArEshMqJ0nEKfzISTDi8W5ZDi2i3k6uBkVUHB+OSj+g=
X-Received: by 2002:a81:f90:: with SMTP id 138mr36999084ywp.425.1560360642931;
 Wed, 12 Jun 2019 10:30:42 -0700 (PDT)
Date:   Wed, 12 Jun 2019 10:30:37 -0700
Message-Id: <20190612173040.61944-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH bpf-next 1/4] bpf: export bpf_sock for BPF_PROG_TYPE_CGROUP_SOCK_ADDR
 prog type
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

And let it use bpf_sk_storage_{get,delete} helpers to access socket
storage. Kernel context (struct bpf_sock_addr_kern) already has sk
member, so I just expose it to the BPF hooks. Using PTR_TO_SOCKET
instead of PTR_TO_SOCK_COMMON should be safe because the hook is
called on bind/connect.

Cc: Martin Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/uapi/linux/bpf.h |  1 +
 net/core/filter.c        | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ae0907d8c03a..8815fc418cde 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3247,6 +3247,7 @@ struct bpf_sock_addr {
 	__u32 msg_src_ip6[4];	/* Allows 1,2,4-byte read an 4-byte write.
 				 * Stored in network byte order.
 				 */
+	__bpf_md_ptr(struct bpf_sock *, sk);
 };
 
 /* User bpf_sock_ops struct to access socket values and specify request ops
diff --git a/net/core/filter.c b/net/core/filter.c
index a5e4ac7fcbe5..37c4a2fd559b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5922,6 +5922,10 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_skc_lookup_tcp:
 		return &bpf_sock_addr_skc_lookup_tcp_proto;
 #endif /* CONFIG_INET */
+	case BPF_FUNC_sk_storage_get:
+		return &bpf_sk_storage_get_proto;
+	case BPF_FUNC_sk_storage_delete:
+		return &bpf_sk_storage_delete_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -6828,6 +6832,13 @@ static bool sock_addr_is_valid_access(int off, int size,
 		if (size != size_default)
 			return false;
 		break;
+	case offsetof(struct bpf_sock_addr, sk):
+		if (type != BPF_READ)
+			return false;
+		if (size != sizeof(__u64))
+			return false;
+		info->reg_type = PTR_TO_SOCKET;
+		break;
 	default:
 		if (type == BPF_READ) {
 			if (size != size_default)
@@ -7778,6 +7789,11 @@ static u32 sock_addr_convert_ctx_access(enum bpf_access_type type,
 			struct bpf_sock_addr_kern, struct in6_addr, t_ctx,
 			s6_addr32[0], BPF_SIZE(si->code), off, tmp_reg);
 		break;
+	case offsetof(struct bpf_sock_addr, sk):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_sock_addr_kern, sk),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_sock_addr_kern, sk));
+		break;
 	}
 
 	return insn - insn_buf;
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

