Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B54D9184D8A
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 18:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgCMRYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 13:24:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56684 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727054AbgCMRYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 13:24:04 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02DHAY1I024212
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 10:24:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=KAl48JeIpTkKNnpgbd69xYDFvR0gGTDxoZ3dGXCLHB8=;
 b=n+rF4legp377zx+yp1OIUJN/0fvKFxWcgrjeQF7i8hUQlYPjJT0/JSrpV4MDQoCu4ylm
 NrWFYHEZhAKqc+QKD5aYmp7X5taTytZFTwAxrb/diIQSrcNxyCxgY2BBT9tLLRbgDe+8
 hyCHDN8cWNsrE4lXGdXrYIiSE29TBzaBeUg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt7fnaft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 10:24:03 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 10:24:02 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 003962EC2DE4; Fri, 13 Mar 2020 10:23:53 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/4] libbpf: ignore incompatible types with matching name during CO-RE relocation
Date:   Fri, 13 Mar 2020 10:23:34 -0700
Message-ID: <20200313172336.1879637-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313172336.1879637-1-andriin@fb.com>
References: <20200313172336.1879637-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_06:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=671
 clxscore=1015 malwarescore=0 adultscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003130085
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When finding target type candidates, ignore forward declarations, functions,
and other named types of incompatible kind. Not doing this can cause false
errors.  See [0] for one such case (due to struct pt_regs forward
declaration).

  [0] https://github.com/iovisor/bcc/pull/2806#issuecomment-598543645

Fixes: ddc7c3042614 ("libbpf: implement BPF CO-RE offset relocation algorithm")
Reported-by: Wenbo Zhang <ethercflow@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1a787a2faf58..085e41f9b68e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3873,6 +3873,10 @@ static struct ids_vec *bpf_core_find_cands(const struct btf *local_btf,
 		if (str_is_empty(targ_name))
 			continue;
 
+		t = skip_mods_and_typedefs(targ_btf, i, NULL);
+		if (!btf_is_composite(t) && !btf_is_array(t))
+			continue;
+
 		targ_essent_len = bpf_core_essential_name_len(targ_name);
 		if (targ_essent_len != local_essent_len)
 			continue;
-- 
2.17.1

