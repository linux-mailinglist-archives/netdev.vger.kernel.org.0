Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B0C1A6B43
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 19:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732718AbgDMRT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 13:19:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732670AbgDMRSl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 13:18:41 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB9C72076A;
        Mon, 13 Apr 2020 17:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586798320;
        bh=diygsHrujtkxdOjgK42/j6clPIEVUq33QjY8ljsaJZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyMJxX8HXiN3TbKYlFUIjxCPxJOvQl3I89PUQ66/DVXl6hZnEErGslg8MdgtNCtdI
         pTDSfn1yb69U3ckJvl+vc4KfVxMSU+3TfNcDTmHxJcM5I4A4UyzLlugFPsgtJ8MWFN
         GzzGTTB9FxIVyKNgp9K9gxp5JjPXCk0eU0OyUd9M=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH RFC-v5 bpf-next 12/12] samples/bpf: add XDP egress support to xdp1
Date:   Mon, 13 Apr 2020 11:18:01 -0600
Message-Id: <20200413171801.54406-13-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200413171801.54406-1-dsahern@kernel.org>
References: <20200413171801.54406-1-dsahern@kernel.org>
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
 samples/bpf/xdp1_user.c | 38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/samples/bpf/xdp1_user.c b/samples/bpf/xdp1_user.c
index c447ad9e3a1d..1e74020203ca 100644
--- a/samples/bpf/xdp1_user.c
+++ b/samples/bpf/xdp1_user.c
@@ -21,18 +21,32 @@
 static int ifindex;
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static __u32 prog_id;
+static bool egress;
 
 static void int_exit(int sig)
 {
+	struct bpf_xdp_set_link_opts opts = { .sz = sizeof(opts) };
 	__u32 curr_prog_id = 0;
+	int err, old_fd;
 
-	if (bpf_get_link_xdp_id(ifindex, &curr_prog_id, xdp_flags)) {
+	if (egress)
+		err = bpf_get_link_xdp_egress_id(ifindex, &curr_prog_id,
+						 xdp_flags);
+	else
+		err = bpf_get_link_xdp_id(ifindex, &curr_prog_id, xdp_flags);
+	if (err) {
 		printf("bpf_get_link_xdp_id failed\n");
 		exit(1);
 	}
-	if (prog_id == curr_prog_id)
-		bpf_set_link_xdp_fd(ifindex, -1, xdp_flags);
-	else if (!curr_prog_id)
+	if (prog_id == curr_prog_id) {
+		if (egress)
+			opts.egress = 1;
+
+		old_fd = bpf_prog_get_fd_by_id(prog_id);
+		opts.old_fd = old_fd;
+		bpf_set_link_xdp_fd_opts(ifindex, -1, xdp_flags, &opts);
+		close(old_fd);
+	} else if (!curr_prog_id)
 		printf("couldn't find a prog id on a given interface\n");
 	else
 		printf("program on interface changed, not removing\n");
@@ -73,19 +87,21 @@ static void usage(const char *prog)
 		"OPTS:\n"
 		"    -S    use skb-mode\n"
 		"    -N    enforce native mode\n"
-		"    -F    force loading prog\n",
+		"    -F    force loading prog\n"
+		"    -E	   egress path program\n",
 		prog);
 }
 
 int main(int argc, char **argv)
 {
+	struct bpf_xdp_set_link_opts opts = { .sz = sizeof(opts) };
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_prog_load_attr prog_load_attr = {
 		.prog_type	= BPF_PROG_TYPE_XDP,
 	};
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
-	const char *optstr = "FSN";
+	const char *optstr = "FSNE";
 	int prog_fd, map_fd, opt;
 	struct bpf_object *obj;
 	struct bpf_map *map;
@@ -103,6 +119,9 @@ int main(int argc, char **argv)
 		case 'F':
 			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
 			break;
+		case 'E':
+			egress = true;
+			break;
 		default:
 			usage(basename(argv[0]));
 			return 1;
@@ -130,6 +149,10 @@ int main(int argc, char **argv)
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	prog_load_attr.file = filename;
+	if (egress) {
+		opts.egress = 1;
+		prog_load_attr.expected_attach_type = BPF_XDP_EGRESS;
+	}
 
 	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
 		return 1;
@@ -149,7 +172,8 @@ int main(int argc, char **argv)
 	signal(SIGINT, int_exit);
 	signal(SIGTERM, int_exit);
 
-	if (bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags) < 0) {
+	err = bpf_set_link_xdp_fd_opts(ifindex, prog_fd, xdp_flags, &opts);
+	if (err < 0) {
 		printf("link set xdp fd failed\n");
 		return 1;
 	}
-- 
2.21.1 (Apple Git-122.3)

