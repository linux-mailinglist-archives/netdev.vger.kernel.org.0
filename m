Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E04B2102B6
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 06:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgGAEVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 00:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgGAEVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 00:21:09 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC8DC061755;
        Tue, 30 Jun 2020 21:21:08 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u185so8380600pfu.1;
        Tue, 30 Jun 2020 21:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ny/z+Jdd18J3qFH3pTJLjZ7QO1/jG7qWaJcFCq021tQ=;
        b=i3ixCpMnPwfTvM+yia3+SHJHu0H7jX6w5f/ANMHzPUNOW9Vjz/QYsYVkbGU/ePrCf5
         6yu7G5yxuqahMfkMQETAgwYEuGxJDnUamD+mLQlIIiptJENZpCfkf92WqyE8CqwIKapP
         ztghzb75m9Ic8Puj+Ee7sTk+MyEp0MvQMVTZu+AmyPRGqXRQ2EXIDSfs3/Vy7LAOZzOJ
         hbDXdEVVGevjAs1UmhMrpLZxE5YdhZyUVMWR/ob79wt4FBbkNwNzRweWImSGtZNClGvK
         rc6EkoyH1NAVXBA1KvBKhGyTOiQ6VMKjYMPVD+Xg3hZ32gVXnTA3rO1Vt2QvclZTt/E2
         LsJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ny/z+Jdd18J3qFH3pTJLjZ7QO1/jG7qWaJcFCq021tQ=;
        b=bhFOR+K3zBE6uJMp10xDICWAaRcLeQZ/uha6dRdHY+dDlsALKMlYAWln0ToQzNX9sN
         QeKFR2YBhOP/DK0b+/KmisNBRpitO9awnEvQ0oWVXHA167IkkEYbRZKrt2sGd9bE/LiJ
         95C2LS0PPfQrOKTa1soUkibFwrmJHfX4y3kcBTkNAReUJjMRh+mIlLktMlQjaF65uhPM
         yuZekWfqhlZyAIvaFWSKVXZ+OGq71HehSyMqWFZOg1v0Sd+8lADn71VgprYNDRZOezk4
         3KXg7Ck9+PliQH06pMPUvzlEwiS/jmEwjCEBkzrtdahA/fZ9qaPmRMC6JqXvpyAkaVov
         hKTA==
X-Gm-Message-State: AOAM533CkxHEi/jkWdHUTED2sJUXY0SXNtbNgDAHjq4NGqESNG1zi/ci
        pKmzIhe7+PbvTDy4ABqRfGAAmQqycLU=
X-Google-Smtp-Source: ABdhPJzDA/JkSBc1s+/vG2JEcaaUqaFmrOWW1ftR61z2pNE7ZTWsGDOlBXQb51sTRlSNnrtElaOOUw==
X-Received: by 2002:aa7:9630:: with SMTP id r16mr16871051pfg.144.1593577268145;
        Tue, 30 Jun 2020 21:21:08 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h9sm3420227pjs.50.2020.06.30.21.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 21:21:07 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv5 bpf-next 0/3] xdp: add a new helper for dev map multicast support
Date:   Wed,  1 Jul 2020 12:19:35 +0800
Message-Id: <20200701041938.862200-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200526140539.4103528-1-liuhangbin@gmail.com>
References: <20200526140539.4103528-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is for xdp multicast support. which has been discussed before[0],
The goal is to be able to implement an OVS-like data plane in XDP, i.e.,
a software switch that can forward XDP frames to multiple ports.

To achieve this, an application needs to specify a group of interfaces
to forward a packet to. It is also common to want to exclude one or more
physical interfaces from the forwarding operation - e.g., to forward a
packet to all interfaces in the multicast group except the interface it
arrived on. While this could be done simply by adding more groups, this
quickly leads to a combinatorial explosion in the number of groups an
application has to maintain.

To avoid the combinatorial explosion, we propose to include the ability
to specify an "exclude group" as part of the forwarding operation. This
needs to be a group (instead of just a single port index), because a
physical interface can be part of a logical grouping, such as a bond
device.

Thus, the logical forwarding operation becomes a "set difference"
operation, i.e. "forward to all ports in group A that are not also in
group B". This series implements such an operation using device maps to
represent the groups. This means that the XDP program specifies two
device maps, one containing the list of netdevs to redirect to, and the
other containing the exclude list.

To achieve this, I re-implement a new helper bpf_redirect_map_multi()
to accept two maps, the forwarding map and exclude map. If user
don't want to use exclude map and just want simply stop redirecting back
to ingress device, they can use flag BPF_F_EXCLUDE_INGRESS.

The 2nd and 3rd patches are for usage sample and testing purpose, so there
is no effort has been made on performance optimisation. I did same tests
with pktgen(pkt size 64) to compire with xdp_redirect_map(). Here is the
test result(the veth peer has a dummy xdp program with XDP_DROP directly):

Version         | Test                                   | Native | Generic
5.8 rc1         | xdp_redirect_map       i40e->i40e      |  10.0M |   1.9M
5.8 rc1         | xdp_redirect_map       i40e->veth      |  12.7M |   1.6M
5.8 rc1 + patch | xdp_redirect_map       i40e->i40e      |  10.0M |   1.9M
5.8 rc1 + patch | xdp_redirect_map       i40e->veth      |  12.3M |   1.6M
5.8 rc1 + patch | xdp_redirect_map_multi i40e->i40e      |   7.2M |   1.5M
5.8 rc1 + patch | xdp_redirect_map_multi i40e->veth      |   8.5M |   1.3M
5.8 rc1 + patch | xdp_redirect_map_multi i40e->i40e+veth |   3.0M |  0.98M

The bpf_redirect_map_multi() is slower than bpf_redirect_map() as we loop
the arrays and do clone skb/xdpf. The native path is slower than generic
path as we send skbs by pktgen. So the result looks reasonable.

Last but not least, thanks a lot to Jiri, Eelco, Toke and Jesper for
suggestions and help on implementation.

[0] https://xdp-project.net/#Handling-multicast

v5:
a) Check devmap_get_next_key() return value.
b) Pass through flags to __bpf_tx_xdp_map() instead of bool value.
c) In function dev_map_enqueue_multi(), consume xdpf for the last
   obj instead of the first on.
d) Update helper description and code comments to explain that we
   use NULL target value to distinguish multicast and unicast
   forwarding.
e) Update memory model, memory id and frame_sz in xdpf_clone().
f) Split the tests from sample and add a bpf kernel selftest patch.

v4: Fix bpf_xdp_redirect_map_multi_proto arg2_type typo

v3: Based on Toke's suggestion, do the following update
a) Update bpf_redirect_map_multi() description in bpf.h.
b) Fix exclude_ifindex checking order in dev_in_exclude_map().
c) Fix one more xdpf clone in dev_map_enqueue_multi().
d) Go find next one in dev_map_enqueue_multi() if the interface is not
   able to forward instead of abort the whole loop.
e) Remove READ_ONCE/WRITE_ONCE for ex_map.

v2: Add new syscall bpf_xdp_redirect_map_multi() which could accept
include/exclude maps directly.

Hangbin Liu (3):
  xdp: add a new helper for dev map multicast support
  sample/bpf: add xdp_redirect_map_multicast test
  selftests/bpf: add xdp_redirect_multi test

 include/linux/bpf.h                           |  20 ++
 include/linux/filter.h                        |   1 +
 include/net/xdp.h                             |   1 +
 include/uapi/linux/bpf.h                      |  25 ++-
 kernel/bpf/devmap.c                           | 154 ++++++++++++++++
 kernel/bpf/verifier.c                         |   6 +
 net/core/filter.c                             | 109 ++++++++++-
 net/core/xdp.c                                |  29 +++
 samples/bpf/Makefile                          |   3 +
 samples/bpf/xdp_redirect_map_multi_kern.c     |  57 ++++++
 samples/bpf/xdp_redirect_map_multi_user.c     | 166 +++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  25 ++-
 tools/testing/selftests/bpf/Makefile          |   4 +-
 .../bpf/progs/xdp_redirect_multi_kern.c       |  90 +++++++++
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 164 +++++++++++++++++
 .../selftests/bpf/xdp_redirect_multi.c        | 173 ++++++++++++++++++
 16 files changed, 1019 insertions(+), 8 deletions(-)
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

-- 
2.25.4

