Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9872B547965
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 11:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235200AbiFLJAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 05:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235156AbiFLJAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 05:00:33 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17369517CF
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 02:00:32 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id z17so1482730wmi.1
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 02:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=bL3IO7tvytV66ahctRHmGVdmaVmcbUuZxI0XVWFQ8ZA=;
        b=JHL9c5Jj8+TTgAFrBdAvWEfZKv/K76qtcJfx/EIfmB2r7S2U8DofeGOLyDw8HLYCoZ
         iEyWEAXSFpm/02ixoec9XeOeaeTauxgSIFJq3A3rcSBMTDyAGP8TcAI/kR3QMrDLsAlY
         mNAl2/obbnT6h7TqFa+zV3mokxklPGO+7gk9o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bL3IO7tvytV66ahctRHmGVdmaVmcbUuZxI0XVWFQ8ZA=;
        b=t9x6d1IEwTlGTEfGNEtfuN+Ct81KERPR3jK4svHu2u+w3co/Tj3vsi0i8Kv3pw+lTL
         0ir3UbUomLVbLKee5ld42GDg8/YoubaekEEsl6sLgYFfkHmxgWSAZCC0aNj0S2MoOgbO
         HEgUASFoq21byoQ+LCIpD99N/EdDP/fVA1DBMjGCbVfAKzxTc98le0DtEoif+4Twu0F2
         0Gf/PwNYPHLzddXXBfVu1bHHkbwUwP9SLOHX01PpJUXmPmchJBlqSpkBzycm7vyUyV2a
         lmreEb0wtSl1KfllygK8i1N0pHf53rCB3kSBJyw6EJ91kf0NT/fUHBAOjQU6Ec4PT4o9
         7LdA==
X-Gm-Message-State: AOAM531QJl28+tyMysYeOYmTc4pSK7lWv8LgR4Y9shjmkc+4g+Dy7pUI
        l2oU5Q2ucgrxoGqVNBFF52jXlQ==
X-Google-Smtp-Source: ABdhPJz0MlOR5KOLHLztCe2inGcdIr3aFFxK6MlpKbF7oSDls4p59MWNYfguvq+Ya6qA/rIGL5MZww==
X-Received: by 2002:a05:600c:2e48:b0:39c:55ba:e4e9 with SMTP id q8-20020a05600c2e4800b0039c55bae4e9mr8398234wmf.180.1655024430554;
        Sun, 12 Jun 2022 02:00:30 -0700 (PDT)
Received: from localhost.localdomain ([178.130.153.185])
        by smtp.gmail.com with ESMTPSA id d34-20020a05600c4c2200b0039c5b4ab1b0sm4798603wmp.48.2022.06.12.02.00.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Jun 2022 02:00:28 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [RFC,net-next,x86 v2 0/8] Nontemporal copies in sendmsg path
Date:   Sun, 12 Jun 2022 01:57:49 -0700
Message-Id: <1655024280-23827-1-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings:

Welcome to RFC v2.

This is my first series that touches more than 1 subsystem; hope I got the
various subject lines and to/cc-lists correct.

Based on the feedback on RFC v1 [1], I've made a few changes:

- Removed the indirect calls.
- Simplified the code a bit by pushing logic down to a wrapper around
  copyin.
- Added support for the 'MSG_NTCOPY' flag to udp, udp-lite, tcp, and unix.

I think this series is much closer to a v1 that can be submit for
consideration, but wanted to test the waters with an RFC first :)

This new set of code allows applications to request non-temporal copies on
individual calls to sendmsg for several socket types, not just unix.

The result is that:

1. Users don't need to specify no cache copy for the entire interface as
   they had been doing previously with ethtool. There is more fine grained
   control of which sendmsgs are non-temporal. I think it makes sense for
   this to be application specific (vs interface-wide) since applications
   will have a better idea of which copy is appropriate.

2. Previously, the ethool bit for enabling no-cache-copy only seems to have
   affected TCP sockets, IIUC. This series supports UDP, UDP-Lite, TCP, and
   Unix. This means the behavior and accessibility of non-temporal copies
   is normalized bit more than it had been previously.

The performance results on my AMD Zen2 test system are identical to the
previous RFC, so I've included those results below.

As you'll see below, NT copies in the unix write path have a large
measureable impact on certain application architectures and CPUs.

Initial benchmarks are extremely encouraging. I wrote a simple C program to
benchmark this patchset, the program:
  - Creates a unix socket pair
  - Forks a child process
  - The parent process writes to the unix socket using MSG_NTCOPY, or not,
    depending on the command line flags
  - The child process uses splice to move the data from the unix socket to
    a pipe buffer, followed by a second splice call to move the data from
    the pipe buffer to a file descriptor opened on /dev/null.
  - taskset is used when launching the benchmark to ensure the parent and
    child run on appropriate CPUs for various scenarios

The source of the test program is available for examination [2] and results
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

Same test as above, but pinned to CPUs 1 and 65 which share an L2 (512kb)
and L3 cache (16mb).

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

[1]: https://patchwork.kernel.org/project/netdevbpf/cover/1652241268-46732-1-git-send-email-jdamato@fastly.com/
[2]: https://gist.githubusercontent.com/jdamato-fsly/03a2f0cd4e71ebe0fef97f7f2980d9e5/raw/19cfd3aca59109ebf5b03871d952ea1360f3e982/unix-nt-copy-bench.c

Joe Damato (8):
  arch, x86, uaccess: Add nontemporal copy functions
  iov_iter: Introduce iter_copy_type
  iov_iter: add copyin_iovec helper
  net: Add MSG_NTCOPY sendmsg flag
  net: unix: Support MSG_NTCOPY
  net: ip: Support MSG_NTCOPY
  net: udplite: Support MSG_NTCOPY
  net: tcp: Support MSG_NTCOPY

 arch/x86/include/asm/uaccess_64.h |  6 ++++++
 include/linux/socket.h            |  9 +++++++++
 include/linux/uaccess.h           |  6 ++++++
 include/linux/uio.h               | 17 +++++++++++++++++
 include/net/sock.h                |  2 +-
 include/net/udplite.h             |  1 +
 lib/iov_iter.c                    | 25 ++++++++++++++++++++-----
 net/ipv4/ip_output.c              |  1 +
 net/ipv4/tcp.c                    |  2 ++
 net/unix/af_unix.c                |  4 ++++
 10 files changed, 67 insertions(+), 6 deletions(-)

-- 
2.7.4

