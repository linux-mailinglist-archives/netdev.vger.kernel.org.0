Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD946280697
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 20:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732507AbgJASbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 14:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730070AbgJASbg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 14:31:36 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0387E20706;
        Thu,  1 Oct 2020 18:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601577095;
        bh=KXXII5hj+4KSdSDI64d/kqUl1qwF0KNGBK7vKhq6Ph0=;
        h=From:To:Cc:Subject:Date:From;
        b=i6zI2aTwCGTnEVKARoFmHnpNuPqT+ln8erQiYDrKu8+ea0HvVkLEBsYV9Vth88BRV
         AXyW0jlCDlwmBirDf5mHnvdOFTMT6C8eu4bZ9KRb13/+q+YGLP9mt9pPTdOFDgkVQm
         EF2LyWJPzsEcjMuKZ09qw9CP4rHduNA7zyHgXfW4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, johannes@sipsolutions.net,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/9] genetlink: support per-command policy dump
Date:   Thu,  1 Oct 2020 11:30:07 -0700
Message-Id: <20201001183016.1259870-1-kuba@kernel.org>
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

Next 5 patches deal the dumping per-op policy.

v1:
 - replace remaining uses of "light" with "small" (patch 2)
 - fix dump (ops can't be on the stack there) (patch 2)
 - coding changes in patch 4
 - new patch 7
 - don't echo op in responses - to make dump all easier
   (patch 9)

Dave - this series will cause a very trivial conflict with
the patch I sent to net. Both sides add some kdoc to struct
genl_ops so we'll need to keep it all.  I'm sending this
already because I also need to restructure ethool policies
in time for 5.10 if we want to use it for the stats flag.

Jakub Kicinski (9):
  genetlink: reorg struct genl_family
  genetlink: add small version of ops
  genetlink: move to smaller ops wherever possible
  genetlink: add a structure for dump state
  genetlink: use .start callback for dumppolicy
  genetlink: bring back per op policy
  taskstats: move specifying netlink policy back to ops
  genetlink: use per-op policy for CTRL_CMD_GETPOLICY
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
 kernel/taskstats.c                       |  36 +---
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
 net/netlink/genetlink.c                  | 228 ++++++++++++++++-------
 net/netlink/policy.c                     |  29 +--
 net/openvswitch/conntrack.c              |   6 +-
 net/openvswitch/datapath.c               |  24 +--
 net/openvswitch/meter.c                  |   6 +-
 net/psample/psample.c                    |   6 +-
 net/tipc/netlink_compat.c                |   6 +-
 net/wimax/stack.c                        |   6 +-
 net/wireless/nl80211.c                   |   5 +
 37 files changed, 343 insertions(+), 232 deletions(-)

-- 
2.26.2

