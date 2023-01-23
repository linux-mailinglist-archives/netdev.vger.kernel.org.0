Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C16167894E
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 22:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbjAWVQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 16:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbjAWVQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 16:16:11 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE4C338005;
        Mon, 23 Jan 2023 13:16:09 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/2] Netfilter fixes for net
Date:   Mon, 23 Jan 2023 22:15:59 +0100
Message-Id: <20230123211601.292930-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix overlap detection in rbtree set backend: Detect overlap by going
   through the ordered list of valid tree nodes. To shorten the number of
   visited nodes in the list, this algorithm descends the tree to search
   for an existing element greater than the key value to insert that is
   greater than the new element.

2) Fix for the rbtree set garbage collector: Skip inactive and busy
   elements when checking for expired elements to avoid interference
   with an ongoing transaction from control plane.

This is a rather large fix coming at this stage of the 6.2-rc. Since
33c7aba0b4ff ("netfilter: nf_tables: do not set up extensions for end
interval"), bogus overlap errors in the rbtree set occur more frequently.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 71ab9c3e2253619136c31c89dbb2c69305cc89b1:

  net: fix UaF in netns ops registration error path (2023-01-20 18:51:18 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 5d235d6ce75c12a7fdee375eb211e4116f7ab01b:

  netfilter: nft_set_rbtree: skip elements in transaction from garbage collection (2023-01-23 21:38:33 +0100)

----------------------------------------------------------------
Pablo Neira Ayuso (2):
      netfilter: nft_set_rbtree: Switch to node list walk for overlap detection
      netfilter: nft_set_rbtree: skip elements in transaction from garbage collection

 net/netfilter/nft_set_rbtree.c | 332 +++++++++++++++++++++++++----------------
 1 file changed, 204 insertions(+), 128 deletions(-)
