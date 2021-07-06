Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2953BD014
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbhGFLcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235728AbhGFLaX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A04861DCB;
        Tue,  6 Jul 2021 11:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570506;
        bh=sV4H0VfzjMn7DSrTOt9uibCBgTCNZPAAO5h3SmG5Krc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kb0eJYw+UQ1HpduDzvjKUJ4Sc/xBJ0NGphyiDIt23hJCQ7DVFJNkFyVq6R2UNWeF5
         7cINFVATc7z/sdqueMhJaA83XPFeZ7fm1VatS1Vq2aZCvdSMFHuDifwvYA7lOV7+Vj
         0X0ivhEzTYNwo5S+TvIguPIA/U8bZJAhu5k7qKx41tI7Dr6h8TxeaNn+UsjPHwyKjr
         EhXTb1wkkg80G5g+BPhNBxWhUfaIfm9I08DTpddimiWUz2AchzGEyZhNJElf0XdSgd
         rlaIqkvvlmButj1rRJn/GIj4GIkkWo2YoEJPD4gp2r6JqjAGFkRa1WFGz4G9ryvvS4
         m76vT6P11P7Gg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 148/160] Bluetooth: L2CAP: Fix invalid access on ECRED Connection response
Date:   Tue,  6 Jul 2021 07:18:14 -0400
Message-Id: <20210706111827.2060499-148-sashal@kernel.org>
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

[ Upstream commit de895b43932cb47e69480540be7eca289af24f23 ]

The use of l2cap_chan_del is not safe under a loop using
list_for_each_entry.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 015f9ecadd0a..b1f4d5505bba 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6062,7 +6062,7 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 	struct l2cap_ecred_conn_rsp *rsp = (void *) data;
 	struct hci_conn *hcon = conn->hcon;
 	u16 mtu, mps, credits, result;
-	struct l2cap_chan *chan;
+	struct l2cap_chan *chan, *tmp;
 	int err = 0, sec_level;
 	int i = 0;
 
@@ -6081,7 +6081,7 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 
 	cmd_len -= sizeof(*rsp);
 
-	list_for_each_entry(chan, &conn->chan_l, list) {
+	list_for_each_entry_safe(chan, tmp, &conn->chan_l, list) {
 		u16 dcid;
 
 		if (chan->ident != cmd->ident ||
-- 
2.30.2

