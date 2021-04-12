Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA9235CD22
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244331AbhDLQd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245063AbhDLQbj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:31:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E12C8613A8;
        Mon, 12 Apr 2021 16:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244771;
        bh=Voh8y93ylmYb0hpiuVCM2v210dVWOSiD+VcoCZTIfQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XN1q46ZNhKXasW40eh00ykvraooFU1t9cKuMzHXPf7VzBt/x8noADrhjRnXU7fch5
         +i5hVtmP90nFba2VG+dxTHJzGFh9YU9pB8myG/m7q4rp9oaz2VYS9RSb3uy3Hu/SCo
         cphNedXfh6REY7Xny0wB9iMtKRitGAKpquZoWD4EJtgdbKElv+UCZ8Kq9DlUJI7twc
         etizY9/yH7Qi5of0PtME4CZilXdgVqd0RyC1ClNZeIXUIlZDYxxCUffR1VtWlQIKbT
         qaWYCQasyNXImDgi8Ph1iFjuMB9o4BydmbtfJvsyrPxIJRFLlXu/8GG/lGXrItlGFw
         wsf8sehCMFP7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/28] net: ieee802154: stop dump llsec keys for monitors
Date:   Mon, 12 Apr 2021 12:25:39 -0400
Message-Id: <20210412162553.315227-14-sashal@kernel.org>
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
index e07624fd8b3b..8ca3a83b260a 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1511,6 +1511,11 @@ nl802154_dump_llsec_key(struct sk_buff *skb, struct netlink_callback *cb)
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

