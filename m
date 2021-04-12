Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C6D35CD6C
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344097AbhDLQhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:37:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245093AbhDLQbn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:31:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E5A0613BA;
        Mon, 12 Apr 2021 16:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244774;
        bh=I+QGz5W+RmPCbdGqGZz+6DgotTIUJmxSaI3QOy068do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bPoho0EnQHMkxhTyATfer/z1kK0hj7cNWwNxrE7jYA0agCbEM3+UlOGLvlOwT2nOl
         mJGxFERzrPEhz56km1OS64wVnJkr14g6vi62jYg5NQdbHue1rEOgYmDd82Hnkbowf5
         i7SMuxe+pp+T2CrLMStrfwSS7reqe7h5C2wAs13iVw3z5uEdyL5yB+xTWIQPE/yYtb
         Y0pSNVI3JpebhgB9jqO+Eizd2W3v8NIvH9wtkZyPMCp4HurjTDUv1T5gHDKOoD5YX9
         DBmw5Jax9mAU/Dr+YcSEnwcldvQCqbCrce85ll+Y9BnIU78LnkXbVij3B0rrkuRXA9
         FS+EjFz7njnAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 16/28] net: ieee802154: forbid monitor for add llsec dev
Date:   Mon, 12 Apr 2021 12:25:41 -0400
Message-Id: <20210412162553.315227-16-sashal@kernel.org>
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

[ Upstream commit 5303f956b05a2886ff42890908156afaec0f95ac ]

This patch forbids to add llsec dev for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-8-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 3b870791075c..10858c31cb47 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1778,6 +1778,9 @@ static int nl802154_add_llsec_dev(struct sk_buff *skb, struct genl_info *info)
 	struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
 	struct ieee802154_llsec_device dev_desc;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (ieee802154_llsec_parse_device(info->attrs[NL802154_ATTR_SEC_DEVICE],
 					  &dev_desc) < 0)
 		return -EINVAL;
-- 
2.30.2

