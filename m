Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C370024C8D6
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgHTX5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbgHTX4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:56:22 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3ACCC06134B
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:50:15 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mw10so25219pjb.2
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C6OVV+OsfkyjcEnicyUeRg4jUR/0tFRO5N/jys6O9Y4=;
        b=BeXwhlt158m8XVkKRNbpV2ZFcop1pdcv54ihgPF20PI/tMfn30XxASqsjxK9KyfiNZ
         0rIBqHISve0fuSM0cJY3Egq4Ddk3P7vOAdfo/rjh51F7ghT0/luCvj4lUc6SSSX8rDsV
         E2cY9wXPzvhJD8odR1WuBnhZWvUWrivZH8J4Vjp4p44WFNr4UivNN06NyRILRwWV/s38
         V+R8lvCdZlkfb+1cUOc+cgnUBijgeRxy74Kq4pHleEvp9xYRF6MzaSDA6rhC0W80jYIC
         qc3OF8KsX8g99llEXe7MDnRWFCj3ID5oOjEzM1mzl2tLliD0oZiynGRWZaSPrZnJGje1
         1zPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C6OVV+OsfkyjcEnicyUeRg4jUR/0tFRO5N/jys6O9Y4=;
        b=FclBibqojyyULHNsdy5KV9BTwUcyjnTs4dQLeAHG8PT5QqKec3wnMrdqQRfyz/grJM
         cm/ol+6PjRtTDKrDvhHH2h58qbtcfqRyIenJgBg6lkWy4vi2YvyhhkTqhCThsbwgxUiQ
         y1l3WdtAZcO9okpuqauYcxa67tXkXm3y0uM0vKmvWBv5FXXHd65r9fXXqZU9w5+L460O
         UGzbvRUVHEjU2nIQD2rFIK7Dh4CVp3/MPn2IuIfgClr5HJX5GaeT9TmAw34GvtIEbaAR
         FZhhYb1ZxEMQoCOz8l9UwAzi1rM4wzvd5J93fKfrF3bhAa8Mtkkzmgt33CylU7XdDyvR
         3VXw==
X-Gm-Message-State: AOAM532PPjcBVZm/iLCpykexJqYO48EY7hBwk9NZpH0vv0jh5y8UJSrw
        4diZPJ8wfi26Fcadfuqoie0dGJsWuHU=
X-Google-Smtp-Source: ABdhPJxNUyGW+wLy2XHN9x3s+x/vQrK0Fio3MAoiFlD35Wgbww4QH+RGjfvB5m1OimF47XRmnbQdCw==
X-Received: by 2002:a17:902:a508:: with SMTP id s8mr204158plq.152.1597967415315;
        Thu, 20 Aug 2020 16:50:15 -0700 (PDT)
Received: from lukehsiao.c.googlers.com.com (40.156.233.35.bc.googleusercontent.com. [35.233.156.40])
        by smtp.gmail.com with ESMTPSA id x9sm194815pff.145.2020.08.20.16.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 16:50:14 -0700 (PDT)
From:   Luke Hsiao <luke.w.hsiao@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Luke Hsiao <lukehsiao@google.com>
Subject: [PATCH net-next 0/2] Support reading msg errq from io_uring
Date:   Thu, 20 Aug 2020 16:49:52 -0700
Message-Id: <20200820234954.1784522-1-luke.w.hsiao@gmail.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luke Hsiao <lukehsiao@google.com>

This patch series adds support for reading MSG_ERRQUEUE using the
io_uring interface. Support for this operation allows io_uring to serve
as an alternative to epoll + recvmsg for reading notification
completions for TCP tx zerocopy. 

The first patch allows ancillary data to be read using recvmsg from
io_uring, while the second patch provides an optimization for reading
these notification completions.

Luke Hsiao (2):
  io_uring: allow tcp ancillary data for __sys_recvmsg_sock()
  io_uring: ignore POLLIN for recvmsg on MSG_ERRQUEUE

 fs/io_uring.c       | 11 +++++++++--
 include/linux/net.h |  3 +++
 net/ipv4/af_inet.c  |  1 +
 net/ipv6/af_inet6.c |  1 +
 net/socket.c        |  8 +++++---
 5 files changed, 19 insertions(+), 5 deletions(-)

-- 
2.28.0.297.g1956fa8f8d-goog

