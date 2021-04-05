Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54921353A5B
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 02:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbhDEAcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 20:32:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231727AbhDEAbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 20:31:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617582674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=npK8BY/FGAVwaaC/lhkdfNVd3nL+DQGeL0KtFJC0rq8=;
        b=XLuV256c+kLv5grn1zgBHxchAsKcYdcG5IBLYGs+g+rvtkOgC/uSX9GFxCvHwtkh/yDulw
        ey5OKL4srT4hT5YJITNoz2tgyPCkk3X4fLcc1V2MhEv3jP/hJPTBLdWqCQFW235gOW/dzz
        4jtDZU8APOv3NNXEo97gOXb71hDnnsM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-Q6kfSqflPiW_5WYs9xaNww-1; Sun, 04 Apr 2021 20:31:12 -0400
X-MC-Unique: Q6kfSqflPiW_5WYs9xaNww-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C880E107ACCD;
        Mon,  5 Apr 2021 00:31:11 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-113-102.rdu2.redhat.com [10.10.113.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 549DC37DD;
        Mon,  5 Apr 2021 00:31:11 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH RESEND wpan 12/15] net: ieee802154: stop dump llsec seclevels for monitors
Date:   Sun,  4 Apr 2021 20:30:51 -0400
Message-Id: <20210405003054.256017-13-aahringo@redhat.com>
In-Reply-To: <20210405003054.256017-1-aahringo@redhat.com>
References: <20210405003054.256017-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index 88735f03b73e..9158b095ccf9 100644
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
2.26.3

