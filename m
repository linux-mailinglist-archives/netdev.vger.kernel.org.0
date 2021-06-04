Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06EB439B80F
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 13:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhFDLi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 07:38:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32811 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229962AbhFDLi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 07:38:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622806600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cmT1HrZEfeL82Y23E0J70CYdtkS00cX34Xo3Q2BxNG4=;
        b=UX+QH+7OHo/ylUMBO7uS3/xT4gaDKLlQUh8UMG0d3YS5Urddt6PWuWqjbqGyQmzBcdeALr
        l3bcKCuKrgJr04GdPoxzgj9TAbTRiWIhYZzIvN+923asw33i1DAbR3aYx4eXUxhelzFbvH
        tOrBKO5OFgpETzw9LFevtr/hRbNfBWc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-h0P-z7AxNweIe4sGF7twrw-1; Fri, 04 Jun 2021 07:36:39 -0400
X-MC-Unique: h0P-z7AxNweIe4sGF7twrw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 422376D5C0;
        Fri,  4 Jun 2021 11:36:38 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-201.ams2.redhat.com [10.36.112.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3239F5C26D;
        Fri,  4 Jun 2021 11:36:36 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org
Cc:     ihuguet@redhat.com, ivecera@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hdanton@sina.com
Subject: [PATCH] net:cxgb3: fix incorrect work cancellation
Date:   Fri,  4 Jun 2021 13:36:33 +0200
Message-Id: <20210604113633.21183-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In my last changes in commit 5e0b8928927f I introduced a copy-paste bug,
leading to cancel twice qresume_task work for OFLD queue, and never the
one for CTRL queue. This patch cancels correctly both works.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/chelsio/cxgb3/sge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index fa91aa57b50a..d1dfccdf571d 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -3310,7 +3310,7 @@ void t3_sge_stop(struct adapter *adap)
 		struct sge_qset *qs = &adap->sge.qs[i];
 
 		cancel_work_sync(&qs->txq[TXQ_OFLD].qresume_task);
-		cancel_work_sync(&qs->txq[TXQ_OFLD].qresume_task);
+		cancel_work_sync(&qs->txq[TXQ_CTRL].qresume_task);
 	}
 }
 
-- 
2.31.1

