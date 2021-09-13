Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E29408343
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 05:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238603AbhIMD6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 23:58:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32322 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238590AbhIMD5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 23:57:52 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.0.43) with SMTP id 18C4guSr018729
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 20:56:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=aVvCBRYxYd6m9pV4eMyjyxbOut6tvyKb0b7ms65PCy8=;
 b=avN5kr5dUuoxLCx3ddrefoJXI3Tay+VmoPffdhHilL+xsQDmpCYuvkCFCcTcbbGfj7zb
 VBgi133VrgbLmAUweIU8xsz8LMb0UDdjDy3FqMBkVYV5OPXD3uqCz0DOBAIc8X4JwmM4
 VVTMIWAIV7V4m0dnDPTJioRHVMUKBdEF7as= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3b0r4u7mrq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 20:56:36 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Sun, 12 Sep 2021 20:56:35 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id B5A436823523; Sun, 12 Sep 2021 20:56:33 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v5 bpf-next 9/9] bpf: clarify data_len param in bpf_snprintf and bpf_seq_printf comments
Date:   Sun, 12 Sep 2021 20:56:09 -0700
Message-ID: <20210913035609.160722-10-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913035609.160722-1-davemarchevsky@fb.com>
References: <20210913035609.160722-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: tJ8Hoxva8ZG1uKrbyqF4tLit3V72nJsl
X-Proofpoint-ORIG-GUID: tJ8Hoxva8ZG1uKrbyqF4tLit3V72nJsl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_02,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 spamscore=0 impostorscore=0 phishscore=0
 mlxscore=0 suspectscore=0 clxscore=1015 mlxlogscore=654 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130025
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the data_len in these two functions is a byte len of the preceding
u64 *data array, it must always be a multiple of 8. If this isn't the
case both helpers error out, so let's make the requirement explicit so
users don't need to infer it.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
---
 include/uapi/linux/bpf.h       | 5 +++--
 tools/include/uapi/linux/bpf.h | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 1852ca9dbc63..f47d4b4db795 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4046,7 +4046,7 @@ union bpf_attr {
  * 		arguments. The *data* are a **u64** array and corresponding format =
string
  * 		values are stored in the array. For strings and pointers where poin=
tees
  * 		are accessed, only the pointer values are stored in the *data* arra=
y.
- * 		The *data_len* is the size of *data* in bytes.
+ * 		The *data_len* is the size of *data* in bytes - must be a multiple =
of 8.
  *
  *		Formats **%s**, **%p{i,I}{4,6}** requires to read kernel memory.
  *		Reading kernel memory may fail due to either invalid address or
@@ -4751,7 +4751,8 @@ union bpf_attr {
  *		Each format specifier in **fmt** corresponds to one u64 element
  *		in the **data** array. For strings and pointers where pointees
  *		are accessed, only the pointer values are stored in the *data*
- *		array. The *data_len* is the size of *data* in bytes.
+ *		array. The *data_len* is the size of *data* in bytes - must be
+ *		a multiple of 8.
  *
  *		Formats **%s** and **%p{i,I}{4,6}** require to read kernel
  *		memory. Reading kernel memory may fail due to either invalid
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 1852ca9dbc63..f47d4b4db795 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4046,7 +4046,7 @@ union bpf_attr {
  * 		arguments. The *data* are a **u64** array and corresponding format =
string
  * 		values are stored in the array. For strings and pointers where poin=
tees
  * 		are accessed, only the pointer values are stored in the *data* arra=
y.
- * 		The *data_len* is the size of *data* in bytes.
+ * 		The *data_len* is the size of *data* in bytes - must be a multiple =
of 8.
  *
  *		Formats **%s**, **%p{i,I}{4,6}** requires to read kernel memory.
  *		Reading kernel memory may fail due to either invalid address or
@@ -4751,7 +4751,8 @@ union bpf_attr {
  *		Each format specifier in **fmt** corresponds to one u64 element
  *		in the **data** array. For strings and pointers where pointees
  *		are accessed, only the pointer values are stored in the *data*
- *		array. The *data_len* is the size of *data* in bytes.
+ *		array. The *data_len* is the size of *data* in bytes - must be
+ *		a multiple of 8.
  *
  *		Formats **%s** and **%p{i,I}{4,6}** require to read kernel
  *		memory. Reading kernel memory may fail due to either invalid
--=20
2.30.2

