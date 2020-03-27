Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81AAF19619B
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 00:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgC0XBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 19:01:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:44466 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727585AbgC0XBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 19:01:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CE915AC1D;
        Fri, 27 Mar 2020 23:01:01 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 65AEDE0FC6; Sat, 28 Mar 2020 00:00:58 +0100 (CET)
Message-Id: <cover.1585349448.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v3 00/12] ethtool netlink interface, part 4
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org
Date:   Sat, 28 Mar 2020 00:00:58 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implementation of more netlink request types:

  - coalescing (ethtool -c/-C, patches 2-4)
  - pause parameters (ethtool -a/-A, patches 5-7)
  - EEE settings (--show-eee / --set-eee, patches 8-10)
  - timestamping info (-T, patches 11-12)

Patch 1 is a fix for netdev reference leak similar to commit 2f599ec422ad
("ethtool: fix reference leak in some *_SET handlers") but fixing a code

Changes in v3
  - change "one-step-*" Tx type names to "onestep-*", (patch 11, suggested
    by Richard Cochran
  - use "TSINFO" rather than "TIMESTAMP" for timestamping information
    constants and adjust symbol names (patch 12, suggested by Richard
    Cochran)

Changes in v2:
  - fix compiler warning in net_hwtstamp_validate() (patch 11)
  - fix follow-up lines alignment (whitespace only, patches 3 and 8)
which is only in net-next tree at the moment.

Michal Kubecek (12):
  ethtool: fix reference leak in ethnl_set_privflags()
  ethtool: provide coalescing parameters with COALESCE_GET request
  ethtool: set coalescing parameters with COALESCE_SET request
  ethtool: add COALESCE_NTF notification
  ethtool: provide pause parameters with PAUSE_GET request
  ethtool: set pause parameters with PAUSE_SET request
  ethtool: add PAUSE_NTF notification
  ethtool: provide EEE settings with EEE_GET request
  ethtool: set EEE settings with EEE_SET request
  ethtool: add EEE_NTF notification
  ethtool: add timestamping related string sets
  ethtool: provide timestamping information with TSINFO_GET request

 Documentation/networking/ethtool-netlink.rst | 225 +++++++++++-
 include/uapi/linux/ethtool.h                 |   6 +
 include/uapi/linux/ethtool_netlink.h         |  93 +++++
 include/uapi/linux/net_tstamp.h              |   6 +
 net/core/dev_ioctl.c                         |   6 +
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/coalesce.c                       | 353 +++++++++++++++++++
 net/ethtool/common.c                         |  70 ++++
 net/ethtool/common.h                         |   6 +
 net/ethtool/eee.c                            | 206 +++++++++++
 net/ethtool/ioctl.c                          |  41 +--
 net/ethtool/netlink.c                        |  53 +++
 net/ethtool/netlink.h                        |   7 +
 net/ethtool/pause.c                          | 145 ++++++++
 net/ethtool/privflags.c                      |   4 +-
 net/ethtool/strset.c                         |  15 +
 net/ethtool/tsinfo.c                         | 143 ++++++++
 17 files changed, 1350 insertions(+), 31 deletions(-)
 create mode 100644 net/ethtool/coalesce.c
 create mode 100644 net/ethtool/eee.c
 create mode 100644 net/ethtool/pause.c
 create mode 100644 net/ethtool/tsinfo.c

-- 
2.25.1

