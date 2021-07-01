Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E543B96E0
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 22:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbhGAUIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 16:08:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39138 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229894AbhGAUIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 16:08:12 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 161K1D91013771
        for <netdev@vger.kernel.org>; Thu, 1 Jul 2021 13:05:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=rfEWlzyTBYt8xwmwundc1bYUM5A4dNQaNhfW7pvLG/A=;
 b=qAUqUMkE43XFNCTfobEZWfNse7U5NW0HHcFRGnBtFW1WBiout/hZNydpUNcwJtWH3h2g
 wdHZXep3IRHzjwL9s7MxQaVDzkfNoiKJfn8QyPgqWTpZSg3IB4nXn+6QYlKijAfBXyHU
 32MsKeYhLJDeuXntjN4Bnrvp2nchTCZ1Grw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39h84wcm4v-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 13:05:41 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Jul 2021 13:05:38 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id A43192940BB9; Thu,  1 Jul 2021 13:05:35 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Yuchung Cheng <ycheng@google.com>
Subject: [PATCH v2 bpf-next 0/8] bpf: Allow bpf tcp iter to do bpf_(get|set)sockopt
Date:   Thu, 1 Jul 2021 13:05:35 -0700
Message-ID: <20210701200535.1033513-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: lhGHEBAQS--lFjJ9ieT187IhS9cLinwo
X-Proofpoint-GUID: lhGHEBAQS--lFjJ9ieT187IhS9cLinwo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-01_12:2021-07-01,2021-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=0 mlxscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=650 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107010117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set is to allow bpf tcp iter to call bpf_(get|set)sockopt.

With bpf-tcp-cc, new algo rollout happens more often.  Instead of
restarting the applications to pick up the new tcp-cc, this set
allows the bpf tcp iter to call bpf_(get|set)sockopt(TCP_CONGESTION).
It is not limited to TCP_CONGESTION, the bpf tcp iter can call
bpf_(get|set)sockopt() with other options.  The bpf tcp iter can read
into all the fields of a tcp_sock, so there is a lot of flexibility
to select the desired sk to do setsockopt(), e.g. it can test for
TCP_LISTEN only and leave the established connections untouched,
or check the addr/port, or check the current tcp-cc name, ...etc.

Patch 1-4 are some cleanup and prep work in the tcp and bpf seq_file.

Patch 5 is to have the tcp seq_file iterate on the
port+addr lhash2 instead of the port only listening_hash.

Patch 6 is to have the bpf tcp iter doing batching which
then allows lock_sock.  lock_sock is needed for setsockopt.

Patch 7 allows the bpf tcp iter to call bpf_(get|set)sockopt.

v2:
- Use __GFP_NOWARN in patch 6
- Add bpf_getsockopt() in patch 7 to give a symmetrical user experience.
  selftest in patch 8 is changed to also cover bpf_getsockopt().
- Remove CAP_NET_ADMIN check in patch 7. Tracing bpf prog has already
  required CAP_SYS_ADMIN or CAP_PERFMON.
- Move some def macros to bpf_tracing_net.h in patch 8

Martin KaFai Lau (8):
  tcp: seq_file: Avoid skipping sk during tcp_seek_last_pos
  tcp: seq_file: Refactor net and family matching
  bpf: tcp: seq_file: Remove bpf_seq_afinfo from tcp_iter_state
  tcp: seq_file: Add listening_get_first()
  tcp: seq_file: Replace listening_hash with lhash2
  bpf: tcp: bpf iter batching and lock_sock
  bpf: tcp: Support bpf_(get|set)sockopt in bpf tcp iter
  bpf: selftest: Test batching and bpf_(get|set)sockopt in bpf tcp iter

 include/linux/bpf.h                           |   8 +
 include/net/inet_hashtables.h                 |   6 +
 include/net/tcp.h                             |   1 -
 kernel/bpf/bpf_iter.c                         |  22 +
 kernel/trace/bpf_trace.c                      |   7 +-
 net/core/filter.c                             |  34 ++
 net/ipv4/tcp_ipv4.c                           | 410 ++++++++++++++----
 tools/testing/selftests/bpf/network_helpers.c |  85 +++-
 tools/testing/selftests/bpf/network_helpers.h |   4 +
 .../bpf/prog_tests/bpf_iter_setsockopt.c      | 226 ++++++++++
 .../selftests/bpf/progs/bpf_iter_setsockopt.c |  72 +++
 .../selftests/bpf/progs/bpf_tracing_net.h     |   6 +
 12 files changed, 784 insertions(+), 97 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_iter_setso=
ckopt.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_setsockopt=
.c

--=20
2.30.2

