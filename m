Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3632F4B0D
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbhAMMNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbhAMMNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:13:06 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2E7C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 04:12:25 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id r3so1890748wrt.2
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 04:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lVVjTpyk650lfPD52lcQ5dVXWpFNnJsdByDwoWNJt2U=;
        b=Ei1K6Eo7uAhMpRPMc24wgYewO7gadC13892S+bzvT9Ztet2LUHaJX5dxuplY87b4pM
         f9mOIj7fq51dTWJSFAhdKmcjJ/3nOWg/GBYlZVrllqzTO2BbScdfcBvyuUgh2tWy90KP
         8MVHnpD/yL/i+Qlqq4Su40oRFGsMmoSZg94EyribSh4Dzrha7SGC+qzBivq0n6Vla8g8
         ce6PK6aWl1xbpBKZmF721+/K2ImNzRT0cKQynJqE4Qu6hfNC09HeRD3ltk5NaelYtIZ3
         TVmJ5i5hsySK9Mesqabf7+joB4G0sniZgsD254MYvegATO3FSFfAFoAdGyNyqJQzjKn7
         TuPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lVVjTpyk650lfPD52lcQ5dVXWpFNnJsdByDwoWNJt2U=;
        b=Fak56GQdZqwsusUtYr0bF6k+uxrzNSzwlltCBfRGJK052KezUHFg0EHoMhi0RWYOmN
         tvymknMWSUvk4iQXPniyngwseUo4CjcPzgCqEzOuBezbu7/l9zTiOt4M2yb8j788qPRt
         E8BV5GVP45lCNL8rRL495BTywb0k94ROiKJDmExDEHk7qkAviKmS5YmfNvnGdvm+IPkW
         zZHCT7ygYF+UJxy481Ymd10eorsKAuGDOoVFNJ5ni3J4b39NUfIIFIQHH/jvVX7mWIBO
         995LeJYQauR5yfGN7tsv00J7I42ZgIkm3HP6QzIBUVeO/XyEAjLI7Ulk2jq8Qc7PsWrG
         DadQ==
X-Gm-Message-State: AOAM531KjRcC9sfpUgr+rmB//UA+M6t5zDJn68/jnchDki4AUhaFOQ5T
        wRrkwNdacheA0GLx7jFu9CVPCTAw2qoFBeyV
X-Google-Smtp-Source: ABdhPJxUHU4997BK2TnidF8+EZAWIOgOJuVoLJgeMdopjS+NER/BFwRnsEH0zLW20KboWXmFvNlIfQ==
X-Received: by 2002:a5d:6607:: with SMTP id n7mr2254676wru.206.1610539943829;
        Wed, 13 Jan 2021 04:12:23 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id p8sm3231188wru.50.2021.01.13.04.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 04:12:23 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, mlxsw@nvidia.com
Subject: [patch net-next RFC 00/10] introduce line card support for modular switch
Date:   Wed, 13 Jan 2021 13:12:12 +0100
Message-Id: <20210113121222.733517-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

This patchset introduces support for modular switch systems.
NVIDIA Mellanox SN4800 is an example of such. It contains 8 slots
to accomodate line cards. Available line cards include:
16X 100GbE (QSFP28)
8X 200GbE (QSFP56)
4X 400GbE (QSFP-DD)

Similar to split cabels, it is essencial for the correctness of
configuration and funcionality to treat the line card entities
in the same way, no matter the line card is inserted or not.
Meaning, the netdevice of a line card port cannot just disappear
when line card is removed. Also, system admin needs to be able
to apply configuration on netdevices belonging to line card port
even before the linecard gets inserted.

To resolve this, a concept of "provisioning" is introduced.
The user may "provision" certain slot with a line card type.
Driver then creates all instances (devlink ports, netdevices, etc)
related to this line card type. The carrier of netdevices stays down.
Once the line card is inserted and activated, the carrier of the
related netdevices goes up.

Once user does not want to use the line card related instances
anymore, he can "unprovision" the slot. Driver then removes the
instances.

Patches 1-5 are extending devlink driver API and UAPI in order to
register, show, dump, provision and activate the line card.
Patches 6-9 are implementing the introduced API in netdevsim

Example:

# Create a new netdevsim device, with no ports and 2 line cards:
$ echo "10 0 2" >/sys/bus/netdevsim/new_device
$ devlink port # No ports are listed
$ devlink lc
netdevsim/netdevsim10:
  lc 0 state unprovisioned
    supported_types:
       card1port card2ports card4ports
  lc 1 state unprovisioned
    supported_types:
       card1port card2ports card4ports

# Note that driver advertizes supported line card types. In case of
# netdevsim, these are 3.

$ devlink lc provision netdevsim/netdevsim10 lc 0 type card4ports
$ devlink lc
netdevsim/netdevsim10:
  lc 0 state provisioned type card4ports
    supported_types:
       card1port card2ports card4ports
  lc 1 state unprovisioned
    supported_types:
       card1port card2ports card4ports
$ devlink port
netdevsim/netdevsim10/1000: type eth netdev eni10nl0p1 flavour physical lc 0 port 1 splittable false
netdevsim/netdevsim10/1001: type eth netdev eni10nl0p2 flavour physical lc 0 port 2 splittable false
netdevsim/netdevsim10/1002: type eth netdev eni10nl0p3 flavour physical lc 0 port 3 splittable false
netdevsim/netdevsim10/1003: type eth netdev eni10nl0p4 flavour physical lc 0 port 4 splittable false
#                                                 ^^                    ^^^^
#                                     netdev name adjusted          index of a line card this port belongs to

$ ip link set eni10nl0p1 up 
$ ip link show eni10nl0p1   
165: eni10nl0p1: <NO-CARRIER,BROADCAST,NOARP,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
    link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff

# Now activate the line card using debugfs. That emulates plug-in event
# on real hardware:
$ echo "Y"> /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/active
$ ip link show eni10nl0p1
165: eni10nl0p1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff
# The carrier is UP now.

Jiri Pirko (10):
  devlink: add support to create line card and expose to user
  devlink: implement line card provisioning
  devlink: implement line card active state
  devlink: append split port number to the port name
  devlink: add port to line card relationship set
  netdevsim: introduce line card support
  netdevsim: allow port objects to be linked with line cards
  netdevsim: create devlink line card object and implement provisioning
  netdevsim: implement line card activation
  selftests: add netdevsim devlink lc test

 drivers/net/netdevsim/bus.c                   |  21 +-
 drivers/net/netdevsim/dev.c                   | 370 ++++++++++++++-
 drivers/net/netdevsim/netdev.c                |   2 +
 drivers/net/netdevsim/netdevsim.h             |  23 +
 include/net/devlink.h                         |  44 ++
 include/uapi/linux/devlink.h                  |  25 +
 net/core/devlink.c                            | 443 +++++++++++++++++-
 .../drivers/net/netdevsim/devlink.sh          |  62 ++-
 8 files changed, 964 insertions(+), 26 deletions(-)

-- 
2.26.2

