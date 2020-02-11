Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E27B5159786
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 19:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731119AbgBKR7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 12:59:14 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59304 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728845AbgBKR7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 12:59:14 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01BHu1Gh002973
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 09:59:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=zBLUyVl7tED7mwHhxTDFIspZ3ahulNnkoOEM7Uu7GuU=;
 b=gLlmZ+igpU0j9VbMF8jTvX47fvzWDuZYoNzTLteUIQJBRh7iugeJQ8pRS+v12jCGchd4
 Bu+XeQbyNJhfkN9kLku+2sNJFb0qUc7cDcyEgvBNfT5MyTb2/L2X9DL0E+xsF6fQE/Za
 kJN040fSi+rhu9kvurkBr7Cuh0xDZ5MEsq8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2y3pq3ty8f-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 09:59:13 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 11 Feb 2020 09:59:12 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 5D5952941E15; Tue, 11 Feb 2020 09:59:10 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: selftests: Fix error checking on reading the tcp_fastopen sysctl
Date:   Tue, 11 Feb 2020 09:59:10 -0800
Message-ID: <20200211175910.3235321-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-11_05:2020-02-10,2020-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=13 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 clxscore=1015 phishscore=0 mlxlogscore=588
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002110125
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a typo in checking the "saved_tcp_fo" and instead
"saved_tcp_syncookie" is checked again.  This patch fixes it
and also breaks them into separate if statements such that
the test will abort asap.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/select_reuseport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
index 098bcae5f827..b577666d028e 100644
--- a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
+++ b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
@@ -822,8 +822,10 @@ void test_select_reuseport(void)
 		goto out;
 
 	saved_tcp_fo = read_int_sysctl(TCP_FO_SYSCTL);
+	if (saved_tcp_fo < 0)
+		goto out;
 	saved_tcp_syncookie = read_int_sysctl(TCP_SYNCOOKIE_SYSCTL);
-	if (saved_tcp_syncookie < 0 || saved_tcp_syncookie < 0)
+	if (saved_tcp_syncookie < 0)
 		goto out;
 
 	if (enable_fastopen())
-- 
2.17.1

