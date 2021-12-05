Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D1B468A12
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 09:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhLEIZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 03:25:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56048 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbhLEIZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 03:25:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A350160F90;
        Sun,  5 Dec 2021 08:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F07C341C4;
        Sun,  5 Dec 2021 08:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638692533;
        bh=WO5zoGfIv7L2ls4vdk54cbVg57AyTxML/w1CZKiJRcg=;
        h=From:To:Cc:Subject:Date:From;
        b=PQG5cgGHp7g8bTmizHvFVqCblEI4+zRd38+OebhsVHuJue2tQILMGFIRj0PajX4W4
         /uJc0JdtAKJTiXltjK7PtSxPTZfBZrsR/pD9ZOUfUjGbdccaMeOkF7fBK+YsPgy+Bz
         ymJOerrsPKhE8HT5pXdGbo/SVOJ8dcxL6Q2EOfDigaW+2sE+zxNJfwfAIegoX53LTs
         2iQXT4DWSa8Wh36ALNbWJklz2yS947yJn1aknZFlDuQH3AX1CNKc7sUJm4zKdGc31v
         P7iAg9sqEmbT5C0GYP+oRH0Q/SNEJs4MllWhgsConuS0Dfllr4xGGwQk7oNdKKMYFe
         TY3pgUuZdswyQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/6] Allow parallel devlink execution
Date:   Sun,  5 Dec 2021 10:22:00 +0200
Message-Id: <cover.1638690564.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This is final piece of devlink locking puzzle, where I remove global
mutex lock (devlink_mutex), so we can run devlink commands in parallel.

The series starts with addition of port_list_lock, which is needed to
prevent locking dependency between netdevsim sysfs and devlink. It
follows by the patch that adds context aware locking primitives. Such
primitives allow us to make sure that devlink instance is locked and
stays locked even during reload operation. The last patches opens
devlink to parallel commands.

It tested on mlx5, mlx4, mlxsw, netdevsim + Ido's syzkaller.

BTW, in the future patches, we will clean devlink from over-engineered
APIs and implementations. It will open a venue to revise all the places
that hold devlink lock, if they really need to do it.

Thanks

[1] https://lore.kernel.org/netdev/cover.1636390483.git.leonro@nvidia.com/
[2] https://lore.kernel.org/netdev/9716f9a13e217a0a163b745b6e92e02d40973d2c.1635701665.git.leonro@nvidia.com/

Leon Romanovsky (6):
  devlink: Clean registration of devlink port
  devlink: Be explicit with devlink port protection
  devlink: Add devlink nested locking primitive
  devlink: Require devlink lock during device reload
  devlink: Use xarray locking mechanism instead big devlink lock
  devlink: Open devlink to parallel operations

 net/core/devlink.c | 432 ++++++++++++++++++++++++---------------------
 1 file changed, 232 insertions(+), 200 deletions(-)

-- 
2.33.1

