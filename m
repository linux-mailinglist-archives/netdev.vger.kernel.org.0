Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B4123B0B3
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgHCXKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:10:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48274 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728940AbgHCXKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 19:10:18 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 073Ms7J9008779
        for <netdev@vger.kernel.org>; Mon, 3 Aug 2020 16:10:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=JJiFuMriW/bxE+TS3sUne7N3y04ILjMt7pzcH98rSO0=;
 b=Or+SjmvyEMC9f+/7R+8Ch6G2HEwE9S8RYbST3DG5hy8pX50OYjG89ChZToFRj391Y7GB
 jEWyQtIuXr3+GPuVIeGMsZxuJAu/fTo6LbmL2R97sN/AIWvbl1ePr+FTtNbfVArH1HTn
 Czd+tI43JkeOBsZ6gfMj6yws81spb6JfL/g= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32nrc9755y-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 16:10:17 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 3 Aug 2020 16:10:16 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 86E0F2943872; Mon,  3 Aug 2020 16:10:13 -0700 (PDT)
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
Subject: [RFC PATCH v4 bpf-next 00/12] BPF TCP header options
Date:   Mon, 3 Aug 2020 16:10:13 -0700
Message-ID: <20200803231013.2681560-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_15:2020-08-03,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 suspectscore=13
 clxscore=1015 impostorscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030158
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
 include/uapi/linux/bpf.h                      | 234 ++++++-
 net/core/filter.c                             | 416 ++++++++++-
 net/ipv4/tcp.c                                |  16 +-
 net/ipv4/tcp_fastopen.c                       |   2 +-
 net/ipv4/tcp_input.c                          | 127 +++-
 net/ipv4/tcp_ipv4.c                           |   5 +-
 net/ipv4/tcp_minisocks.c                      |   1 +
 net/ipv4/tcp_output.c                         | 193 ++++-
 net/ipv6/tcp_ipv6.c                           |   5 +-
 tools/include/uapi/linux/bpf.h                | 234 ++++++-
 tools/testing/selftests/bpf/network_helpers.c |  37 +
 tools/testing/selftests/bpf/network_helpers.h |   2 +
 .../bpf/prog_tests/tcp_hdr_options.c          | 629 +++++++++++++++++
 .../bpf/progs/test_misc_tcp_hdr_options.c     | 338 +++++++++
 .../bpf/progs/test_tcp_hdr_options.c          | 657 ++++++++++++++++++
 .../selftests/bpf/test_tcp_hdr_options.h      | 150 ++++
 22 files changed, 3107 insertions(+), 62 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tcp_hdr_option=
s.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_o=
ptions.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tcp_hdr_option=
s.c
 create mode 100644 tools/testing/selftests/bpf/test_tcp_hdr_options.h

--=20
2.24.1

