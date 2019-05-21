Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3459F25849
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 21:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfEUTaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 15:30:52 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37316 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfEUTaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 15:30:52 -0400
Received: by mail-qt1-f195.google.com with SMTP id o7so21951865qtp.4
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 12:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dx1OUrkFZEbY4LmB5VdTN5Ytb3/nVdfIt7IUkl6z0bM=;
        b=h3VgnCAjJ1MgBDGDPP9s8e/B3tOD6PgDhbyOzSYL2zrG+HsCwD2ABDXR3F61q5/Lrr
         i/gbprUMzz+aZsuU+L3mZdCDHYFEEQn288xCLSbITmKU0yhlZdhvw35gP0eeJx+sUX9P
         azOs4glPJNLse1FTPqn+Xkt7or8VRyw5hf0F4Vr9Dkss4Kcgw+ZAdD3Hre7qfhJQlwTk
         Z+Cksf+9es6ruJgqwOEZ18nydqSrdNGk2IcBqZ+e5+SwxNpM/A527o+yULZhX2i0fI9f
         l4MzPNzfINfmXXVH9ghLinApNaGUjTQI21/wqtkSPb+cjK40SCcShxJo0ribUEXKYTfC
         bfQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dx1OUrkFZEbY4LmB5VdTN5Ytb3/nVdfIt7IUkl6z0bM=;
        b=oK4RaAAhTiBb4JGv0TYoXerJftEuCjVnDsOvvGuHfku0nldM0ZbKGmAkiQcp7sddyD
         KCWaoPx6N6KNsvUbWML3h1drvASmFYCVDMfObjXpdbMjAfPhZtZTuG1s/oCL+7IwPQeE
         JHll6cvxUWC0HcXeDwKUcjBqAzxNkwgujFvrpod2x7eFyig5gUdD+D1qzQOMR8PfDWaS
         PCXKcmkg2FJz3ED7ykjvC3HbW8TrPnNekWesjM9qip1HyRSHfmplQx8DepzhLMgIJIaU
         JsJjsEQWQa5hJ0Vld0mp5no4yUJQtEpUpgQnJm7ONR90DlBQXDsAm2ss5RWJrm9ML8ga
         TPBQ==
X-Gm-Message-State: APjAAAWDLyPm+7acznkyDualxxssM89TvqWe1Xm6yucvo0v6/dsCTvFg
        BcZliRlq14Y4Y43weqqcfe/GHWax
X-Google-Smtp-Source: APXvYqzhN95S2fP4KXDpExIvtJz3rH9wPJWOW3BbX+LSIPzNZ7yc226Ik72iq4EhpMNlasG5/RyTnA==
X-Received: by 2002:a0c:9bae:: with SMTP id o46mr8768497qve.196.1558467049826;
        Tue, 21 May 2019 12:30:49 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id y47sm6529558qtb.55.2019.05.21.12.30.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 May 2019 12:30:48 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     cphealy@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFC net-next 0/9] net: dsa: mv88e6xxx: add RMU support
Date:   Tue, 21 May 2019 15:29:55 -0400
Message-Id: <20190521193004.10767-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is a request for comment for the support for sending
and receiving special management frames between Linux and Ethernet
switch drivers.

The (Marvell) Ethernet switches can respond to special control
frames used to access the internal switch registers. This provides
an alternative control bus for the switches, in addition to SMI. This
is called Remote Management Unit (RMU) and must be activated on
choosen port(s). Here's an illustration of what we may see:

        +-----------+
        |    CPU    +-----+
        +----+ +----+     |             Control path via port 1.
        |eth0| |eth1|     | MDIO        Data path via port port 3.
        +-+--+-+--+-+     |(optional)   eth1 is a dedicated DSA master,
(optional)|       |       |             eth0 is a normal interface,
    +---+-+-+---+-+-+---+ |             doing normal traffic + MGMT.
    | 0 | 1 | 2 | 3 | 4 | | (optional)
    +---+---+---+---+---+ | +--------+  There can also be several
    |  Ethernet Switch  +-+ | EEPROM |  interconnected switches using
    +-----------------+-+   +-+------+  a single control interface.
                      +-------+

Working examples for RMU are the vf610-zii-dev boards where the Control
and Data paths are both using the single DSA master interface wired
to 2 or 3 interconnected switches.

Having access to both SMI and Ethernet busses in the driver is
interesting because they each have specific operations which can
be more efficient in certain scenarios. For example, SMI has an ATU
GetNext operation which is handy to lookup a particular FDB entry,
but is expensive for dumping the whole database. RMU has no ATU
GetNext operation, but a Dump ATU operation allowing to retrieve up
to 48 entries per frame. RMU also has a Wait Bit implementation and
statistics dump operations. Ideally the driver would choose which
bus to use depending on the operation.

This RFC only implements the hooks in DSA to allow a switch driver to
send and receive frames it is interested in, as well as the register
read and write operations through RMU in mv88e6xxx as an illustration.

Please do not spend too much time reviewing the frame crafting itself
(in rmu.c), which currently hardcodes values and must share code with
the (E)DSA taggers. This part will be polished later.

The purpose of this RFC is not to discuss the implementation of RMU
frames in mv88e6xxx, but to discuss the appropriate way to implement
such control bus in the kernel and allow switch drivers to use it.

The master of such Ethernet bus could be any network interface,
doing normal traffic plus control frames for the switch(es) it is
(directly or indirectly) connected to. A proper virtual Ethernet
bus allowing switches to be probed can be implemented, plus DTS
properties to describe which interface to use as a bus master and
on which switch port the remote management must be enabled. In the
meantime, this RFC hooks into DSA.

My concerns are how to properly add hooks to filter frames on the
receive path of any struct net_device (including but not necessarily
a DSA master)? Are there other device drivers out there making use
of multiple control bus at the same time? Is this implementation
sufficient for the moment?


Cheers,

Vivien Didelot (9):
  net: dsa: introduce dsa_master_find_switch
  net: dsa: allow switches to receive frames
  net: dsa: allow switches to transmit frames
  net: dsa: introduce dsa_is_upstream_port
  net: dsa: introduce dsa_to_master
  net: dsa: mv88e6xxx: add default bus operations
  net: dsa: mv88e6xxx: implement RMU enable
  net: dsa: mv88e6xxx: setup RMU port
  net: dsa: mv88e6xxx: setup RMU bus

 drivers/net/dsa/mv88e6xxx/Makefile  |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c    |  43 +++-
 drivers/net/dsa/mv88e6xxx/chip.h    |  14 ++
 drivers/net/dsa/mv88e6xxx/global1.c |  56 +++++
 drivers/net/dsa/mv88e6xxx/global1.h |   2 +
 drivers/net/dsa/mv88e6xxx/rmu.c     | 314 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h     |  34 +++
 drivers/net/dsa/mv88e6xxx/smi.c     |   3 +
 drivers/net/dsa/mv88e6xxx/smi.h     |  18 --
 include/net/dsa.h                   |  32 +++
 net/dsa/dsa2.c                      |   6 +
 net/dsa/dsa_priv.h                  |  19 +-
 net/dsa/switch.c                    |  15 ++
 net/dsa/tag_dsa.c                   |   6 +
 net/dsa/tag_edsa.c                  |   6 +
 15 files changed, 536 insertions(+), 33 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h

-- 
2.21.0

