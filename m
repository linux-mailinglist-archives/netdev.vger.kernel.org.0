Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 122F91A3D2C
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 02:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgDJAEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 20:04:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35096 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726858AbgDJAEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 20:04:35 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03A01DMk009487
        for <netdev@vger.kernel.org>; Thu, 9 Apr 2020 17:04:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=7itgDPBa4TxViCnoMzDPgvfwSjVu5ZS3d+23mIbwJqs=;
 b=P7MNauj5n8UmPFMvpVamWyoDmTVdV7KFu8nFMdpcVIWMD8xytq1wotQEd1Wc0iCkf6eN
 P+XejDBDIjQUYM7E0H5bmuiPEV6enlXkqKhIQ433oq7jrBaasn0/uDsR8SazAOLCB574
 j3g2BRSdHQlv8+b+tHiy00onTw+toDj9JOU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30a61ytudc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 17:04:35 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 9 Apr 2020 17:04:34 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6DB722EC31C4; Thu,  9 Apr 2020 17:04:32 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 2/2] selftests/bpf: validate frozen map contents stays frozen
Date:   Thu, 9 Apr 2020 17:04:25 -0700
Message-ID: <20200410000425.2597887-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200410000425.2597887-1-andriin@fb.com>
References: <20200410000425.2597887-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-09_09:2020-04-07,2020-04-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=8 lowpriorityscore=0 mlxlogscore=457 clxscore=1015
 malwarescore=0 impostorscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004090171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test that frozen and mmap()'ed BPF map can't be mprotect()'ed as writable=
 or
executable memory.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/mmap.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/mmap.c b/tools/testin=
g/selftests/bpf/prog_tests/mmap.c
index 16a814eb4d64..1cdb738346a5 100644
--- a/tools/testing/selftests/bpf/prog_tests/mmap.c
+++ b/tools/testing/selftests/bpf/prog_tests/mmap.c
@@ -140,6 +140,22 @@ void test_mmap(void)
 		goto cleanup;
 	}
=20
+	map_mmaped =3D mmap(NULL, map_sz, PROT_READ, MAP_SHARED, data_map_fd, 0=
);
+	if (CHECK(map_mmaped =3D=3D MAP_FAILED, "data_mmap",
+		  "data_map R/O mmap failed: %d\n", errno)) {
+		map_mmaped =3D NULL;
+		goto cleanup;
+	}
+	err =3D mprotect(map_mmaped, map_sz, PROT_WRITE);
+	if (CHECK(!err, "mprotect_wr", "mprotect() succeeded unexpectedly!\n"))
+		goto cleanup;
+	err =3D mprotect(map_mmaped, map_sz, PROT_EXEC);
+	if (CHECK(!err, "mprotect_ex", "mprotect() succeeded unexpectedly!\n"))
+		goto cleanup;
+	err =3D munmap(map_mmaped, map_sz);
+	CHECK_FAIL(err);
+	map_mmaped =3D NULL;
+
 	bss_data->in_val =3D 321;
 	usleep(1);
 	CHECK_FAIL(bss_data->in_val !=3D 321);
--=20
2.24.1

