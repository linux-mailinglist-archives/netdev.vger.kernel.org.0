Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8671672950
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 21:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjARUaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 15:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjARU3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 15:29:52 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED1154208
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 12:29:23 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id k13so294486plg.0
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 12:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jKRAitOiQPmbS5rGDLLUsUfTY+3zbVCInzKKQFPomOQ=;
        b=FF4fNXhpxmUqtDelix2KoSryIBaNqGl+XLfP5SPCekXuBCH9BkdWoDW8nMupEshT62
         Ioob3GjJnWXZv1ySlu0Pz9TgviwQ7hMfZKXNfeg3P4MrAOBwL/Q/clkCzckyBi8iItFR
         sDXf00DQ/kvqnu34xVhg/r6AJkmV70cQk+kPXieWd/8Ssq++E54TJq82Oo5UaJqm+NYC
         2liFtD6f9nLxL1x0Bl9ihlQ++UmOhe/cMpoymnNeshPWeuHJ6RnubhF8/ewy3PSTPqUZ
         qE2AD93U4pPKkPcVbBgMC+IEFwG4OhGVXEU5MnthQ7fjPjqiVPEisHo0zjINbi3s3UaX
         f7eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jKRAitOiQPmbS5rGDLLUsUfTY+3zbVCInzKKQFPomOQ=;
        b=7Gk5dQdc247hKi7QanXwfj2Ps3o+lQ/jCLYLhx2YHshQ2+bx4xBebsnxVWU66pkVb5
         PG85Y5S8dF5WX3eRu636TXn9Ly5/Qsoe3frQACEZLFweVdT+5VMtPc9mCgzb6cLg0ueA
         Vd7J0YaaE/OvfZiWuRIgfnfdjm6ZFeGiisUa+SznyR99WRdyvmuI0V+L32rpxWUOb9pN
         fTLlLlk0eiehnZSccDDEXFrEp0w1+u7QE72Y94iQ+o2w0mj0+pSx7IBpiLy8p2A1OF0J
         MJiYuAC3cXw8FUxlgTcIYELgOZ03Y9OJ+F3/YROsSUrQlCkiTIw6odny4DiviWuinOSf
         h25Q==
X-Gm-Message-State: AFqh2krj9CZzfytIARW6NISk32QoRQwQsKR358bdPfAzDDC9cbivsgf6
        s2nEO8CUyBxG7SS2yMaxF2RepA==
X-Google-Smtp-Source: AMrXdXvEbVDnE8TMf736ZzmYy1jZgkqSSPdF1yfGj5D9moZsDvf8/UHNAFw4GbQucPxSv3nraZPRRg==
X-Received: by 2002:a17:90b:1206:b0:229:188a:c0e7 with SMTP id gl6-20020a17090b120600b00229188ac0e7mr8203143pjb.49.1674073763324;
        Wed, 18 Jan 2023 12:29:23 -0800 (PST)
Received: from [127.0.1.1] (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090a3b4d00b002132f3e71c6sm1724948pjf.52.2023.01.18.12.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 12:29:22 -0800 (PST)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Subject: [PATCH RFC 0/3] vsock: add support for sockmap
Date:   Wed, 18 Jan 2023 12:27:39 -0800
Message-Id: <20230118-support-vsock-sockmap-connectible-v1-0-d47e6294827b@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADtWyGMC/x2OywrCMBBFf6XM2oFOXPjYCn6AW3GRx2iD7SQkM
 Qil/27i5sLhwuGskDl5znAeVkhcffZBGtBuADtpeTF61xjUqPYj0RHzJ8aQCtYc7Bv7LDqiDSJs
 izczo2JSp4NTRKSheYzOjCZpsVM3Oa48h7iwlP7GxE///Rfc4Xa9wGPbfgucVMKWAAAA
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
X-Mailer: b4 0.11.2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for sockmap to vsock.

We're testing usage of vsock as a way to redirect guest-local UDS requests to
the host and this patch series greatly improves the performance of such a
setup.

Compared to copying packets via userspace, this improves throughput by 221% in
basic testing.

Tested as follows.

Setup: guest unix dgram sender -> guest vsock redirector -> host vsock server
Threads: 1
Payload: 64k
No sockmap:
- 76.3 MB/s
- The guest vsock redirector was
  "socat VSOCK-CONNECT:2:1234 UNIX-RECV:/path/to/sock"
Using sockmap (this patch):
- 168.8 MB/s (+221%)
- The guest redirector was a simple sockmap echo server,
  redirecting unix ingress to vsock 2:1234 egress.
- Same sender and server programs

Only the virtio transport has been tested. The loopback transport was used in
writing bpf/selftests, but not thoroughly tested otherwise.

This series requires the skb patch.

To: Stefan Hajnoczi <stefanha@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Andrii Nakryiko <andrii@kernel.org>
To: Mykola Lysenko <mykolal@fb.com>
To: Alexei Starovoitov <ast@kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
To: Martin KaFai Lau <martin.lau@linux.dev>
To: Song Liu <song@kernel.org>
To: Yonghong Song <yhs@fb.com>
To: John Fastabend <john.fastabend@gmail.com>
To: KP Singh <kpsingh@kernel.org>
To: Stanislav Fomichev <sdf@google.com>
To: Hao Luo <haoluo@google.com>
To: Jiri Olsa <jolsa@kernel.org>
To: Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>

---
Bobby Eshleman (3):
      vsock: support sockmap
      selftests/bpf: add vsock to vmtest.sh
      selftests/bpf: Add a test case for vsock sockmap

 drivers/vhost/vsock.c                              |   1 +
 include/linux/virtio_vsock.h                       |   1 +
 include/net/af_vsock.h                             |  17 ++
 net/vmw_vsock/Makefile                             |   1 +
 net/vmw_vsock/af_vsock.c                           |  59 ++++++-
 net/vmw_vsock/virtio_transport.c                   |   2 +
 net/vmw_vsock/virtio_transport_common.c            |  22 +++
 net/vmw_vsock/vsock_bpf.c                          | 180 +++++++++++++++++++++
 net/vmw_vsock/vsock_loopback.c                     |   2 +
 tools/testing/selftests/bpf/config.x86_64          |   4 +
 .../selftests/bpf/prog_tests/sockmap_listen.c      | 163 +++++++++++++++++++
 tools/testing/selftests/bpf/vmtest.sh              |   1 +
 12 files changed, 447 insertions(+), 6 deletions(-)
---
base-commit: f12f4326c6a75a74e908714be6d2f0e2f0fd0d76
change-id: 20230118-support-vsock-sockmap-connectible-2e1297d2111a

Best regards,
-- 
Bobby Eshleman <bobby.eshleman@bytedance.com>
