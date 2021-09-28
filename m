Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0CB41AC67
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 11:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240051AbhI1J51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 05:57:27 -0400
Received: from mail.netfilter.org ([217.70.188.207]:56906 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239872AbhI1J5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 05:57:24 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6878763EA4;
        Tue, 28 Sep 2021 11:54:19 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        lukas@wunner.de, daniel@iogearbox.net, kadlec@netfilter.org,
        fw@strlen.de, ast@kernel.org, edumazet@google.com, tgraf@suug.ch,
        nevola@gmail.com, john.fastabend@gmail.com, willemb@google.com
Subject: [PATCH nf-next v5 0/6] Netfilter egress hook
Date:   Tue, 28 Sep 2021 11:55:32 +0200
Message-Id: <20210928095538.114207-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset v5 that re-adds the Netfilter egress:

1) Rename linux/netfilter_ingress.h to linux/netfilter_netdev.h
   from Lukas Wunner.

2) Generalize ingress hook file to accomodate egress support,
   from Lukas Wunner.

3) Modularize Netfilter ingress hook into nf_tables_netdev: Daniel
   Borkmann is requesting for a mechanism to allow to blacklist
   Netfilter, this allows users to blacklist this new module that
   includes ingress chain and the new egress chain for the netdev
   family. There is no other in-tree user of the ingress and egress
   hooks than this which might interfer with his matter.

4) Place the egress hook again before the tc egress hook as requested
   by Daniel Borkmann. Patch to add egress hook from Lukas Wunner.
   The Netfilter egress hook remains behind the static key, if unused
   performance degradation is negligible.

5) Add netfilter egress handling to af_packet.

Arguably, distributors might decide to compile nf_tables_netdev
built-in. Traditionally, distributors have compiled their kernels using
the default configuration that Netfilter Kconfig provides (ie. use
modules whenever possible). In any case, I consider that distributor
policy is out of scope in this discussion, providing a mechanism to
allow Daniel to prevent Netfilter ingress and egress chains to be loaded
should be sufficient IMHO.

Joint work with Lukas Wunner.

Please review, thanks.

Lukas Wunner (3):
  netfilter: Rename ingress hook include file
  netfilter: Generalize ingress hook include file
  netfilter: Introduce egress hook

Pablo Neira Ayuso (3):
  netfilter: nf_tables: move netdev ingress filter chain to nf_tables_netdev.c
  af_packet: Introduce egress hook
  netfilter: nf_tables: add egress support

 include/linux/netdevice.h         |   4 +
 include/linux/netfilter_ingress.h |  58 ------------
 include/linux/netfilter_netdev.h  | 112 ++++++++++++++++++++++
 include/uapi/linux/netfilter.h    |   1 +
 net/core/dev.c                    |  15 ++-
 net/netfilter/Kconfig             |  10 +-
 net/netfilter/Makefile            |   1 +
 net/netfilter/core.c              |  34 ++++++-
 net/netfilter/nf_tables_api.c     |   7 +-
 net/netfilter/nf_tables_netdev.c  | 150 ++++++++++++++++++++++++++++++
 net/netfilter/nft_chain_filter.c  | 143 ----------------------------
 net/packet/af_packet.c            |  35 +++++++
 12 files changed, 358 insertions(+), 212 deletions(-)
 delete mode 100644 include/linux/netfilter_ingress.h
 create mode 100644 include/linux/netfilter_netdev.h
 create mode 100644 net/netfilter/nf_tables_netdev.c

-- 
2.30.2

