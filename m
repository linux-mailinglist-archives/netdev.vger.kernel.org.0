Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9127B388D93
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 14:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353340AbhESMKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 08:10:49 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41247 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353324AbhESMKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 08:10:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1B5C75C013E;
        Wed, 19 May 2021 08:09:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 May 2021 08:09:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PhFgUzzdq6cxS7O3K
        Fs/EFtFtPq+QsDTbyeOUEgfHpQ=; b=l1T4eMMQ27kb1u6cA8/UmljrwIndeks74
        3s74zWBGyY+UmYMCC6mJtN0Quwn2OIVHmJKILNvH6h/A2Kzn5TI1SGQ7Q9VZiBDb
        3r9hIO+dTqd9CBylNXYaTau4cAMLf2bfm3h1ZR7509foIJ6vFAtI1k0Bpae2+Pg4
        mTTsGk/Dp/fusfVutKAva+YlIBdcVURDq3seBTVo7tqP6zFBW/aHi8rVHkBZlNpS
        lqIznw4C82WpoUh5VQSs7m/aQ/znQjBO6uIUXClqrgq+ScXphbgJVheZxRaw7lJw
        pXDIaP4PbClWv7Rjjm1dv595vQOzTbRjpzmEs59J87dOuwzHN+iKA==
X-ME-Sender: <xms:-P-kYOQ9rKA6DluS0Hl_1ZnxMyL5kuB2i73Gf9A6aUi7jWUrbWWgqw>
    <xme:-P-kYDxOFzeP5hCZVQr7aqsF4TxoC_vqHVkdOBJrtnBkFkaiIURjSCKi9sXhrT7Zf
    DbrfQj7mptYKFQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeiledggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrudekjeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:-P-kYL2P5oMtAj46WSae_XbsFUMIFMhaI-IN9IXowc_QTXVGymMn6g>
    <xmx:-P-kYKBtbvsTxObdEIeeEhYEEyn1eCcRLQiza8T3VQERRNnsOfuV4A>
    <xmx:-P-kYHgxRlATbrig_8dJJFojaWy3U3kEda48zP-HEsJkYW8O6diLfQ>
    <xmx:-f-kYHeCRTXG8rjWmmmzHz_HLRFZCig-EMt4PgvhQ9IxpzaeKveatw>
Received: from shredder.mellanox.com (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 19 May 2021 08:09:26 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/7] mlxsw: Add support for new multipath hash policies
Date:   Wed, 19 May 2021 15:08:17 +0300
Message-Id: <20210519120824.302191-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset adds support for two new multipath hash policies in mlxsw.

Patch #1 emits net events whenever the
net.ipv{4,6}.fib_multipath_hash_fields sysctls are changed. This allows
listeners to react to changes in the packet fields used for the
computation of the multipath hash.

Patches #2-#3 refactor the code in mlxsw that is responsible for the
configuration of the multipath hash, so that it will be easier to extend
for the two new policies.

Patch #4 adds the register fields required to support the new policies.

Patch #5-#7 add support for inner layer 3 and custom multipath hash
policies.

Tested using following forwarding selftests:

* custom_multipath_hash.sh
* gre_custom_multipath_hash.sh
* gre_inner_v4_multipath.sh
* gre_inner_v6_multipath.sh

Ido Schimmel (7):
  net: Add notifications when multipath hash field change
  mlxsw: spectrum_router: Replace if statement with a switch statement
  mlxsw: spectrum_router: Move multipath hash configuration to a bitmap
  mlxsw: reg: Add inner packet fields to RECRv2 register
  mlxsw: spectrum_outer: Factor out helper for common outer fields
  mlxsw: spectrum_router: Add support for inner layer 3 multipath hash
    policy
  mlxsw: spectrum_router: Add support for custom multipath hash policy

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  84 +++---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 239 +++++++++++++++---
 net/ipv4/sysctl_net_ipv4.c                    |  18 +-
 net/ipv6/sysctl_net_ipv6.c                    |  18 +-
 4 files changed, 279 insertions(+), 80 deletions(-)

-- 
2.31.1

