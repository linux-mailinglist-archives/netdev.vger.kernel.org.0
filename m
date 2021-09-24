Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9D9417D75
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 00:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344667AbhIXWHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 18:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344683AbhIXWG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 18:06:59 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7190C061571;
        Fri, 24 Sep 2021 15:05:25 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id q81so26088732qke.5;
        Fri, 24 Sep 2021 15:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yeYH3sR7fD8D9TwHWKHA1gsHm6rYW9zdaGYQTSjApHM=;
        b=l7R0tmCpHLE0vtSUTpz6u+r+Y5/6DuPBTPUmolfv4jjVkQmA3Vmiy1UUr2QplU0jvC
         VrEwmkXVSI/GGQOCbSaX0n+GZ7g0m1GE71Vn6dTBFW0C8Au+1R5hWWegQ+bb5TjPNbJl
         po3OYd0hqHqKvLaSptKuEZNmngPYYCC9SBSj//G/inPwjRchS9s17LINxc0kbfTPI4Cm
         qauYj+0uwDlxuUGoE3Yd/E5/2hvtx8cuXFAWvBUCnV5BULEhxY0+bU1qYMK4d020wK4+
         L64FEIcLBeVAAsAt8miUQJAzJzX4p5w/CqXz3LS6Hqpubx3TI1i3Oa4r6LiRIHJox7Rd
         ZvFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yeYH3sR7fD8D9TwHWKHA1gsHm6rYW9zdaGYQTSjApHM=;
        b=S6rZFqTwhsNp8n1yiStaHmERJcJV5HrBf1R5Xaat39jeEra4FgFye2Gd8vwZHUSe6s
         plKqfLDdRfs6U9F2zPLZcHDmuNITTFBM+9ybnCUtLJew4s/ZR4p+3fhWMUdnn8aqIx9E
         bMQHs+8R1fINN3+foHA/kDckCy1ERK6va3St5jH5OZ8mbRM5ozcZ/jZgS1bdyMKoLBS3
         3tY9r0Svzssb85ZHOI99g2LAFw6yO6v+6M/5eO3yAUo2q2yecddXdELYo4fwgRFmK74Q
         +5eyNp2XK65kDwOXEwHTOIkX7KmRBzpkPXbAR9nuwa9HMzWLmtlqfKk/HbDIPatdSpeR
         9gQw==
X-Gm-Message-State: AOAM5324vFk+OePorBvRuZDjs2w8b59shPWv1FOFNxrqld440arQVyVU
        X47MaaUNvPJuVMDE84Cz96IaWi+/6WE=
X-Google-Smtp-Source: ABdhPJwtgNJVYPF0wD8hzCRr8dB3JbvRxCXgdpR7zpXyr/5hDSGPQTWdcHnuyLPP7Ityh6ZNSzojFw==
X-Received: by 2002:ae9:ed48:: with SMTP id c69mr12963917qkg.424.1632521124788;
        Fri, 24 Sep 2021 15:05:24 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c4dc:647c:f35b:bfc4])
        by smtp.gmail.com with ESMTPSA id h2sm7895683qkf.106.2021.09.24.15.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 15:05:24 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf 0/3] sock_map: fix ->poll() and update selftests
Date:   Fri, 24 Sep 2021 15:05:04 -0700
Message-Id: <20210924220507.24543-1-xiyou.wangcong@gmail.com>
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

Cong Wang (2):
  skmsg: introduce sk_psock_get_checked()
  net: poll psock queues too for sockmap sockets

Yucong Sun (1):
  selftests/bpf: use recv_timeout() instead of retries

 include/linux/skmsg.h                         | 26 +++++++
 net/core/skmsg.c                              | 15 ++++
 net/core/sock_map.c                           | 22 +-----
 net/ipv4/tcp.c                                |  2 +
 net/ipv4/udp.c                                |  2 +
 net/unix/af_unix.c                            |  5 ++
 .../selftests/bpf/prog_tests/sockmap_listen.c | 75 +++++--------------
 7 files changed, 71 insertions(+), 76 deletions(-)

-- 
2.30.2

