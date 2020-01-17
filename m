Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6851403CB
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 07:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgAQGIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 01:08:25 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1334 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726982AbgAQGIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 01:08:21 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00H68GCk001552
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 22:08:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=vD1go5ni0WhRe4tQ6LPinwyWhOOBkoLkD8RJOCcZBgc=;
 b=jlZioySWanjR54X8vEWAENUawzPYbepgk3TjEC3XvSYiC4FutfnuxWfYkM/4f4ZXhhXW
 h+db/ciDO+9a6EK06tXr1XVzMIZ3iI7KMbYl//TUyiqFp9VzlTvI4OzrQvonUz8YpmgN
 bfT+cjozuwUAFlagOxJoBsTl0YG6LHWRg6E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xk0rn1bnw-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 22:08:20 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 16 Jan 2020 22:08:11 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 450352EC1745; Thu, 16 Jan 2020 22:08:06 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/4] libbpf: fix error handling bug in btf_dump__new
Date:   Thu, 16 Jan 2020 22:07:58 -0800
Message-ID: <20200117060801.1311525-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200117060801.1311525-1-andriin@fb.com>
References: <20200117060801.1311525-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_06:2020-01-16,2020-01-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=8
 mlxlogscore=961 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001170048
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix missing jump to error handling in btf_dump__new, found by Coverity static
code analysis.

Fixes: 9f81654eebe8 ("libbpf: Expose BTF-to-C type declaration emitting API")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf_dump.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 885acebd4396..bd09ed1710f1 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -142,6 +142,7 @@ struct btf_dump *btf_dump__new(const struct btf *btf,
 	if (IS_ERR(d->type_names)) {
 		err = PTR_ERR(d->type_names);
 		d->type_names = NULL;
+		goto err;
 	}
 	d->ident_names = hashmap__new(str_hash_fn, str_equal_fn, NULL);
 	if (IS_ERR(d->ident_names)) {
-- 
2.17.1

