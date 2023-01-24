Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9974967A17C
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 19:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbjAXSlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 13:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbjAXSk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 13:40:59 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 43E3449558;
        Tue, 24 Jan 2023 10:40:35 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/4] Netfilter fixes for net
Date:   Tue, 24 Jan 2023 19:39:29 +0100
Message-Id: <20230124183933.4752-1-pablo@netfilter.org>
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

1) Perform SCTP vtag verification for ABORT/SHUTDOWN_COMPLETE according
   to RFC 9260, Sect 8.5.1.

2) Fix infinite loop if SCTP chunk size is zero in for_each_sctp_chunk().
   And remove useless check in this macro too.

3) Revert DATA_SENT state in the SCTP tracker, this was applied in the
   previous merge window. Next patch in this series provides a more
   simple approach to multihoming support.

4) Unify HEARTBEAT_ACKED and ESTABLISHED states for SCTP multihoming
   support, use default ESTABLISHED of 210 seconds based on
   heartbeat timeout * maximum number of retransmission + round-trip timeout.
   Otherwise, SCTP conntrack entry that represents secondary paths
   remain stale in the table for up to 5 days.

This is a slightly large batch with fixes for the SCTP connection
tracking helper, all patches from Sriram Yagnaraman.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 208a21107ef0ae86c92078caf84ce80053e73f7a:

  Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue (2023-01-23 22:36:59 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to a44b7651489f26271ac784b70895e8a85d0cebf4:

  netfilter: conntrack: unify established states for SCTP paths (2023-01-24 09:52:52 +0100)

----------------------------------------------------------------
Sriram Yagnaraman (4):
      netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE
      netfilter: conntrack: fix bug in for_each_sctp_chunk
      Revert "netfilter: conntrack: add sctp DATA_SENT state"
      netfilter: conntrack: unify established states for SCTP paths

 Documentation/networking/nf_conntrack-sysctl.rst   |  10 +-
 include/uapi/linux/netfilter/nf_conntrack_sctp.h   |   3 +-
 include/uapi/linux/netfilter/nfnetlink_cttimeout.h |   3 +-
 net/netfilter/nf_conntrack_proto_sctp.c            | 170 +++++++++------------
 net/netfilter/nf_conntrack_standalone.c            |  16 --
 5 files changed, 77 insertions(+), 125 deletions(-)
