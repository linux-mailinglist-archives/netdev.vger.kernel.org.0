Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13D71F8A2D
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 20:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgFNSlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 14:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbgFNSlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 14:41:14 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAEEC08C5C2;
        Sun, 14 Jun 2020 11:41:13 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id w90so10962081qtd.8;
        Sun, 14 Jun 2020 11:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=gbKqT2VlDYF8btDBBV8p9eIC1+5x1Xv1FhkzFosEmBU=;
        b=RJAqddZpsXCGmQpjMNeF1S88f1P16hTpZ2+l46ov5INy9TIDmVHe7PetkJY87R4Fu4
         AF3R2azbrVDE1IPIgGHTFMEUSvNps1gCAnMbIaJtNDUEtiphriBeaJjAGTe12KJZ+Ak8
         X5i2eNiVxrl1Ltb8MZGKPG8MMYltxeg10fD0hxSOtP0ml8TOjlTqzaLyxe5wSCEZfRNL
         OzuVlCCVOCr/i8zIfYk3XBbkslH6OJ/iy60idJaY0JKahtzw51N1TceCL9kFGe/qHVdc
         CSIS+KQRVRJgnnXiIRZivvS1Hwo2/7SI3UkJx+z9V+B9SPvr2oNYKYcJh8TgaZ+sFfxy
         XPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=gbKqT2VlDYF8btDBBV8p9eIC1+5x1Xv1FhkzFosEmBU=;
        b=D5F+6CEFHThgE/grE46OdYfTfob3rAarUhnyLnbSjAW/2AlDmx/WbeRVJdJ5JSP89J
         +UrFyPXLiQ1wir7I+ApN4z8kFMRZmmHZML6/4r17qGViRQcoWG2aoVi45tctjxhryQ8f
         YWMMdIrxDr+gra1LHbZZla3XSjC8L9USIowtsOmc9fL4MixKTn4sm0yAa67vZbNsXBo5
         ah9BxPnZmPLtyYbvR8k4byYwEEMK89NFzS3jMQcVCaArIHYXZ+7VEHN4dOmVSzxKsBoP
         yCzOBUGWYo3ptyOkPMjPOsvwJCW9v8awAHCgbPNNLfssG/wT6SdQjRf1RBuxeaowvahx
         sfGg==
X-Gm-Message-State: AOAM533qBl8W0ctnEBw8LMjgY2QT/9ZWg9eKNiXUm0MGYvHRCKdVWWXT
        Huec2vyGivN0bTbdQHJG9P4=
X-Google-Smtp-Source: ABdhPJyJWjgaueHQFHNwYrQM6ovCIrix85cqkvPOlobJK8Krs+9ZNgUolsAiHTFNnLdNMGZrEROIUg==
X-Received: by 2002:ac8:6a11:: with SMTP id t17mr12892740qtr.272.1592160072669;
        Sun, 14 Jun 2020 11:41:12 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:b556:165b:f409:9052])
        by smtp.googlemail.com with ESMTPSA id v189sm9378572qkb.64.2020.06.14.11.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 11:41:12 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] [bpf] xdp_monitor_user: Fix null pointer dereference
Date:   Sun, 14 Jun 2020 14:41:02 -0400
Message-Id: <20200614184102.30992-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Memset() on the pointer right after malloc() can cause
a null pointer dereference if it failed to allocate memory.
Fix this by replacing malloc/memset with a single calloc().

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 samples/bpf/xdp_monitor_user.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/samples/bpf/xdp_monitor_user.c b/samples/bpf/xdp_monitor_user.c
index dd558cbb2309..ef53b93db573 100644
--- a/samples/bpf/xdp_monitor_user.c
+++ b/samples/bpf/xdp_monitor_user.c
@@ -509,11 +509,8 @@ static void *alloc_rec_per_cpu(int record_size)
 {
 	unsigned int nr_cpus = bpf_num_possible_cpus();
 	void *array;
-	size_t size;
 
-	size = record_size * nr_cpus;
-	array = malloc(size);
-	memset(array, 0, size);
+	array = calloc(nr_cpus, record_size);
 	if (!array) {
 		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
 		exit(EXIT_FAIL_MEM);
@@ -528,8 +525,7 @@ static struct stats_record *alloc_stats_record(void)
 	int i;
 
 	/* Alloc main stats_record structure */
-	rec = malloc(sizeof(*rec));
-	memset(rec, 0, sizeof(*rec));
+	rec = calloc(1, sizeof(*rec));
 	if (!rec) {
 		fprintf(stderr, "Mem alloc error\n");
 		exit(EXIT_FAIL_MEM);
-- 
2.17.1

