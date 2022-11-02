Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA8A616D09
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 19:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiKBSrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 14:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbiKBSrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 14:47:06 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 592802F672;
        Wed,  2 Nov 2022 11:47:05 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/7] Netfilter/IPVS fixes for net
Date:   Wed,  2 Nov 2022 19:46:52 +0100
Message-Id: <20221102184659.2502-1-pablo@netfilter.org>
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

The following patchset contains Netfilter/IPVS fixes for net:

1) netlink socket notifier might win race to release objects that are
   already pending to be released via commit release path, reported by
   syzbot.

2) No need to postpone flow rule release to commit release path, this
   triggered the syzbot report, complementary fix to previous patch.

3) Use explicit signed chars in IPVS to unbreak arm, from Jason A. Donenfeld.

4) Missing check for proc entry creation failure in IPVS, from Zhengchao Shao.

5) Incorrect error path handling when BPF NAT fails to register, from
   Chen Zhongjin.

6) Prevent huge memory allocation in ipset hash types, from Jozsef Kadlecsik.

Except the incorrect BPF NAT error path which is broken in 6.1-rc, anything
else has been broken for several releases.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 363a5328f4b0517e59572118ccfb7c626d81dca9:

  net: tun: fix bugs for oversize packet when napi frags enabled (2022-10-31 20:04:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 510841da1fcc16f702440ab58ef0b4d82a9056b7:

  netfilter: ipset: enforce documented limit to prevent allocating huge memory (2022-11-02 19:22:23 +0100)

----------------------------------------------------------------
Chen Zhongjin (1):
      netfilter: nf_nat: Fix possible memory leak in nf_nat_init()

Jason A. Donenfeld (1):
      ipvs: use explicitly signed chars

Jozsef Kadlecsik (1):
      netfilter: ipset: enforce documented limit to prevent allocating huge memory

Pablo Neira Ayuso (2):
      netfilter: nf_tables: netlink notifier might race to release objects
      netfilter: nf_tables: release flow rule object from commit path

Zhengchao Shao (2):
      ipvs: fix WARNING in __ip_vs_cleanup_batch()
      ipvs: fix WARNING in ip_vs_app_net_cleanup()

 net/netfilter/ipset/ip_set_hash_gen.h | 30 ++++++------------------------
 net/netfilter/ipvs/ip_vs_app.c        | 10 ++++++++--
 net/netfilter/ipvs/ip_vs_conn.c       | 30 +++++++++++++++++++++++-------
 net/netfilter/nf_nat_core.c           | 11 ++++++++++-
 net/netfilter/nf_tables_api.c         |  8 +++++---
 5 files changed, 52 insertions(+), 37 deletions(-)
