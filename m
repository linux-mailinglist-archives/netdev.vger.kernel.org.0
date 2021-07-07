Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB193BE73E
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 13:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbhGGLm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 07:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbhGGLm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 07:42:57 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FF3C061574;
        Wed,  7 Jul 2021 04:40:17 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id v5so2704966wrt.3;
        Wed, 07 Jul 2021 04:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z2uCkvq1OR+Q2+7RwQm8CsU1YV4vRtiyU/JB72/AtBw=;
        b=usKyTp5FUQk85fJW07hOHal5Sw1D6ooqe0BFj+PsBWgqkuvbAm6x9SqSHlUjUiAUr4
         kp4Iv/T6Txn8Ea2lfuhXax5EMPuwmx1EqcPO6l4pbvG5dDQE8539MlcvxBUP3LqsVuqE
         FiWBVRbH7OD/J7JBeL3/ZYFI2qyjTYIrXmyvZMQ85zz+CDHcsJUypMVW2Sf01sL7rnqT
         4FpRTjXRz2X74ywqKC8XLXGqCtS+dSKqw8cTMqupTxpBQulydjE7MuSpwHhTj4Sta9pU
         sm/n/JdAoQ9H1VPcE2GzsOTYvdfYM7Q7uw9/vXE1z7n4ziIGQq+w44fsqeueRIzFmvzE
         zmnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z2uCkvq1OR+Q2+7RwQm8CsU1YV4vRtiyU/JB72/AtBw=;
        b=cdQzL14YPpKRVLcaBd8x56wobu6GWBIHfTc6poNb7K44qGhlXLaapj/9/BPGGcnxCt
         eAKDzJzV9vKoKB/C04hGNthQf2Ejj1Sj3ALdBJLzDbezAwRSsGzz8CMaaChW6woyrPE6
         xRcYcltcN7q8XTEzl2FR/K4YzNlgiDF7nVrvN6b584YEsjhCi6nxlyPjcf1KnXw+KuNw
         m670Ez80ukKVK1+VU/UWHVcV6U/bqBXuRU6qEMbvetTV9fNWoRyxJ2w4HEvyo1MKCdit
         pDH969o+6y7cgcZKZMgjDYCx5h6ajGH3tWWP9p/NEYFQWI7lgnhci/S8gXV1roQwRhHM
         MwlQ==
X-Gm-Message-State: AOAM531QqqCmAZSlh/Zzfxj2uPIdxmtTCXyW7OYl3x9izfpGom77FoWv
        UX5KTXimx1jjT2LwuDfCOtU=
X-Google-Smtp-Source: ABdhPJz+dTwJ0SaK8HojFyHxmzZuXH1YLmz/XkX0t8NVgpdZRZYuDEC1N4sTH6sFCaDwFvMMi2vA7Q==
X-Received: by 2002:adf:ef87:: with SMTP id d7mr27445589wro.204.1625658015756;
        Wed, 07 Jul 2021 04:40:15 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.206])
        by smtp.gmail.com with ESMTPSA id p9sm18415790wmm.17.2021.07.07.04.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 04:40:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC 0/4] open/accept directly into io_uring fixed file table 
Date:   Wed,  7 Jul 2021 12:39:42 +0100
Message-Id: <cover.1625657451.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement an old idea allowing open/accept io_uring requests to register
a newly created file as a io_uring's fixed file instead of placing it
into a task's file table. The switching is encoded in io_uring's SQEs
by setting sqe->buf_index/file_index, so restricted to 2^16-1. Don't
think we need more, but may be a good idea to scrap u32 somewhere
instead.

From the net side only needs a function doing __sys_accept4_file()
but not installing fd, see 2/4.

Only RFC for now, the new functionality is tested only for open yet.
I hope we can remember the author of the idea to add attribution.

Pavel Begunkov (4):
  io_uring: allow open directly into fixed fd table
  net: add an accept helper not installing fd
  io_uring: hand code io_accept()' fd installing
  io_uring: accept directly into fixed file table

 fs/io_uring.c                 | 113 +++++++++++++++++++++++++++++-----
 include/linux/socket.h        |   3 +
 include/uapi/linux/io_uring.h |   2 +
 net/socket.c                  |  71 +++++++++++----------
 4 files changed, 138 insertions(+), 51 deletions(-)

-- 
2.32.0

