Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29DBE41715
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 23:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407697AbfFKVqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 17:46:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58670 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404730AbfFKVqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 17:46:01 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5BLdDiF026952
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 14:46:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=kJquJf7Xz0objhdEKgUGpNqF1UrQH71lkZ/+J4QXDZE=;
 b=oCKqTKyYEkaYJjJYu3W/2B/fs99L8mkxUoxHr5EOwhOm4og9S65t9NPNSqTqH6RmXkrw
 sKUSfi1OHiPgP18JS/FmG+GrDgEMjH9Jg2XtqnUf5X/OHo5jU0De8ojrJqsTOffmgTv/
 a4dNcAcvxHYGRN6tv+7qFJDWNZYjy1xoxaA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t2j2urjj9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 14:46:00 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 11 Jun 2019 14:45:58 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 124692942431; Tue, 11 Jun 2019 14:45:57 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: net: Set sk_bpf_storage back to NULL for cloned sk
Date:   Tue, 11 Jun 2019 14:45:57 -0700
Message-ID: <20190611214557.2700117-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-11_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=694 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110140
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cloned sk should not carry its parent-listener's sk_bpf_storage.
This patch fixes it by setting it back to NULL.

Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/core/sock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/sock.c b/net/core/sock.c
index 2b3701958486..d90fd04622e5 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1850,6 +1850,9 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 			goto out;
 		}
 		RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
+#ifdef CONFIG_BPF_SYSCALL
+		RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
+#endif
 
 		newsk->sk_err	   = 0;
 		newsk->sk_err_soft = 0;
-- 
2.17.1

