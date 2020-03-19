Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC1518B853
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbgCSNsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:48:09 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40103 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726936AbgCSNsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 09:48:09 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9D67F5C0316;
        Thu, 19 Mar 2020 09:48:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 19 Mar 2020 09:48:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nrhaymNM42esqVfi1
        hAsjCzANfLvBHyUUv3EE2WuHtk=; b=I78CHuj0iapOcFXAByp+KEhVb8VOWBI95
        JS9ZX5WVvjajwx40mtj8rCDD6RKkiRhjKYmGtoobZewfhrRwg6JT/pfn5onOYMEI
        PMNZJXNaX70tUT7xrlRTTlCbSZv2ICDYFQ6/QG0mwLjFGK8hwvvjB9jIkoyU4Syo
        VyNsXtZTpF9Ok+lMHFpwnEGUpTJUWGcckpbVXZ1aUVG48pgx3Ss2WEN+DOW/21gh
        4l/NlSiuwDVzJ7xY94O4SfeNX58um78W4JnsGPdzVplcTUCYrRwSupBimLHd2Vqk
        uE9LCXbgQ5ZPWFPU1CPNgmP7rfAWawPBSyj4qP8ve3PiJREewxCJw==
X-ME-Sender: <xms:FXhzXqx1grAE9W7wfbZpO8STUndMDHIuwqNx0oAcfCXKc7jNs3ZdWg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefledgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppedutdelrdeiiedrudeftddrheenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdho
    rhhg
X-ME-Proxy: <xmx:FXhzXt_RmS0z-A-5wLr7-sqtA0KChhoKIfHWaGWW8xNMa0Ji6VQ7jw>
    <xmx:FXhzXiJMP77B9B3UWhTC3SVJJCv43raTeXTvdWJt76rsRkaDbcoDqw>
    <xmx:FXhzXh45hGUQ6RXL6pCbndVlmsNUcHtR7rpCBQWkbGDf6ve1_-tvzg>
    <xmx:FXhzXn2nLlWylNsYcOuz7URoQVE68LDXaTuREUF3dpgpQQz-n44cKA>
Received: from splinter.mtl.com (bzq-109-66-130-5.red.bezeqint.net [109.66.130.5])
        by mail.messagingengine.com (Postfix) with ESMTPA id A814130618B7;
        Thu, 19 Mar 2020 09:48:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/5] mlxsw: Offload TC action skbedit priority
Date:   Thu, 19 Mar 2020 15:47:19 +0200
Message-Id: <20200319134724.1036942-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Petr says:

The TC action "skbedit priority P" has the effect of assigning skbprio of P
to SKBs that it's applied on. In HW datapath of a switch, the corresponding
action is assignment of internal switch priority. Spectrum switches allow
setting of packet priority based on an ACL action, which is good match for
the skbedit priority gadget. This patchset therefore implements offloading
of this action to the Spectrum ACL engine.

After a bit of refactoring in patch #1, patch #2 extends the skbedit action
to support offloading of "priority" subcommand.

On mlxsw side, in patch #3, the QOS_ACTION flexible action is added, with
fields necessary for priority adjustment. In patch #4, "skbedit priority"
is connected to that action.

Patch #5 implements a new forwarding selftest, suitable for both SW- and
HW-datapath testing.

Petr Machata (5):
  net: tc_skbedit: Factor a helper out of is_tcf_skbedit_{mark, ptype}()
  net: tc_skbedit: Make the skbedit priority offloadable
  mlxsw: core: Add QOS_ACTION
  mlxsw: spectrum_flower: Offload FLOW_ACTION_PRIORITY
  selftests: forwarding: Add an skbedit priority selftest

 .../mellanox/mlxsw/core_acl_flex_actions.c    |  53 ++++++
 .../mellanox/mlxsw/core_acl_flex_actions.h    |   3 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   3 +
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |  17 ++
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |   4 +
 include/net/flow_offload.h                    |   2 +
 include/net/tc_act/tc_skbedit.h               |  41 +++--
 net/sched/cls_api.c                           |   3 +
 .../net/forwarding/skbedit_priority.sh        | 163 ++++++++++++++++++
 9 files changed, 275 insertions(+), 14 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/skbedit_priority.sh

-- 
2.24.1

