Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A541435CBD0
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244238AbhDLQZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:25:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243518AbhDLQXy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F04F61353;
        Mon, 12 Apr 2021 16:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244613;
        bh=cVzxih78KjyS2DB18rOlSVUKQmib598DiAgSu7lcCgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPFQjOfSIUqB5WsMh/yYyB48g0EP4l5+c+GHAZqKMSLo04wXX/hbsLlBFq7+vyGIb
         3CHddHu7fBWwRkpkWH7tomOSgNCNwcZEQweHwVwZWTwsP9GyW5ChnZHUXvCcR4PY4S
         sVUUE3Y2DNKYW1PSonpyIsBmFPdtzaHKMLbJzeve+SZDrzByaUO85M4SbrOGqFNWQq
         Bn+pqWrxQv3qBJ0MIFfijZqA15qNZ813CvryPpQd4vImV0zp1kr0SNnM4qYgDvr5gW
         /A9Z/bjRS0w0OWZIOL7Mq1qi6AnRjaW8Jx1f/fpt0FV0nnFjJRvFAkJbzIMomvLS9H
         vxt+gIAEIz+vA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 29/51] net: ieee802154: stop dump llsec keys for monitors
Date:   Mon, 12 Apr 2021 12:22:34 -0400
Message-Id: <20210412162256.313524-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162256.313524-1-sashal@kernel.org>
References: <20210412162256.313524-1-sashal@kernel.org>
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
index dd43aa03200e..c85e4230ec60 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1493,6 +1493,11 @@ nl802154_dump_llsec_key(struct sk_buff *skb, struct netlink_callback *cb)
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

