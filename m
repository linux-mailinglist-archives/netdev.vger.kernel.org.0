Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBAE1F7171
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 02:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgFLAgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 20:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgFLAgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 20:36:49 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C815C03E96F;
        Thu, 11 Jun 2020 17:36:49 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id c12so5927705qtq.11;
        Thu, 11 Jun 2020 17:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=boR49jpVVRV/Q0WW/lSHnRqxWQvt+zi1RK7D2cfa/KQ=;
        b=rlAdwRm9hTb9aJanRInl8J1ga3yBiPstojKvPwkWPLmWuhIfnagqRf2036p2pa7Q8A
         RWu+NMUefznT+bPIVBlAfmv7d5vyOOipVD8HsRVHKtu06OL3V2c11fgP/8QE4emjSNtD
         33wi+hHa5G97wharcnrXbgMpWMylPcxvZYMHce+FHT6kEEn98NFDhOfnnwfux1qBHw3H
         /gfdxPgeGbhjpmsyIK/k/5zOFWMtScvvhasE5yPPAdtTWMvY8sii62idNBcAM3Gl1Zss
         +km/niDjnK5rAm8UvK6mCLrvTajNjdne/kuTXkXmmxlpvSQB9DNjrw7CeTeljT/V0Xaw
         cfiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=boR49jpVVRV/Q0WW/lSHnRqxWQvt+zi1RK7D2cfa/KQ=;
        b=DbAIuxPnZPywXMrpvgd1mxIa6i62Z0S25q8GPxcOmvVht9ATE6CsEI3/Grh6ENWTEm
         T1LD54yHKoDxWkOuyj64zQAIS0BXWJwttng+RuG2WgFarP2Dbrl/v4paDlfyni0hBbbW
         KqKRjxntJiXvbtGRYdv+BOswOGXfLue0Q4YxnlCt3lLXtpO4FoNJfZ8lzLu0shn74ulM
         ypZ28hVQQA+kHvviyjyyzRmf7MYE0CtOcLHtzpWK7w7jZW1qj8lOADzzudet+7glmjOZ
         R2n1WIrWU0hD+EZP8Y8kWq5a2TePfbqETq5uAXNO5Qj8aUgz92SEEf7iCD8Zr+gajRum
         2gPg==
X-Gm-Message-State: AOAM531NL+KxMHB3bdPi2zQRRe7Jocvax45yuj4pnuODSuz2Ck6SrVvl
        L/I2CtffeoQnZs9L4T0rm8s=
X-Google-Smtp-Source: ABdhPJyMNFemg5AAjTj1xQ2S4u9yW3ZUeOWoSPep6xN2RyxhGudxiyuxJn96SJvdohjSw9lew8hQ8A==
X-Received: by 2002:ac8:1742:: with SMTP id u2mr641083qtk.341.1591922208515;
        Thu, 11 Jun 2020 17:36:48 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:f00a:33d2:6ec2:475c])
        by smtp.googlemail.com with ESMTPSA id m126sm3432996qke.99.2020.06.11.17.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 17:36:48 -0700 (PDT)
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
Date:   Thu, 11 Jun 2020 20:36:40 -0400
Message-Id: <20200612003640.16248-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200611150221.15665-1-gaurav1086@gmail.com>
References: <20200611150221.15665-1-gaurav1086@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace malloc/memset with calloc

Fixes: 0fca931a6f21 ("samples/bpf: program demonstrating access to xdp_rxq_info")
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

