Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64546522A91
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237409AbiEKDza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiEKDz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:55:29 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A89E20F9E7
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:55:27 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c11so642688plg.13
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=pgUf0x9IMyC8ClGRMY2f5UA7rgX258Y7Q0GbPlxY2EM=;
        b=HDOHPlLjJYrWu+Oow2kzsgidT56wHe3InNXEfud0DZcP5i45cYc0G5YfjSHXVNS0vf
         Fwk/MTJWhVSG+JKf3e18jOMue/Ih4DDX0RY0M9WYTas4mI7YswDdUlr9xZL0Ca+vhwZK
         E2S0YE3gZfdFUJ+NkphK0zTypm2TBJkcNVBSY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pgUf0x9IMyC8ClGRMY2f5UA7rgX258Y7Q0GbPlxY2EM=;
        b=pDOcMrZ+ZFzDq/HZ8bbte1NPyV5K1ZxHfHu69JiKgpE8P4DWKSeByuBXcsCOhMC2Ys
         N8ffc06i4JTsSPNi9pOkdQcoVQ4W1/u2/gNOa2J6PU0AmzbzYsXAMXXD03JxFAl5s2TE
         JmwqeHhhMESa/Y4MWqHlk4O/BOuDrI1jq8inyR93NsIjWuXyqP9w+G1zNLWyvIcMurIC
         I753ZNK9sBDlsSFl9oRQJG9nOKtOSeEklRb3g8lvet647wSOWf6PyBohysuwMdBXIzBx
         U16z0ekFD6kcX9fhn7DidHfaaHKjzT7ul2hiuDuwlejF+fKKKReuK8pHtzH5C5xwCFZ6
         21MA==
X-Gm-Message-State: AOAM533D1zQUhS9dM4DlNmSNf6EKGyYgRpuFNyt5oCXwNhETSvY+vRar
        dxAVBonLUm4Qhg1mODDCVUksoiIFCNIlSN7wqEKgwODy2hlNvjNBwx6Bb8q+Bh95sBtbIk+arKt
        12w0Q0xjOu89/HoFlVVGxslffgOYnq9Vm27qOB+oYOL30QrU526pZ8rP0rNWnHkbKGAV6
X-Google-Smtp-Source: ABdhPJzfY5D7FpjxSU63ohupHUsv1vk22TIwqF5qAC2RKgKMRjvTvMqs4NmTUvLxU5qIjzg1GcEw0w==
X-Received: by 2002:a17:903:1d1:b0:15e:9607:d4c9 with SMTP id e17-20020a17090301d100b0015e9607d4c9mr23478904plh.41.1652241325998;
        Tue, 10 May 2022 20:55:25 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id d7-20020a170903230700b0015e8d4eb1f7sm442789plh.65.2022.05.10.20.55.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 May 2022 20:55:25 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [RFC,net-next,x86 0/6] Nontemporal copies in unix socket write path
Date:   Tue, 10 May 2022 20:54:21 -0700
Message-Id: <1652241268-46732-1-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings:

The purpose of this RFC is to gauge initial thoughts/reactions to adding a
path in af_unix for nontemporal copies in the write path. The network stack
supports something similar, but it is enabled for the entire NIC via the
NETIF_F_NOCACHE_COPY bit and cannot (AFAICT) be controlled or adjusted per
socket or per-write and does not affect unix sockets.

This work seeks to build on the existing nontemporal (NT) copy work in the
kernel by adding support in the unix socket write path via a new sendmsg
flag: MSG_NTCOPY. This could also be accomplished via a setsockopt flag,
as well, but this initial implementation adds MSG_NTCOPY for ease of use
and to save an extra system call or two.

In the future, MSG_NTCOPY could be supported by other protocols, and
perhaps used in place of NETIF_F_NOCACHE_COPY to allow user programs to
enable this functionality on a per-write (or per-socket) basis.

If supporting NT copies in the unix write path is acceptable in principle,
I am open to making whatever modifications are requested or needed to get
this RFC closer to a v1. I am sure there will be many; this is just a PoC
in its current form.

As you'll see below, NT copies in the unix write path have a large
measureable impact on certain application architectures and CPUs.

Initial benchmarks are extremely encouraging. I wrote a simple C program to
benchmark this patchset, the program:
  - Creates a unix socket pair
  - Forks a child process
  - The parent process writes to the unix socket using MSG_NTCOPY - or not -
    depending on the command line flags
  - The child process uses splice to move the data from the unix socket to
    a pipe buffer, followed by a second splice call to move the data from
    the pipe buffer to a file descriptor opened on /dev/null.
  - taskset is used when launching the benchmark to ensure the parent and
    child run on appropriate CPUs for various scenarios

The source of the test program is available for examination [1] and results
for three benchmarks I ran are provided below.

Test system: AMD EPYC 7662 64-Core Processor,
	     64 cores / 128 threads,
	     512kb L2 per core shared by sibling CPUs,
	     16mb L3 per NUMA zone,
	     AMD specific settings: NPS=1 and L3 as NUMA enabled 

Test: 1048576 byte object,
      100,000 iterations,
      512kb pipe buffer size,
      512kb unix socket send buffer size

Sample command lines for running the tests provided below. Note that the
command line shows how to run a "normal" copy benchmark. To run the
benchmark in MSG_NTCOPY mode, change command line argument 3 from 0 to 1.

Test pinned to CPUs 1 and 2 which do *not* share an L2 cache, but do share
an L3.

Command line for "normal" copy:
% time taskset -ac 1,2 ./unix-nt-bench 1048576 100000 0 524288 524288

Mode			real time (sec.)		throughput (Mb/s)
"Normal" copy		10.630				78,928
MSG_NTCOPY		7.429				112,935 

Same test as above, but pinned to CPUs 1 and 65 which share an L2 (512kb) and L3
cache (16mb).

Command line for "normal" copy:
% time taskset -ac 1,65 ./unix-nt-bench 1048576 100000 0 524288 524288

Mode			real time (sec.)		throughput (Mb/s)
"Normal" copy		12.532				66,941
MSG_NTCOPY		9.445				88,826	

Same test as above, pinned to CPUs 1 and 65, but with 128kb unix send
buffer and pipe buffer sizes (to avoid spilling L2).

Command line for "normal" copy:
% time taskset -ac 1,65 ./unix-nt-bench 1048576 100000 0 131072 131072

Mode			real time (sec.)		throughput (Mb/s)
"Normal" copy		12.451				67,377
MSG_NTCOPY		9.451				88,768

Thanks,
Joe

[1]: https://gist.githubusercontent.com/jdamato-fsly/03a2f0cd4e71ebe0fef97f7f2980d9e5/raw/19cfd3aca59109ebf5b03871d952ea1360f3e982/unix-nt-copy-bench.c

Joe Damato (6):
  arch, x86, uaccess: Add nontemporal copy functions
  iov_iter: Allow custom copyin function
  iov_iter: Add a nocache copy iov iterator
  net: Add a struct for managing copy functions
  net: Add a way to copy skbs without affect cache
  net: unix: Add MSG_NTCOPY

 arch/x86/include/asm/uaccess_64.h |  6 ++++
 include/linux/skbuff.h            |  2 ++
 include/linux/socket.h            |  1 +
 include/linux/uaccess.h           |  6 ++++
 include/linux/uio.h               |  2 ++
 lib/iov_iter.c                    | 34 ++++++++++++++++++----
 net/core/datagram.c               | 61 ++++++++++++++++++++++++++++-----------
 net/unix/af_unix.c                | 13 +++++++--
 8 files changed, 100 insertions(+), 25 deletions(-)

-- 
2.7.4

