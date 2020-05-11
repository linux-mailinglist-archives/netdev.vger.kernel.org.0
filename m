Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10271CD0DE
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 06:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgEKEnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 00:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725790AbgEKEnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 00:43:35 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC6AC061A0C;
        Sun, 10 May 2020 21:43:34 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jY0Ho-005jBz-CV; Mon, 11 May 2020 04:43:28 +0000
Date:   Mon, 11 May 2020 05:43:28 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [RFC][PATCHES] uaccess-related stuff in net/*
Message-ID: <20200511044328.GP23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Assorted uaccess-related work in net/*.  First, there's
getting rid of compat_alloc_user_space() mess in MCAST_...
[gs]etsockopt() - no need to play with copying to/from temporary
object on userland stack, etc., when ->compat_[sg]etsockopt()
instances in question can easly do everything without that.
That's the first 13 patches.  Then there's a trivial bit in
net/batman-adv (completely unrelated to everything else) and
finally getting the atm compat ioctls into simpler shape.

	Please, review and comment.  Individual patches in followups,
the entire branch (on top of current net/master) is in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #uaccess.net

Shortlog:
Al Viro (19):
      lift compat definitions of mcast [sg]etsockopt requests into net/compat.h
      compat_ip{,v6}_setsockopt(): enumerate MCAST_... options explicitly
      ip*_mc_gsfget(): lift copyout of struct group_filter into callers
      get rid of compat_mc_getsockopt()
      set_mcast_msfilter(): take the guts of setsockopt(MCAST_MSFILTER) into a helper
      ipv4: do compat setsockopt for MCAST_MSFILTER directly
      ip6_mc_msfilter(): pass the address list separately
      ipv6: do compat setsockopt for MCAST_MSFILTER directly
      ipv[46]: do compat setsockopt for MCAST_{JOIN,LEAVE}_GROUP directly
      ipv4: take handling of group_source_req options into a helper
      ipv6: take handling of group_source_req options into a helper
      handle the group_source_req options directly
      get rid of compat_mc_setsockopt()
      batadv_socket_read(): get rid of pointless access_ok()
      atm: separate ATM_GETNAMES handling from the rest of atm_dev_ioctl()
      atm: move copyin from atm_getnames() into the caller
      atm: switch do_atm_iobuf() to direct use of atm_getnames()
      atm: lift copyin from atm_dev_ioctl()
      atm: switch do_atmif_sioc() to direct use of atm_dev_ioctl()
Diffstat:
 include/linux/igmp.h         |   2 +-
 include/net/compat.h         |  29 +++-
 include/net/ipv6.h           |   5 +-
 net/atm/ioctl.c              |  96 +++++++------
 net/atm/resources.c          | 108 +++++---------
 net/atm/resources.h          |   5 +-
 net/batman-adv/icmp_socket.c |   3 -
 net/compat.c                 | 194 -------------------------
 net/ipv4/igmp.c              |  18 +--
 net/ipv4/ip_sockglue.c       | 329 ++++++++++++++++++++++++++++++++-----------
 net/ipv6/ipv6_sockglue.c     | 233 ++++++++++++++++++++++++------
 net/ipv6/mcast.c             |  17 +--
 12 files changed, 567 insertions(+), 472 deletions(-)
