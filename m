Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7614E2FBD15
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 18:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389515AbhASQ7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 11:59:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56234 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389995AbhASQ6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 11:58:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611075430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=48FwshhjZ+G2oqgIV5odTogbJUPrwxPmjTGXHjXAe4w=;
        b=RU1RhMKqylsGBlcffPlUQsCOeXlwFFpCaVDTTpVQLUNibAnQGXf2HU+KRaM2jU7udqEBoC
        yUTMWp9Ve1UwNFUM8UESNSRACnKwBMyINHCw7yFpYgqVnN7a4n5AmSZypZnV9QMbiHi3pq
        MTgLFDC64aU+NyK+k+jBw2zHBuYMYCY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-7bRAmpjIMh6GYMqYG6OAqQ-1; Tue, 19 Jan 2021 11:57:07 -0500
X-MC-Unique: 7bRAmpjIMh6GYMqYG6OAqQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD4371005504;
        Tue, 19 Jan 2021 16:57:04 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-139.ams2.redhat.com [10.36.115.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3EBEF60C0F;
        Tue, 19 Jan 2021 16:57:03 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Xin Long <lucien.xin@gmail.com>
Subject: [PATCH v2 net-next] net: fix GSO for SG-enabled devices.
Date:   Tue, 19 Jan 2021 17:56:56 +0100
Message-Id: <861947c2d2d087db82af93c21920ce8147d15490.1611074818.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit dbd50f238dec ("net: move the hsize check to the else
block in skb_segment") introduced a data corruption for devices
supporting scatter-gather.

The problem boils down to signed/unsigned comparison given
unexpected results: if signed 'hsize' is negative, it will be
considered greater than a positive 'len', which is unsigned.

This commit addresses resorting to the old checks order, so that
'hsize' never has a negative value when compared with 'len'.

v1 -> v2:
 - reorder hsize checks instead of explicit cast (Alex)

Bisected-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Fixes: dbd50f238dec ("net: move the hsize check to the else block in skb_segment")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/skbuff.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e835193cabcc3..cf2c4dcf42579 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3938,10 +3938,10 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 			skb_release_head_state(nskb);
 			__skb_push(nskb, doffset);
 		} else {
+			if (hsize < 0)
+				hsize = 0;
 			if (hsize > len || !sg)
 				hsize = len;
-			else if (hsize < 0)
-				hsize = 0;
 
 			nskb = __alloc_skb(hsize + doffset + headroom,
 					   GFP_ATOMIC, skb_alloc_rx_flag(head_skb),
-- 
2.26.2

