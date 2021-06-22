Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D983B0C74
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhFVSK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbhFVSKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:10:55 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595A4C03C191;
        Tue, 22 Jun 2021 11:05:02 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id g14so108068qtv.4;
        Tue, 22 Jun 2021 11:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ACYQHWslOfOFFBOnLRF6wkw9lgsL1LKIWMJAldkRYrE=;
        b=J+PZ/FGB1+ErzkSyv7+jxGvxRR8/Sdp7VaFZa8m2jb//lw5t6/PCuECutxpvBTLPnZ
         jwnwbSOKLgUMcb4SABok0cHIB9Mdvl5G0FcSOwbNySEdVKeaBgzor2Ny+pFWnNcjXvwh
         Om8F+pS7vBLp9UyMAPBCArq/iVPQVKSl6+QUHMm5UHE7okR0y/mOB6WXX6QAqRMC8l14
         3vGO7x/hhkNuhrw5OisNAtD9QN6ouJRNYeQnzQnzbJanZT/EoqP4qVcaBL69WD8X1SrC
         ReSw9Krzuvt91nFOoJKhLNbMYA7Fd8fh/eMgDc7RZZGtKDhXoC2HG2TxGEapDbYBc5oR
         6LGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ACYQHWslOfOFFBOnLRF6wkw9lgsL1LKIWMJAldkRYrE=;
        b=phzDu6uHvT8WD133wx4s9+Xx2CCUgUycxO5OWLlQnGCcOcX+bvxwT2Y5nT7I9Th0/8
         GGHnlRFFzM7DblKvmwq01oir/L+3QmKL5y1MSOmAapGDJ8LYo2i5UTcnDx8vAxJL7IeH
         OHIVPmqDav8PyJYU1QG/2XUKgZwWN8EzOZ05AFVCdGBmdrEisEZbrVktUepHlkNvxvoz
         TiCY9FJTccxiuJhuujBoxVc9JTdwlg1+P2CIoFsnRd6WhsuH6bpkDf5+bb/PuJKsoghf
         dqzMccJmGKJIIT5it/I1B5EDDUivvCLUC3yZjf0u63E96ROcNhD8hJ9+qVEjj4WCMwGc
         +pVw==
X-Gm-Message-State: AOAM531/BVPod41hxGsuSxL+G0kdhGiDDfhDn9UsN+/FVmSuuvOcxNCz
        H8HSQdrhKY+HT7aeZPEVBarjj6qS0Gk=
X-Google-Smtp-Source: ABdhPJyfUREDhTFLzOt2ePcAFNSlpQ+HEywmgEojkw8VYTLz4uOt7FSjCupVYx9278rhftXD1MeM0g==
X-Received: by 2002:ac8:5383:: with SMTP id x3mr38645qtp.278.1624385101269;
        Tue, 22 Jun 2021 11:05:01 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id e1sm2290693qti.27.2021.06.22.11.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 11:05:00 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCHv2 net-next 00/14] sctp: implement RFC8899: Packetization Layer Path MTU Discovery for SCTP transport
Date:   Tue, 22 Jun 2021 14:04:46 -0400
Message-Id: <cover.1624384990.git.lucien.xin@gmail.com>
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

v1->v2:
  - See Patch 06/14.

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
 net/sctp/output.c                      |  33 +++++-
 net/sctp/outqueue.c                    |  13 ++-
 net/sctp/protocol.c                    |  21 +---
 net/sctp/sm_make_chunk.c               |  31 ++++-
 net/sctp/sm_sideeffect.c               |  37 ++++++
 net/sctp/sm_statefuns.c                |  37 +++++-
 net/sctp/sm_statetable.c               |  43 +++++++
 net/sctp/socket.c                      | 123 ++++++++++++++++++++
 net/sctp/sysctl.c                      |  35 ++++++
 net/sctp/transport.c                   | 153 ++++++++++++++++++++++++-
 23 files changed, 779 insertions(+), 127 deletions(-)

-- 
2.27.0

