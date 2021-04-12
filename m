Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD6E35CE1E
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244734AbhDLQmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244513AbhDLQh0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:37:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE654613EC;
        Mon, 12 Apr 2021 16:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244871;
        bh=CdciPnGCjQHz/s6U0m4C9OppoCGXYrfiUbQmNnmrSns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2dgOB0O4tYPqfYAo+nXJQ//QrvFSgzy+8u4/BDi2kTgYDYVNvkVIfte+T/PxFg3h
         Us1z0Ewsd+mzXvj7jcm4m2pxZEkfXmZkynXXuDxFwILtAywhsJDrEBwtBL6/5ndfF1
         pAnthqvTSgc8tDz6VEF3qKFKvMbxAs0B1I9DUCTSkWm2LQDkRoREX/igbWhrsfIgRe
         eBF8vK6N0GoFzh8+QBC0Z5rq0kDzd/zqa4lNKPZA46Ks5cynIYdXVTM0ghMOdB5Cl7
         Qh+9bkRP/2JXB5iltX1RzddKhAvH/H7pmeGcvfGvbScjlLydOG8CcuggBItUdMYqf8
         zTHbF2qyKku0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 11/23] net: ieee802154: stop dump llsec devs for monitors
Date:   Mon, 12 Apr 2021 12:27:24 -0400
Message-Id: <20210412162736.316026-11-sashal@kernel.org>
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
index 36f2d44a8753..19a900292f20 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1651,6 +1651,11 @@ nl802154_dump_llsec_dev(struct sk_buff *skb, struct netlink_callback *cb)
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

