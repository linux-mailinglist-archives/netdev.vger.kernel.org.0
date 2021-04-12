Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4D435CE27
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243739AbhDLQma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244193AbhDLQhv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:37:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6030C613DC;
        Mon, 12 Apr 2021 16:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244874;
        bh=lhtX/OPV2ZQfXFQ3AlnVnaqsm6+ABCZQ2nSHmsSLkIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLyF1tGU/UhEX51Dyh3sfZN/q/jGDEEHIvKtn+2cVSmynJLSsjUX6Uhu/FCx+MTYL
         OT85H9YTZICyoww5sI5mi6orlXP2C3ahK1+4W0EQ9ov2nKm6ZDi1zQ+ft7GZA0qzz/
         5ou15KiSh13q7BnnIo0ehtuMBlrZrS9cOdIETcMsJv8R4slvitoyZWLh9dNTih5xpl
         fNJBicKHlnRfA4Wr8OawbVLXL4NZN6qnrg/KbMx8B8OR2z+f5Mp0Xvs1AjOeQmdcjD
         jWe5t8CqbOcgEeahoDWw/9mEb/FbBByVFVRHTU5QRSsU5Cjouz+beP6MZIUwbClz3/
         3PJqCX79VccgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 13/23] net: ieee802154: stop dump llsec devkeys for monitors
Date:   Mon, 12 Apr 2021 12:27:26 -0400
Message-Id: <20210412162736.316026-13-sashal@kernel.org>
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

[ Upstream commit 080d1a57a94d93e70f84b7a360baa351388c574f ]

This patch stops dumping llsec devkeys for monitors which we don't support
yet. Otherwise we will access llsec mib which isn't initialized for
monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-10-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 8d22b1a68835..db45cb0d20b2 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1831,6 +1831,11 @@ nl802154_dump_llsec_devkey(struct sk_buff *skb, struct netlink_callback *cb)
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

