Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41BF440FF6D
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 20:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242445AbhIQSbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 14:31:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22378 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242452AbhIQSbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 14:31:34 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HGQ7b7010813
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 11:30:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=/XZq3XANIDF98Hn2lbHJ7+XBRPZqQwz9YLnU+BTvmss=;
 b=lL3rcOTd19dL4WWEKYGv1/8KGjnuzTxGfHXywHEbiCq2arSlZS+b5PMqgYx2LxH7ac5I
 RhqShW0i7Nrgy8ejP91P/X2GtRDP7CPZtvs4P04PQMUhdx6/FJt5h3c65VqDiACyo/gV
 ImEKehbHVfnXsn2kY/EFH1+Tfw+t27Tb15U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3b4xhe0vcf-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 11:30:12 -0700
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 17 Sep 2021 11:30:06 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 953FE6BF3240; Fri, 17 Sep 2021 11:29:22 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v6 bpf-next 9/9] bpf: Clarify data_len param in bpf_snprintf and bpf_seq_printf comments
Date:   Fri, 17 Sep 2021 11:29:11 -0700
Message-ID: <20210917182911.2426606-10-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917182911.2426606-1-davemarchevsky@fb.com>
References: <20210917182911.2426606-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: ZTxi6sgJI9Gvvct1aq30ELIligEXiT9W
X-Proofpoint-ORIG-GUID: ZTxi6sgJI9Gvvct1aq30ELIligEXiT9W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_07,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 mlxlogscore=643 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109030001 definitions=main-2109170110
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the data_len in these two functions is a byte len of the preceding
u64 *data array, it must always be a multiple of 8. If this isn't the
case both helpers error out, so let's make the requirement explicit so
users don't need to infer it.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 include/uapi/linux/bpf.h       | 5 +++--
 tools/include/uapi/linux/bpf.h | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 98ca79a67937..6fc59d61937a 100644
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
index 98ca79a67937..6fc59d61937a 100644
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

