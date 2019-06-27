Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAF2458B01
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 21:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfF0TnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 15:43:00 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:33097 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfF0TnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 15:43:00 -0400
Received: by mail-vs1-f74.google.com with SMTP id x140so1122466vsc.0
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 12:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rvqTWRgqdVUuZJBScxjjnn0Y/brPrEuiDmT2nqMsuFg=;
        b=UF//QoKE13S9O9rg14PKggA4WRZ8GuvJqne8ZMiteTmYEafEEp5WITNCRDjdBWvduj
         fKi8+HvgJ7ZsKdDk5vuUAm+DMneHijli8HCoZn5vwYv95Md3Xw666HSkfEmXGAy3HgM8
         9PKCqTYUqhxeo/+QVLzC/qeGzYcfQD9gKsAv58sqfAUdH1iSF8oqX8lJ3+8kCxrzgCJK
         nRubAlkaqxAI37/k1tpuBDt+3e15R2vrCJTtd/ybk9zAENmmY2GjPqaI4MFQOlHjvend
         xJ/TllaggpU65tK77uFjzMrUBro+b0RER/CSIN16R9AhiQJBb98BS4Zffb+39IABUFYj
         oIRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rvqTWRgqdVUuZJBScxjjnn0Y/brPrEuiDmT2nqMsuFg=;
        b=hOpW1VyVS+fY7rgCoAyddTt8P3uSHXXaDwPXX6a9cbjEm62TLpY0PtgQN9h4hoWysS
         7spSkZ5x22O08ahzvozxdxU1XDFNPTq99pxhQtmHcwGAjY0GxMaKVhPUv4DBsCuSg27w
         FDqziauv7f9i5F+CR2YQS1EvzCMXgqYqRV46b/3uNYUdMPb9hJbjpSXYoIAlfGFUYwtD
         Mdc0WoenKOBDwTRsih9CaZ7Rh1WRTKJKRAlTXjY9ySxn89NlBWybgH71V0thiLT5wXGb
         Gp/SNX1+DGZmN8cN3SVK91kScZASiqtyzlO9Q/KqYmWCWu/PZ+D0rS6wgE+y39EZqn/U
         v1gg==
X-Gm-Message-State: APjAAAWzKi0ImCahlp6EUMFKQ30jhzCAOKrZHEQ+p+A7qtQc83NeICw2
        Ddt0kY2Zu4vFRvbwNXi3/KVe9shejelbizGkBiaD+cUUy23HSifg6QVC4MHIT+4FsmJuiX5RdsP
        zG/fxfBsNGkFidoN4ho/yAOXf8+PYpQOnJ0nhsfWi6jMC3pKln42nFf4zLds7qRz8
X-Google-Smtp-Source: APXvYqwc1wpamHDnznMVsaUFPJEarBPjsraSbOzBDi5UVgqEdlDJ05eRE1h6W3xa4c/a5PMyXC7QO7+G9ErM
X-Received: by 2002:a1f:16c9:: with SMTP id 192mr2168587vkw.54.1561664579351;
 Thu, 27 Jun 2019 12:42:59 -0700 (PDT)
Date:   Thu, 27 Jun 2019 12:42:50 -0700
Message-Id: <20190627194250.91296-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCHv2 next 0/3] blackhole device to invalidate dst
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Daniel Axtens <dja@axtens.net>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we invalidate dst or mark it "dead", we assign 'lo' to
dst->dev. First of all this assignment is racy and more over,
it has MTU implications.

The standard dev MTU is 1500 while the Loopback MTU is 64k. TCP
code when dereferencing the dst don't check if the dst is valid
or not. TCP when dereferencing a dead-dst while negotiating a
new connection, may use dst device which is 'lo' instead of
using the correct device. Consider the following scenario:

A SYN arrives on an interface and tcp-layer while processing
SYNACK finds a dst and associates it with SYNACK skb. Now before
skb gets passed to L3 for processing, if that dst gets "dead"
(because of the virtual device getting disappeared & then reappeared),
the 'lo' gets assigned to that dst (lo MTU = 64k). Let's assume
the SYN has ADV_MSS set as 9k while the output device through
which this SYNACK is going to go out has standard MTU of 1500.
The MTU check during the route check passes since MIN(9K, 64K)
is 9k and TCP successfully negotiates 9k MSS. The subsequent
data packet; bigger in size gets passed to the device and it 
won't be marked as GSO since the assumed MTU of the device is
9k.

This either crashes the NIC and we have seen fixes that went
into drivers to handle this scenario. 8914a595110a ('bnx2x:
disable GSO where gso_size is too big for hardware') and
2b16f048729b ('net: create skb_gso_validate_mac_len()') and
with those fixes TCP eventually recovers but not before
few dropped segments.

Well, I'm not a TCP expert and though we have experienced
these corner cases in our environment, I could not reproduce 
this case reliably in my test setup to try this fix myself.
However, Michael Chan <michael.chan@broadcom.com> had a setup
where these fixes helped him mitigate the issue and not cause
the crash.

The idea here is to not alter the data-path with additional
locks or smb()/rmb() barriers to avoid racy assignments but
to create a new device that has really low MTU that has
.ndo_start_xmit essentially a kfree_skb(). Make use of this
device instead of 'lo' when marking the dst dead.

First patch implements the blackhole device and second
patch uses it in IPv4 and IPv6 stack while the third patch
is the self test that ensures the sanity of this device.

v1->v2
  fixed the self-test patch to handle the conflict

Mahesh Bandewar (3):
  loopback: create blackhole net device similar to loopack.
  blackhole_netdev: use blackhole_netdev to invalidate dst entries
  blackhole_dev: add a selftest

 drivers/net/loopback.c                        |  76 +++++++++++--
 include/linux/netdevice.h                     |   2 +
 lib/Kconfig.debug                             |   9 ++
 lib/Makefile                                  |   1 +
 lib/test_blackhole_dev.c                      | 100 ++++++++++++++++++
 net/core/dst.c                                |   2 +-
 net/ipv4/route.c                              |   3 +-
 net/ipv6/route.c                              |   2 +-
 tools/testing/selftests/net/Makefile          |   2 +-
 tools/testing/selftests/net/config            |   1 +
 .../selftests/net/test_blackhole_dev.sh       |  11 ++
 11 files changed, 195 insertions(+), 14 deletions(-)
 create mode 100644 lib/test_blackhole_dev.c
 create mode 100755 tools/testing/selftests/net/test_blackhole_dev.sh

-- 
2.22.0.410.gd8fdbe21b5-goog

