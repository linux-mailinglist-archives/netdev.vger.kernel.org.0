Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4DB140F436
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 10:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245411AbhIQIf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 04:35:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38616 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245399AbhIQIfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 04:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631867670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mRvAXPuRtiVqIbpRHkAvC3odeA7PfoFZ93jl+i/JzVM=;
        b=bMZKrX9kZ6wlBOE0wcjyf/Bx/3+ZwCFe/I4LvtsIQQwQ/Jk8BXbS+/M9BD5k4ZFqo+CrkN
        lm3dwetv2O83RY6kHRfV/htj4QUQnAWxhX8MfPtYweUxQylhvIfjZGxyylFUtZpNNX8Qa4
        bC0h4wlpUE4FnGM4A3+SlQm1cCkrJKQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-wt9JcRDnMlChs4kvkhcd6g-1; Fri, 17 Sep 2021 04:34:29 -0400
X-MC-Unique: wt9JcRDnMlChs4kvkhcd6g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 480F01006AAA;
        Fri, 17 Sep 2021 08:34:27 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-234.pek2.redhat.com [10.72.12.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B42A60C82;
        Fri, 17 Sep 2021 08:34:08 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH net] virtio-net: fix pages leaking when building skb in big mode
Date:   Fri, 17 Sep 2021 16:34:06 +0800
Message-Id: <20210917083406.75602-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We try to use build_skb() if we had sufficient tailroom. But we forget
to release the unused pages chained via private in big mode which will
leak pages. Fixing this by release the pages after building the skb in
big mode.

Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 271d38c1d9f8..79bd2585ec6b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -423,6 +423,10 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 
 		skb_reserve(skb, p - buf);
 		skb_put(skb, len);
+
+		page = (struct page *)page->private;
+		if (page)
+			give_pages(rq, page);
 		goto ok;
 	}
 
-- 
2.25.1

