Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE0DADE2B
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 19:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391445AbfIIRq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 13:46:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729123AbfIIRq3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 13:46:29 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 05A528BA02
        for <netdev@vger.kernel.org>; Mon,  9 Sep 2019 17:46:29 +0000 (UTC)
Received: by mail-ed1-f71.google.com with SMTP id c2so8591080edy.18
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 10:46:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F6aLxg8zxj2D9aBgx4Rb9m3lXULmbJDMagDZnexDIe0=;
        b=q//wWk2hRgOQub2OGnDTliNCsYhE+YujjEl4/8GCHFjZhkLve0Z35IE0ci9QAcJl6e
         gg36e8iJxgN7NLA0J24IHpLO7j/61kTdV8WWbjAWZ8EaH4kv57MvTpb8lzaZ5ejdYHaF
         o07Xn8hUoj6UCz6mW20wsMQhL+Y6LrVFW26bao7frltjV75k985EqCBE0f6h+Xw8638X
         QpY3DW64TupTQK2IyDJnf+RApsAPh9nikCUvsOWr+6ym5Rx7HEjv7Pj55Xz9FQDy0Ej2
         fTOEHRWwhBN5Lhzz+3mGDp6KxNn6gnZboU4XXojKo6AL+DjeCyRWzNnX3wDUtVEpBDiG
         Ac6w==
X-Gm-Message-State: APjAAAUbt4XhPJ96a8JBi8RfB93o6f7gR+FT4YbGbY4QwT8W1RiPS805
        FmDesyO1ZbQZtix7mmD43SSBjeZn5nzywEXbm4L7wB5EA1547JoT3RT+KQtZRMfgZU9MtlZ6RPb
        kvIt5RzhEx2HC2uqE
X-Received: by 2002:aa7:da90:: with SMTP id q16mr18813245eds.123.1568051187735;
        Mon, 09 Sep 2019 10:46:27 -0700 (PDT)
X-Google-Smtp-Source: APXvYqySc6dNFB0H2ePCrnBgWtDGSlyRlvEZ/IAx4gl35LDbPPbkeBhpM3gkYDStptCFSMtjNTBeEQ==
X-Received: by 2002:aa7:da90:: with SMTP id q16mr18813234eds.123.1568051187581;
        Mon, 09 Sep 2019 10:46:27 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id j10sm3098083ede.59.2019.09.09.10.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 10:46:26 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 90C2D1804C5; Mon,  9 Sep 2019 18:46:25 +0100 (WEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH] libbpf: Don't error out if getsockopt() fails for XDP_OPTIONS
Date:   Mon,  9 Sep 2019 18:46:19 +0100
Message-Id: <20190909174619.1735-1-toke@redhat.com>
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
there really is no need to error out if the getsockopt() call fails.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/xsk.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 680e63066cf3..598e487d9ce8 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -603,12 +603,8 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 
 	optlen = sizeof(opts);
 	err = getsockopt(xsk->fd, SOL_XDP, XDP_OPTIONS, &opts, &optlen);
-	if (err) {
-		err = -errno;
-		goto out_mmap_tx;
-	}
-
-	xsk->zc = opts.flags & XDP_OPTIONS_ZEROCOPY;
+	if (!err)
+		xsk->zc = opts.flags & XDP_OPTIONS_ZEROCOPY;
 
 	if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
 		err = xsk_setup_xdp_prog(xsk);
-- 
2.23.0

