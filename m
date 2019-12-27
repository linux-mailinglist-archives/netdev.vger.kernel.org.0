Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06B6012B728
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbfL0Rrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:47:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728605AbfL0Roz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:44:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D880D20740;
        Fri, 27 Dec 2019 17:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468694;
        bh=Al7bzgi2unxPyfP1PZlhJR/3qZPvUNIjLvPGQBoa3nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eAhyXW4MWH2HXnNKSTCJyAxyrVHHK4IvmmqxHp69pfO5Uju6X8l8nD0wni5p9VU5k
         EXHmHmuhponV8LdPTl+BVQljf9QnlSNp3YbxoGbX1PSvNIPVi6fJ4ftX4VQoVRZuI8
         vBLa6ozMEbyTwdwSIs9GOtttYBlxOqS71qjcqRgo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mahesh Bandewar <maheshb@google.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 51/84] bonding: fix active-backup transition after link failure
Date:   Fri, 27 Dec 2019 12:43:19 -0500
Message-Id: <20191227174352.6264-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174352.6264-1-sashal@kernel.org>
References: <20191227174352.6264-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>

[ Upstream commit 5d485ed88d48f8101a2067348e267c0aaf4ed486 ]

After the recent fix in commit 1899bb325149 ("bonding: fix state
transition issue in link monitoring"), the active-backup mode with
miimon initially come-up fine but after a link-failure, both members
transition into backup state.

Following steps to reproduce the scenario (eth1 and eth2 are the
slaves of the bond):

    ip link set eth1 up
    ip link set eth2 down
    sleep 1
    ip link set eth2 up
    ip link set eth1 down
    cat /sys/class/net/eth1/bonding_slave/state
    cat /sys/class/net/eth2/bonding_slave/state

Fixes: 1899bb325149 ("bonding: fix state transition issue in link monitoring")
CC: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 9b8143dca512..f57b86f1373d 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2223,9 +2223,6 @@ static void bond_miimon_commit(struct bonding *bond)
 			} else if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
 				/* make it immediately active */
 				bond_set_active_slave(slave);
-			} else if (slave != primary) {
-				/* prevent it from being the active one */
-				bond_set_backup_slave(slave);
 			}
 
 			netdev_info(bond->dev, "link status definitely up for interface %s, %u Mbps %s duplex\n",
-- 
2.20.1

