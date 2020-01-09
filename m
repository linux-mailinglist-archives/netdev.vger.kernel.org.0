Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 238EB13508E
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 01:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbgAIAfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 19:35:42 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5296 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727237AbgAIAfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 19:35:42 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0090Xr1P018493
        for <netdev@vger.kernel.org>; Wed, 8 Jan 2020 16:35:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=TxK2G62VtFtlleXszvC8L5q8Ft5LXjU/Pc1jfLjAcTU=;
 b=hRKQmhtkFAwlO2gREkHXWclCPWLO2MA3lqNdjXAXB1ws7Er9Fkwfm18yWcLdRBeSX1P7
 XgkUOh+TMl+GfVVzSnKiOW1FJgLiSFxKW+wvlxtk8laTgItlEp/S6rgddX9kzLtP3aau
 83b8NM5dnOhzLV4L+BDxZOLQfb8+zC4OGTk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2xdrhwrb3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 16:35:40 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 8 Jan 2020 16:35:08 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 7605B2942576; Wed,  8 Jan 2020 16:35:01 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 04/11] bpf: Support bitfield read access in btf_struct_access
Date:   Wed, 8 Jan 2020 16:35:01 -0800
Message-ID: <20200109003501.3855427-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200109003453.3854769-1-kafai@fb.com>
References: <20200109003453.3854769-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_07:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=871 malwarescore=0 adultscore=0 suspectscore=13
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001090003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows bitfield access as a scalar.

It checks "off + size > t->size" to avoid accessing bitfield
end up accessing beyond the struct.  This check is done
outside of the loop since it is applicable to all access.

It also takes this chance to break early on the "off < moff" case.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/btf.c | 44 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 6a5ccb748a72..48bbde2e1c1e 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3744,19 +3744,53 @@ int btf_struct_access(struct bpf_verifier_log *log,
 		return -EINVAL;
 	}
 
-	for_each_member(i, t, member) {
-		if (btf_member_bitfield_size(t, member))
-			/* bitfields are not supported yet */
-			continue;
+	if (off + size > t->size) {
+		bpf_log(log, "access beyond struct %s at off %u size %u\n",
+			tname, off, size);
+		return -EACCES;
+	}
 
+	for_each_member(i, t, member) {
 		/* offset of the field in bytes */
 		moff = btf_member_bit_offset(t, member) / 8;
 		if (off + size <= moff)
 			/* won't find anything, field is already too far */
 			break;
+
+		if (btf_member_bitfield_size(t, member)) {
+			u32 end_bit = btf_member_bit_offset(t, member) +
+				btf_member_bitfield_size(t, member);
+
+			/* off <= moff instead of off == moff because clang
+			 * does not generate a BTF member for anonymous
+			 * bitfield like the ":16" here:
+			 * struct {
+			 *	int :16;
+			 *	int x:8;
+			 * };
+			 */
+			if (off <= moff &&
+			    BITS_ROUNDUP_BYTES(end_bit) <= off + size)
+				return SCALAR_VALUE;
+
+			/* off may be accessing a following member
+			 *
+			 * or
+			 *
+			 * Doing partial access at either end of this
+			 * bitfield.  Continue on this case also to
+			 * treat it as not accessing this bitfield
+			 * and eventually error out as field not
+			 * found to keep it simple.
+			 * It could be relaxed if there was a legit
+			 * partial access case later.
+			 */
+			continue;
+		}
+
 		/* In case of "off" is pointing to holes of a struct */
 		if (off < moff)
-			continue;
+			break;
 
 		/* type of the field */
 		mtype = btf_type_by_id(btf_vmlinux, member->type);
-- 
2.17.1

