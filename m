Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B62E6A6D9
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 12:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733303AbfGPK4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 06:56:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20078 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733037AbfGPK4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 06:56:49 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6GArVTx020876
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 06:56:47 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tsbmkmf1g-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 06:56:47 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Tue, 16 Jul 2019 11:56:45 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 16 Jul 2019 11:56:42 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6GAufMr56033436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 10:56:41 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 583A411C052;
        Tue, 16 Jul 2019 10:56:41 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 191EC11C054;
        Tue, 16 Jul 2019 10:56:41 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.96.205])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Jul 2019 10:56:41 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     gor@linux.ibm.com, heiko.carstens@de.ibm.com,
        andrii.nakryiko@gmail.com, ys114321@gmail.com,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH bpf v2] selftests/bpf: skip nmi test when perf hw events are disabled
Date:   Tue, 16 Jul 2019 12:56:34 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071610-0008-0000-0000-000002FDA41C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071610-0009-0000-0000-0000226B199E
Message-Id: <20190716105634.21827-1-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160137
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some setups (e.g. virtual machines) might run with hardware perf events
disabled. If this is the case, skip the test_send_signal_nmi test.

Add a separate test involving a software perf event. This allows testing
the perf event path regardless of hardware perf event support.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---

v1->v2: Skip the test instead of using a software event.
Add a separate test with a software event.

 .../selftests/bpf/prog_tests/send_signal.c    | 33 ++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
index 67cea1686305..54218ee3c004 100644
--- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
+++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
@@ -173,6 +173,18 @@ static int test_send_signal_tracepoint(void)
 	return test_send_signal_common(&attr, BPF_PROG_TYPE_TRACEPOINT, "tracepoint");
 }
 
+static int test_send_signal_perf(void)
+{
+	struct perf_event_attr attr = {
+		.sample_period = 1,
+		.type = PERF_TYPE_SOFTWARE,
+		.config = PERF_COUNT_SW_CPU_CLOCK,
+	};
+
+	return test_send_signal_common(&attr, BPF_PROG_TYPE_PERF_EVENT,
+				       "perf_sw_event");
+}
+
 static int test_send_signal_nmi(void)
 {
 	struct perf_event_attr attr = {
@@ -181,8 +193,26 @@ static int test_send_signal_nmi(void)
 		.type = PERF_TYPE_HARDWARE,
 		.config = PERF_COUNT_HW_CPU_CYCLES,
 	};
+	int pmu_fd;
+
+	/* Some setups (e.g. virtual machines) might run with hardware
+	 * perf events disabled. If this is the case, skip this test.
+	 */
+	pmu_fd = syscall(__NR_perf_event_open, &attr, 0 /* pid */,
+			 -1 /* cpu */, -1 /* group_fd */, 0 /* flags */);
+	if (pmu_fd == -1) {
+		if (errno == ENOENT) {
+			printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n",
+				__func__);
+			return 0;
+		}
+		/* Let the test fail with a more informative message */
+	} else {
+		close(pmu_fd);
+	}
 
-	return test_send_signal_common(&attr, BPF_PROG_TYPE_PERF_EVENT, "perf_event");
+	return test_send_signal_common(&attr, BPF_PROG_TYPE_PERF_EVENT,
+				       "perf_hw_event");
 }
 
 void test_send_signal(void)
@@ -190,6 +220,7 @@ void test_send_signal(void)
 	int ret = 0;
 
 	ret |= test_send_signal_tracepoint();
+	ret |= test_send_signal_perf();
 	ret |= test_send_signal_nmi();
 	if (!ret)
 		printf("test_send_signal:OK\n");
-- 
2.21.0

