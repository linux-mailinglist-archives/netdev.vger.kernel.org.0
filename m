Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 717F9185224
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 00:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgCMXQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 19:16:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35052 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726534AbgCMXQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 19:16:11 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02DN9l0i006732
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 16:16:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=C0x2CUw7bCzL5b3a307IDu0E3CdYixifm5zmdEMJQxM=;
 b=Tuvh7w5eIQ1bOpFYQaZ9LZ5XdrnwWdESGjlI2WqFuaS6za7l9oJVQ1fI61ro2mtv+VXo
 Zl52s4kHFdr2ykE7DBTfdUbYqe//iidtqjpqp1sodsdxRIoYbfoYtiwxNXzUVjkyCsgZ
 gxTj8Ekh9yJhkBe050DN3SY0cVjDBUdtDAA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt79pvrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 16:16:10 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 16:16:09 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 96B112EC2D2A; Fri, 13 Mar 2020 16:15:58 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftest/bpf: fix compilation warning in sockmap_parse_prog.c
Date:   Fri, 13 Mar 2020 16:07:15 -0700
Message-ID: <20200313230715.3287973-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_11:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 suspectscore=8 lowpriorityscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 mlxlogscore=898 clxscore=1015 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130103
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cast void * to long before casting to 32-bit __u32 to avoid compilation
warning.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/progs/sockmap_parse_prog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c b/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
index a5c6d5903b22..a9c2bdbd841e 100644
--- a/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
+++ b/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
@@ -12,7 +12,7 @@ int bpf_prog1(struct __sk_buff *skb)
 	__u32 lport = skb->local_port;
 	__u32 rport = skb->remote_port;
 	__u8 *d = data;
-	__u32 len = (__u32) data_end - (__u32) data;
+	__u32 len = (__u32)(long)data_end - (__u32)(long)data;
 	int err;
 
 	if (data + 10 > data_end) {
-- 
2.17.1

