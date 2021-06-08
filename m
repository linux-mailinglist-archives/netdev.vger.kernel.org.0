Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A17639FD02
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 19:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbhFHREh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 13:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbhFHREg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 13:04:36 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934D1C061574
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 10:02:28 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id i67so20858311qkc.4
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 10:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AedxjGUrrA4tLsBI3MH1ygUrScEWxG3LA5D9Je0HER4=;
        b=tvc5g0dKgdI2NSE1wxFlHhI9OuKnTXcRx8B4YbfW1txiSQ4bF40cvb+uBcQNpcksUD
         0n1TAoaQYiaKJrQLbmMxXbuSOBGBaFHe4SluffdKp1el/DPpiIvFFh8YRQ72kLAY6zqa
         KCNWN2BQhAJihM3fmG7WIlb+YrnSz4iDQESLe/ByODINjObP0Cv0hroc99zj+uOgw5Pb
         5K6CAfWDh55eG+fP6BB5+bkcuFn/QDWVOc937J/MLByuIS+sGuB3v9PQVj5y5f9uBpv9
         ZgOW7wFuk3w99NDM9yYuNZKLgBEM/7PHJJBzqkvU/ll6bvEJ+9xGtHv6UecLruNrUpBQ
         lChQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AedxjGUrrA4tLsBI3MH1ygUrScEWxG3LA5D9Je0HER4=;
        b=fNFZMgC1dzC3m0TlMnmWQGy41VWuEyqhdTEYft9bp9rks94sVJeNizwu4JmomB8nHG
         8d9ovMEVofC+Bdy7Cjr3aU+e3HwacpA/Yhu1LXBHeww92Mn+iqqOFeKNOt3rP8cPeKzh
         plUqDjdFuV/hOCz3EJMgCWwk1ZZQUUi9TZE8TbO8dKmMKuO4jhwHFjM1iZ3Xzpp3AjT3
         UjqnLhtFjPDq1PLoksM/zj+oIL4d60lsJWFk7EBEbrpX3PQJJ4U6Mess6Uo4MqDPJpU8
         xYMaPaPtCYuLHiA0gryVKDsK2cKNLFaAgz11sN9vOHL7qKuBUUgf7savawFe2XoWWBEG
         E6cQ==
X-Gm-Message-State: AOAM533ChkGv4Te78LywSHBddP7xvHEKbYhZhwZzA/uLMNW4Rs5fYa9B
        EPSCMzGnwDniB4UgpAAcHgt3WLQ3tXg=
X-Google-Smtp-Source: ABdhPJz/abGVGWgjbJ35VlVshxbBfyEtFw09E5iUc74wO0+00oBOEBaQ1fBQQPenZ8EowoYBwTi/Lw==
X-Received: by 2002:a37:a703:: with SMTP id q3mr22426668qke.269.1623171747575;
        Tue, 08 Jun 2021 10:02:27 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:1000:9f44:8134:602c:7e3e])
        by smtp.gmail.com with ESMTPSA id 97sm10969017qte.20.2021.06.08.10.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 10:02:27 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next v4 0/3] virtio_net: add optional flow dissection in virtio_net_hdr_to_skb
Date:   Tue,  8 Jun 2021 13:02:21 -0400
Message-Id: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

First patch extends the flow dissector BPF program type to accept
virtio-net header members.

Second patch uses this feature to add optional flow dissection in
virtio_net_hdr_to_skb(). This allows admins to define permitted
packets more strictly, for example dropping deprecated UDP_UFO
packets.

Third patch extends kselftest to cover this feature.

Tanner Love (3):
  net: flow_dissector: extend bpf flow dissector support with vnet hdr
  virtio_net: add optional flow dissection in virtio_net_hdr_to_skb
  selftests/net: amend bpf flow dissector prog to do vnet hdr validation

 drivers/net/bonding/bond_main.c               |   2 +-
 include/linux/bpf.h                           |   2 +
 include/linux/skbuff.h                        |  35 ++-
 include/linux/virtio_net.h                    |  25 ++-
 include/uapi/linux/bpf.h                      |   2 +
 kernel/bpf/verifier.c                         |  48 +++-
 net/bpf/test_run.c                            |   2 +-
 net/core/filter.c                             |  26 +++
 net/core/flow_dissector.c                     |  19 +-
 net/core/sysctl_net_core.c                    |   9 +
 tools/include/uapi/linux/bpf.h                |   2 +
 tools/testing/selftests/bpf/progs/bpf_flow.c  | 208 ++++++++++++++----
 .../selftests/bpf/test_flow_dissector.c       | 181 +++++++++++++--
 .../selftests/bpf/test_flow_dissector.sh      |  19 ++
 14 files changed, 495 insertions(+), 85 deletions(-)

-- 
2.32.0.rc1.229.g3e70b5a671-goog

