Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8568B320C1E
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 18:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhBURpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 12:45:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26891 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229844AbhBURpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 12:45:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613929418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8VgaRV7Fd9A+gYNGoaLn/LCYYkPGKOfSnguHXEuxcJE=;
        b=KpocSHh/4zDNnLouqT/ZBQS99kA9T4sDbQl58ANwKDK81zeBAE0DqOU7MelipuQVibNtdR
        4nPoZEUpzPFnP4ERMe6kr7vuPit613WyIr24svsjII1J1vPS6DnHJmGusg4DGoy4T2momn
        2vaQHh2HdUj4Ac1faGFHWRTKhKMLxIs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-Muv1seoRPkWbg_Lhd79lcw-1; Sun, 21 Feb 2021 12:43:36 -0500
X-MC-Unique: Muv1seoRPkWbg_Lhd79lcw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED48A801979;
        Sun, 21 Feb 2021 17:43:34 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-112-235.rdu2.redhat.com [10.10.112.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 842482BFE1;
        Sun, 21 Feb 2021 17:43:34 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH wpan 4/4] net: ieee802154: fix nl802154 del llsec devkey
Date:   Sun, 21 Feb 2021 12:43:21 -0500
Message-Id: <20210221174321.14210-4-aahringo@redhat.com>
In-Reply-To: <20210221174321.14210-1-aahringo@redhat.com>
References: <20210221174321.14210-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a nullpointer dereference if NL802154_ATTR_SEC_DEVKEY is
not set by the user. If this is the case nl802154 will return -EINVAL.

Reported-by: syzbot+368672e0da240db53b5f@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 net/ieee802154/nl802154.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 3f6d86d63923..e9e4652cd592 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1916,7 +1916,8 @@ static int nl802154_del_llsec_devkey(struct sk_buff *skb, struct genl_info *info
 	struct ieee802154_llsec_device_key key;
 	__le64 extended_addr;
 
-	if (nla_parse_nested_deprecated(attrs, NL802154_DEVKEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVKEY], nl802154_devkey_policy, info->extack))
+	if (!info->attrs[NL802154_ATTR_SEC_DEVKEY] ||
+	    nla_parse_nested_deprecated(attrs, NL802154_DEVKEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVKEY], nl802154_devkey_policy, info->extack))
 		return -EINVAL;
 
 	if (!attrs[NL802154_DEVKEY_ATTR_EXTENDED_ADDR])
-- 
2.26.2

