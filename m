Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CF841A424
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 02:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238313AbhI1AYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 20:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238277AbhI1AYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 20:24:09 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D0EC061575;
        Mon, 27 Sep 2021 17:22:29 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id a13so18405195qtw.10;
        Mon, 27 Sep 2021 17:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OmwbKwAa4NtUUvxlecm7KLJeFKeLc1dSItdzmyjeSkk=;
        b=hg1DpeNe7IS0Qe/3aezC2fS9R7I/KN5hZuhtsxCGRICkOpiYcHMZVSJvPYoUSmOHKs
         C+0LJeVgZyTGb/CqQRjVma/Fd2N7weQ4bVdKUDNIYxN/KdHNlZm4BPK1bV0gATqOikoj
         eDDQlcbEnrjiCB62tX9H6zWPLdENIZpN6Qi6+gXGLNTrsNwUMmyr+Vd5BhNbRlKAWvoP
         GJNhKphEOCvfgptR/q+91vhuZMeudPH/yjRvcugZlqBWxGmyL3SPXIcJ1r1tEhI6vgTA
         LjNH0kEYEO/4E4+MVEOUCpQXNfzPYzFEAUaztbtT59tcNRmlXgFSZ4TCik17r1j7iAh6
         x2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OmwbKwAa4NtUUvxlecm7KLJeFKeLc1dSItdzmyjeSkk=;
        b=QvH9hINlL6kR2+6L/QMLWrzh/kxXEpXdeuBxzf8IRmWgCWi39xC0T/RgzX8Elmzu0t
         T8kro6STTMpQeRrv5s/fpq577OG7oS96PimpVLUzeoRQgUMjLWlPBjA18Q2re2BOOeR9
         OBkQ+re3S3aZa1jfNzyosTf+QoFpehwGnWU10+UBguIveVcZ0FBVNNMv4D1VZuQdB0e/
         qTSETyrIOwUOyfRNWeoLU/L3GZ1zAoA1+Am+9/UOhQoJ1TPqvsDbJ2jIV/kBEtyJ87mY
         XzolynRwujuamdlU0SH5q9Cox6h/nV6CkeYZ0IJmccFRVwRB7DxpOUx07apIyNwHzLGy
         Hgkg==
X-Gm-Message-State: AOAM531v8EPGD733SRVxHnryyfW74uFcjEefpWyy8dWq0357Y6n3R3QH
        N5yEBa6a6Qt8IJiZCBieibUV+3D6rmE=
X-Google-Smtp-Source: ABdhPJzronDtFrmS72gc2ZeFyaeLrZmDzMQtC3wncTTQiFObPcOte/gatbIVoXnZepg+QZx2F1OLzg==
X-Received: by 2002:ac8:51ce:: with SMTP id d14mr2815571qtn.16.1632788548316;
        Mon, 27 Sep 2021 17:22:28 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1ce2:35c5:917e:20d7])
        by smtp.gmail.com with ESMTPSA id 31sm5672308qtb.85.2021.09.27.17.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 17:22:28 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf v2 0/4] sock_map: fix ->poll() and update selftests
Date:   Mon, 27 Sep 2021 17:22:08 -0700
Message-Id: <20210928002212.14498-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patchset fixes ->poll() on sockmap sockets and update
selftests accordingly with select(). Please check each patch
for more details.
---
v2: rename and reuse ->stream_memory_read()
    fix a compile error in sk_psock_get_checked()

Cong Wang (3):
  skmsg: introduce sk_psock_get_checked()
  net: rename ->stream_memory_read to ->sock_is_readable
  net: implement ->sock_is_readable for UDP and AF_UNIX

Yucong Sun (1):
  selftests/bpf: use recv_timeout() instead of retries

 include/linux/skmsg.h                         | 21 ++++++
 include/net/sock.h                            |  8 +-
 include/net/tls.h                             |  2 +-
 net/core/skmsg.c                              | 14 ++++
 net/core/sock_map.c                           | 22 +-----
 net/ipv4/tcp.c                                |  5 +-
 net/ipv4/tcp_bpf.c                            |  4 +-
 net/ipv4/udp.c                                |  2 +
 net/ipv4/udp_bpf.c                            |  1 +
 net/tls/tls_main.c                            |  4 +-
 net/tls/tls_sw.c                              |  2 +-
 net/unix/af_unix.c                            |  4 +
 net/unix/unix_bpf.c                           |  2 +
 .../selftests/bpf/prog_tests/sockmap_listen.c | 75 +++++--------------
 14 files changed, 79 insertions(+), 87 deletions(-)

-- 
2.30.2

