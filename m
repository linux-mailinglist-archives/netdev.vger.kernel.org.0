Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E57961841E1
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 08:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgCMH4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 03:56:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61328 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726514AbgCMH4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 03:56:15 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 02D7rd3m003060
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 00:56:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=KAl48JeIpTkKNnpgbd69xYDFvR0gGTDxoZ3dGXCLHB8=;
 b=kmIfZwF2F6dersNhytwJc7ptnRAe25iXz/PFsbsBWjs+jw6v5iYmMkxmFnXrEkUrjpRL
 Y9YqOQ3egfZkgz9YMZEh3WI52ghSyHNwCb4DniTO59kTAq2pdM2oOc4fyt6uE+INXqcc
 QjXuZga7Sj2EezW5yPU3pGF22fTU05lsnnY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2yqt89awds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 00:56:14 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 00:56:12 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0B88F2EC2DC7; Fri, 13 Mar 2020 00:56:06 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/4] libbpf: ignore incompatible types with matching name during CO-RE relocation
Date:   Fri, 13 Mar 2020 00:54:39 -0700
Message-ID: <20200313075442.4071486-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313075442.4071486-1-andriin@fb.com>
References: <20200313075442.4071486-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_03:2020-03-11,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=673
 clxscore=1015 malwarescore=0 bulkscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130044
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

