Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDE2373BC4
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 14:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhEEM4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 08:56:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233051AbhEEM4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 08:56:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620219317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5/Hr/rgKSvr3/48grAcGfL3btvwIpqWZESlyqU89EvA=;
        b=RfArmWR8TYMPZ7lvMa3OinsEO3rYQYVi0MWE6d22GfnHi2YykWDCMAiizJzhPy+ny1IawJ
        wXO9JVCexmVyFfbl61jXbqZfUPnZzvmJoAMH72R3cym0c6ZwL77mVlhfp07T7+xENcGFHA
        rt/jtpbmhc1BNhwF8xthi9NIVX6zWjI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-z9zhlQMVPWWJIM27Vg8iCw-1; Wed, 05 May 2021 08:55:14 -0400
X-MC-Unique: z9zhlQMVPWWJIM27Vg8iCw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE8A51008062;
        Wed,  5 May 2021 12:55:12 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-211.ams2.redhat.com [10.36.112.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5C7D6062C;
        Wed,  5 May 2021 12:55:10 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     netdev@vger.kernel.org, rajur@chelsio.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Cc:     ivecera@redhat.com, ihuguet@redhat.com
Subject: [PATCH] net:CXGB4: fix leak if sk_buff is not used
Date:   Wed,  5 May 2021 14:54:50 +0200
Message-Id: <20210505125450.21737-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An sk_buff is allocated to send a flow control message, but it's not
sent in all cases: in case the state is not appropiate to send it or if
it can't be enqueued.

In the first of these 2 cases, the sk_buff was discarded but not freed,
producing a memory leak.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 256fae15e032..1e5f2edb70cf 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2563,12 +2563,12 @@ int cxgb4_ethofld_send_flowc(struct net_device *dev, u32 eotid, u32 tc)
 	spin_lock_bh(&eosw_txq->lock);
 	if (tc != FW_SCHED_CLS_NONE) {
 		if (eosw_txq->state != CXGB4_EO_STATE_CLOSED)
-			goto out_unlock;
+			goto out_free_skb;
 
 		next_state = CXGB4_EO_STATE_FLOWC_OPEN_SEND;
 	} else {
 		if (eosw_txq->state != CXGB4_EO_STATE_ACTIVE)
-			goto out_unlock;
+			goto out_free_skb;
 
 		next_state = CXGB4_EO_STATE_FLOWC_CLOSE_SEND;
 	}
@@ -2604,17 +2604,19 @@ int cxgb4_ethofld_send_flowc(struct net_device *dev, u32 eotid, u32 tc)
 		eosw_txq_flush_pending_skbs(eosw_txq);
 
 	ret = eosw_txq_enqueue(eosw_txq, skb);
-	if (ret) {
-		dev_consume_skb_any(skb);
-		goto out_unlock;
-	}
+	if (ret)
+		goto out_free_skb;
 
 	eosw_txq->state = next_state;
 	eosw_txq->flowc_idx = eosw_txq->pidx;
 	eosw_txq_advance(eosw_txq, 1);
 	ethofld_xmit(dev, eosw_txq);
 
-out_unlock:
+	spin_unlock_bh(&eosw_txq->lock);
+	return 0;
+
+out_free_skb:
+	dev_consume_skb_any(skb);
 	spin_unlock_bh(&eosw_txq->lock);
 	return ret;
 }
-- 
2.31.1

