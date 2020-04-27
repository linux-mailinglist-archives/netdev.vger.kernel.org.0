Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759561BAA2B
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 18:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgD0Qhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 12:37:52 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44775 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726499AbgD0Qhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 12:37:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588005471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=csl1hmYpPL8mhlstV3gAcCbXq6iZpL7GNW1YjSBjXWg=;
        b=d74iH/vcazFppJmamcDmNBtKb5yK36oMqoX8UTs9cqhTqZ9ToS6y2FHIA0tX5FpJQ74KVC
        osqkICqzaZ3dXJ/V/r5/JqDFCca4zTnEApC6QRB51BT2/dwNiZ11TK/GqAMB6sgXUlMir7
        7FWub6Zv3AMCUbnJt/0i0qBI1vDXVVI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-1LtbozPyOSSs-gHaQC3f7w-1; Mon, 27 Apr 2020 12:37:48 -0400
X-MC-Unique: 1LtbozPyOSSs-gHaQC3f7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BDC045F;
        Mon, 27 Apr 2020 16:37:47 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30C3C66060;
        Mon, 27 Apr 2020 16:37:44 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id A7B3730000272;
        Mon, 27 Apr 2020 18:37:43 +0200 (CEST)
Subject: [PATCH net-next] net: fix skb_panic to output real address
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, me@tobin.cc
Date:   Mon, 27 Apr 2020 18:37:43 +0200
Message-ID: <158800546361.1962096.4535216438507756179.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In skb_panic() the real pointer values are really needed to diagnose
issues, e.g. data and head are related (to calculate headroom). The
hashed versions of the addresses doesn't make much sense here. The
patch use the printk specifier %px to print the actual address.

The printk documentation on %px:
https://www.kernel.org/doc/html/latest/core-api/printk-formats.html#unmodified-addresses

Fixes: ad67b74d2469 ("printk: hash addresses printed with %p")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/skbuff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7e29590482ce..1bf0c3d278e7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -102,7 +102,7 @@ EXPORT_SYMBOL(sysctl_max_skb_frags);
 static void skb_panic(struct sk_buff *skb, unsigned int sz, void *addr,
 		      const char msg[])
 {
-	pr_emerg("%s: text:%p len:%d put:%d head:%p data:%p tail:%#lx end:%#lx dev:%s\n",
+	pr_emerg("%s: text:%px len:%d put:%d head:%px data:%px tail:%#lx end:%#lx dev:%s\n",
 		 msg, addr, skb->len, sz, skb->head, skb->data,
 		 (unsigned long)skb->tail, (unsigned long)skb->end,
 		 skb->dev ? skb->dev->name : "<NULL>");


