Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82FE35CC8B
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244875AbhDLQ3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:29:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244634AbhDLQ05 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:26:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EE4C61387;
        Mon, 12 Apr 2021 16:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244706;
        bh=jNAeqwGvDpM6LJeCcQuu/H6t0WfjtqYstcKkuFlctXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOT/ivJu7bBI3Qk3/H/1bk9X3Yn9XV+Osh2B40wZaxjiagRuJ8UEBfnqU7Wfgd+UG
         Jq4C4vwzFYdK5tml8HmWnAy6a+jCqwbrinM9Jy4zEZrfJTn/F4AWC5SzPzkTTUwMn9
         P3glr8sdWvQGrRdOxaIiaEhDZeusLen+n9NHOJeZnPHRHstueVTccwMa/lWo8LH1af
         VjNaYG1IGgT34yVqgPLX6waManJ8yJot0mgGUXz9trzK/iMFxZVB8k++dEblB3kc+h
         47T36blliwAejdv9GhUZyYy44GicRcX1DtW+7c6+TIMyr4bAacl0Nnq33ZtRdW9CuX
         uQmmBlK1EwmIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        syzbot+ce4e062c2d51977ddc50@syzkaller.appspotmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/39] net: ieee802154: fix nl802154 add llsec key
Date:   Mon, 12 Apr 2021 12:24:25 -0400
Message-Id: <20210412162502.314854-3-sashal@kernel.org>
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

[ Upstream commit 20d5fe2d7103f5c43ad11a3d6d259e9d61165c35 ]

This patch fixes a nullpointer dereference if NL802154_ATTR_SEC_KEY is
not set by the user. If this is the case nl802154 will return -EINVAL.

Reported-by: syzbot+ce4e062c2d51977ddc50@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210221174321.14210-3-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 829696a3e2c7..43003108be95 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1560,7 +1560,8 @@ static int nl802154_add_llsec_key(struct sk_buff *skb, struct genl_info *info)
 	struct ieee802154_llsec_key_id id = { };
 	u32 commands[NL802154_CMD_FRAME_NR_IDS / 32] = { };
 
-	if (nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
+	if (!info->attrs[NL802154_ATTR_SEC_KEY] ||
+	    nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
 		return -EINVAL;
 
 	if (!attrs[NL802154_KEY_ATTR_USAGE_FRAMES] ||
-- 
2.30.2

