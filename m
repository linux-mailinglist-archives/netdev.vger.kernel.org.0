Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA623272FF
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 16:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhB1PWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 10:22:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26176 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230409AbhB1PT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 10:19:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614525513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=roKbvdchfdha4OXRhxovDmvW8qahWbulZ67jfkOsE40=;
        b=XkNtCl8kvaC8BSMTk611oj72tcpo8wEXbhryGDfMi0aAQaIRSWZ5ha0XQXBn7X/hFsUbsE
        4NQbqtsiKf5ky0eIX7QhBYRemaXGqOz5JmoRHPIieV7fb6DFiYmSqAP2pVSqzgdZbRqYZn
        M4C/1zLLURuQLfoA45kZG97e4t2qnBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-FvIX_5lvN9uQ49P17tkJtQ-1; Sun, 28 Feb 2021 10:18:31 -0500
X-MC-Unique: FvIX_5lvN9uQ49P17tkJtQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 443EF10066EE;
        Sun, 28 Feb 2021 15:18:30 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-112-225.rdu2.redhat.com [10.10.112.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D38A35C1D5;
        Sun, 28 Feb 2021 15:18:29 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH wpan 14/17] net: ieee802154: stop dump llsec seclevels for monitors
Date:   Sun, 28 Feb 2021 10:18:14 -0500
Message-Id: <20210228151817.95700-15-aahringo@redhat.com>
In-Reply-To: <20210228151817.95700-1-aahringo@redhat.com>
References: <20210228151817.95700-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch stops dumping llsec seclevels for monitors which we don't
support yet. Otherwise we will access llsec mib which isn't initialized
for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 net/ieee802154/nl802154.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index d0352148e34c..95a13a5b75d0 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2026,6 +2026,11 @@ nl802154_dump_llsec_seclevel(struct sk_buff *skb, struct netlink_callback *cb)
 	if (err)
 		return err;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR) {
+		err = skb->len;
+		goto out_err;
+	}
+
 	if (!wpan_dev->netdev) {
 		err = -EINVAL;
 		goto out_err;
-- 
2.26.2

