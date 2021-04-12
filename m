Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9867B35CD61
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344087AbhDLQg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:36:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245136AbhDLQbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:31:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3439C6135F;
        Mon, 12 Apr 2021 16:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244778;
        bh=jg1qQhWF9uBukkVmaeh1ltTMWssWijDjIOBMESgcPiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Be2CThfSTQU1qHkM+WDlPAs4BC4w9lJEqK9HFBPsLGhvpthq6xtg6ob341kCMLvd3
         hhuYtLvpwwrRZhQ1n1flTkCiwDqaKYRZnn6S884WTYSX6BRTxPvniaHMidgnBG+DCn
         th76qDx8fcqoCAxd1W0mOCxtp7jrK8o1sRh+449UnOwo2dPrGDC41Hp4I3lgIW74/U
         0XVl40BqV0XK0bkhxGHX5ud1fli8u1p0zk2YI1iv4v8y34KCO2eEFH/eGKgbA+rf7s
         NtS5h83Gu9Is4fePgyT8CZNxoNhz2HAELOqFHs1X35oV4sTtkVHp9IOZ3QpdgzZ/zC
         qzFMhYAQlO2Jg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 20/28] net: ieee802154: forbid monitor for add llsec seclevel
Date:   Mon, 12 Apr 2021 12:25:45 -0400
Message-Id: <20210412162553.315227-20-sashal@kernel.org>
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

[ Upstream commit 9ec87e322428d4734ac647d1a8e507434086993d ]

This patch forbids to add llsec seclevel for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-14-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index c47f83bd21df..8cf71f637ead 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2129,6 +2129,9 @@ static int nl802154_add_llsec_seclevel(struct sk_buff *skb,
 	struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
 	struct ieee802154_llsec_seclevel sl;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (llsec_parse_seclevel(info->attrs[NL802154_ATTR_SEC_LEVEL],
 				 &sl) < 0)
 		return -EINVAL;
-- 
2.30.2

