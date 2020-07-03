Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F8A2131DD
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 04:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgGCCpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 22:45:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13608 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726065AbgGCCpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 22:45:45 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0632jR38019318
        for <netdev@vger.kernel.org>; Thu, 2 Jul 2020 19:45:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=xkW/NXPJb9g5DyOUmKNLs/KVHEWlTsH8eZwtERwU2Is=;
 b=AdNRC8muNrpSz8Aiy9vCRIHOdnBVpZfOPWucuzSpYcBt+EwB7T9WgBdCEzngdcZXYaW7
 ycsRXOcYFL4/f+DnPfN8/OVaB3RwfIMvxpyFrMS3xWrmsMCqUZc3KFNNcG9MiW8Qubxz
 jDZ5fzuNRq2FXBzBjUR+V05EiKXTb2Xq5Dw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 321k40jmma-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 19:45:44 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 19:45:42 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 0EDD462E51C1; Thu,  2 Jul 2020 19:45:40 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>,
        kernel test robot <lkp@intel.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [bpf-next] bpf: fix build without CONFIG_STACKTRACE
Date:   Thu, 2 Jul 2020 19:45:37 -0700
Message-ID: <20200703024537.79971-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-02_18:2020-07-02,2020-07-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=8 impostorscore=0 bulkscore=0 priorityscore=1501
 malwarescore=0 mlxlogscore=747 phishscore=0 mlxscore=0 adultscore=0
 clxscore=1015 cotscore=-2147483648 lowpriorityscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030019
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without CONFIG_STACKTRACE stack_trace_save_tsk() is not defined. Let
get_callchain_entry_for_task() to always return NULL in such cases.

Fixes: fa28dcb82a38 ("bpf: Introduce helper bpf_get_task_stack()")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/stackmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 5ad72ab2276b3..a6c361ed7937b 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -351,6 +351,7 @@ static void stack_map_get_build_id_offset(struct bpf_=
stack_build_id *id_offs,
 static struct perf_callchain_entry *
 get_callchain_entry_for_task(struct task_struct *task, u32 init_nr)
 {
+#ifdef CONFIG_STACKTRACE
 	struct perf_callchain_entry *entry;
 	int rctx;
=20
@@ -380,6 +381,9 @@ get_callchain_entry_for_task(struct task_struct *task=
, u32 init_nr)
 	put_callchain_entry(rctx);
=20
 	return entry;
+#else /* CONFIG_STACKTRACE */
+	return NULL;
+#endif
 }
=20
 BPF_CALL_3(bpf_get_stackid, struct pt_regs *, regs, struct bpf_map *, ma=
p,
--=20
2.24.1

