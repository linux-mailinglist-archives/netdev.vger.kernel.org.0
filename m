Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4CA01F8A50
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 21:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgFNTEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 15:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbgFNTEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 15:04:43 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F6EC08C5C2;
        Sun, 14 Jun 2020 12:04:42 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id g62so10990538qtd.5;
        Sun, 14 Jun 2020 12:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=ZMcCnhw+cb0GssjRbz2Uvr23jd5CfAqDE459LKY1/1g=;
        b=O4f0no9gkSjNwQeZuPS7lBS877ehntOkn4Y5ujlumfsbRYOyrEHldqHzVigXDiSSe5
         HhxT6u2hr+AuZ0+KYXJ9gZg50GjPXIXjFPRu5PrrdzoE0TWBpM7BTmYhrol1vSEtyBB7
         GXIiydsljflA1rCzKioD+ROrAaDY1N3lFj84zaVkfA+qS0H/qNUGeUaJTM/PCa6NMipj
         Af9s+hXy1V0BGUk5UEUONvLJnC2fhKJl63LFthHX+yBHq9f6bWAY44vjiljDVLEl7fS2
         mLnx0mKPuHa45xSY+Z/GBeTouuADZUoda6QuaueFNpJngGh9rtiqErlgbom3mCeNIAsR
         XTrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=ZMcCnhw+cb0GssjRbz2Uvr23jd5CfAqDE459LKY1/1g=;
        b=q1bDEQTCznZFpHNf5NFy3ybmlsL+dNOqHBci7T/XnXInTR0tSHTEytc1q0CP2ZMfkA
         wVhsn19jV0jxAnpiEPel0JWgxLPkgrCD41UZmNbT/+25ewSg9ZjJc1JEMJlOxJfn2rrh
         08b6lqd9ui7n0jcTBksshgNjV5rpQTPoAgsut/gqz1+R5fTPMsTrrmOvTvn7EVTglnOz
         dLnz2ZUkshx1QAjpUrsTMkm00i3dHCxs4kiM/oYEQ4Kf/VfUrR1GvSpkcExbVl0vP18O
         9LMqHFslauDWUmE5SQeljYLA0tQDFLE1t90lD/qYk/jIFOOw2xrPw3dleChNJEmWOibw
         wX/Q==
X-Gm-Message-State: AOAM532S0fOLUSOO2lGaeYxrkZvsBt2LgpQ92W31igdMU8+n0Vp03isv
        z/jGT/uQc/kLsld8LRGomRQ=
X-Google-Smtp-Source: ABdhPJzsFCo/ACyKhmF/+97h8AR6FsA+85GRPNjWIzqOnbnbnw/hF3IHAduxaMCZIKMEAVwtcT+aQQ==
X-Received: by 2002:ac8:3551:: with SMTP id z17mr12429782qtb.139.1592161481533;
        Sun, 14 Jun 2020 12:04:41 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:b556:165b:f409:9052])
        by smtp.googlemail.com with ESMTPSA id i40sm10953911qte.67.2020.06.14.12.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 12:04:40 -0700 (PDT)
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
Subject: [PATCH] [bpf] xdp_redirect_cpu_user: Fix null pointer dereference
Date:   Sun, 14 Jun 2020 15:04:33 -0400
Message-Id: <20200614190434.31321-1-gaurav1086@gmail.com>
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
 samples/bpf/xdp_redirect_cpu_user.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index f3468168982e..2ae7a9a1d950 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -207,11 +207,8 @@ static struct datarec *alloc_record_per_cpu(void)
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
@@ -222,11 +219,9 @@ static struct datarec *alloc_record_per_cpu(void)
 static struct stats_record *alloc_stats_record(void)
 {
 	struct stats_record *rec;
-	int i, size;
+	int i;
 
-	size = sizeof(*rec) + n_cpus * sizeof(struct record);
-	rec = malloc(size);
-	memset(rec, 0, size);
+	rec = calloc(n_cpus + 1, sizeof(struct record));
 	if (!rec) {
 		fprintf(stderr, "Mem alloc error\n");
 		exit(EXIT_FAIL_MEM);
-- 
2.17.1

