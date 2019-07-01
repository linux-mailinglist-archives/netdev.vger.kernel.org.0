Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E935C50D
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 23:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfGAVit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 17:38:49 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:41820 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfGAVit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 17:38:49 -0400
Received: by mail-pf1-f201.google.com with SMTP id q14so9560717pff.8
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 14:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OTUJ01SFZhn+HS7HslaW0tNe6NVNBc4RfKl+Kzib+Cg=;
        b=OcEbXpnj5wNQ6860l+tts2r0EuPjSbzSoSSlBwUmIuAR7no4+BpmzdioRq6G6Pfxre
         IchxGvEmLrsWK6js9bmq7hFgb85oNgqQ3BXmGmJ6rrbIaH1XLtrN1yTBj5/JdnhSJ26T
         wD5PsZSvDSXhRAs1zblZEjBv/OFofputLyvBJS++FB0cw7WjfJw9kakVgWAcRJV63Yuq
         X7t0coqnvYEx76lT1B6614mdfmE9BXRtCOQ5W463Dm/4DAhV3RzqtOjo0I3LyBaLApby
         PUanumpR+qDDs2l9ql2XjpZHxtGlffM9wU6arnoTzKJUbs1FfvUCrNQHZt0+gFc2Tapd
         gQqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OTUJ01SFZhn+HS7HslaW0tNe6NVNBc4RfKl+Kzib+Cg=;
        b=rJvn7MRRTGjAEFjF9RFgvQIlQm3HkL09VI6DMzHqn/93dkac3Y+/6tnw4f3IvfadVA
         k8JapUXjNTe+aKBcz9a8xUHD0xHktEapn2NI0iX+KOGg87Tpfr15qMZ+6mtt8/xx/AMi
         NgFUfYXkJyFMzY6l3ofAAWgjSdH/Tak9v3yN3AyH47NaqGxMZsKWVm81irus5G9Gjd2k
         NYkakGAxbnPNJxpjp8dH36/y6xFX9HqbaVdcyXqjMEXbjD2D/7FyDYg4sQLYHIpRrRKz
         vSp3bePnW0ogLn6Q329qWwM8N/rjtoEwJEsIWGmN94MG8W5pNsMOJvG+eKiMqovxzKVK
         5jkQ==
X-Gm-Message-State: APjAAAXjie/SeFtslJ4/icu7lFq9RTmCLfXjwbc4wbAsQjWD/Xr311eo
        IANIGbz+E1EdCd+AQKvcpAP3Dot37Y1J2Ds8EMolo6W6jYZzqI0/Xx0aMG+NFkra77PcvsOWaXQ
        kTqhj5cDHIrjpOYpoLMYzaEKa0jT9FiHBS9u/JcsP3iVAZKyhqeSHGzmdVe7GqXJR
X-Google-Smtp-Source: APXvYqxRjOZxEOpxINh2MmiFz0Ml5puffMjY53rE/2UOJPx179Po5p93zh0ljQ0A+05+xBw0SGIG89WgYNVo
X-Received: by 2002:a63:394:: with SMTP id 142mr19109129pgd.43.1562017127889;
 Mon, 01 Jul 2019 14:38:47 -0700 (PDT)
Date:   Mon,  1 Jul 2019 14:38:43 -0700
Message-Id: <20190701213843.102002-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCHv3 next 0/3] blackhole device to invalidate dst
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

v2 -> v3
  fixed Kconfig text/string.

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

