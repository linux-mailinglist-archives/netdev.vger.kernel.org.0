Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68985481ED2
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 18:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236713AbhL3Rwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 12:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbhL3Rwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 12:52:40 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C135C061574;
        Thu, 30 Dec 2021 09:52:40 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id rj2-20020a17090b3e8200b001b1944bad25so23748641pjb.5;
        Thu, 30 Dec 2021 09:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dq2E6g/viDgXFbLgjfa6p0MLq/dB8qnH50bjxF94Y4s=;
        b=HnSF0Pc5UoeSa/FhqjDvEnsa2QElgA8qZNUsR7mq09O0MsDDGG8tIdg16zvRw1NY4R
         5ojg9P7qSQrdb3apd0dJhIHALlHhZrNnkDg5Jy5uHDb5ipjH3MzKmpxutRLFeGTuBnyn
         /jN7iszgVhb0uy/7cpFCpWq3J+BpkyYg+ivnYNb5xeI9LrhBvT5pQfnTsWew0EdwZeVV
         RVcE/6XYeffOIDaqqhfPc8P4KNQQrRK2Nd9nhLkTyQ/0g5CVLYLz2H1HIJZgVJt3pxqj
         Fc1ZwDxqsRW0DURgjhbGWYuzvPYfh/O77qLCYPFcT7B+bNmiYQUGSTt+FbkC7B+HkMRC
         cCHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dq2E6g/viDgXFbLgjfa6p0MLq/dB8qnH50bjxF94Y4s=;
        b=it8BlB+nKdN9ZWzeKYXDaD2m8pr/Sbrdp3Xdu5XoKD8LeiLOb1bXVZjaw2c+wCbZzj
         3Osz4i9H37qBCUFfTEe3SCL/aIUHZYXR7mMYIY/XCwQTr0FhKAMv4e62PCW2fLxF+iEl
         OuSNtKjqmvz8isISCvZTQiPlgsBcu/1bqcG3/W/4KO2/JehR1hF56fjg9XNCXk2/Zl/D
         bdhV2Tyb8Grljm/v75qb0+Pd7hCaQDnUasc4W+vLRcdq2Gu+hNeFtwObpNh8OPhhiQYv
         SjuuKQK3wZDzNfNoEntzziXbjT/TWWIhnCPZpXxAj3gdbWfgbN28rM6zdOZqwGuPr4xP
         ZVmg==
X-Gm-Message-State: AOAM533waeyKwwmHizE+ViqXJvtUQESKVI9t8TDu4UqPkaV/bHHzfES/
        MSWzNcF8J6OEPuF38DCzy2k=
X-Google-Smtp-Source: ABdhPJxvPXRN1fUkZigkt67KioWHWu7AhlGxl/UBrJp9uKf+WeC3crS01et3xu1/K6ogXley8W+tRA==
X-Received: by 2002:a17:90a:a00e:: with SMTP id q14mr39001863pjp.88.1640886759870;
        Thu, 30 Dec 2021 09:52:39 -0800 (PST)
Received: from integral2.. ([180.254.126.2])
        by smtp.gmail.com with ESMTPSA id 185sm9244188pfe.26.2021.12.30.09.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 09:52:39 -0800 (PST)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        Nugra <richiisei@gmail.com>
Subject: [RFC PATCH v3 0/3] io_uring: Add sendto(2) and recvfrom(2) support
Date:   Fri, 31 Dec 2021 00:52:29 +0700
Message-Id: <20211230173126.174350-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211230115057.139187-3-ammar.faizi@intel.com>
References: <20211230115057.139187-3-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This RFC patchset adds sendto(2) and recvfrom(2) support for io_uring.
It also addresses an issue in the liburing GitHub repository [1].


## Motivations:
1) By using `sendto()` and `recvfrom()` we can make the submission
   simpler compared to always using `sendmsg()` and `recvmsg()` from
   the userspace.

2) There is a historical patch that tried to add the same
   functionality, but did not end up being applied. [2]

On Tue, 7 Jul 2020 12:29:18 -0600, Jens Axboe <axboe@kernel.dk> wrote:
> In a private conversation with the author, a good point was brought
> up that the sendto/recvfrom do not require an allocation of an async
> context, if we need to defer or go async with the request. I think
> that's a major win, to be honest. There are other benefits as well
> (like shorter path), but to me, the async less part is nice and will
> reduce overhead


## Changes summary
There are 3 patches in this series.

PATCH 1/3 renames io_recv to io_recvfrom and io_send to io_sendto.
Note that

    send(sockfd, buf, len, flags);

  is equivalent to

    sendto(sockfd, buf, len, flags, NULL, 0);

and
    recv(sockfd, buf, len, flags);

  is equivalent to

    recvfrom(sockfd, buf, len, flags, NULL, NULL);

So it is saner to have `send` and `recv` directed to `sendto` and
`recvfrom` instead of the opposite with respect to the name.


PATCH 2/3 makes `move_addr_to_user()` be a non static function. This
function lives in net/socket.c, we need to call this from io_uring
to add `recvfrom()` support for liburing. Added net files maintainers
to the CC list.

PATCH 3/3 adds `sendto(2)` and `recvfrom(2)` support for io_uring.
Added two new opcodes: IORING_OP_SENDTO and IORING_OP_RECVFROM.


## How to test

This patchset is based on "for-next" branch commit:

  bb3294e22482db4b7ec7cfbb2d0f5b53c1adcf86 ("Merge branch 'for-5.17/drivers' into for-next")

It is also available in the Git repository at:

  https://github.com/ammarfaizi2/linux-block ammarfaizi2/linux-block/io_uring-recvfrom-sendto


I also added the liburing support and test. The liburing support is
based on "xattr-getdents64" branch commit:

  55a9bf979f27f3a5c9f456f26dcfe16c4791667b ("src/include/liburing.h: style cleanups")

It is available in the Git repository at:

  https://github.com/ammarfaizi2/liburing sendto-recvfrom

---
v3:
  - Fix build error when CONFIG_NET is undefined for PATCH 1/3. I
    tried to fix it in PATCH 3/3, but it should be fixed in PATCH 1/3,
    otherwise it breaks the build in PATCH 1/3.

  - Added `io_uring_prep_{sendto,recvfrom}` docs to the liburing.

v2:
  - Rebased the work, now this patchset is based on commit
    bb3294e22482db4b7ec ("Merge branch 'for-5.17/drivers' into
    for-next").

  - In `io_recvfrom()`, mark the error check of `move_addr_to_user()`
    call as unlikely.

  - Fix build error when CONFIG_NET is undefined.

  - Update liburing test (the branch is still the same, just force
    pushed).

  - Added Nugra to CC list (tester).

---
RFC v2: https://lore.kernel.org/io-uring/20211230114846.137954-1-ammar.faizi@intel.com/
RFC v1: https://lore.kernel.org/io-uring/20211230013154.102910-1-ammar.faizi@intel.com/
Link: https://github.com/axboe/liburing/issues/397 [1]
Link: https://lore.kernel.org/io-uring/a2399c89-2c45-375c-7395-b5caf556ec3d@kernel.dk/ [2]
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: Nugra <richiisei@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---

Ammar Faizi (3):
  io_uring: Rename `io_{send,recv}` to `io_{sendto,recvfrom}`
  net: Make `move_addr_to_user()` be a non static function
  io_uring: Add `sendto(2)` and `recvfrom(2)` support

 fs/io_uring.c                 | 92 +++++++++++++++++++++++++++++++----
 include/linux/socket.h        |  2 +
 include/uapi/linux/io_uring.h |  2 +
 net/socket.c                  |  4 +-
 4 files changed, 88 insertions(+), 12 deletions(-)


base-commit: bb3294e22482db4b7ec7cfbb2d0f5b53c1adcf86
-- 
Ammar Faizi

