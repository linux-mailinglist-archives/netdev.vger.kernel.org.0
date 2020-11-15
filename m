Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66562B3454
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 11:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgKOKtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 05:49:01 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56560 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbgKOKtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 05:49:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AFAjw3L034226;
        Sun, 15 Nov 2020 10:48:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=0SQ04sPpy55hmGwi9wK6B8H2o5DGQMXCFt2rANOMIJQ=;
 b=vuC857aCSvmVZPlZZcuDCMwoGt8JXGZnv4TNihkUw0bUu0I7LSZEN3aUmczFwXRYKkZM
 BICVdxf8d2zT6rq0Zsh5gMDwCu9dvc5QLu8dlNz9yKi//3mD0hJ7gXrSSBkseZvOij8s
 YJD01ZSI0P9W0tQHYZwHomOiSksO5dGquskzOyTaXYR+Wrnt1955nBfss9H225qgD7Ma
 DRqrsoUP0S8WjqQLuxc7ncRbyN3AypqsHUpz03Cg1sGGFyXquIx/67sV/WS1oNBDDBbA
 fIPrY77epKwe/lVOdRSYnRVyt410fHbbf5yBWjEPsF948ZLn18Ypio2XYgViW/ZTSQwD Vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34t76kj71e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 15 Nov 2020 10:48:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AFAjJGs053689;
        Sun, 15 Nov 2020 10:46:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34ts0nc20e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Nov 2020 10:46:42 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AFAkedg026085;
        Sun, 15 Nov 2020 10:46:40 GMT
Received: from localhost.uk.oracle.com (/10.175.173.115)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 15 Nov 2020 02:46:40 -0800
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next] libbpf: bpf__find_by_name[_kind] should use btf__get_nr_types()
Date:   Sun, 15 Nov 2020 10:46:35 +0000
Message-Id: <1605437195-2175-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9805 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011150065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9805 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011150065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When operating on split BTF, btf__find_by_name[_kind] will not
iterate over all types since they use btf->nr_types to show
the number of types to iterate over.  For split BTF this is
the number of types _on top of base BTF_, so it will
underestimate the number of types to iterate over, especially
for vmlinux + module BTF, where the latter is much smaller.

Use btf__get_nr_types() instead.

Fixes: ba451366bf44 ("libbpf: Implement basic split BTF support")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/btf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 2d0d064..8ff46cd 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -674,12 +674,12 @@ int btf__resolve_type(const struct btf *btf, __u32 type_id)
 
 __s32 btf__find_by_name(const struct btf *btf, const char *type_name)
 {
-	__u32 i;
+	__u32 i, nr_types = btf__get_nr_types(btf);
 
 	if (!strcmp(type_name, "void"))
 		return 0;
 
-	for (i = 1; i <= btf->nr_types; i++) {
+	for (i = 1; i <= nr_types; i++) {
 		const struct btf_type *t = btf__type_by_id(btf, i);
 		const char *name = btf__name_by_offset(btf, t->name_off);
 
@@ -693,12 +693,12 @@ __s32 btf__find_by_name(const struct btf *btf, const char *type_name)
 __s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
 			     __u32 kind)
 {
-	__u32 i;
+	__u32 i, nr_types = btf__get_nr_types(btf);
 
 	if (kind == BTF_KIND_UNKN || !strcmp(type_name, "void"))
 		return 0;
 
-	for (i = 1; i <= btf->nr_types; i++) {
+	for (i = 1; i <= nr_types; i++) {
 		const struct btf_type *t = btf__type_by_id(btf, i);
 		const char *name;
 
-- 
1.8.3.1

