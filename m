Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7385E249231
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgHSBO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:14:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21656 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726890AbgHSBO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 21:14:57 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J1DW84018300
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 18:14:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=/uUFrz2pplyNeuzwjVTtdWHekCwyi/O0CKqPnUBAh2Y=;
 b=A08HzhhPElIP8ar1HUd6SO3WoFR2zWYS304bUD3/iGH7tq16rHT9X+6i+bNksEqKJLBo
 tPJNPbLzpcBnIor4xYyEYi7riZWFWYvmcvYY3NG7BEl+DYk4GgNICA273F6w3AuMIU+L
 3tXb3CcQoiPSbZxSgxn7eetJn3yu2L3kzDc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304kpp0ep-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 18:14:56 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 18:14:54 -0700
Received: by devbig218.frc2.facebook.com (Postfix, from userid 116055)
        id 4079D207458; Tue, 18 Aug 2020 18:14:50 -0700 (PDT)
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
Subject: [PATCH bpf] bpf: verifier: check for packet data access based on target prog
Date:   Tue, 18 Aug 2020 18:12:44 -0700
Message-ID: <20200819011244.2027725-1-udippant@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_16:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 malwarescore=0 mlxlogscore=880
 lowpriorityscore=0 suspectscore=0 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190010
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

