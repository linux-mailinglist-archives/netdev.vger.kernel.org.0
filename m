Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038F635CE23
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245367AbhDLQmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244635AbhDLQhP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:37:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B60D613E8;
        Mon, 12 Apr 2021 16:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244869;
        bh=XDHwsFDNW9WVpCrF13ZwTyoyVSHLssbVaOVoGAhNrB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/5/32fPMtj7QHEbf0Db3Vy8PNdzQIfBo1zmP0vqW9L6QNfU/DpvuItQJWxJCF2yp
         nGXuioVKK0pAu/Jgm9LwacTE2aWOOxlkpKZGT2jiaitlg6DtbRu+gQEsqNZtFXZA4b
         WDfk1yzHb9CI1j+9/9PgpMCrLWk9PiF1rK1zorDZ2KBpnV0Fvs2Z5DKUa37PmWHF4O
         yqv0ZkAW7Zuywq1HO3Zh9vrUFsvPj84V38qPTywleILcXsF458Xwe6I42tMeeXya+6
         as4Li3X2/CVxAtPZ7fkdF5btqHs54Od91wb0wS1kuXjkhJ3cahLyquNBwlZcKBftfH
         kxam7vNIEuDiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        syzbot+8b6719da8a04beeafcc3@syzkaller.appspotmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 09/23] net: ieee802154: forbid monitor for set llsec params
Date:   Mon, 12 Apr 2021 12:27:22 -0400
Message-Id: <20210412162736.316026-9-sashal@kernel.org>
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
index 16ef0d9f566e..746701424d79 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1367,6 +1367,9 @@ static int nl802154_set_llsec_params(struct sk_buff *skb,
 	u32 changed = 0;
 	int ret;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (info->attrs[NL802154_ATTR_SEC_ENABLED]) {
 		u8 enabled;
 
-- 
2.30.2

