Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D521E23A8
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 16:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgEZOGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 10:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgEZOGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 10:06:05 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F84C03E96D;
        Tue, 26 May 2020 07:06:04 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id b190so10213248pfg.6;
        Tue, 26 May 2020 07:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5mDdR8TlEXwMvyyWunjaWH2WvwrYiXWQGZa63vaj38o=;
        b=tlHdAwhNHOMrWLEH2oQFTphzKc03DAoAq0bXJNpF9TGNpq6AJ9qGTS9WYq/cva/b/N
         2lcaROunVrfLdl5LYjz6KGQkDIzleJeCdZRrzk6A8eW2knNpZS6FIbW++azcTe9s0ee+
         v3HJpXYvTtPrIXnfJfvioVK7OzAakzvFuXsu2nGS0p05JbhPz5uYXXreA7vxqJZk6cW7
         qIYd+E1OtPHA3aOPTjY56POEYLcbpMF9MAi73jajZWYU75mL2wWWLgRS6TYEiY4S50ia
         DtAx6+GmktoCViqbxIWD5oRZf8R+/+oPZtAnPBw2N4c0CyJpZOPFPc6u8KsTJE6mAChZ
         xG1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5mDdR8TlEXwMvyyWunjaWH2WvwrYiXWQGZa63vaj38o=;
        b=XppcYNL+2P/Ezjqz0cRy/Ps73O5TLU+M+gbPD1eVbUzBoFMNkQEai2ZkwIQ8CT3+BH
         5az554Ps99F5XkA7SRHy1wQ28g+6K+yJ5IlYMHC4kr5A6VXuEzhX11HhfQUlwJSVHg/Z
         0DDel1HYr6EWXiFQUR7PmEZjvZc1tK7A8mLIX6FbKbBC6kKaiXsb1s6Itkuzp5zvKMrx
         Hd28PcOTGYP+l+SDBjNCJLhxtRQxuJIGINzp24i0uB8WlURgzAMjmLm3dl/UQQEGVZa4
         40ES9I5sfHrN1VTBLkEnAZgAAfbMAOk0IsPL+GeNf3St+kjBJTJbiSG7pUVSZrM50vk8
         8Vuw==
X-Gm-Message-State: AOAM532QB9+Jeg405Od8RwIV3jXApVUlrRH1zEzPDy8Eql8APCVVePG6
        FXrn8Niah9baPDuSBSZUuHsiGZtiQJVbjg==
X-Google-Smtp-Source: ABdhPJxzrP3pICWeazMKTcvplXMuMbnMipwctMPk0PHgF83NliGgWCZIRGEwuuNBVSQawprzgp6lRQ==
X-Received: by 2002:a63:fd57:: with SMTP id m23mr1280344pgj.325.1590501962383;
        Tue, 26 May 2020 07:06:02 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q201sm15506859pfq.40.2020.05.26.07.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 07:06:01 -0700 (PDT)
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
Subject: [PATCHv4 bpf-next 0/2] xdp: add dev map multicast support
Date:   Tue, 26 May 2020 22:05:37 +0800
Message-Id: <20200526140539.4103528-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200415085437.23028-1-liuhangbin@gmail.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patchset is for xdp multicast support, which has been discussed
before[0]. The goal is to be able to implement an OVS-like data plane in
XDP, i.e., a software switch that can forward XDP frames to multiple
ports.

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

The example in patch 2 is functional, but not a lot of effort
has been made on performance optimisation. I did a simple test(pkt size 64)
with pktgen. Here is the test result with BPF_MAP_TYPE_DEVMAP_HASH
arrays:

bpf_redirect_map() with 1 ingress, 1 egress:
generic path: ~1600k pps
native path: ~980k pps

bpf_redirect_map_multi() with 1 ingress, 3 egress:
generic path: ~600k pps
native path: ~480k pps

bpf_redirect_map_multi() with 1 ingress, 9 egress:
generic path: ~125k pps
native path: ~100k pps

The bpf_redirect_map_multi() is slower than bpf_redirect_map() as we loop
the arrays and do clone skb/xdpf. The native path is slower than generic
path as we send skbs by pktgen. So the result looks reasonable.

We need also note that the performace number will get slower if we use large
BPF_MAP_TYPE_DEVMAP arrays.

Last but not least, thanks a lot to Jiri, Eelco, Toke and Jesper for
suggestions and help on implementation.

[0] https://xdp-project.net/#Handling-multicast

v4: Fix bpf_xdp_redirect_map_multi_proto arg2_type typo

v3: Based on Toke's suggestion, do the following update
a) Update bpf_redirect_map_multi() description in bpf.h.
b) Fix exclude_ifindex checking order in dev_in_exclude_map().
c) Fix one more xdpf clone in dev_map_enqueue_multi().
d) Go find next one in dev_map_enqueue_multi() if the interface is not
   able to forward instead of abort the whole loop.
e) Remove READ_ONCE/WRITE_ONCE for ex_map.
f) Add rxcnt map to show the packet transmit speed in sample test.
g) Add performace test number.

I didn't split the tools/include to a separate patch because I think
they are all the same change, and I saw some others also do like this.
But I can re-post the patch and split it if you insist.

v2:
Discussed with Jiri, Toke, Jesper, Eelco, we think the v1 is doing
a trick and may make user confused. So let's just add a new helper
to make the implementation more clear.

Hangbin Liu (2):
  xdp: add a new helper for dev map multicast support
  sample/bpf: add xdp_redirect_map_multicast test

 include/linux/bpf.h                       |  20 +++
 include/linux/filter.h                    |   1 +
 include/net/xdp.h                         |   1 +
 include/uapi/linux/bpf.h                  |  22 ++-
 kernel/bpf/devmap.c                       | 124 ++++++++++++++
 kernel/bpf/verifier.c                     |   6 +
 net/core/filter.c                         | 101 ++++++++++-
 net/core/xdp.c                            |  26 +++
 samples/bpf/Makefile                      |   3 +
 samples/bpf/xdp_redirect_map_multi.sh     | 133 +++++++++++++++
 samples/bpf/xdp_redirect_map_multi_kern.c | 112 ++++++++++++
 samples/bpf/xdp_redirect_map_multi_user.c | 198 ++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h            |  22 ++-
 13 files changed, 762 insertions(+), 7 deletions(-)
 create mode 100755 samples/bpf/xdp_redirect_map_multi.sh
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c

-- 
2.25.4

