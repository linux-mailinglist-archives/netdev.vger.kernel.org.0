Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDCFA24C928
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 02:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgHUA20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 20:28:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7860 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726701AbgHUA2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 20:28:24 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07L0Od3w005557
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 17:28:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=/uUFrz2pplyNeuzwjVTtdWHekCwyi/O0CKqPnUBAh2Y=;
 b=hOOAhYdUEg3OBsjRRyxwaFCjD/1f33nWqNGHwOPPwGn1LM6auWEGD2Q5necwVsEYsPO4
 q498YGj0CaRMsctVXPRxRJj0h7vfVR8I+1QavTnNHFq973PtO7eeTykkAizUNG+kLgo2
 TaOyb0keev+lbBQlY3GlyP1m6RZ0EdUzEw8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 331hcbwgnc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 17:28:23 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 17:28:14 -0700
Received: by devbig218.frc2.facebook.com (Postfix, from userid 116055)
        id 14363207539; Thu, 20 Aug 2020 17:28:14 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Udip Pant <udippant@fb.com>
Smtp-Origin-Hostname: devbig218.frc2.facebook.com
To:     Udip Pant <udippant@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Smtp-Origin-Cluster: frc2c02
Subject: [PATCH v2 bpf 1/2] bpf: verifier: check for packet data access based on target prog
Date:   Thu, 20 Aug 2020 17:28:03 -0700
Message-ID: <20200821002804.546826-1-udippant@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_07:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 bulkscore=0
 mlxlogscore=940 lowpriorityscore=0 phishscore=0 impostorscore=0
 adultscore=0 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008210002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While using dynamic program extension (of type BPF_PROG_TYPE_EXT), we
need to check the program type of the target program to grant the read /
write access to the packet data.

The BPF_PROG_TYPE_EXT type can be used to extend types such as XDP, SKB
and others. Since the BPF_PROG_TYPE_EXT program type on itself is just a
placeholder for those, we need this extended check for those target
programs to actually work while using this option.

Tested this with a freplace xdp program. Without this patch, the
verifier fails with error 'cannot write into packet'.

Signed-off-by: Udip Pant <udippant@fb.com>
---
 kernel/bpf/verifier.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ef938f17b944..4d7604430994 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2629,7 +2629,11 @@ static bool may_access_direct_pkt_data(struct bpf_=
verifier_env *env,
 				       const struct bpf_call_arg_meta *meta,
 				       enum bpf_access_type t)
 {
-	switch (env->prog->type) {
+	struct bpf_prog *prog =3D env->prog;
+	enum bpf_prog_type prog_type =3D prog->aux->linked_prog ?
+	      prog->aux->linked_prog->type : prog->type;
+
+	switch (prog_type) {
 	/* Program types only with direct read access go here! */
 	case BPF_PROG_TYPE_LWT_IN:
 	case BPF_PROG_TYPE_LWT_OUT:
--=20
2.24.1

