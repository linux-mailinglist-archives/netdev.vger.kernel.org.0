Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706A6330D8
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 15:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbfFCNTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 09:19:22 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42465 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbfFCNTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 09:19:20 -0400
Received: by mail-lj1-f194.google.com with SMTP id t28so5041039lje.9
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 06:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=daJ7DQFGqdxbmrFgyxA8+fMwjZ7EZmTJaFWyZhbuPPI=;
        b=f58EisfL3R0On8w6XI8fk4pktzS2e2WC0fdh1q5/SSwC2j0Zv8D68ZtqZnXqPxIfwJ
         JX7SuqkyniOJe2i5WjRHkIYpw8KLbsCoRCiUGRsvBBhHmbCQvIwHozzFKfHjewXVgy+B
         RuOKXu5N0H/lJXyVTnI9cX2QdcE79v1woS0p7CyyT8oz5bt7g4SLxcWiEB++lO4CTgPw
         EJn6sek+eEumPRvx8MCH1hg8zUUfVFVjP3TtgS1KCmNeDJQyk1Zeqslzew0Uwo3k/cjp
         IH4TIfsXkg7WqqWczf3fyQFftywyg2lM36xINDphfL8I/qYbRBXkfl6+wDTKr02iILm4
         3Vpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=daJ7DQFGqdxbmrFgyxA8+fMwjZ7EZmTJaFWyZhbuPPI=;
        b=DfaYWNPLkSQ67IVBzbMmAQTLG7LOhkenFI6YEXxMCAnGOOC55u+TXor04h4zIwQHqA
         3QABRZrfPtwUwlKXmSOdRCBFrqAHEFXB7ls6REZ/coT+hH6woFbw7JjZpZn4P/lt7r+Z
         eENGJX7x1IsQxNLxk/4QYoOB9/YnRzJ1nRsSX6DB2CoLYmyv1PiNL24FWh94BQt1w6s+
         XKU188C27cN1MkEht0RXnAKeCArPTcerwjpgKccFXs82mjKpstdNATgSu5bdxFFneZn/
         6KpKfNJduPVt/yU2YkvqrVGMXm3YCW47x0i6lNYd7drSdY+/JzhiIUuHFgOmlI/7W8x1
         75cQ==
X-Gm-Message-State: APjAAAW11oLONMSf1PWO7hhHTjpvkJ+z1pKpMD2fDdouZLOXVjMEgnIr
        TIpXMKb2aGqwxx30KGY5sa0=
X-Google-Smtp-Source: APXvYqzgs4funjynq2k3D2uouY4yWO9HADzQyLUTMgTEaoIeGg+C/DZkcVqxZ2MoGmr1fsiMq/rMbg==
X-Received: by 2002:a2e:998b:: with SMTP id w11mr6493752lji.179.1559567957055;
        Mon, 03 Jun 2019 06:19:17 -0700 (PDT)
Received: from localhost.localdomain (host-185-93-94-143.ip-point.pl. [185.93.94.143])
        by smtp.gmail.com with ESMTPSA id 20sm577808ljf.21.2019.06.03.06.19.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 03 Jun 2019 06:19:16 -0700 (PDT)
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
X-Google-Original-From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com,
        jonathan.lemon@gmail.com, songliubraving@fb.com
Subject: [RFC PATCH bpf-next 3/4] libbpf: move xdp program removal to libbpf
Date:   Mon,  3 Jun 2019 15:19:06 +0200
Message-Id: <20190603131907.13395-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.16.1
In-Reply-To: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
References: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since xsk support in libbpf loads the xdp program interface, make it
also responsible for its removal. Store the prog id in xsk_socket_config
so when removing the program we are still able to compare the current
program id with the id from the attachment time and make a decision
onward.

While at it, remove the socket/umem in xdpsock's error path.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 samples/bpf/xdpsock_user.c | 33 ++++++++++-----------------------
 tools/lib/bpf/xsk.c        | 32 ++++++++++++++++++++++++++++++++
 tools/lib/bpf/xsk.h        |  1 +
 3 files changed, 43 insertions(+), 23 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index e9dceb09b6d1..123862b16dd4 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -68,7 +68,6 @@ static int opt_queue;
 static int opt_poll;
 static int opt_interval = 1;
 static u32 opt_xdp_bind_flags;
-static __u32 prog_id;
 
 struct xsk_umem_info {
 	struct xsk_ring_prod fq;
@@ -170,22 +169,6 @@ static void *poller(void *arg)
 	return NULL;
 }
 
-static void remove_xdp_program(void)
-{
-	__u32 curr_prog_id = 0;
-
-	if (bpf_get_link_xdp_id(opt_ifindex, &curr_prog_id, opt_xdp_flags)) {
-		printf("bpf_get_link_xdp_id failed\n");
-		exit(EXIT_FAILURE);
-	}
-	if (prog_id == curr_prog_id)
-		bpf_set_link_xdp_fd(opt_ifindex, -1, opt_xdp_flags);
-	else if (!curr_prog_id)
-		printf("couldn't find a prog id on a given interface\n");
-	else
-		printf("program on interface changed, not removing\n");
-}
-
 static void int_exit(int sig)
 {
 	struct xsk_umem *umem = xsks[0]->umem->umem;
@@ -195,7 +178,6 @@ static void int_exit(int sig)
 	dump_stats();
 	xsk_socket__delete(xsks[0]->xsk);
 	(void)xsk_umem__delete(umem);
-	remove_xdp_program();
 
 	exit(EXIT_SUCCESS);
 }
@@ -206,7 +188,16 @@ static void __exit_with_error(int error, const char *file, const char *func,
 	fprintf(stderr, "%s:%s:%i: errno: %d/\"%s\"\n", file, func,
 		line, error, strerror(error));
 	dump_stats();
-	remove_xdp_program();
+
+	if (xsks[0]->xsk)
+		xsk_socket__delete(xsks[0]->xsk);
+
+	if (xsks[0]->umem) {
+		struct xsk_umem *umem = xsks[0]->umem->umem;
+
+		(void)xsk_umem__delete(umem);
+	}
+
 	exit(EXIT_FAILURE);
 }
 
@@ -312,10 +303,6 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem)
 	if (ret)
 		exit_with_error(-ret);
 
-	ret = bpf_get_link_xdp_id(opt_ifindex, &prog_id, opt_xdp_flags);
-	if (ret)
-		exit_with_error(-ret);
-
 	return xsk;
 }
 
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 514ab3fb06f4..e28bedb0b078 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -259,6 +259,8 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, void *umem_area, __u64 size,
 static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 {
 	static const int log_buf_size = 16 * 1024;
+	struct bpf_prog_info info = {};
+	__u32 info_len = sizeof(info);
 	char log_buf[log_buf_size];
 	int err, prog_fd;
 
@@ -321,6 +323,14 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 		return err;
 	}
 
+	err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
+	if (err) {
+		pr_warning("can't get prog info - %s\n", strerror(errno));
+		close(prog_fd);
+		return err;
+	}
+	xsk->config.prog_id = info.id;
+
 	xsk->prog_fd = prog_fd;
 	return 0;
 }
@@ -483,6 +493,25 @@ static int xsk_set_bpf_maps(struct xsk_socket *xsk)
 	return err;
 }
 
+static void xsk_remove_xdp_prog(struct xsk_socket *xsk)
+{
+	__u32 prog_id = xsk->config.prog_id;
+	__u32 curr_prog_id = 0;
+	int err;
+
+	err = bpf_get_link_xdp_id(xsk->ifindex, &curr_prog_id,
+				  xsk->config.xdp_flags);
+	if (err)
+		return;
+
+	if (prog_id == curr_prog_id)
+		bpf_set_link_xdp_fd(xsk->ifindex, -1, xsk->config.xdp_flags);
+	else if (!curr_prog_id)
+		pr_warning("couldn't find a prog id on a given interface\n");
+	else
+		pr_warning("program on interface changed, not removing\n");
+}
+
 static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
 {
 	__u32 prog_id = 0;
@@ -506,6 +535,7 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
 		err = xsk_lookup_bpf_maps(xsk);
 		if (err)
 			goto out_load;
+		xsk->config.prog_id = prog_id;
 	}
 
 	err = xsk_set_bpf_maps(xsk);
@@ -744,6 +774,8 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 
 	}
 
+	xsk_remove_xdp_prog(xsk);
+
 	xsk->umem->refcount--;
 	/* Do not close an fd that also has an associated umem connected
 	 * to it.
diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 82ea71a0f3ec..e1b23e9432c9 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -186,6 +186,7 @@ struct xsk_socket_config {
 	__u32 tx_size;
 	__u32 libbpf_flags;
 	__u32 xdp_flags;
+	__u32 prog_id;
 	__u16 bind_flags;
 };
 
-- 
2.16.1

