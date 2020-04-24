Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618D31B701D
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 10:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgDXI4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 04:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgDXI4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 04:56:24 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906B2C09B045;
        Fri, 24 Apr 2020 01:56:24 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id b1so3637011qtt.1;
        Fri, 24 Apr 2020 01:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iJi32V8l6LY5tluOebJf1kSm8dTn4kAqf6ydh2km4Oo=;
        b=IGCuLqVy9yZl9cPdBG+l5Cu7Cm8ENmf4UL/XMFp5DaWEggqAtdUX12uUGs6oZ7VDcv
         DewrNHMiH36IZG/YbBfWzlJI7CkjfcLHwxNSadjyeRZhD5RNuM8FH6kqy3NWckyIuIoY
         HBOf38+UVyVEqnuP5QKgcTzHaADnRoqxgvEPQttkSJoINOPEZX5dn6zeYb9FIJxHY+xL
         Xb9nY5xhP1dubgxGEEh7pUaeyqFtNFceD22biKBwQhrfbsi3huVKSNKIalONuZPka1sr
         CHXAplNmcg4pqcEFZjPUPE17jyfg72DD5Gt31G/6V3nBspBLFHspwNosvQAuZIlQYZVY
         36Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iJi32V8l6LY5tluOebJf1kSm8dTn4kAqf6ydh2km4Oo=;
        b=k4d6EfeUd5r12etvejRk0mg5zpKa5p9UNpjQM9LSY+ox01FVj77EnWvcsd5320/bcK
         DVFBO0iguUuFpFk1CMQ1Ei5c73t+Rr+U6z+brTrqNmurmHHct2cjewnE/lasMMmqFUV3
         furPIGjSaXK7UR3DNHPxWoFbVxe0x3wmfPycv8VU3nRgphWORajdE2Ma4EkAcdzb571v
         kgwBSxWOiy5ylyfVJ/bQ6vYvriDylAevN/ycoiYy2+Ucig/077t8cIRdA5yEKQBlMhas
         j0F1pRKwy3ddd83EkyQc9RJXNBSruhi4lVNppBQhVpfLEBWNvpPXs5kyiMlYjNOKwKVX
         FUOQ==
X-Gm-Message-State: AGi0PuYeSbSs1IELBaXoJOaqWz1J4uqFyJnXC5L7URHD3BaNantFAMxl
        t61/dNbebA9c+2f+HfM6NcgtgFjm5OA=
X-Google-Smtp-Source: APiQypLeOfUjAsDI6Z8izA6pOWxRJjyJUipUFWjrBms+T6BpXYh4iicUamjmkeWuTLkPQcUrHfmzGA==
X-Received: by 2002:ac8:6ecd:: with SMTP id f13mr8489847qtv.114.1587718583424;
        Fri, 24 Apr 2020 01:56:23 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z18sm3390842qti.47.2020.04.24.01.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 01:56:22 -0700 (PDT)
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
Subject: [RFC PATCHv2 bpf-next 0/2] xdp: add dev map multicast support
Date:   Fri, 24 Apr 2020 16:56:08 +0800
Message-Id: <20200424085610.10047-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200415085437.23028-1-liuhangbin@gmail.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This is a prototype for xdp multicast support, which has been discussed
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

For this RFC series we are primarily looking for feedback on the concept
and API: the example in patch 2 is functional, but not a lot of effort
has been made on performance optimisation.

Last but not least, thanks a lot to Jiri, Eelco, Toke and Jesper for
suggestions and help on implementation.

[0] https://xdp-project.net/#Handling-multicast

v2: Discussed with Jiri, Toke, Jesper, Eelco, we think the v1 is doing
a trick and may make user confused. So let's just add a new helper
to make the implemention more clear.

Hangbin Liu (2):
  xdp: add a new helper for dev map multicast support
  sample/bpf: add xdp_redirect_map_multicast test

 include/linux/bpf.h                       |  20 +++
 include/linux/filter.h                    |   1 +
 include/net/xdp.h                         |   1 +
 include/uapi/linux/bpf.h                  |  23 ++-
 kernel/bpf/devmap.c                       | 114 +++++++++++++++
 kernel/bpf/verifier.c                     |   6 +
 net/core/filter.c                         |  98 ++++++++++++-
 net/core/xdp.c                            |  26 ++++
 samples/bpf/Makefile                      |   3 +
 samples/bpf/xdp_redirect_map_multi.sh     | 124 ++++++++++++++++
 samples/bpf/xdp_redirect_map_multi_kern.c | 100 +++++++++++++
 samples/bpf/xdp_redirect_map_multi_user.c | 170 ++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h            |  23 ++-
 13 files changed, 702 insertions(+), 7 deletions(-)
 create mode 100755 samples/bpf/xdp_redirect_map_multi.sh
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c

-- 
2.19.2

