Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5696322A43E
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 03:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387530AbgGWBEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 21:04:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29302 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733293AbgGWBEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 21:04:24 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06N14Mfe017674
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 18:04:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=UaGrg376ho+N71KTFtfpuWAWmp3X4Uj39bSXGKpeilk=;
 b=jm90/17RI0+NlVRoDWvN2EcFGispDg1lZCwy4FNkZKsRdcl0ruIXAaDKGplJE7ej3kd3
 jERFTtswrsrATTo54bnB4Xyhcr0ElfR3DGFANNzVbaDcNkoXmR1XELdJZT5U8wmdl5qB
 hhVH3wpmBQwG/NdLBixN0OOqJPGqsAAXdQY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32embc3tqf-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 18:04:23 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Jul 2020 18:04:21 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 7CCE62945AD1; Wed, 22 Jul 2020 18:04:18 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 7/9] bpf: selftests: Add fastopen_connect to network_helpers
Date:   Wed, 22 Jul 2020 18:04:18 -0700
Message-ID: <20200723010418.1908667-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200723010334.1905574-1-kafai@fb.com>
References: <20200723010334.1905574-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_17:2020-07-22,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0 suspectscore=13
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230005
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a fastopen_connect() helper which will
be used in a latter test.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/network_helpers.c | 37 +++++++++++++++++++
 tools/testing/selftests/bpf/network_helpers.h |  2 +
 2 files changed, 39 insertions(+)

diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testin=
g/selftests/bpf/network_helpers.c
index f56655690f9b..12ee40284da0 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -104,6 +104,43 @@ int start_server(int family, int type, const char *a=
ddr_str, __u16 port,
 	return -1;
 }
=20
+int fastopen_connect(int server_fd, const char *data, unsigned int data_=
len,
+		     int timeout_ms)
+{
+	struct sockaddr_storage addr;
+	socklen_t addrlen =3D sizeof(addr);
+	struct sockaddr_in *addr_in;
+	int fd, ret;
+
+	if (getsockname(server_fd, (struct sockaddr *)&addr, &addrlen)) {
+		log_err("Failed to get server addr");
+		return -1;
+	}
+
+	addr_in =3D (struct sockaddr_in *)&addr;
+	fd =3D socket(addr_in->sin_family, SOCK_STREAM, 0);
+	if (fd < 0) {
+		log_err("Failed to create client socket");
+		return -1;
+	}
+
+	if (settimeo(fd, timeout_ms))
+		goto error_close;
+
+	ret =3D sendto(fd, data, data_len, MSG_FASTOPEN, (struct sockaddr *)&ad=
dr,
+		     addrlen);
+	if (ret !=3D data_len) {
+		log_err("sendto(data, %u) !=3D %d\n", data_len, ret);
+		goto error_close;
+	}
+
+	return fd;
+
+error_close:
+	save_errno_close(fd);
+	return -1;
+}
+
 static int connect_fd_to_addr(int fd,
 			      const struct sockaddr_storage *addr,
 			      socklen_t addrlen)
diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testin=
g/selftests/bpf/network_helpers.h
index c3728f6667e4..7205f8afdba1 100644
--- a/tools/testing/selftests/bpf/network_helpers.h
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -37,6 +37,8 @@ int start_server(int family, int type, const char *addr=
, __u16 port,
 		 int timeout_ms);
 int connect_to_fd(int server_fd, int timeout_ms);
 int connect_fd_to_fd(int client_fd, int server_fd, int timeout_ms);
+int fastopen_connect(int server_fd, const char *data, unsigned int data_=
len,
+		     int timeout_ms);
 int make_sockaddr(int family, const char *addr_str, __u16 port,
 		  struct sockaddr_storage *addr, socklen_t *len);
=20
--=20
2.24.1

