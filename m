Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E841634941
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiKVV2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:28:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiKVV2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:28:18 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1656022529;
        Tue, 22 Nov 2022 13:28:18 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Tue, 22 Nov 2022 22:28:11 +0100
Message-Id: <20221122212814.63177-1-pablo@netfilter.org>
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

The following patch contains another round of Netfilter fixes for net:

1) Fix regression in ipset hash:ip with IPv4 range, from Vishwanath Pai.
   This is fixing up a bug introduced in the 6.0 release.

2) The "netfilter: ipset: enforce documented limit to prevent allocating
   huge memory" patch contained a wrong condition which makes impossible to
   add up to 64 clashing elements to a hash:net,iface type of set while it
   is the documented feature of the set type. The patch fixes the condition
   and thus makes possible to add the elements while keeps preventing
   allocating huge memory, from Jozsef Kadlecsik. This has been broken
   for several releases.

3) Missing locking when updating the flow block list which might lead
   a reader to crash. This has been broken since the introduction of the
   flowtable hardware offload support.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit badbda1a01860c80c6ab60f329ef46c713653a27:

  octeontx2-af: cn10k: mcs: Fix copy and paste bug in mcs_bbe_intr_handler() (2022-11-21 13:04:28 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to bcd9e3c1656d0f7dd9743598c65c3ae24efb38d0:

  netfilter: flowtable_offload: add missing locking (2022-11-22 22:17:12 +0100)

----------------------------------------------------------------
Felix Fietkau (1):
      netfilter: flowtable_offload: add missing locking

Jozsef Kadlecsik (1):
      netfilter: ipset: restore allowing 64 clashing elements in hash:net,iface

Vishwanath Pai (1):
      netfilter: ipset: regression in ip_set_hash_ip.c

 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 net/netfilter/ipset/ip_set_hash_ip.c  | 8 +++-----
 net/netfilter/nf_flow_table_offload.c | 4 ++++
 3 files changed, 8 insertions(+), 6 deletions(-)
