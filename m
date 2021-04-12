Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D73E35CCDC
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245146AbhDLQb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245112AbhDLQ3i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:29:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D38A6138F;
        Mon, 12 Apr 2021 16:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244740;
        bh=+8T01LAUUfEDZHrnRfk4MKq7jK1CInXNw2zoPsr7no4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dISQHDeAZIEdJqn75l3vlXy3A3WC0pLrBpntoGfueeRhBWy8d6/ih/Nz5qPAMxj2u
         yQLcVipH0G04KF0QH2jJLXoi7qV0SBbrhdP8Jo/m3g5PbaIRHFJZ8PxSzh8guXpFSv
         m7zuBIlPUq1n58uav0H6X4VrJtHzFmgYnWSOsl9Na7cOQTvPTpwAqD5yh7wQi6Koh9
         GR+puX+9b8UUumNc/QHg1F7RClTEz8bCplJJMhdv4srIYU/TO/pRse6fsxqDewjEbg
         1wiFHCNfieobkKT3f6+Y9/O2YyU8nJoKwmuNtU+65cTmMsd9DB6A8q68xBv3P16gZq
         /8t4hTkL9nAog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 30/39] net: ieee802154: forbid monitor for add llsec seclevel
Date:   Mon, 12 Apr 2021 12:24:52 -0400
Message-Id: <20210412162502.314854-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162502.314854-1-sashal@kernel.org>
References: <20210412162502.314854-1-sashal@kernel.org>
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
index 7c013d45d690..898982b51363 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2131,6 +2131,9 @@ static int nl802154_add_llsec_seclevel(struct sk_buff *skb,
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

