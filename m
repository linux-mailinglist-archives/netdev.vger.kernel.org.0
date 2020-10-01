Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163D927F66C
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 02:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730918AbgJAAF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 20:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgJAAF1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 20:05:27 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A229A20754;
        Thu,  1 Oct 2020 00:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601510727;
        bh=EXyy2SUVq/zn/pB+p7ZO+HQ4OWyYUL59blDKtbXJE34=;
        h=From:To:Cc:Subject:Date:From;
        b=TPgqh1BsSmjL13yN8XPWeDWtkUbXugtsOTrviiTLyCH61NyarXtrRmTAYGDwq9WpV
         q+XxLxFyzj4q6qUOeMC+menWGpeq5lJA4l40VWwpjgD7sl+A2l6Qv/8dEuc7TIEM+E
         5owMUzYBkdTreiZAZWkjdgjTyl+ZUvJs3n4VVwlc=
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, johannes@sipsolutions.net, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 0/9] genetlink: support per-command policy dump
Date:   Wed, 30 Sep 2020 17:05:09 -0700
Message-Id: <20201001000518.685243-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

The objective of this series is to dump ethtool policies
to be able to tell which flags are supported by the kernel.
Ethtool policies are per command.

First patch here is included for completeness - it's already
in net, but other patches won't apply cleanly without it.

The series adds new set of "light" ops which don't have all
the callbacks, and won't have the policy. Most of families
are then moved to these ops. This gives us 4096B in savings
on an allyesconfig build (not counting the growth that would
have happened when policy is added):

     text       data       bss        dec       hex
244415581  227958581  78372980  550747142  20d3bc06
244415581  227962677  78372980  550751238  20d3cc06

Next 5 patches deal the dumping per-op policy.

Jakub Kicinski (9):
  genetlink: add missing kdoc for validation flags
  genetlink: reorg struct genl_family
  genetlink: add small version of ops
  genetlink: move to smaller ops wherever possible
  genetlink: add a structure for dump state
  genetlink: use .start callback for dumppolicy
  genetlink: bring back per op policy
  genetlink: use per-op policy for CTRL_CMD_GETPOLICY
  genetlink: allow dumping command-specific policy

 drivers/block/nbd.c                      |   6 +-
 drivers/net/gtp.c                        |   6 +-
 drivers/net/ieee802154/mac802154_hwsim.c |   6 +-
 drivers/net/macsec.c                     |   6 +-
 drivers/net/team/team.c                  |   6 +-
 drivers/net/wireless/mac80211_hwsim.c    |   6 +-
 drivers/target/target_core_user.c        |   6 +-
 drivers/thermal/thermal_netlink.c        |   6 +-
 fs/dlm/netlink.c                         |   6 +-
 include/net/genetlink.h                  |  40 +++-
 include/uapi/linux/genetlink.h           |   1 +
 kernel/taskstats.c                       |   6 +-
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
 net/netlink/genetlink.c                  | 225 ++++++++++++++++-------
 net/openvswitch/conntrack.c              |   6 +-
 net/openvswitch/datapath.c               |  24 +--
 net/openvswitch/meter.c                  |   6 +-
 net/psample/psample.c                    |   6 +-
 net/tipc/netlink_compat.c                |   6 +-
 net/wimax/stack.c                        |   6 +-
 net/wireless/nl80211.c                   |   5 +
 35 files changed, 304 insertions(+), 171 deletions(-)

-- 
2.26.2

