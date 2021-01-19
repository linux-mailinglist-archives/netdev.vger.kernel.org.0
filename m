Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3D52FB8EB
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732068AbhASOB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 09:01:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56746 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393138AbhASMdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 07:33:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611059493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lEJP/GTD2F7xeOrpz7tftxb2cGM9XX10WDfz1YKvxjU=;
        b=QYvUNl7NhbLAWAk8+U2aLTYNEf3gnyvDrGKXR5/WL/TH7e11NpK6+Ui4LHWBiwow9shFLA
        JNHGe1u/cdzmNkHvguk2CWAFXf4xBCTC3QfRddty5veAtQT53s+QfTVa/e3dxzZKOjVtpx
        9qd+G8ZEjAJdg0JZB68Az81C5bVKm+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-bi-u0zy_OqmjY15JZmcfGg-1; Tue, 19 Jan 2021 07:31:31 -0500
X-MC-Unique: bi-u0zy_OqmjY15JZmcfGg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F7838066E5;
        Tue, 19 Jan 2021 12:31:30 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-139.ams2.redhat.com [10.36.115.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 880B161F47;
        Tue, 19 Jan 2021 12:31:28 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net-next] net: fix GSO for SG-enabled devices.
Date:   Tue, 19 Jan 2021 13:30:32 +0100
Message-Id: <61306401471dcfc6219d5c001580769c2c67377a.1611059420.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit dbd50f238dec ("net: move the hsize check to the else
block in skb_segment") introduced a data corruption for devices
supporting scatter-gather.

The problem boils down to signed/unsigned comparison given
unexpected results: if signed 'hsize' is negative, it will be
considered greater than a positive 'len', which is unsigned.

This commit addresses the issue explicitly casting 'len' to a
signed integer, so that the comparison gives the correct result.

Bisected-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Fixes: dbd50f238dec ("net: move the hsize check to the else block in skb_segment")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
note: a possible more readable alternative would be moving the
	if (hsize < 0)

before 'if (hsize > len)', but that was explicitly discouraged
in a previous iteration of the blamed commit to save a comparison,
so I opted to preserve that optimization.
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e835193cabcc3..27f69c0bd8393 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3938,7 +3938,7 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 			skb_release_head_state(nskb);
 			__skb_push(nskb, doffset);
 		} else {
-			if (hsize > len || !sg)
+			if (hsize > (int)len || !sg)
 				hsize = len;
 			else if (hsize < 0)
 				hsize = 0;
-- 
2.26.2

