Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7FA35CC5A
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243905AbhDLQ2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:28:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244404AbhDLQZy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:25:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0683760FD7;
        Mon, 12 Apr 2021 16:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244685;
        bh=tkivOsPHHgE+DZlMHLV027aE+cEGI6z/Qq7NzeM0rMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqWWSVQAJvpsHUhCaZQllYS2qEAmxgN56wAdRGqYW4TcwW8aGS2S5NmRG1re1DfsE
         MyUAHJoMsyjBoZpNtiNvwTV9xA5r07klNOJ7ZdJVqHgpz6tT1klQ9daG5HMIF4vE/Y
         1SL+P2ritNL7SQvJMC3b1grs+/4wBrpfxTl9MzPeFVep2eCBHY1XXt2STRmTOEWh7W
         GNcCYTFByQ7wLfLh8wrCV3zco5JWBgKW/9+VyHttb8YTePfgpzJ8fbI3mu/sXRVnJ1
         ZQMcJYBZjE8bmrJLETzm18PtwRU+1C2Qtc0g+IhSJT45khI+OqoQ++e0EcDPSD7Bqw
         ltobbC3+JA2Ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 35/46] net: ieee802154: forbid monitor for add llsec seclevel
Date:   Mon, 12 Apr 2021 12:23:50 -0400
Message-Id: <20210412162401.314035-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162401.314035-1-sashal@kernel.org>
References: <20210412162401.314035-1-sashal@kernel.org>
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
index 6a39fb7c0c46..c2e9d133e5fc 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2115,6 +2115,9 @@ static int nl802154_add_llsec_seclevel(struct sk_buff *skb,
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

