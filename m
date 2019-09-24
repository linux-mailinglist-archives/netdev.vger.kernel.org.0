Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4A3BCC60
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 18:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbfIXQYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 12:24:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4866 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728564AbfIXQYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 12:24:51 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8OGNu2D016390
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 09:24:50 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2v77mac2p6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 09:24:50 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 24 Sep 2019 09:24:48 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 6E32B37BC879; Tue, 24 Sep 2019 09:24:47 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <daniel@iogearbox.net>, <bjorn.topel@intel.com>,
        <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [PATCH net] bpf/xskmap: Return ERR_PTR for failure case instead of NULL.
Date:   Tue, 24 Sep 2019 09:24:47 -0700
Message-ID: <20190924162447.1629211-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-24_06:2019-09-23,2019-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 clxscore=1034
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909240148
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kzalloc() failed, NULL was returned to the caller, which
tested the pointer with IS_ERR(), which didn't match, so the
pointer was used later, resulting in a NULL dereference.

Return ERR_PTR(-ENOMEM) instead of NULL.

Reported-by: syzbot+491c1b7565ba9069ecae@syzkaller.appspotmail.com
Fixes: 0402acd683c6 ("xsk: remove AF_XDP socket from map when the socket is released")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 kernel/bpf/xskmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index 942c662e2eed..82a1ffe15dfa 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -37,7 +37,7 @@ static struct xsk_map_node *xsk_map_node_alloc(struct xsk_map *map,
 
 	node = kzalloc(sizeof(*node), GFP_ATOMIC | __GFP_NOWARN);
 	if (!node)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	err = xsk_map_inc(map);
 	if (err) {
-- 
2.17.1

