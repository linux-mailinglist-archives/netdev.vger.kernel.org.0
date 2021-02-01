Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF1930AE34
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhBARmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbhBARmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 12:42:21 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00CDC061786
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 09:41:41 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id j24so10893733pgn.20
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 09:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=FkWHZoDKLZwI+xuVqRwHYTXFYTqVT0XtYwSO3SpZo80=;
        b=wLBgxMPGLTsJw9XbpqsPQNPCF4M0XtCNj1TGJnEiOw3+lKoOVzDfi9fbNFrRZS876o
         SrDB/CRuRsEXRgFog+0O4NeRpm+DvA+UrwRMdHc3FFCnnD1EKpW3E4/LEqsnbyiquy6i
         i2ohuMKROopdbrWi6DzJrdAbwPImOkGPdDzTBeoUyJZfSn5wlWCFnL074hS1uCZOF+eA
         8VikM/mh/tsWDlMIUuQ/AVuIGgdAULsIov7snfmzDJL/hRq5SwPuPt9kWnqt8x4ct4cs
         XEEn1hT8T2kL/hxQRCQHdwyVp+8CIDiWpSIjpgd5xr0Mph5As2i5JIntT6NRBV0SV3IO
         ZZEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=FkWHZoDKLZwI+xuVqRwHYTXFYTqVT0XtYwSO3SpZo80=;
        b=pH/JBv8KlhMmBgltTTI9wxyAaJ83k8EjDQFkp8Gc2izVyXvE18AJyV8mzUW/7VRBMf
         C2qK8j03S9Pe4PaAya7gFEflxEot47C2ck7AkEeGCdmZSkhV/Pwg3RD5sIr95z7so/I2
         7B5K4ujA9I3BSuEZ9G6W0w+yws92TNR70rIixJ+WMBVsaE80NTWNDln/9tv9iy3EABgI
         7tTb1zUUyj/souvSX7Il8zAytppvVlYZet3jo5Uyu8jJz82KECr43zR+DK9BOIemjffQ
         KNpPcghWd5yx/MwK87uFcuxpRH3koZdwROpptnAY+PCW7IgQUEig0X0aroNRb9kburJI
         U51A==
X-Gm-Message-State: AOAM533TrPs2Q7OucxmTvV+ckRj806HjPj88SAiE8eijJ4zadLIGhBdS
        Rx+upm0+mev8pZJnRwT6B+gk3fBBGQ5E
X-Google-Smtp-Source: ABdhPJzwYpNhfeOeWXyiU79Whm46AxZ2ch9U1ePNDldK5iLljRpOgwXObVbe6qu01K9k4GWxltjBJFRbKDeR
Sender: "brianvv via sendgmr" <brianvv@brianvv.c.googlers.com>
X-Received: from brianvv.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:348])
 (user=brianvv job=sendgmr) by 2002:a17:90a:4548:: with SMTP id
 r8mr44745pjm.16.1612201299266; Mon, 01 Feb 2021 09:41:39 -0800 (PST)
Date:   Mon,  1 Feb 2021 17:41:28 +0000
Message-Id: <20210201174132.3534118-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH net-next v3 0/4] net: use INDIRECT_CALL in some dst_ops
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Luigi Rizzo <lrizzo@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series uses the INDIRECT_CALL wrappers in some dst_ops
functions to mitigate retpoline costs. Benefits depend on the
platform as described below.

Background: The kernel rewrites the retpoline code at
__x86_indirect_thunk_r11 depending on the CPU's requirements.
The INDIRECT_CALL wrappers provide hints on possible targets and
save the retpoline overhead using a direct call in case the
target matches one of the hints.

The retpoline overhead for the following three cases has been
measured by Luigi Rizzo in microbenchmarks, using CPU performance
counters, and cover reasonably well the range of possible retpoline
overheads compared to a plain indirect call (in equal conditions,
specifically with predicted branch, hot cache):

- just "jmp *(%r11)" on modern platforms like Intel Cascadelake.
  In this case the overhead is just 2 clock cycles:

- "lfence; jmp *(%r11)" on e.g. some recent AMD CPUs.
  In this case the lfence is blocked until pending reads complete,
  so the actual overhead depends on previous instructions.
  The best case we have measured 15 clock cycles of overhead.

- worst case, e.g. skylake, the full retpoline is used

    __x86_indirect_thunk_r11:     call set_u_target
    capture_speculation:          pause
                                  lfence
                                  jmp capture_speculation
    .align 16
    set_up_target:                mov %r11, (%rsp)
                                  ret

   In this case the overhead has been measured in 35-40 clock cycles.

The actual time saved hence depends on the platform and current
clock speed (which varies heavily, especially when C-states are active).
Also note that actual benefit might be lower than expected if the
longer retpoline overlaps with some pending memory read.

MEASUREMENTS:
The INDIRECT_CALL wrappers in this patchset involve the processing
of incoming SYN and generation of syncookies. Hence, the test has been
run by configuring a receiving host with a single NIC rx queue, disabling
RPS and RFS so that all processing occurs on the same core.
An external source generates SYN fast enough to saturate the receiving CPU.
We ran two sets of experiments, with and without the dst_output patch,
comparing the number of syncookies generated over a 20s period
in multiple runs.


Assuming the CPU is saturated, the time per packet is
   t = number_of_packets/total_time
and if the two datasets have statistically meaningful difference,
the difference in times between the two cases gives an estimate
of the benefits from one INDIRECT_CALL.

Here are the experimental results:

Skylake     Syncookies over 20s (5 tests)
---------------------------------------------------
indirect    9166325 9182023 9170093 9134014 9171082
retpoline   9099308 9126350 9154841 9056377 9122376

Computing the stats on the ns_pkt = 20e6/total_packets gives the following:

$ ministat -c 95 -w 70 /tmp/sk-indirect /tmp/sk-retp
x /tmp/sk-indirect
+ /tmp/sk-retp
+----------------------------------------------------------------------+
|x     xx x     +          x    + +           +                       +|
||______M__A_______|_|____________M_____A___________________|          |
+----------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5   2.17817e-06   2.18962e-06     2.181e-06  2.182292e-06 4.3252133e-09
+   5   2.18464e-06   2.20839e-06   2.19241e-06  2.194974e-06 8.8695958e-09
Difference at 95.0% confidence
        1.2682e-08 +/- 1.01766e-08
        0.581132% +/- 0.466326%
        (Student's t, pooled s = 6.97772e-09)

This suggests a difference of 13ns +/- 10ns
Our expectation from microbenchmarks was 35-40 cycles per call,
but part of the gains may be eaten by stalls from pending memory reads.

For Cascadelake:
Cascadelake     Syncookies over 20s (5 tests)
---------------------------------------------------------
indirect     10339797 10297547 10366826 10378891 10384854
retpoline    10332674 10366805 10320374 10334272 10374087

Computing the stats on the ns_pkt = 20e6/total_packets gives no
meaningful difference even at just 80% (this was expected):

$ ministat -c 80 -w 70 /tmp/cl-indirect /tmp/cl-retp
x /tmp/cl-indirect
+ /tmp/cl-retp
+----------------------------------------------------------------------+
|   x    x  +     *                   x   + +        +                x|
||______________|_M_________A_____A_______M________|___|               |
+----------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5   1.92588e-06   1.94221e-06   1.92923e-06  1.931716e-06 6.6936746e-09
+   5   1.92788e-06   1.93791e-06   1.93531e-06  1.933188e-06 4.3734106e-09
No difference proven at 80.0% confidence

Changed in v3:
- fix From: tag
- provide measurements

Changed in v2:
-fix build issues reported by kernel test robot

Brian Vazquez (4):
  net: use indirect call helpers for dst_input
  net: use indirect call helpers for dst_output
  net: use indirect call helpers for dst_mtu
  net: indirect call helpers for ipv4/ipv6 dst_check functions

 include/net/dst.h     | 25 +++++++++++++++++++++----
 net/core/sock.c       | 12 ++++++++++--
 net/ipv4/ip_input.c   |  1 +
 net/ipv4/ip_output.c  |  1 +
 net/ipv4/route.c      | 13 +++++++++----
 net/ipv4/tcp_ipv4.c   |  5 ++++-
 net/ipv6/ip6_output.c |  1 +
 net/ipv6/route.c      | 13 +++++++++----
 net/ipv6/tcp_ipv6.c   |  5 ++++-
 9 files changed, 60 insertions(+), 16 deletions(-)

-- 
2.30.0.365.g02bc693789-goog

