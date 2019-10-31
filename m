Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7DA7EB193
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 14:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfJaNui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 09:50:38 -0400
Received: from mailout2.hostsharing.net ([83.223.78.233]:56595 "EHLO
        mailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727592AbfJaNui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 09:50:38 -0400
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Oct 2019 09:50:37 EDT
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id 652F110189A6F;
        Thu, 31 Oct 2019 14:41:32 +0100 (CET)
Received: from localhost (pd95be530.dip0.t-ipconnect.de [217.91.229.48])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 1DEEE613C8DC;
        Thu, 31 Oct 2019 14:41:32 +0100 (CET)
X-Mailbox-Line: From de461181e53bcec9a75a9630d0d998d555dc8bf5 Mon Sep 17 00:00:00 2001
Message-Id: <cover.1572528496.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 31 Oct 2019 14:41:00 +0100
Subject: [PATCH nf-next,RFC 0/5] Netfilter egress hook
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Daniel Borkmann <daniel@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a netfilter egress hook to complement the existing ingress hook.

User space support for nft is submitted in a separate patch.

The need for this arose because I had to filter egress packets which do
not match a specific ethertype.  The most common solution appears to be
to enslave the interface to a bridge and use ebtables, but that's
cumbersome to configure and comes with a (small) performance penalty.
An alternative approach is tc, but that doesn't afford equivalent
matching options as netfilter.  A bit of googling reveals that more
people have expressed a desire for egress filtering in the past:

https://www.spinics.net/lists/netfilter/msg50038.html
https://unix.stackexchange.com/questions/512371

I am first performing traffic control with sch_handle_egress() before
performing filtering with nf_egress().  That order is identical to
ingress processing.  I'm wondering whether an inverse order would be
more logical or more beneficial.  Among other things it would allow
marking packets with netfilter on egress before performing traffic
control based on that mark.  Thoughts?

Lukas Wunner (5):
  netfilter: Clean up unnecessary #ifdef
  netfilter: Document ingress hook
  netfilter: Rename ingress hook include file
  netfilter: Generalize ingress hook
  netfilter: Introduce egress hook

 include/linux/netdevice.h         |   5 ++
 include/linux/netfilter_ingress.h |  58 -----------------
 include/linux/netfilter_netdev.h  | 102 ++++++++++++++++++++++++++++++
 include/uapi/linux/netfilter.h    |   1 +
 net/core/dev.c                    |  31 ++++++---
 net/netfilter/Kconfig             |   8 +++
 net/netfilter/core.c              |  24 +++++--
 net/netfilter/nft_chain_filter.c  |   4 +-
 8 files changed, 161 insertions(+), 72 deletions(-)
 delete mode 100644 include/linux/netfilter_ingress.h
 create mode 100644 include/linux/netfilter_netdev.h

-- 
2.23.0

