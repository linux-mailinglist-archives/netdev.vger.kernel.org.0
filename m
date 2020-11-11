Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE112AF998
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 21:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgKKUOF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 11 Nov 2020 15:14:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36624 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgKKUOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 15:14:05 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kcwVB-0002LF-Sq; Wed, 11 Nov 2020 20:13:58 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 57C5D5FEE8; Wed, 11 Nov 2020 12:13:56 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 4F9CEA0409;
        Wed, 11 Nov 2020 12:13:56 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/5] bonding: rename bond components
In-reply-to: <20201106200436.943795-1-jarod@redhat.com>
References: <20201106200436.943795-1-jarod@redhat.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Fri, 06 Nov 2020 15:04:31 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10064.1605125636.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 11 Nov 2020 12:13:56 -0800
Message-ID: <10065.1605125636@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>The bonding driver's use of master and slave, while largely understood
>in technical circles, poses a barrier for inclusion to some potential
>members of the development and user community, due to the historical
>context of masters and slaves, particularly in the United States. This
>is a first full pass at replacing those phrases with more socially
>inclusive ones, opting for bond to replace master and port to
>replace slave, which is congruent with the bridge and team drivers.
>
>There are a few problems with this change. First up, "port" is used in
>the bonding 802.3ad code, so the first step here is to rename port to
>ad_port, so we can reuse port. Second, we have the issue of not wanting
>to break any existing userspace, which I believe this patchset
>accomplishes, preserving all existing sysfs and procfs interfaces, and
>adding module parameter aliases where necessary.
>
>Third, we do still have the issue of ease of backporting fixes to
>-stable trees. I've not had a huge amount of time to spend on it, but
>brief forays into coccinelle didn't really pay off (since it's meant to
>operate on code, not patches), and the best solution I can come up with
>is providing a shell script someone could run over git-format-patch
>output before git-am'ing the result to a -stable tree, though scripting
>these changes in the first place turned out to be not the best thing to
>do anyway, due to subtle cases where use of master or slave can NOT yet
>be replaced, so a large amount of work was done by hand, inspection,
>trial and error, which is why this set is a lot longer in coming than
>I'd originally hoped. I don't expect -stable backports to be horrible to
>figure out one way or another though, and I don't believe that a bit of
>inconvenience on that front is enough to warrant not making these
>changes.

	I think this undersells the impact a bit; this will most likely
break the majority of cherry-picks for the bonding driver to stable
going forward should this patch set be committed.  Yes, the volume of
patches to bonding is relatively low, and the manual backports are not
likely to be technically difficult.  Nevertheless, I expect that most
bonding backports to stable that cross this patch set will require
manual intervention.

	As such, I'd still like to see explicit direction from the
kernel development community leadership that change sets of this nature
(not technically driven, with long term maintenance implications) are
changes that should be undertaken rather than are merely permitted.

	-J

>See here for further details on Red Hat's commitment to this work:
>https://www.redhat.com/en/blog/making-open-source-more-inclusive-eradicating-problematic-language
>
>As far as testing goes, I've manually operated on various bonds while
>working on this code, and have run it through multiple lnst test runs,
>which exercises the existing sysfs interfaces fairly extensively. As far
>as I can tell through testing and inspection, there is no breakage of
>any existing interfaces with this set.
>
>v2: legacy module parameters are retained this time, and we're trying
>out bond/port instead of aggregator/link in place of master/slave. The
>procfs interface legacy output is also duplicated or dropped, depending
>on Kconfig, rather than being replaced.
>
>v3: remove Kconfig knob, leave sysfs and procfs interfaces entirely
>untouched, but update documentation to reference their deprecated
>nature, explain the name changes, add references to NetworkManager,
>include more netlink/iproute2 examples and make note of netlink
>being the preferred interface for userspace interaction with bonds.
>
>v4: documentation table of contents fixes
>
>Cc: Jay Vosburgh <j.vosburgh@gmail.com>
>Cc: Veaceslav Falico <vfalico@gmail.com>
>Cc: Andy Gospodarek <andy@greyhouse.net>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Thomas Davis <tadavis@lbl.gov>
>Cc: netdev@vger.kernel.org
>
>Jarod Wilson (5):
>  bonding: rename 802.3ad's struct port to ad_port
>  bonding: replace use of the term master where possible
>  bonding: rename slave to port where possible
>  bonding: rename bonding_sysfs_slave.c to _port.c
>  bonding: update Documentation for port/bond terminology
>
> .clang-format                                 |    4 +-
> Documentation/networking/bonding.rst          |  581 ++--
> drivers/infiniband/core/cma.c                 |    2 +-
> drivers/infiniband/core/lag.c                 |    2 +-
> drivers/infiniband/core/roce_gid_mgmt.c       |   10 +-
> drivers/infiniband/hw/mlx4/main.c             |    2 +-
> drivers/net/bonding/Makefile                  |    2 +-
> drivers/net/bonding/bond_3ad.c                | 1701 ++++++------
> drivers/net/bonding/bond_alb.c                |  689 ++---
> drivers/net/bonding/bond_debugfs.c            |    2 +-
> drivers/net/bonding/bond_main.c               | 2341 +++++++++--------
> drivers/net/bonding/bond_netlink.c            |  114 +-
> drivers/net/bonding/bond_options.c            |  258 +-
> drivers/net/bonding/bond_procfs.c             |   86 +-
> drivers/net/bonding/bond_sysfs.c              |   78 +-
> drivers/net/bonding/bond_sysfs_port.c         |  185 ++
> drivers/net/bonding/bond_sysfs_slave.c        |  176 --
> .../ethernet/chelsio/cxgb3/cxgb3_offload.c    |    2 +-
> .../net/ethernet/mellanox/mlx4/en_netdev.c    |   14 +-
> .../ethernet/mellanox/mlx5/core/en/rep/bond.c |    4 +-
> .../net/ethernet/mellanox/mlx5/core/en_tc.c   |    2 +-
> .../ethernet/netronome/nfp/flower/lag_conf.c  |    2 +-
> .../ethernet/qlogic/netxen/netxen_nic_main.c  |   12 +-
> include/linux/netdevice.h                     |   22 +-
> include/net/bond_3ad.h                        |   42 +-
> include/net/bond_alb.h                        |   74 +-
> include/net/bond_options.h                    |   18 +-
> include/net/bonding.h                         |  362 +--
> include/net/lag.h                             |    2 +-
> 29 files changed, 3482 insertions(+), 3307 deletions(-)
> create mode 100644 drivers/net/bonding/bond_sysfs_port.c
> delete mode 100644 drivers/net/bonding/bond_sysfs_slave.c
>
>-- 
>2.28.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
