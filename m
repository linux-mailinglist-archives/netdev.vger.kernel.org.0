Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B80274BF8
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 00:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgIVWTc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Sep 2020 18:19:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58187 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgIVWTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 18:19:31 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kKqdA-0006tL-Mg; Tue, 22 Sep 2020 22:19:24 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 2BF3D5FED0; Tue, 22 Sep 2020 15:19:23 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 25D8A9FB5C;
        Tue, 22 Sep 2020 15:19:23 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] bonding: rename bond components
In-reply-to: <20200922133731.33478-1-jarod@redhat.com>
References: <20200922133731.33478-1-jarod@redhat.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Tue, 22 Sep 2020 09:37:26 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14714.1600813163.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Tue, 22 Sep 2020 15:19:23 -0700
Message-ID: <14715.1600813163@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>The bonding driver's use of master and slave, while largely understood
>in technical circles, poses a barrier for inclusion to some potential
>members of the development and user community, due to the historical
>context of masters and slaves, particularly in the United States. This
>is a first full pass at replacing those phrases with more socially
>inclusive ones, opting for aggregator to replace master and link to
>replace slave, as the bonding driver itself is a link aggregation
>driver.

	First, I think there should be some direction from the kernel
development leadership as to whether or not this type of large-scale
search and replace of socially sensitive terms of art or other
terminology is a task that should be undertaken, given the noted issues
it will cause in stable release maintenance going forwards.

	Second, on the merits of the proposed changes (presuming for the
moment that this goes forward), I would prefer different nomenclature
that does not reuse existing names for different purposes, i.e., "link"
and "aggregator."

	Both of those have specific meanings in the current code, and
old kernels will retain that meaning.  Changing them to have new
meanings going forward will lead to confusion, in my opinion for no good
reason, as there are other names suited that do not conflict.

	For example, instead of "master" call everything a "bond," which
matches common usage in discussion.  Changing "master" to "aggregator,"
the replacement results in cumbersome descriptions like "the
aggregator's active aggregator" in the context of LACP.

	A replacement term for "slave" is trickier; my first choice
would be "port," but that may make more churn from a code change point
of view, although struct slave could become struct bond_port, and leave
the existing struct port for its current LACP use.

>There are a few problems with this change. First up, "link" is used for
>link state already in the bonding driver, so the first step here is to
>rename link to link_state. Second, aggregator is already used in the
>802.3ad code, but I feel the usage is actually consistent with referring
>to the bonding aggregation virtual device as the aggregator. Third, we
>have the issue of not wanting to break any existing userspace, which I
>believe this patchset accomplishes, while also adding alternative
>interfaces using new terminology, and a Kconfig option that will let
>people make the conscious decision to break userspace and no longer
>expose the original master/slave interfaces, once their userspace is
>able to cope with their removal.

	I'm opposed to the Kconfig option because it will lead to
balkanization of the UAPI, which would be worse than a clean break
(which I'm also opposed to).

>Lastly, we do still have the issue of ease of backporting fixes to
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

	I'm skeptical that, given the scope of the changes involved,
that it's really feasible to have effective automated massaging of
patches.  I think the reality is that a large fraction of the bonding
fixes in the future will have to be backported entirely by hand.  The
only saving grace here is that the quantity of such patches is generally
low (~40 in 2020 year to date).

	-J

>See here for further details on Red Hat's commitment to this work:
>https://www.redhat.com/en/blog/making-open-source-more-inclusive-eradicating-problematic-language
>
>As far as testing goes, I've manually operated on various bonds while
>working on this code, and have run it through multiple lnst test runs,
>which exercises the existing sysfs interfaces fairly extensively. As far
>as I can tell, there is no breakage of existing interfaces with this
>set, unless the user consciously opts to do so via Kconfig.
>
>Jarod Wilson (5):
>  bonding: rename struct slave member link to link_state
>  bonding: rename slave to link where possible
>  bonding: rename master to aggregator where possible
>  bonding: make Kconfig toggle to disable legacy interfaces
>  bonding: update Documentation for link/aggregator terminology
>
>Cc: Jay Vosburgh <j.vosburgh@gmail.com>
>Cc: Veaceslav Falico <vfalico@gmail.com>
>Cc: Andy Gospodarek <andy@greyhouse.net>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Thomas Davis <tadavis@lbl.gov>
>Cc: netdev@vger.kernel.org
>
> .clang-format                                 |    4 +-
> Documentation/networking/bonding.rst          |  440 ++--
> drivers/infiniband/core/cma.c                 |    2 +-
> drivers/infiniband/core/lag.c                 |    2 +-
> drivers/infiniband/core/roce_gid_mgmt.c       |   10 +-
> drivers/infiniband/hw/mlx4/main.c             |    2 +-
> drivers/net/Kconfig                           |   12 +
> drivers/net/bonding/Makefile                  |    2 +-
> drivers/net/bonding/bond_3ad.c                |  604 ++---
> drivers/net/bonding/bond_alb.c                |  687 ++---
> drivers/net/bonding/bond_debugfs.c            |    2 +-
> drivers/net/bonding/bond_main.c               | 2336 +++++++++--------
> drivers/net/bonding/bond_netlink.c            |  104 +-
> drivers/net/bonding/bond_options.c            |  258 +-
> drivers/net/bonding/bond_procfs.c             |   63 +-
> drivers/net/bonding/bond_sysfs.c              |  249 +-
> drivers/net/bonding/bond_sysfs_link.c         |  193 ++
> drivers/net/bonding/bond_sysfs_slave.c        |  176 --
> .../ethernet/chelsio/cxgb3/cxgb3_offload.c    |    2 +-
> .../net/ethernet/mellanox/mlx4/en_netdev.c    |    4 +-
> .../ethernet/mellanox/mlx5/core/en/rep/bond.c |    2 +-
> .../net/ethernet/mellanox/mlx5/core/en_tc.c   |    2 +-
> .../ethernet/netronome/nfp/flower/lag_conf.c  |    2 +-
> .../ethernet/qlogic/netxen/netxen_nic_main.c  |   12 +-
> include/linux/netdevice.h                     |   20 +-
> include/net/bond_3ad.h                        |   20 +-
> include/net/bond_alb.h                        |   31 +-
> include/net/bond_options.h                    |   19 +-
> include/net/bonding.h                         |  351 +--
> include/net/lag.h                             |    2 +-
> 30 files changed, 2902 insertions(+), 2711 deletions(-)
> create mode 100644 drivers/net/bonding/bond_sysfs_link.c
> delete mode 100644 drivers/net/bonding/bond_sysfs_slave.c
>
>-- 
>2.27.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
