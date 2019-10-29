Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C58DE7FFF
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 07:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732074AbfJ2GAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 02:00:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12358 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726034AbfJ2GAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 02:00:05 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9T5vY1b008602
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 23:00:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=41JfYLKTUlhkyGd+w/AeqfNtHOua4m6JwYmAe8FXJTI=;
 b=mzuvuDT70jS/lv9Ld+MOrqwoe/vHGzN9LgAEWUlMt1eddmogqGM+Tt7K1w39+S5Lg/WZ
 z3GMrynR0Zjko/89tu9+cjpl5cP7lx4ohaKiWrmkO81BtLwxk66/8bZCBqShhYBiyslv
 fOYHCTzsa3h806KHBJKx8F1LuLywJp5qjoQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2vvhtpmsbg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 23:00:02 -0700
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 28 Oct 2019 23:00:00 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id BB2312EC038A; Mon, 28 Oct 2019 22:59:59 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: don't use kernel-side u32 type in xsk.c
Date:   Mon, 28 Oct 2019 22:59:53 -0700
Message-ID: <20191029055953.2461336-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-29_02:2019-10-28,2019-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=814 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 mlxscore=0 suspectscore=8 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910290064
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

u32 is a kernel-side typedef. User-space library is supposed to use __u32.
This breaks Github's projection of libbpf. Do u32 -> __u32 fix.

Fixes: 94ff9ebb49a5 ("libbpf: Fix compatibility for kernels without need_wakeup")
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/xsk.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index d54111133123..74d84f36a5b2 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -161,22 +161,22 @@ static void xsk_mmap_offsets_v1(struct xdp_mmap_offsets *off)
 	off->rx.producer = off_v1.rx.producer;
 	off->rx.consumer = off_v1.rx.consumer;
 	off->rx.desc = off_v1.rx.desc;
-	off->rx.flags = off_v1.rx.consumer + sizeof(u32);
+	off->rx.flags = off_v1.rx.consumer + sizeof(__u32);
 
 	off->tx.producer = off_v1.tx.producer;
 	off->tx.consumer = off_v1.tx.consumer;
 	off->tx.desc = off_v1.tx.desc;
-	off->tx.flags = off_v1.tx.consumer + sizeof(u32);
+	off->tx.flags = off_v1.tx.consumer + sizeof(__u32);
 
 	off->fr.producer = off_v1.fr.producer;
 	off->fr.consumer = off_v1.fr.consumer;
 	off->fr.desc = off_v1.fr.desc;
-	off->fr.flags = off_v1.fr.consumer + sizeof(u32);
+	off->fr.flags = off_v1.fr.consumer + sizeof(__u32);
 
 	off->cr.producer = off_v1.cr.producer;
 	off->cr.consumer = off_v1.cr.consumer;
 	off->cr.desc = off_v1.cr.desc;
-	off->cr.flags = off_v1.cr.consumer + sizeof(u32);
+	off->cr.flags = off_v1.cr.consumer + sizeof(__u32);
 }
 
 static int xsk_get_mmap_offsets(int fd, struct xdp_mmap_offsets *off)
-- 
2.17.1

