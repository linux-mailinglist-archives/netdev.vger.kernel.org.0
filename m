Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506863272FA
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 16:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhB1PUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 10:20:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230473AbhB1PT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 10:19:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614525511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/N9mjJW3W0eC4wzSlguu9RYpB4AfVEyqkbrMcjAVPcs=;
        b=GaXMvyiAjy5s0loAjpwVDccLq2xL9BgSp/uv9oAw+cHABUi+H+UyOL/ojf/YVv/1Up1Am5
        9UfiKQe29tv+AFgFBSeG5pyEOw/00rqu4y2AQ/M6IU3zS2+r5VZyy35Qibde8M7w57eCZ0
        3bTiCzQSFwKma1pYR16Z51vcRgdrXlA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-RUtnEo6NMPWdhuH0A9qMZQ-1; Sun, 28 Feb 2021 10:18:28 -0500
X-MC-Unique: RUtnEo6NMPWdhuH0A9qMZQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D739B1936B61;
        Sun, 28 Feb 2021 15:18:27 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-112-225.rdu2.redhat.com [10.10.112.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 714885C1D5;
        Sun, 28 Feb 2021 15:18:27 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH wpan 10/17] net: ieee802154: forbid monitor for del llsec dev
Date:   Sun, 28 Feb 2021 10:18:10 -0500
Message-Id: <20210228151817.95700-11-aahringo@redhat.com>
In-Reply-To: <20210228151817.95700-1-aahringo@redhat.com>
References: <20210228151817.95700-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch forbids to del llsec dev for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index c32e55f961c2..46faf451f413 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1781,6 +1781,9 @@ static int nl802154_del_llsec_dev(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *attrs[NL802154_DEV_ATTR_MAX + 1];
 	__le64 extended_addr;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (!info->attrs[NL802154_ATTR_SEC_DEVICE] ||
 	    nla_parse_nested_deprecated(attrs, NL802154_DEV_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVICE], nl802154_dev_policy, info->extack))
 		return -EINVAL;
-- 
2.26.2

