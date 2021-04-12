Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E303335CB0F
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243344AbhDLQX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:23:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243290AbhDLQXX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DEC66101B;
        Mon, 12 Apr 2021 16:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244584;
        bh=queHXL5nUUS7iNmoJELJgIFWWQiEhQewqh+vlgsM25M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLlLB+ZKfVrrQrFhaouh2h7/INEqhP+pf3ctUD2qgos8MWpJv2WegcI1tslCXBr40
         pAWQjyFxVdJiDdCA6dHWfgsB/Qvat9Zx6Uu28jXshpC3NiBuY+5i0EP1FxPJB9H+YK
         g025OfgNFVzXgv7tQ54e2lVT4Ndu7q9i5byVQI3sKNJ6UXdhwz2EymRktNiLC7Iaxt
         IPQ8V91BnyOB7RvFoii6g/FYitDkmY5AhksXwRS31HcZrAnLk4P7x7udQDp5zQ3hZR
         Hko8gEfmPgUJkDpY/5JguLRtfP2FBHU3u1EbHq7Qyrc41awg9/Sc+Dgnek3n7pp0bn
         zjfqRfQ9NGZlg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        syzbot+d4c07de0144f6f63be3a@syzkaller.appspotmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 05/51] net: ieee802154: nl-mac: fix check on panid
Date:   Mon, 12 Apr 2021 12:22:10 -0400
Message-Id: <20210412162256.313524-5-sashal@kernel.org>
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
index 9c640d670ffe..0c1b0770c59e 100644
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

