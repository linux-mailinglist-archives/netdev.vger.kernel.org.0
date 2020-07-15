Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1D9221286
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGOQkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:40:22 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:42638 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgGOQkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:40:21 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06FGeG9i003829;
        Wed, 15 Jul 2020 11:40:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594831216;
        bh=l9F2o1gesIVnYJhZiValfLiNSoAwf9JeCCag42kCIhw=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=pOYUydWsjV15MttD6f3f7N0GbW76lJoenLILsfkvQ+uKDLqOxmkVAjElsnykej79v
         hEn5IQSar6BmIP4WlhFqen/9ZMVTwXxmjKjCSSxTTGRZmeHQZWJ/M4wTh0jL5E9OJd
         pmL0pcmGNV86wqmKWENA7WUjxJE39TrrJQLiZgS0=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06FGeGI4102665
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 11:40:16 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 15
 Jul 2020 11:40:15 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 15 Jul 2020 11:40:15 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06FGeCvZ081717;
        Wed, 15 Jul 2020 11:40:14 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
Subject: [net-next PATCH v2 1/9] net: hsr: fix incorrect lsdu size in the tag of HSR frames for small frames
Date:   Wed, 15 Jul 2020 12:40:02 -0400
Message-ID: <20200715164012.1222-2-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715164012.1222-1-m-karicheri2@ti.com>
References: <20200715164012.1222-1-m-karicheri2@ti.com>
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
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 net/hsr/hsr_forward.c | 3 +++
 1 file changed, 3 insertions(+)

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

