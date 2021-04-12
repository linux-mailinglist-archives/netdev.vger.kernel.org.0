Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C3735CD20
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245043AbhDLQds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:33:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245064AbhDLQbj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:31:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 893E0613B8;
        Mon, 12 Apr 2021 16:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244770;
        bh=cipkI2R4wewVzpszPx2BUvIZojTZ/k31RMG6xNHv1G0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLh+ZQQH6u9RrUdVZQARxv7Gh/1mvsBh0hVgWeJK/coly5tNdGhsRwULl1b6TzIrU
         iRpe0MHlJhNd/mMeiqK2AaC45H59vHQo8SD2MbBl2z04bfyHLCgmyYaXEWyeZBeE4j
         1BZRrCUE+i/FXlmhSOFtmA3dV7LHvVYiujf4/X1hnCCM1YXXSLN1VE53cIxMCON8rT
         7v90uUC63e3FuRaMu9uvyNCFDs6lqjLHa4vq5E7h4uCijD1/No2QChk6NkMv5pNdV1
         4JiPkiM2+tkiLa8TQTKFNdjzgcJYvfek9asTK2p3QtbfuA4t1RaYC05fCapKISkPZb
         B4PeZsoNkJBTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        syzbot+8b6719da8a04beeafcc3@syzkaller.appspotmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/28] net: ieee802154: forbid monitor for set llsec params
Date:   Mon, 12 Apr 2021 12:25:38 -0400
Message-Id: <20210412162553.315227-13-sashal@kernel.org>
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

[ Upstream commit 88c17855ac4291fb462e13a86b7516773b6c932e ]

This patch forbids to set llsec params for monitor interfaces which we
don't support yet.

Reported-by: syzbot+8b6719da8a04beeafcc3@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-3-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 99f6c254ea77..e07624fd8b3b 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1402,6 +1402,9 @@ static int nl802154_set_llsec_params(struct sk_buff *skb,
 	u32 changed = 0;
 	int ret;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (info->attrs[NL802154_ATTR_SEC_ENABLED]) {
 		u8 enabled;
 
-- 
2.30.2

