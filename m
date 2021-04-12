Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A8B35CC31
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244209AbhDLQ1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244247AbhDLQZa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:25:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A51D461241;
        Mon, 12 Apr 2021 16:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244683;
        bh=pmRi6S6i6sW0VoYRe5IUjCSS588C2lkOCx7WMEzmfmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2eIQxUmzEyUjVFrJllyPV50JOKzVjCI1yKBolALJc1SxSej9fFEP0aLKIwb/K86Q
         1OcwRQcZNLdsM3ifJaZZUNoPjQwyYOaFPbe19QBjlnTREECt6719VcPfCqa36GATj7
         boew7a29yY2bFxsKzadyxhdOEge6RFlkakyDB4N/UQgNiHm+G+w01o9lEd04SzZzej
         7GuZ3gLMUgjY39Ah8liQ7UX37bTrJwrB/3mVp4McyMhJCQSBa41qLWm+HNO8HREtfj
         5JbONkJlIxg0XQC6ivaDGby3kbewUXMA0cC5xe4iCz/KTGiGI6IcQqf8DK528CEPnJ
         r8GzZ33C4g/ww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 33/46] net: ieee802154: forbid monitor for del llsec devkey
Date:   Mon, 12 Apr 2021 12:23:48 -0400
Message-Id: <20210412162401.314035-33-sashal@kernel.org>
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

[ Upstream commit 6fb8045319ef172dc88a8142e7f8b58c7608137e ]

This patch forbids to del llsec devkey for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-12-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 1e437de5e7c9..f1f3af618039 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1949,6 +1949,9 @@ static int nl802154_del_llsec_devkey(struct sk_buff *skb, struct genl_info *info
 	struct ieee802154_llsec_device_key key;
 	__le64 extended_addr;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (!info->attrs[NL802154_ATTR_SEC_DEVKEY] ||
 	    nla_parse_nested_deprecated(attrs, NL802154_DEVKEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVKEY], nl802154_devkey_policy, info->extack))
 		return -EINVAL;
-- 
2.30.2

