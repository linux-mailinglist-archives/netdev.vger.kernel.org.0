Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD0C18395A
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 20:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgCLTTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 15:19:06 -0400
Received: from smtprelay0078.hostedemail.com ([216.40.44.78]:55542 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726553AbgCLTTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 15:19:06 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 2019A837F27B;
        Thu, 12 Mar 2020 19:19:05 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:541:973:982:988:989:1260:1311:1314:1345:1437:1515:1534:1542:1711:1730:1747:1777:1792:1801:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3870:3871:4605:5007:6119:6261:7903:10004:10848:11026:11658:11914:12043:12048:12296:12297:12679:12895:13161:13229:13255:13894:14096:14394:14721:21080:21433:21451:21627:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: iron54_6c49d87829722
X-Filterd-Recvd-Size: 3313
Received: from joe-laptop.perches.com (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Thu, 12 Mar 2020 19:19:04 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     dri-devel@lists.freedesktop.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] treewide: Convert unscriptable /* fallthrough */ comments to fallthrough;
Date:   Thu, 12 Mar 2020 12:17:11 -0700
Message-Id: <cover.1584040050.git.joe@perches.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several files in the kernel can not be perfectly scripted to convert
/* fallthrough */ style comments to fallthrough; because the direct
scripted conversion causes gcc to emit warnings because the fallthrough;
marking is outside of an #ifdef/#endif block.

e.g.:
	switch (foo) {
	#ifdef CONFIG_BAR
	case BAR:
	     ...
	#endif
	/* fallthrough */
	case BAZ:
	     ...
	}

is converted via script to

	switch (foo) {
	#ifdef CONFIG_BAR
	case BAR:
	     ...
	#endif
	fallthrough;
	case BAZ:
	     ...
	}

gcc emits a warning for the bare fallthrough; before case BAZ: when
CONFIG_BAR is not enabled.

So moving the fallthrough; conversions inside the #ifdef/#endif block
avoids this warning.

These are the only warnings emitted on a treewide scripted conversion as
found by the kernel-robot so applying these patches allows a treewide
conversion, either as multiple discrete patches or a single large patch
to eventually be done.

Joe Perches (3):
  drm: drm_vm: Use fallthrough;
  net: [IPv4/IPv6]: Use fallthrough;
  virt: vbox: Use fallthrough;

 drivers/gpu/drm/drm_vm.c                 | 4 ++--
 drivers/virt/vboxguest/vboxguest_core.c  | 2 +-
 drivers/virt/vboxguest/vboxguest_utils.c | 2 +-
 net/ipv4/af_inet.c                       | 4 ++--
 net/ipv4/ah4.c                           | 2 +-
 net/ipv4/arp.c                           | 2 +-
 net/ipv4/devinet.c                       | 6 +++---
 net/ipv4/fib_semantics.c                 | 4 ++--
 net/ipv4/icmp.c                          | 2 +-
 net/ipv4/ip_output.c                     | 2 +-
 net/ipv4/ipmr.c                          | 2 +-
 net/ipv4/netfilter/nf_log_ipv4.c         | 2 +-
 net/ipv4/netfilter/nf_nat_pptp.c         | 4 ++--
 net/ipv4/nexthop.c                       | 2 +-
 net/ipv4/tcp.c                           | 2 +-
 net/ipv4/tcp_input.c                     | 6 +++---
 net/ipv4/tcp_ipv4.c                      | 4 ++--
 net/ipv4/udp.c                           | 2 +-
 net/ipv6/addrconf.c                      | 6 ++----
 net/ipv6/ah6.c                           | 2 +-
 net/ipv6/exthdrs.c                       | 2 +-
 net/ipv6/icmp.c                          | 2 +-
 net/ipv6/ip6_fib.c                       | 8 ++++----
 net/ipv6/ip6mr.c                         | 2 +-
 net/ipv6/ndisc.c                         | 2 +-
 net/ipv6/netfilter/nf_log_ipv6.c         | 2 +-
 net/ipv6/raw.c                           | 8 ++++----
 net/ipv6/route.c                         | 2 +-
 net/ipv6/tcp_ipv6.c                      | 2 +-
 29 files changed, 45 insertions(+), 47 deletions(-)

-- 
2.24.0

