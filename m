Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A643523C2C2
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 02:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgHEAsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 20:48:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46110 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726210AbgHEAsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 20:48:07 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0750jNLI029513
        for <netdev@vger.kernel.org>; Tue, 4 Aug 2020 17:48:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=9YmiKWZC16HxfLQD28dGK/D+AbLfaoErcxHiHLvI3V8=;
 b=EC0D33O1V0L0rYoE+mMea6okInQrUTNlwj6gER+EhEykpqQGW8kT+kghsZuQgYj1A+1P
 ke20vkVPzv3hDZCrkCTWC6SR+HVSyWVBM86jpQQsMomMLazQbqInU0NPobBk6DE2t1Zq
 TSgGfVylHXSMKJ6ttP5kFK3jAQ117SWOjiA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32n81jqjqa-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 17:48:06 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 4 Aug 2020 17:48:04 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 792D62EC5301; Tue,  4 Aug 2020 17:47:59 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] selftests/bpf: prevent runqslower from racing on building bpftool
Date:   Tue, 4 Aug 2020 17:47:57 -0700
Message-ID: <20200805004757.2960750-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-04_04:2020-08-03,2020-08-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 suspectscore=8 lowpriorityscore=0 phishscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 priorityscore=1501 mlxlogscore=543
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008050005
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

runqslower's Makefile is building/installing bpftool into
$(OUTPUT)/sbin/bpftool, which coincides with $(DEFAULT_BPFTOOL). In pract=
ice
this means that often when building selftests from scratch (after `make
clean`), selftests are racing with runqslower to simultaneously build bpf=
tool
and one of the two processes fail due to file being busy. Prevent this ra=
ce by
explicitly order-depending on $(BPFTOOL_DEFAULT).

Fixes: a2c9652f751e ("selftests: Refactor build to remove tools/lib/bpf f=
rom include path")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
index e7a8cf83ba48..48425f9251b5 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -142,7 +142,9 @@ VMLINUX_BTF_PATHS ?=3D $(if $(O),$(O)/vmlinux)				\
 		     /boot/vmlinux-$(shell uname -r)
 VMLINUX_BTF ?=3D $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS)))=
)
=20
-$(OUTPUT)/runqslower: $(BPFOBJ)
+DEFAULT_BPFTOOL :=3D $(SCRATCH_DIR)/sbin/bpftool
+
+$(OUTPUT)/runqslower: $(BPFOBJ) | $(DEFAULT_BPFTOOL)
 	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower	\
 		    OUTPUT=3D$(SCRATCH_DIR)/ VMLINUX_BTF=3D$(VMLINUX_BTF)   \
 		    BPFOBJ=3D$(BPFOBJ) BPF_INCLUDE=3D$(INCLUDE_DIR) &&	\
@@ -164,7 +166,6 @@ $(OUTPUT)/test_netcnt: cgroup_helpers.c
 $(OUTPUT)/test_sock_fields: cgroup_helpers.c
 $(OUTPUT)/test_sysctl: cgroup_helpers.c
=20
-DEFAULT_BPFTOOL :=3D $(SCRATCH_DIR)/sbin/bpftool
 BPFTOOL ?=3D $(DEFAULT_BPFTOOL)
 $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefi=
le)    \
 		    $(BPFOBJ) | $(BUILD_DIR)/bpftool
--=20
2.24.1

