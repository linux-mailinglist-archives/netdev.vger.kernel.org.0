Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666F7223EDA
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 16:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgGQOzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 10:55:17 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:51220 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgGQOzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 10:55:16 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06HEtBDR075663;
        Fri, 17 Jul 2020 09:55:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594997711;
        bh=ILo50kO6ZaOdsTSCv78i0Pa1kXFMMaSNMvFJOAtFzlA=;
        h=From:To:Subject:Date;
        b=i/hyofjwqwhtDDL014iF3ilR9ymjkqRNoidttj8kSmAtzZnD84n3FUdJY5pGdqVYR
         3XSm1qap2Tbt1B2HdLNohm5wcHGOSh3xRhbdrXiT3Jc3lqC7NgQN4SEmsabKq1Y52k
         5+3tU9Qq2YUhv11+g+FTenpD5OiZZXgrTG3dtnSg=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06HEtB0u066964;
        Fri, 17 Jul 2020 09:55:11 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 17
 Jul 2020 09:55:10 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 17 Jul 2020 09:55:11 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06HEtAg0090872;
        Fri, 17 Jul 2020 09:55:10 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>,
        <grygorii.strashko@ti.com>, <vinicius.gomes@intel.com>
Subject: [PATCH 1/2 v2] net: hsr: fix incorrect lsdu size in the tag of HSR frames for small frames
Date:   Fri, 17 Jul 2020 10:55:09 -0400
Message-ID: <20200717145510.30433-1-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For small Ethernet frames with size less than minimum size 66 for HSR
vs 60 for regular Ethernet frames, hsr driver currently doesn't pad the
frame to make it minimum size. This results in incorrect LSDU size being
populated in the HSR tag for these frames. Fix this by padding the frame
to the minimum size applicable for HSR.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 no change from original version
 Sending this bug fix ahead of PRP patch series as per comment
 net/hsr/hsr_forward.c | 3 +++
 1 file changed, 3 insertions(+)

 Sending this bug fix ahead of PRP patch series as per comment
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index ed13760463de..e42fd356f073 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -127,6 +127,9 @@ static void hsr_fill_tag(struct sk_buff *skb, struct hsr_frame_info *frame,
 	int lane_id;
 	int lsdu_size;
 
+	/* pad to minimum packet size which is 60 + 6 (HSR tag) */
+	skb_put_padto(skb, ETH_ZLEN + HSR_HLEN);
+
 	if (port->type == HSR_PT_SLAVE_A)
 		lane_id = 0;
 	else
-- 
2.17.1

