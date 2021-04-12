Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF48835CE0F
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245708AbhDLQlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344015AbhDLQge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:36:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EE0660FD7;
        Mon, 12 Apr 2021 16:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244859;
        bh=kfdakB4MXOcNnahQzf8NSHcI8dYl4ooky6tyHqqLcKU=;
        h=From:To:Cc:Subject:Date:From;
        b=oBHNgm0JsZ79f85b/fQxJ+WFGXoBQiHwMEe9+/FEychA1tQ14TC9iMP6kIKBsX6Lk
         dceidglgFyqX5C4Yqk5XoijdnY9duXHsFcT2mepbTnRZKRTIO0UTlsHaNnMbI/L5gF
         +76Fc4bvcaUiXaFywboofRtNe2eLF5UMD+M7eaMqHOk3lZrrtxxdR5hAhz+m2Y1NhL
         C8v9WpAuyEpfnbpPd6ECFFaOuTntfCP+D2rZ9psw2ho6TIighWeQsymbnsTZinX/l2
         VtLKQaqdALZJmj71SV+L5+B3nPIMfZhTxhm7Jn4GF99ZS1WflkJGhBfBnSjKWVVlvv
         PP/G7TXMFsHoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        syzbot+d4c07de0144f6f63be3a@syzkaller.appspotmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 01/23] net: ieee802154: nl-mac: fix check on panid
Date:   Mon, 12 Apr 2021 12:27:14 -0400
Message-Id: <20210412162736.316026-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
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
index 3503c38954f9..76691a07a2e0 100644
--- a/net/ieee802154/nl-mac.c
+++ b/net/ieee802154/nl-mac.c
@@ -557,9 +557,7 @@ ieee802154_llsec_parse_key_id(struct genl_info *info,
 	desc->mode = nla_get_u8(info->attrs[IEEE802154_ATTR_LLSEC_KEY_MODE]);
 
 	if (desc->mode == IEEE802154_SCF_KEY_IMPLICIT) {
-		if (!info->attrs[IEEE802154_ATTR_PAN_ID] &&
-		    !(info->attrs[IEEE802154_ATTR_SHORT_ADDR] ||
-		      info->attrs[IEEE802154_ATTR_HW_ADDR]))
+		if (!info->attrs[IEEE802154_ATTR_PAN_ID])
 			return -EINVAL;
 
 		desc->device_addr.pan_id = nla_get_shortaddr(info->attrs[IEEE802154_ATTR_PAN_ID]);
@@ -568,6 +566,9 @@ ieee802154_llsec_parse_key_id(struct genl_info *info,
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

