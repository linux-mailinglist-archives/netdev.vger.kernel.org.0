Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A267A2A9FBF
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728685AbgKFWIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:08:06 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45296 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728594AbgKFWIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 17:08:05 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A6Lwom2014244
        for <netdev@vger.kernel.org>; Fri, 6 Nov 2020 14:08:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=Wgy1IYFmaJr062bGS4QL+FI9MGl4k8SGXjbDgz0DL9M=;
 b=JdDoRtqALH11QxH6NG+51dywUsW5NlA+FSyBV1KRrcgbtQwpEFgdjbOU0Ilmyx6jU8Ag
 qd+gJxJIsVImKorjbct/cB6R+8lubutCIPUB1L8wrvfnPdPgUGPTKDqJohIU7RGjiRP+
 qkyZ1QgpL/TYKRFzGofqaf/MXrkfy5HfjjE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34mr9ben9m-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 14:08:04 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 6 Nov 2020 14:08:02 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 04CF529463F7; Fri,  6 Nov 2020 14:07:50 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 0/3] bpf: Enable bpf_sk_storage for FENTRY/FEXIT/RAW_TP
Date:   Fri, 6 Nov 2020 14:07:50 -0800
Message-ID: <20201106220750.3949423-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=395
 suspectscore=13 mlxscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011060151
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set is to allow the FENTRY/FEXIT/RAW_TP tracing program to use
bpf_sk_storage.  The first patch is a cleanup.  The last patch is
tests.  The second patch has the required kernel changes to
enable bpf_sk_storage for FENTRY/FEXIT/RAW_TP.

Please see individual patch for details.

Martin KaFai Lau (3):
  bpf: Folding omem_charge() into sk_storage_charge()
  bpf: Allow using bpf_sk_storage in FENTRY/FEXIT/RAW_TP
  bpf: selftest: Use bpf_sk_storage in FENTRY/FEXIT/RAW_TP

 include/net/bpf_sk_storage.h                  |   2 +
 kernel/trace/bpf_trace.c                      |   5 +
 net/core/bpf_sk_storage.c                     |  96 +++++++++++--
 .../bpf/prog_tests/sk_storage_tracing.c       | 135 ++++++++++++++++++
 .../bpf/progs/test_sk_storage_trace_itself.c  |  29 ++++
 .../bpf/progs/test_sk_storage_tracing.c       |  95 ++++++++++++
 6 files changed, 349 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_storage_tra=
cing.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_storage_tra=
ce_itself.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_storage_tra=
cing.c

--=20
2.24.1

