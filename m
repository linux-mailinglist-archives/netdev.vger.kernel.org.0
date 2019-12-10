Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F967119A1D
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbfLJVty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:49:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:55914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbfLJVIa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7281624684;
        Tue, 10 Dec 2019 21:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012110;
        bh=7XAFeYdjzdaDWxzc/x4+K8Fg4Yzq7/2lj8NDwkqvElI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w8ih1pJ+6XNd3kyHiThAUiAKrg5pNnhqFGdcWKAmtHC0QdVC66Xvu4n7/r6swppsu
         yMZ1g83shuLhmTXOV/Pqe5uTyzHKZCKnMpBnZmstZFMI6nLGw0/CPjjLOsIpi9+rpG
         MTAo4FrwWDCg6cnOq1xW+7qWsL3cJuOFzP0OPE3Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 083/350] team: call RCU read lock when walking the port_list
Date:   Tue, 10 Dec 2019 16:03:08 -0500
Message-Id: <20191210210735.9077-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit c17e26ddc79596230834345be80fcad6c619e9ec ]

Before reading the team port list, we need to acquire the RCU read lock.
Also change list_for_each_entry() to list_for_each_entry_rcu().

v2:
repost the patch to net-next and remove fixes flag as this is a cosmetic
change.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 8156b33ee3e79..ca70a1d840eb3 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2074,7 +2074,8 @@ static int team_ethtool_get_link_ksettings(struct net_device *dev,
 	cmd->base.duplex = DUPLEX_UNKNOWN;
 	cmd->base.port = PORT_OTHER;
 
-	list_for_each_entry(port, &team->port_list, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(port, &team->port_list, list) {
 		if (team_port_txable(port)) {
 			if (port->state.speed != SPEED_UNKNOWN)
 				speed += port->state.speed;
@@ -2083,6 +2084,8 @@ static int team_ethtool_get_link_ksettings(struct net_device *dev,
 				cmd->base.duplex = port->state.duplex;
 		}
 	}
+	rcu_read_unlock();
+
 	cmd->base.speed = speed ? : SPEED_UNKNOWN;
 
 	return 0;
-- 
2.20.1

