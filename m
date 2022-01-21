Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523D7495AAD
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 08:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378989AbiAUHaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 02:30:39 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48534 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378984AbiAUHah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 02:30:37 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20L06frC010885
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 23:30:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=7GflWt4fi0AeOActFjaj98OUlkg6Vpv4+Ho/5AqMZaM=;
 b=N/LBThNC8Q8WrZLR/h/liTcbn+ykIA4pRa1xULvBs6HziPQRLDwT+lqPTlzLPS1ZUBhg
 PQjtY50zSAoMuDRBUsLxLtHLgS3Rge8Ls8k5x1derfQ2D0k6KDc4lhy+Axi0jEiA27/N
 44EZXVGreCpprqGgJYxDmyLWtHVfxwL1ei8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dqj0ghnbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 23:30:36 -0800
Received: from twshared22811.39.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 20 Jan 2022 23:30:36 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 29B025BDEBEE; Thu, 20 Jan 2022 23:30:26 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [RFC PATCH v3 net-next 0/4] Preserve mono delivery time (EDT) in skb->tstamp
Date:   Thu, 20 Jan 2022 23:30:26 -0800
Message-ID: <20220121073026.4173996-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4B2-_BzQGTr6ayeDBeeuRmaEkgCj1W14
X-Proofpoint-GUID: 4B2-_BzQGTr6ayeDBeeuRmaEkgCj1W14
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_02,2022-01-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0 adultscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210047
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb->tstamp was first used as the (rcv) timestamp in real time clock base=
.
The major usage is to report it to the user (e.g. SO_TIMESTAMP).

Later, skb->tstamp is also set as the (future) delivery_time (e.g. EDT in=
 TCP)
during egress and used by the qdisc (e.g. sch_fq) to make decision on whe=
n
the skb can be passed to the dev.

Currently, there is no way to tell skb->tstamp having the (rcv) timestamp
or the delivery_time, so it is always reset to 0 whenever forwarded
between egress and ingress.

While it makes sense to always clear the (rcv) timestamp in skb->tstamp
to avoid confusing sch_fq that expects the delivery_time, it is a
performance issue [0] to clear the delivery_time if the skb finally
egress to a fq@phy-dev.

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

Martin KaFai Lau (4):
  net: Add skb->mono_delivery_time to distinguish mono delivery_time
    from (rcv) timestamp
  net: Add skb_clear_tstamp() to keep the mono delivery_time
  net: Set skb->mono_delivery_time and clear it when delivering locally
  bpf: Add __sk_buff->mono_delivery_time and handle __sk_buff->tstamp
    based on tc_at_ingress

 drivers/net/loopback.c                     |   2 +-
 include/linux/filter.h                     |  31 ++++-
 include/linux/skbuff.h                     |  64 ++++++++--
 include/uapi/linux/bpf.h                   |   1 +
 net/bridge/br_forward.c                    |   2 +-
 net/bridge/netfilter/nf_conntrack_bridge.c |   5 +-
 net/core/dev.c                             |   4 +-
 net/core/filter.c                          | 140 +++++++++++++++++++--
 net/core/skbuff.c                          |   8 +-
 net/ipv4/ip_forward.c                      |   2 +-
 net/ipv4/ip_input.c                        |   1 +
 net/ipv4/ip_output.c                       |   5 +-
 net/ipv4/tcp_output.c                      |  16 +--
 net/ipv6/ip6_input.c                       |   1 +
 net/ipv6/ip6_output.c                      |   7 +-
 net/ipv6/netfilter.c                       |   5 +-
 net/netfilter/ipvs/ip_vs_xmit.c            |   6 +-
 net/netfilter/nf_dup_netdev.c              |   2 +-
 net/netfilter/nf_flow_table_ip.c           |   4 +-
 net/netfilter/nft_fwd_netdev.c             |   2 +-
 net/openvswitch/vport.c                    |   2 +-
 net/packet/af_packet.c                     |   4 +-
 net/sched/act_bpf.c                        |   5 +-
 net/sched/cls_bpf.c                        |   6 +-
 net/xfrm/xfrm_interface.c                  |   2 +-
 tools/include/uapi/linux/bpf.h             |   1 +
 26 files changed, 265 insertions(+), 63 deletions(-)

--=20
2.30.2

