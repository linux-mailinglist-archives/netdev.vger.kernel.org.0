Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB69E447CC
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbfFMRBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:01:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47224 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729544AbfFLXY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 19:24:27 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CNIfWw007878
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 16:24:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=G9Qvn4W0vyFE+eSObH1gaAkGjLJ6ViJzH32ICMKUTDU=;
 b=NZEyrE5YJuKlfsmfehUC7uEj+LeTxwapGxvRLVF6mMvt4abN+PEDZfnV0tOswUkCAbO9
 eUM94MU9p7yGzyQ8HI+uv7LnBHRHdBiC/GmHew684v+fjjFaVwOuViZopjl4A4oeok1s
 jwBSCfPqwpy7SD4wD4IDlKhjEoZIUA3BIoE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t37588ud6-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 16:24:25 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 12 Jun 2019 16:24:23 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 96EF3294308C; Wed, 12 Jun 2019 16:24:18 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 3/3] bpf: Add test for SO_REUSEPORT_DETACH_BPF
Date:   Wed, 12 Jun 2019 16:24:18 -0700
Message-ID: <20190612232418.3197297-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190612232412.3196844-1-kafai@fb.com>
References: <20190612232412.3196844-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=897 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a test for the new sockopt SO_REUSEPORT_DETACH_BPF.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../selftests/bpf/test_select_reuseport.c     | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_select_reuseport.c b/tools/testing/selftests/bpf/test_select_reuseport.c
index 75646d9b34aa..7566c13eb51a 100644
--- a/tools/testing/selftests/bpf/test_select_reuseport.c
+++ b/tools/testing/selftests/bpf/test_select_reuseport.c
@@ -523,6 +523,58 @@ static void test_pass_on_err(int type, sa_family_t family)
 	printf("OK\n");
 }
 
+static void test_detach_bpf(int type, sa_family_t family)
+{
+#ifdef SO_DETACH_REUSEPORT_BPF
+	__u32 nr_run_before = 0, nr_run_after = 0, tmp, i;
+	struct epoll_event ev;
+	int cli_fd, err, nev;
+	struct cmd cmd = {};
+	int optvalue = 0;
+
+	printf("%s: ", __func__);
+	err = setsockopt(sk_fds[0], SOL_SOCKET, SO_DETACH_REUSEPORT_BPF,
+			 &optvalue, sizeof(optvalue));
+	CHECK(err == -1, "setsockopt(SO_DETACH_REUSEPORT_BPF)",
+	      "err:%d errno:%d\n", err, errno);
+
+	err = setsockopt(sk_fds[1], SOL_SOCKET, SO_DETACH_REUSEPORT_BPF,
+			 &optvalue, sizeof(optvalue));
+	CHECK(err == 0 || errno != ENOENT, "setsockopt(SO_DETACH_REUSEPORT_BPF)",
+	      "err:%d errno:%d\n", err, errno);
+
+	for (i = 0; i < NR_RESULTS; i++) {
+		err = bpf_map_lookup_elem(result_map, &i, &tmp);
+		CHECK(err == -1, "lookup_elem(result_map)",
+		      "i:%u err:%d errno:%d\n", i, err, errno);
+		nr_run_before += tmp;
+	}
+
+	cli_fd = send_data(type, family, &cmd, sizeof(cmd), PASS);
+	nev = epoll_wait(epfd, &ev, 1, 5);
+	CHECK(nev <= 0, "nev <= 0",
+	      "nev:%d expected:1 type:%d family:%d data:(0, 0)\n",
+	      nev,  type, family);
+
+	for (i = 0; i < NR_RESULTS; i++) {
+		err = bpf_map_lookup_elem(result_map, &i, &tmp);
+		CHECK(err == -1, "lookup_elem(result_map)",
+		      "i:%u err:%d errno:%d\n", i, err, errno);
+		nr_run_after += tmp;
+	}
+
+	CHECK(nr_run_before != nr_run_after,
+	      "nr_run_before != nr_run_after",
+	      "nr_run_before:%u nr_run_after:%u\n",
+	      nr_run_before, nr_run_after);
+
+	printf("OK\n");
+	close(cli_fd);
+#else
+	printf("%s: SKIP\n", __func__);
+#endif
+}
+
 static void prepare_sk_fds(int type, sa_family_t family, bool inany)
 {
 	const int first = REUSEPORT_ARRAY_SIZE - 1;
@@ -664,6 +716,8 @@ static void test_all(void)
 			test_pass(type, family);
 			test_syncookie(type, family);
 			test_pass_on_err(type, family);
+			/* Must be the last test */
+			test_detach_bpf(type, family);
 
 			cleanup_per_test();
 			printf("\n");
-- 
2.17.1

