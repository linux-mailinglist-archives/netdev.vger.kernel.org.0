Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63D2427251
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 22:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhJHUfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 16:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbhJHUfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 16:35:14 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCACC061570;
        Fri,  8 Oct 2021 13:33:18 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id p4so10733876qki.3;
        Fri, 08 Oct 2021 13:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fw1JeXckjpQUT4pr0a3/4T0uF3FLL3n37JF3TpjaaJY=;
        b=LqDYksDIqUOSFPVRqF/CgGnxr597MT5P9BbdRViTqs2xi376JSMG91MGiRSCwhH5Sd
         KgzRcisZV8wqmbimE0wBY4eAFk9Lb1SgCwFoF3iuD+HPmYLP3b1Jz98n1zSCDC6e0y6p
         qSjOA/sBMI7ysqd6QbNtRGljjIuUruHGaTfej/XmBEQ4ly0cJXFxl9xoNA8nFHD/JGap
         w63XjJXIxzxf9Y6Kxzy5CM/DiRQy800oBtrDEGlZ7QdXKBS40hrKmFlu8qkoARqoMxfJ
         7RpS4m6vd4svwdqwxD36dDI7bx3EkTjmGifi4xhEvbF26DFtvTwbOoMSKw8jeuiiN9tu
         Dq7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fw1JeXckjpQUT4pr0a3/4T0uF3FLL3n37JF3TpjaaJY=;
        b=H3kSw+BOsFYlfw9PaqVjl77zYzdEbjXdozVsrGTds+QrSeXUxF4cqFvoeXlYnIU9Rt
         NXqnUkUxsgoIU8AY6Att69lHG9jeBDSvyx+EgfE5vjAMt9bjRK+j+TLZrL+oNQhhXb/L
         06b+GUtlIJm5czKouCbfmLGud4D1IOU0jXf+9zPHHtecJjAl5s0XGJWJMfayNAkgnKH9
         q+ofunsJH02jGNnggJ33q/FVBcT1G3ou02ezCkC5zq/n+f9fnR65dSjn2U6JDesABzNW
         g2ICguLk6j6G4D9NpAfEbbzwwN5LtqZm0PbC5yf2d72FVhOZN15vlyfcfPl1g9KSeYbq
         Dvnw==
X-Gm-Message-State: AOAM530MdP28GJ+9s1SN9ytIH2WzOqHpbf11GOXRdX49nP7enwNSih9x
        6agSTtZqj4yN2Nqdmc499fgoz5szpv8=
X-Google-Smtp-Source: ABdhPJyb8zEOY9gguCXrHjF79VZ9D1J8a/5Gvu6r+O0HBTCz3bJqFL3wdc4aGILCbMBjQS2DzEbIwQ==
X-Received: by 2002:a37:65d6:: with SMTP id z205mr4846587qkb.522.1633725197579;
        Fri, 08 Oct 2021 13:33:17 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:795f:367d:1f1e:4801])
        by smtp.gmail.com with ESMTPSA id c8sm381945qtb.9.2021.10.08.13.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:33:17 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf v4 0/4] sock_map: fix ->poll() and update selftests
Date:   Fri,  8 Oct 2021 13:33:02 -0700
Message-Id: <20211008203306.37525-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patchset fixes ->poll() for sockets in sockmap and updates
selftests accordingly with select(). Please check each patch
for more details.

Fixes: c50524ec4e3a ("Merge branch 'sockmap: add sockmap support for unix datagram socket'")
Fixes: 89d69c5d0fbc ("Merge branch 'sockmap: introduce BPF_SK_SKB_VERDICT and support UDP'")
Acked-by: John Fastabend <john.fastabend@gmail.com>

---
v4: add a comment in udp_poll()

v3: drop sk_psock_get_checked()
    reuse tcp_bpf_sock_is_readable()

v2: rename and reuse ->stream_memory_read()
    fix a compile error in sk_psock_get_checked()

Cong Wang (3):
  net: rename ->stream_memory_read to ->sock_is_readable
  skmsg: extract and reuse sk_msg_is_readable()
  net: implement ->sock_is_readable() for UDP and AF_UNIX

Yucong Sun (1):
  selftests/bpf: use recv_timeout() instead of retries

 include/linux/skmsg.h                         |  1 +
 include/net/sock.h                            |  8 +-
 include/net/tls.h                             |  2 +-
 net/core/skmsg.c                              | 14 ++++
 net/ipv4/tcp.c                                |  5 +-
 net/ipv4/tcp_bpf.c                            | 15 +---
 net/ipv4/udp.c                                |  3 +
 net/ipv4/udp_bpf.c                            |  1 +
 net/tls/tls_main.c                            |  4 +-
 net/tls/tls_sw.c                              |  2 +-
 net/unix/af_unix.c                            |  4 +
 net/unix/unix_bpf.c                           |  2 +
 .../selftests/bpf/prog_tests/sockmap_listen.c | 75 +++++--------------
 13 files changed, 58 insertions(+), 78 deletions(-)

-- 
2.30.2

