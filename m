Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BCD42987B
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 22:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbhJKU42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 16:56:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16720 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233216AbhJKU42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 16:56:28 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BI7NG4011658
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 13:54:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=gKOdMROmTro6c+ERGjXdSCze6aoR0BHv8Ac76sJcNx8=;
 b=iQImAjxJ8K7h20GOl1H6BffJnIBGE0R6RN5iKutp0LhVw+TzKEc2CA/MtP3ockvs3xWk
 epUOnDPeXeKHwLoBNfSazSQaOfMwFuG4x5Y9JszO++T6mCk0IOwhWkGQLGpf2nstzveD
 1fr73Ac029k0tqMtmSRVYIfdj/A74BbkZCI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bmhwums9a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 13:54:27 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 11 Oct 2021 13:54:21 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id C52137E37709; Mon, 11 Oct 2021 13:54:16 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v2 bpf-next 0/2] bpf: keep track of verifier insn_processed
Date:   Mon, 11 Oct 2021 13:54:13 -0700
Message-ID: <20211011205415.234479-1-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: 93TV1I3IOdayfTmW_bQWtyZabPasye3H
X-Proofpoint-ORIG-GUID: 93TV1I3IOdayfTmW_bQWtyZabPasye3H
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-11_10,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 lowpriorityscore=0
 mlxlogscore=543 suspectscore=0 impostorscore=0 malwarescore=0 mlxscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110119
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

v1->v2:
  * Rename uapi field from insn_processed to verified_insns [Daniel]
  * use 31 bits of existing bitfield space in bpf_prog_info [Daniel]
  * change underlying type from 64-> 32 bits [Daniel]

Dave Marchevsky (2):
  bpf: add verified_insns to bpf_prog_info and fdinfo
  selftests/bpf: add verif_stats test

 include/linux/bpf.h                           |  1 +
 include/uapi/linux/bpf.h                      |  2 +-
 kernel/bpf/syscall.c                          |  8 +++--
 kernel/bpf/verifier.c                         |  1 +
 tools/include/uapi/linux/bpf.h                |  2 +-
 .../selftests/bpf/prog_tests/verif_stats.c    | 31 +++++++++++++++++++
 6 files changed, 41 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verif_stats.c

--=20
2.30.2

