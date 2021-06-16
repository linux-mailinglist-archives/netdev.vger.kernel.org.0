Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CF33AA55C
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 22:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbhFPUhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 16:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbhFPUg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 16:36:59 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA753C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 13:34:51 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id k11so867375qkk.1
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 13:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E1YhaqsTQv8kOwblwCGP1BIsfN0tgl7FTF5byt+nEt8=;
        b=Aj1sNam+pfC8JwYvWveGWXfLvCzLFf5rNS8CpGg9wOOj/8Q+npBkaLen8FQB5D4+c3
         vV8knAuowWH1bJbHYWoUP2lZlB5w0l974ovqOL1GLZxTojUVJ5kTfP2hGDzddqnHtN56
         pNKACinl9vHUiTW4XPnbz2/e4TgwJecJ3UZghRPgXdbOX2jntM92W5tNsuzhrO0BQUBg
         M5/VD1JyhmKqN66bSallfm6e0rt8HKzbpZKIkAfUaBxdRAoIaLRkhcBle/H09Yok/niE
         mAUNHsYRo7XG2a7YBjTdXdMYZYWbKKFIRNamDIbDXxLJK/UZSC2yQVn3F4KkzKpjpFCk
         J6Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E1YhaqsTQv8kOwblwCGP1BIsfN0tgl7FTF5byt+nEt8=;
        b=DRS57DMnKnvyJnjafzqC+4rs1tt0c0lqOnVZiqQWAL+rI5ZSP3SK5DIcK2AUNrbai3
         IkMLV6uSkOAbvQ/BEW65mM16u4ypDhQHe/g/JsJZ532PrwYTxZaL4guIkVP4qgxkFiGK
         wUYVQibouIW6/iKBQu5kKLxRHEbwSwLaegi0y/aR+/LFnfyapEeSiTIoZ921SpRm3v8/
         Z1j7uAzmq+ZlKefN0wknoaVeJgnoLSvCpBmjXYO4uufFQOsQieAHH5DNu1pwZ0EyOcgp
         M2VlYRbt/zlRpD8UhUEOhF/fc3bqy/Oar6NbR6iRsjvDMbs2SMsDTtqRMIpFyAgxSPZT
         qORA==
X-Gm-Message-State: AOAM530MEux8mRzpxETsO35v/moZSiOPdPB7twXe8QMK5FxeoALo+bA9
        tdRabrd5SGQNva2umrg+0EMbvYluGhk=
X-Google-Smtp-Source: ABdhPJzc+mN7Cx//DmgLOtkWJYPt+9r5VkBDFpQx1T1AHBb+JepDwYYo6Hf62I7+472p4QlHRVw/IA==
X-Received: by 2002:a05:620a:44c6:: with SMTP id y6mr172324qkp.353.1623875690771;
        Wed, 16 Jun 2021 13:34:50 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:1000:3395:f164:4389:255f])
        by smtp.gmail.com with ESMTPSA id p2sm267308qkf.76.2021.06.16.13.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 13:34:50 -0700 (PDT)
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
        Martin KaFai Lau <kafai@fb.com>,
        Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next v7 0/3] virtio_net: add optional flow dissection in virtio_net_hdr_to_skb
Date:   Wed, 16 Jun 2021 16:34:45 -0400
Message-Id: <20210616203448.995314-1-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

First patch extends the flow dissector BPF program type to accept
pointer to virtio-net header. 

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
 include/linux/bpf.h                           |   8 +
 include/linux/skbuff.h                        |  35 +++-
 include/linux/virtio_net.h                    |  25 ++-
 include/uapi/linux/bpf.h                      |   1 +
 kernel/bpf/verifier.c                         |  33 +--
 net/bpf/test_run.c                            |   2 +-
 net/core/filter.c                             |  53 +++++
 net/core/flow_dissector.c                     |  39 +++-
 net/core/sysctl_net_core.c                    |   9 +
 tools/include/uapi/linux/bpf.h                |   1 +
 tools/testing/selftests/bpf/progs/bpf_flow.c  | 188 +++++++++++++-----
 .../selftests/bpf/test_flow_dissector.c       | 181 +++++++++++++++--
 .../selftests/bpf/test_flow_dissector.sh      |  19 ++
 14 files changed, 497 insertions(+), 99 deletions(-)

-- 
2.32.0.272.g935e593368-goog

