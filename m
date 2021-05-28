Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30EE6393B5D
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 04:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236052AbhE1C3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 22:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbhE1C3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 22:29:43 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021F8C061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 19:28:09 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id u33so1197354qvf.9
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 19:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kmAhOyl48lcesngCq8Ggo58RmX1+7F3BQGH+L2Kn+NE=;
        b=LPXHS9H1Qnxusy78lZrK3DG57DNv1ewdMNP0YR4N/YKUpHJjzkQv/ovoFZWm1NzlE3
         njGPOpOuqqFGsKtkbJO0+kzi9Pgs0k8aSAjixczfHnV0kExCzCmf6xySh1KbTTuR4pBp
         iyFtOkqWt1QGc8VZAeSvs5McGgFyRWP7fThEBe4gDrAn8dEy++ffxEFtuMuWTe4f2gXr
         RHUAdMxpdryH+8Y7772RIF3kylaBnilW/0ql7iyRGhfpDaiO6887G1D5xSBoIurWMspg
         /D0WU0ugLhngVygBHlU8gLYCVY4zW4vcJVAW73JU4Aw/6wY5QvXXV7Oo+n6BIpY55w1k
         MPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kmAhOyl48lcesngCq8Ggo58RmX1+7F3BQGH+L2Kn+NE=;
        b=D9b6zLskmca/vQBHZSIE9ejAz27BcldwEOZEv5q5LqxNvBVCrlorn6JjAzySb2vZRG
         yg3uFivLKd97cFEEomJbZDKlIKocJqnVmB93JHfwpf3w6EUCl9gdXQxGwLmMrhhSyBlM
         2FajrnCYlf9fKJWLksQ/WmjL2Tl0PesOwjRVk6DR+FVn7ewG41nDC8cYrODBC32FQiRH
         yKV1uLx302CwYhF/afIP9iMGHzHHwDowBph2mPyTLDDFoOkW2h68KXNTEpFPRPFvqsiT
         ta/nP5I1swUimEWmherb5iEUSspZvJvAQMTMOYnmmwa2CE/ZXBKkd3bMlB0DeAtYqfAB
         D+VQ==
X-Gm-Message-State: AOAM530QK+6IAxqqFoWbOrc67oO/eH3rTFAzmX4LDk35gHhw/98N+hf+
        FYXrk0zQVAwHmiiuPrjDYZDiymTwxtI=
X-Google-Smtp-Source: ABdhPJw5RkJrLPr2D/0jHLqf6YfKjWK46URWdegQKVcrMh/1UUdQYfhm00CBCZxSg54WuSTYFjW3hQ==
X-Received: by 2002:ad4:4a83:: with SMTP id h3mr1725701qvx.19.1622168888030;
        Thu, 27 May 2021 19:28:08 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:2437:9aae:c493:2542])
        by smtp.gmail.com with ESMTPSA id a14sm2488071qtj.57.2021.05.27.19.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 19:28:07 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next v2 0/3] virtio_net: add optional flow dissection in virtio_net_hdr_to_skb
Date:   Thu, 27 May 2021 22:28:00 -0400
Message-Id: <20210528022803.778578-1-tannerlove.kernel@gmail.com>
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
 include/linux/virtio_net.h                    |  27 ++-
 include/net/flow_dissector.h                  |   6 +
 include/uapi/linux/bpf.h                      |   6 +
 net/core/filter.c                             |  55 +++++
 net/core/flow_dissector.c                     |  24 ++-
 net/core/sysctl_net_core.c                    |  10 +
 tools/include/uapi/linux/bpf.h                |   6 +
 tools/testing/selftests/bpf/progs/bpf_flow.c  | 188 +++++++++++++-----
 .../selftests/bpf/test_flow_dissector.c       | 181 +++++++++++++++--
 .../selftests/bpf/test_flow_dissector.sh      |  19 ++
 12 files changed, 470 insertions(+), 80 deletions(-)

-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

