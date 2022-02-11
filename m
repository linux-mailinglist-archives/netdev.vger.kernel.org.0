Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5664B1F0E
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 08:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347613AbiBKHM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 02:12:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347594AbiBKHMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 02:12:55 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B278010A4
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:12:54 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21ANrYmM018278
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:12:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=fThJZV5/pgayFnQZYBK56Ba1uNClKy/R6fc1ciU6QOs=;
 b=UAIpSPdnIAujyssuS6JFEilF6rg4Q1DYwSIojdWD4ijlOSGBCp1x+msBr53S+n79ecgX
 OMLFni3IWLXEgTr7PdiVkET+WYc+gX7iK51ahiGw3ulD7XJsIsR8k1nBXv0dGlCgtWa4
 ieSpActLNZ2O8skMkZggkWOVyjM3R14yQ8Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e592ukfrk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:12:53 -0800
Received: from twshared0983.05.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 23:12:42 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 52A6A6C756E3; Thu, 10 Feb 2022 23:12:32 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v4 net-next 0/8] Preserve mono delivery time (EDT) in skb->tstamp
Date:   Thu, 10 Feb 2022 23:12:32 -0800
Message-ID: <20220211071232.885225-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: NHuEbjvVqJRRPQPjjN6L3VbTwXYBQNPf
X-Proofpoint-ORIG-GUID: NHuEbjvVqJRRPQPjjN6L3VbTwXYBQNPf
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_02,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 spamscore=0 impostorscore=0
 phishscore=0 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202110040
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb->tstamp was first used as the (rcv) timestamp.
The major usage is to report it to the user (e.g. SO_TIMESTAMP).

Later, skb->tstamp is also set as the (future) delivery_time (e.g. EDT in T=
CP)
during egress and used by the qdisc (e.g. sch_fq) to make decision on when
the skb can be passed to the dev.

Currently, there is no way to tell skb->tstamp having the (rcv) timestamp
or the delivery_time, so it is always reset to 0 whenever forwarded
between egress and ingress.

While it makes sense to always clear the (rcv) timestamp in skb->tstamp
to avoid confusing sch_fq that expects the delivery_time, it is a
performance issue [0] to clear the delivery_time if the skb finally
egress to a fq@phy-dev.

This set is to keep the mono delivery time and make it available to
the final egress interface.  Please see individual patch for
the details.

[0] (slide 22): https://linuxplumbersconf.org/event/11/contributions/953/at=
tachments/867/1658/LPC_2021_BPF_Datapath_Extensions.pdf

v4:
netdev:
- Push the skb_clear_delivery_time() from
  ip_local_deliver() and ip6_input() to
  ip_local_deliver_finish() and ip6_input_finish()
  to accommodate the ipvs forward path.
  This is the notable change in v4 at the netdev side.

    - Patch 3/8 first does the skb_clear_delivery_time() after
      sch_handle_ingress() in dev.c and this will make the
      tc-bpf forward path work via the bpf_redirect_*() helper.

    - The next patch 4/8 (new in v4) will then postpone the
      skb_clear_delivery_time() from dev.c to
      the ip_local_deliver_finish() and ip6_input_finish() after
      taking care of the tstamp usage in the ip defrag case.
      This will make the kernel forward path also work, e.g.
      the ip[6]_forward().

- Fixed a case v3 which missed setting the skb->mono_delivery_time bit
  when sending TCP rst/ack in some cases (e.g. from a ctl_sk).
  That case happens at ip_send_unicast_reply() and
  tcp_v6_send_response().  It is fixed in patch 1/8 (and
  then patch 3/8) in v4.

bpf:
- Adding __sk_buff->delivery_time_type instead of adding
  __sk_buff->mono_delivery_time as in v3.  The tc-bpf can stay with
  one __sk_buff->tstamp instead of having two 'time' fields
  while one is 0 and another is not.
  tc-bpf can use the new __sk_buff->delivery_time_type to tell
  what is stored in __sk_buff->tstamp.
- bpf_skb_set_delivery_time() helper is added to set
  __sk_buff->tstamp from non mono delivery_time to
  mono delivery_time
- Most of the convert_ctx_access() bpf insn rewrite in v3
  is gone, so no new rewrite added for __sk_buff->tstamp.
  The only rewrite added is for reading the new
  __sk_buff->delivery_time_type.
- Added selftests, test_tc_dtime.c

v3:
- Feedback from v2 is using shinfo(skb)->tx_flags could be racy.
- Considered to reuse a few bits in skb->tstamp to represent
  different semantics, other than more code churns, it will break
  the bpf usecase which currently can write and then read back
  the skb->tstamp.
- Went back to v1 idea on adding a bit to skb and address the
  feedbacks on v1:
- Added one bit skb->mono_delivery_time to flag that
  the skb->tstamp has the mono delivery_time (EDT), instead
  of adding a bit to flag if the skb->tstamp has been forwarded or not.
- Instead of resetting the delivery_time back to the (rcv) timestamp
  during recvmsg syscall which may be too late and not useful,
  the delivery_time reset in v3 happens earlier once the stack
  knows that the skb will be delivered locally.
- Handled the tapping@ingress case by af_packet
- No need to change the (rcv) timestamp to mono clock base as in v1.
  The added one bit to flag skb->mono_delivery_time is enough
  to keep the EDT delivery_time during forward.
- Added logic to the bpf side to make the existing bpf
  running at ingress can still get the (rcv) timestamp
  when reading the __sk_buff->tstamp.  New __sk_buff->mono_delivery_time
  is also added.  Test is still needed to test this piece.

Martin KaFai Lau (8):
  net: Add skb->mono_delivery_time to distinguish mono delivery_time
    from (rcv) timestamp
  net: Add skb_clear_tstamp() to keep the mono delivery_time
  net: Set skb->mono_delivery_time and clear it after
    sch_handle_ingress()
  net: Postpone skb_clear_delivery_time() until knowing the skb is
    delivered locally
  bpf: Keep the (rcv) timestamp behavior for the existing tc-bpf@ingress
  bpf: Clear skb->mono_delivery_time bit if needed after running
    tc-bpf@egress
  bpf: Add __sk_buff->delivery_time_type and bpf_skb_set_delivery_time()
  bpf: selftests: test skb->tstamp in redirect_neigh

 drivers/net/loopback.c                        |   2 +-
 include/linux/filter.h                        |  33 +-
 include/linux/skbuff.h                        |  64 ++-
 include/net/inet_frag.h                       |   1 +
 include/uapi/linux/bpf.h                      |  35 +-
 net/bridge/br_forward.c                       |   2 +-
 net/bridge/netfilter/nf_conntrack_bridge.c    |   5 +-
 net/core/dev.c                                |   4 +-
 net/core/filter.c                             |  85 +++-
 net/core/skbuff.c                             |   8 +-
 net/ipv4/inet_fragment.c                      |   1 +
 net/ipv4/ip_forward.c                         |   2 +-
 net/ipv4/ip_fragment.c                        |   1 +
 net/ipv4/ip_input.c                           |   1 +
 net/ipv4/ip_output.c                          |   6 +-
 net/ipv4/tcp_output.c                         |  16 +-
 net/ipv6/ip6_input.c                          |   1 +
 net/ipv6/ip6_output.c                         |   7 +-
 net/ipv6/netfilter.c                          |   5 +-
 net/ipv6/tcp_ipv6.c                           |   2 +-
 net/netfilter/ipvs/ip_vs_xmit.c               |   6 +-
 net/netfilter/nf_dup_netdev.c                 |   2 +-
 net/netfilter/nf_flow_table_ip.c              |   4 +-
 net/netfilter/nft_fwd_netdev.c                |   2 +-
 net/openvswitch/vport.c                       |   2 +-
 net/packet/af_packet.c                        |   4 +-
 net/sched/act_bpf.c                           |   7 +-
 net/sched/cls_bpf.c                           |   8 +-
 net/xfrm/xfrm_interface.c                     |   2 +-
 tools/include/uapi/linux/bpf.h                |  35 +-
 .../selftests/bpf/prog_tests/tc_redirect.c    | 434 ++++++++++++++++++
 .../selftests/bpf/progs/test_tc_dtime.c       | 348 ++++++++++++++
 32 files changed, 1078 insertions(+), 57 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_dtime.c

--=20
2.30.2

