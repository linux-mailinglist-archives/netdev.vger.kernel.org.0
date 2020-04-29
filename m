Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C804F1BD1B0
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgD2BV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:21:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52320 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726587AbgD2BVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 21:21:55 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T1LotG022109
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=O7oe9qY/VuM9IT4PFCy6MtNL3wEAsmXbiqUvjEatFG4=;
 b=lI4u7d73MIt86z5kX6VYb0NyxxWOmZJRFpF2abhT3UVD617l9X7ZbIqoIuf7tjBMRVm/
 WNmf5/s9wOLfZ08Adrvmj1rg6FgNYmH9Z7s4Yr9zfUwzQlhQEJwrL9D/4X4lq2NOy6N5
 XekgHNPn1g/RWF4T9drWEvbn4gwykr8sZ5k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n5bxb87c-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:55 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 18:21:22 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id EA3122EC30E4; Tue, 28 Apr 2020 18:21:14 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 01/11] selftests/bpf: ensure test flavors use correct skeletons
Date:   Tue, 28 Apr 2020 18:21:01 -0700
Message-ID: <20200429012111.277390-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200429012111.277390-1-andriin@fb.com>
References: <20200429012111.277390-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=936 suspectscore=8 bulkscore=0 clxscore=1015 impostorscore=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290008
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that test runner flavors include their own skeletons from <flavor>=
/
directory. Previously, skeletons generated for no-flavor test_progs were =
used.
Apart from fixing correctness, this also makes it possible to compile onl=
y
flavors individually:

  $ make clean && make test_progs-no_alu32
  ... now succeeds ...

Fixes: 74b5a5968fe8 ("selftests/bpf: Replace test_progs and test_maps w/ =
general rule")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
index 4e654d41c7af..01c95f8278c7 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -324,7 +324,7 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:			\
 		      $(TRUNNER_BPF_SKELS)				\
 		      $$(BPFOBJ) | $(TRUNNER_OUTPUT)
 	$$(call msg,TEST-OBJ,$(TRUNNER_BINARY),$$@)
-	cd $$(@D) && $$(CC) $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
+	cd $$(@D) && $$(CC) -I. $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F=
)
=20
 $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 		       %.c						\
--=20
2.24.1

