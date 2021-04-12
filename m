Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B35135CE25
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245656AbhDLQmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:42:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245539AbhDLQhv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:37:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24E79613DD;
        Mon, 12 Apr 2021 16:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244872;
        bh=UMjl1JdBi9hDtsmjt7WBWA/FxwH3EAEIdX+REREdI7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PFv5ePlvaWtGoNG8HU9q003lsVFfMHZfJS5QnVmlq5/sBDJXb0oChuYJYY+1OZ2oD
         G/uEo0783hVR29PpZca9wywH6aLi3LNZyfK6ExdZPB5mO7PbbTpNqRCI/vtKKzo2qm
         3lsnePVxZhe4Xi65Ffep8U61UZT5jjdgXKf2JDdBL0t6mawFcedank/bbIzdYQUjl1
         cNIACu2+95GC4BrhQQitpkoHIwRSEdI8ebHjwoR/8msf8HTd7oX7UewoZUKvXvh5Q5
         TcjGjOhI7eAQbCFRY4SQW/CMws2jlkXIKGBGnbnCtvIC9f/uhY8JGxFUcK6Wr6Yt4i
         TEdw8C9/THyAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 12/23] net: ieee802154: forbid monitor for add llsec dev
Date:   Mon, 12 Apr 2021 12:27:25 -0400
Message-Id: <20210412162736.316026-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162736.316026-1-sashal@kernel.org>
References: <20210412162736.316026-1-sashal@kernel.org>
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
index 19a900292f20..8d22b1a68835 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1743,6 +1743,9 @@ static int nl802154_add_llsec_dev(struct sk_buff *skb, struct genl_info *info)
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

