Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE2D33D65D
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbhCPPEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:04:13 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:32839 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237683AbhCPPEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:04:02 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7C3FB5C012B;
        Tue, 16 Mar 2021 11:04:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 16 Mar 2021 11:04:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=61mrUNAGOZuVkRwXR
        uuJGF9qXQ+WaR90kh4czlw5pCk=; b=Gh+6ffaaTg69q0Oatp9wxqZn0y1/B/0NZ
        PTiR6fBbeE4Ed8QFK4/dlOtgOqBse0/kuZDLBkrXqiGkA5JqPW5TmPiY7NuZEJcb
        v6qGmLpss9a2HzQKmtXJW9KN3RgjeE1+UpCHWaQdVkpuMTM4KbVz3dOtmN/KU8oi
        E2URAfOEHxMIxORGT+2uTx0YxSebQeIzQQl+zeCNTkahYO95LXPzHztx33r5i31z
        fh65vkVeUtBN81CSlQtjzrBQawlKtWZJqf+BBAPOUJRqrEHBi7XC4v2chvSEFT5x
        uQEW+e8xVvdl6H5ThAMwHEKcxeDLa2bgx3BB4pFpplAnIlqP5bRIA==
X-ME-Sender: <xms:38hQYHW1gLZLCq-7a_9JWJkACpe0NV1Ft9oPEBsADfAanFugNWNstA>
    <xme:38hQYPl8pl2UkO8am0gYj7PSzV5o-r7yxNzdpiVWmRj7eNDkhXxte_ngOrf2fv4qq
    7ReAwejo2bCYSM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefvddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrgeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:38hQYDZEF4_pET_qmT352_x9Jt2PMtmErSgAloxFcUoAL7B_LcuV4A>
    <xmx:38hQYCX7284TX8edjnvuP7s5fs0ljrFALpSchya0suOqeg5LS_ncAQ>
    <xmx:38hQYBnxrI87knKqi0OHoxuHCh4d6PemntdpJ-rbq1tCEQ6kiauCYg>
    <xmx:4MhQYEuT2FXZy24RzJgkXJdFn8c_ljbOv5gyQGOFF1xrfM-quIHZIw>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 25D6A1080066;
        Tue, 16 Mar 2021 11:03:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/10] mlxsw: Add support for egress and policy-based sampling
Date:   Tue, 16 Mar 2021 17:02:53 +0200
Message-Id: <20210316150303.2868588-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

So far mlxsw only supported ingress sampling using matchall classifier.
This series adds support for egress sampling and policy-based sampling
using flower classifier on Spectrum-2 and newer ASICs. As such, it is
now possible to issue these commands:

 # tc filter add dev swp1 egress pref 1 proto all matchall action sample rate 100 group 1

 # tc filter add dev swp2 ingress pref 1 proto ip flower dst_ip 198.51.100.1 action sample rate 100 group 2

When performing egress sampling (using either matchall or flower) the
ASIC is able to report the end-to-end latency which is passed to the
psample module.

Series overview:

Patches #1-#3 are preparations without any functional changes

Patch #4 generalizes the idea of sampling triggers and creates a hash
table to track active sampling triggers in preparation for egress and
policy-based triggers. The motivation is explained in the changelog

Patch #5 flips mlxsw to start using this hash table instead of storing
ingress sampling triggers as an attribute of the sampled port

Patch #6 finally adds support for egress sampling using matchall
classifier

Patches #7-#8 add support for policy-based sampling using flower
classifier

Patches #9 extends the mlxsw sampling selftest to cover the new triggers

Patch #10 makes sure that egress sampling configuration only fails on
Spectrum-1

Ido Schimmel (10):
  mlxsw: spectrum_matchall: Propagate extack further
  mlxsw: spectrum_matchall: Push sampling checks to per-ASIC operations
  mlxsw: spectrum_matchall: Pass matchall entry to sampling operations
  mlxsw: spectrum: Track sampling triggers in a hash table
  mlxsw: spectrum: Start using sampling triggers hash table
  mlxsw: spectrum_matchall: Add support for egress sampling
  mlxsw: core_acl_flex_actions: Add mirror sampler action
  mlxsw: spectrum_acl: Offload FLOW_ACTION_SAMPLE
  selftests: mlxsw: Add tc sample tests for new triggers
  selftests: mlxsw: Test egress sampling limitation on Spectrum-1 only

 .../mellanox/mlxsw/core_acl_flex_actions.c    | 131 ++++++++++++++
 .../mellanox/mlxsw/core_acl_flex_actions.h    |  11 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 148 ++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  52 +++++-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |  25 +++
 .../mlxsw/spectrum_acl_flex_actions.c         |  83 +++++++++
 .../ethernet/mellanox/mlxsw/spectrum_flow.c   |   2 +-
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |  18 ++
 .../mellanox/mlxsw/spectrum_matchall.c        | 167 +++++++++++-------
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 111 +++++++++++-
 .../drivers/net/mlxsw/tc_restrictions.sh      |   4 +-
 .../selftests/drivers/net/mlxsw/tc_sample.sh  | 135 ++++++++++++++
 12 files changed, 808 insertions(+), 79 deletions(-)

-- 
2.29.2

