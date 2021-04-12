Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0376A35CDF8
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245342AbhDLQlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343987AbhDLQga (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:36:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 166E5613C6;
        Mon, 12 Apr 2021 16:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244845;
        bh=G8hbmx/SRIv8ruojRYxa0PUIsVV6j2J5SGaBN3mZJ9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnJVradCi8ZZffwUT6bp5LdSYRwnkdoXkAv6jOj4jl0WYGmq9Oj8IS0w89yOInDtA
         l1I8Ob+7bRiKSqC/EGa3R2LD3RTjfyt78SeX0dwn1OpOI7WlVseBMoFh54CTqJEuA3
         mRyIO4+KgVFtvPsTbyOnyf45tf1QMeZzRX984+wqCdCDlRyhlFgLmesqaKYVzJ977X
         /fXnVwwn55PHNlLCAQjbbnG30ygqIxT0EJ4RXp21svamEfNhuJjxmo1OokibGCXELp
         Hb03Wn92+gJbjLt2aShgIhMiIzra+pSD2aEelfHffXivVIEcsE/zmfDxw4yONh/ZIf
         FMNVq9izzDJ+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 16/23] net: ieee802154: forbid monitor for add llsec seclevel
Date:   Mon, 12 Apr 2021 12:26:57 -0400
Message-Id: <20210412162704.315783-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162704.315783-1-sashal@kernel.org>
References: <20210412162704.315783-1-sashal@kernel.org>
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
index a54ca9ba9107..c51467693c6d 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2144,6 +2144,9 @@ static int nl802154_add_llsec_seclevel(struct sk_buff *skb,
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

