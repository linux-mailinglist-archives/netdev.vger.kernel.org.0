Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C83F92D
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 14:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbfD3MqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 08:46:16 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46437 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfD3MqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 08:46:15 -0400
Received: by mail-pf1-f193.google.com with SMTP id j11so6981119pff.13;
        Tue, 30 Apr 2019 05:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eo2JVJnXpqBrlVA8QoXySsjfBZZ1lKr09bIpEKOAp64=;
        b=cC3e3tgCP786t1Z2LBBwUqluSlSK+VK74cMX7/EYGxAqOeGREhMeV+c4JyLM2n4ZBo
         wUjnmjELjqCrYXHwxA4tapV7gV7yGlZV/PRRu1HXH5THZMOQ501rFUEkbmV6lveznWZ5
         7hfZ7KBoLLFD6XWGLPGt3fDeCPB5lEbT4QUlIhPBt0eYcO4yVlQcTy5RsVgyJD8WBgqo
         zi20fJ73U57uFqIvRm11uWh+i+76iOtf29lY7K8bpIr4WusCMWGhxEznyOLJvGDtJCDO
         +aqGaj65yf7bLdp4V4kF9fK8tQfIbalkcZsC0t6UlHDE1MkcgMrMRzcJ37Oy6NOLNDH1
         ge5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eo2JVJnXpqBrlVA8QoXySsjfBZZ1lKr09bIpEKOAp64=;
        b=A0ZWNSb9TGOK99wI5DaD6DJceyJXT8bVVTXCuN9B3Cn52HjScB4VUa7MnjaR4dU8hQ
         C6efIzf5HFQ3xuys8YEBu+E3MAkqUDWyjXNWFwwdtI7GdUkTgFkVNVpP3epfsLQJlgvv
         05U3z/Gq8rApKhRfv+VyEGC6OvKiofno5Xzo35fDPj0g8aAW/OTmHYe74W2TrLWhDynt
         hJPVnsjC7dTz8UvOEWZa8c3F7dL3dFu2r9fmCsETuqEqVtbBl0QC/o445WHIpgiQPHzm
         7yKKeYBRl2MHGdr0RR9EuBfaWOQagdc0WCNAiLBM9+WYim8oTqURcKyJv9Gs58cvxvRL
         8s0g==
X-Gm-Message-State: APjAAAXdL5+v5KN6M+0dmkmAasm5wsNt2OQm6C3NTozMNovgRl/uLeFG
        FFJdjfwOvqFhYQ71ilMg9E7qHN2H93qPCw==
X-Google-Smtp-Source: APXvYqxlBgjuh2EwY103OoCZcXu8WKHr/9jAQkr63596XXJ28SKq/EUaaOSrjsaRsPFjtiEJi43LRQ==
X-Received: by 2002:aa7:8190:: with SMTP id g16mr24340319pfi.92.1556628374911;
        Tue, 30 Apr 2019 05:46:14 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.41])
        by smtp.gmail.com with ESMTPSA id u5sm52334523pfa.169.2019.04.30.05.46.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 05:46:14 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, u9012063@gmail.com
Subject: [PATCH bpf 2/2] libbpf: proper XSKMAP cleanup
Date:   Tue, 30 Apr 2019 14:45:36 +0200
Message-Id: <20190430124536.7734-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190430124536.7734-1-bjorn.topel@gmail.com>
References: <20190430124536.7734-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The bpf_map_update_elem() function, when used on an XSKMAP, will fail
if not a valid AF_XDP socket is passed as value. Therefore, this is
function cannot be used to clear the XSKMAP. Instead, the
bpf_map_delete_elem() function should be used for that.

This patch also simplifies the code by breaking up
xsk_update_bpf_maps() into three smaller functions.

Reported-by: William Tu <u9012063@gmail.com>
Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/lib/bpf/xsk.c | 115 +++++++++++++++++++++++---------------------
 1 file changed, 60 insertions(+), 55 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index af5f310ecca1..c2e6da464504 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -386,21 +386,17 @@ static void xsk_delete_bpf_maps(struct xsk_socket *xsk)
 {
 	close(xsk->qidconf_map_fd);
 	close(xsk->xsks_map_fd);
+	xsk->qidconf_map_fd = -1;
+	xsk->xsks_map_fd = -1;
 }
 
-static int xsk_update_bpf_maps(struct xsk_socket *xsk, int qidconf_value,
-			       int xsks_value)
+static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
 {
-	bool qidconf_map_updated = false, xsks_map_updated = false;
+	__u32 i, *map_ids, num_maps, prog_len = sizeof(struct bpf_prog_info);
+	__u32 map_len = sizeof(struct bpf_map_info);
 	struct bpf_prog_info prog_info = {};
-	__u32 prog_len = sizeof(prog_info);
 	struct bpf_map_info map_info;
-	__u32 map_len = sizeof(map_info);
-	__u32 *map_ids;
-	int reset_value = 0;
-	__u32 num_maps;
-	unsigned int i;
-	int err;
+	int fd, err;
 
 	err = bpf_obj_get_info_by_fd(xsk->prog_fd, &prog_info, &prog_len);
 	if (err)
@@ -421,66 +417,71 @@ static int xsk_update_bpf_maps(struct xsk_socket *xsk, int qidconf_value,
 		goto out_map_ids;
 
 	for (i = 0; i < prog_info.nr_map_ids; i++) {
-		int fd;
+		if (xsk->qidconf_map_fd != -1 && xsk->xsks_map_fd != -1)
+			break;
 
 		fd = bpf_map_get_fd_by_id(map_ids[i]);
-		if (fd < 0) {
-			err = -errno;
-			goto out_maps;
-		}
+		if (fd < 0)
+			continue;
 
 		err = bpf_obj_get_info_by_fd(fd, &map_info, &map_len);
-		if (err)
-			goto out_maps;
+		if (err) {
+			close(fd);
+			continue;
+		}
 
 		if (!strcmp(map_info.name, "qidconf_map")) {
-			err = bpf_map_update_elem(fd, &xsk->queue_id,
-						  &qidconf_value, 0);
-			if (err)
-				goto out_maps;
-			qidconf_map_updated = true;
 			xsk->qidconf_map_fd = fd;
-		} else if (!strcmp(map_info.name, "xsks_map")) {
-			err = bpf_map_update_elem(fd, &xsk->queue_id,
-						  &xsks_value, 0);
-			if (err)
-				goto out_maps;
-			xsks_map_updated = true;
+			continue;
+		}
+
+		if (!strcmp(map_info.name, "xsks_map")) {
 			xsk->xsks_map_fd = fd;
+			continue;
 		}
 
-		if (qidconf_map_updated && xsks_map_updated)
-			break;
+		close(fd);
 	}
 
-	if (!(qidconf_map_updated && xsks_map_updated)) {
+	err = 0;
+	if (xsk->qidconf_map_fd < 0 || xsk->xsks_map_fd < 0) {
 		err = -ENOENT;
-		goto out_maps;
+		xsk_delete_bpf_maps(xsk);
 	}
 
-	err = 0;
-	goto out_success;
-
-out_maps:
-	if (qidconf_map_updated)
-		(void)bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id,
-					  &reset_value, 0);
-	if (xsks_map_updated)
-		(void)bpf_map_update_elem(xsk->xsks_map_fd, &xsk->queue_id,
-					  &reset_value, 0);
-out_success:
-	if (qidconf_map_updated)
-		close(xsk->qidconf_map_fd);
-	if (xsks_map_updated)
-		close(xsk->xsks_map_fd);
 out_map_ids:
 	free(map_ids);
 	return err;
 }
 
+static void xsk_clear_bpf_maps(struct xsk_socket *xsk)
+{
+	int qid = false;
+
+	(void)bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qid, 0);
+	(void)bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
+}
+
+static int xsk_set_bpf_maps(struct xsk_socket *xsk)
+{
+	int qid = true, fd = xsk->fd, err;
+
+	err = bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qid, 0);
+	if (err)
+		goto out;
+
+	err = bpf_map_update_elem(xsk->xsks_map_fd, &xsk->queue_id, &fd, 0);
+	if (err)
+		goto out;
+
+	return 0;
+out:
+	xsk_clear_bpf_maps(xsk);
+	return err;
+}
+
 static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
 {
-	bool prog_attached = false;
 	__u32 prog_id = 0;
 	int err;
 
@@ -490,7 +491,6 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
 		return err;
 
 	if (!prog_id) {
-		prog_attached = true;
 		err = xsk_create_bpf_maps(xsk);
 		if (err)
 			return err;
@@ -500,20 +500,21 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
 			goto out_maps;
 	} else {
 		xsk->prog_fd = bpf_prog_get_fd_by_id(prog_id);
+		err = xsk_lookup_bpf_maps(xsk);
+		if (err)
+			goto out_load;
 	}
 
-	err = xsk_update_bpf_maps(xsk, true, xsk->fd);
+	err = xsk_set_bpf_maps(xsk);
 	if (err)
 		goto out_load;
 
 	return 0;
 
 out_load:
-	if (prog_attached)
-		close(xsk->prog_fd);
+	close(xsk->prog_fd);
 out_maps:
-	if (prog_attached)
-		xsk_delete_bpf_maps(xsk);
+	xsk_delete_bpf_maps(xsk);
 	return err;
 }
 
@@ -641,6 +642,9 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 		goto out_mmap_tx;
 	}
 
+	xsk->qidconf_map_fd = -1;
+	xsk->xsks_map_fd = -1;
+
 	if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
 		err = xsk_setup_xdp_prog(xsk);
 		if (err)
@@ -705,7 +709,8 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 	if (!xsk)
 		return;
 
-	(void)xsk_update_bpf_maps(xsk, 0, 0);
+	xsk_clear_bpf_maps(xsk);
+	xsk_delete_bpf_maps(xsk);
 
 	optlen = sizeof(off);
 	err = getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
-- 
2.20.1

