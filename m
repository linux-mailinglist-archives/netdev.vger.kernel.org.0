Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD06512A9CC
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfLZCdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:33:32 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45303 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbfLZCdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:33:32 -0500
Received: by mail-pl1-f196.google.com with SMTP id b22so9914757pls.12
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 18:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NJgksG3l0wyueuuJ36JHFJcZkKOOlyDSdDxskOD5Glg=;
        b=ns4TCPnIbHEikaqrd5LxaNmhQJxty0dApTS8HYdN9kaIo/203lPLf5+RcOqxt/tve/
         cbqR4NoWu4UX4ySlg7YSZyqfXIbR0BU2k7EyD0XA4keFLYF5KK6EzscVbL8GzB04SCN8
         759diviO45TVrwp31Ae5xyH3WI1KsUX9cMAYZa9i6Ds9WgYC4gGZqE1PgQDGacRl0TeF
         NM1QhIAIS9x5frhsQp1zD12UAujCDqXEWrp5jOFEzwC20c6aJc+Zu9Ccz1x3K3enZNyE
         4WLOmAX2xcSz5s6SbEJWHZ4o/WDHrCkN0muUhzLCiadDpBNmT+6fsxFwDemcsTob9nNi
         AHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NJgksG3l0wyueuuJ36JHFJcZkKOOlyDSdDxskOD5Glg=;
        b=ULwCKZE7l+TiSHEnJdjrzP6nWwudWG+XU6i97eCkFHb9CR98ifh5Z7aU2IlgZE6FIU
         l4Hid3NsNPpbyzv+aYHw397V1xrJ/Oos4Qzq+7WLQF9114zyKhFPYcX40gWoRvlHF1/G
         fhAiqtgEHCkceBvqXMCN1NWCfZUDkWhBvzOqzNcro/hI6w7I4g2djo998JS27oe8H41B
         B9pGbJpe63LmIW5uhxA3Fmt+rIvBwsyk4U3qgC855PMqN1Z29kdQ1pm2we0KZJ4zy4sY
         Tg9cl7tz3EcjGDBHPGKvz3K4NJTS0zDy+NVxBhqNHxrNk5/7InYD8GfYT9LwNWm+F+Jx
         Nvkg==
X-Gm-Message-State: APjAAAVdXHkE0GdHyaIwIEAFKlF5LZLS75lFPOXuyn+uAJ11oQNH7CGv
        N25KkyfuaH4SzC8IFLug488=
X-Google-Smtp-Source: APXvYqz3Gmu3Gonu6vbfXkfypwE1/nVYVn8Ug0IvDFHnBysQO9L7aqpAoCcVC5kVrSY+uwTeNRb2aQ==
X-Received: by 2002:a17:902:a403:: with SMTP id p3mr29029476plq.126.1577327611823;
        Wed, 25 Dec 2019 18:33:31 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id e6sm33865222pfh.32.2019.12.25.18.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:33:31 -0800 (PST)
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
Subject: [RFC v2 net-next 05/12] samples/bpf: xdp1, add XDP tx support
Date:   Thu, 26 Dec 2019 11:31:53 +0900
Message-Id: <20191226023200.21389-6-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
References: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp1 and xdp2 now accept -T flag to set XDP program in the tx path.
The user program uses new APIs bpf_get_link_opts/bpf_set_link_opts.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 samples/bpf/xdp1_user.c | 42 +++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/samples/bpf/xdp1_user.c b/samples/bpf/xdp1_user.c
index 3e553eed95a7..d8e27d4f785c 100644
--- a/samples/bpf/xdp1_user.c
+++ b/samples/bpf/xdp1_user.c
@@ -21,21 +21,31 @@
 static int ifindex;
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static __u32 prog_id;
+static bool tx_path;
 
 static void int_exit(int sig)
 {
-	__u32 curr_prog_id = 0;
+	struct bpf_link_xdp_opts xdp_opts = {};
+	int err;
+
+	xdp_opts.flags = xdp_flags;
+	xdp_opts.tx_path = tx_path;
 
-	if (bpf_get_link_xdp_id(ifindex, &curr_prog_id, xdp_flags)) {
-		printf("bpf_get_link_xdp_id failed\n");
+	err = bpf_get_link_opts(ifindex, &xdp_opts, BPF_LINK_GET_XDP_ID);
+	if (err) {
+		printf("getting xdp program id failed\n");
 		exit(1);
 	}
-	if (prog_id == curr_prog_id)
-		bpf_set_link_xdp_fd(ifindex, -1, xdp_flags);
-	else if (!curr_prog_id)
+
+	if (prog_id == xdp_opts.prog_id) {
+		xdp_opts.prog_fd = -1;
+		err = bpf_set_link_opts(ifindex, &xdp_opts,
+					BPF_LINK_SET_XDP_FD);
+	} else if (!xdp_opts.prog_id) {
 		printf("couldn't find a prog id on a given interface\n");
-	else
+	} else {
 		printf("program on interface changed, not removing\n");
+	}
 	exit(0);
 }
 
@@ -73,7 +83,8 @@ static void usage(const char *prog)
 		"OPTS:\n"
 		"    -S    use skb-mode\n"
 		"    -N    enforce native mode\n"
-		"    -F    force loading prog\n",
+		"    -F    force loading prog\n"
+		"    -T    TX path prog\n",
 		prog);
 }
 
@@ -83,9 +94,10 @@ int main(int argc, char **argv)
 	struct bpf_prog_load_attr prog_load_attr = {
 		.prog_type	= BPF_PROG_TYPE_XDP,
 	};
+	struct bpf_link_xdp_opts xdp_opts = {0};
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
-	const char *optstr = "FSN";
+	const char *optstr = "FSNT";
 	int prog_fd, map_fd, opt;
 	struct bpf_object *obj;
 	struct bpf_map *map;
@@ -103,6 +115,9 @@ int main(int argc, char **argv)
 		case 'F':
 			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
 			break;
+		case 'T':
+			tx_path = true;
+			break;
 		default:
 			usage(basename(argv[0]));
 			return 1;
@@ -127,6 +142,8 @@ int main(int argc, char **argv)
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	prog_load_attr.file = filename;
+	if (tx_path)
+		prog_load_attr.expected_attach_type = BPF_XDP_EGRESS;
 
 	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
 		return 1;
@@ -146,7 +163,12 @@ int main(int argc, char **argv)
 	signal(SIGINT, int_exit);
 	signal(SIGTERM, int_exit);
 
-	if (bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags) < 0) {
+	xdp_opts.prog_fd = prog_fd;
+	xdp_opts.flags = xdp_flags;
+	xdp_opts.tx_path = tx_path;
+
+	err = bpf_set_link_opts(ifindex, &xdp_opts, BPF_LINK_SET_XDP_FD);
+	if (err < 0) {
 		printf("link set xdp fd failed\n");
 		return 1;
 	}
-- 
2.21.0

