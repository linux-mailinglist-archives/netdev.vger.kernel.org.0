Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FD035CD26
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245152AbhDLQeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:34:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245153AbhDLQb6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:31:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD694613BC;
        Mon, 12 Apr 2021 16:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244781;
        bh=Kd7gkNycfdjTW6Q57UxmmOWAEWQHM4HD+7B6qR1ldPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2Nr+7JFvlTyVvvtYGwllQqx6Vugi55mTJRFejV6EcwtoRIx8ZufR/7nwBsbIbO+n
         tQR4/4ahTaJicpE18zXyXSE72xSm2DwK/Up6lOsTpAIJ3avv+GS/5BFHYok535ZF1s
         EfyH31CjehxXmqH2/+eEWxglEZVkIb04lXq3y1btWKWFJS5qe3Br1KrHRm0aZOnDUy
         G1CgHCBK4OVXozl2HQiyoZC/dJoWOQGI/ajO4xEufD5PaJo3nMOEXAaqZ52amWtqBD
         Ob/LiO9u/RJwY8ATH9LRA+SKgKwgnMWCWXFSA7y0q8oYF5jgGWmS39G+wU3HrdJMzG
         ZEuAD6v96/ACQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        syzbot+cde43a581a8e5f317bc2@syzkaller.appspotmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 22/28] net: ieee802154: stop dump llsec params for monitors
Date:   Mon, 12 Apr 2021 12:25:47 -0400
Message-Id: <20210412162553.315227-22-sashal@kernel.org>
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

[ Upstream commit 1534efc7bbc1121e92c86c2dabebaf2c9dcece19 ]

This patch stops dumping llsec params for monitors which we don't support
yet. Otherwise we will access llsec mib which isn't initialized for
monitors.

Reported-by: syzbot+cde43a581a8e5f317bc2@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-16-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 138aa41fb6f7..f2ddeb73c3ef 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -836,8 +836,13 @@ nl802154_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flags,
 		goto nla_put_failure;
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		goto out;
+
 	if (nl802154_get_llsec_params(msg, rdev, wpan_dev) < 0)
 		goto nla_put_failure;
+
+out:
 #endif /* CONFIG_IEEE802154_NL802154_EXPERIMENTAL */
 
 	genlmsg_end(msg, hdr);
-- 
2.30.2

