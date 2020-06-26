Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023C720B7A2
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgFZRz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:55:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10634 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725977AbgFZRz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:55:26 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QHssvk019322
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:55:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=Z0Ny/UbkwzOX/BfPlSa3nxytQzuq06lhHGd51wiSH3Y=;
 b=Vwx75lQ8G9wev3YOA7kgL0J4G2aKRSxLoy1IwrjskmTZbnrhgJ7Jc7aLBHEIOeZ2ew6K
 1xpxSN+Yu5Ism/fMA2eoZJpO43jP/G33q0jDIgU9bqKfd0vAl3trdtgBjsiyoaojLoFk
 gRKNb8xnS+AEp258y1CkupYQc3nEgIi7eCo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux1exn12-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:55:24 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 10:55:04 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id D8C672942E38; Fri, 26 Jun 2020 10:55:01 -0700 (PDT)
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
Subject: [PATCH bpf-next 00/10] BPF TCP header options
Date:   Fri, 26 Jun 2020 10:55:01 -0700
Message-ID: <20200626175501.1459961-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_10:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 cotscore=-2147483648 spamscore=0 mlxlogscore=383 bulkscore=0
 adultscore=0 phishscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 suspectscore=13 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006260126
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
allow bpf program (BPF_PROG_TYPE_SOCK_OPS) to write and parse
TCP options under experimental kind(254) and 16bit-magic(0xeB9F).
The experimental kind(254) usage is defined in RFC 6994.

There are also some changes to TCP and they are mostly to provide
the needed sk and skb info to the bpf program to make decision.

Patch 4 is the main patch and has more details on the API and design.

The set ends with an example which sends the max delay ack in
the BPF TCP header option and the receiving side can
then adjust its RTO accordingly.

Martin KaFai Lau (10):
  tcp: Use a struct to represent a saved_syn
  tcp: bpf: Parse BPF experimental header option
  bpf: sock_ops: Change some members of sock_ops_kern from u32 to u8
  bpf: tcp: Allow bpf prog to write and parse BPF TCP header option
  bpf: selftests: A few improvements to network_helpers.c
  bpf: selftests: Add fastopen_connect to network_helpers
  bpf: selftests: Restore netns after each test
  bpf: selftests: tcp header options
  tcp: bpf: Add TCP_BPF_DELACK_MAX and TCP_BPF_RTO_MIN to bpf_setsockopt
  bpf: selftest: Add test for TCP_BPF_DELACK_MAX and TCP_BPF_RTO_MIN

 include/linux/bpf-cgroup.h                    |  25 +
 include/linux/filter.h                        |  10 +-
 include/linux/tcp.h                           |  11 +-
 include/net/inet_connection_sock.h            |   2 +
 include/net/request_sock.h                    |   8 +-
 include/net/tcp.h                             |  58 +-
 include/uapi/linux/bpf.h                      | 189 ++++-
 net/core/filter.c                             | 236 +++++-
 net/ipv4/tcp.c                                |  13 +-
 net/ipv4/tcp_fastopen.c                       |   2 +-
 net/ipv4/tcp_input.c                          |  99 ++-
 net/ipv4/tcp_ipv4.c                           |   4 +-
 net/ipv4/tcp_minisocks.c                      |   1 +
 net/ipv4/tcp_output.c                         | 188 ++++-
 net/ipv6/tcp_ipv6.c                           |   4 +-
 tools/include/uapi/linux/bpf.h                | 189 ++++-
 tools/testing/selftests/bpf/network_helpers.c | 182 +++--
 tools/testing/selftests/bpf/network_helpers.h |  11 +-
 .../bpf/prog_tests/cgroup_skb_sk_lookup.c     |  12 +-
 .../bpf/prog_tests/connect_force_port.c       |  10 +-
 .../bpf/prog_tests/load_bytes_relative.c      |   4 +-
 .../bpf/prog_tests/tcp_hdr_options.c          | 522 +++++++++++++
 .../selftests/bpf/prog_tests/tcp_rtt.c        |   4 +-
 .../bpf/progs/test_tcp_hdr_options.c          | 708 ++++++++++++++++++
 tools/testing/selftests/bpf/test_progs.c      |  21 +
 tools/testing/selftests/bpf/test_progs.h      |   2 +
 .../selftests/bpf/test_tcp_hdr_options.h      |  34 +
 27 files changed, 2426 insertions(+), 123 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tcp_hdr_option=
s.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tcp_hdr_option=
s.c
 create mode 100644 tools/testing/selftests/bpf/test_tcp_hdr_options.h

--=20
2.24.1

