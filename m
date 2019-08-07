Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81C3A84E6E
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 16:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbfHGORL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 10:17:11 -0400
Received: from kadath.azazel.net ([81.187.231.250]:46004 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730025AbfHGORK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 10:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=S1ICqeFba6/4xgXYTDH2ivn5FhkTPY2MAzZqJYfm29E=; b=cLotZSu+h8GGPkrTFK59+hLYgn
        RVXnaAbk8rrsSbUGK7d7qYZXiNuzTjkTKUjejybbQIoG/2rKfVhttsuX8+6oyQ4iWDfMrN8Bzqyee
        yRm1zPD0+63/DOS5CQw+Cl7dLjO3XmS8f3QspHNHnhte2w7xDysGjdu+sBDE30QmGoRWQ6zH9Tzbd
        IFz9pSi4SN5t/kFsPRGcDK9TpFYwxuELOspCKSt/fIolh1FJvNMGhE7jvM0gxq1qqNZgAsVLTMA4b
        qQWY1GAQPFJqdsusK+eFqRBpSDMWgBzdj5U+lVF7tcquf9pyz3VT8cjT1XWjWTDyGuQF0/ScX5/ql
        mEvkwbQA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hvMkU-0001Wc-2r; Wed, 07 Aug 2019 15:17:06 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Net Dev <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH net-next v1 0/8] netfilter: header compilation fixes
Date:   Wed,  7 Aug 2019 15:16:57 +0100
Message-Id: <20190807141705.4864-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190722201615.GE23346@azazel.net>
References: <20190722201615.GE23346@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A number of netfilter header files are on the header-test blacklist
becuse they cannot be compiled stand-alone.   There are two main reasons
for this: missing inclusions of other headers, and missing conditionals
checking for CONFIG_* symbols.

The first six of these patches rectify these omissions, the seventh
removes some unnecessary "#ifdef __KERNEL__" checks, and the last
removes all the NF headers from the blacklist.

I've cc'ed Masahiro Yamada because the last patch removes 74 lines from
include/Kbuild and may conflict with his kbuild tree.

Jeremy Sowden (8):
  netfilter: inlined four headers files into another one.
  netfilter: added missing includes to a number of header-files.
  netfilter: added missing IS_ENABLED(CONFIG_BRIDGE_NETFILTER) checks to
    header-file.
  netfilter: added missing IS_ENABLED(CONFIG_NF_TABLES) check to
    header-file.
  netfilter: added missing IS_ENABLED(CONFIG_NF_CONNTRACK) checks to
    some header-files.
  netfilter: added missing IS_ENABLED(CONFIG_NETFILTER) checks to some
    header-files.
  netfilter: removed "#ifdef __KERNEL__" guards from some headers.
  kbuild: removed all netfilter headers from header-test blacklist.

 include/Kbuild                                |  74 ------
 include/linux/netfilter/ipset/ip_set.h        | 238 +++++++++++++++++-
 .../linux/netfilter/ipset/ip_set_comment.h    |  73 ------
 .../linux/netfilter/ipset/ip_set_counter.h    |  84 -------
 .../linux/netfilter/ipset/ip_set_getport.h    |   4 +
 .../linux/netfilter/ipset/ip_set_skbinfo.h    |  42 ----
 .../linux/netfilter/ipset/ip_set_timeout.h    |  77 ------
 include/linux/netfilter/nf_conntrack_amanda.h |   4 +
 include/linux/netfilter/nf_conntrack_dccp.h   |   3 -
 include/linux/netfilter/nf_conntrack_ftp.h    |   8 +-
 include/linux/netfilter/nf_conntrack_h323.h   |  11 +-
 .../linux/netfilter/nf_conntrack_h323_asn1.h  |   2 +
 include/linux/netfilter/nf_conntrack_irc.h    |   5 +-
 include/linux/netfilter/nf_conntrack_pptp.h   |  12 +-
 .../linux/netfilter/nf_conntrack_proto_gre.h  |   2 -
 include/linux/netfilter/nf_conntrack_sane.h   |   4 -
 include/linux/netfilter/nf_conntrack_sip.h    |   6 +-
 include/linux/netfilter/nf_conntrack_snmp.h   |   3 +
 include/linux/netfilter/nf_conntrack_tftp.h   |   5 +
 include/linux/netfilter/x_tables.h            |   6 +
 include/linux/netfilter_arp/arp_tables.h      |   2 +
 include/linux/netfilter_bridge/ebtables.h     |   2 +
 include/linux/netfilter_ipv4/ip_tables.h      |   4 +
 include/linux/netfilter_ipv6/ip6_tables.h     |   2 +
 include/net/netfilter/br_netfilter.h          |  12 +
 include/net/netfilter/ipv4/nf_dup_ipv4.h      |   3 +
 include/net/netfilter/ipv6/nf_defrag_ipv6.h   |   4 +-
 include/net/netfilter/ipv6/nf_dup_ipv6.h      |   2 +
 include/net/netfilter/nf_conntrack.h          |  10 +
 include/net/netfilter/nf_conntrack_acct.h     |  13 +
 include/net/netfilter/nf_conntrack_bridge.h   |   6 +
 include/net/netfilter/nf_conntrack_core.h     |   3 +
 include/net/netfilter/nf_conntrack_count.h    |   3 +
 include/net/netfilter/nf_conntrack_l4proto.h  |   4 +
 .../net/netfilter/nf_conntrack_timestamp.h    |   6 +
 include/net/netfilter/nf_conntrack_tuple.h    |   2 +
 include/net/netfilter/nf_dup_netdev.h         |   2 +
 include/net/netfilter/nf_flow_table.h         |   5 +
 include/net/netfilter/nf_nat.h                |   4 +
 include/net/netfilter/nf_nat_helper.h         |   4 +-
 include/net/netfilter/nf_nat_redirect.h       |   3 +
 include/net/netfilter/nf_queue.h              |   7 +
 include/net/netfilter/nf_reject.h             |   3 +
 include/net/netfilter/nf_synproxy.h           |   4 +
 include/net/netfilter/nf_tables.h             |  12 +
 include/net/netfilter/nf_tables_ipv6.h        |   1 +
 include/net/netfilter/nft_fib.h               |   2 +
 include/net/netfilter/nft_meta.h              |   2 +
 include/net/netfilter/nft_reject.h            |   5 +
 include/uapi/linux/netfilter/xt_policy.h      |   1 +
 net/netfilter/ipset/ip_set_hash_gen.h         |   2 +-
 net/netfilter/xt_set.c                        |   1 -
 52 files changed, 409 insertions(+), 390 deletions(-)
 delete mode 100644 include/linux/netfilter/ipset/ip_set_comment.h
 delete mode 100644 include/linux/netfilter/ipset/ip_set_counter.h
 delete mode 100644 include/linux/netfilter/ipset/ip_set_skbinfo.h
 delete mode 100644 include/linux/netfilter/ipset/ip_set_timeout.h

-- 
2.20.1

