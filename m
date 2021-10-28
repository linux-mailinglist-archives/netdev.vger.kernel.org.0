Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5198443DDFE
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 11:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhJ1Jut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 05:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhJ1Jus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 05:50:48 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF0FC061745
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 02:48:21 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id s13so1909183wrb.3
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 02:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=diHVjz1WhrjX75ZOoRS+Bny9Hg9Bwrniy+m7QlCdwYs=;
        b=iUfCTIoncygx0YnWQYW+UWjjDHOYYyKRKp2J6jtpkVESAVqxQgSPpUtTt3Zf9iZafM
         kzn5Y2gHgrLBUYhwCN7KypmNUQQn48S+d+rHRRhn5XIAYxuyyKIQzrOlOTQafFw9v4Te
         wzwen6ixvOMRfwuAtnFDjIP6Ho5rPVlbFb2tg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=diHVjz1WhrjX75ZOoRS+Bny9Hg9Bwrniy+m7QlCdwYs=;
        b=AXag0akwZqDIDuGF22zG6VKmp5ogekn68L0aRjLsG7vyxWsnHpNxNKWe9AcNwLv6bh
         QePVNuBWBrRcCL/euPeM2kwK1ITeKSSYcVQXT/7HPxhlcsqKlxhvvCRx2dD/XTug5rGj
         SutSTeZLjeOIvUrI4Lpk0k9yq3j+fB/BeaU+OY1MCwy2n3I0MxEL/jokFT6H5gypG2g7
         6qYR3qepFsR4pMe8xseXNtKbmC2EPg3ut0X7Y2V5AqWsULY+Qs0WRL7xwErCZvDdNIiE
         Vs8ZElT/pL6HsCxTL/z1QGXbT+H7Z7/1r8gG7o41B5jFi0PWSaO4ZxszOhfu3PunzZsy
         FKtA==
X-Gm-Message-State: AOAM531OVKstdHt5b381BhSj1ndf60Z1mSFxLXsv6384K5L/lM6itGuQ
        US5cVtrTiLmRxT1kUSi1itfZyuRO6cfIUw==
X-Google-Smtp-Source: ABdhPJxQwK82OCyiLT+soGx28WhlUDexNTS1YVvXDZAP/5uAg03hiJCeldbDzk6Qh2+n0TfSwEycJQ==
X-Received: by 2002:a5d:4949:: with SMTP id r9mr4140560wrs.439.1635414499634;
        Thu, 28 Oct 2021 02:48:19 -0700 (PDT)
Received: from altair.lan (2.f.6.6.b.3.3.0.3.a.d.b.6.0.6.0.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:606:bda3:33b:66f2])
        by smtp.googlemail.com with ESMTPSA id i6sm3378029wry.71.2021.10.28.02.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 02:48:19 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     viro@zeniv.linux.org.uk, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     mszeredi@redhat.com, gregkh@linuxfoundation.org,
        Lorenz Bauer <lmb@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 0/4] Support RENAME_EXCHANGE on bpffs
Date:   Thu, 28 Oct 2021 10:47:20 +0100
Message-Id: <20211028094724.59043-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for renameat2(RENAME_EXCHANGE) on bpffs. This is useful
for atomic upgrades of our sk_lookup control plane.

v3:
- Re-use shmem_exchange (Miklos)

v2:
- Test exchanging a map and a directory (Alexei)
- Use ASSERT macros (Andrii)

Lorenz Bauer (4):
  libfs: move shmem_exchange to simple_rename_exchange
  libfs: support RENAME_EXCHANGE in simple_rename()
  selftests: bpf: convert test_bpffs to ASSERT macros
  selftests: bpf: test RENAME_EXCHANGE and RENAME_NOREPLACE on bpffs

 fs/libfs.c                                    | 29 ++++++-
 include/linux/fs.h                            |  2 +
 mm/shmem.c                                    | 24 +-----
 .../selftests/bpf/prog_tests/test_bpffs.c     | 85 ++++++++++++++++---
 4 files changed, 105 insertions(+), 35 deletions(-)

-- 
2.32.0

