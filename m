Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7446058E29A
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 00:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiHIWGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 18:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiHIWFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 18:05:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCA8313F94;
        Tue,  9 Aug 2022 15:05:40 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/8] Netfilter fixes for net
Date:   Wed, 10 Aug 2022 00:05:24 +0200
Message-Id: <20220809220532.130240-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Harden set element field checks to avoid out-of-bound memory access,
   this patch also fixes the type of issue described in 7e6bc1f6cabc
   ("netfilter: nf_tables: stricter validation of element data") in a
   broader way.

2) Patches to restrict the chain, set, and rule id lookup in the
   transaction to the corresponding top-level table, patches from
   Thadeu Lima de Souza Cascardo.

3) Fix incorrect comment in ip6t_LOG.h

4) nft_data_init() performs upfront validation of the expected data.
   struct nft_data_desc is used to describe the expected data to be
   received from userspace. The .size field represents the maximum size
   that can be stored, for bound checks. Then, .len is an input/output field
   which stores the expected length as input (this is optional, to restrict
   the checks), as output it stores the real length received from userspace
   (if it was not specified as input). This patch comes in response to
   7e6bc1f6cabc ("netfilter: nf_tables: stricter validation of element data")
   to address this type of issue in a more generic way by avoid opencoded
   data validation. Next patch requires this as a dependency.

5) Disallow jump to implicit chain from set element, this configuration
   is invalid. Only allow jump to chain via immediate expression is
   supported at this stage.

6) Fix possible null-pointer derefence in the error path of table updates,
   if memory allocation of the transaction fails. From Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit b8c3bf0ed2edf2deaedba5f0bf0bb54c76dee71d:

  Merge tag 'for-net-2022-08-08' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth (2022-08-08 20:59:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 580077855a40741cf511766129702d97ff02f4d9:

  netfilter: nf_tables: fix null deref due to zeroed list head (2022-08-09 20:13:30 +0200)

----------------------------------------------------------------
Christophe JAILLET (1):
      netfilter: ip6t_LOG: Fix a typo in a comment

Florian Westphal (1):
      netfilter: nf_tables: fix null deref due to zeroed list head

Pablo Neira Ayuso (3):
      netfilter: nf_tables: validate variable length element extension
      netfilter: nf_tables: upfront validation of data via nft_data_init()
      netfilter: nf_tables: disallow jump to implicit chain from set element

Thadeu Lima de Souza Cascardo (3):
      netfilter: nf_tables: do not allow SET_ID to refer to another table
      netfilter: nf_tables: do not allow CHAIN_ID to refer to another table
      netfilter: nf_tables: do not allow RULE_ID to refer to another chain

 include/net/netfilter/nf_tables.h            |  13 +-
 include/uapi/linux/netfilter_ipv6/ip6t_LOG.h |   2 +-
 net/netfilter/nf_tables_api.c                | 184 ++++++++++++++++++---------
 net/netfilter/nft_bitwise.c                  |  66 +++++-----
 net/netfilter/nft_cmp.c                      |  44 +++----
 net/netfilter/nft_dynset.c                   |   2 +-
 net/netfilter/nft_immediate.c                |  22 +++-
 net/netfilter/nft_range.c                    |  27 ++--
 8 files changed, 222 insertions(+), 138 deletions(-)
