Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABDC16655A3
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbjAKICv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbjAKICF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:02:05 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B071275B;
        Wed, 11 Jan 2023 00:01:28 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NsKkt1fX6zqTJ4;
        Wed, 11 Jan 2023 15:56:38 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 11 Jan 2023 16:01:23 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <willemb@google.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <martin.lau@linux.dev>,
        <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>
Subject: [PATCH bpf-next v2 0/2] bpf: Add ipip6 and ip6ip decap support for bpf_skb_adjust_room()
Date:   Wed, 11 Jan 2023 16:01:20 +0800
Message-ID: <cover.1673423199.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ipip6 and ip6ip decap support for bpf_skb_adjust_room().
Main use case is for using cls_bpf on ingress hook to decapsulate
IPv4 over IPv6 and IPv6 over IPv4 tunnel packets.

And add ipip6 and ip6ip decap testcases to verify that
bpf_skb_adjust_room() correctly decapsulate ipip6 and ip6ip
tunnel packets.

$./test_tc_tunnel.sh
ipip
encap 192.168.1.1 to 192.168.1.2, type ipip, mac none len 100
test basic connectivity
0
test bpf encap without decap (expect failure)
Ncat: TIMEOUT.
1
test bpf encap with tunnel device decap
0
test bpf encap with bpf decap
0
OK
ipip6
encap 192.168.1.1 to 192.168.1.2, type ipip6, mac none len 100
test basic connectivity
0
test bpf encap without decap (expect failure)
Ncat: TIMEOUT.
1
test bpf encap with tunnel device decap
0
test bpf encap with bpf decap
0
OK
ip6ip6
encap fd::1 to fd::2, type ip6tnl, mac none len 100
test basic connectivity
0
test bpf encap without decap (expect failure)
Ncat: TIMEOUT.
1
test bpf encap with tunnel device decap
0
test bpf encap with bpf decap
0
OK
sit
encap fd::1 to fd::2, type sit, mac none len 100
test basic connectivity
0
test bpf encap without decap (expect failure)
Ncat: TIMEOUT.
1
test bpf encap with tunnel device decap
0
test bpf encap with bpf decap
0
OK
...
OK. All tests passed

v2:
  - Use decap flags to indicate the new IP header.
    Do not rely on skb->encapsulation.

Ziyang Xuan (2):
  bpf: Add ipip6 and ip6ip decap support for bpf_skb_adjust_room()
  selftests/bpf: add ipip6 and ip6ip decap to test_tc_tunnel

 include/uapi/linux/bpf.h                      |  8 ++
 net/core/filter.c                             | 26 +++++-
 tools/include/uapi/linux/bpf.h                |  8 ++
 .../selftests/bpf/progs/test_tc_tunnel.c      | 91 ++++++++++++++++++-
 tools/testing/selftests/bpf/test_tc_tunnel.sh | 15 +--
 5 files changed, 139 insertions(+), 9 deletions(-)

-- 
2.25.1

