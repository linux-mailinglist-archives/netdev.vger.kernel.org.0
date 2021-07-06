Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0666C3BD202
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236793AbhGFLlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236929AbhGFLfr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 567A861C58;
        Tue,  6 Jul 2021 11:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570688;
        bh=bIznIDi8CkwwEjaikFaCvPgHDHQok3btZ9pSdMe2VCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWvvLP65/rPGcQy1BtW5YGQntFDCT755nEnKQRm8rzrrM6zaupBA1J1XTFjRreSYg
         qTNmNQxVfUkl1TtPYwVtLRPeBQoFhYoYsbuxJp1AFxJNmYa8nNgupDXjN/HmuuIywW
         4F+g4z1O8Iql897Enbu1LhKoMS/BSHi1byYvD3LUo0m9Cwsl9CT6hg4yKPDJEU/jpP
         aFnmJRl4MrfkOhy9eyP8POXDrb/uBAwVi6ponZO9MEVz6I/sN2n/0q2qm4bz7wK5MX
         VQo2zKsLaV5o496pDMduCsFy3LZHsTWRTbQoAR/JZJf643poEAPlqU+kzf8spBXGvI
         sfrYZXK+AiDNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 127/137] Bluetooth: L2CAP: Fix invalid access on ECRED Connection response
Date:   Tue,  6 Jul 2021 07:21:53 -0400
Message-Id: <20210706112203.2062605-127-sashal@kernel.org>
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
index 17520133093a..0ddbc415ce15 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6055,7 +6055,7 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 	struct l2cap_ecred_conn_rsp *rsp = (void *) data;
 	struct hci_conn *hcon = conn->hcon;
 	u16 mtu, mps, credits, result;
-	struct l2cap_chan *chan;
+	struct l2cap_chan *chan, *tmp;
 	int err = 0, sec_level;
 	int i = 0;
 
@@ -6074,7 +6074,7 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 
 	cmd_len -= sizeof(*rsp);
 
-	list_for_each_entry(chan, &conn->chan_l, list) {
+	list_for_each_entry_safe(chan, tmp, &conn->chan_l, list) {
 		u16 dcid;
 
 		if (chan->ident != cmd->ident ||
-- 
2.30.2

