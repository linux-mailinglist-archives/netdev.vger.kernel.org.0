Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEBC21F2FE
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgGNNuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:50:52 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38428 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725906AbgGNNuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 09:50:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594734650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc; bh=Eoga+Mdleam2+PFUQQVvh+tI5hcjfog78flkltDgmv4=;
        b=Q/PP4Oo/ld3cpKUOok6AwJO8jC1huqAmnuu+gqBl4jMu4Bjk66qJ0/o61PMxJwKmO4bBmM
        Rufab7L5T1DWOt4OWYGUlF4lfOGC3w3Sg00bzb5KrRSsJ7YQ42JCAZNuvy+pfZVW8xTg1j
        ts0/TDknT/5FaJjsSuXrC8CVQ/XGoJY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-G1xjpu_dMQeo_rDCwT7TWA-1; Tue, 14 Jul 2020 09:50:47 -0400
X-MC-Unique: G1xjpu_dMQeo_rDCwT7TWA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16BF51937E01;
        Tue, 14 Jul 2020 13:50:46 +0000 (UTC)
Received: from loberhel7laptop.redhat.com (ovpn-113-229.phx2.redhat.com [10.3.113.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7B9260BF4;
        Tue, 14 Jul 2020 13:50:43 +0000 (UTC)
From:   Laurence Oberman <loberman@redhat.com>
To:     loberman@redhat.com, linux-scsi@vger.kernel.org,
        QLogic-Storage-Upstream@cavium.com, netdev@vger.kernel.org,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com,
        netdev@vger.kernel.org, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, loberman@redhat.com
Subject: [PATCH] qed (qed_int.c) disable "MFW indication via attention" SPAM every 5 minutes 
Date:   Tue, 14 Jul 2020 09:50:29 -0400
Message-Id: <1594734629-9969-1-git-send-email-loberman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is likely firmware causing this but its starting to annoy customers.
Change the message level to verbose to prevent the spam.
Note that this seems to only show up with ISCSI enabled on the HBA via the 
qedi driver.

Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/net/ethernet/qlogic/qed/qed_int.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index b7b974f..d853eb9 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -1193,7 +1193,8 @@ static int qed_int_attentions(struct qed_hwfn *p_hwfn)
 			index, attn_bits, attn_acks, asserted_bits,
 			deasserted_bits, p_sb_attn_sw->known_attn);
 	} else if (asserted_bits == 0x100) {
-		DP_INFO(p_hwfn, "MFW indication via attention\n");
+		DP_VERBOSE(p_hwfn, NETIF_MSG_INTR,
+			"MFW indication via attention\n");
 	} else {
 		DP_VERBOSE(p_hwfn, NETIF_MSG_INTR,
 			   "MFW indication [deassertion]\n");
-- 
1.8.3.1

