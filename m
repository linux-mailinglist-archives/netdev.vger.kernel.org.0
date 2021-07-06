Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4423BD207
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236286AbhGFLlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:41:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236928AbhGFLfr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E35361C1F;
        Tue,  6 Jul 2021 11:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570686;
        bh=bsEnOKTKubeAnXdjd1dwyP1b4t3xhg2iwVST1V6/ve8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Awu3giRoKaE/m2D2jgbF+wZLN0TKnNZlTWmZlQGr8ei+ypsoCrkfV+0qTf27ukFSk
         bqRA6dXHTTMs1Fk6nN72I7ggXd0DSIg9uF5pNSjpuo0PFA23y9yJq5pd8VGfQ9/oQf
         geBrqJy0ghtAuoaLCHQiEhWJjhaZquF2oiei3ZURHnm6i9ewn77UtARgEu5thVrvVU
         MhRewS8BKx8lAHNwQnUSrnVBvNYVfe33Bgk5vWjN6dongQa2o+t2OdRB3oSuAG5rPH
         Chz99lNZtyTc50ItPwe8LCILNeMNJ55h8ybdJNf7o+UmDhOu1QfKIa8tdpi+GQf+GB
         pm/fZqtJGSOxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 126/137] Bluetooth: L2CAP: Fix invalid access if ECRED Reconfigure fails
Date:   Tue,  6 Jul 2021 07:21:52 -0400
Message-Id: <20210706112203.2062605-126-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 1fa20d7d4aad02206e84b74915819fbe9f81dab3 ]

The use of l2cap_chan_del is not safe under a loop using
list_for_each_entry.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index cdc386337173..17520133093a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6237,7 +6237,7 @@ static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
 					 struct l2cap_cmd_hdr *cmd, u16 cmd_len,
 					 u8 *data)
 {
-	struct l2cap_chan *chan;
+	struct l2cap_chan *chan, *tmp;
 	struct l2cap_ecred_conn_rsp *rsp = (void *) data;
 	u16 result;
 
@@ -6251,7 +6251,7 @@ static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
 	if (!result)
 		return 0;
 
-	list_for_each_entry(chan, &conn->chan_l, list) {
+	list_for_each_entry_safe(chan, tmp, &conn->chan_l, list) {
 		if (chan->ident != cmd->ident)
 			continue;
 
-- 
2.30.2

