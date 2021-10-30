Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0C9440B9C
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 22:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhJ3UXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 16:23:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229782AbhJ3UXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 16:23:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 567CB60F02;
        Sat, 30 Oct 2021 20:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635625265;
        bh=3c8OLt25LcrKcRxs6A52GMOlDaUrbdKXbNNNRakXibE=;
        h=From:To:Cc:Subject:Date:From;
        b=QQSX6+5OY2jIA2u+NRwukHxePNc8ec6L70Cm7ZUJ4MtG0/cV5/V3P196YFQbCuT19
         GWnx0/jSC6C/UbmtRnpw0Db08tv+oEwYkzGyxT4r008Y412fxzUXUw+/B5MvUdQeuy
         VRDGoCclPdn4vJRIwOW8a0Q68LTA6IDdJv5WKtvJLb7dKd0kCD+f9UfvZSXizFFOyq
         eBR8A73v2Xmm9SiS3IRWVhdvlh9EF87pk8evaKUyUoBop3tNy+FOHdQUv/ZoYB+Oix
         dSHy5GbaGVMS+Wd7zlwqwcnu8fdjjqeSoJ/pdwPTAPI3qZP3Y9k1w2IipzMi1RyPkK
         6RNlTTWnyFYaQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/5] netdevsim: improve separation between device and bus
Date:   Sat, 30 Oct 2021 13:20:57 -0700
Message-Id: <20211030202102.2157622-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VF config falls strangely in between device and bus
responsibilities today. Because of this bus.c sticks fingers
directly into struct nsim_dev and we look at nsim_bus_dev
in many more places than necessary.

Make bus.c contain pure interface code, and move
the particulars of the logic (which touch on eswitch,
devlink reloads etc) to dev.c. Rename the functions
at the boundary of the interface to make the separation
clearer.

Jakub Kicinski (5):
  netdevsim: take rtnl_lock when assigning num_vfs
  netdevsim: move vfconfig to nsim_dev
  netdevsim: move details of vf config to dev
  netdevsim: move max vf config to dev
  netdevsim: rename 'driver' entry points

 drivers/net/netdevsim/bus.c       | 155 ++-----------------------
 drivers/net/netdevsim/dev.c       | 181 ++++++++++++++++++++++++++----
 drivers/net/netdevsim/netdev.c    |  72 ++++++------
 drivers/net/netdevsim/netdevsim.h |  55 +++++----
 4 files changed, 230 insertions(+), 233 deletions(-)

-- 
2.31.1

