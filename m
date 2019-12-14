Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50D9411EF4F
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 01:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfLNArr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 19:47:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40656 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725818AbfLNArr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 19:47:47 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBE0RFaj015105
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 16:47:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=0cN9+uzdZsJkNCfcX5bdzZd4wW8G3zXTiRCtb7tEfyU=;
 b=ANFc5iXmnCA7Fcy7YHCH/4qErUvfBqrkz+mRmVmta/SWozIxDK2HX8zsQBFmZLHjfgQw
 IjaeqRRN6elvNK7oU3v2jXriUvEmQYWINSq7nyqslv4CfIPFXpPmVWWwAQUZj0rXWfxz
 PzG8I627zzj9epv1wW6wyi8OK2i3d29CFB0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2wvfg8skwm-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 16:47:46 -0800
Received: from intmgw004.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 16:47:45 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 59E962943AB4; Fri, 13 Dec 2019 16:47:44 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 03/13] bpf: Add enum support to btf_ctx_access()
Date:   Fri, 13 Dec 2019 16:47:44 -0800
Message-ID: <20191214004744.1652395-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191214004737.1652076-1-kafai@fb.com>
References: <20191214004737.1652076-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 suspectscore=13 mlxscore=0
 mlxlogscore=806 phishscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912140001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It allows bpf prog (e.g. tracing) to attach
to a kernel function that takes enum argument.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 88359a4bccb0..6e652643849b 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3676,7 +3676,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	/* skip modifiers */
 	while (btf_type_is_modifier(t))
 		t = btf_type_by_id(btf, t->type);
-	if (btf_type_is_int(t))
+	if (btf_type_is_int(t) || btf_type_is_enum(t))
 		/* accessing a scalar */
 		return true;
 	if (!btf_type_is_ptr(t)) {
-- 
2.17.1

