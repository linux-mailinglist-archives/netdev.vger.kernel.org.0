Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC775B08C3
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiIGPlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiIGPld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:41:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B60FA9C04;
        Wed,  7 Sep 2022 08:41:31 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oVxB6-00065E-Mv; Wed, 07 Sep 2022 17:41:24 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 0/8] netfilter: patches for net-next
Date:   Wed,  7 Sep 2022 17:41:02 +0200
Message-Id: <20220907154110.8898-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following set contains changes for your *net-next* tree:

- make conntrack ignore packets that are delayed (containing
  data already acked).  The current behaviour to flag them as INVALID
  causes more harm than good, let them pass so peer can send an
  immediate ACK for the most recent sequence number.
- make conntrack recognize when both peers have sent 'invalid' FINs:
  This helps cleaning out stale connections faster for those cases where
  conntrack is no longer in sync with the actual connection state.
- Now that DECNET is gone, we don't need to reserve space for DECNET
  related information.
- compact common 'find a free port number for the new inbound
  connection' code and move it to a helper, then cap number of tries
  the new helper will make until it gives up.
- replace various instances of strlcpy with strscpy, from Wolfram Sang.

----------------------------------------------------------------
The following changes since commit 016eb59012b576f5a7b7b415d757717dc8cb3c6b:

  Merge branch 'macsec-offload-mlx5' (2022-09-07 14:02:09 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git 

for you to fetch changes up to adda60cc2bb0fa46bed004070f29f90db96afbb3:

  netfilter: nat: avoid long-running port range loop (2022-09-07 16:46:04 +0200)

----------------------------------------------------------------
Florian Westphal (7):
      netfilter: conntrack: prepare tcp_in_window for ternary return value
      netfilter: conntrack: ignore overly delayed tcp packets
      netfilter: conntrack: remove unneeded indent level
      netfilter: conntrack: reduce timeout when receiving out-of-window fin or rst
      netfilter: remove NFPROTO_DECNET
      netfilter: nat: move repetitive nat port reserve loop to a helper
      netfilter: nat: avoid long-running port range loop

Wolfram Sang (1):
      netfilter: move from strlcpy with unused retval to strscpy

 include/net/netfilter/nf_nat_helper.h  |   1 +
 include/uapi/linux/netfilter.h         |   2 +
 net/ipv4/netfilter/nf_nat_h323.c       |  60 +-----
 net/netfilter/ipset/ip_set_core.c      |   4 +-
 net/netfilter/ipvs/ip_vs_ctl.c         |   8 +-
 net/netfilter/nf_conntrack_proto_tcp.c | 321 +++++++++++++++++++++------------
 net/netfilter/nf_log.c                 |   4 +-
 net/netfilter/nf_nat_amanda.c          |  14 +-
 net/netfilter/nf_nat_ftp.c             |  17 +-
 net/netfilter/nf_nat_helper.c          |  31 ++++
 net/netfilter/nf_nat_irc.c             |  16 +-
 net/netfilter/nf_nat_sip.c             |  14 +-
 net/netfilter/nf_tables_api.c          |   2 +-
 net/netfilter/nft_osf.c                |   2 +-
 net/netfilter/x_tables.c               |  20 +-
 net/netfilter/xt_RATEEST.c             |   2 +-
 16 files changed, 266 insertions(+), 252 deletions(-)

