Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34ECE1F6A85
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 17:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgFKPCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 11:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728273AbgFKPCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 11:02:37 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC6EC08C5C1;
        Thu, 11 Jun 2020 08:02:37 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id er17so2755575qvb.8;
        Thu, 11 Jun 2020 08:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=r0hNAlb8gwk+2s8vLxqGkBolOrtvmVp5BagPwVX1Ajk=;
        b=ZEnqBpV6x9tbdnOXrWgmoMoqpMcm7FzfGEskyPDedCcKDSQrsF1vEAxEx9ndKxbWHn
         jS17XPJiB9YI1TnrV5zGnhtH5ObaNDQ3I4vVq8QLarWla8zcjHw4zwGELtxndGQOwjH0
         SyYu47PN7bk5ooMJ3JhCYhDB5F8UESAwIAuQbkTRpu6xdomvxWEwTxSqNz2ARGfIfk00
         7nMgwDnjIrThaEtNn/LPqSkJVIXO9Vx0qpjKRBnYmNqQSBNCc/+5vgHicWxPXQu6qh/s
         5UdV1sorpqq+5yC5X116GTcMYS2IrTvZC1JKINbuGVo9vB+BW/lmgdlTi4aVQZUcZ1Xf
         6BTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=r0hNAlb8gwk+2s8vLxqGkBolOrtvmVp5BagPwVX1Ajk=;
        b=QXQ0Y5/4O+C1igi4p0hkKxFPyn9uH44BL0vh9NuHwI8RtIybeMoGOQP9nyQE0waXC1
         gB5Ud2m6NXx/wwiSBqxYsE6GYMiiAaxKiUDFW6PXvxfKic2/H0gjIjr6fv7pVBLbgZjz
         HRC6uMZSmx2EiFO+toWdSODimC7xCp7IXOp/zTdN5X4vL5gBqp8j0PoOFBPYY1lljCj2
         Bw2PSJIgvYWUtLlVHIbuuq457H5cRm/Qs7vA64D2VTLuXNfJacWxvOJNGu6ciZU9FC7u
         brGK/FSvXq0Eo9F6WrWDazDyEkmPRdr3h30W5pKSsFnac8sSC/StNKaxusvJwaib+IaQ
         zBvA==
X-Gm-Message-State: AOAM530u01gU/T8u/S8df7zqWFPKk8zwLoqZkMCIBBMZnu3RwGzWMice
        mMV72hMwo3UEHAChQd2JTrg=
X-Google-Smtp-Source: ABdhPJxOTBEvquTX9k2vohWCjqbVEuu/GZqdZH7clWhzbcWr27EmLQ//jvq/zFCkjHzAGjdmWyUa1Q==
X-Received: by 2002:ad4:4e14:: with SMTP id dl20mr8503813qvb.101.1591887756824;
        Thu, 11 Jun 2020 08:02:36 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:f00a:33d2:6ec2:475c])
        by smtp.googlemail.com with ESMTPSA id 78sm2230157qkg.65.2020.06.11.08.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 08:02:35 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev@vger.kernel.org (open list:XDP (eXpress Data Path)),
        bpf@vger.kernel.org (open list:XDP (eXpress Data Path)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] xdp_rxq_info_user: Replace malloc/memset w/calloc
Date:   Thu, 11 Jun 2020 11:02:21 -0400
Message-Id: <20200611150221.15665-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace malloc/memset with calloc

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 samples/bpf/xdp_rxq_info_user.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
index 4fe47502ebed..caa4e7ffcfc7 100644
--- a/samples/bpf/xdp_rxq_info_user.c
+++ b/samples/bpf/xdp_rxq_info_user.c
@@ -198,11 +198,8 @@ static struct datarec *alloc_record_per_cpu(void)
 {
 	unsigned int nr_cpus = bpf_num_possible_cpus();
 	struct datarec *array;
-	size_t size;
 
-	size = sizeof(struct datarec) * nr_cpus;
-	array = malloc(size);
-	memset(array, 0, size);
+	array = calloc(nr_cpus, sizeof(struct datarec));
 	if (!array) {
 		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
 		exit(EXIT_FAIL_MEM);
@@ -214,11 +211,8 @@ static struct record *alloc_record_per_rxq(void)
 {
 	unsigned int nr_rxqs = bpf_map__def(rx_queue_index_map)->max_entries;
 	struct record *array;
-	size_t size;
 
-	size = sizeof(struct record) * nr_rxqs;
-	array = malloc(size);
-	memset(array, 0, size);
+	array = calloc(nr_rxqs, sizeof(struct record));
 	if (!array) {
 		fprintf(stderr, "Mem alloc error (nr_rxqs:%u)\n", nr_rxqs);
 		exit(EXIT_FAIL_MEM);
@@ -232,8 +226,7 @@ static struct stats_record *alloc_stats_record(void)
 	struct stats_record *rec;
 	int i;
 
-	rec = malloc(sizeof(*rec));
-	memset(rec, 0, sizeof(*rec));
+	rec = calloc(1, sizeof(struct stats_record));
 	if (!rec) {
 		fprintf(stderr, "Mem alloc error\n");
 		exit(EXIT_FAIL_MEM);
-- 
2.17.1

