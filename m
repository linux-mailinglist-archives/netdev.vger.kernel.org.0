Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7AFE17EC39
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 23:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgCIWk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 18:40:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6550 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727125AbgCIWk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 18:40:27 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 029MaIwd017040
        for <netdev@vger.kernel.org>; Mon, 9 Mar 2020 15:40:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=Ot3yvsJGq05LFkk2MrG+kC5EWFHLX7V2T/GeJ6X5cuU=;
 b=WzF4cotmn8FATKyjbwtTto9cmNnhb+IWirgTHOI4L0znLULFwDuX28KFrB5Mu5BPTnia
 ROE+qQaCjVZoz6t6osDKAbYonQ3tMYcS16cxdQuUZ8Zg62UHLhf0O/vUm/OFe6Eg3u0r
 I06v4n8ki/MOUGuLXiFRSJKWJ+zJCQCubG8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ynu7js4nj-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 15:40:27 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 9 Mar 2020 15:40:24 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7B9442EC2D75; Mon,  9 Mar 2020 15:40:23 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <guro@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: fix cgroup ref leak in cgroup_bpf_inherit on out-of-memory
Date:   Mon, 9 Mar 2020 15:40:17 -0700
Message-ID: <20200309224017.1063297-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_11:2020-03-09,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=468 priorityscore=1501 impostorscore=0
 clxscore=1015 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 suspectscore=25 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2003090136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no compensating cgroup_bpf_put() for each ancestor cgroup in
cgroup_bpf_inherit(). If compute_effective_progs returns error, those cgroups
won't be freed ever. Fix it by putting them in cleanup code path.

Fixes: e10360f815ca ("bpf: cgroup: prevent out-of-order release of cgroup bpf")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 9a500fadbef5..5220a67392fc 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -227,6 +227,9 @@ int cgroup_bpf_inherit(struct cgroup *cgrp)
 	for (i = 0; i < NR; i++)
 		bpf_prog_array_free(arrays[i]);
 
+	for (p = cgroup_parent(cgrp); p; p = cgroup_parent(p))
+		cgroup_bpf_put(p);
+
 	percpu_ref_exit(&cgrp->bpf.refcnt);
 
 	return -ENOMEM;
-- 
2.17.1

