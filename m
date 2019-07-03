Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E980B5E6E0
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbfGCOhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:37:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:51236 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725933AbfGCOhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 10:37:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 718D4AF89;
        Wed,  3 Jul 2019 14:37:23 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id E89DAE0159; Wed,  3 Jul 2019 16:37:22 +0200 (CEST)
Date:   Wed, 3 Jul 2019 16:37:22 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 08/15] ethtool: move string arrays into
 common file
Message-ID: <20190703143722.GN20101@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <0647ac484dac2c655d0e4260d81e86405688ff5b.1562067622.git.mkubecek@suse.cz>
 <20190703134452.GZ2250@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703134452.GZ2250@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 03:44:52PM +0200, Jiri Pirko wrote:
> Tue, Jul 02, 2019 at 01:50:19PM CEST, mkubecek@suse.cz wrote:
> >Introduce file net/ethtool/common.c for code shared by ioctl and netlink
> >ethtool interface. Move name tables of features, RSS hash functions,
> >tunables and PHY tunables into this file.
> >
> >Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> >---
> > net/ethtool/Makefile |  2 +-
> > net/ethtool/common.c | 84 ++++++++++++++++++++++++++++++++++++++++++++
> > net/ethtool/common.h | 17 +++++++++
> > net/ethtool/ioctl.c  | 83 ++-----------------------------------------
> > 4 files changed, 104 insertions(+), 82 deletions(-)
> > create mode 100644 net/ethtool/common.c
> > create mode 100644 net/ethtool/common.h
> >
> >diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
> >index 482fdb9380fa..11782306593b 100644
> >--- a/net/ethtool/Makefile
> >+++ b/net/ethtool/Makefile
> >@@ -1,6 +1,6 @@
> > # SPDX-License-Identifier: GPL-2.0
> > 
> >-obj-y				+= ioctl.o
> >+obj-y				+= ioctl.o common.o
> > 
> > obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
> > 
> >diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> >new file mode 100644
> >index 000000000000..b0ce420e994e
> >--- /dev/null
> >+++ b/net/ethtool/common.c
> >@@ -0,0 +1,84 @@
> >+// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
> >+
> >+#include "common.h"
> >+
> >+const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
> 
> const char *netdev_features_strings[NETDEV_FEATURE_COUNT] = {
> ?
> 
> Same with the other arrays.

These are not new tables, this patch only moves existing tables from
ioctl.c (originally net/core/ethtool.c) into common.c so that they can
be used by both ioctl and netlink code.

This fixed size string array format is used by ETHTOOL_GSTRINGS ioctl
command. So if we switch these into simple const char *table[], we can
get rid of some complexity in strset.c and bitset.c (the "simple" vs.
"legacy" string set mess) but we would have to convert them into the
fixed size string array in ioctl ETHTOOL_GSTRINGS handler. And then we
would also have to convert (or rather "index") string sets retrieved
from NIC driver (e.g. private flags, stats, tests) - which also means an
extra kmalloc() (or rather kmalloc_array()).

It an option I'm certainly open to if we agree on it but it's not for
free.

Michal
