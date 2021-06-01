Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0BF397C52
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbhFAWUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbhFAWU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 18:20:29 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F51C061574
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 15:18:46 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id 76so414428qkn.13
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 15:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p3BBwyic6CK4Masjkpld5z1Gl1lmaP4lgp3Iwlda1gw=;
        b=INR/QhVGZTPClxG0WiwpHDwF9It/ux04bWfOBDk7/TzweQbpm6CcnADh/UUif8CXwH
         NMqLWGw3Qgr2TqMhn+n4z8+8QB5Qhg82ZX1yU1XKhsvD9B0JQRkJK3Pd67b1K/CJIVC9
         C+yTG+p26LTCPu19CIT8SLFu/YlMBkKUkHfA7/PFOobiTv1kaksQbu+CIpqRE6B3U77B
         jP1gHtoRD0NuK/6dK7Om6Y+GHFLGMG4T/x/Q+ldmiXaUcFIdtSWWGz8pO8Kza8IOz9vz
         Nq4UYit/NQ3mHzCe8e4FYT2UcXmdGUY1zTeKaFm/VGa5mNLJUZuypVmBCqgHRaoA0YJp
         ZCgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p3BBwyic6CK4Masjkpld5z1Gl1lmaP4lgp3Iwlda1gw=;
        b=EiInURNdN643uqnmllLu0X36mPmG3x4kxgq6gMy2GvxJA680mJ+3eJLP+K6Xi+C+Ab
         bVvOrFpLwi4pJj5FZdt8SH3kV/V9i6s7BnD4MGX7jorbVugddbQ3iqyaVeO0yJFGGRRa
         +oO6kufFwiPEv/lEAHO+qCCNI/FnV6s68xBzcvIdg+efowtIxkZ2CYRYcUFw7PFUzzIc
         WeO+TwuXINmXOKKgcQwvN9MijCIA5qkbTIBFqkT/BEIAqmgBuaVHVt4AYfIJsA/9Zl4p
         PC93uKVy4+cCoZVk2HP82IvQPYofF7yV2/2TSXy8ukFn7fi+k8y3i95d5M7cT2e+vWP4
         PRLQ==
X-Gm-Message-State: AOAM532EslmvQPbWkeB2BwKqlbp+PFoX1k7C2KY9Qtv5uqEbD5IPvOy7
        wjR7QcOiRjtuYlthOSZVOJlclPQv7sNVlg==
X-Google-Smtp-Source: ABdhPJzJPhHdIvR4l9uf9DptiSfv+mvMR8HTlXGXeKNKvqIgpiAyyImGC6fhpJevC1aneGOSyga06w==
X-Received: by 2002:a37:b0f:: with SMTP id 15mr5014738qkl.210.1622585925179;
        Tue, 01 Jun 2021 15:18:45 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:1000:56ea:5ee7:bba5:d755])
        by smtp.gmail.com with ESMTPSA id n25sm1279282qtr.8.2021.06.01.15.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 15:18:44 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next v3 0/3] virtio_net: add optional flow dissection in virtio_net_hdr_to_skb
Date:   Tue,  1 Jun 2021 18:18:37 -0400
Message-Id: <20210601221841.1251830-1-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
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
 include/linux/skbuff.h                        |  26 ++-
 include/linux/virtio_net.h                    |  25 ++-
 include/net/flow_dissector.h                  |   6 +
 include/uapi/linux/bpf.h                      |   6 +
 net/core/filter.c                             |  55 +++++
 net/core/flow_dissector.c                     |  27 ++-
 net/core/sysctl_net_core.c                    |   9 +
 tools/include/uapi/linux/bpf.h                |   6 +
 tools/testing/selftests/bpf/progs/bpf_flow.c  | 188 +++++++++++++-----
 .../selftests/bpf/test_flow_dissector.c       | 181 +++++++++++++++--
 .../selftests/bpf/test_flow_dissector.sh      |  19 ++
 12 files changed, 470 insertions(+), 80 deletions(-)

-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

