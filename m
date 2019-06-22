Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A980A4F2DA
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 02:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfFVAp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 20:45:26 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:49472 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbfFVApZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 20:45:25 -0400
Received: by mail-qk1-f202.google.com with SMTP id c4so9443468qkd.16
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 17:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PLGF9MN+YeUf8orTO+4pxBCLfxJTtjGEneY0lB2ZX0Y=;
        b=OwloZ2GvVoWcyrfxM/3YRMRHWGzvtq7sG708F2DB9ePCZSKRwz0djCXJYjL7dL2mo4
         UEkwVL7/4GnQZlhV8M+8pXG1w1+4aN/firRz2g58NYOh8r24K4fxJ8by8j8jZgMsJxME
         W4z3kWA12TkJt0C7GLQUpp1PFCCZ2HmZInydd5SIuRaMjZDju5Ouk1vRstbdwD29Y61c
         8M7m0pCDKyMfnfRQ5dCwHeutb5K0CkVmrQ144GvofHl8k8FdENzJTyU68EhWppSnIDUq
         uHsOKDnvywMLKdO7NkJVpAXb9l1n31W9hJdD1LNtjNDWVYvkKffHruFOQa2Y+ajnot9D
         XQdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PLGF9MN+YeUf8orTO+4pxBCLfxJTtjGEneY0lB2ZX0Y=;
        b=T7SzS1CBo8csA9p2uGgoD+vi49kSKzbT/fFMWLz6u45UlJwLZW8Aqfj8LwfLz/jdIJ
         miGd+5OpfT8qDyyQzH4yPz000qPX0DdE2PK9a+IBHQG9Dvhd/z4MMbvTvwT1j2vcO9YY
         MuZr0maFQEDxhUh/Am+EJeZ88xm0EJWG89KFHWDWei7rDMYRnpe+AB8c6qWHNYV5D3la
         zK7i77x76rWD2SQg/plB9TabSCBZ3TFXLt63cH52/IEJDGW3hGI8V70M+UsAbCIgfH8o
         aka/JTvRFzWVeW4nVt9GIwtpg95c1TfR+cXYqzEwqzCL9vo4BTN5WpDUTs410fEnKe5w
         Q6CQ==
X-Gm-Message-State: APjAAAW+LWIEJTcgy6WzaqlNwWx2tRf/uGDfDnh/hnRGJqDHM0+2D9wA
        aB1VCc32zWnmRJKWKBUuyqetP7hWv+t5Ku/3JvymPRyHOfWEdkKCUMqBeyKeGDvc53Dw6fCIIws
        l37g1fyv2hdlrOkVDWwYdapcf++Qs8nSLLfiiyvx+1ww9csWslaqySvh9/Zfo35SM
X-Google-Smtp-Source: APXvYqyw/rfxI3iVABWfBp42eclyrOhmZH7YEjA7ef00DNX3r6bFxVZ5TRMjDw6ducvf1FbryuIpCJcYhsri
X-Received: by 2002:a37:a5d5:: with SMTP id o204mr38069606qke.155.1561164324820;
 Fri, 21 Jun 2019 17:45:24 -0700 (PDT)
Date:   Fri, 21 Jun 2019 17:45:19 -0700
Message-Id: <20190622004519.89335-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH next 0/3] blackhole device to invalidate dst
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
 tools/testing/selftests/net/Makefile          |   3 +-
 tools/testing/selftests/net/config            |   1 +
 .../selftests/net/test_blackhole_dev.sh       |  11 ++
 11 files changed, 196 insertions(+), 14 deletions(-)
 create mode 100644 lib/test_blackhole_dev.c
 create mode 100755 tools/testing/selftests/net/test_blackhole_dev.sh

-- 
2.22.0.410.gd8fdbe21b5-goog

