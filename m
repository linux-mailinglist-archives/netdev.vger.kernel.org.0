Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E90429AA06
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 11:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1420852AbgJ0Kv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 06:51:56 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35768 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1420751AbgJ0Kv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 06:51:56 -0400
Received: by mail-lj1-f193.google.com with SMTP id x16so1230978ljh.2
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 03:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=9cU1Xy2fUuxWwU4rnMb9NhXWhkoWc9BC0t3d0upVSaA=;
        b=x+bOmPU9mIwB1IZ3NYtd5bTiwhXdk1MSmUcH0q4Ivky7A4m+YNjFAjpfa/v6cYqj94
         utlfjr0fcXwcurd5k5ujGj3zsnrfYanX9loaMmYdZH0KjfCAvOWaaQR2CniTBqoYd3CO
         4DC0TAA8hyZtfwT4UDUNEv2K8QV6b+LQ8u0xiRnIQc+3C5Lw1p88VsXrj/+/Hb6spii6
         oIqpPDqN9XFvHtVN4mrv5CGfqw0Rv9EK22ivoyTi7+ppSIB5rgjAJ6TB6khTe4/NFUAJ
         6gw+pZNzqo8TNm4wv+dqtFcm5WAv+DoEG3QTGSUX9J3f69kPUyS5KDP+BvWl1G4J7zCC
         Jy1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=9cU1Xy2fUuxWwU4rnMb9NhXWhkoWc9BC0t3d0upVSaA=;
        b=Tcl2ZjCX+Der39L83YfOzBlBMLy/K7oPBwr+eLg7X80VjBBqc6JI3/hV3luwzl+tft
         uIlg90ZD2lLptNjDV0GdZhJTsfyrgjmyKvX2XLxKXYWqNxtIJMwD+oi5XvosrbO5RVLu
         k3ZUP0SCCUf5dJTx6qhuVnkjcmuijRoWGHC/RMFCxl6yDDdUIWREO3Q1DiJPzg01ibOQ
         ICG9MAkqFUvnVt7Zw/yYmTbyWSGCgfk/xN1i/8V8+FAyP2VUN1Kh9pBQ3aaRGUCcoj6z
         7SBpK3SXZoFJyF8xANteEZCF65js1CJ5van08S4TtY75rFd0ot4Rt2Cs6TNNo9yMh22+
         D73w==
X-Gm-Message-State: AOAM532QTBA4nTpeEx8u7ukg13flYnUqNDm7O5BU5FEMVmP7kSNJT4CY
        +cEe1IHhejKi4o+eP3qz9CtXzw==
X-Google-Smtp-Source: ABdhPJxFstJSe0T58ZFwVZ8BDJiVzwNQv9GDleLw1ieI5n1P7/56vB6/15DjZTF6+IpjTP4hspsG7g==
X-Received: by 2002:a05:651c:297:: with SMTP id b23mr860185ljo.363.1603795913192;
        Tue, 27 Oct 2020 03:51:53 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id s19sm134385lfb.224.2020.10.27.03.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 03:51:52 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [RFC PATCH 0/4] net: dsa: link aggregation support
Date:   Tue, 27 Oct 2020 11:51:13 +0100
Message-Id: <20201027105117.23052-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series starts by adding the generic support required to offload
link aggregates to drivers built on top of the DSA subsystem. It then
implements offloading for the mv88e6xxx driver, i.e. Marvell's
LinkStreet family.

Posting this as an RFC as there are some topics that I would like
feedback on before going further with testing. Thus far I've done some
basic tests to verify that:

- A LAG can be used as a regular interface.
- Bridging a LAG with other DSA ports works as expected.
- Load balancing is done by the hardware, both in single- and
  multi-chip systems.
- Load balancing is dynamically reconfigured when the state of
  individual links change.

Testing as been done on two systems:

1. Single-chip system with one Peridot (6390X).
2. Multi-chip system with one Agate (6352) daisy-chained with an Opal
   (6097F).

I would really appreciate feedback on the following:

All LAG configuration is cached in `struct dsa_lag`s. I realize that
the standard M.O. of DSA is to read back information from hardware
when required. With LAGs this becomes very tricky though. For example,
the change of a link state on one switch will require re-balancing of
LAG hash buckets on another one, which in turn depends on the total
number of active links in the LAG. Do you agree that this is
motivated?

The LAG driver ops all receive the LAG netdev as an argument when this
information is already available through the port's lag pointer. This
was done to match the way that the bridge netdev is passed to all VLAN
ops even though it is in the port's bridge_dev. Is there a reason for
this or should I just remove it from the LAG ops?

At least on mv88e6xxx, the exact source port is not available when
packets are received on the CPU. The way I see it, there are two ways
around that problem:

- Inject the packet directly on the LAG device (what this series
  does). Feels right because it matches all that we actually know; the
  packet came in on the LAG. It does complicate dsa_switch_rcv
  somewhat as we can no longer assume that skb->dev is a DSA port.

- Inject the packet on "the designated port", i.e. some port in the
  LAG. This lets us keep the current Rx path untouched. The problem is
  that (a) the port would have to be dynamically updated to match the
  expectations of the LAG driver (team/bond) as links are
  enabled/disabled and (b) we would be presenting a lie because
  packets would appear to ingress on netdevs that they might not in
  fact have been physically received on.

(mv88e6xxx) What is the policy regarding the use of DSA vs. EDSA?  It
seems like all chips capable of doing EDSA are using that, except for
the Peridot.

(mv88e6xxx) The cross-chip PVT changes required to allow a LAG to
communicate with the other ports do not feel quite right, but I'm
unsure about what the proper way of doing it would be. Any ideas?

(mv88e6xxx) Marvell has historically used the idiosyncratic term
"trunk" to refer to link aggregates. Somewhere around the Peridot they
have switched and are now referring to the same registers/tables using
the term "LAG". In this series I've stuck to using LAG for all generic
stuff, and only used trunk for driver-internal functions. Do we want
to rename everything to use the LAG nomenclature?

Thanks,
Tobias

Tobias Waldekranz (4):
  net: dsa: mv88e6xxx: use ethertyped dsa for 6390/6390X
  net: dsa: link aggregation support
  net: dsa: mv88e6xxx: link aggregation support
  net: dsa: tag_edsa: support reception of packets from lag devices

 drivers/net/dsa/mv88e6xxx/chip.c    | 232 +++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h    |   4 +
 drivers/net/dsa/mv88e6xxx/global2.c |   8 +-
 drivers/net/dsa/mv88e6xxx/global2.h |   5 +
 drivers/net/dsa/mv88e6xxx/port.c    |  21 +++
 drivers/net/dsa/mv88e6xxx/port.h    |   5 +
 include/net/dsa.h                   |  68 ++++++++
 net/dsa/dsa.c                       |  23 +--
 net/dsa/dsa2.c                      |   3 +
 net/dsa/dsa_priv.h                  |  16 ++
 net/dsa/port.c                      | 146 +++++++++++++++++
 net/dsa/slave.c                     |  53 ++++++-
 net/dsa/switch.c                    |  64 ++++++++
 net/dsa/tag_edsa.c                  |  12 +-
 14 files changed, 635 insertions(+), 25 deletions(-)

-- 
2.17.1

