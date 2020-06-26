Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3FA20B7A7
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgFZRzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:55:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65230 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726469AbgFZRzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:55:46 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QHoVW8020136
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:55:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=mdkDI6VlZsq6qN2AouCHjmdJu7QYRc0tUiHGxSLroYM=;
 b=dmZaXcGu8DYRwgUSC9OJ6yHALJC0gkMqPwZwWdn4O5ow5OwxntufTa6ISgliTBQXOVzX
 vnPtDNFxANiH2/25CbwmTpVWqlrS5C1Sj8vlD2ISnMvmHznkHo8PZM1gG1gS7s2ZldPW
 x7zEm5Xi8j6h7Ml1+5p+avY8w5jTH5otisE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31w3w2mbku-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:55:46 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 10:55:44 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 76E072942E38; Fri, 26 Jun 2020 10:55:39 -0700 (PDT)
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
Subject: [PATCH bpf-next 06/10] bpf: selftests: Add fastopen_connect to network_helpers
Date:   Fri, 26 Jun 2020 10:55:39 -0700
Message-ID: <20200626175539.1461894-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200626175501.1459961-1-kafai@fb.com>
References: <20200626175501.1459961-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_09:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015
 suspectscore=13 mlxlogscore=999 cotscore=-2147483648 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260126
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
index 1a371d3eca7d..93028f0d4081 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -125,6 +125,43 @@ int start_server(int family, int type, const char *a=
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
index f580e82fda58..c4827941327a 100644
--- a/tools/testing/selftests/bpf/network_helpers.h
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -37,5 +37,7 @@ int start_server(int family, int type, const char *addr=
, __u16 port,
 		 int timeout_ms);
 int connect_to_fd(int server_fd, int timeout_ms);
 int connect_fd_to_fd(int client_fd, int server_fd, int timeout_ms);
+int fastopen_connect(int server_fd, const char *data, unsigned int data_=
len,
+		     int timeout_ms);
=20
 #endif
--=20
2.24.1

