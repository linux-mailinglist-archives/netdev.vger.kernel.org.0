Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C823BCE8F
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbhGFL0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233899AbhGFLXG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:23:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6D9061CBF;
        Tue,  6 Jul 2021 11:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570287;
        bh=PdvUE2xi/A75WZ8XqDzq1pCdWAVrTkQelS2Jm0MQPto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FjYrWBxeAu41AQfz+Q2kpsHUGAs680vK/C833fuZWPJuScs1w124X8K81HmBLQwrD
         uFx000Byphb0BtaI5x1ySbgRy0iM4mnelBXVuD8whTZAG041GwtGdLJ6md5YPt5Bi9
         G77URAxOLeesyIRZojAPCMeZ6N0RBjT6RW9e1QemHVZEEdw0laVJ54F2iSw4okq9N2
         2YJiOGgXshUCuZj0J7zpAiMe40DUSia+1t/xyvVTAYKBxrsimHKERQoa0mUyUgLLGj
         h3lZ9AxaJJkf3NhWtkHy5wPNwJ5wNVVuOYmgRmulENWum98lE+AaEZiIRAWqk0ai+V
         HLrtIwPJDmpLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 177/189] Bluetooth: L2CAP: Fix invalid access on ECRED Connection response
Date:   Tue,  6 Jul 2021 07:13:57 -0400
Message-Id: <20210706111409.2058071-177-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index 9b6e57204f51..9908aa53a682 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6066,7 +6066,7 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 	struct l2cap_ecred_conn_rsp *rsp = (void *) data;
 	struct hci_conn *hcon = conn->hcon;
 	u16 mtu, mps, credits, result;
-	struct l2cap_chan *chan;
+	struct l2cap_chan *chan, *tmp;
 	int err = 0, sec_level;
 	int i = 0;
 
@@ -6085,7 +6085,7 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 
 	cmd_len -= sizeof(*rsp);
 
-	list_for_each_entry(chan, &conn->chan_l, list) {
+	list_for_each_entry_safe(chan, tmp, &conn->chan_l, list) {
 		u16 dcid;
 
 		if (chan->ident != cmd->ident ||
-- 
2.30.2

