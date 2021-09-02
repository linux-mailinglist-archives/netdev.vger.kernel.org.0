Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AADE13FF235
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 19:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346592AbhIBRVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 13:21:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45526 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1346572AbhIBRVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 13:21:05 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 182HIvX8028222
        for <netdev@vger.kernel.org>; Thu, 2 Sep 2021 10:20:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=npoIg0hH/PLsSOOKa3cr7jFeeSikgJuTg/witRzt/oE=;
 b=gSw8AUc2OakjwjxyNO1SAauuKUGh7WFE4298DybfwAX01iiwhteM73hCe9b/YSqfjrTV
 rxZcAn0NiysK0mpukcPyzQTxtWE5jQ19aVCTPxrJf9olKYWfIzAWxaDlQLTNXTuEv25m
 dazGNNTklkQKzcDITiNC3c43d+8RDfPee6o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3atdyhdkv1-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 10:20:06 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 2 Sep 2021 10:20:04 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 5FD195FE24A6; Thu,  2 Sep 2021 10:20:03 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v4 bpf-next 6/9] bpftool: only probe trace_vprintk feature in 'full' mode
Date:   Thu, 2 Sep 2021 10:19:26 -0700
Message-ID: <20210902171929.3922667-7-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210902171929.3922667-1-davemarchevsky@fb.com>
References: <20210902171929.3922667-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: z8SGWyd04oBuToWUT46a6wmU-PZcyiAZ
X-Proofpoint-ORIG-GUID: z8SGWyd04oBuToWUT46a6wmU-PZcyiAZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-02_04:2021-09-02,2021-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 suspectscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109020100
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 368cb0e7cdb5e ("bpftool: Make probes which emit dmesg
warnings optional"), some helpers aren't probed by bpftool unless
`full` arg is added to `bpftool feature probe`.

bpf_trace_vprintk can emit dmesg warnings when probed, so include it.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
---
 tools/bpf/bpftool/feature.c                 |  1 +
 tools/testing/selftests/bpf/test_bpftool.py | 22 +++++++++------------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 7f36385aa9e2..ade44577688e 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -624,6 +624,7 @@ probe_helpers_for_progtype(enum bpf_prog_type prog_ty=
pe, bool supported_type,
 		 */
 		switch (id) {
 		case BPF_FUNC_trace_printk:
+		case BPF_FUNC_trace_vprintk:
 		case BPF_FUNC_probe_write_user:
 			if (!full_mode)
 				continue;
diff --git a/tools/testing/selftests/bpf/test_bpftool.py b/tools/testing/=
selftests/bpf/test_bpftool.py
index 4fed2dc25c0a..1c2408ee1f5d 100644
--- a/tools/testing/selftests/bpf/test_bpftool.py
+++ b/tools/testing/selftests/bpf/test_bpftool.py
@@ -57,6 +57,11 @@ def default_iface(f):
         return f(*args, iface, **kwargs)
     return wrapper
=20
+DMESG_EMITTING_HELPERS =3D [
+        "bpf_probe_write_user",
+        "bpf_trace_printk",
+        "bpf_trace_vprintk",
+    ]
=20
 class TestBpftool(unittest.TestCase):
     @classmethod
@@ -67,10 +72,7 @@ class TestBpftool(unittest.TestCase):
=20
     @default_iface
     def test_feature_dev_json(self, iface):
-        unexpected_helpers =3D [
-            "bpf_probe_write_user",
-            "bpf_trace_printk",
-        ]
+        unexpected_helpers =3D DMESG_EMITTING_HELPERS
         expected_keys =3D [
             "syscall_config",
             "program_types",
@@ -94,10 +96,7 @@ class TestBpftool(unittest.TestCase):
             bpftool_json(["feature", "probe"]),
             bpftool_json(["feature"]),
         ]
-        unexpected_helpers =3D [
-            "bpf_probe_write_user",
-            "bpf_trace_printk",
-        ]
+        unexpected_helpers =3D DMESG_EMITTING_HELPERS
         expected_keys =3D [
             "syscall_config",
             "system_config",
@@ -121,10 +120,7 @@ class TestBpftool(unittest.TestCase):
             bpftool_json(["feature", "probe", "kernel", "full"]),
             bpftool_json(["feature", "probe", "full"]),
         ]
-        expected_helpers =3D [
-            "bpf_probe_write_user",
-            "bpf_trace_printk",
-        ]
+        expected_helpers =3D DMESG_EMITTING_HELPERS
=20
         for tc in test_cases:
             # Check if expected helpers are included at least once in an=
y
@@ -157,7 +153,7 @@ class TestBpftool(unittest.TestCase):
                 not_full_set.add(helper)
=20
         self.assertCountEqual(full_set - not_full_set,
-                                {"bpf_probe_write_user", "bpf_trace_prin=
tk"})
+                              set(DMESG_EMITTING_HELPERS))
         self.assertCountEqual(not_full_set - full_set, set())
=20
     def test_feature_macros(self):
--=20
2.30.2

