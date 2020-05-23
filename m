Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17AC1DF516
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 08:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387637AbgEWGGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 02:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387621AbgEWGGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 02:06:10 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90499C061A0E;
        Fri, 22 May 2020 23:06:10 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id f15so5286700plr.3;
        Fri, 22 May 2020 23:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AZifmcFnH0nsNq1yufHEcmAjs87ZEXzPDrtWH0pQJMM=;
        b=IRC3Az5T0d8rrF5uy5gKGs2Vr9HWwErhB/nDlRoGlCGwG64Hi7KS50fR4HGcEvL7I7
         0kRSkhaePlSyCim8KJF7+qnFN/tcP7E6JheCBt1Oo/igPaERsreoix+qi35MpivBizRh
         rtIRLeWrkjJdPjF/imKDYX6eMw+NuXQWEA6W8vcHwFAl5tCLi1bpOxaZOog6hnIsQfK1
         5untbT3VdI3sh8oxCnPwjnyjpDQKiL3euSPIHXL5fp719l1zjagwi10rr9C9uDd56M9R
         cy7rKzqAYnO+5npb5+WeUVteldYu3arOLp5TdWm4tUfzQhh6OJkQP23PwfDClQsScW6I
         kVkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AZifmcFnH0nsNq1yufHEcmAjs87ZEXzPDrtWH0pQJMM=;
        b=rFt7F9L4ZAcI1/tbiN0ToOwxzuq/de7zo4FY5ToRI/audtzW1Sr9UhRMiFth+HZRN8
         D/qKssR7x+yZ1At5V8Hk7ca0UrCAGZg8YtNaKPpUbGQWhwldlXQCnTXPa23L+Qy1kUDi
         wzlCIXpEMX35Ax6j8QYw/fvxqnnDbWiljrbYIxB5U6tQsGNywcYrnN1t+LLAfzUz6C52
         hdUR0ev4eKPtINnNNpvn3HScItck9SZnXJgFWQQg606OYGnRgp0BGHl7Bl0SNjp7MOdj
         MrV2/LchKwvv13/vlrADfhMPlJrHmyACLkMcjfwhWhkpj1/3MiBhULq8OKnED7arhZPf
         x2qQ==
X-Gm-Message-State: AOAM53075Tc1RaYkFxFnbt4XD1X8IDl4aW8Iy3irktfTO/zFw5WZq6ns
        cyUX3yQxP5sU0aPp8zVJqIkZVYYLlm2pTw==
X-Google-Smtp-Source: ABdhPJyuCgQLSmOED46T9JAkEWJymKltnO4DlfnuuYSVfd8qobMpxEZqbPREj8OZP9dB5AGBcxA1Iw==
X-Received: by 2002:a17:90a:17e6:: with SMTP id q93mr8003937pja.133.1590213969790;
        Fri, 22 May 2020 23:06:09 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a2sm8259780pfl.12.2020.05.22.23.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 23:06:09 -0700 (PDT)
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
Subject: [PATCHv3 bpf-next 0/2] xdp: add dev map multicast support
Date:   Sat, 23 May 2020 14:05:35 +0800
Message-Id: <20200523060537.264096-1-liuhangbin@gmail.com>
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

