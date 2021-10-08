Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B164271ED
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 22:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242017AbhJHURt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 16:17:49 -0400
Received: from mailout1.hostsharing.net ([83.223.95.204]:56909 "EHLO
        mailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbhJHURs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 16:17:48 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Oct 2021 16:17:47 EDT
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id 8F62B101903A0;
        Fri,  8 Oct 2021 22:08:16 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 5E992601498D;
        Fri,  8 Oct 2021 22:08:16 +0200 (CEST)
X-Mailbox-Line: From 732e7c0a386a0a4a22201db433122dbf82d14808 Mon Sep 17 00:00:00 2001
Message-Id: <cover.1633693519.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Fri, 8 Oct 2021 22:06:00 +0200
Subject: [PATCH nf-next v6 0/4] Netfilter egress hook
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        "Laura Garcia Liebana" <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "Willem de Bruijn" <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netfilter egress hook, 6th iteration

Changes:

* Perform netfilter egress classifying before tc egress classifying
  to achieve reverse order vis-a-vis ingress datapath.

* Avoid layering violations by way of new skb->nf_skip_egress flag.

* Add egress support to new nfnetlink_hook.c.


Link to previous version v5 (posted by Pablo):
https://lore.kernel.org/netdev/20210928095538.114207-1-pablo@netfilter.org/

Link to previous version v4:
https://lore.kernel.org/netdev/cover.1611304190.git.lukas@wunner.de/


Lukas Wunner (3):
  netfilter: Rename ingress hook include file
  netfilter: Generalize ingress hook include file
  netfilter: Introduce egress hook

Pablo Neira Ayuso (1):
  af_packet: Introduce egress hook

 drivers/net/ifb.c                 |   3 +
 include/linux/netdevice.h         |   4 +
 include/linux/netfilter_ingress.h |  58 ------------
 include/linux/netfilter_netdev.h  | 146 ++++++++++++++++++++++++++++++
 include/linux/skbuff.h            |   4 +
 include/uapi/linux/netfilter.h    |   1 +
 net/core/dev.c                    |  19 +++-
 net/netfilter/Kconfig             |  11 +++
 net/netfilter/core.c              |  34 ++++++-
 net/netfilter/nfnetlink_hook.c    |  16 +++-
 net/netfilter/nft_chain_filter.c  |   4 +-
 net/packet/af_packet.c            |  35 +++++++
 12 files changed, 265 insertions(+), 70 deletions(-)
 delete mode 100644 include/linux/netfilter_ingress.h
 create mode 100644 include/linux/netfilter_netdev.h

-- 
2.31.1

