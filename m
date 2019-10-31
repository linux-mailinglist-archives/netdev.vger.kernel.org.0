Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 199F5EACB1
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbfJaJmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:42:44 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36223 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726864AbfJaJmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:42:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0644921EB2;
        Thu, 31 Oct 2019 05:42:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 31 Oct 2019 05:42:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=D1mIi9T5pjcHqafiK
        Jbgm8nE/n2YoJ42/kkUqPgyIBY=; b=AtFC43QZdHOT8OCVgGghi0PJ8iJAqjaEe
        fxUPyyLy3a37U0eFfeRFU76t0saWGjNKGtblKlLTnUBJRli6HyFjX4Pgc9ZG6KBR
        bjR/j3PCMFqmPoUE5sPvcTzauHpXuIDvPYWI5db9jQ0hTB1QVkLP2HJLwwwcDiAl
        zwR+/XZwksoEyceb78suLqrLaQNYjYmqMOhu0CpE8U7kCuAiy1b2ilidAV/g3/HQ
        rZLQ9av0iwtDJocKkvTH8NZCTCpJu/BYErdtXd4LPa3EqzZh1co01lO83RGI1GVz
        AyHC4xYvx4gQfIwq54qLdF2vh9EUIQXiMPcTl33d3n6qSSNiD9LTw==
X-ME-Sender: <xms:kqy6XSiGHy-BOYEXc62DSOxe6GtgdJKzVX9SvUKveMJ5B1X8z4Y-Ow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddthedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:kqy6XZkYetVNa77KodqekGDkIVBcN94hUk7w3g0s_S_zTHqqx0jrZg>
    <xmx:kqy6XbxMBQd3CzJNZZGZUKZCqJ3TH8U44jB6hF5WPEzZJDzHi8wbUA>
    <xmx:kqy6XUvmcTeXarTufACbBj8y8VoERFxrAMyQUi2sKRZL2Ol01qidHg>
    <xmx:kqy6XZofAXS8HMjQLBFu1Gm2Phy6kPBcFuKNhQZoJpYkFqJCo-czyA>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DEDEF80066;
        Thu, 31 Oct 2019 05:42:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/16] mlxsw: Make port split code more generic
Date:   Thu, 31 Oct 2019 11:42:05 +0200
Message-Id: <20191031094221.17526-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Jiri says:

Currently, we assume some limitations and constant values which are not
applicable for Spectrum-3 which has 8 lanes ports (instead of previous 4
lanes).

This patch does 2 things:

1) Generalizes the code to not use constants so it can work for 4, 8 and
   possibly 16 lanes.

2) Enforces some assumptions we had in the code but did not check.

Jiri Pirko (16):
  mlxsw: reg: Extend PMLP tx/rx lane value size to 4 bits
  mlxsw: reg: Add Port Module Type Mapping Register
  mlxsw: spectrum: Use PMTM register to get max module width
  mlxsw: spectrum: Move max_width check up before count check
  mlxsw: spectrum: Distinguish between unsplittable and split port
  mlxsw: spectrum: Replace port_to_module array with array of structs
  mlxsw: spectrum: Use mapping of port being split for creating split
    ports
  mlxsw: spectrum: Pass mapping values in port mapping structure
  mlxsw: spectrum: Add sanity checks into module info get
  mlxsw: spectrum: Push getting offsets of split ports into a helper
  mlxsw: spectrum: Introduce resource for getting offset of 4 lanes
    split port
  mlxsw: spectrum: Remember split base local port and use it in unsplit
  mlxsw: spectrum: Use port_module_max_width to compute base port index
  mlxsw: spectrum: Fix base port get for split count 4 and 8
  mlxsw: spectrum: Iterate over all ports in gap during unsplit create
  mlxsw: spectrum: Generalize split count check

 drivers/net/ethernet/mellanox/mlxsw/core.c    |  29 ++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   1 +
 drivers/net/ethernet/mellanox/mlxsw/port.h    |   2 -
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  55 ++-
 .../net/ethernet/mellanox/mlxsw/resources.h   |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 345 ++++++++++++------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  21 +-
 7 files changed, 325 insertions(+), 130 deletions(-)

-- 
2.21.0

