Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79E0254160
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 11:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgH0JCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 05:02:03 -0400
Received: from mailout1.hostsharing.net ([83.223.95.204]:35547 "EHLO
        mailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgH0JCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 05:02:02 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Aug 2020 05:02:00 EDT
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id 0D8B9101933FA;
        Thu, 27 Aug 2020 10:55:02 +0200 (CEST)
Received: from localhost (pd95be530.dip0.t-ipconnect.de [217.91.229.48])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id BDF3961248DE;
        Thu, 27 Aug 2020 10:55:01 +0200 (CEST)
X-Mailbox-Line: From d2256c451876583bbbf8f0e82a5a43ce35c5cf2f Mon Sep 17 00:00:00 2001
Message-Id: <cover.1598517739.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 27 Aug 2020 10:55:00 +0200
Subject: [PATCH nf-next v3 0/3] Netfilter egress hook
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, Laura Garcia <nevola@gmail.com>,
        David Miller <davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a netfilter egress hook to allow filtering outbound AF_PACKETs
such as DHCP and to prepare for in-kernel NAT64/NAT46.

An earlier version of this series was applied by Pablo Neira Ayuso back
in March and subsequently reverted by Daniel Borkmann over performance
concerns.  I've now reworked the series following a discussion between
Daniel and Florian Westphal:

https://lore.kernel.org/netdev/20200318123315.GI979@breakpoint.cc/

Briefly, traffic control and netfilter handling is moved out of the
__dev_queue_xmit() hotpath into a noinline function which is dynamically
patched in using a static_key.  In that function, each of tc and nft are
patched in with additional static_keys.

Thus, if neither tc nor nft is used, performance improves compared to
the status quo (see measurements in patch [3/3]).  However if tc is
used, performance degrades a little due to the "noinline", the additional
outer static key and the added netfilter code.  That's kind of a bummer.
If anyone has ideas how to mitigate this performance degradation, please
come forward.

To test the new netfilter egress hook, apply this nft patch to add rules
from user space:

https://lore.kernel.org/netfilter-devel/d6b6896fdd8408e4ddbd66ab524709e5cf82ea32.1583929080.git.lukas@wunner.de/

Thanks!

Lukas Wunner (3):
  netfilter: Rename ingress hook include file
  netfilter: Generalize ingress hook
  netfilter: Introduce egress hook

 include/linux/netdevice.h         |   8 +++
 include/linux/netfilter_ingress.h |  58 -----------------
 include/linux/netfilter_netdev.h  | 102 ++++++++++++++++++++++++++++++
 include/linux/rtnetlink.h         |   2 +-
 include/uapi/linux/netfilter.h    |   1 +
 net/core/dev.c                    |  56 +++++++++++++---
 net/netfilter/Kconfig             |   8 +++
 net/netfilter/core.c              |  24 +++++--
 net/netfilter/nft_chain_filter.c  |   4 +-
 net/sched/Kconfig                 |   3 +
 10 files changed, 194 insertions(+), 72 deletions(-)
 delete mode 100644 include/linux/netfilter_ingress.h
 create mode 100644 include/linux/netfilter_netdev.h

-- 
2.27.0

