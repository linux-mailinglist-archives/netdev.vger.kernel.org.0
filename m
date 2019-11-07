Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8182F247E
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 02:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732753AbfKGBqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 20:46:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51280 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728021AbfKGBqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 20:46:45 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA71jL8t030460
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 17:46:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=vd+7RXw6TDZ1w+VTM6gFZdpZGF4UdxXMqvos2K/niFg=;
 b=YTzA0lKNorUfyRWkOxDhfKb1+/aOAfh4w0lo5ZwyYN6MYS2iMzMts/bjHkuwKo8JATwm
 kwtjmRCy7NYNkgrqXpE9aUO1BgL6qQaWBeaWP0sJ2h9t0DjjoxAHBiqadO3F5I60XzEa
 3DbGNH4mmzgYn53N4aIpAFhHuPGLm4FkGaM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41ue2f8h-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 17:46:44 -0800
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 Nov 2019 17:46:42 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 0864429430DB; Wed,  6 Nov 2019 17:46:40 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 1/3] bpf: Account for insn->off when doing bpf_probe_read_kernel
Date:   Wed, 6 Nov 2019 17:46:40 -0800
Message-ID: <20191107014640.384083-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107014639.384014-1-kafai@fb.com>
References: <20191107014639.384014-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 mlxlogscore=935 suspectscore=8 adultscore=0
 mlxscore=0 bulkscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070017
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the bpf interpreter mode, bpf_probe_read_kernel is used to read
from PTR_TO_BTF_ID's kernel object.  It currently missed considering
the insn->off.  This patch fixes it.

Fixes: 2a02759ef5f8 ("bpf: Add support for BTF pointers to interpreter")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 97e37d82a1cc..c1fde0303280 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1569,7 +1569,7 @@ static u64 __no_fgcse ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u6
 #undef LDST
 #define LDX_PROBE(SIZEOP, SIZE)							\
 	LDX_PROBE_MEM_##SIZEOP:							\
-		bpf_probe_read_kernel(&DST, SIZE, (const void *)(long) SRC);	\
+		bpf_probe_read_kernel(&DST, SIZE, (const void *)(long) (SRC + insn->off));	\
 		CONT;
 	LDX_PROBE(B,  1)
 	LDX_PROBE(H,  2)
-- 
2.17.1

