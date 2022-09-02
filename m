Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE7D5AA45A
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 02:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbiIBA2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 20:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbiIBA2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 20:28:02 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03F194EFD
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 17:28:01 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 28208pkD018342
        for <netdev@vger.kernel.org>; Thu, 1 Sep 2022 17:28:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=AaEt7Q3ZHEEiNEJDTzWAp0gFrVoSuSH9qSvdafmSdzk=;
 b=qCZEFTXaKMgiyYcH96lR2hrK19qy1A/nvEpN4MrA+ZZrQcJ8KAgsbttdYOLbcoBWEg/O
 PCehaVNrXMwYYcRgeBppAyfzUuxu9sGV6vIMKzmbgtLQRDVAZhVjmV0jh7Kh9Eh9/3cq
 Kazfx/YW1D/EZgdTqhAMUhOZx9u+rfYRq8k= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3jaur6d3f3-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 17:28:00 -0700
Received: from twshared10425.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 17:27:58 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id 589328C47A37; Thu,  1 Sep 2022 17:27:50 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2 bpf-next 00/17] bpf: net: Remove duplicated code from bpf_getsockopt()
Date:   Thu, 1 Sep 2022 17:27:50 -0700
Message-ID: <20220902002750.2887415-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: oho68MVZKNliihQdinKCiFh27OLLMahN
X-Proofpoint-GUID: oho68MVZKNliihQdinKCiFh27OLLMahN
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_12,2022-08-31_03,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

The earlier commits [0] removed duplicated code from bpf_setsockopt().
This series is to remove duplicated code from bpf_getsockopt().

Unlike the setsockopt() which had already changed to take
the sockptr_t argument, the same has not been done to
getsockopt().  This is the extra step being done in this
series.

[0]: https://lore.kernel.org/all/20220817061704.4174272-1-kafai@fb.com/

v2:
- The previous v2 did not reach the list. It is a resend.
- Add comments on bpf_getsockopt() should not free
  the saved_syn (Stanislav)
- Explicitly null-terminate the tcp-cc name (Stanislav)

Martin KaFai Lau (17):
  net: Change sock_getsockopt() to take the sk ptr instead of the sock
    ptr
  bpf: net: Change sk_getsockopt() to take the sockptr_t argument
  bpf: net: Avoid sk_getsockopt() taking sk lock when called from bpf
  bpf: net: Change do_tcp_getsockopt() to take the sockptr_t argument
  bpf: net: Avoid do_tcp_getsockopt() taking sk lock when called from
    bpf
  bpf: net: Change do_ip_getsockopt() to take the sockptr_t argument
  bpf: net: Avoid do_ip_getsockopt() taking sk lock when called from bpf
  net: Remove unused flags argument from do_ipv6_getsockopt
  net: Add a len argument to compat_ipv6_get_msfilter()
  bpf: net: Change do_ipv6_getsockopt() to take the sockptr_t argument
  bpf: net: Avoid do_ipv6_getsockopt() taking sk lock when called from
    bpf
  bpf: Embed kernel CONFIG check into the if statement in bpf_getsockopt
  bpf: Change bpf_getsockopt(SOL_SOCKET) to reuse sk_getsockopt()
  bpf: Change bpf_getsockopt(SOL_TCP) to reuse do_tcp_getsockopt()
  bpf: Change bpf_getsockopt(SOL_IP) to reuse do_ip_getsockopt()
  bpf: Change bpf_getsockopt(SOL_IPV6) to reuse do_ipv6_getsockopt()
  selftest/bpf: Add test for bpf_getsockopt()

 include/linux/filter.h                        |   3 +-
 include/linux/igmp.h                          |   4 +-
 include/linux/mroute.h                        |   6 +-
 include/linux/mroute6.h                       |   4 +-
 include/linux/sockptr.h                       |   5 +
 include/net/ip.h                              |   2 +
 include/net/ipv6.h                            |   4 +-
 include/net/ipv6_stubs.h                      |   2 +
 include/net/sock.h                            |   2 +
 include/net/tcp.h                             |   2 +
 net/core/filter.c                             | 220 ++++++++----------
 net/core/sock.c                               |  51 ++--
 net/ipv4/igmp.c                               |  22 +-
 net/ipv4/ip_sockglue.c                        |  98 ++++----
 net/ipv4/ipmr.c                               |   9 +-
 net/ipv4/tcp.c                                |  92 ++++----
 net/ipv6/af_inet6.c                           |   1 +
 net/ipv6/ip6mr.c                              |  10 +-
 net/ipv6/ipv6_sockglue.c                      |  95 ++++----
 net/ipv6/mcast.c                              |   8 +-
 .../selftests/bpf/progs/bpf_tracing_net.h     |   1 +
 .../selftests/bpf/progs/setget_sockopt.c      | 148 ++++--------
 22 files changed, 379 insertions(+), 410 deletions(-)

--=20
2.30.2

