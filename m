Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17641B6B2A
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgDXCMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 22:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgDXCMP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 22:12:15 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3978521556;
        Fri, 24 Apr 2020 02:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587694335;
        bh=fW1BC6x7tMfCNt++/v7F2D1iENTMOQg79pviDBE/3s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5ZK1iaIEOL4yUkNq/t9F3YJFzRGPr9hpbIJa8ig1Arj+0Cv4IsA+6zl/kj6PlHgk
         8tLwiY+4W+FWc7PcoZCMksynwQHlyY1JoY1fC8LUNBvfRnj7ApmRcGuRGTEF1gNMcy
         /TzKkkKfG5Sv5i2UxJlcGMk5kvhIgxIiXAHYSh1g=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v2 bpf-next 17/17] samples/bpf: add XDP egress support to xdp1
Date:   Thu, 23 Apr 2020 20:11:48 -0600
Message-Id: <20200424021148.83015-18-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200424021148.83015-1-dsahern@kernel.org>
References: <20200424021148.83015-1-dsahern@kernel.org>
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
 samples/bpf/xdp1_user.c | 39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/samples/bpf/xdp1_user.c b/samples/bpf/xdp1_user.c
index c447ad9e3a1d..9f79bd537763 100644
--- a/samples/bpf/xdp1_user.c
+++ b/samples/bpf/xdp1_user.c
@@ -20,22 +20,37 @@
 
 static int ifindex;
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+static struct bpf_xdp_set_link_opts opts;
 static __u32 prog_id;
 
 static void int_exit(int sig)
 {
 	__u32 curr_prog_id = 0;
+	int rc;
 
-	if (bpf_get_link_xdp_id(ifindex, &curr_prog_id, xdp_flags)) {
-		printf("bpf_get_link_xdp_id failed\n");
+	if (opts.egress)
+		rc = bpf_get_link_xdp_egress_id(ifindex, &curr_prog_id, xdp_flags);
+	else
+		rc = bpf_get_link_xdp_id(ifindex, &curr_prog_id, xdp_flags);
+
+	if (rc) {
+		printf("Failed to get existing prog id for device");
 		exit(1);
 	}
+
+	if (curr_prog_id)
+		opts.old_fd = bpf_prog_get_fd_by_id(curr_prog_id);
+
 	if (prog_id == curr_prog_id)
-		bpf_set_link_xdp_fd(ifindex, -1, xdp_flags);
+		bpf_set_link_xdp_fd_opts(ifindex, -1, xdp_flags, &opts);
 	else if (!curr_prog_id)
 		printf("couldn't find a prog id on a given interface\n");
 	else
 		printf("program on interface changed, not removing\n");
+
+	if (opts.old_fd >= 0)
+		close(opts.old_fd);
+
 	exit(0);
 }
 
@@ -73,7 +88,8 @@ static void usage(const char *prog)
 		"OPTS:\n"
 		"    -S    use skb-mode\n"
 		"    -N    enforce native mode\n"
-		"    -F    force loading prog\n",
+		"    -F    force loading prog\n"
+		"    -E	   egress path program\n",
 		prog);
 }
 
@@ -83,15 +99,20 @@ int main(int argc, char **argv)
 	struct bpf_prog_load_attr prog_load_attr = {
 		.prog_type	= BPF_PROG_TYPE_XDP,
 	};
+	struct bpf_xdp_set_link_opts opts;
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
-	const char *optstr = "FSN";
+	const char *optstr = "FSNE";
 	int prog_fd, map_fd, opt;
 	struct bpf_object *obj;
 	struct bpf_map *map;
 	char filename[256];
 	int err;
 
+	memset(&opts, 0, sizeof(opts));
+	opts.sz = sizeof(opts);
+	opts.old_fd = -1;
+
 	while ((opt = getopt(argc, argv, optstr)) != -1) {
 		switch (opt) {
 		case 'S':
@@ -103,13 +124,17 @@ int main(int argc, char **argv)
 		case 'F':
 			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
 			break;
+		case 'E':
+			opts.egress = true;
+			prog_load_attr.expected_attach_type = BPF_XDP_EGRESS;
+			break;
 		default:
 			usage(basename(argv[0]));
 			return 1;
 		}
 	}
 
-	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
+	if (!(xdp_flags & XDP_FLAGS_SKB_MODE) && !opts.egress)
 		xdp_flags |= XDP_FLAGS_DRV_MODE;
 
 	if (optind == argc) {
@@ -149,7 +174,7 @@ int main(int argc, char **argv)
 	signal(SIGINT, int_exit);
 	signal(SIGTERM, int_exit);
 
-	if (bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags) < 0) {
+	if (bpf_set_link_xdp_fd_opts(ifindex, prog_fd, xdp_flags, &opts) < 0) {
 		printf("link set xdp fd failed\n");
 		return 1;
 	}
-- 
2.21.1 (Apple Git-122.3)

