Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9DC1287BE
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 07:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfLUG0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 01:26:00 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31902 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725954AbfLUG0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 01:26:00 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBL6OZKp019573
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 22:25:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=FqJDHT5zIe7EFMz3Q4YF3C2Z0DHiOuQJqZ3XrqSZTUg=;
 b=A65WBsqzn0ewMM709r5wIrbQmwaJ+oMaDriUtBCgFsd7n6J7wM+peCsX18VQ2ijFKrnn
 C73IpigUolz7/rZctEHXoNpzwbU0cfl2TDINCywT3Qm5/3Uzz9DTV2P44N71gbHLhCS1
 X1K/k2WLw8w2K+ro+bVHtbXtO/wYgha6Ngs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2x14s8a699-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 22:25:59 -0800
Received: from intmgw005.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 20 Dec 2019 22:25:58 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id A54BB2946127; Fri, 20 Dec 2019 22:25:57 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 01/11] bpf: Save PTR_TO_BTF_ID register state when spilling to stack
Date:   Fri, 20 Dec 2019 22:25:57 -0800
Message-ID: <20191221062557.1182372-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191221062556.1182261-1-kafai@fb.com>
References: <20191221062556.1182261-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-21_01:2019-12-17,2019-12-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=13 mlxlogscore=666 phishscore=0
 clxscore=1015 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912210054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes the verifier save the PTR_TO_BTF_ID register state when
spilling to the stack.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/verifier.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 034ef81f935b..408264c1d55b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1915,6 +1915,7 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
+	case PTR_TO_BTF_ID:
 		return true;
 	default:
 		return false;
-- 
2.17.1

