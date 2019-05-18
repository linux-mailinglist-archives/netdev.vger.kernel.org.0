Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA730220FD
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 02:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbfERArb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 20:47:31 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43804 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfERArb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 20:47:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id r4so8756606wro.10
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 17:47:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vSly531sOw2rwvVk7zttVUIbMVurcuy0BpNrHVMScoY=;
        b=o01FPKBd8zmvG+QFoz5jTCUmS4QWBL7N35VpbSwocDGLz0lVhRnrAjFG8HMPmlRmfk
         uTr+S7DYjArH0mjSuZ+WXhGC9RYEpiuBRxhnY7SsPXARdNWJAf+eZWrnQjqfhpOvcXln
         reDFCsLiXQylhh/6Ti1M4cW3qp0X9xfqq3g2FZR+unGviMgQU15hdF1o7yWVlP9337hv
         pZMaYhV0PMYbaS8F1dlur7h+aFbKX7puEvIsPCGvP6t/tttQa/K9iCU8U3i6tywGz1Bt
         oM2J+7xXwn6irR9y4QSqSoRDX1h1OlgJHNE7tCWNrO35GJd4FZa0TawXhYsTTRbtT1z/
         kkdQ==
X-Gm-Message-State: APjAAAUxD/ud3km577hAczx4v4+vwW6WzvN44opj9rDHDkyNhbx67KWj
        45895bKaHFoYLIjHBWDx9RR958MhVGE=
X-Google-Smtp-Source: APXvYqxlCzuyTJ2++aLbnoALR+KdYHMVcvZEv227fTudzSLzBYhEqdsJUOOkmP6PGoIRErJdBel76Q==
X-Received: by 2002:adf:e908:: with SMTP id f8mr5263821wrm.124.1558140449852;
        Fri, 17 May 2019 17:47:29 -0700 (PDT)
Received: from raver.teknoraver.net (net-47-53-225-211.cust.vodafonedsl.it. [47.53.225.211])
        by smtp.gmail.com with ESMTPSA id j82sm14386099wmj.40.2019.05.17.17.47.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 May 2019 17:47:29 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     xdp-newbies@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5/5] samples/bpf: fix hbm build error
Date:   Sat, 18 May 2019 02:46:39 +0200
Message-Id: <20190518004639.20648-5-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190518004639.20648-1-mcroce@redhat.com>
References: <20190518004639.20648-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following build error by declaring bpf_spin_lock in hbm.c.
Including the UAPI header generates tons of redefined symbol errors,
and including it in hbm.h breaks hbm_out_kern.c.

make -C samples/bpf/../../tools/lib/bpf/ RM='rm -rf' LDFLAGS= srctree=samples/bpf/../../ O=
  HOSTCC  samples/bpf/hbm.o
In file included from samples/bpf/hbm.c:49:
samples/bpf/hbm.h:12:23: error: field ‘lock’ has incomplete type
   12 |  struct bpf_spin_lock lock;
      |                       ^~~~
make[2]: *** [scripts/Makefile.host:109: samples/bpf/hbm.o] Error 1
make[1]: *** [Makefile:1763: samples/bpf/] Error 2

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 samples/bpf/hbm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
index a79828ab273f..ca8e567b63c3 100644
--- a/samples/bpf/hbm.c
+++ b/samples/bpf/hbm.c
@@ -40,17 +40,22 @@
 #include <fcntl.h>
 #include <linux/unistd.h>
 
-#include <linux/bpf.h>
 #include <bpf/bpf.h>
+#include <linux/bpf.h>
 
 #include "bpf_load.h"
 #include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
-#include "hbm.h"
 #include "bpf_util.h"
 #include "bpf/bpf.h"
 #include "bpf/libbpf.h"
 
+struct bpf_spin_lock {
+	__u32	val;
+};
+
+#include "hbm.h"
+
 bool outFlag = true;
 int minRate = 1000;		/* cgroup rate limit in Mbps */
 int rate = 1000;		/* can grow if rate conserving is enabled */
-- 
2.21.0

