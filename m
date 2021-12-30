Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9485481BDD
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 13:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239118AbhL3MBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 07:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235352AbhL3MBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 07:01:11 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3466BC061574;
        Thu, 30 Dec 2021 04:01:11 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so27782998pjj.2;
        Thu, 30 Dec 2021 04:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sb4g3VsIegSPMmpYpqxjEW0uci7clyl11pHi9PsfY+E=;
        b=Rvx/UFYTBER+iaj7RZaEpECqX8Mv2q+VOlYhJAh24HS2An/6ooKrjvfdI03B8E2qon
         jDZgE9jieZrcvRs/m0F/Mlzo7BfMrQliosuTZz7e7EQddGC4QqkRI/MjuCuXIlLdISQu
         TLG6TUz85bN6g3Lc1vur1CIgMuOxkED8gjdDa0jUb81gZgjIv532v/zMkDdn+WYcy15b
         p1QW7qCxAIp8cBl8zGqh2DmkZSc5Atip3P/95Ka6ABRcpA3I5RrJT2UKGSraiQ6SOTdy
         ZCoLCizQJKxsa25gXA/R51qjJoyHyaCnuZwq2XQEleV3PnOLNUHZuhBDwpoozpt6S4p7
         xutA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sb4g3VsIegSPMmpYpqxjEW0uci7clyl11pHi9PsfY+E=;
        b=eVothtqyvnyRzNULwYrgY182Px57Ntg5Vc6LuSNLPRcdlQD2Yvip2UALHyEIkv4FRf
         FUyt6+jdznSz3058//kQ4wUXCapKzIPM/NZBZdmKlrWd2vpjIQoPyyWYxQz2LArUI7Q2
         6gygMvz1PFVNUODk4m3TWZl0bSAZxX6XHivIThZrlyDVoWxsMj/9Uk7FFUzdpmBAFB8M
         EAnUNedSuNKnq8mFGrwSLB34VZQLoU5iu9STiZo2XrYDPpaXqmvpKQsMsv63jmZkbn1N
         vHuTOoetD1Ca4fCs9PrMTJnR+4mj6CuGwNNOB318FO1yY2tzDIdgtpcUHaDMf+g3cMPl
         qIpw==
X-Gm-Message-State: AOAM531k4gCQVSSrV70VpnicCZVo3dh5yuZi48ghhlio0UHAfWj8u4N7
        FSoOSgNwLLJn+ZALFkoU1rI=
X-Google-Smtp-Source: ABdhPJwbl+HzdvlUGZW5Sb7kgep8oCfMyyHMb31gvcCY3Hov6qNKHpEGPnpURGzNcaQypGTUp58nzQ==
X-Received: by 2002:a17:90b:4ac3:: with SMTP id mh3mr19574401pjb.220.1640865670532;
        Thu, 30 Dec 2021 04:01:10 -0800 (PST)
Received: from integral2.. ([180.254.126.2])
        by smtp.gmail.com with ESMTPSA id nn16sm30121257pjb.54.2021.12.30.04.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 04:01:10 -0800 (PST)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        Nugra <richiisei@gmail.com>
Subject: [RFC PATCH v2 0/3] io_uring: Add sendto(2) and recvfrom(2) support
Date:   Thu, 30 Dec 2021 19:00:41 +0700
Message-Id: <20211230114846.137954-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211230013250.103267-3-ammar.faizi@intel.com>
References: 
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
2.32.0

