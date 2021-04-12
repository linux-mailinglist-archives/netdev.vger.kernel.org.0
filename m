Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9C835CC8D
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243969AbhDLQaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:30:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243743AbhDLQ1N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:27:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A486D61366;
        Mon, 12 Apr 2021 16:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244709;
        bh=AW0bp1piLj4es0BhKJCmMFtIk8VNLiEF3VgcSgo9LV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GbHR9ujYFF/2RUDhSnSiqzIYpnm4QdI1rAjILF3Z2t4K5fjWqXzq/Hn7rk3N2LXEy
         P/+3VN2y48GKdNj4XcIvhwDwknXnyPvh3+WeD14q+fYPve0r5PY4tWt+AKmKL6M7/D
         24bSQSN/4iJsPb8jcrofCPBgDVdUIDX/B7zdVGcaoxGjZoakqIq7I0k0We8xvlwfDD
         OBqTVXpTdB+7pp/9LlL82SwPj6luA8v12Nc3Pe8IPgCsTHS0AVw7wXHjNqtOhIYxb0
         pIUKzHM5UkpSweYlUdk1opFKDL5lANl4d1WNAXX85Egt13il1MkwwL6F+dcYgxOoIW
         tjbjeS3z8lR6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        syzbot+d4c07de0144f6f63be3a@syzkaller.appspotmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/39] net: ieee802154: nl-mac: fix check on panid
Date:   Mon, 12 Apr 2021 12:24:27 -0400
Message-Id: <20210412162502.314854-5-sashal@kernel.org>
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

[ Upstream commit 6f7f657f24405f426212c09260bf7fe8a52cef33 ]

This patch fixes a null pointer derefence for panid handle by move the
check for the netlink variable directly before accessing them.

Reported-by: syzbot+d4c07de0144f6f63be3a@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210228151817.95700-4-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl-mac.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ieee802154/nl-mac.c b/net/ieee802154/nl-mac.c
index 6d091e419d3e..d19c40c684e8 100644
--- a/net/ieee802154/nl-mac.c
+++ b/net/ieee802154/nl-mac.c
@@ -551,9 +551,7 @@ ieee802154_llsec_parse_key_id(struct genl_info *info,
 	desc->mode = nla_get_u8(info->attrs[IEEE802154_ATTR_LLSEC_KEY_MODE]);
 
 	if (desc->mode == IEEE802154_SCF_KEY_IMPLICIT) {
-		if (!info->attrs[IEEE802154_ATTR_PAN_ID] &&
-		    !(info->attrs[IEEE802154_ATTR_SHORT_ADDR] ||
-		      info->attrs[IEEE802154_ATTR_HW_ADDR]))
+		if (!info->attrs[IEEE802154_ATTR_PAN_ID])
 			return -EINVAL;
 
 		desc->device_addr.pan_id = nla_get_shortaddr(info->attrs[IEEE802154_ATTR_PAN_ID]);
@@ -562,6 +560,9 @@ ieee802154_llsec_parse_key_id(struct genl_info *info,
 			desc->device_addr.mode = IEEE802154_ADDR_SHORT;
 			desc->device_addr.short_addr = nla_get_shortaddr(info->attrs[IEEE802154_ATTR_SHORT_ADDR]);
 		} else {
+			if (!info->attrs[IEEE802154_ATTR_HW_ADDR])
+				return -EINVAL;
+
 			desc->device_addr.mode = IEEE802154_ADDR_LONG;
 			desc->device_addr.extended_addr = nla_get_hwaddr(info->attrs[IEEE802154_ATTR_HW_ADDR]);
 		}
-- 
2.30.2

