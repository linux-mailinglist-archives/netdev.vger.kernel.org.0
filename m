Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134063AE15A
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 03:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhFUBlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 21:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbhFUBlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 21:41:06 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90C8C061574;
        Sun, 20 Jun 2021 18:38:51 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id d9so12245644qtp.11;
        Sun, 20 Jun 2021 18:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7LiTZ7Vo0EjnxP+a3/KTYoZ8oLYkHRE3dLLVRabPw9E=;
        b=Sll4U/XDqJKc5e+skjJNTFUmpgHc+aYSm9biHzr+vmtz3MtxMUcW72x6aOec1xmvTq
         Lh2Ng38oF6EqKURbwaHzvhKyPjj0W2p+wxzkOBf5U3byVjevwVWyt+DjPPYSduGBG/jp
         MlxTJntEVr656OtyMowKcK68q6fP8FV7NN/qqsMTT6LCHhSZ7MjrEvORv7wnDF+XaQFN
         jDDPcwDRqhD3IjHtLoZzqy26IEVAEoIAXkobZSthhIYLNeA+75Rfe6z0hvp7tejchhk7
         9qDhvJ7pSNQiu/kgKahxQwcmFb2ofMnNfjdcNxGOjofxbpR0e7/g8Q1P3ak8acbwJGie
         fCKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7LiTZ7Vo0EjnxP+a3/KTYoZ8oLYkHRE3dLLVRabPw9E=;
        b=VOhFLuvjX74LUyF5bxe1deyX1VpijN3L0wQkOMmXr9gX9ewtmos7Y7TdxepENpIGM9
         KfcCQ4E3JO7iNBGvnoNsxJiBDVtclDKqu3KS5+wQvWg4bDsBazkEb7QSHVJgao/tT4tg
         sdkeMoLEaxE+WKizPG7V18pEp6t1ru20tdxl8QV9NGCddBJA/zUw4TlA97XesOOTAAIT
         shU7WK9rwPL+OcRC+Hx5M7HS1ZdzMzdR19U6CR0n479FZi4DQj/qDL6pgf13/W4PUeJT
         kTwB3atBziScx2VQlJ3J4Ws8IEjFCWZXP50A1fWO/+OqufGPTiCYIuNTNGvLqsdIp21M
         Qv8g==
X-Gm-Message-State: AOAM532bCNPlTzuX8RDDe7NqGPVGu2lqcMmHffZyhBBlViHlAcOh/o38
        oTNdsd1yalVB0gyogjXMyWyANovC8C4=
X-Google-Smtp-Source: ABdhPJyd5UfsX4+kivw/65qjcIel8DBHPq4Jeoods7KJPo6NwCOolPIifiwoFm4iAhMW3qSAWY7kxw==
X-Received: by 2002:ac8:4e93:: with SMTP id 19mr21520171qtp.202.1624239530858;
        Sun, 20 Jun 2021 18:38:50 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id a3sm9028152qkc.109.2021.06.20.18.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 18:38:50 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCH net-next 00/14] sctp: implement RFC8899: Packetization Layer Path MTU Discovery for SCTP transport
Date:   Sun, 20 Jun 2021 21:38:35 -0400
Message-Id: <cover.1624239422.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Overview(From RFC8899):

  In contrast to PMTUD, Packetization Layer Path MTU Discovery
  (PLPMTUD) [RFC4821] introduces a method that does not rely upon
  reception and validation of PTB messages.  It is therefore more
  robust than Classical PMTUD.  This has become the recommended
  approach for implementing discovery of the PMTU [BCP145].

  It uses a general strategy in which the PL sends probe packets to
  search for the largest size of unfragmented datagram that can be sent
  over a network path.  Probe packets are sent to explore using a
  larger packet size.  If a probe packet is successfully delivered (as
  determined by the PL), then the PLPMTU is raised to the size of the
  successful probe.  If a black hole is detected (e.g., where packets
  of size PLPMTU are consistently not received), the method reduces the
  PLPMTU.

SCTP Probe Packets:

  As the RFC suggested, the probe packets consist of an SCTP common header
  followed by a HEARTBEAT chunk and a PAD chunk. The PAD chunk is used to
  control the length of the probe packet.  The HEARTBEAT chunk is used to
  trigger the sending of a HEARTBEAT ACK chunk to confirm this probe on
  the HEARTBEAT sender.

  The HEARTBEAT chunk also carries a Heartbeat Information parameter that
  includes the probe size to help an implementation associate a HEARTBEAT
  ACK with the size of probe that was sent. The sender use the nonce and
  the probe size to verify the information returned.

Detailed Implementation on SCTP:

                       +------+
              +------->| Base |-----------------+ Connectivity
              |        +------+                 | or BASE_PLPMTU
              |           |                     | confirmation failed
              |           |                     v
              |           | Connectivity    +-------+
              |           | and BASE_PLPMTU | Error |
              |           | confirmed       +-------+
              |           |                     | Consistent
              |           v                     | connectivity
   Black Hole |       +--------+                | and BASE_PLPMTU
    detected  |       | Search |<---------------+ confirmed
              |       +--------+
              |          ^  |
              |          |  |
              |    Raise |  | Search
              |    timer |  | algorithm
              |  expired |  | completed
              |          |  |
              |          |  v
              |   +-----------------+
              +---| Search Complete |
                  +-----------------+

  When PLPMTUD is enabled, it's in Base state, and starts to probe with
  BASE_PLPMTU (1200). If this probe succeeds, it goes to Search state;
  If this probe fails, it goes to Error state under which pl.pmtu goes
  down to MIN_PLPMTU (512) and keeps probing with BASE_PLPMTU until it
  succeeds and goes to Search state.

  During the Search state, the probe size is growing by a Big step (32)
  every time when the last probe succeeds at the beginning. Once a probe
  (such as 1420) fails after trying MAX_PROBES (3) times, the probe_size
  goes back to the last one (1420 - 32 = 1388), meanwhile 'probe_high'
  is set to 1420 and the growing step becomes a Small one (4). Then the
  probe is continuing with a Small step grown each round. Until it gets
  the optimal size (such as 1400) when probe with its next probe size
  (1404) fails, it sync this size to pathmtu and goes to Complete state.

  In Complete state, it will only does a probe check for the pathmtu just
  set, if it fails, which means a Black Hole is detected and it goes back
  to Base state. If it succeeds, it goes back to Search state again, and
  probe is continuing with growing a Small step (1400 + 4). If this probe
  fails, probe_high is set and goes back to 1388 and then Complete state,
  which is kind of a loop normally. However if the env's pathmtu changes
  to a big size somehow, this probe will succeed and then probe continues
  with growing a Big step (1400 + 32) each round until another probe fails.

PTB Messages Process:

  PLPMTUD doesn't rely on these package to find the pmtu, and shouldn't
  trust it either. When processing them, it only changes the probe_size
  to PL_PTB_SIZE(info - hlen) if 'pl.pmtu < PL_PTB_SIZE < the current
  probe_size' druing Search state. As this could help probe_size to get
  to the optimal size faster, for exmaple:

  pl.pmtu = 1388, probe_size = 1420, while the env's pathmtu = 1400.
  When probe_size is 1420, a Toobig packet with 1400 comes back. If probe
  size changes to use 1400, it will save quite a few rounds to get there.
  But of course after having this value, PLPMTUD will still verify it on
  its own before using it.

Patches:

  - Patch 1-6: introduce some new constants/variables from the RFC, systcl
    and members in transport, APIs for the following patches, chunks and
    a timer for the probe sending and some codes for the probe receiving.

  - Patch 7-9: implement the state transition on the tx path, rx path and
    toobig ICMP packet processing. This is the main algorithm part.

  - Patch 10: activate this feature

  - Patch 11-14: improve the process for ICMP packets for SCTP over UDP,
    so that it can also be covered by this feature.

Tests:

  - do sysctl and setsockopt tests for this feature's enabling and disabling.

  - get these pr_debug points for this feature by
      # cat /sys/kernel/debug/dynamic_debug/control | grep PLP
    and enable them on kernel dynamic debug, then play with the pathmtu and
    check if the state transition and plpmtu change match the RFC.

  - do the above tests for SCTP over IPv4/IPv6 and SCTP over UDP.

Xin Long (14):
  sctp: add pad chunk and its make function and event table
  sctp: add probe_interval in sysctl and sock/asoc/transport
  sctp: add SCTP_PLPMTUD_PROBE_INTERVAL sockopt for sock/asoc/transport
  sctp: add the constants/variables and states and some APIs for
    transport
  sctp: add the probe timer in transport for PLPMTUD
  sctp: do the basic send and recv for PLPMTUD probe
  sctp: do state transition when PROBE_COUNT == MAX_PROBES on HB send
    path
  sctp: do state transition when a probe succeeds on HB ACK recv path
  sctp: do state transition when receiving an icmp TOOBIG packet
  sctp: enable PLPMTUD when the transport is ready
  sctp: remove the unessessary hold for idev in sctp_v6_err
  sctp: extract sctp_v6_err_handle function from sctp_v6_err
  sctp: extract sctp_v4_err_handle function from sctp_v4_err
  sctp: process sctp over udp icmp err on sctp side

 Documentation/networking/ip-sysctl.rst |   8 ++
 include/linux/sctp.h                   |   7 ++
 include/net/netns/sctp.h               |   3 +
 include/net/sctp/command.h             |   1 +
 include/net/sctp/constants.h           |  20 ++++
 include/net/sctp/sctp.h                |  57 ++++++++-
 include/net/sctp/sm.h                  |   6 +-
 include/net/sctp/structs.h             |  19 +++
 include/uapi/linux/sctp.h              |   8 ++
 net/sctp/associola.c                   |   6 +
 net/sctp/debug.c                       |   1 +
 net/sctp/input.c                       | 132 ++++++++++++---------
 net/sctp/ipv6.c                        | 112 +++++++++++-------
 net/sctp/output.c                      |  36 +++++-
 net/sctp/outqueue.c                    |  13 ++-
 net/sctp/protocol.c                    |  21 +---
 net/sctp/sm_make_chunk.c               |  31 ++++-
 net/sctp/sm_sideeffect.c               |  37 ++++++
 net/sctp/sm_statefuns.c                |  37 +++++-
 net/sctp/sm_statetable.c               |  43 +++++++
 net/sctp/socket.c                      | 123 ++++++++++++++++++++
 net/sctp/sysctl.c                      |  35 ++++++
 net/sctp/transport.c                   | 153 ++++++++++++++++++++++++-
 23 files changed, 782 insertions(+), 127 deletions(-)

-- 
2.27.0

