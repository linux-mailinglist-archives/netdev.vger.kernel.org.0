Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D54535CDD2
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344179AbhDLQjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:39:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343559AbhDLQfZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:35:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BF14613D1;
        Mon, 12 Apr 2021 16:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244815;
        bh=Kd7gkNycfdjTW6Q57UxmmOWAEWQHM4HD+7B6qR1ldPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hlZTbZENaWPpQmW1zI+0v0camZbcGLMJB8XFCrtHRRQmN+1/myta6IMBwmo+pfTCr
         QNEV/V/bj8xtgsHY+QvX8lbtaxsWxWZrbRC0V16sdyG3IL5baZY5auJFw1JD3AsYTE
         aa33eZtLjxuHcxjCJjIGq/OhYKMjodwrdCyQ95US9rdA5cntwQ28lPMLWKnjrshGwS
         fn37v9bEm4TvtjbXeHN6OACf77gruOEUpSjm/zu6xhQqu1XTGsrzhSjScZTz4/2DuQ
         cjqZhU5i84Pg1lEgtbKmDBiQn5SLnD6wS60phtQFPVTbcuLXKcjk6y0XyhnPKCjswS
         a7TwqQOwV395g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        syzbot+cde43a581a8e5f317bc2@syzkaller.appspotmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 19/25] net: ieee802154: stop dump llsec params for monitors
Date:   Mon, 12 Apr 2021 12:26:24 -0400
Message-Id: <20210412162630.315526-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162630.315526-1-sashal@kernel.org>
References: <20210412162630.315526-1-sashal@kernel.org>
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

