Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A012866A9
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 20:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgJGSOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 14:14:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727237AbgJGSO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 14:14:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602094467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ARzrUT1YSKBK/c3o/UWxshPKkI8c4ivs8VjyiPUC74k=;
        b=cbSxt6POeM7bI5kzCgnhKVAqc9N/py4r5PxrobxZBX143q3DGmLpgrWf92eF9pqxkqD+lE
        M7+Ph/uwN/RxIRhLiMg7WW/1TSSW6gi2gPwNwbo1LdfTQ8aURduMES7Cq0xtewWYQHcgLc
        bmHi+eOFSdQ9bW3GO5hzgJMQqZT4N2U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-xOsYuMNkORGIqBkAFgomfw-1; Wed, 07 Oct 2020 14:14:25 -0400
X-MC-Unique: xOsYuMNkORGIqBkAFgomfw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52E3764141;
        Wed,  7 Oct 2020 18:14:24 +0000 (UTC)
Received: from hpe-dl360pgen9-01.klab.eng.bos.redhat.com (hpe-dl360pgen9-01.klab.eng.bos.redhat.com [10.16.160.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5CA075120;
        Wed,  7 Oct 2020 18:14:20 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 0/5] bonding: rename bond components
Date:   Wed,  7 Oct 2020 14:14:04 -0400
Message-Id: <20201007181409.1275639-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bonding driver's use of master and slave, while largely understood
in technical circles, poses a barrier for inclusion to some potential
members of the development and user community, due to the historical
context of masters and slaves, particularly in the United States. This
is a first full pass at replacing those phrases with more socially
inclusive ones, opting for bond to replace master and port to
replace slave, which is congruent with the bridge and team drivers.

There are a few problems with this change. First up, "port" is used in
the bonding 802.3ad code, so the first step here is to rename port to
ad_port, so we can reuse port. Second, we have the issue of not wanting
to break any existing userspace, which I believe this patchset
accomplishes, preserving all existing sysfs and procfs interfaces, and
adding module parameter aliases where necessary.

Third, we do still have the issue of ease of backporting fixes to
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
as I can tell through testing and inspection, there is no breakage of
any existing interfaces with this set.

v2: legacy module parameters are retained this time, and we're trying
out bond/port instead of aggregator/link in place of master/slave. The
procfs interface legacy output is also duplicated or dropped, depending
on Kconfig, rather than being replaced.

v3: remove Kconfig knob, leave sysfs and procfs interfaces entirely
untouched, but update documentation to reference their deprecated
nature, explain the name changes, add references to NetworkManager,
include more netlink/iproute2 examples and make note of netlink
being the preferred interface for userspace interaction with bonds.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org

Jarod Wilson (5):
  bonding: rename 802.3ad's struct port to ad_port
  bonding: replace use of the term master where possible
  bonding: rename slave to port where possible
  bonding: rename bonding_sysfs_slave.c to _port.c
  bonding: update Documentation for port/bond terminology

 .clang-format                                 |    4 +-
 Documentation/networking/bonding.rst          |  578 ++--
 drivers/infiniband/core/cma.c                 |    2 +-
 drivers/infiniband/core/lag.c                 |    2 +-
 drivers/infiniband/core/roce_gid_mgmt.c       |   10 +-
 drivers/infiniband/hw/mlx4/main.c             |    2 +-
 drivers/net/bonding/Makefile                  |    2 +-
 drivers/net/bonding/bond_3ad.c                | 1701 ++++++------
 drivers/net/bonding/bond_alb.c                |  689 ++---
 drivers/net/bonding/bond_debugfs.c            |    2 +-
 drivers/net/bonding/bond_main.c               | 2339 +++++++++--------
 drivers/net/bonding/bond_netlink.c            |  114 +-
 drivers/net/bonding/bond_options.c            |  258 +-
 drivers/net/bonding/bond_procfs.c             |   86 +-
 drivers/net/bonding/bond_sysfs.c              |   78 +-
 drivers/net/bonding/bond_sysfs_port.c         |  185 ++
 drivers/net/bonding/bond_sysfs_slave.c        |  176 --
 .../ethernet/chelsio/cxgb3/cxgb3_offload.c    |    2 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |   14 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bond.c |    4 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |    2 +-
 .../ethernet/netronome/nfp/flower/lag_conf.c  |    2 +-
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |   12 +-
 include/linux/netdevice.h                     |   22 +-
 include/net/bond_3ad.h                        |   42 +-
 include/net/bond_alb.h                        |   74 +-
 include/net/bond_options.h                    |   18 +-
 include/net/bonding.h                         |  362 +--
 include/net/lag.h                             |    2 +-
 29 files changed, 3479 insertions(+), 3305 deletions(-)
 create mode 100644 drivers/net/bonding/bond_sysfs_port.c
 delete mode 100644 drivers/net/bonding/bond_sysfs_slave.c

-- 
2.27.0

