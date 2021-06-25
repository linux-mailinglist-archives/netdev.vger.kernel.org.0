Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5443B4996
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 22:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbhFYUHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 16:07:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51756 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229712AbhFYUHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 16:07:13 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PJxEFw005852
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 13:04:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=sGXoSWisqxFkfdeszz5U9gKg/5S3Fy/jhAbUlP6uWYs=;
 b=jJAAsJZaDwItVKbmvYkag/Mr0kwITwNeAvfiVPt72ymyUALUzfmV8CVvQkPlvTQCmqq7
 mIIW9j2/c9b968LJm1R0+snlIbU8xIeSeTmWj94tuKhMvHmiJ2iv0hiTDUUYID8KnF5+
 BHurhJr5V5KqAwaoWDptyvOvqIh5U8AzbzA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39d23jes1g-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 13:04:51 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 13:04:49 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 3CFDB2942295; Fri, 25 Jun 2021 13:04:46 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Yuchung Cheng <ycheng@google.com>
Subject: [PATCH bpf-next 0/8] bpf: Allow bpf tcp iter to do bpf_setsockopt
Date:   Fri, 25 Jun 2021 13:04:46 -0700
Message-ID: <20210625200446.723230-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Z2H67PzJzkYTBN_sjnWqi89-rKr6c4kp
X-Proofpoint-GUID: Z2H67PzJzkYTBN_sjnWqi89-rKr6c4kp
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_07:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 mlxlogscore=632 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set is to allow bpf tcp iter to call bpf_setsockopt.

With bpf-tcp-cc, new algo rollout happens more often.  Instead of
restarting the applications to pick up the new tcp-cc, this set
allows the bpf tcp iter with the netadmin cap to call
bpf_setsockopt(TCP_CONGESTION).  It is not limited to TCP_CONGESTION
and the bpf tcp iter can call bpf_setsockopt() with other options.
The bpf tcp iter can read into all the fields of a tcp_sock, so
there is a lot of flexibility to select the desired sk to do
setsockopt(), e.g. it can test for TCP_LISTEN only and leave
the established connections untouched, or check the addr/port,
or check the current tcp-cc name, ...etc.

Patch 1-4 are some cleanup and prep work in the tcp and bpf seq_file.

Patch 5 is to have the tcp seq_file iterate on the
port+addr lhash2 instead of the port only listening_hash.

Patch 6 is to have the bpf tcp iter doing batching which
then allows lock_sock.  lock_sock is needed for setsockopt.

Patch 7 allows the bpf tcp iter to call bpf_setsockopt.

Martin KaFai Lau (8):
  tcp: seq_file: Avoid skipping sk during tcp_seek_last_pos
  tcp: seq_file: Refactor net and family matching
  bpf: tcp: seq_file: Remove bpf_seq_afinfo from tcp_iter_state
  tcp: seq_file: Add listening_get_first()
  tcp: seq_file: Replace listening_hash with lhash2
  bpf: tcp: bpf iter batching and lock_sock
  bpf: tcp: Support bpf_setsockopt in bpf tcp iter
  bpf: selftest: Test batching and bpf_setsockopt in bpf tcp iter

 include/linux/bpf.h                           |   7 +
 include/net/inet_hashtables.h                 |   6 +
 include/net/tcp.h                             |   1 -
 kernel/bpf/bpf_iter.c                         |  22 +
 kernel/trace/bpf_trace.c                      |   7 +-
 net/core/filter.c                             |  17 +
 net/ipv4/tcp_ipv4.c                           | 409 ++++++++++++++----
 tools/testing/selftests/bpf/network_helpers.c |  85 +++-
 tools/testing/selftests/bpf/network_helpers.h |   4 +
 .../bpf/prog_tests/bpf_iter_setsockopt.c      | 226 ++++++++++
 .../selftests/bpf/progs/bpf_iter_setsockopt.c |  76 ++++
 .../selftests/bpf/progs/bpf_tracing_net.h     |   4 +
 12 files changed, 767 insertions(+), 97 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_iter_setso=
ckopt.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_setsockopt=
.c

--=20
2.30.2

