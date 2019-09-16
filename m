Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25DD1B3AE8
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 15:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732944AbfIPNEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 09:04:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727996AbfIPNEw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 09:04:52 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5B5CE796ED
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 13:04:52 +0000 (UTC)
Received: by mail-ed1-f71.google.com with SMTP id d7so3098127edp.23
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 06:04:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aipl9G3Zh5MTOwmbvbDk71GpN3zyj23LWdpB0ymIyJw=;
        b=gs/FKDA4fKcgOoGKe0w+KrQNSeHuAm16PKvST2BiO8+XfQaq3JZoXx8VIYn1JkJAXY
         XQhnAOvpx6XN9vvhMsK6dCYBkOD7+rUcBSnD6yTp63RcQMSCpvImgt26qsa8aXojlYrS
         7scDB1Z/l6LeenLwW26EFyzzIyU2KQdoAlItWuNZdqTBzbpeABo08zh5h7EGPVpSW4++
         iZ3SHoRy74eqj2Wu5JIAf+f4E7hJZDSI+7EkVVR5j8Enug4iHntn2wqCHVzlYRKJM20K
         +peFg7NPoNt4jfSCVnF1QrwdP/yfuEshvD8XN0xOUXNjnRuFFL36nZvNFlZ4BRfP5qfI
         sByA==
X-Gm-Message-State: APjAAAXkv3rUouFSe0PeG5evDMgMkkHVwodY4g3DX0zbY/UckJFuHejQ
        Fi5mQg/VyQpj4WGsdOmibAYuLUuMxPsxoU8TUedpDnQUkIGoUVEq0ChUM+FO9HX06rFN7Op3/63
        ezo+QHrOa6I1Nqf79
X-Received: by 2002:a50:acc1:: with SMTP id x59mr29757257edc.278.1568639091101;
        Mon, 16 Sep 2019 06:04:51 -0700 (PDT)
X-Google-Smtp-Source: APXvYqynHBnBQy/W2eNq2mEjhu4HMVJOpTbeWZxo80yXmPXROS35KD0ol0Lq3n++XHYZ5ChrSvXE7g==
X-Received: by 2002:a50:acc1:: with SMTP id x59mr29757240edc.278.1568639090941;
        Mon, 16 Sep 2019 06:04:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id j6sm119976ejv.36.2019.09.16.06.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 06:04:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4ED4418063F; Mon, 16 Sep 2019 14:33:50 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf v2] libbpf: Remove getsockopt() check for XDP_OPTIONS
Date:   Mon, 16 Sep 2019 14:33:42 +0200
Message-Id: <20190916123342.49928-1-toke@redhat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The xsk_socket__create() function fails and returns an error if it cannot
get the XDP_OPTIONS through getsockopt(). However, support for XDP_OPTIONS
was not added until kernel 5.3, so this means that creating XSK sockets
always fails on older kernels.

Since the option is just used to set the zero-copy flag in the xsk struct,
and that flag is not really used for anything yet, just remove the
getsockopt() call until a proper use for it is introduced.

Suggested-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
v2:
  - Remove the call entirely.
  
 tools/lib/bpf/xsk.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 680e63066cf3..14aea315c914 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -65,7 +65,6 @@ struct xsk_socket {
 	int xsks_map_fd;
 	__u32 queue_id;
 	char ifname[IFNAMSIZ];
-	bool zc;
 };
 
 struct xsk_nl_info {
@@ -481,7 +480,6 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	void *rx_map = NULL, *tx_map = NULL;
 	struct sockaddr_xdp sxdp = {};
 	struct xdp_mmap_offsets off;
-	struct xdp_options opts;
 	struct xsk_socket *xsk;
 	socklen_t optlen;
 	int err;
@@ -601,15 +599,6 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 
 	xsk->prog_fd = -1;
 
-	optlen = sizeof(opts);
-	err = getsockopt(xsk->fd, SOL_XDP, XDP_OPTIONS, &opts, &optlen);
-	if (err) {
-		err = -errno;
-		goto out_mmap_tx;
-	}
-
-	xsk->zc = opts.flags & XDP_OPTIONS_ZEROCOPY;
-
 	if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
 		err = xsk_setup_xdp_prog(xsk);
 		if (err)
-- 
2.23.0

