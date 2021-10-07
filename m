Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFD9424EC1
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 10:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240553AbhJGIMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 04:12:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5216 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240459AbhJGIMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 04:12:01 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1975NAK4020575
        for <netdev@vger.kernel.org>; Thu, 7 Oct 2021 01:10:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=xDDbffhL6iyameOuKpEhS1si7HZrZXbnA9ZTB4pAQ10=;
 b=azeeNUVsSxDAMm+5S4K1lNnFLBrD2QXDzfznY2cx57k0KlOQvi9pU5xiKtVxThQthqtC
 Oa3TkAuL1d/GDYSPJ9/A+DC6tJTnJ2UE6fEfQW9iEFH30t3w34a10Kwr9Jbp4hMyt6GU
 e01pRGNEG+ozDDrpzpuhoziNZGoDv+UL+eg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bhe6qegd3-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 01:10:08 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 7 Oct 2021 01:09:59 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id CEB8C7AA998B; Thu,  7 Oct 2021 01:09:57 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH bpf-next 0/2] bpf: keep track of verifier insn_processed
Date:   Thu, 7 Oct 2021 01:09:50 -0700
Message-ID: <20211007080952.1255615-1-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: k6s_lXDlFExT2k9DFxFUGWracDAp1Uuy
X-Proofpoint-GUID: k6s_lXDlFExT2k9DFxFUGWracDAp1Uuy
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=457 adultscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 impostorscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070055
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a followup to discussion around RFC patchset "bpf: keep track of
prog verification stats" [0]. The RFC elaborates on my usecase, but to
summarize: keeping track of verifier stats for programs as they - and
the kernels they run on - change over time can help developers of
individual programs and BPF kernel folks.

The RFC added a verif_stats to the uapi which contained most of the info
which verifier prints currently. Feedback here was to avoid polluting
uapi with stats that might be meaningless after major changes to the
verifier, but that insn_processed or conceptually similar number would
exist in the long term and was safe to expose.

So let's expose just insn_processed via bpf_prog_info and fdinfo for now
and explore good ways of getting more complicated stats in the future.

[0] https://lore.kernel.org/bpf/20210920151112.3770991-1-davemarchevsky@fb.=
com/

Dave Marchevsky (2):
  bpf: add insn_processed to bpf_prog_info and fdinfo
  selftests/bpf: add verif_stats test

 include/linux/bpf.h                           |  1 +
 include/uapi/linux/bpf.h                      |  1 +
 kernel/bpf/syscall.c                          |  8 +++--
 kernel/bpf/verifier.c                         |  1 +
 tools/include/uapi/linux/bpf.h                |  1 +
 .../selftests/bpf/prog_tests/verif_stats.c    | 31 +++++++++++++++++++
 6 files changed, 41 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verif_stats.c

--=20
2.30.2

