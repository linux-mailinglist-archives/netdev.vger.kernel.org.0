Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB5FA109792
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 02:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfKZBbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 20:31:51 -0500
Received: from mail-il1-f182.google.com ([209.85.166.182]:41546 "EHLO
        mail-il1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfKZBbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 20:31:50 -0500
Received: by mail-il1-f182.google.com with SMTP id q15so16066448ils.8
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 17:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zn8VqHtQBtNLHrPAO+Qtq4SCfAHM6my3okrNbzHb3zw=;
        b=C3I3otougfcoghtWBTCTtW9XVLF63YTLa3y+xdYGVsv+FLo172kXmj5Keet/4l22/2
         hNsbjD6W/ZJU8dmWQiKt3+iJD6ncVk6NJjZjgjRgJX2oouBvdH6/KZITaBVCtJHTN4VO
         wkronN+KBiS6EMMVmMp29mYOZN+OnGOey+GNc1gu3Tr7h9PfTt0LONgkZSpAS0r5xTRd
         0/KfsxzK18d8lVUfxyqlSxxXNWdCzcg1oHjK7woqI3N5yY1epIQ0NzopCkgtzHzHLKNg
         q4YBbKuS37v/lmsKyuM10ijgTtpHL/VVNhDIPobiZ9xeG3lUZ2BW5J6MWbzOrnAV6rIT
         bC6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zn8VqHtQBtNLHrPAO+Qtq4SCfAHM6my3okrNbzHb3zw=;
        b=Ybf+KRHpwpe4MqlmVR61RNEUjBjL7/Gu4tMxcqwNvQ6S+NTvbg11aYcaQlzmet0hsW
         e1AVq+Ocb3aZvn9bhWNg/i/SWWKInO4bxqwhmf5+PaYHeDmW+ClLCrCFg6p/D0d1nua1
         1y5tY5ZaYCoU6HU6uw9292knCOPJdfEt7Dq7SSWaurO+bRLP9rqoxHhLUhqITpg75fKx
         lXKUSfZX3FvQx/O6eMeCeZSM1yVH0HrALrKvH1IiMMXYHQsXl94dKF0ge1xcNDpHBdQF
         lcKCiuMQvnrImVw+T78skSdZ7iZsr1XdZrJigYn9Nt7LDlk73Na81Y98XAcBJAlVM7mT
         76tQ==
X-Gm-Message-State: APjAAAW3fweetarh+mry/IEFWO4Fse2dsL02DXJpo79sK2EBzjNvm7H8
        W+NEQ6b7QvJwQhPaPauqafjfdFTiwWcE6Q==
X-Google-Smtp-Source: APXvYqwv21MxHcEhO+M570gJR5ka2jeFCO9yI094ZFcm05RuujRjYB5nmNykZNMaC8A6+q0aD+vJjg==
X-Received: by 2002:a92:9ace:: with SMTP id c75mr36775527ill.296.1574731909442;
        Mon, 25 Nov 2019 17:31:49 -0800 (PST)
Received: from localhost.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v15sm2723353ilk.8.2019.11.25.17.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 17:31:48 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net
Subject: [PATCHSET 0/2] Disallow ancillary data from __sys_{recv,send}msg_file()
Date:   Mon, 25 Nov 2019 18:31:43 -0700
Message-Id: <20191126013145.23426-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

io_uring currently uses __sys_sendmsg_file() and __sys_recvmsg_file() to
handle sendmsg and recvmsg operations. This generally works fine, but we
don't want to allow cmsg type operations, just "normal" data transfers.

This small patchset first splits the msghdr copy from the two main
helpers in net/socket.c, then changes __sys_sendmsg_file() and
__sys_recvmsg_file() to use those helpers. With patch 2, we also add a
check to explicitly check for msghdr->msg_control and
msghdr->msg_controllen and return -EINVAL if they are set.

 net/socket.c | 184 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 132 insertions(+), 52 deletions(-)

-- 
Jens Axboe


