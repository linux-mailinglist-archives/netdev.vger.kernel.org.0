Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306B63F744D
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 13:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239945AbhHYL1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 07:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236784AbhHYL1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 07:27:12 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C88C061757;
        Wed, 25 Aug 2021 04:26:26 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id c129-20020a1c35870000b02902e6b6135279so4378075wma.0;
        Wed, 25 Aug 2021 04:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IP1bVLY+A67NAQN0X5sEJAXxtYP4QJq3m3qkSSmNl3c=;
        b=HQ5tV7Kc225JC6kECs1YeP9OyyGdqZO0Bnt0MWSXhpqEtojn3T5+LLKo8a+e/RpKPT
         wfgjWTg8r81bOjlq3ATnttQ0xZnMYtTy/OqA7wckVD5dyQXUYGC/Qt1i7jnJJf5NkXrB
         xbFb/XrlOIqhmM4+R2XZmnPktF0kmWOl0hSQzsNZr+ZnG/EZo29xRACiPVFwHFlnz3JS
         NhgF7Y1RyGL2hX2Mq/A66l1pdUi8HqG4eYJnDiDPAFAd5oP3GR+qNhtppR4ih7b+RW6J
         xsedcx4MuEtKrhet1zw7pnE4J3PI/GBRpfu03eyZjkkdT/U9X1IoODCZxBYRa/bgvrIL
         arew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IP1bVLY+A67NAQN0X5sEJAXxtYP4QJq3m3qkSSmNl3c=;
        b=sdjyqZ+VYZGlVNRhkST8/hJpxqjMdAFFj//O1LgB14DMv4rBpGssWAypnRsf/Yj52U
         5iqJ5GYmbwxrVE8dgVzDNSvVLA5v1O75Hwu0CdZGt73JVLoIx1zMbDzWGA0YGhCnPvKN
         pRZ1INIrmkCoFurHYq7zqTAfdsfI4ACKxiVuXItELG2UXjSPG58jFePdcslMD7D1EiEr
         dBTvGVzuA2ZHrrAc+6gqgchdtroW+m2x0KS1EChOSsLXiSKERayC4yHLgiSwWpl3meWm
         pimR2xTmWddjFLSFIKwTb6Cdu4OOuxVbWQlXpCLyX4sHOYAfn0XKFz/ogcjiw6qapGJI
         aFNw==
X-Gm-Message-State: AOAM532PfLV5LGjS6dMWWoA3tWfqVz8GM4WrA38QO0N2nna1ylPJtXOk
        KVNwvHczdHRAQD8KEh4o16s=
X-Google-Smtp-Source: ABdhPJwXTT2b0tzrvZOBHiKSfB74rHDOFa+UvDn5t9OC9dQxfndl2I3iBFWWBXh+4FmDLg+EGBl3/Q==
X-Received: by 2002:a7b:c0c7:: with SMTP id s7mr8452702wmh.66.1629890784854;
        Wed, 25 Aug 2021 04:26:24 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id b12sm25113730wrx.72.2021.08.25.04.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 04:26:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v4 0/4] open/accept directly into io_uring fixed file table 
Date:   Wed, 25 Aug 2021 12:25:43 +0100
Message-Id: <cover.1629888991.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an optional feature to open/accept directly into io_uring's fixed
file table bypassing the normal file table. Same behaviour if as the
snippet below, but in one operation:

sqe = io_uring_[open|accept]_prep();
io_uring_submit(sqe);
// ... once we get a CQE back
io_uring_register_files_update(uring_idx, (fd = cqe->res));
close((fd = cqe->res));

The idea is old, and was brough up and implemented a year ago by
Josh Triplett, though haven't sought the light.

The behaviour is controlled by setting sqe->file_index, where 0 implies
the old behaviour using normal file tables. If non-zero value is
specified, then it will behave as described and place the file into a
fixed file slot sqe->file_index - 1. A file table should be already
created, the slot should be valid and empty, otherwise the operation
will fail.

note: IOSQE_FIXED_FILE can't be used as a mode switch, because accept
takes a file, and it already uses the flag with a different meaning.

v2, since RFC:
 - added attribution
 - updated descriptions
 - rebased

v3:
 - EBADF if slot is already used (Josh Triplett)
 - alias index with splice_fd_in (Josh Triplett)
 - fix a bound check bug

v4:
 - separate u32 fields to internally store indexes (Jens, Josh)

Pavel Begunkov (4):
  net: add accept helper not installing fd
  io_uring: openat directly into fixed fd table
  io_uring: hand code io_accept() fd installing
  io_uring: accept directly into fixed file table

 fs/io_uring.c                 | 115 +++++++++++++++++++++++++++++-----
 include/linux/socket.h        |   3 +
 include/uapi/linux/io_uring.h |   5 +-
 net/socket.c                  |  71 +++++++++++----------
 4 files changed, 143 insertions(+), 51 deletions(-)

-- 
2.32.0

