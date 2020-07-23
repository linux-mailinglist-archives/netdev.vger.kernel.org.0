Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBE422A431
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 03:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387473AbgGWBDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 21:03:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19520 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729401AbgGWBDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 21:03:42 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06N0lZan026149
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 18:03:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=I0sSMB8jzgrYoc7104CidJ+wBtTu0+QUata4+XMyTgA=;
 b=gCiaMbuLWv1ZDfn9tmvYubc7yBQnE4NhB+5oYJtuFHfwyocO0uc2TirJMP4M/z1SPTtD
 mguqR1wT/c5O1mgi9gySQC0zM6KtAAXVB0Z60Ch+AaMLFeEZdQk5Hj9q6jkcizozvCPx
 51Pj5rA7IQWtFIbAM5st4SMwdcldd8Rhj7E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 32esdjj615-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 18:03:40 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Jul 2020 18:03:39 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id AF7242945AD1; Wed, 22 Jul 2020 18:03:34 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/9] BPF TCP header options
Date:   Wed, 22 Jul 2020 18:03:34 -0700
Message-ID: <20200723010334.1905574-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_17:2020-07-22,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 malwarescore=0 spamscore=0 adultscore=0 impostorscore=0 phishscore=0
 suspectscore=13 bulkscore=0 priorityscore=1501 mlxlogscore=929
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The earlier effort in BPF-TCP-CC allows the TCP Congestion Control
algorithm to be written in BPF.  It opens up opportunities to allow
a faster turnaround time in testing/releasing new congestion control
ideas to production environment.

The same flexibility can be extended to writing TCP header option.
It is not uncommon that people want to test new TCP header option
to improve the TCP performance.  Another use case is for data-center
that has a more controlled environment and has more flexibility in
putting header options for internal traffic only.
   =20
This patch set introduces the necessary BPF logic and API to
allow bpf program to write and parse header options.

There are also some changes to TCP and they are mostly to provide
the needed sk and skb info to the bpf program to make decision.

Patch 6 is the main patch and has more details on the API and design.

The set includes an example which sends the max delay ack in
the BPF TCP header option and the receiving side can
then adjust its RTO accordingly.

v2:
- Instead of limiting the bpf prog to write experimental
  option (kind:254, magic:0xeB9F), this revision allows the bpf prog to
  write any TCP header option through the bpf_store_hdr_opt() helper.
  That will allow different bpf-progs to write its own
  option and the helper will guarantee there is no duplication.

- Add bpf_load_hdr_opt() helper to search a particular option by kind.
  Some of the get_syn logic is refactored to bpf_sock_ops_get_syn().

- Since bpf prog is no longer limited to option (254, 0xeB9F),
  the TCP_SKB_CB(skb)->bpf_hdr_opt_off is no longer needed.
  Instead, when there is any option kernel cannot recognize,
  the bpf prog will be called if the
  BPF_SOCK_OPS_PARSE_UNKWN_HDR_OPT_CB_FLAG is set.
  [ The "unknown_opt" is learned in tcp_parse_options() in patch 4. ]

- Add BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG.
  If this flag is set, the bpf-prog will be called
  on all tcp packet received at an established sk.
  It will be useful to ensure a previously written header option is
  received by the peer.
  e.g. The latter test is using this on the active-side during syncookie.

- The test_tcp_hdr_options.c is adjusted accordingly
  to test writing both experimental and regular TCP header option.

- The test_misc_tcp_hdr_options.c is added to mainly
  test different cases on the new helpers.
 =20
- Break up the TCP_BPF_RTO_MIN and TCP_BPF_DELACK_MAX into
  two patches.

- Directly store the tcp_hdrlen in "struct saved_syn" instead of
  going back to the tcp header to obtain it by "th->doff * 4"

- Add a new optval(=3D=3D2) for setsockopt(TCP_SAVE_SYN) such
  that it will also store the mac header (patch 9).

Martin KaFai Lau (9):
  tcp: Use a struct to represent a saved_syn
  tcp: bpf: Add TCP_BPF_DELACK_MAX setsockopt
  tcp: bpf: Add TCP_BPF_RTO_MIN for bpf_setsockopt
  tcp: Add unknown_opt arg to tcp_parse_options
  bpf: sock_ops: Change some members of sock_ops_kern from u32 to u8
  bpf: tcp: Allow bpf prog to write and parse TCP header option
  bpf: selftests: Add fastopen_connect to network_helpers
  bpf: selftests: tcp header options
  tcp: bpf: Optionally store mac header in TCP_SAVE_SYN

 drivers/infiniband/hw/cxgb4/cm.c              |   2 +-
 include/linux/bpf-cgroup.h                    |  25 +
 include/linux/filter.h                        |   8 +-
 include/linux/tcp.h                           |  18 +-
 include/net/inet_connection_sock.h            |   2 +
 include/net/request_sock.h                    |   9 +-
 include/net/tcp.h                             |  58 +-
 include/uapi/linux/bpf.h                      | 218 +++++-
 net/core/filter.c                             | 416 ++++++++++-
 net/ipv4/syncookies.c                         |   2 +-
 net/ipv4/tcp.c                                |  16 +-
 net/ipv4/tcp_fastopen.c                       |   2 +-
 net/ipv4/tcp_input.c                          | 151 +++-
 net/ipv4/tcp_ipv4.c                           |   3 +-
 net/ipv4/tcp_minisocks.c                      |   5 +-
 net/ipv4/tcp_output.c                         | 165 ++++-
 net/ipv6/syncookies.c                         |   2 +-
 net/ipv6/tcp_ipv6.c                           |   3 +-
 tools/include/uapi/linux/bpf.h                | 218 +++++-
 tools/testing/selftests/bpf/network_helpers.c |  37 +
 tools/testing/selftests/bpf/network_helpers.h |   2 +
 .../bpf/prog_tests/tcp_hdr_options.c          | 636 +++++++++++++++++
 .../bpf/progs/test_misc_tcp_hdr_options.c     | 314 +++++++++
 .../bpf/progs/test_tcp_hdr_options.c          | 652 ++++++++++++++++++
 .../selftests/bpf/test_tcp_hdr_options.h      | 150 ++++
 25 files changed, 3050 insertions(+), 64 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tcp_hdr_option=
s.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_o=
ptions.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tcp_hdr_option=
s.c
 create mode 100644 tools/testing/selftests/bpf/test_tcp_hdr_options.h

--=20
2.24.1

