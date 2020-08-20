Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F46724C5F7
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 21:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgHTTAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 15:00:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20230 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725819AbgHTTAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 15:00:12 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KJ03Ob010890
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 12:00:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=bDhVR3Gz+oWRGRRod2eRR8l5+VSebiHHJbzZX9KF7lQ=;
 b=NJXxeADypVMk89AKaCdD2hU60zdCXkKmg8ONAR2cDN6sMkIZhNKZzWcquUwSmjKJ8qCU
 qMIDzfIchOmUAB1qDw5KrLEKD2r8BGzFPBpPbkODR7YPy6wolvnWL6Q2ex/jHfqiwA7O
 dcscBvy7zro6mb7guj9qKNZ2wFvEqOAPkRo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3318g0pbe6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 12:00:10 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 12:00:10 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 980A22945825; Thu, 20 Aug 2020 12:00:08 -0700 (PDT)
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
Subject: [PATCH v5 bpf-next 00/12] BPF TCP header options
Date:   Thu, 20 Aug 2020 12:00:08 -0700
Message-ID: <20200820190008.2883500-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 mlxlogscore=999 suspectscore=13 mlxscore=0 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200151
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

Patch 9 is the main patch and has more details on the API and design.

The set includes an example which sends the max delay ack in
the BPF TCP header option and the receiving side can
then adjust its RTO accordingly.

v5:
- Move some of the comments from git commit message to the UAPI bpf.h
  in patch 9

- Some variable clean up in the tests (patch 11).

v4:
- Since bpf-next is currently closed, tag the set with RFC to keep the
  review cadence

- Separate tcp changes in its own patches (5, 6, 7).  It is a bit
  tricky since most of the tcp changes is to call out the bpf prog to
  write and parse the header.  The write and parse callout has been
  modularized into a few bpf_skops_* function in v3.

  This revision (v4) tries to move those bpf_skops_* functions into separ=
ate
  TCP patches.  However, they will be half implemented to highlight
  the changes to the TCP stack, mainly:
    - when the bpf prog will be called in the TCP stack and
    - what information needs to pump through the TCP stack to the actual =
bpf
      prog callsite.

  The bpf_skops_* functions will be fully implemented in patch 9 together
  with other bpf pieces.

- Use struct_size() in patch 1 (Eric)

- Add saw_unknown to struct tcp_options_received in patch 4 (Eric)

v3:
- Add kdoc for tcp_make_synack (Jakub Kicinski)
- Add BPF_WRITE_HDR_TCP_CURRENT_MSS and BPF_WRITE_HDR_TCP_SYNACK_COOKIE
  in bpf.h to give a clearer meaning to sock_ops->args[0] when
  writing header option.
- Rename BPF_SOCK_OPS_PARSE_UNKWN_HDR_OPT_CB_FLAG
  to     BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG

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

Martin KaFai Lau (12):
  tcp: Use a struct to represent a saved_syn
  tcp: bpf: Add TCP_BPF_DELACK_MAX setsockopt
  tcp: bpf: Add TCP_BPF_RTO_MIN for bpf_setsockopt
  tcp: Add saw_unknown to struct tcp_options_received
  bpf: tcp: Add bpf_skops_established()
  bpf: tcp: Add bpf_skops_parse_hdr()
  bpf: tcp: Add bpf_skops_hdr_opt_len() and bpf_skops_write_hdr_opt()
  bpf: sock_ops: Change some members of sock_ops_kern from u32 to u8
  bpf: tcp: Allow bpf prog to write and parse TCP header option
  bpf: selftests: Add fastopen_connect to network_helpers
  bpf: selftests: tcp header options
  tcp: bpf: Optionally store mac header in TCP_SAVE_SYN

 include/linux/bpf-cgroup.h                    |  25 +
 include/linux/filter.h                        |   8 +-
 include/linux/tcp.h                           |  20 +-
 include/net/inet_connection_sock.h            |   2 +
 include/net/request_sock.h                    |   9 +-
 include/net/tcp.h                             |  59 +-
 include/uapi/linux/bpf.h                      | 306 ++++++++-
 net/core/filter.c                             | 416 +++++++++++-
 net/ipv4/tcp.c                                |  16 +-
 net/ipv4/tcp_fastopen.c                       |   2 +-
 net/ipv4/tcp_input.c                          | 127 +++-
 net/ipv4/tcp_ipv4.c                           |   5 +-
 net/ipv4/tcp_minisocks.c                      |   1 +
 net/ipv4/tcp_output.c                         | 193 +++++-
 net/ipv6/tcp_ipv6.c                           |   5 +-
 tools/include/uapi/linux/bpf.h                | 306 ++++++++-
 tools/testing/selftests/bpf/network_helpers.c |  37 ++
 tools/testing/selftests/bpf/network_helpers.h |   2 +
 .../bpf/prog_tests/tcp_hdr_options.c          | 622 +++++++++++++++++
 .../bpf/progs/test_misc_tcp_hdr_options.c     | 325 +++++++++
 .../bpf/progs/test_tcp_hdr_options.c          | 623 ++++++++++++++++++
 .../selftests/bpf/test_tcp_hdr_options.h      | 151 +++++
 22 files changed, 3198 insertions(+), 62 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tcp_hdr_option=
s.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_o=
ptions.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tcp_hdr_option=
s.c
 create mode 100644 tools/testing/selftests/bpf/test_tcp_hdr_options.h

--=20
2.24.1

