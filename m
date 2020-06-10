Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8A61F4BA8
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 05:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgFJDB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 23:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgFJDB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 23:01:58 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D3CC05BD1E;
        Tue,  9 Jun 2020 20:01:58 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id i16so671320qtr.7;
        Tue, 09 Jun 2020 20:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=9BDkz46lWvTDN3YxKGr7Bl8qQegPZ/wDf2X35bbrkxU=;
        b=oVKNo/tfvz7bFmNdvIMwTizX/CsT8Gxj6piNvPjqzCF7cJCI3wQOS7Hs/HkFy/pMjn
         mQVorA9tU4t/ylaGAJpQZFrmG+Q+MopbBOyPQ0PzFOhqkJ/DH/0Yafq3HOw7AndkRtNZ
         SfusXBFGo2lTUTDTOO8g1n9dT/ZxKcHOMg+Uc+6d5b6JD+s3yMj2RikNoEKXSom/kaD/
         Qp4dSrLdIfVKC2/Mx40xuzWkOZ1W1/FGfSLmisSFwlayob8MtzuMRjhlV1mLu4TmZjr9
         Z3VtByXkO8hKPzHHwdmQuvLURHxXGA0eWs0zvL+xiQMEmvDU7kkwDPnoFuZ9fOxmMtA1
         iUwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=9BDkz46lWvTDN3YxKGr7Bl8qQegPZ/wDf2X35bbrkxU=;
        b=Nt7LpsCpQkA0L8sWbzHXcQc20oSvmrFU0gx4DRQrcsgRMzJGjy2AV6dleGL9fyRxoh
         dLPtyU41SjFIRuQejvLp1sE0zsmoyN9v+O/8EvaB0hNgTzZ7InxSLuybnvND5G4YJFDx
         QrbT8ZCdhBB76Fw8CuawupSGj6tcAyvLGh3QQzJTdvbC9xLg2DLBrA1Cakmu0vd/jgA+
         VZU2fZYE1MmFrvErymTIdJwG+OBry2wrdWoam5fT1iQIccvbwDYpTekwF2vmGws1/qqg
         2kDnwuNEV4AjhTbDrq3RVPr/DIEXqlvhnq7dqGhCc/MBF62yIFo31b7WEw9TfvNbLXGl
         mrDQ==
X-Gm-Message-State: AOAM530VO8zevcedf7YlTk1+UaFH1Raq/7u5CbN5Li/kk7YlDePbn6UY
        nmhqKDIKp5GOFSo5VqARnr0=
X-Google-Smtp-Source: ABdhPJwO45Dbs22xOgau2tZLeyyht/La6qYJg4UW4TydiwZ68nZvNhFSDc2qDJGiLzO3Va+Sh21zaw==
X-Received: by 2002:ac8:18b9:: with SMTP id s54mr1089544qtj.176.1591758117561;
        Tue, 09 Jun 2020 20:01:57 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:29ac:7979:1e2e:c67b])
        by smtp.googlemail.com with ESMTPSA id y19sm10778716qki.19.2020.06.09.20.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 20:01:56 -0700 (PDT)
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
Subject: [PATCH] xdp_rxq_info_user: Add null check after malloc
Date:   Tue,  9 Jun 2020 23:01:36 -0400
Message-Id: <20200610030145.17263-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>

The memset call is made right after malloc call which
can return a NULL pointer upon failure causing a 
segmentation fault. Fix this by adding a null check 
right after malloc() and then do memset().

---
 samples/bpf/xdp_rxq_info_user.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
index 4fe47502ebed..2d03c84a4cca 100644
--- a/samples/bpf/xdp_rxq_info_user.c
+++ b/samples/bpf/xdp_rxq_info_user.c
@@ -202,11 +202,11 @@ static struct datarec *alloc_record_per_cpu(void)
 
 	size = sizeof(struct datarec) * nr_cpus;
 	array = malloc(size);
-	memset(array, 0, size);
 	if (!array) {
 		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
 		exit(EXIT_FAIL_MEM);
 	}
+	memset(array, 0, size);
 	return array;
 }
 
@@ -218,11 +218,11 @@ static struct record *alloc_record_per_rxq(void)
 
 	size = sizeof(struct record) * nr_rxqs;
 	array = malloc(size);
-	memset(array, 0, size);
 	if (!array) {
 		fprintf(stderr, "Mem alloc error (nr_rxqs:%u)\n", nr_rxqs);
 		exit(EXIT_FAIL_MEM);
 	}
+	memset(array, 0, size);
 	return array;
 }
 
@@ -233,11 +233,11 @@ static struct stats_record *alloc_stats_record(void)
 	int i;
 
 	rec = malloc(sizeof(*rec));
-	memset(rec, 0, sizeof(*rec));
 	if (!rec) {
 		fprintf(stderr, "Mem alloc error\n");
 		exit(EXIT_FAIL_MEM);
 	}
+	memset(rec, 0, sizeof(*rec));
 	rec->rxq = alloc_record_per_rxq();
 	for (i = 0; i < nr_rxqs; i++)
 		rec->rxq[i].cpu = alloc_record_per_cpu();
-- 
2.17.1

