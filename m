Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8693D220071
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 00:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgGNWIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 18:08:32 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43213 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726619AbgGNWIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 18:08:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594764509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc; bh=Eoga+Mdleam2+PFUQQVvh+tI5hcjfog78flkltDgmv4=;
        b=C0ppJTCY1NymYDrTPltGfAjsKug+B71A8SyYJffE6DPh8oz8CGqR2h4pHp/WwKipsbZVC6
        Yx7cyBSq5uXEyz/77n2GtsXg5ToBrghgzaca2Czv4+wjM6r+6Jl1OkvbRlCr5kADL7p5X8
        mVw9xjNzEKixccy18CWxcCQiVXZ7Nw4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-tcRqVYBLNXq9aneVJyXS3Q-1; Tue, 14 Jul 2020 18:08:27 -0400
X-MC-Unique: tcRqVYBLNXq9aneVJyXS3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 457EC800685;
        Tue, 14 Jul 2020 22:08:26 +0000 (UTC)
Received: from loberhel7laptop.redhat.com (ovpn-113-229.phx2.redhat.com [10.3.113.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BC4E1992D;
        Tue, 14 Jul 2020 22:08:25 +0000 (UTC)
From:   Laurence Oberman <loberman@redhat.com>
To:     loberman@redhat.com, linux-scsi@vger.kernel.org,
        QLogic-Storage-Upstream@cavium.com, netdev@vger.kernel.org,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com
Subject: [PATCH net] qed: Disable "MFW indication via attention" SPAM every 5 minutes 
Date:   Tue, 14 Jul 2020 18:08:05 -0400
Message-Id: <1594764485-682-1-git-send-email-loberman@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
+			   "MFW indication via attention\n");
 	} else {
 		DP_VERBOSE(p_hwfn, NETIF_MSG_INTR,
 			   "MFW indication [deassertion]\n");
-- 
1.8.3.1

