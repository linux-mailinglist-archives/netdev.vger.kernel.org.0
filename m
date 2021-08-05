Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9363E0D74
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 07:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbhHEFBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 01:01:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50392 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230422AbhHEFBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 01:01:42 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1754wQNo001942
        for <netdev@vger.kernel.org>; Wed, 4 Aug 2021 22:01:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=6Vllg8IdrYpINbbBLwe/SU/UVeRH5TEu2m/+zEkQGto=;
 b=aIGWW3VpSnrGG9PCdRPQGoL46aWcw5UdaDjd/EqeGccRdl4JSdb3kXxPTnPWZ7aAG/+q
 1aVdffyiFd3RX8t6QKcz8d2mtUnihRuzl1xrn6Nn2zglEuf+e6EPCz0sWeuMIyimlbrn
 K1xqj6lYn3V9uapTucErO8cMk/Vn9UcyMF4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a7wshbsyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 22:01:28 -0700
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 4 Aug 2021 22:01:28 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 76A44294203D; Wed,  4 Aug 2021 22:01:19 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 0/4] bpf: tcp: Allow bpf-tcp-cc to call bpf_(get|set)sockopt
Date:   Wed, 4 Aug 2021 22:01:19 -0700
Message-ID: <20210805050119.1349009-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: Tgn8fKgwYMEyE3SFn0ho6ibQcUfN1dM1
X-Proofpoint-ORIG-GUID: Tgn8fKgwYMEyE3SFn0ho6ibQcUfN1dM1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_01:2021-08-04,2021-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 clxscore=1015 impostorscore=0 mlxlogscore=552 mlxscore=0
 spamscore=0 phishscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108050028
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set allows the bpf-tcp-cc to call bpf_setsockopt.  One use
case is to allow a bpf-tcp-cc switching to another cc during init().
For example, when the tcp flow is not ecn ready, the bpf_dctcp
can switch to another cc by calling setsockopt(TCP_CONGESTION).

bpf_getsockopt() is also added to have a symmetrical API, so
less usage surprise.

Martin KaFai Lau (4):
  bpf: tcp: Allow bpf-tcp-cc to call bpf_(get|set)sockopt
  bpf: selftests: Add sk_state to bpf_tcp_helpers.h
  bpf: selftests: Add connect_to_fd_opts to network_helpers
  bpf: selftests: Add dctcp fallback test

 kernel/bpf/bpf_struct_ops.c                   |  22 +++-
 net/ipv4/bpf_tcp_ca.c                         |  26 ++++-
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |   5 +
 tools/testing/selftests/bpf/network_helpers.c |  23 +++-
 tools/testing/selftests/bpf/network_helpers.h |   6 ++
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 101 ++++++++++++++----
 .../selftests/bpf/prog_tests/kfunc_call.c     |   2 +-
 tools/testing/selftests/bpf/progs/bpf_dctcp.c |  20 ++++
 .../selftests/bpf/progs/bpf_dctcp_release.c   |  26 +++++
 .../bpf/progs/kfunc_call_test_subprog.c       |   4 +-
 10 files changed, 203 insertions(+), 32 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_dctcp_release.c

--=20
2.30.2

