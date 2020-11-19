Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71882B99C2
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbgKSRkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:40:32 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6506 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729397AbgKSRiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 12:38:09 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJHUR6V010042
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:38:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=FBlMP3vkmjBpV4Cj/ZwYUzcA6JfufLS/KOYX6AWCiGM=;
 b=FAHi5rr6trNsk83d7kHpOExyHq8YHyAq3C7yRNMM9YdtAhUNFS2VTcO0hrC33F6vNRLN
 eZOcjijjLWAYBZCFiDfGqNnvvIfcTPRwMYg1Lpaz+Dp1sum33gWP5F94MQMnpx0gyatk
 Jcdls9Cznr+zGSakJbJodZNxLP8zFiK4+jI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34wdgvq59b-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:38:08 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 09:38:01 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 94640145BCE5; Thu, 19 Nov 2020 09:37:56 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v7 07/34] bpf: memcg-based memory accounting for bpf maps
Date:   Thu, 19 Nov 2020 09:37:27 -0800
Message-ID: <20201119173754.4125257-8-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201119173754.4125257-1-guro@fb.com>
References: <20201119173754.4125257-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_09:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=13 priorityscore=1501 bulkscore=0
 impostorscore=0 spamscore=0 mlxlogscore=688 clxscore=1015
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011190125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables memcg-based memory accounting for memory allocated
by __bpf_map_area_alloc(), which is used by many types of bpf maps for
large memory allocations.

Following patches in the series will refine the accounting for
some of the map types.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4154c616788c..4b514bb5cd70 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -281,7 +281,7 @@ static void *__bpf_map_area_alloc(u64 size, int numa_=
node, bool mmapable)
 	 * __GFP_RETRY_MAYFAIL to avoid such situations.
 	 */
=20
-	const gfp_t gfp =3D __GFP_NOWARN | __GFP_ZERO;
+	const gfp_t gfp =3D __GFP_NOWARN | __GFP_ZERO | __GFP_ACCOUNT;
 	unsigned int flags =3D 0;
 	unsigned long align =3D 1;
 	void *area;
--=20
2.26.2

