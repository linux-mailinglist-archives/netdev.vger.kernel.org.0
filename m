Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2D5320C1C
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 18:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbhBURpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 12:45:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57059 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230079AbhBURpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 12:45:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613929418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RNXjcg6pEwN2fcgXqy2YL1L3IVwb8rvCfI7dQc3q99I=;
        b=EsmS4D+lZUEtEko8ijcQGqkAeHWbH/mZJailolM+maPfm+cnOWPVIqfH5se2ldi+ceRtNk
        vnkEAaV7taE6UHfdvXl8J3LEAl+jnLSOYEK9kMJUo25EDnxKFlY8MW9TM2NTe8OGtXwvLi
        063iXLiQ4GRr1LSRrWaIN1vIg1kNKls=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-q0n9tBLaNcu2sx5fpw-Zfg-1; Sun, 21 Feb 2021 12:43:34 -0500
X-MC-Unique: q0n9tBLaNcu2sx5fpw-Zfg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DCAE801965;
        Sun, 21 Feb 2021 17:43:33 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-112-235.rdu2.redhat.com [10.10.112.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92C7D1346F;
        Sun, 21 Feb 2021 17:43:32 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH wpan 1/4] net: ieee802154: fix nl802154 del llsec key
Date:   Sun, 21 Feb 2021 12:43:18 -0500
Message-Id: <20210221174321.14210-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a nullpointer dereference if NL802154_ATTR_SEC_KEY is
not set by the user. If this is the case nl802154 will return -EINVAL.

Reported-by: syzbot+ac5c11d2959a8b3c4806@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 net/ieee802154/nl802154.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 7c5a1aa5adb4..2f0a138bd5eb 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1592,7 +1592,8 @@ static int nl802154_del_llsec_key(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *attrs[NL802154_KEY_ATTR_MAX + 1];
 	struct ieee802154_llsec_key_id id;
 
-	if (nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
+	if (!info->attrs[NL802154_ATTR_SEC_KEY] ||
+	    nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
 		return -EINVAL;
 
 	if (ieee802154_llsec_parse_key_id(attrs[NL802154_KEY_ATTR_ID], &id) < 0)
-- 
2.26.2

