Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910A63272FE
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 16:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhB1PVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 10:21:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43627 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230495AbhB1PT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 10:19:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614525512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qbHjWMdzSnO9u6fOOnNr8/pV6qnRvnT5ATDhbRpeEPc=;
        b=gi6+BYvwLLVGnhzuNjIUKPmmi4n8Go7QEupKrGaxyR2/KeZuvoi0GQVtF2fbbF31NHUDjH
        eqxRZuk9nok86Yy2PLraA5izoiXvyVo073doUilXyjpx/gAukAw+CJjDSGJ6BDv2s6oro7
        C7ewoPRU6AzHoWzfbylddOSqhKj9f+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-tf3H-480MYy1PIjG7Ku5uw-1; Sun, 28 Feb 2021 10:18:28 -0500
X-MC-Unique: tf3H-480MYy1PIjG7Ku5uw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DBD61936B60;
        Sun, 28 Feb 2021 15:18:27 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-112-225.rdu2.redhat.com [10.10.112.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBC7C5C1D5;
        Sun, 28 Feb 2021 15:18:26 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH wpan 09/17] net: ieee802154: forbid monitor for add llsec dev
Date:   Sun, 28 Feb 2021 10:18:09 -0500
Message-Id: <20210228151817.95700-10-aahringo@redhat.com>
In-Reply-To: <20210228151817.95700-1-aahringo@redhat.com>
References: <20210228151817.95700-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch forbids to add llsec dev for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 7f728d85e9b6..c32e55f961c2 100644
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
2.26.2

