Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C20D2634C3
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbgIIRiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:38:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729135AbgIIRh6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 13:37:58 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A55D20757;
        Wed,  9 Sep 2020 17:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599673077;
        bh=YMNxy+6Xq5/52E7pSnhnUK7ftxkD7XuYzodi7vHazOk=;
        h=From:To:Cc:Subject:Date:From;
        b=1T2yLvnfrnRYiITcddx3sVWh7z30tXYhruQagHoNCILtQw79whWDbFzvcwQj77IHo
         ojw34dVZ/WjRL75GDoOPNMU3BCieIodMq0byUYRt58BOKuaJH14Gh6CQpTfYevX39L
         NcdQJr7SWVitq+5e0h6fsmqKeqDiVJ2yD6evnVxA=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] netpoll: make sure napi_list is safe for RCU traversal
Date:   Wed,  9 Sep 2020 10:37:50 -0700
Message-Id: <20200909173753.229124-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This series is a follow-up to the fix in commit 96e97bc07e90 ("net: 
disable netpoll on fresh napis"). To avoid any latent race conditions
convert dev->napi_list to a proper RCU list. We need minor restructuring
because it looks like netif_napi_del() used to be idempotent, and
it may be quite hard to track down everyone who depends on that.

Jakub Kicinski (3):
  net: remove napi_hash_del() from driver-facing API
  net: manage napi add/del idempotence explicitly
  net: make sure napi_list is safe for RCU traversal

 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |  8 ++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  5 ++-
 drivers/net/ethernet/cisco/enic/enic_main.c   | 12 ++++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  |  4 +--
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  5 ++-
 drivers/net/veth.c                            |  3 +-
 drivers/net/virtio_net.c                      |  7 ++--
 include/linux/netdevice.h                     | 36 +++++++++----------
 net/core/dev.c                                | 32 ++++++++---------
 net/core/netpoll.c                            |  2 +-
 10 files changed, 55 insertions(+), 59 deletions(-)

-- 
2.26.2

