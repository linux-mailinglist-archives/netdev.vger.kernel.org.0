Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D04A49704C
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 06:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbiAWF52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 00:57:28 -0500
Received: from giacobini.uberspace.de ([185.26.156.129]:58836 "EHLO
        giacobini.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiAWF51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 00:57:27 -0500
Received: (qmail 12117 invoked by uid 990); 23 Jan 2022 05:57:25 -0000
Authentication-Results: giacobini.uberspace.de;
        auth=pass (plain)
From:   Soenke Huster <soenke.huster@eknoes.de>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Soenke Huster <soenke.huster@eknoes.de>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] Bluetooth: msft: fix null pointer deref on msft_monitor_device_evt
Date:   Sun, 23 Jan 2022 06:57:09 +0100
Message-Id: <20220123055709.7925-1-soenke.huster@eknoes.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: /
X-Rspamd-Report: BAYES_HAM(-2.999986) R_MISSING_CHARSET(0.5) MIME_GOOD(-0.1) MID_CONTAINS_FROM(1) SUSPICIOUS_RECIPS(1.5)
X-Rspamd-Score: -0.099986
Received: from unknown (HELO unkown) (::1)
        by giacobini.uberspace.de (Haraka/2.8.28) with ESMTPSA; Sun, 23 Jan 2022 06:57:25 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

msft_find_handle_data returns NULL if it can't find the handle.
Therefore, handle_data must be checked, otherwise a null pointer
is dereferenced.

Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
---
v2: Remove empty line

 net/bluetooth/msft.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 484540855863..9a3d77d3ca86 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -704,6 +704,8 @@ static void msft_monitor_device_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		   ev->monitor_state, &ev->bdaddr);
 
 	handle_data = msft_find_handle_data(hdev, ev->monitor_handle, false);
+	if (!handle_data)
+		return;
 
 	switch (ev->addr_type) {
 	case ADDR_LE_DEV_PUBLIC:
-- 
2.34.1

