Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD823F6752
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239841AbhHXRc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:32:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18190 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238425AbhHXRaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 13:30:52 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17OHU0Jc001168
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 10:30:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=G2gKnmW+A9fdO+WKJw8vDzIvrP/mzMN8631sIzWI/Cg=;
 b=n5jDNj2OFminDC6gjfWeHoVo0Rzxd/hhic7S+uQOe7WmUvbwQ9tF7lYw40KKkjURf/6o
 RvtC2bqZ6WcBrbMIo5tykixRARpH1GUSy75m4wDvZ0of94RtmiL9gkLx+QKy1Bhn6Hg0
 pBSzG+wXVX+Xs9UmrYW6b51L0X4+I3shmgI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3amfqt7t75-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 10:30:05 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 24 Aug 2021 10:30:01 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 04BEB2940D05; Tue, 24 Aug 2021 10:30:00 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 bpf-next 0/4] bpf: tcp: Allow bpf-tcp-cc to call bpf_(get|set)sockopt
Date:   Tue, 24 Aug 2021 10:30:00 -0700
Message-ID: <20210824173000.3976470-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: kXYhtRE8bCLEzYytPQieyh3_tOeK40o9
X-Proofpoint-ORIG-GUID: kXYhtRE8bCLEzYytPQieyh3_tOeK40o9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-24_05:2021-08-24,2021-08-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0
 mlxlogscore=590 mlxscore=0 spamscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108240115
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
   =20
v2:
- Not allow switching to kernel's tcp_cdg because it is the only
  kernel tcp-cc that stores a pointer to icsk_ca_priv.
  Please see the commit log in patch 1 for details.
  Test is added in patch 4 to check switching to tcp_cdg.
- Refactor the logic finding the offset of a func ptr
  in the "struct tcp_congestion_ops" to prog_ops_moff()
  in patch 1.
- bpf_setsockopt() has been disabled in release() since v1 (please
  see commit log in patch 1 for reason).  bpf_getsockopt() is
  also disabled together in release() in v2 to avoid usage surprise
  because both of them are usually expected to be available together.
  bpf-tcp-cc can already use PTR_TO_BTF_ID to read from tcp_sock.

Martin KaFai Lau (4):
  bpf: tcp: Allow bpf-tcp-cc to call bpf_(get|set)sockopt
  bpf: selftests: Add sk_state to bpf_tcp_helpers.h
  bpf: selftests: Add connect_to_fd_opts to network_helpers
  bpf: selftests: Add dctcp fallback test

 kernel/bpf/bpf_struct_ops.c                   |  22 +++-
 net/core/filter.c                             |   6 +
 net/ipv4/bpf_tcp_ca.c                         |  41 ++++++-
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |   1 +
 tools/testing/selftests/bpf/network_helpers.c |  23 +++-
 tools/testing/selftests/bpf/network_helpers.h |   6 +
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 106 ++++++++++++++----
 .../selftests/bpf/prog_tests/kfunc_call.c     |   2 +-
 tools/testing/selftests/bpf/progs/bpf_dctcp.c |  25 +++++
 .../selftests/bpf/progs/bpf_dctcp_release.c   |  26 +++++
 .../bpf/progs/kfunc_call_test_subprog.c       |   4 +-
 11 files changed, 230 insertions(+), 32 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_dctcp_release.c

--=20
2.30.2

