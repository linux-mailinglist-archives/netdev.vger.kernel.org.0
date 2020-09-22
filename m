Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638D8274346
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 15:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgIVNiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 09:38:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46526 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726473AbgIVNiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 09:38:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600781900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gEQtsye1N5ZeSvXJeI4NA1lJbrYHXyarmLcoIWvJxgc=;
        b=HwlcNyriCVVy2ukxGmow49Rfdrd28NXb4UttLqPwHVtyfQsP7VhAYyTwzuPhvMOhCrYO76
        hxjLE0b7fxqZNOjoF8kRHFm4Wtv6Xoo0hZfdiU/KHo3wNaq5y5RAiFOHDs3q+CyNZg+TtB
        zQoGntnUYC2bGP/qwTu9nI4oPkWF8aU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-SQsjlqhENvyST-45EM32Zw-1; Tue, 22 Sep 2020 09:38:16 -0400
X-MC-Unique: SQsjlqhENvyST-45EM32Zw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 268F41084D9C;
        Tue, 22 Sep 2020 13:38:05 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D9C978822;
        Tue, 22 Sep 2020 13:38:04 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/5] bonding: rename bond components
Date:   Tue, 22 Sep 2020 09:37:26 -0400
Message-Id: <20200922133731.33478-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bonding driver's use of master and slave, while largely understood
in technical circles, poses a barrier for inclusion to some potential
members of the development and user community, due to the historical
context of masters and slaves, particularly in the United States. This
is a first full pass at replacing those phrases with more socially
inclusive ones, opting for aggregator to replace master and link to
replace slave, as the bonding driver itself is a link aggregation
driver.

There are a few problems with this change. First up, "link" is used for
link state already in the bonding driver, so the first step here is to
rename link to link_state. Second, aggregator is already used in the
802.3ad code, but I feel the usage is actually consistent with referring
to the bonding aggregation virtual device as the aggregator. Third, we
have the issue of not wanting to break any existing userspace, which I
believe this patchset accomplishes, while also adding alternative
interfaces using new terminology, and a Kconfig option that will let
people make the conscious decision to break userspace and no longer
expose the original master/slave interfaces, once their userspace is
able to cope with their removal.

Lastly, we do still have the issue of ease of backporting fixes to
-stable trees. I've not had a huge amount of time to spend on it, but
brief forays into coccinelle didn't really pay off (since it's meant to
operate on code, not patches), and the best solution I can come up with
is providing a shell script someone could run over git-format-patch
output before git-am'ing the result to a -stable tree, though scripting
these changes in the first place turned out to be not the best thing to
do anyway, due to subtle cases where use of master or slave can NOT yet
be replaced, so a large amount of work was done by hand, inspection,
trial and error, which is why this set is a lot longer in coming than
I'd originally hoped. I don't expect -stable backports to be horrible to
figure out one way or another though, and I don't believe that a bit of
inconvenience on that front is enough to warrant not making these
changes.

See here for further details on Red Hat's commitment to this work:
https://www.redhat.com/en/blog/making-open-source-more-inclusive-eradicating-problematic-language

As far as testing goes, I've manually operated on various bonds while
working on this code, and have run it through multiple lnst test runs,
which exercises the existing sysfs interfaces fairly extensively. As far
as I can tell, there is no breakage of existing interfaces with this
set, unless the user consciously opts to do so via Kconfig.

Jarod Wilson (5):
  bonding: rename struct slave member link to link_state
  bonding: rename slave to link where possible
  bonding: rename master to aggregator where possible
  bonding: make Kconfig toggle to disable legacy interfaces
  bonding: update Documentation for link/aggregator terminology

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org

 .clang-format                                 |    4 +-
 Documentation/networking/bonding.rst          |  440 ++--
 drivers/infiniband/core/cma.c                 |    2 +-
 drivers/infiniband/core/lag.c                 |    2 +-
 drivers/infiniband/core/roce_gid_mgmt.c       |   10 +-
 drivers/infiniband/hw/mlx4/main.c             |    2 +-
 drivers/net/Kconfig                           |   12 +
 drivers/net/bonding/Makefile                  |    2 +-
 drivers/net/bonding/bond_3ad.c                |  604 ++---
 drivers/net/bonding/bond_alb.c                |  687 ++---
 drivers/net/bonding/bond_debugfs.c            |    2 +-
 drivers/net/bonding/bond_main.c               | 2336 +++++++++--------
 drivers/net/bonding/bond_netlink.c            |  104 +-
 drivers/net/bonding/bond_options.c            |  258 +-
 drivers/net/bonding/bond_procfs.c             |   63 +-
 drivers/net/bonding/bond_sysfs.c              |  249 +-
 drivers/net/bonding/bond_sysfs_link.c         |  193 ++
 drivers/net/bonding/bond_sysfs_slave.c        |  176 --
 .../ethernet/chelsio/cxgb3/cxgb3_offload.c    |    2 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |    4 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bond.c |    2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |    2 +-
 .../ethernet/netronome/nfp/flower/lag_conf.c  |    2 +-
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |   12 +-
 include/linux/netdevice.h                     |   20 +-
 include/net/bond_3ad.h                        |   20 +-
 include/net/bond_alb.h                        |   31 +-
 include/net/bond_options.h                    |   19 +-
 include/net/bonding.h                         |  351 +--
 include/net/lag.h                             |    2 +-
 30 files changed, 2902 insertions(+), 2711 deletions(-)
 create mode 100644 drivers/net/bonding/bond_sysfs_link.c
 delete mode 100644 drivers/net/bonding/bond_sysfs_slave.c

-- 
2.27.0

