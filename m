Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41520280AB7
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733171AbgJAW7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 18:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbgJAW7m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 18:59:42 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3E4620796;
        Thu,  1 Oct 2020 22:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601593182;
        bh=nmuKeGezY1IutyJRkhDtJQGTxkyet2bazX2g6mGXjXw=;
        h=From:To:Cc:Subject:Date:From;
        b=N8XNqBeRVclJbKi0EOfB4IoSoejcDqQ5xHstu7mQxeKs3Ic2WO/VzGeZ+XdwuxIdT
         SVIadD9KRWUFVibIXmb/mZmKB3wfNjdwyTpJPqbcuR0evDowef208QoI/s9fF0+bvr
         NbQY1uzU23D2BVaX35FR0tLc8F/EUSjzOMuXLYxU=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, johannes@sipsolutions.net,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 00/10] genetlink: support per-command policy dump
Date:   Thu,  1 Oct 2020 15:59:23 -0700
Message-Id: <20201001225933.1373426-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

The objective of this series is to dump ethtool policies
to be able to tell which flags are supported by the kernel.
Current release adds ETHTOOL_FLAG_STATS for dumping extra
stats, but because of strict checking we need to make sure
that the flag is actually supported before setting it in
a request.

Ethtool policies are per command, and so far only dumping
family policies was supported.

The series adds new set of "light" ops to genl families which
don't have all the callbacks, and won't have the policy.
Most of families are then moved to these ops. This gives
us 4096B in savings on an allyesconfig build (not counting
the growth that would have happened when policy is added):

     text       data       bss        dec       hex
244415581  227958581  78372980  550747142  20d3bc06
244415581  227962677  78372980  550751238  20d3cc06

Next 6 patches deal the dumping per-op policy.

v2:
 - remove the stale comment in taskstats
 - split patch 8 -> 8, 9
 - now the getfamily policy is also in the op
 - make cmd u32
v1:
 - replace remaining uses of "light" with "small"
 - fix dump (ops can't be on the stack there)
 - coding changes in patch 4
 - new patch 7
 - don't echo op in responses - to make dump all easier

Dave - this series will cause a very trivial conflict with
the patch I sent to net. Both sides add some kdoc to struct
genl_ops so we'll need to keep it all.  I'm sending this
already because I also need to restructure ethool policies
in time for 5.10 if we want to use it for the stats flag.

Jakub Kicinski (10):
  genetlink: reorg struct genl_family
  genetlink: add small version of ops
  genetlink: move to smaller ops wherever possible
  genetlink: add a structure for dump state
  genetlink: use .start callback for dumppolicy
  genetlink: bring back per op policy
  taskstats: move specifying netlink policy back to ops
  genetlink: use parsed attrs in dumppolicy
  genetlink: switch control commands to per-op policies
  genetlink: allow dumping command-specific policy

 drivers/block/nbd.c                      |   6 +-
 drivers/net/gtp.c                        |   6 +-
 drivers/net/ieee802154/mac802154_hwsim.c |   6 +-
 drivers/net/macsec.c                     |   6 +-
 drivers/net/team/team.c                  |   6 +-
 drivers/net/wireless/mac80211_hwsim.c    |   6 +-
 drivers/target/target_core_user.c        |   6 +-
 drivers/thermal/thermal_netlink.c        |   8 +-
 fs/dlm/netlink.c                         |   6 +-
 include/net/genetlink.h                  |  67 +++++--
 include/net/netlink.h                    |   9 +-
 include/uapi/linux/genetlink.h           |   1 +
 kernel/taskstats.c                       |  40 +---
 net/batman-adv/netlink.c                 |   6 +-
 net/core/devlink.c                       |   6 +-
 net/core/drop_monitor.c                  |   6 +-
 net/hsr/hsr_netlink.c                    |   6 +-
 net/ieee802154/netlink.c                 |   6 +-
 net/ipv4/fou.c                           |   6 +-
 net/ipv4/tcp_metrics.c                   |   6 +-
 net/l2tp/l2tp_netlink.c                  |   6 +-
 net/mptcp/pm_netlink.c                   |   6 +-
 net/ncsi/ncsi-netlink.c                  |   6 +-
 net/netfilter/ipvs/ip_vs_ctl.c           |   6 +-
 net/netlabel/netlabel_calipso.c          |   6 +-
 net/netlabel/netlabel_cipso_v4.c         |   6 +-
 net/netlabel/netlabel_mgmt.c             |   6 +-
 net/netlabel/netlabel_unlabeled.c        |   6 +-
 net/netlink/genetlink.c                  | 234 ++++++++++++++++-------
 net/netlink/policy.c                     |  29 +--
 net/openvswitch/conntrack.c              |   6 +-
 net/openvswitch/datapath.c               |  24 +--
 net/openvswitch/meter.c                  |   6 +-
 net/psample/psample.c                    |   6 +-
 net/tipc/netlink_compat.c                |   6 +-
 net/wimax/stack.c                        |   6 +-
 net/wireless/nl80211.c                   |   5 +
 37 files changed, 346 insertions(+), 239 deletions(-)

-- 
2.26.2

