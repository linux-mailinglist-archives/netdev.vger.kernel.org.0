Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C40835CE31
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244759AbhDLQml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344119AbhDLQh5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:37:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A21E6613D8;
        Mon, 12 Apr 2021 16:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244880;
        bh=FuoiKPuk3K0b0sUorfpxEF/frD+yKa7Ew8giUzEVwdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rJRIbBml5NUL9CGT6COPtT4XY4wQHTUv0nZpBjoxBWq9QRl7TY36e1T6G4O/w65Uk
         cZ8vl4GGenmZG91uDQMlNQVHJWR7Qsc6zpE9dOjEFqvfZauE1km0mfO/piN+f718ev
         gjxNxOW9VMrRvMweSM6kYWbbzc5R6THtEs4j+VM+ZRiIB97J5/r1l4A5gRziGXFeOW
         /rGDP1AhsKJ+7uQd5SvR0vAgVj+HFhTS5JN12cWSYOCZEJ5FA0ZqZFm7BoKUVG5QNm
         7uwsVU8g4tulQXJu+ibIuqlyOiPZVOT+iCPyDdayndNXxM0pK95zY4C5VWPLP5+7yC
         S0jZP85bB+DdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        syzbot+cde43a581a8e5f317bc2@syzkaller.appspotmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 18/23] net: ieee802154: stop dump llsec params for monitors
Date:   Mon, 12 Apr 2021 12:27:31 -0400
Message-Id: <20210412162736.316026-18-sashal@kernel.org>
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
index f0de6ea84124..c3c0e989d728 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -843,8 +843,13 @@ nl802154_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flags,
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

