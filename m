Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832B02029A8
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 10:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbgFUIev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 04:34:51 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56737 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729502AbgFUIev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 04:34:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 30BA55C00E6;
        Sun, 21 Jun 2020 04:34:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 21 Jun 2020 04:34:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=io9bYRzgQJ7QPqEdx
        +/2q93yjfn6oB+PVvcLgK8K6rU=; b=QgYK7ZWWBqvHiyMcTj/qdDavmFd0PdQi+
        P91gX1Y+pqnAJB65hDiATXWZUbYIYi/0/yn4bUikmMEdlYE869kaU9ERUY4J5gyx
        rkdy0AkEAUdi1Gp9pMS7fNdr9g9X7vwDWEAIVC1taRjRoVYmCYJNvRN+HOGp/11a
        xu59JapJnl7O+WIjHh5Ti8gBgQolINm+XgiqegzuYYeFVGD+eWoFBmjXGygNEpLm
        vMO2Z7pFjUKtvlIn+OKC6xHyp2H4e8FHON/cRocs1EtbKt5KeTVCl0HCQiYYMDlF
        WBrUWKBxHbz9q5w6gTlspUO8rBqYnybx/a1f6U2AscNTN3s6FNj1w==
X-ME-Sender: <xms:qRvvXlO85G4p_nVQPIOz8Sc6govT5TCbs96glsrW0_3m28c9wQiUeg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudektddgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppedutdelrdeijedrkedruddvleenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:qRvvXn_dEJfzpp4iCRmz_nuM8ZEj4r7UwLKDv1h2vP6J_8zyE6-I0g>
    <xmx:qRvvXkTBosP0yjm-qsdonNyoQgSl9DnglbnLT_6BXh4R6jRcBZob8A>
    <xmx:qRvvXhvOgu3BSzmia_T5WuILwa3rcjk7tmjC1UvWwXAq-BTlXU41aQ>
    <xmx:qhvvXupYu6yJNd73ECs1iwZCJUgvBWwuA-_5z4svv64IOTXvZqhDwA>
Received: from splinter.mtl.com (bzq-109-67-8-129.red.bezeqint.net [109.67.8.129])
        by mail.messagingengine.com (Postfix) with ESMTPA id A71B93066D7A;
        Sun, 21 Jun 2020 04:34:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/4] mlxsw: Offload TC action pedit munge tcp/udp sport/dport
Date:   Sun, 21 Jun 2020 11:34:32 +0300
Message-Id: <20200621083436.476806-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Petr says:

On Spectrum-2 and Spectrum-3, it is possible to overwrite L4 port number of
a TCP or UDP packet in the ACL engine. That corresponds to the pedit munges
of tcp and udp sport resp. dport fields. Offload these munges on the
systems where they are supported.

The current offloading code assumes that all systems support the same set
of fields. This now changes, so in patch #1 first split handling of pedit
munges by chip type. The analysis of which packet field a given munge
describes is kept generic.

Patch #2 introduces the new flexible action fields. Patch #3 then adds the
new pedit fields, and dispatches on them on Spectrum>1.

Patch #4 adds a forwarding selftest for pedit dsfield, applicable to SW as
well as HW datapaths.

Petr Machata (4):
  mlxsw: spectrum: Split handling of pedit mangle by chip type
  mlxsw: core_acl_flex_actions: Add L4_PORT_ACTION
  mlxsw: spectrum_acl: Support FLOW_ACTION_MANGLE for TCP, UDP ports
  selftests: forwarding: Add a test for pedit munge tcp, udp sport,
    dport

 .../mellanox/mlxsw/core_acl_flex_actions.c    |  51 +++++
 .../mellanox/mlxsw/core_acl_flex_actions.h    |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   3 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  13 ++
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |  75 ++++++-
 .../selftests/net/forwarding/pedit_l4port.sh  | 198 ++++++++++++++++++
 6 files changed, 335 insertions(+), 7 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/pedit_l4port.sh

-- 
2.26.2

