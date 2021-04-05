Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FEC353A57
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 02:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhDEAbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 20:31:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42268 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231760AbhDEAbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 20:31:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617582672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VfCnJkta+8F2c4fJv7y9YIk7W0E2kwmAy5zrFL0vAsw=;
        b=jST3i3cbZJAU5Y2NX2NEwrvtRzpxbZMcld5Ei9GLJct2GyDSZCAGO+/p9IO8Zhabtm5vNK
        TjpaHrgs/RvBJEL6Xp6t9Jz5Zfa4ATb/HaLxyBjdvkyuvncvtpslRq9Krvw6pCqYQwYeuR
        FGe4JtCDeyB0S0gXavptyG2U4Nn+w7M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-l7QiYpoFOjSIz3rOvvxoMg-1; Sun, 04 Apr 2021 20:31:08 -0400
X-MC-Unique: l7QiYpoFOjSIz3rOvvxoMg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9D541007468;
        Mon,  5 Apr 2021 00:31:07 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-113-102.rdu2.redhat.com [10.10.113.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7568A37DD;
        Mon,  5 Apr 2021 00:31:07 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH RESEND wpan 06/15] net: ieee802154: stop dump llsec devs for monitors
Date:   Sun,  4 Apr 2021 20:30:45 -0400
Message-Id: <20210405003054.256017-7-aahringo@redhat.com>
In-Reply-To: <20210405003054.256017-1-aahringo@redhat.com>
References: <20210405003054.256017-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch stops dumping llsec devs for monitors which we don't support
yet. Otherwise we will access llsec mib which isn't initialized for
monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 net/ieee802154/nl802154.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index bfc0eca774e3..ef0becc9faa7 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1672,6 +1672,11 @@ nl802154_dump_llsec_dev(struct sk_buff *skb, struct netlink_callback *cb)
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

