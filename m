Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1F8F1449FD
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 03:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgAVClw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Jan 2020 21:41:52 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33992 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728842AbgAVClv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 21:41:51 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00M2ffwj021708
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 18:41:51 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xp7371tds-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 18:41:51 -0800
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 21 Jan 2020 18:41:49 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 72523760C45; Tue, 21 Jan 2020 18:41:38 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpf: Fix error path under memory pressure
Date:   Tue, 21 Jan 2020 18:41:38 -0800
Message-ID: <20200122024138.3385590-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 impostorscore=0 suspectscore=3 phishscore=0 mlxlogscore=369
 priorityscore=1501 lowpriorityscore=10 malwarescore=0 spamscore=0
 bulkscore=10 clxscore=1034 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001220019
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Restore the 'if (env->cur_state)' check that was incorrectly removed during
code move. Under memory pressure env->cur_state can be freed and zeroed inside
do_check(). Hence the check is necessary.

Fixes: 51c39bb1d5d1 ("bpf: Introduce function-by-function verification")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ca17dccc17ba..6defbec9eb62 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9594,8 +9594,13 @@ static int do_check_common(struct bpf_verifier_env *env, int subprog)
 
 	ret = do_check(env);
 out:
-	free_verifier_state(env->cur_state, true);
-	env->cur_state = NULL;
+	/* check for NULL is necessary, since cur_state can be freed inside
+	 * do_check() under memory pressure.
+	 */
+	if (env->cur_state) {
+		free_verifier_state(env->cur_state, true);
+		env->cur_state = NULL;
+	}
 	while (!pop_stack(env, NULL, NULL));
 	free_states(env);
 	if (ret)
-- 
2.23.0

