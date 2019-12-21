Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A112A1287CB
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 07:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfLUG0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 01:26:17 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24920 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725907AbfLUG0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 01:26:16 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBL6QD4n013751
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 22:26:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Z7gK7RNNL7Lvdyadz21GeIxgxtcW0jLYJ4j4w3Ilxvc=;
 b=fxQPxSdbxwiapeDtlz+BTZ5YEbpCL2GQ2HxRWz16DnFsjmQOv79U/DLLMnPfZ+fCNKyA
 AKO7pAKg+d9Fa4a2VmaCrlsloDhKFyiA3/yoPWAwk+5K3X3XBoA13wvRQ8AQ8md1PsK7
 Kjnaq9QCkV759QArx//Vg1+K3wMbl67kRzw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2x0s98df1x-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 22:26:15 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 20 Dec 2019 22:26:10 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 6D5B42946127; Fri, 20 Dec 2019 22:26:04 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 04/11] bpf: Support bitfield read access in btf_struct_access
Date:   Fri, 20 Dec 2019 22:26:04 -0800
Message-ID: <20191221062604.1182843-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191221062556.1182261-1-kafai@fb.com>
References: <20191221062556.1182261-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-21_01:2019-12-17,2019-12-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=731 phishscore=0
 clxscore=1015 spamscore=0 malwarescore=0 adultscore=0 suspectscore=13
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912210054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows bitfield access as a scalar.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/btf.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 6e652643849b..da73b63acfc5 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3744,10 +3744,6 @@ int btf_struct_access(struct bpf_verifier_log *log,
 	}
 
 	for_each_member(i, t, member) {
-		if (btf_member_bitfield_size(t, member))
-			/* bitfields are not supported yet */
-			continue;
-
 		/* offset of the field in bytes */
 		moff = btf_member_bit_offset(t, member) / 8;
 		if (off + size <= moff)
@@ -3757,6 +3753,12 @@ int btf_struct_access(struct bpf_verifier_log *log,
 		if (off < moff)
 			continue;
 
+		if (btf_member_bitfield_size(t, member)) {
+			if (off == moff && off + size <= t->size)
+				return SCALAR_VALUE;
+			continue;
+		}
+
 		/* type of the field */
 		mtype = btf_type_by_id(btf_vmlinux, member->type);
 		mname = __btf_name_by_offset(btf_vmlinux, member->name_off);
-- 
2.17.1

