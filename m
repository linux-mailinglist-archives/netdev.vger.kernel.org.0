Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC3E35CC1A
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244056AbhDLQ1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:27:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244052AbhDLQZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:25:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF0D261289;
        Mon, 12 Apr 2021 16:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244678;
        bh=ERB2TuorPERWoiYpSCdrSnzqUHhaINVZft2pDls/WiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQTx5V3924jWQV6L7b8Il2i/eJfCgtDmkGMSWFJGtCzPnBhvA6bSjolEWxYGk0CEy
         8k4e4zb05Nu75cf29dJ3w9fPA4xl+0uocmzMeQjGmRx1D+9Aioshk7X/fhS3PXKPTO
         7732qj+xCTr/6NA7tOBHNvM+Neh7Cd495Irn75jQkekQwkoGHTJoIJ5cznLY0K8XDd
         dsE1+UG71OqQwWfdvfEJqi0Qwpxj1pMVezSiflUF/rbEeFCfRS3IKHm3fm0quel09y
         na9Uo4UtyRZ25iAa0LOYYAXbZCYvqCvYHAdwLJd7goRdUn5RsEFRPKvrMK/On73Ip6
         OFJHdw8T3yggw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 29/46] net: ieee802154: forbid monitor for add llsec dev
Date:   Mon, 12 Apr 2021 12:23:44 -0400
Message-Id: <20210412162401.314035-29-sashal@kernel.org>
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
index 39a81602e5b5..29aaeb094959 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1763,6 +1763,9 @@ static int nl802154_add_llsec_dev(struct sk_buff *skb, struct genl_info *info)
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

