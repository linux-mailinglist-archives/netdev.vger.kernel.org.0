Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F35834E0C1
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 07:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhC3FmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 01:42:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59198 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229655AbhC3FmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 01:42:03 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12U5eO19019655
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 22:42:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Ckb/t8HLOhQeh/gP+l083YGJiGPyGN/hZJf+6trd9jc=;
 b=YNF8T+nx/3gqWbMo1cePMpkFM1vAty7PMQNY0qfaBdhD54cqHiiAms3gh9bgVpWXS6FW
 3CT2obMAKZD+LLqbOvVRZfVcmTZgwv5RcyzxZYwHf4biku2oBrIiHF65kQxL+rOKGDOE
 0jvwqsRqBLOHDcuAmgbLlDIrYnMsHUc4TTA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37kcfndk1s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 22:42:02 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 22:42:01 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 13B932942D2F; Mon, 29 Mar 2021 22:41:50 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 1/2] bpf: Update bpf_design_QA.rst to clarify the kfunc call is not ABI
Date:   Mon, 29 Mar 2021 22:41:50 -0700
Message-ID: <20210330054150.2933542-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330054143.2932947-1-kafai@fb.com>
References: <20210330054143.2932947-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Or--yeQn65HbEBimuTvd_9LPbn1_xsuK
X-Proofpoint-ORIG-GUID: Or--yeQn65HbEBimuTvd_9LPbn1_xsuK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_01:2021-03-26,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=701 impostorscore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300040
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch updates bpf_design_QA.rst to clarify that the kernel
function callable by bpf program is not an ABI.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 Documentation/bpf/bpf_design_QA.rst | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_=
design_QA.rst
index 0e15f9b05c9d..437de2a7a5de 100644
--- a/Documentation/bpf/bpf_design_QA.rst
+++ b/Documentation/bpf/bpf_design_QA.rst
@@ -258,3 +258,18 @@ Q: Can BPF functionality such as new program or map =
types, new
 helpers, etc be added out of kernel module code?
=20
 A: NO.
+
+Q: Directly calling kernel function is an ABI?
+----------------------------------------------
+Q: Some kernel functions (e.g. tcp_slow_start) can be called
+by BPF programs.  Do these kernel functions become an ABI?
+
+A: NO.
+
+The kernel function protos will change and the bpf programs will be
+rejected by the verifier.  Also, for example, some of the bpf-callable
+kernel functions have already been used by other kernel tcp
+cc (congestion-control) implementations.  If any of these kernel
+functions has changed, both the in-tree and out-of-tree kernel tcp cc
+implementations have to be changed.  The same goes for the bpf
+programs and they have to be adjusted accordingly.
--=20
2.30.2

