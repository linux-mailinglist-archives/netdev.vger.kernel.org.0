Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5EB5E328
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 13:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfGCLum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 07:50:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49966 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726490AbfGCLum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 07:50:42 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x63BlbnN142732
        for <netdev@vger.kernel.org>; Wed, 3 Jul 2019 07:50:41 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tgsu057ru-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 07:50:40 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Wed, 3 Jul 2019 12:50:38 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 3 Jul 2019 12:50:36 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x63BoZqh57409556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Jul 2019 11:50:35 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45634A4053;
        Wed,  3 Jul 2019 11:50:35 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F724A4040;
        Wed,  3 Jul 2019 11:50:35 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.98.248])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Jul 2019 11:50:35 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH bpf-next] selftests/bpf: fix test_reuseport_array on s390
Date:   Wed,  3 Jul 2019 13:50:34 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19070311-0020-0000-0000-0000034FCB2B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070311-0021-0000-0000-000021A361C6
Message-Id: <20190703115034.53984-1-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-03_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=674 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907030143
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix endianness issue: passing a pointer to 64-bit fd as a 32-bit key
does not work on big-endian architectures. So cast fd to 32-bits when
necessary.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 tools/testing/selftests/bpf/test_maps.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index a3fbc571280a..5443b9bd75ed 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -1418,7 +1418,7 @@ static void test_map_wronly(void)
 	assert(bpf_map_get_next_key(fd, &key, &value) == -1 && errno == EPERM);
 }
 
-static void prepare_reuseport_grp(int type, int map_fd,
+static void prepare_reuseport_grp(int type, int map_fd, size_t map_elem_size,
 				  __s64 *fds64, __u64 *sk_cookies,
 				  unsigned int n)
 {
@@ -1428,6 +1428,8 @@ static void prepare_reuseport_grp(int type, int map_fd,
 	const int optval = 1;
 	unsigned int i;
 	u64 sk_cookie;
+	void *value;
+	__s32 fd32;
 	__s64 fd64;
 	int err;
 
@@ -1449,8 +1451,14 @@ static void prepare_reuseport_grp(int type, int map_fd,
 		      "err:%d errno:%d\n", err, errno);
 
 		/* reuseport_array does not allow unbound sk */
-		err = bpf_map_update_elem(map_fd, &index0, &fd64,
-					  BPF_ANY);
+		if (map_elem_size == sizeof(__u64))
+			value = &fd64;
+		else {
+			assert(map_elem_size == sizeof(__u32));
+			fd32 = (__s32)fd64;
+			value = &fd32;
+		}
+		err = bpf_map_update_elem(map_fd, &index0, value, BPF_ANY);
 		CHECK(err != -1 || errno != EINVAL,
 		      "reuseport array update unbound sk",
 		      "sock_type:%d err:%d errno:%d\n",
@@ -1478,7 +1486,7 @@ static void prepare_reuseport_grp(int type, int map_fd,
 			 * reuseport_array does not allow
 			 * non-listening tcp sk.
 			 */
-			err = bpf_map_update_elem(map_fd, &index0, &fd64,
+			err = bpf_map_update_elem(map_fd, &index0, value,
 						  BPF_ANY);
 			CHECK(err != -1 || errno != EINVAL,
 			      "reuseport array update non-listening sk",
@@ -1541,7 +1549,7 @@ static void test_reuseport_array(void)
 	for (t = 0; t < ARRAY_SIZE(types); t++) {
 		type = types[t];
 
-		prepare_reuseport_grp(type, map_fd, grpa_fds64,
+		prepare_reuseport_grp(type, map_fd, sizeof(__u64), grpa_fds64,
 				      grpa_cookies, ARRAY_SIZE(grpa_fds64));
 
 		/* Test BPF_* update flags */
@@ -1649,7 +1657,8 @@ static void test_reuseport_array(void)
 				sizeof(__u32), sizeof(__u32), array_size, 0);
 	CHECK(map_fd == -1, "reuseport array create",
 	      "map_fd:%d, errno:%d\n", map_fd, errno);
-	prepare_reuseport_grp(SOCK_STREAM, map_fd, &fd64, &sk_cookie, 1);
+	prepare_reuseport_grp(SOCK_STREAM, map_fd, sizeof(__u32), &fd64,
+			      &sk_cookie, 1);
 	fd = fd64;
 	err = bpf_map_update_elem(map_fd, &index3, &fd, BPF_NOEXIST);
 	CHECK(err == -1, "reuseport array update 32 bit fd",
-- 
2.21.0

