Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BBE52C5AA
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 23:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238954AbiERVkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 17:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243268AbiERVjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 17:39:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32135246DB5;
        Wed, 18 May 2022 14:38:45 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net 0/7] Netfilter fixes for net
Date:   Wed, 18 May 2022 23:38:34 +0200
Message-Id: <20220518213841.359653-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset contains Netfilter fixes for net:

1) Reduce number of hardware offload retries from flowtable datapath
   which might hog system with retries, from Felix Fietkau.

2) Skip neighbour lookup for PPPoE device, fill_forward_path() already
   provides this and set on destination address from fill_forward_path for
   PPPoE device, also from Felix.

4) When combining PPPoE on top of a VLAN device, set info->outdev to the
   PPPoE device so software offload works, from Felix.

5) Fix TCP teardown flowtable state, races with conntrack gc might result
   in resetting the state to ESTABLISHED and the time to one day. Joint
   work with Oz Shlomo and Sven Auhagen.

6) Call dst_check() from flowtable datapath to check if dst is stale
   instead of doing it from garbage collector path.

7) Disable register tracking infrastructure, either user-space or
   kernel need to pre-fetch keys inconditionally, otherwise register
   tracking assumes data is already available in register that might
   not well be there, leading to incorrect reductions.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit f3f19f939c11925dadd3f4776f99f8c278a7017b:

  Merge tag 'net-5.18-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-05-12 11:51:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 9e539c5b6d9c5b996e45105921ee9dd955c0f535:

  netfilter: nf_tables: disable expression reduction infra (2022-05-18 17:34:26 +0200)

----------------------------------------------------------------
Felix Fietkau (4):
      netfilter: flowtable: fix excessive hw offload attempts after failure
      netfilter: nft_flow_offload: skip dst neigh lookup for ppp devices
      net: fix dev_fill_forward_path with pppoe + bridge
      netfilter: nft_flow_offload: fix offload with pppoe + vlan

Pablo Neira Ayuso (2):
      netfilter: flowtable: fix TCP flow teardown
      netfilter: nf_tables: disable expression reduction infra

Ritaro Takenaka (1):
      netfilter: flowtable: move dst_check to packet path

 drivers/net/ppp/pppoe.c            |  1 +
 include/linux/netdevice.h          |  2 +-
 net/core/dev.c                     |  2 +-
 net/netfilter/nf_flow_table_core.c | 60 +++++++-------------------------------
 net/netfilter/nf_flow_table_ip.c   | 19 ++++++++++++
 net/netfilter/nf_tables_api.c      | 11 +------
 net/netfilter/nft_flow_offload.c   | 28 +++++++++++-------
 7 files changed, 51 insertions(+), 72 deletions(-)
