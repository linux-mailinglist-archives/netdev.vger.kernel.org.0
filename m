Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D21E27ACDD
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 13:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgI1LeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 07:34:09 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56238 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgI1Ldz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 07:33:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SBTxMd110752;
        Mon, 28 Sep 2020 11:33:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=qKJeAMjM6G/zEtxzVNVaDYjfycFYarZOBBJX/8TJ5W8=;
 b=KLBlsajl2ByvID6QdiqcTrZ9O/U25dbofWAWaC+SvAJYKeDJAqGCBrlyecRwXKxlRPr3
 NhOKlxo3+9WbNfKgv2ELjCwNaBM6/T8J5FykNk64GT4BoFRs+hDtZlgP0GZQE3OQkoaW
 gzskHxxdWzUawBZpdKep3/+sBHMLRIaLDC2IIslWo1xxuatSdJcpAphqUehwgnRWHddj
 2Dfaruc2UCKjCS/52wsvq4eOI/2yq22mn9D3Pel+ysQGpH4Eb15cxiF7f0fEHfGMnSyL
 faLHA1AgReDB6nHnSLlm/ZWbKcUy+VXs+C2dpd1A9eZv2ZsFH5tEn/A0RQPEuXVEtF12 0w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33su5amhna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 11:33:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SBTebf020384;
        Mon, 28 Sep 2020 11:33:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33tfjuu2xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 11:33:16 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08SBXErl009444;
        Mon, 28 Sep 2020 11:33:14 GMT
Received: from localhost.uk.oracle.com (/10.175.167.231)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 04:33:14 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com
Cc:     linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, acme@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v7 bpf-next 6/8] selftests/bpf: fix overflow tests to reflect iter size increase
Date:   Mon, 28 Sep 2020 12:31:08 +0100
Message-Id: <1601292670-1616-7-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601292670-1616-1-git-send-email-alan.maguire@oracle.com>
References: <1601292670-1616-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=2
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf iter size increase to PAGE_SIZE << 3 means overflow tests assuming
page size need to be bumped also.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index fe1a83b9..ad9de13 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -352,7 +352,7 @@ static void test_overflow(bool test_e2big_overflow, bool ret1)
 	struct bpf_map_info map_info = {};
 	struct bpf_iter_test_kern4 *skel;
 	struct bpf_link *link;
-	__u32 page_size;
+	__u32 iter_size;
 	char *buf;
 
 	skel = bpf_iter_test_kern4__open();
@@ -374,19 +374,19 @@ static void test_overflow(bool test_e2big_overflow, bool ret1)
 		  "map_creation failed: %s\n", strerror(errno)))
 		goto free_map1;
 
-	/* bpf_seq_printf kernel buffer is one page, so one map
+	/* bpf_seq_printf kernel buffer is 8 pages, so one map
 	 * bpf_seq_write will mostly fill it, and the other map
 	 * will partially fill and then trigger overflow and need
 	 * bpf_seq_read restart.
 	 */
-	page_size = sysconf(_SC_PAGE_SIZE);
+	iter_size = sysconf(_SC_PAGE_SIZE) << 3;
 
 	if (test_e2big_overflow) {
-		skel->rodata->print_len = (page_size + 8) / 8;
-		expected_read_len = 2 * (page_size + 8);
+		skel->rodata->print_len = (iter_size + 8) / 8;
+		expected_read_len = 2 * (iter_size + 8);
 	} else if (!ret1) {
-		skel->rodata->print_len = (page_size - 8) / 8;
-		expected_read_len = 2 * (page_size - 8);
+		skel->rodata->print_len = (iter_size - 8) / 8;
+		expected_read_len = 2 * (iter_size - 8);
 	} else {
 		skel->rodata->print_len = 1;
 		expected_read_len = 2 * 8;
-- 
1.8.3.1

