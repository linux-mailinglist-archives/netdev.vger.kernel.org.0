Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05BF2CE331
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 00:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgLCXzg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Dec 2020 18:55:36 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31564 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729534AbgLCXzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 18:55:36 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B3NlBut006148
        for <netdev@vger.kernel.org>; Thu, 3 Dec 2020 15:54:55 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 356xfqw6x5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 15:54:55 -0800
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 15:54:53 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AE1C42ECA8F6; Thu,  3 Dec 2020 15:54:48 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 1/2] libbpf: use memcpy instead of strncpy to please GCC
Date:   Thu, 3 Dec 2020 15:54:39 -0800
Message-ID: <20201203235440.2302137-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_15:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 mlxscore=0 clxscore=1034
 impostorscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some versions of GCC are really nit-picky about strncpy() use. Use memcpy(),
as they are pretty much equivalent for the case of fixed length strings.

Fixes: e459f49b4394 ("libbpf: Separate XDP program load with xsk socket creation")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 4b051ec7cfbb..e3e41ceeb1bc 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -583,7 +583,7 @@ static int xsk_create_xsk_struct(int ifindex, struct xsk_socket *xsk)
 	}
 
 	ctx->ifindex = ifindex;
-	strncpy(ctx->ifname, ifname, IFNAMSIZ - 1);
+	memcpy(ctx->ifname, ifname, IFNAMSIZ -1);
 	ctx->ifname[IFNAMSIZ - 1] = 0;
 
 	xsk->ctx = ctx;
-- 
2.24.1

