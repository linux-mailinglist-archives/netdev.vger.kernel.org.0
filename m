Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E491BA786
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgD0PNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:13:32 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46145 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727006AbgD0PNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:13:32 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 23A415C00BC;
        Mon, 27 Apr 2020 11:13:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 27 Apr 2020 11:13:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=54gTkCxyL2YJsVkVK
        mYHDAzlJ6VhXdVfTlIJz9Mp3KY=; b=MSduVb2SGXtnm5RLAa2sAWT/Uk87iKSDc
        BFheowj6DpPKVrcqK7so5yIar+MGJlSxwz75OaPd1vXzsn4L5nbe1UKsPxkXYuTd
        +Vgf2uLxfXZz4EMHCSohI91Eaxi0PhCQVMoznf93JqwTLQji90wENbQKUKjT4ixU
        KpR8QhRzwDeSo57YiF1nPjwsJoDqsLojAygVAfDxi1jQdmzRaxcNw7me72QJ9S9Q
        v5Z4F7x2Ul15wcWldTmE9d9MpE8kTV5Fq7A9drYTqcpGp0jje88vmhQsGF9VFuLC
        Heua7L6rjgsZREjqySdu5sI9ADGfu9Cuvbk1oRU45slBj2S4AX2oA==
X-ME-Sender: <xms:mvamXsgvVOypb1xYBQj_lDFab0SSa3Z6lppxfALvVBWtLkpEuEveeQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdho
    rhhg
X-ME-Proxy: <xmx:mvamXhX10IAAw8IyDz9v8eUVDkR3kJQimEojnw1nEA9HlWvoF4p_wg>
    <xmx:mvamXm1BhMnHWD1Fy0V7wg2zbtMcGpNwW_Vbn1cqTXAgcKu1bp6HCg>
    <xmx:mvamXvFoJ0--nplC3A05XoLjj2EzDyqAF8PxtPb0CTPgQIpkRXXcjg>
    <xmx:m_amXgwc7aN8yZd0CRuGvdl5hl9CLjaqZEAmNor4oSWBmfG4fToF2w>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id B51BE3280060;
        Mon, 27 Apr 2020 11:13:29 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/13] mlxsw: Rework matchall offloading plumbing
Date:   Mon, 27 Apr 2020 18:12:57 +0300
Message-Id: <20200427151310.3950411-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Jiri says:

Currently the matchall and flower are handled by registering separate
callbacks in mlxsw. That leads to faulty indication "in_hw_count 2" in
filter show command for every inserted flower filter. That happens
because matchall callback just blindly returns 0 for it and it is
wrongly accounted for as "the offloader".

I inspected different ways to fix this problem. The only clean solution
is to rework handling of matchall in mlxsw a bit. The driver newely
registers one callback for bound block which is called for both matchall
and flower filter insertions.

On the way, iron out the matchall code a bit, push it into a separate
file etc.

Jiri Pirko (13):
  mlxsw: spectrum_acl: Move block helpers into inline header functions
  mlxsw: spectrum: Rename acl_block to flow_block
  mlxsw: spectrum: Push flow_block related functions into a separate
    file
  mlxsw: spectrum: Push matchall bits into a separate file
  mlxsw: spectrum_acl: Use block variable in mlxsw_sp_acl_rule_del()
  mlxsw: spectrum_matchall: Pass mall_entry as arg to
    mlxsw_sp_mall_port_mirror_add()
  mlxsw: spectrum_matchall: Pass mall_entry as arg to
    mlxsw_sp_mall_port_sample_add()
  mlxsw: spectrum_matchall: Move ingress indication into mall_entry
  mlxsw: spectrum_matchall: Push per-port rule add/del into separate
    functions
  mlxsw: spectrum: Avoid copying sample values and use RCU pointer
    direcly instead
  mlxsw: spectrum_matchall: Process matchall events from the same cb as
    flower
  mlxsw: spectrum: Move flow offload binding into spectrum_flow.c
  selftests: forwarding: tc_actions.sh: add matchall mirror test

 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   1 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 463 +-----------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 167 ++++---
 .../mellanox/mlxsw/spectrum2_mr_tcam.c        |  14 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 207 +-------
 .../ethernet/mellanox/mlxsw/spectrum_flow.c   | 303 ++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |  24 +-
 .../mellanox/mlxsw/spectrum_matchall.c        | 278 +++++++++++
 .../selftests/net/forwarding/tc_actions.sh    |  26 +-
 9 files changed, 756 insertions(+), 727 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c

-- 
2.24.1

