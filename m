Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19920179D72
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 02:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgCEBf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 20:35:26 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16350 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727002AbgCEBfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 20:35:25 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0251WE7g014338
        for <netdev@vger.kernel.org>; Wed, 4 Mar 2020 17:35:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=T+DSF+hfrUFKJ+8RB8qdYBDF6tn6sMbshl/NeaZhpgw=;
 b=ABWVGJZA+2Oa0WKtHKUHjCtir/EQ3AJIZPHOfuX6N/aXSe+9shI5w/XackjP+gTVVoJw
 SOsqD10jR+s8u/AVjDTlbUrvQmXrpOwKk+0LucruCXl92VpKu4/RE2JsOAOj8uJE+T0X
 E0jht5RDdSFcwR8fbe9EagadVKHgAOi8ztI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yjqu5r0gj-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 17:35:24 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 4 Mar 2020 17:35:07 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 5FE4829425EB; Wed,  4 Mar 2020 17:34:54 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 2/2] bpf: Do not allow map_freeze in struct_ops map
Date:   Wed, 4 Mar 2020 17:34:54 -0800
Message-ID: <20200305013454.535397-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200305013437.534961-1-kafai@fb.com>
References: <20200305013437.534961-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-04_10:2020-03-04,2020-03-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=858 malwarescore=0
 suspectscore=13 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2003050006
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct_ops map cannot support map_freeze.  Otherwise, a struct_ops
cannot be unregistered from the subsystem.

Fixes: 85d33df357b6 ("bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/syscall.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index a91ad518c050..0c7fb0d4836d 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1510,6 +1510,11 @@ static int map_freeze(const union bpf_attr *attr)
 	if (IS_ERR(map))
 		return PTR_ERR(map);
 
+	if (map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
+		fdput(f);
+		return -ENOTSUPP;
+	}
+
 	mutex_lock(&map->freeze_mutex);
 
 	if (map->writecnt) {
-- 
2.17.1

