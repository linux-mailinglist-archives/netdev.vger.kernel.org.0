Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757662C4879
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 20:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgKYTft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 14:35:49 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33171 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728521AbgKYTft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 14:35:49 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2DE1D5C00AE;
        Wed, 25 Nov 2020 14:35:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 25 Nov 2020 14:35:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=s16efWSTMo+3BJ/WD
        RHFy0XCrhX7bNmXLxnXdQhiPlg=; b=UEFw0Y/S+agc8Imm71uH7NQR6Qq/1u43j
        taUH0V9Q1j25DZ8U1BPIBY4rEiUZsu7mXNYengjN5IAwHn4OPyS3jHUQdZ56aj4P
        peX9Hc02kTK+4NCsZ6NGYr82YZT7MIlR8aZUqsbBigqGwpsUsEX6Wqt33pCyJsKy
        6Vabw5JwlnKNnAUek/qTYg/vECCaDFmS8nQE3uzAJghwvrsR/Uw4qMN0lJh57dSb
        kTOscgBtbnOUeC9lQv33ZJPzhkruOCioMjJxetXqtLawSbQGdMzoRB0RXKOgOQz8
        KbXgaSVLHhQoDZ1BhPAyyTnBbhfC9i2thZOWSUq3zTNyUnDZiYcyw==
X-ME-Sender: <xms:E7K-X-0Nvslg28Hv0O79mtwHJqm4H_KWI13yTe26JBIh-K1BsWSzeA>
    <xme:E7K-XxH44ErhXZ8aArU6MzDBtsJdObQ4TnrySNPsTFXIjSPdcvey6I6n7GOzsSzwb
    E6VhdT7bxOklaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehtddguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheegrddugeej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:E7K-X249tWXBWLyM2cdjsmeUafivyJ2qVZYV7ulgDIG6TFI0eXy_pQ>
    <xmx:E7K-X_1np22sMlo4X83bvAODc0TTh1WdN9PeDnMOWylQHtWbAXqGww>
    <xmx:E7K-XxFZNJfILWYYHr4-4Z80Dz5MrqM3zui-nJDTQ8wpwZZslVZbFw>
    <xmx:FLK-XxDXuRBJP79SGRPLEDzwtvTt4vWc2d97PqgekdloRgo9iF4bkQ>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 980343280063;
        Wed, 25 Nov 2020 14:35:46 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/5] mlxsw: Update adjacency index more efficiently
Date:   Wed, 25 Nov 2020 21:35:00 +0200
Message-Id: <20201125193505.1052466-1-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The device supports an operation that allows the driver to issue one
request to update the adjacency index for all the routes in a given
virtual router (VR) from old index and size to new ones. This is useful
in case the configuration of a certain nexthop group is updated and its
adjacency index changes.

Currently, the driver does not use this operation in an efficient
manner. It iterates over all the routes using the nexthop group and
issues an update request for the VR if it is not the same as the
previous VR.

Instead, this patch set tracks the VRs in which the nexthop group is
used and issues one request for each VR.

Example:

8k IPv6 routes were added in an alternating manner to two VRFs. All the
routes are using the same nexthop object ('nhid 1').

Before:

# perf stat -e devlink:devlink_hwmsg --filter='incoming==0' -- ip nexthop replace id 1 via 2001:db8:1::2 dev swp3

 Performance counter stats for 'ip nexthop replace id 1 via 2001:db8:1::2 dev swp3':

            16,385      devlink:devlink_hwmsg

       4.255933213 seconds time elapsed

       0.000000000 seconds user
       0.666923000 seconds sys

Number of EMAD transactions corresponds to number of routes using the
nexthop group.

After:

# perf stat -e devlink:devlink_hwmsg --filter='incoming==0' -- ip nexthop replace id 1 via 2001:db8:1::2 dev swp3

 Performance counter stats for 'ip nexthop replace id 1 via 2001:db8:1::2 dev swp3':

                 3      devlink:devlink_hwmsg

       0.077655094 seconds time elapsed

       0.000000000 seconds user
       0.076698000 seconds sys

Number of EMAD transactions corresponds to number of VRFs / VRs.

Patch set overview:

Patch #1 is a fix for a bug introduced in previous submission. Detected
by Coverity.

Patches #2 and #3 are preparations.

Patch #4 tracks the VRs a nexthop group is member of.

Patch #5 uses the membership tracking from the previous patch to issue
one update request per each VR.

Ido Schimmel (5):
  mlxsw: spectrum_router: Fix error handling issue
  mlxsw: spectrum_router: Pass virtual router parameters directly
    instead of pointer
  mlxsw: spectrum_router: Rollback virtual router adjacency pointer
    update
  mlxsw: spectrum_router: Track nexthop group virtual router membership
  mlxsw: spectrum_router: Update adjacency index more efficiently

 .../ethernet/mellanox/mlxsw/spectrum_router.c | 203 ++++++++++++++++--
 1 file changed, 186 insertions(+), 17 deletions(-)

-- 
2.28.0

