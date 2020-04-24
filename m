Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3AB21B8049
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 22:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgDXUOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 16:14:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729538AbgDXUOr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 16:14:47 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDCAC21835;
        Fri, 24 Apr 2020 20:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587759286;
        bh=y6cYodOnqiQ7E1VdSwSuqVLLoLlzcN3HGsrUIcZG4y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uTlH56qWBQXiAPLes0tb0seKyfEWCyidtgt5DSB7v1iUhT+lsXU6aG4vcTI067g0H
         l+NtHgObyQeHSdGEHl8kmwuWOA01ZZcAQnQoywE3W999hxKwSC7nsBx9cnrIJpxoEN
         jSmJrgbt1i8G00niW9/mkph6GgxxUqmtYACDzXX8=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v3 bpf-next 15/15] samples/bpf: add XDP egress support to xdp1
Date:   Fri, 24 Apr 2020 14:14:28 -0600
Message-Id: <20200424201428.89514-16-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200424201428.89514-1-dsahern@kernel.org>
References: <20200424201428.89514-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

xdp1 and xdp2 now accept -E flag to set XDP program in the egress
path.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 samples/bpf/xdp1_user.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/xdp1_user.c b/samples/bpf/xdp1_user.c
index c447ad9e3a1d..bb104f4d8c5e 100644
--- a/samples/bpf/xdp1_user.c
+++ b/samples/bpf/xdp1_user.c
@@ -73,7 +73,8 @@ static void usage(const char *prog)
 		"OPTS:\n"
 		"    -S    use skb-mode\n"
 		"    -N    enforce native mode\n"
-		"    -F    force loading prog\n",
+		"    -F    force loading prog\n"
+		"    -E	   egress path program\n",
 		prog);
 }
 
@@ -85,7 +86,7 @@ int main(int argc, char **argv)
 	};
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
-	const char *optstr = "FSN";
+	const char *optstr = "FSNE";
 	int prog_fd, map_fd, opt;
 	struct bpf_object *obj;
 	struct bpf_map *map;
@@ -103,13 +104,17 @@ int main(int argc, char **argv)
 		case 'F':
 			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
 			break;
+		case 'E':
+			xdp_flags |= XDP_FLAGS_EGRESS_MODE;
+			prog_load_attr.expected_attach_type = BPF_XDP_EGRESS;
+			break;
 		default:
 			usage(basename(argv[0]));
 			return 1;
 		}
 	}
 
-	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
+	if (!(xdp_flags & (XDP_FLAGS_SKB_MODE | XDP_FLAGS_EGRESS_MODE)))
 		xdp_flags |= XDP_FLAGS_DRV_MODE;
 
 	if (optind == argc) {
-- 
2.21.1 (Apple Git-122.3)

