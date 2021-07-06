Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5548A3BD00A
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbhGFLcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235727AbhGFLaX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E86E361DDF;
        Tue,  6 Jul 2021 11:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570504;
        bh=Z+g+ozLNpl3+4Xx8VSrAf65TzsuwM2aBXEWHnZ+Ugxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=elAOCyxr4jcKCltdJUL1T3Adfag5+Lb5AkNpTL2xv1nTMa4+P1ov1PHC+uA/ySWgt
         LVsoNWJKJeEG2TcWwxe43S7vnKBYOFS9jD7uOq7hmrJB59pxHhEyi7TgcDMRRwfFjK
         oX7IUvg0LdOvHXbi1+I3cPgNsDfOskJll2Xj3y/Bg6RPSO5CSUOzHd3lo7LeeO8Pnr
         c/ur+nsQbYgYG+WNUaGehsRmxGOxACTW1VBQWj1kMJ1Sw4F5ENuJTFJxkQxaiTiQBd
         rsee0sWj1QZoONxM2+sE6OFynrd1nG05214LFcyd/bbZE/oU8Kf7kn8yOhQLUi/unq
         g505aaxlCAtrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 147/160] Bluetooth: L2CAP: Fix invalid access if ECRED Reconfigure fails
Date:   Tue,  6 Jul 2021 07:18:13 -0400
Message-Id: <20210706111827.2060499-147-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 53ddbee459b9..015f9ecadd0a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6244,7 +6244,7 @@ static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
 					 struct l2cap_cmd_hdr *cmd, u16 cmd_len,
 					 u8 *data)
 {
-	struct l2cap_chan *chan;
+	struct l2cap_chan *chan, *tmp;
 	struct l2cap_ecred_conn_rsp *rsp = (void *) data;
 	u16 result;
 
@@ -6258,7 +6258,7 @@ static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
 	if (!result)
 		return 0;
 
-	list_for_each_entry(chan, &conn->chan_l, list) {
+	list_for_each_entry_safe(chan, tmp, &conn->chan_l, list) {
 		if (chan->ident != cmd->ident)
 			continue;
 
-- 
2.30.2

