Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB160146085
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 02:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgAWBmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 20:42:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:59882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729092AbgAWBm3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 20:42:29 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4C2424686;
        Thu, 23 Jan 2020 01:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579743748;
        bh=EfTAn5mwHDeL7VcK/Dul+M1bNJ14Gpphqty6Accb/V4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2E7RfKnqa/0uvhhU827x8h2lYQn7T1KZYrVYR79ZVd3ipwFjWJhChOG3JOdXDX4rU
         lpZxxBDxXh49/jHAvvD6/lxKhDI+Kj8+nm+qZ34vWVcHu2Kc9R3AGrl97vEFk+Sbzf
         jMgaI6wushQ2/MOz4DnUg0AnZWHsgJjwOIhNm6PY=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        jbrouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
Subject: [PATCH bpf-next 12/12] samples/bpf: xdp1, add egress XDP support
Date:   Wed, 22 Jan 2020 18:42:10 -0700
Message-Id: <20200123014210.38412-13-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200123014210.38412-1-dsahern@kernel.org>
References: <20200123014210.38412-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Bhole <prashantbhole.linux@gmail.com>

xdp1 and xdp2 now accept -E flag to set XDP program in the egress
path.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 samples/bpf/xdp1_user.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/xdp1_user.c b/samples/bpf/xdp1_user.c
index c447ad9e3a1d..72c5bedbd030 100644
--- a/samples/bpf/xdp1_user.c
+++ b/samples/bpf/xdp1_user.c
@@ -21,17 +21,27 @@
 static int ifindex;
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static __u32 prog_id;
+static bool egress;
 
 static void int_exit(int sig)
 {
 	__u32 curr_prog_id = 0;
+	int err;
 
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
 	if (prog_id == curr_prog_id)
-		bpf_set_link_xdp_fd(ifindex, -1, xdp_flags);
+		if (egress)
+			bpf_set_link_xdp_egress_fd(ifindex, -1, xdp_flags);
+		else
+			bpf_set_link_xdp_fd(ifindex, -1, xdp_flags);
 	else if (!curr_prog_id)
 		printf("couldn't find a prog id on a given interface\n");
 	else
@@ -73,7 +83,8 @@ static void usage(const char *prog)
 		"OPTS:\n"
 		"    -S    use skb-mode\n"
 		"    -N    enforce native mode\n"
-		"    -F    force loading prog\n",
+		"    -F    force loading prog\n"
+		"    -E	   egress path program\n",
 		prog);
 }
 
@@ -85,7 +96,7 @@ int main(int argc, char **argv)
 	};
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
-	const char *optstr = "FSN";
+	const char *optstr = "FSNE";
 	int prog_fd, map_fd, opt;
 	struct bpf_object *obj;
 	struct bpf_map *map;
@@ -103,6 +114,9 @@ int main(int argc, char **argv)
 		case 'F':
 			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
 			break;
+		case 'E':
+			egress = true;
+			break;
 		default:
 			usage(basename(argv[0]));
 			return 1;
@@ -130,6 +144,8 @@ int main(int argc, char **argv)
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	prog_load_attr.file = filename;
+	if (egress)
+		prog_load_attr.expected_attach_type = BPF_XDP_EGRESS;
 
 	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
 		return 1;
@@ -149,7 +165,11 @@ int main(int argc, char **argv)
 	signal(SIGINT, int_exit);
 	signal(SIGTERM, int_exit);
 
-	if (bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags) < 0) {
+	if (egress)
+		err = bpf_set_link_xdp_egress_fd(ifindex, prog_fd, xdp_flags);
+	else
+		err = bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags);
+	if (err < 0) {
 		printf("link set xdp fd failed\n");
 		return 1;
 	}
-- 
2.21.1 (Apple Git-122.3)

