Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CF735CBDC
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244301AbhDLQZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243601AbhDLQYE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:24:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F17161289;
        Mon, 12 Apr 2021 16:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244626;
        bh=3MSVkPhV+KfUdNhYtPdolmQDFfe1PHftrcVloIvNmgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUirpE/GURHgsGV7ThjYg9ZfVaD6wAg/cxN5+4jF4wHG7yDVyR0jWqtAOXDnazFv1
         pvjMwZUjrfEGMnWlBbt/jmCy8aFjZY0vGLDcmo3YruVV8k0CwPNVkXNo21dMjtxrVO
         2wpNx0pYKtSf3ujtU6l8s0yrhIDheADRWYayXxtQLYWXBkVIy8whXcnRU0SWW9zK64
         Id6K/NsWnvVaVSclQK4UH3PMT2hx2xUbA5ziRtI9rI/imDFeJeqVoSzAUsWo5gsiu+
         uacVlGfg2YwGILMgCPYQZIS9Dfw0ynM53LDdEmAd1aH410AZBHeho9NTkRCsPCjjeD
         32yhf5WI9LtQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        syzbot+fbf4fc11a819824e027b@syzkaller.appspotmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 40/51] net: ieee802154: forbid monitor for del llsec seclevel
Date:   Mon, 12 Apr 2021 12:22:45 -0400
Message-Id: <20210412162256.313524-40-sashal@kernel.org>
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

[ Upstream commit 9dde130937e95b72adfae64ab21d6e7e707e2dac ]

This patch forbids to del llsec seclevel for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Reported-by: syzbot+fbf4fc11a819824e027b@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-15-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index c2e9d133e5fc..edd09eb7bf6d 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2133,6 +2133,9 @@ static int nl802154_del_llsec_seclevel(struct sk_buff *skb,
 	struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
 	struct ieee802154_llsec_seclevel sl;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (!info->attrs[NL802154_ATTR_SEC_LEVEL] ||
 	    llsec_parse_seclevel(info->attrs[NL802154_ATTR_SEC_LEVEL],
 				 &sl) < 0)
-- 
2.30.2

