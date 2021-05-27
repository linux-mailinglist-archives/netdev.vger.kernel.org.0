Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84433937CB
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 23:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbhE0VN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 17:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233387AbhE0VNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 17:13:55 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD73C061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 14:12:21 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id k4so2169984qkd.0
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 14:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2PO0dl4d0zdkZqHioEGkmfd8OJxhhsiQ9r0se5fDwAk=;
        b=KGzLkXu+HUuU4nLhwC3exh79lhh52cbFcAzFMnnDcjD8Ikd2O91vF+HZQF+8Y0Ocm9
         Lr4TJ3UP7+mjHVNzd8YuiYLJ5j02caWV+rr+qSvPjtAf6DcaqK+HATPxEXdx1pFKM15u
         aTSzYM3BQcuTOM68E1dycQa50czbL6UdjunUBNfiZ6Y1upoqMfTPG9H01Qavh95kPyem
         CX5s5W8d5/BWGIrRHDAa5XUTVfDcp6fFAEpqdD83iH1jxh2/x4eTx/hzNIXS4F4ctMrD
         fs1Ht+uQtFjHFODoq+eQCfqdkSQF6zHF4HA1c3kp9XihpMckM4WR5DCX+nr3K3JzE+ds
         oGdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2PO0dl4d0zdkZqHioEGkmfd8OJxhhsiQ9r0se5fDwAk=;
        b=nZcFNnEITsVqbCwHBfLGv8KXhn1UdkFzAys7urBef+bJRHCVaGuqHPSDBAsBk05DdU
         ELgb924ljz1CRxVn7MAvKTxKYl4aX83bBq4/gSZ1urvRJ2/DUbpySviw7/gtrZuwNJzP
         IMtSm2bIkBMoBaqCGLdPRyTwhRbQeY+nr/W+qRfZprETdYHO35c6FU8QzmJo//Mb10L2
         oWDmqEZueAA+JSK249M9sbR9gnIawR1npz2xl5RS76HGMyMq2xOc+iZ92Q9u4NUf/F+R
         XoK/vrYlVNEQTZWAoE5N1vmhP6VNPLEaYD4FeqDFc4Z1jmwLMhMbiKtGA7+tRITm7ELf
         vQRw==
X-Gm-Message-State: AOAM531dzD9+tOMNHLVRlsDeSJZg9IpmGknu9kLK2ng4lwsfBj3yf+QX
        nkXrfbns57RpI0IwJDPFVR3m5g3/iFk=
X-Google-Smtp-Source: ABdhPJwEizOmbQ93QIBxrI2aVV+xyGWkMQqo12NDqiZEbXZPLCJGJ7oUAvH/HJoQMtu1kQ0wi+LXog==
X-Received: by 2002:a05:620a:2f9:: with SMTP id a25mr483648qko.401.1622149940726;
        Thu, 27 May 2021 14:12:20 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:2437:9aae:c493:2542])
        by smtp.gmail.com with ESMTPSA id f19sm2271362qkg.70.2021.05.27.14.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 14:12:20 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next 0/3] virtio_net: add optional flow dissection in virtio_net_hdr_to_skb
Date:   Thu, 27 May 2021 17:12:11 -0400
Message-Id: <20210527211214.1960922-1-tannerlove.kernel@gmail.com>
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
 net/core/filter.c                             |  55 ++++++
 net/core/flow_dissector.c                     |  23 ++-
 net/core/sysctl_net_core.c                    |  10 +
 tools/include/uapi/linux/bpf.h                |   6 +
 tools/testing/selftests/bpf/progs/bpf_flow.c  | 187 +++++++++++++-----
 .../selftests/bpf/test_flow_dissector.c       | 181 ++++++++++++++---
 .../selftests/bpf/test_flow_dissector.sh      |  19 ++
 12 files changed, 469 insertions(+), 79 deletions(-)

-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

