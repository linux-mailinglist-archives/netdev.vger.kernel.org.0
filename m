Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6143B35CDCA
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244870AbhDLQir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245082AbhDLQbm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:31:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11978613AB;
        Mon, 12 Apr 2021 16:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244772;
        bh=+kFcPS7nRu6Pb7d/7qpjf/+ko098izStzlsX9Prp/pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGEOolUw+4WE+PJWYLqaOWAK3ehbH8q+p03p4DgU11X+jKWZ5LdM18MIq5nMJzjC9
         IbB4iSv1CkjWjx1oOPYgdqAHJJDKkeKjqBXXMNSFtgfLqj1kmBab4UYeicYKBfP0hs
         mNQft2BuKtSPgl8Pd/PcGFe2X5wEHVkveg0Ear9zDlU2vv4MKGXmoRfv4tqIarVPvB
         /aHiMlvpr1qVbWF7GuIdAdoF00F3OXGDzrYSLqCC2Bodn9hgxR//UZFtU96spbt5gG
         4f5vnJ1VoLx2Gb/e8UxkbKSx1WeMicyOfXWgcX58L8ppygFYEqfpKvhZH/yHl/EnyJ
         woFyZOV9a1MKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 15/28] net: ieee802154: stop dump llsec devs for monitors
Date:   Mon, 12 Apr 2021 12:25:40 -0400
Message-Id: <20210412162553.315227-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162553.315227-1-sashal@kernel.org>
References: <20210412162553.315227-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 5582d641e6740839c9b83efd1fbf9bcd00b6f5fc ]

This patch stops dumping llsec devs for monitors which we don't support
yet. Otherwise we will access llsec mib which isn't initialized for
monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-7-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 8ca3a83b260a..3b870791075c 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1686,6 +1686,11 @@ nl802154_dump_llsec_dev(struct sk_buff *skb, struct netlink_callback *cb)
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

