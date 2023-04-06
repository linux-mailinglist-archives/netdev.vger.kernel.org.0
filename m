Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B2A6D9AED
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239443AbjDFOpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239223AbjDFOpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:45:24 -0400
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8471AF06;
        Thu,  6 Apr 2023 07:44:32 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id i9so39775995wrp.3;
        Thu, 06 Apr 2023 07:44:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680792234;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fpeYeTlPCSjCzesZ5RiOpkKQaOiJYEXrA3BRe7RFWW0=;
        b=Uxw34zoCjpFst3tF47bTXIae9lQhPjev5ICBztM5OVVfZzLWw5W8d34DeAbqNFvfH4
         xhI5bwpNf6JGOF1QcBqbw7jeYJ30qJRxcLKE7RllQUH/R9+MRkOEMLlXkB2OWraHvqJV
         5DlK+ntdE7tFbW9CNtSQTGdWlLda9YHtbLKKPtNvBMmoypp9Y5G8f7M+oa69tATkbp73
         pZtPgpZmOOwr+yDMLluhlQmUb5ycJpwug0EOHq31MsUlY3MEHctzPFxDzUgOnBH8dHF6
         WeEe4o5rd75He41GflBTQsgtGhpDiNDfBjGz3Uhndss4rOc0D5vIg8ZKqfyDYC4AblAh
         qC6A==
X-Gm-Message-State: AAQBX9dHHS7ysAkM0iSjagkC2zYiAb7dO7F8ROemfVPRhK9Ge2K//9wJ
        Usqwz/uZcYlBr48cyGAdV87IufooVk1D2Q==
X-Google-Smtp-Source: AKy350aD2Lho4oSNIg7agw45Of4VLNEFw3wGkTM1LkIkjxdhofXWpEzZoYmSuEopYsZQnRAATnKa/w==
X-Received: by 2002:a5d:4d50:0:b0:2ef:930a:cb27 with SMTP id a16-20020a5d4d50000000b002ef930acb27mr165033wru.2.1680792233938;
        Thu, 06 Apr 2023 07:43:53 -0700 (PDT)
Received: from localhost (fwdproxy-cln-028.fbsv.net. [2a03:2880:31ff:1c::face:b00c])
        by smtp.gmail.com with ESMTPSA id e8-20020a5d5308000000b002ce9f0e4a8fsm1945760wrv.84.2023.04.06.07.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 07:43:53 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        asml.silence@gmail.com, axboe@kernel.dk
Cc:     leit@fb.com, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net, dccp@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        willemdebruijn.kernel@gmail.com, matthieu.baerts@tessares.net,
        marcelo.leitner@gmail.com
Subject: [PATCH 0/5] add initial io_uring_cmd support for sockets
Date:   Thu,  6 Apr 2023 07:43:26 -0700
Message-Id: <20230406144330.1932798-1-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Breno Leitao <leit@fb.com>

This patchset creates the initial plumbing for a io_uring command for
sockets.

For now, create two uring commands for sockets, SOCKET_URING_OP_SIOCOUTQ
and SOCKET_URING_OP_SIOCINQ. They are similar to ioctl operations
SIOCOUTQ and SIOCINQ. In fact, the code on the protocol side itself is
heavily based on the ioctl operations.

In order to test this code, I created a liburing test, which is
currently located at [1], and I will create a pull request once we are
good with this patch.

I've also run test/io_uring_passthrough to make sure the first patch
didn't regressed the NVME passthrough path.

This patchset is a RFC for two different reasons:
  * It changes slighlty on how IO uring command operates. I.e, we are
    now passing the whole SQE to the io_uring_cmd callback (instead of
    an opaque buffer). This seems to be more palatable instead of
    creating some custom structure just to fit small parameters, as in
    SOCKET_URING_OP_SIOC{IN,OUT}Q. Is this OK?

  * Pavel has some ideas about the SQE->cmd_op field, so, we can start
    discussing it here.

This work is heavily inspired by Jens Axboe's initial implementation.

[1] https://github.com/leitao/liburing/blob/master/test/socket-io-cmd.c

Breno Leitao (4):
  net: wire up support for file_operations->uring_cmd()
  net: add uring_cmd callback to UDP
  net: add uring_cmd callback to TCP
  net: add uring_cmd callback to raw "protocol"

 include/linux/net.h      |  2 ++
 include/net/raw.h        |  3 +++
 include/net/sock.h       |  6 ++++++
 include/net/tcp.h        |  2 ++
 include/net/udp.h        |  2 ++
 include/uapi/linux/net.h |  5 +++++
 net/core/sock.c          | 17 +++++++++++++++--
 net/dccp/ipv4.c          |  1 +
 net/ipv4/af_inet.c       |  3 +++
 net/ipv4/raw.c           | 26 ++++++++++++++++++++++++++
 net/ipv4/tcp.c           | 34 ++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c      |  1 +
 net/ipv4/udp.c           | 18 ++++++++++++++++++
 net/l2tp/l2tp_ip.c       |  1 +
 net/mptcp/protocol.c     |  1 +
 net/sctp/protocol.c      |  1 +
 net/socket.c             | 13 +++++++++++++
 17 files changed, 134 insertions(+), 2 deletions(-)

-- 
2.34.1



