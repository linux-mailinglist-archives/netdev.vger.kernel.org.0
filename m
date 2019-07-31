Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339797D078
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731122AbfGaWLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:11:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26912 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726073AbfGaWLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:11:00 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6VM48Jx013403
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 15:10:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=4NMDrjStOiGLjloTnwopH1NcqDKSobPNHxEkFaEx/xM=;
 b=kgEk8qkomCpWVg0kvNVtDxlXD/Ne+c70U3poznG0bFretAg8//cTsmiz799MFyNMR4Au
 KNwozTYuDY8Up3IcVifpa+FF7MWilS3RwLZ73tZ1klC1HLrK7mEoSnNnsOTUCgVpDAd+
 AQiXp408NgKnyJzXCTcBAg2u59E+9Y8cohI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u3cumsm76-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 15:10:58 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 31 Jul 2019 15:10:57 -0700
Received: by devvm6270.prn2.facebook.com (Postfix, from userid 153359)
        id AFC3815FC578A; Wed, 31 Jul 2019 15:10:56 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Takshak Chahande <ctakshak@fb.com>
Smtp-Origin-Hostname: devvm6270.prn2.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <rdna@fb.com>,
        <ctakshak@fb.com>, <kernel-team@fb.com>, <hechaol@fb.com>,
        <jakub.kicinski@netronome.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf v2] libbpf : make libbpf_num_possible_cpus function thread safe
Date:   Wed, 31 Jul 2019 15:10:55 -0700
Message-ID: <20190731221055.1478201-1-ctakshak@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=919 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310221
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Having static variable `cpus` in libbpf_num_possible_cpus function
without guarding it with mutex makes this function thread-unsafe.

If multiple threads accessing this function, in the current form; it
leads to incrementing the static variable value `cpus` in the multiple
of total available CPUs.

Used local stack variable to calculate the number of possible CPUs and
then updated the static variable using WRITE_ONCE().

Changes since v1:
 * added stack variable to calculate cpus
 * serialized static variable update using WRITE_ONCE()
 * fixed Fixes tag

Fixes: 6446b3155521 ("bpf: add a new API libbpf_num_possible_cpus()")
Signed-off-by: Takshak Chahande <ctakshak@fb.com>
---
 tools/lib/bpf/libbpf.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6718d0b90130..2e84fa5b8479 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4995,13 +4995,15 @@ int libbpf_num_possible_cpus(void)
 	static const char *fcpu = "/sys/devices/system/cpu/possible";
 	int len = 0, n = 0, il = 0, ir = 0;
 	unsigned int start = 0, end = 0;
+	int tmp_cpus = 0;
 	static int cpus;
 	char buf[128];
 	int error = 0;
 	int fd = -1;
 
-	if (cpus > 0)
-		return cpus;
+	tmp_cpus = READ_ONCE(cpus);
+	if (tmp_cpus > 0)
+		return tmp_cpus;
 
 	fd = open(fcpu, O_RDONLY);
 	if (fd < 0) {
@@ -5024,7 +5026,7 @@ int libbpf_num_possible_cpus(void)
 	}
 	buf[len] = '\0';
 
-	for (ir = 0, cpus = 0; ir <= len; ir++) {
+	for (ir = 0, tmp_cpus = 0; ir <= len; ir++) {
 		/* Each sub string separated by ',' has format \d+-\d+ or \d+ */
 		if (buf[ir] == ',' || buf[ir] == '\0') {
 			buf[ir] = '\0';
@@ -5036,13 +5038,15 @@ int libbpf_num_possible_cpus(void)
 			} else if (n == 1) {
 				end = start;
 			}
-			cpus += end - start + 1;
+			tmp_cpus += end - start + 1;
 			il = ir + 1;
 		}
 	}
-	if (cpus <= 0) {
-		pr_warning("Invalid #CPUs %d from %s\n", cpus, fcpu);
+	if (tmp_cpus <= 0) {
+		pr_warning("Invalid #CPUs %d from %s\n", tmp_cpus, fcpu);
 		return -EINVAL;
 	}
-	return cpus;
+
+	WRITE_ONCE(cpus, tmp_cpus);
+	return tmp_cpus;
 }
-- 
2.17.1

