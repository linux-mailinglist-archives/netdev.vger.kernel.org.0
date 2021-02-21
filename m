Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C2C320C1F
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 18:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhBURpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 12:45:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46469 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230080AbhBURpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 12:45:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613929419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=veEkBduKmRsVQSCI1fPx3giWU2w1iYFYp57+YGlkdNg=;
        b=Vu0RrcWIvppbfJPY9VJ1IAIgGf/BzM9hp6GMZFlRYIl6jPnakF97ADXY/tyb94MA1MNSoi
        tKUkHcDpCZ17GuPBlHI8+faYrSIKtD0ffNvr2/dmwa/JIsFrc366tz9lFVNHALDSK5SK6g
        xSIoBI4Fww9gkfJ+S/Tfeekm5SbIuUQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-8tz9E9PcOk-MA-rHgGBbnA-1; Sun, 21 Feb 2021 12:43:35 -0500
X-MC-Unique: 8tz9E9PcOk-MA-rHgGBbnA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AE446EE20;
        Sun, 21 Feb 2021 17:43:33 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-112-235.rdu2.redhat.com [10.10.112.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31C311346F;
        Sun, 21 Feb 2021 17:43:33 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH wpan 2/4] net: ieee802154: fix nl802154 del llsec dev
Date:   Sun, 21 Feb 2021 12:43:19 -0500
Message-Id: <20210221174321.14210-2-aahringo@redhat.com>
In-Reply-To: <20210221174321.14210-1-aahringo@redhat.com>
References: <20210221174321.14210-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a nullpointer dereference if NL802154_ATTR_SEC_DEVICE is
not set by the user. If this is the case nl802154 will return -EINVAL.

Reported-by: syzbot+d946223c2e751d136c94@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 net/ieee802154/nl802154.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 2f0a138bd5eb..063b12cba71f 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1758,7 +1758,8 @@ static int nl802154_del_llsec_dev(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *attrs[NL802154_DEV_ATTR_MAX + 1];
 	__le64 extended_addr;
 
-	if (nla_parse_nested_deprecated(attrs, NL802154_DEV_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVICE], nl802154_dev_policy, info->extack))
+	if (!info->attrs[NL802154_ATTR_SEC_DEVICE] ||
+	    nla_parse_nested_deprecated(attrs, NL802154_DEV_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVICE], nl802154_dev_policy, info->extack))
 		return -EINVAL;
 
 	if (!attrs[NL802154_DEV_ATTR_EXTENDED_ADDR])
-- 
2.26.2

