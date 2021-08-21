Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64ED23F3B3E
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 17:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbhHUPyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 11:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbhHUPyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 11:54:00 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD70C061575;
        Sat, 21 Aug 2021 08:53:20 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v10so7511362wrd.4;
        Sat, 21 Aug 2021 08:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3no8bjlTC7qG2fVZz3i3VTGfYtIjxhSSicUhax0MRz4=;
        b=qbIgQsGJ4NKkBTRex/r3TPba7U5y7NqF18rCVNREbYIa2mEKAoUP/isyAVxDQpDbVa
         etlzoccomTsu/ipCqEU6rDxNfz09bEjpqmK1esD0sgSPWJ54KAlvrxV5tI7P4ts/lXv7
         fWNGMFMQn+JN9PhpPHfn3F9rbPyjLwIFYwR5YssPdPmDqlGr6Pj0HzJ0l3WZTuQtUj9e
         Ab//0/uTBy1H53kg13PjCEB+joyueLTgxmokA0Eu+i3Wv33JtaTUH/sdVOeu0YurKLY6
         5IUahl2BZeu182mNeG68741Ahc+7sgcushXRQDxhASDLwFqc43UTJ2QOd306SnrQOVEu
         FVqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3no8bjlTC7qG2fVZz3i3VTGfYtIjxhSSicUhax0MRz4=;
        b=mWh/P5rNOA4RhQFTJqt1sOW9sfSjqLaYS+tRilVKZdTMTQZ8Uq0NqyF21tDuqPiseN
         GBrkSa4+hyYO6+yhl3bawadfdU4vY4WAUTRAEzy1LJ4CB5RALi749y/ZsY2Yej6/nb2n
         +1WUhftEFWTQo/5GkjBb8hMDDxRoqVlcnxWjc8NAB5/sz4EbYx4I+0Kf/e64bJO97o0W
         wmRPfiKDkEy6j4txWJQjbJGYjZkdBTIvXvfp6OxqkoBlcf+dIS2whsP1dyBDSySkoNqt
         C0tUXRGhvBhgODReMs+OOEmpLJ6ER+alKcRjVAgGdM/ijwmZ1mbZfJ7PZZnI8YGi+8je
         AMRQ==
X-Gm-Message-State: AOAM533kpW3JR27D7vtwtDJ1WgJSWRBlv26kY7V7TL5HZlU54JmiRPPu
        /2XtyLT+2k5TzJIuN3PJQ28=
X-Google-Smtp-Source: ABdhPJwtv94+OnpvcNSQQUev8ESWsIq+ajwCOY8LzcCeq0TWgSjaPuIsSbBFLYzD4A8cbPcPhhtNAQ==
X-Received: by 2002:a05:6000:1091:: with SMTP id y17mr4418460wrw.202.1629561199016;
        Sat, 21 Aug 2021 08:53:19 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id e3sm9479554wro.15.2021.08.21.08.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 08:53:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v3 0/4] open/accept directly into io_uring fixed file table 
Date:   Sat, 21 Aug 2021 16:52:36 +0100
Message-Id: <cover.1629559905.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an optional feature to open/accept directly into io_uring's fixed
file table bypassing the normal file table. Same behaviour if as the
snippet below, but in one operation:

sqe = prep_[open,accept](...);
cqe = submit_and_wait(sqe);
io_uring_register_files_update(uring_idx, (fd = cqe->res));
close((fd = cqe->res));

The idea in pretty old, and was brough up and implemented a year ago
by Josh Triplett, though haven't sought the light for some reasons.

The behaviour is controlled by setting sqe->file_index, where 0 implies
the old behaviour. If non-zero value is specified, then it will behave
as described and place the file into a fixed file slot
sqe->file_index - 1. A file table should be already created, the slot
should be valid and empty, otherwise the operation will fail.

we can't use IOSQE_FIXED_FILE to switch between modes, because accept
takes a file, and it already uses the flag with a different meaning.

since RFC:
 - added attribution
 - updated descriptions
 - rebased

since v1:
 - EBADF if slot is already used (Josh Triplett)
 - alias index with splice_fd_in (Josh Triplett)
 - fix a bound check bug

Pavel Begunkov (4):
  net: add accept helper not installing fd
  io_uring: openat directly into fixed fd table
  io_uring: hand code io_accept() fd installing
  io_uring: accept directly into fixed file table

 fs/io_uring.c                 | 129 +++++++++++++++++++++++++++++-----
 include/linux/socket.h        |   3 +
 include/uapi/linux/io_uring.h |   5 +-
 net/socket.c                  |  71 ++++++++++---------
 4 files changed, 157 insertions(+), 51 deletions(-)

-- 
2.32.0

