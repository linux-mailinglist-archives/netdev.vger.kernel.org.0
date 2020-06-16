Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94871FA816
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 07:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbgFPFFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 01:05:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51480 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726052AbgFPFFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 01:05:10 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05G558QW012830
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 22:05:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=GkEct7hq4y31Z+EChUTSGdzyQUOiVP/OFvqPi7EQuZc=;
 b=YN835TCv3FLHimtQQB8yhzz/Vla9JtO6uJ0u0n5f7iJ4psbblSdv4AmMnshwH4uxp/wQ
 v4YUl6IjNbIcwwLy6+8RkOq+Lqj5nOOYcLs/yfT9BdumrAaJzlSq59UR4MDAoAtmElOq
 Dgh8U0GyjtoNsWVddqTooAaK/N6NFouD5kc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31pne70du9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 22:05:09 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 15 Jun 2020 22:04:41 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 9E8CC2EC2F00; Mon, 15 Jun 2020 22:04:34 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Christoph Hellwig <hch@lst.de>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 1/2] bpf: bpf_probe_read_kernel_str() has to return amount of data read on success
Date:   Mon, 15 Jun 2020 22:04:30 -0700
Message-ID: <20200616050432.1902042-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-15_11:2020-06-15,2020-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 cotscore=-2147483648
 priorityscore=1501 spamscore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=831 mlxscore=0 impostorscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160036
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During recent refactorings, bpf_probe_read_kernel_str() started returning=
 0 on
success, instead of amount of data successfully read. This majorly breaks
applications relying on bpf_probe_read_kernel_str() and bpf_probe_read_st=
r()
and their results. Fix this by returning actual number of bytes read.

Cc: Christoph Hellwig <hch@lst.de>
Fixes: 8d92db5c04d1 ("bpf: rework the compat kernel probe handling")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/trace/bpf_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index e729c9e587a0..a3ac7de98baa 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -241,7 +241,7 @@ bpf_probe_read_kernel_str_common(void *dst, u32 size,=
 const void *unsafe_ptr)
 	if (unlikely(ret < 0))
 		goto fail;
=20
-	return 0;
+	return ret;
 fail:
 	memset(dst, 0, size);
 	return ret;
--=20
2.24.1

