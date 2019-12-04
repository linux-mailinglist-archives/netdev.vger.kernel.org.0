Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C0A112325
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 08:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfLDHAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 02:00:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5028 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727247AbfLDHAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 02:00:42 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB46rJk1011535
        for <netdev@vger.kernel.org>; Tue, 3 Dec 2019 23:00:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=zzR6nON3D3o3R4BI/KRZUl99XEyIhqzUw+LZQGkqMFY=;
 b=TKnCaVxOUdNXl6la3lf7wNdZyLu7ImvIA5P7Im0qFpvC7R5siTlTppnJxpRo5TEmnnO0
 3v/cu0eTesXMn0x7BnhYudtv6f6qlJb+bg3hjuzVIjGkkc1YYTQbtBtkobcxL1uqjbpd
 Pn56b2Zj5QW2mrqQ7A7J1D8Y86n7UmBFoX8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wp7rnr242-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 23:00:41 -0800
Received: from 2401:db00:2050:5076:face:0:7:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 3 Dec 2019 23:00:38 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 2AFB72EC1853; Tue,  3 Dec 2019 23:00:38 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 09/16] libbpf: reduce log level of supported section names dump
Date:   Tue, 3 Dec 2019 23:00:08 -0800
Message-ID: <20191204070015.3523523-10-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191204070015.3523523-1-andriin@fb.com>
References: <20191204070015.3523523-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-04_01:2019-12-04,2019-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 mlxlogscore=831
 phishscore=0 suspectscore=25 priorityscore=1501 mlxscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912040050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's quite spammy. And now that bpf_object__open() is trying to determine
program type from its section name, we are getting these verbose messages all
the time. Reduce their log level to DEBUG.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f4a3ed73c9f5..a4cce8f1e6b1 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5191,7 +5191,7 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 	pr_warn("failed to guess program type from ELF section '%s'\n", name);
 	type_names = libbpf_get_type_names(false);
 	if (type_names != NULL) {
-		pr_info("supported section(type) names are:%s\n", type_names);
+		pr_debug("supported section(type) names are:%s\n", type_names);
 		free(type_names);
 	}
 
-- 
2.17.1

