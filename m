Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B404235CE1B
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245107AbhDLQmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244289AbhDLQhZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:37:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D39C613F4;
        Mon, 12 Apr 2021 16:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244870;
        bh=cpXGB91uc3dbR5TYi49hhCnLQMQoZpJuph7uj5+A8/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSWtBiZKWh2wJ4G2fHgtI83e7iB9fsrqMu2ax91srJDpk8Y7U+6i/Tll//TDUzUlm
         7vJN4iWwJzcxqk8gJjZBcr+uQuzeT1z8llnPvpAL3UqBxkcvgNBgcX62lSAncJQaRk
         6ZHKUOl8VcmEBtYGFVluqS918goRz2+f9q25SEKtacl/519lcZeRfCRtd4HLiIqpbh
         abLI3Fr1SAONoGOEjssfITa6k1TWsgeIvBZnNDe2AQBMVUs1Pq3uJAnQKekxve7/QD
         j80R6SYdL0NAhQeSMSMby0r5D6wL0hDzdZdVYHMQ5XYo6pUq3oNPKzoAEU3Ep2GlYY
         dgagKg/67x2rw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 10/23] net: ieee802154: stop dump llsec keys for monitors
Date:   Mon, 12 Apr 2021 12:27:23 -0400
Message-Id: <20210412162736.316026-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162736.316026-1-sashal@kernel.org>
References: <20210412162736.316026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit fb3c5cdf88cd504ef11d59e8d656f4bc896c6922 ]

This patch stops dumping llsec keys for monitors which we don't support
yet. Otherwise we will access llsec mib which isn't initialized for
monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-4-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 746701424d79..36f2d44a8753 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1476,6 +1476,11 @@ nl802154_dump_llsec_key(struct sk_buff *skb, struct netlink_callback *cb)
 	if (err)
 		return err;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR) {
+		err = skb->len;
+		goto out_err;
+	}
+
 	if (!wpan_dev->netdev) {
 		err = -EINVAL;
 		goto out_err;
-- 
2.30.2

