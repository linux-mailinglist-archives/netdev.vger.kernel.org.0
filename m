Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952E621B21D
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 11:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgGJJUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 05:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbgGJJUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 05:20:46 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6128C08C5CE;
        Fri, 10 Jul 2020 02:20:46 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id gc15so4344618pjb.0;
        Fri, 10 Jul 2020 02:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=k3Fg5uwWi3YIL1ND93G+AfS7yVUtKWD1/rSB1uSDlrw=;
        b=V2AkEhpMUH+KvSbxIjWFzekdSoByVCjiHrqM6j0Af5aT1HNGdfs/S13m1HgEk8L8uH
         /N+ZRBJbte83Mbv+EqjVgM/73jc2jrMwIV8u//7tMQkcsk7L9YOWqF9En11idEEYHNUo
         CoFyial+U9c+L8f3mh2CK0T76qzCiwTTrSwOqeJdmzbdvMlHPpCISev+77I/QmPj/KLk
         vfMLTuVDyLw+HrB5h9VhB3i3+k7CHItB+1q4s9QvbMAma+BU/qBRnXzpfolepnmrB7tY
         SLvZJGLljmjxie1ca/3PxOPcHsiBnIFdfWkfrd7fnmW3/SkvKfmwJcWpZrj77T5+5aAq
         I7mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=k3Fg5uwWi3YIL1ND93G+AfS7yVUtKWD1/rSB1uSDlrw=;
        b=PyDxvRIQITpInFu2a5HprzWpFB+lbuN4KFYZIGDUD/SepqwL9EYDHWCi6I46uEJ1n1
         YqPG7wvrP8eDW1sJDV8K6ys+0f9mtX4oBDi5T5/+RJj94cdzlIZPojukGeo/XMyBKYqe
         Y9CEPuNN5abo9OrGxxHB7Gc9IaN2ngj86V8a2j07SRda8Mzy3bkgxQqn8snKCzxdWo+H
         Cu9ybHeWUlvqeI3Ti52+FGNGXRuc0iF+eMqt+Nk1VqBHWKRRWpZT/24SdVf7R5Ai/7eT
         pDphIztqAbBljebQO72U+73MIVHAvcqUkAxi8UEXnSwv0JM/A9eT6hP6nc+yYVuZQs8f
         acxA==
X-Gm-Message-State: AOAM5319VXECIGJxIupDPTiWebWkLCmCI98wDS0cP7u1Z2pCq0kHE/DN
        a3xPSKxeHMkj/3uYUNAOLniDDqgygsxHzsj8
X-Google-Smtp-Source: ABdhPJx0z3oN+10frWzUngzJ8rZr4E4WNMuJsBdU4vBk4Qe3hRr1WE3NechrtXApQrlpC1p3cSZsiQ==
X-Received: by 2002:a17:90a:2a4d:: with SMTP id d13mr4505138pjg.195.1594372846367;
        Fri, 10 Jul 2020 02:20:46 -0700 (PDT)
Received: from ubuntu-18.04-x8664 ([119.28.181.184])
        by smtp.gmail.com with ESMTPSA id i23sm5580924pfq.206.2020.07.10.02.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 02:20:46 -0700 (PDT)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, ethercflow@gmail.com
Subject: [PATCH] bpf: fix fds_example SIGSEGV error
Date:   Fri, 10 Jul 2020 05:20:35 -0400
Message-Id: <20200710092035.28919-1-ethercflow@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The `BPF_LOG_BUF_SIZE`'s value is `UINT32_MAX >> 8`, so define an array
with it on stack caused an overflow.

Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
---
 samples/bpf/fds_example.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/fds_example.c b/samples/bpf/fds_example.c
index d5992f787232..59f45fef5110 100644
--- a/samples/bpf/fds_example.c
+++ b/samples/bpf/fds_example.c
@@ -30,6 +30,8 @@
 #define BPF_M_MAP	1
 #define BPF_M_PROG	2
 
+char bpf_log_buf[BPF_LOG_BUF_SIZE];
+
 static void usage(void)
 {
 	printf("Usage: fds_example [...]\n");
@@ -57,7 +59,6 @@ static int bpf_prog_create(const char *object)
 		BPF_EXIT_INSN(),
 	};
 	size_t insns_cnt = sizeof(insns) / sizeof(struct bpf_insn);
-	char bpf_log_buf[BPF_LOG_BUF_SIZE];
 	struct bpf_object *obj;
 	int prog_fd;
 
-- 
2.17.1

