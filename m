Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65319183A3A
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgCLUHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:07:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:45032 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgCLUHk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 16:07:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0B2FDABCE;
        Thu, 12 Mar 2020 20:07:37 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 6B996E0C79; Thu, 12 Mar 2020 21:07:33 +0100 (CET)
Message-Id: <cover.1584043144.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 00/15] ethtool netlink interface, part 3
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Mar 2020 21:07:33 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implementation of more netlink request types:

  - netdev features (ethtool -k/-K, patches 3-6)
  - private flags (--show-priv-flags / --set-priv-flags, patches 7-9)
  - ring sizes (ethtool -g/-G, patches 10-12)
  - channel counts (ethtool -l/-L, patches 13-15)

Patch 1 is a style cleanup suggested in part 2 review and patch 2 updates
the mapping between netdev features and legacy ioctl requests (which are
still used by ethtool for backward compatibility).

Changes in v2:
  - fix netdev reference leaks in error path of ethnl_set_rings() and
    ethnl_set_channels() (found by Jakub Kicinski)
  - use __set_bit() rather than set_bit() (suggested by David Miller)
  - in replies to RINGS_GET and CHANNELS_GET requests, omit ring and
    channel types not supported by driver/device (suggested by Jakub
    Kicinski)
  - more descriptive message size calculations in rings_reply_size() and
    channels_reply_size() (suggested by Jakub Kicinski)
  - coding style cleanup (suggested by Jakub Kicinski)

Michal Kubecek (15):
  ethtool: rename ethnl_parse_header() to ethnl_parse_header_dev_get()
  ethtool: update mapping of features to legacy ioctl requests
  ethtool: provide netdev features with FEATURES_GET request
  ethtool: add ethnl_parse_bitset() helper
  ethtool: set netdev features with FEATURES_SET request
  ethtool: add FEATURES_NTF notification
  ethtool: provide private flags with PRIVFLAGS_GET request
  ethtool: set device private flags with PRIVFLAGS_SET request
  ethtool: add PRIVFLAGS_NTF notification
  ethtool: provide ring sizes with RINGS_GET request
  ethtool: set device ring sizes with RINGS_SET request
  ethtool: add RINGS_NTF notification
  ethtool: provide channel counts with CHANNELS_GET request
  ethtool: set device channel counts with CHANNELS_SET request
  ethtool: add CHANNELS_NTF notification

 Documentation/networking/ethtool-netlink.rst | 272 +++++++++++++++--
 include/uapi/linux/ethtool_netlink.h         |  82 +++++
 net/ethtool/Makefile                         |   3 +-
 net/ethtool/bitset.c                         |  94 ++++++
 net/ethtool/bitset.h                         |   4 +
 net/ethtool/channels.c                       | 227 ++++++++++++++
 net/ethtool/common.c                         |  31 ++
 net/ethtool/common.h                         |   3 +
 net/ethtool/debug.c                          |   6 +-
 net/ethtool/features.c                       | 304 +++++++++++++++++++
 net/ethtool/ioctl.c                          |  52 +---
 net/ethtool/linkinfo.c                       |   6 +-
 net/ethtool/linkmodes.c                      |   6 +-
 net/ethtool/netlink.c                        |  99 +++++-
 net/ethtool/netlink.h                        |  15 +-
 net/ethtool/privflags.c                      | 209 +++++++++++++
 net/ethtool/rings.c                          | 200 ++++++++++++
 net/ethtool/wol.c                            |   5 +-
 18 files changed, 1538 insertions(+), 80 deletions(-)
 create mode 100644 net/ethtool/channels.c
 create mode 100644 net/ethtool/features.c
 create mode 100644 net/ethtool/privflags.c
 create mode 100644 net/ethtool/rings.c

-- 
2.25.1

