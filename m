Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 454861350C2
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 02:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgAIBAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 20:00:41 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6790 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727417AbgAIBAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 20:00:41 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 009102DL030283
        for <netdev@vger.kernel.org>; Wed, 8 Jan 2020 17:00:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=V7/umriol0bL43X+cEmp7XeQfwdSmHpl4BxkKhK1phU=;
 b=QkY47B6S4MX3i7BasdDu/ITf8ID32TirSreS9cs6v42bLLQXnlMzMKOtFhLF+QZslQEW
 bpOqa2ycQR3+fCrvs6pEY1/2pGqPkLD0UqOXVAayOKqe5mzVI5+0Epk/s05aFXRn0uRF
 6JG//hdOkHaMunqlDdcF+oBPMdRfdtZcj30= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xd5aux32b-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 17:00:21 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 8 Jan 2020 16:59:47 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id A8C232942576; Wed,  8 Jan 2020 16:34:54 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 01/11] bpf: Save PTR_TO_BTF_ID register state when spilling to stack
Date:   Wed, 8 Jan 2020 16:34:54 -0800
Message-ID: <20200109003454.3854870-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200109003453.3854769-1-kafai@fb.com>
References: <20200109003453.3854769-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_07:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=682
 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0 suspectscore=13
 bulkscore=0 mlxscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001090007
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
index 6f63ae7a370c..d433d70022fd 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1916,6 +1916,7 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
+	case PTR_TO_BTF_ID:
 		return true;
 	default:
 		return false;
-- 
2.17.1

