Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8EB3EBA40
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 18:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236326AbhHMQoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 12:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbhHMQoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 12:44:18 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388A9C0617AD;
        Fri, 13 Aug 2021 09:43:51 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x10so7802819wrt.8;
        Fri, 13 Aug 2021 09:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tTtxt0HccECn9JoP7tPP5lmd6vJWaG+/hAvUwgP25po=;
        b=TbSOfuEXfhis1AmXSoz50XxA+hf3EYvt9WVVOwZWaRE8Gf3MMP+GPGIL1yo8fs3Xfj
         2j/E3eMiAd+DXmgLCYE89ISuA00lvBy6GN9v3tKvZoXR7t6gbw9btZeRGsKvqrIjBbWl
         9O1XUY7uFIb5oah61Gunjr6BJ2/CF9s/OWVswEBi29LEZhZlRl4GHeLw3giiT40Th9sF
         GrfoQ6q3DbbKFQy6VjeD3BWjdxwYNxmoHCwSCEuQAYGwnaA3lzxYdUr+oEPqMNAyDR++
         2hojKoRM4xNSxj8VPWXr25kbn2dXmBIXQVXb3xdUEF6Av/4jjZh5eUANe1lw1/540JnY
         fikQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tTtxt0HccECn9JoP7tPP5lmd6vJWaG+/hAvUwgP25po=;
        b=RlDLaHVK4j+cQ0FoVn9D549AR9b/ywA6ff/PG9TGWfN+jZW4fkf4ZoVtvMW0M74uxD
         mhYuV8BywfHi2kFayQYEb4ew0vrzIEQWgaiTEWKGf+jMAPz1iCiTd0tChT+PE69dg1tV
         6pULr1IUA9OtQu8m0u0XqUd9GWQMtHAjsxJQrBhH/jfod74eBTo0K40IO/MEkrOA8YXb
         dOPBrOt6Xr/UPsmjwGgSmuYC3PqxrnucofpUSthn3DJUNG2Oh+gjq3hh++8jvIVcd45A
         R/jQSDca2EYkVs7QH8wZK0kPr/eKbEa51G5pYZ6FLKtyOOw40CAU7xVkOSE+PSuPSvyD
         gQZw==
X-Gm-Message-State: AOAM530seqOP0GhKNQYsVzYYt2gwwIbiUkLRKWgUVaqlASHMdVPmQmZu
        QcdYf+v8YMe21NYXg1GQV6I=
X-Google-Smtp-Source: ABdhPJyChgJYhTo+p5S189H5duTstjsG7BENGIPd7duv34/mMfqPc3J1u3WlRhmITYV4kROnsMQKkw==
X-Received: by 2002:a5d:4808:: with SMTP id l8mr4215129wrq.349.1628873029830;
        Fri, 13 Aug 2021 09:43:49 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.210])
        by smtp.gmail.com with ESMTPSA id s10sm2495829wrv.54.2021.08.13.09.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 09:43:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v2 0/4] open/accept directly into io_uring fixed file table 
Date:   Fri, 13 Aug 2021 17:43:09 +0100
Message-Id: <cover.1628871893.git.asml.silence@gmail.com>
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
// error handling
io_uring_register_files_update(uring_idx, (fd = cqe->res));
// optionally
close((fd = cqe->res));

The idea in pretty old, and was brough up and implemented a year ago
by Josh Triplett, though haven't sought the light for some reasons.

Tested on basic cases, will be sent out as liburing patches later.

A copy paste from 2/2 describing user API and some notes:

The behaviour is controlled by setting sqe->file_index, where 0 implies
the old behaviour. If non-zero value is specified, then it will behave
as described and place the file into a fixed file slot
sqe->file_index - 1. A file table should be already created, the slot
should be valid and empty, otherwise the operation will fail.

Note 1: we can't use IOSQE_FIXED_FILE to switch between modes, because
accept takes a file, and it already uses the flag with a different
meaning.

Note 2: it's u16, where in theory the limit for fixed file tables might
get increased in the future. If would ever happen so, we'll better
workaround later, e.g. by making ioprio to represent upper bits 16 bits.
The layout for open is tight already enough.

since RFC:
 - added attribution
 - updated descriptions
 - rebased

Pavel Begunkov (4):
  net: add accept helper not installing fd
  io_uring: openat directly into fixed fd table
  io_uring: hand code io_accept() fd installing
  io_uring: accept directly into fixed file table

 fs/io_uring.c                 | 114 +++++++++++++++++++++++++++++-----
 include/linux/socket.h        |   3 +
 include/uapi/linux/io_uring.h |   2 +
 net/socket.c                  |  71 +++++++++++----------
 4 files changed, 139 insertions(+), 51 deletions(-)

-- 
2.32.0

