Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6899B35CC6F
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243721AbhDLQ2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243546AbhDLQ0a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:26:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33EF961379;
        Mon, 12 Apr 2021 16:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244698;
        bh=ZlYDUGOp6vu9r2PonruhRKU3ed5UEZlWik0Tk17Umgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKsx5UexC3pN0tmuSA/pIJUxHrGTffDO84S/wGLbCZVATBAIkMrI6SfNGr8s563mP
         UsSWbFINR3+c2RqRT/yly7tTVFqlBM71ftGgPUJxDhCI7IGKwOBu0qRXLEmU7IpeWo
         NVE18yZnQKnNSdCc3vcKsRCSA/HjxJDn8XtByhANaBtet5usUgLdnrOAeW9LY7rMav
         JYFQ+p7QfTOX5Q8VVEJMGQSnU6lZ+dWSzbPKpvoqctS5gXj6cWVJjL57KQttpx7Ekt
         dgy1wNK6Dt8DkfOn7nVB7uvElkRsOWneKq8IEn8l0iaU+UoyVoxUkbLdcOb/bBoH5j
         D3Mc9aU63w0ww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Du Cheng <ducheng2@gmail.com>,
        syzbot+5f9392825de654244975@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 44/46] cfg80211: remove WARN_ON() in cfg80211_sme_connect
Date:   Mon, 12 Apr 2021 12:23:59 -0400
Message-Id: <20210412162401.314035-44-sashal@kernel.org>
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

From: Du Cheng <ducheng2@gmail.com>

[ Upstream commit 1b5ab825d9acc0f27d2f25c6252f3526832a9626 ]

A WARN_ON(wdev->conn) would trigger in cfg80211_sme_connect(), if multiple
send_msg(NL80211_CMD_CONNECT) system calls are made from the userland, which
should be anticipated and handled by the wireless driver. Remove this WARN_ON()
to prevent kernel panic if kernel is configured to "panic_on_warn".

Bug reported by syzbot.

Reported-by: syzbot+5f9392825de654244975@syzkaller.appspotmail.com
Signed-off-by: Du Cheng <ducheng2@gmail.com>
Link: https://lore.kernel.org/r/20210407162756.6101-1-ducheng2@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/sme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 38df713f2e2e..060e365c8259 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -530,7 +530,7 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 		cfg80211_sme_free(wdev);
 	}
 
-	if (WARN_ON(wdev->conn))
+	if (wdev->conn)
 		return -EINPROGRESS;
 
 	wdev->conn = kzalloc(sizeof(*wdev->conn), GFP_KERNEL);
-- 
2.30.2

