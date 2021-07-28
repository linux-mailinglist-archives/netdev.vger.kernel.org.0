Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6141A3D9323
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhG1QYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:24:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49484 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230213AbhG1QYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:24:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627489479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+TeIpvJ1BAVpAfhn5njvcI5dr+DIMci7+nWCkodmJl0=;
        b=TRvQwgdpcwjvV66gFi/mqddXw+/14hYAUNBpOgBgPJykjcEH37vcX2Oh1JhLCMHcMn8u5b
        OsVxM+5tE66Dc82MfUQcJbTcF7mPXZBH6Q+J5qu6qoKpr3ygqxC0R91N1101Eg8ab7Zg1F
        KmV051tkyJDfIDrMXakCHznvzEFotGA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-6MuXRCX1P56kbxlUR6GgXw-1; Wed, 28 Jul 2021 12:24:37 -0400
X-MC-Unique: 6MuXRCX1P56kbxlUR6GgXw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3E39760C8;
        Wed, 28 Jul 2021 16:24:36 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-169.ams2.redhat.com [10.36.113.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BAD35C1B4;
        Wed, 28 Jul 2021 16:24:35 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 3/6] sk_buff: track extension status in slow_gro
Date:   Wed, 28 Jul 2021 18:24:01 +0200
Message-Id: <a0c30fb003ea140ee09cf739e3044347e4282f56.1627405778.git.pabeni@redhat.com>
In-Reply-To: <cover.1627405778.git.pabeni@redhat.com>
References: <cover.1627405778.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the previous one, but tracking the
active_extensions field status.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/skbuff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 517ee2c36425..a990e11c393c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6455,6 +6455,7 @@ void *skb_ext_add(struct sk_buff *skb, enum skb_ext_id id)
 	new->chunks = newlen;
 	new->offset[id] = newoff;
 set_active:
+	skb->slow_gro = 1;
 	skb->extensions = new;
 	skb->active_extensions |= 1 << id;
 	return skb_ext_get_ptr(new, id);
-- 
2.26.3

