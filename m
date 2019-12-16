Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA2A71217C8
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 19:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbfLPSik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 13:38:40 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2618 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729143AbfLPSij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 13:38:39 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBGIaNP3020355
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 10:38:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=kq1fRx8zSd/+q5wcJUQ5KdTFm36nQ4EAz3QAXz5XJDQ=;
 b=mU3LT+5VAjraSr08R0tTP2+ERFG+fQAf7YP2utrNoMmdsNT/pDRanxSNtQ2B9L9L4gOw
 mU3dl291n1um6s8ZU1Qc1ZlkWt26qsC8Ojy4NIGdxroqTRZtiv0qPVda1rShVoAONodj
 eKZh+w3n4yz6cwQ8UIAj99dYwdL+kGDZcl4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wwgayngm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 10:38:38 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Dec 2019 10:38:37 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 230802EC14BF; Mon, 16 Dec 2019 10:38:35 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Luca Boccassi <bluca@debian.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: add zlib as a dependency in pkg-config template
Date:   Mon, 16 Dec 2019 10:38:29 -0800
Message-ID: <20191216183830.3972964-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_07:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=8 clxscore=1015 malwarescore=0 priorityscore=1501
 mlxlogscore=916 phishscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912160156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

List zlib as another dependency of libbpf in pkg-config template.
Verified it is correctly resolved to proper -lz flag:

$ make DESTDIR=/tmp/libbpf-install install
$ pkg-config --libs /tmp/libbpf-install/usr/local/lib64/pkgconfig/libbpf.pc
-L/usr/local/lib64 -lbpf
$ pkg-config --libs --static /tmp/libbpf-install/usr/local/lib64/pkgconfig/libbpf.pc
-L/usr/local/lib64 -lbpf -lelf -lz

Fixes: 166750bc1dd2 ("libbpf: Support libbpf-provided extern variables")
Cc: Luca Boccassi <bluca@debian.org>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.pc.template | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.pc.template b/tools/lib/bpf/libbpf.pc.template
index ac17fcef2108..b45ed534bdfb 100644
--- a/tools/lib/bpf/libbpf.pc.template
+++ b/tools/lib/bpf/libbpf.pc.template
@@ -8,5 +8,5 @@ Name: libbpf
 Description: BPF library
 Version: @VERSION@
 Libs: -L${libdir} -lbpf
-Requires.private: libelf
+Requires.private: libelf zlib
 Cflags: -I${includedir}
-- 
2.17.1

