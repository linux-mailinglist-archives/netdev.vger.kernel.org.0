Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 801CE125A83
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 06:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfLSFVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 00:21:10 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33390 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725996AbfLSFVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 00:21:10 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJ5FhR2015322
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 21:21:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=FdX7wuw32tpuPELk2kNk9Tp6Ny/9xqY+JdEOL6JvtCU=;
 b=o1vjpsdkSP0unJdwS+sj1Ir0Qzm0O7G7sanCQZKh4IrQLg4lSf8nbOXA3gLnNOel01nK
 rh2uQJ3jQd76ZFXQwIFMaxCyVk5wRF1WB3TBiKjm3nqdxHdNbq89TsMqC7G6IJCMDBK/
 9mytxpleDyAbKl4lSRevTwDj17heQpnXw9g= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2x01dfr93t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 21:21:09 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 18 Dec 2019 21:21:08 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1BFC22EC1869; Wed, 18 Dec 2019 21:21:05 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: fix another __u64 printf warning
Date:   Wed, 18 Dec 2019 21:21:03 -0800
Message-ID: <20191219052103.3515-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_08:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 spamscore=0 adultscore=0 impostorscore=0 suspectscore=8 mlxlogscore=999
 malwarescore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190042
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix yet another printf warning for %llu specifier on ppc64le. This time size_t
casting won't work, so cast to verbose `unsigned long long`.

Fixes: 166750bc1dd2 ("libbpf: Support libbpf-provided extern variables")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6340b81b555b..e5a6b07060fb 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1129,12 +1129,12 @@ static int set_ext_value_num(struct extern_desc *ext, void *ext_val,
 {
 	if (ext->type != EXT_INT && ext->type != EXT_CHAR) {
 		pr_warn("extern %s=%llu should be integer\n",
-			ext->name, value);
+			ext->name, (unsigned long long)value);
 		return -EINVAL;
 	}
 	if (!is_ext_value_in_range(ext, value)) {
 		pr_warn("extern %s=%llu value doesn't fit in %d bytes\n",
-			ext->name, value, ext->sz);
+			ext->name, (unsigned long long)value, ext->sz);
 		return -ERANGE;
 	}
 	switch (ext->sz) {
-- 
2.17.1

