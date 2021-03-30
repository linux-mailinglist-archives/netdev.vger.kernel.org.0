Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545CE34DFD3
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhC3EAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:00:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhC3EAC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:00:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 772F561929;
        Tue, 30 Mar 2021 04:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617076801;
        bh=30e8V1HNC4VYP5RBgYzUqvxdxk7kPAN26Z3IjXa5li0=;
        h=From:To:Cc:Subject:Date:From;
        b=Ekcl4HoIRxRAHQNe7h3Bqr746vl2kIHA1LXXNuaiD5DLIIZhujleCT1y0rQctTkDo
         Jb02WKi7ZOJunYTqJfoirCf08K+UtFCUITud4t36vIPTFlbRD7OWy7zPeOc2+sxeyr
         aDZlYUFQr337AVNx19ODEVqV3Mon2XPbJt4XsKAjaHRBF82RpawP3/ZWev5uN5qxsy
         uWXE7f0fPUEcLjQTVV3JL7gbnvlDTywxJQlj23XNONfV85VwFizjGFqhChD2ANwp3+
         1COnwQmds0IZvD/xPa07+ZfUGki8zOCmqACIkxj1GChwVHe7lRQl6C3HQ1wjF5Hn0K
         YsMinB0lcSlQQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, mkubecek@suse.cz, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] ethtool: support FEC configuration over netlink
Date:   Mon, 29 Mar 2021 20:59:51 -0700
Message-Id: <20210330035954.1206441-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for the equivalents of ETHTOOL_GFECPARAM
and ETHTOOL_SFECPARAM over netlink.

As a reminder - this is an API which allows user to query current
FEC mode, as well as set FEC manually if autoneg is disabled.
It does not configure anything if autoneg is enabled (that said
few/no drivers currently reject .set_fecparam calls while autoneg
is disabled, hopefully FW will just ignore the settings).

The existing functionality is mostly preserved in the new API.
The ioctl interface uses a set of flags, and link modes to tell
user which modes are supported. Here is how the flags translate
to the new interface (skipping descriptions for actual FEC modes):

  ioctl flag      |   description         |  new API
================================================================
ETHTOOL_FEC_OFF   | disabled (supported)  | \
ETHTOOL_FEC_RS    |                       |  ` link mode bitset
ETHTOOL_FEC_BASER |                       |  / .._A_FEC_MODES
ETHTOOL_FEC_LLRS  |                       | /  
ETHTOOL_FEC_AUTO  | pick based on cable   | bool .._A_FEC_AUTO
ETHTOOL_FEC_NONE  | not supported         | no bit, no AUTO reported

Since link modes are already depended on (although somewhat implicitly)
for expressing supported modes - the new interface uses them for
the manual configuration, as well as uses link mode bit number
to communicate the active mode.

Use of link modes allows us to define any number of FEC modes we want,
and reuse the strset we already have defined.

Separating AUTO as its own attribute is the biggest changed compared
to the ioctl. It means drivers can no longer report AUTO as the
active FEC mode because there is no link mode for AUTO.
active_fec == AUTO makes little sense in the first place IMHO,
active_fec should be the actual mode, so hopefully this is fine.

The other minor departure is that None is no longer explicitly
expressed in the API. But drivers are reasonable in handling of
this somewhat pointless bit, so I'm not expecting any issues there.


One extension which could be considered would be moving active FEC
to ETHTOOL_MSG_LINKMODE_*, but then why not move all of FEC into
link modes? I don't know where to draw the line.

netdevsim support and a simple self test are included.

Next step is adding stats similar to the ones added for pause.

Jakub Kicinski (3):
  ethtool: support FEC settings over netlink
  netdevsim: add FEC settings support
  selftests: ethtool: add a netdevsim FEC test

 Documentation/networking/ethtool-netlink.rst  |  62 ++++-
 drivers/net/netdevsim/ethtool.c               |  36 +++
 drivers/net/netdevsim/netdevsim.h             |   3 +
 include/uapi/linux/ethtool_netlink.h          |  17 ++
 net/ethtool/Makefile                          |   2 +-
 net/ethtool/fec.c                             | 238 ++++++++++++++++++
 net/ethtool/netlink.c                         |  19 ++
 net/ethtool/netlink.h                         |   4 +
 .../drivers/net/netdevsim/ethtool-common.sh   |   5 +-
 .../drivers/net/netdevsim/ethtool-fec.sh      | 110 ++++++++
 10 files changed, 492 insertions(+), 4 deletions(-)
 create mode 100644 net/ethtool/fec.c
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/ethtool-fec.sh

-- 
2.30.2

