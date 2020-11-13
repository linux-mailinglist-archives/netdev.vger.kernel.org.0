Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671C32B2362
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 19:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgKMSLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 13:11:20 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54522 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgKMSLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 13:11:17 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ADI438J173191;
        Fri, 13 Nov 2020 18:10:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=aIg6ncmRmCzTXwkJO/u9W1OVqILkc+nE/6r1jBCCrAo=;
 b=mbqg/AO5mYnmBbkhKNtTdomGBZ8nrEXw13bhb7d/notA3foDwhu6Adl/aCn7RztzZ3Pz
 zKWKHTo+SLDAEEsDff/1ujfXc3UDqds6oaf/AETSJv5bb0j56OXVRfTpkoWp6vd4HM+j
 UmiXDgQ3ZqdeFhBWI3iwdbLzeBw0CK2BTeLQKXUNfWRuOi0IsH4DUwZio31ejMMXFc6L
 kRauO8gb2eoOZVEAndfnbiwJUQm9vGEXQFGFCjrMKoE7HNyvi3oP0D+r5+CmMq4jvbfY
 Kdhi24qcCBbwWPUkbxiEymkhEwurQ326AAUzHPJpS8/alP9UD6Wk0TOL/hSNlcWFmZpG qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34nh3bbuc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 13 Nov 2020 18:10:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ADI6Km1117766;
        Fri, 13 Nov 2020 18:10:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34rtku1w5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 18:10:26 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0ADIAPSi021491;
        Fri, 13 Nov 2020 18:10:25 GMT
Received: from localhost.uk.oracle.com (/10.175.203.107)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 10:10:25 -0800
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        rostedt@goodmis.org, mingo@redhat.com, haoluo@google.com,
        jolsa@kernel.org, quentin@isovalent.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [RFC bpf-next 2/3] libbpf: bpf__find_by_name[_kind] should use btf__get_nr_types()
Date:   Fri, 13 Nov 2020 18:10:12 +0000
Message-Id: <1605291013-22575-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605291013-22575-1-git-send-email-alan.maguire@oracle.com>
References: <1605291013-22575-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130117
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

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/btf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 2d0d064..0fccf4b 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -679,7 +679,7 @@ __s32 btf__find_by_name(const struct btf *btf, const char *type_name)
 	if (!strcmp(type_name, "void"))
 		return 0;
 
-	for (i = 1; i <= btf->nr_types; i++) {
+	for (i = 1; i <= btf__get_nr_types(btf); i++) {
 		const struct btf_type *t = btf__type_by_id(btf, i);
 		const char *name = btf__name_by_offset(btf, t->name_off);
 
@@ -698,7 +698,7 @@ __s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
 	if (kind == BTF_KIND_UNKN || !strcmp(type_name, "void"))
 		return 0;
 
-	for (i = 1; i <= btf->nr_types; i++) {
+	for (i = 1; i <= btf__get_nr_types(btf); i++) {
 		const struct btf_type *t = btf__type_by_id(btf, i);
 		const char *name;
 
-- 
1.8.3.1

