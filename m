Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C428310A6DB
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 00:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfKZXBL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 Nov 2019 18:01:11 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41326 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726445AbfKZXBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 18:01:11 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAQMwNi2028932
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 15:01:10 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2whcy3g4vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 15:01:10 -0800
Received: from 2401:db00:2120:80d4:face:0:39:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 26 Nov 2019 15:01:09 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 9AD40760E50; Tue, 26 Nov 2019 15:01:06 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <dan.carpenter@oracle.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpf: fix static checker warning
Date:   Tue, 26 Nov 2019 15:01:06 -0800
Message-ID: <20191126230106.237179-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-26_07:2019-11-26,2019-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 adultscore=0 spamscore=0 mlxlogscore=943 priorityscore=1501 malwarescore=0
 phishscore=0 mlxscore=0 bulkscore=0 impostorscore=0 suspectscore=1
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911260195
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel/bpf/btf.c:4023 btf_distill_func_proto()
        error: potentially dereferencing uninitialized 't'.

kernel/bpf/btf.c
  4012          nargs = btf_type_vlen(func);
  4013          if (nargs >= MAX_BPF_FUNC_ARGS) {
  4014                  bpf_log(log,
  4015                          "The function %s has %d arguments. Too many.\n",
  4016                          tname, nargs);
  4017                  return -EINVAL;
  4018          }
  4019          ret = __get_type_size(btf, func->type, &t);
                                                       ^^
t isn't initialized for the first -EINVAL return

This is unlikely path, since BTF should have been validated at this point.
Fix it by returning 'void' BTF.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/btf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 40efde5eedcb..bd5e11881ba3 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3976,8 +3976,10 @@ static int __get_type_size(struct btf *btf, u32 btf_id,
 	t = btf_type_by_id(btf, btf_id);
 	while (t && btf_type_is_modifier(t))
 		t = btf_type_by_id(btf, t->type);
-	if (!t)
+	if (!t) {
+		*bad_type = btf->types[0];
 		return -EINVAL;
+	}
 	if (btf_type_is_ptr(t))
 		/* kernel size of pointer. Not BPF's size of pointer*/
 		return sizeof(void *);
-- 
2.23.0

