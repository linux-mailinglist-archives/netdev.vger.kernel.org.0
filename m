Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB8B124127
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 09:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfLRIM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 03:12:29 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36497 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfLRIM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 03:12:28 -0500
Received: by mail-pf1-f196.google.com with SMTP id x184so792544pfb.3
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 00:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oanPp9MNorBAEXrc7hv+/g6VKM8FXMmRJJCuEO/HANs=;
        b=qUhK/SZGz+i5Njm2abQVY+fJeuVH/+Pu0mwRJIuEpJadHystDCIouMj8QxftQY+g7P
         DoxfP2HbiRDwZAmbS73PZ5OnWGPimkpMqNGxoso6uODIdEeYuLIkpk32S7qTHDkK+Rhi
         KTDjXbaflp808Tb23GF5VIKhrrSAYSPmFLaXflZx6AYBSyUxvLu5sW9QF7e4DYSB3XZb
         jU3z0fo69oKhyHaNehiJTnXEWlk65VwtGMfvA10Rb8KPGMjZXR+iO5h2SkGO3xjYc+Ne
         MQ+hzuW1KLn3fFEvI4lBCC5nYX2dae3o1l7wO+Tw53Zf32jZAPyTxQYskINWQMT5bf9V
         w2+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oanPp9MNorBAEXrc7hv+/g6VKM8FXMmRJJCuEO/HANs=;
        b=loylcgerAxk9/pq1iEzjzBEiSwTtYCG00UJ8I95C5mrUYBfOYYwAHP38F+Vms1Rab0
         lB8ihSvdHx/UsgBu0I2GHEf5a2Gx8hcWMYLVZ4YdzY7qbI8Xr/1K5hWARwPlh7o3hfLt
         hmt+BpMNCQlRFP933yGks8BCQDkK88WLDsVCAbmLJEjbQQRdryOIJoX7aK5u9GEkX0IR
         OcU+3A6yczHdFPUrGIQ1W9DM+EDEFO7e9WPshAU7sWK0FG8c4yMZ8dpjIASwNuw0ktzz
         Vn93YmyBDgIamStKcD/8ULmcA6cuFI9BO7g/66s1Q1oWXboPTgO5GK1RAWNiFcl6m1Gh
         Gp0Q==
X-Gm-Message-State: APjAAAUVJGfcDyDqhA4bUnDDIHhC+iXXnRtPmJ4+zftsyYYznWxGfAVg
        tsIlUlCwzpVui/YL4S1pLn8=
X-Google-Smtp-Source: APXvYqyJGVNQmvtZIuUVnOwZFkB4cRcy0WwXXPqKdt7MfOC++6b5U9rg6FRdeE7qVuQ0wZITI9bg3A==
X-Received: by 2002:a63:6704:: with SMTP id b4mr1659198pgc.424.1576656747974;
        Wed, 18 Dec 2019 00:12:27 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s1sm1799181pgv.87.2019.12.18.00.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 00:12:27 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
Subject: [RFC net-next 04/14] samples/bpf: xdp1, add XDP tx support
Date:   Wed, 18 Dec 2019 17:10:40 +0900
Message-Id: <20191218081050.10170-5-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp1 and xdp2 now accept -T flag to set XDP program in the tx path.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 samples/bpf/xdp1_user.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/xdp1_user.c b/samples/bpf/xdp1_user.c
index 3e553eed95a7..16408f5afa4d 100644
--- a/samples/bpf/xdp1_user.c
+++ b/samples/bpf/xdp1_user.c
@@ -21,17 +21,26 @@
 static int ifindex;
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static __u32 prog_id;
+static bool tx_path;
 
 static void int_exit(int sig)
 {
 	__u32 curr_prog_id = 0;
+	int err;
 
-	if (bpf_get_link_xdp_id(ifindex, &curr_prog_id, xdp_flags)) {
+	if (tx_path)
+		err = bpf_get_link_xdp_tx_id(ifindex, &curr_prog_id, xdp_flags);
+	else
+		err = bpf_get_link_xdp_id(ifindex, &curr_prog_id, xdp_flags);
+	if (err) {
 		printf("bpf_get_link_xdp_id failed\n");
 		exit(1);
 	}
 	if (prog_id == curr_prog_id)
-		bpf_set_link_xdp_fd(ifindex, -1, xdp_flags);
+		if (tx_path)
+			bpf_set_link_xdp_tx_fd(ifindex, -1, xdp_flags);
+		else
+			bpf_set_link_xdp_fd(ifindex, -1, xdp_flags);
 	else if (!curr_prog_id)
 		printf("couldn't find a prog id on a given interface\n");
 	else
@@ -73,7 +82,8 @@ static void usage(const char *prog)
 		"OPTS:\n"
 		"    -S    use skb-mode\n"
 		"    -N    enforce native mode\n"
-		"    -F    force loading prog\n",
+		"    -F    force loading prog\n"
+		"    -T    TX path prog\n",
 		prog);
 }
 
@@ -85,7 +95,7 @@ int main(int argc, char **argv)
 	};
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
-	const char *optstr = "FSN";
+	const char *optstr = "FSNT";
 	int prog_fd, map_fd, opt;
 	struct bpf_object *obj;
 	struct bpf_map *map;
@@ -103,6 +113,9 @@ int main(int argc, char **argv)
 		case 'F':
 			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
 			break;
+		case 'T':
+			tx_path = true;
+			break;
 		default:
 			usage(basename(argv[0]));
 			return 1;
@@ -146,7 +159,12 @@ int main(int argc, char **argv)
 	signal(SIGINT, int_exit);
 	signal(SIGTERM, int_exit);
 
-	if (bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags) < 0) {
+	if (tx_path)
+		err = bpf_set_link_xdp_tx_fd(ifindex, prog_fd, xdp_flags);
+	else
+		err = bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags);
+
+	if (err < 0) {
 		printf("link set xdp fd failed\n");
 		return 1;
 	}
-- 
2.21.0

