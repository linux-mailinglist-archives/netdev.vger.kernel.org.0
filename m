Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33285252F83
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 15:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730228AbgHZNUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 09:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbgHZNUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 09:20:19 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC13C061574;
        Wed, 26 Aug 2020 06:20:18 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id v15so1016885pgh.6;
        Wed, 26 Aug 2020 06:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4lEiv1+g42tak/pNBpAE9OgTskqsd570J5NbrgTF+rw=;
        b=nNtQ3v1BVgsx4TRI7w62tgAa3GApt9C4fEWT4Fzp7DgUe3yJnRieVQdqBJwDO7ABen
         fjbAT0gWhWcuIAwcnZGp8hAyn9uzMHR86lCmiLHJ+KXIL2YuKnH6gjHnyLdxdbT4dgwo
         owTuVTLeBNQxWLXebUk35aAS0TuV1jIe0j+5DV+1vkvV40XN8byYfFiwlfe6ogs+LbtQ
         HBe2YRB4u+iyINEkGL3rciNfxWE38w+nZA2PCWXPMNMHMhRdmcVb6Y8//7tK+L6rMKOq
         cX3IW596PZj9xsqrcnlFDJwZiA51H4Q7DF97sTY0YsCib7slwOCdwMHcukUBfDmbySw4
         Jb7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4lEiv1+g42tak/pNBpAE9OgTskqsd570J5NbrgTF+rw=;
        b=n1YSPoGVUTZ/o064OOinJrdsok1x/4nExgGkXWrXK6NwJHeg3H4wUUg6Uan99hnfGl
         HMx72mFs0JY94aF57J2lX3IXe5ocqezmmin/DZ3imRx5kOZSOtSkDlsIbmBBXlTRMvJM
         3Btm1vpRzVdFYxu+bVh90jYqB66FOufvB1Yi46GKgjshV/yAgC3Ilb/tY1DqDlGrmuqm
         nMeO1sdcLX8rF6xwBXzF5sCV8cjz2jY4/lZdLUrpSUIpTIAxQlLdb1DmedfNGoQR03qd
         LBktB1oVdr4sDLV5MaGO+PEKNubBsFkNbYRjwhfvsc1i4TM6VuS32LZTypJDOgAszHb4
         2FEA==
X-Gm-Message-State: AOAM531OMvrVRaqO6Zf+2QqHJgupP4yHWlKtQ3XYS3/Wo7dyvkRVcn1z
        TSJVb46iY11LSejG6ky5U6rbucwZdm4UR4aF
X-Google-Smtp-Source: ABdhPJyN1F2uNljjQzI2Bikxr5uHOZflMJqPqx/eUC6MyCnzUFa5Abc2EwFLCV18QVIGOWv7RtGmzA==
X-Received: by 2002:a63:30c6:: with SMTP id w189mr10298599pgw.241.1598448017984;
        Wed, 26 Aug 2020 06:20:17 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s129sm3131794pfb.39.2020.08.26.06.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 06:20:16 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko B <andrii.nakryiko@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv9 bpf-next 0/5] xdp: add a new helper for dev map multicast support
Date:   Wed, 26 Aug 2020 21:19:57 +0800
Message-Id: <20200826132002.2808380-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200715130816.2124232-1-liuhangbin@gmail.com>
References: <20200715130816.2124232-1-liuhangbin@gmail.com>
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
needs to be a group (instead of just a single port index), because there
may have multi interfaces you want to exclude.

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

The 1st patch add a new bpf arg to allow NULL map pointer.
The 2nd patch add the new bpf_redirect_map_multi() helper.
The 3rd and 4th patches are for usage sample and testing purpose, there
is no effort has been made on performance optimisation.
The 5th patch added some verifier test for new bpf arg ARG_CONST_MAP_PTR_OR_NULL

I did same tests with pktgen(pkt size 64) to compire with xdp_redirect_map().
Here is the test result(the veth peer has a dummy xdp program with XDP_DROP
directly):

Version         | Test                                   | Native | Generic
5.9 rc1         | xdp_redirect_map       i40e->i40e      |  10.4M |  1.9M
5.9 rc1         | xdp_redirect_map       i40e->veth      |  14.2M |  2.2M
5.9 rc1 + patch | xdp_redirect_map       i40e->i40e      |  10.3M |  1.9M
5.9 rc1 + patch | xdp_redirect_map       i40e->veth      |  14.2M |  2.2M
5.9 rc1 + patch | xdp_redirect_map_multi i40e->i40e      |   8.0M |  1.5M
5.9 rc1 + patch | xdp_redirect_map_multi i40e->veth      |  11.2M |  1.6M
5.9 rc1 + patch | xdp_redirect_map_multi i40e->i40e+veth |   3.5M |  1.1M

The bpf_redirect_map_multi() is slower than bpf_redirect_map() as we loop
the map and do clone skb/xdpf. The generic path is slower than native
path as we send skbs by pktgen. So the result looks reasonable. There is
some performance improvement for veth port compared with 5.8 rc1.

Last but not least, thanks a lot to Toke, Jesper, Jiri and Eelco for
suggestions and help on implementation.

[0] https://xdp-project.net/#Handling-multicast

v9: Merge the new bpf argument type ARG_CONST_MAP_PTR_OR_NULL to this patchset

v8:
a) Update function dev_in_exclude_map():
   - remove duplicate ex_map map_type check in
   - lookup the element in dev map by obj dev index directly instead
     of looping all the map

v7:
a) Fix helper flag check
b) Limit the *ex_map* to use DEVMAP_HASH only and update function
   dev_in_exclude_map() to get better performance.

v6: converted helper return types from int to long

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

Hangbin Liu (5):
  bpf: add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL
  xdp: add a new helper for dev map multicast support
  sample/bpf: add xdp_redirect_map_multicast test
  selftests/bpf: add xdp_redirect_multi test
  selftests/bpf: Add verifier tests for bpf arg
    ARG_CONST_MAP_PTR_OR_NULL

 include/linux/bpf.h                           |  22 +++
 include/linux/filter.h                        |   1 +
 include/net/xdp.h                             |   1 +
 include/uapi/linux/bpf.h                      |  27 +++
 kernel/bpf/devmap.c                           | 124 +++++++++++++
 kernel/bpf/verifier.c                         |  29 ++-
 net/core/filter.c                             | 112 +++++++++++-
 net/core/xdp.c                                |  29 +++
 samples/bpf/Makefile                          |   3 +
 samples/bpf/xdp_redirect_map_multi_kern.c     |  43 +++++
 samples/bpf/xdp_redirect_map_multi_user.c     | 166 +++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  27 +++
 tools/testing/selftests/bpf/Makefile          |   4 +-
 .../bpf/progs/xdp_redirect_multi_kern.c       |  77 ++++++++
 tools/testing/selftests/bpf/test_verifier.c   |  22 ++-
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 164 +++++++++++++++++
 .../testing/selftests/bpf/verifier/map_ptr.c  |  70 +++++++
 .../selftests/bpf/xdp_redirect_multi.c        | 173 ++++++++++++++++++
 18 files changed, 1080 insertions(+), 14 deletions(-)
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

-- 
2.25.4

