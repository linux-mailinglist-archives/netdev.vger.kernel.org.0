Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7756751F4E
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 01:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbfFXXyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 19:54:24 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:34840 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728637AbfFXXyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 19:54:22 -0400
Received: by mail-qt1-f201.google.com with SMTP id v58so18914109qta.2
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 16:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lTASmr8508yaqk28Yw8XQISa65o9AY9rEgUPJ2XrbLE=;
        b=r0LIa8t8cJ7NaQ2a+C/uTGXaf7OQfAhksS84SuwNyHIZaQRl0RmfXqcz12wUsBrhs7
         2tIAUbiBOvx9i+MNZ6enW8oY+D/VHk56AZH50cRWPxiACMA5JS1c4xqQREt7FVE8xxnT
         BVQot6fbWkKdMBW0WxHE6v0dN8+fKyg4RB1QBUNul4L3ZzC9W8c3AbhI0Pnhbz26zWjk
         1ApU0XDmlpIRq8wskM/B4PPZdyrGDujgVFcP1cJA5Y4IpxKJFhxrZNAjd0gGy0X5FKMf
         BXjMR6YWjcAEEQ7w5YP7btA/irrQgK8Yta1ezVAddLDrauEWBWzuXnoQF6uRM+xV39Mb
         0m4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lTASmr8508yaqk28Yw8XQISa65o9AY9rEgUPJ2XrbLE=;
        b=XGSRlWtpv2yikFOjBEJq7RhHyFAJO/6bg3tAe+ks8D3+ouaJRN16/x7slHTh08r/ky
         6XKPN946JSIeHVjXz8KenuuQdcu+mgn9KPBebgXgTniSf9yYe9UHQZ9PfZ0uJFcipz6F
         t/VeMQgwxn6Qs5ykrN4lSYo6azvXrFXxLInOaDgZU4LzxCCjVnDq4ug7fApkzZXLfkXx
         v5q+KmlOf9onyAyShlL7qBnef/L45h4yU+lhSKIb1SEKsl8H6v8sdBQ5eHH72M6591HG
         eYdasZajumdOc3Q8RqK9fxDpWUrCMWqbsNg3kB1Sn/xn9yDVwlU4eyl4I/YLGbYE4f8Y
         GNOg==
X-Gm-Message-State: APjAAAXugsheKBf0v1CAeXF5K1BqmeYrwTLp3k84LtH7IvNVs8NPIBKC
        TZegVMyhxCXe9y3Q+3ptUruwI8qCGrx5Ddxw
X-Google-Smtp-Source: APXvYqxt8Ezi17/Qx95OXA8goGDuFtYQo//ogaYxT61oW1J+JaUgcvSkqkLsZjnKNNnXYDuaW92NRVS58w8TOI5t
X-Received: by 2002:aed:3e7c:: with SMTP id m57mr127049459qtf.204.1561420461923;
 Mon, 24 Jun 2019 16:54:21 -0700 (PDT)
Date:   Mon, 24 Jun 2019 16:53:33 -0700
In-Reply-To: <20190624235334.163625-1-allanzhang@google.com>
Message-Id: <20190624235334.163625-2-allanzhang@google.com>
Mime-Version: 1.0
References: <20190624235334.163625-1-allanzhang@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH v2 1/2] bpf: Allow bpf_skb_event_output for a few prog types
From:   allanzhang <allanzhang@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     allanzhang <allanzhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Software event output is only enabled by a few prog types right now (TC,
LWT out, XDP, sockops). Many other skb based prog types need
bpf_skb_event_output to produce software event.

Added socket_filter, cg_skb, sk_skb prog types to generate sw event.

Test bpf code is generated from code snippet:

struct TMP {
    uint64_t tmp;
} tt;
tt.tmp = 5;
bpf_perf_event_output(skb, &connection_tracking_event_map, 0,
                      &tt, sizeof(tt));
return 1;

the bpf assembly from llvm is:
       0:       b7 02 00 00 05 00 00 00         r2 = 5
       1:       7b 2a f8 ff 00 00 00 00         *(u64 *)(r10 - 8) = r2
       2:       bf a4 00 00 00 00 00 00         r4 = r10
       3:       07 04 00 00 f8 ff ff ff         r4 += -8
       4:       18 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00    r2 = 0ll
       6:       b7 03 00 00 00 00 00 00         r3 = 0
       7:       b7 05 00 00 08 00 00 00         r5 = 8
       8:       85 00 00 00 19 00 00 00         call 25
       9:       b7 00 00 00 01 00 00 00         r0 = 1
      10:       95 00 00 00 00 00 00 00         exit

Signed-off-by: allanzhang <allanzhang@google.com>
---
 net/core/filter.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2014d76e0d2a..b75fcf412628 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5958,6 +5958,8 @@ sk_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_socket_cookie_proto;
 	case BPF_FUNC_get_socket_uid:
 		return &bpf_get_socket_uid_proto;
+	case BPF_FUNC_perf_event_output:
+		return &bpf_skb_event_output_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -5978,6 +5980,8 @@ cg_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sk_storage_get_proto;
 	case BPF_FUNC_sk_storage_delete:
 		return &bpf_sk_storage_delete_proto;
+	case BPF_FUNC_perf_event_output:
+		return &bpf_skb_event_output_proto;
 #ifdef CONFIG_SOCK_CGROUP_DATA
 	case BPF_FUNC_skb_cgroup_id:
 		return &bpf_skb_cgroup_id_proto;
@@ -6226,6 +6230,8 @@ sk_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sk_redirect_map_proto;
 	case BPF_FUNC_sk_redirect_hash:
 		return &bpf_sk_redirect_hash_proto;
+	case BPF_FUNC_perf_event_output:
+		return &bpf_skb_event_output_proto;
 #ifdef CONFIG_INET
 	case BPF_FUNC_sk_lookup_tcp:
 		return &bpf_sk_lookup_tcp_proto;
-- 
2.22.0.410.gd8fdbe21b5-goog

