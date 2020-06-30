Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D8F20F456
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387589AbgF3MPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:15:43 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:45820 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387554AbgF3MPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:15:43 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4475520064;
        Tue, 30 Jun 2020 12:15:42 +0000 (UTC)
Received: from us4-mdac16-18.at1.mdlocal (unknown [10.110.49.200])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 45BA28009B;
        Tue, 30 Jun 2020 12:15:42 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.48.236])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D628240072;
        Tue, 30 Jun 2020 12:15:41 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9819F400092;
        Tue, 30 Jun 2020 12:15:41 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Jun
 2020 13:15:37 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 14/14] sfc: don't call tx_remove if there isn't one
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Message-ID: <ad8f6f86-b910-a95b-3c00-7dc4e40bb8f7@solarflare.com>
Date:   Tue, 30 Jun 2020 13:15:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25512.003
X-TM-AS-Result: No-3.215400-8.000000-10
X-TMASE-MatchedRID: hjMKqWyETKjeG4FwcWqAS+IfK/Jd5eHmL7DjpoDqNZn5LkL/TyFZzf4T
        wyrKMcsB8XVI39JCRnSjfNAVYAJRApzAN0sNcMp5PwKTD1v8YV5MkOX0UoduuVVkJxysad/IeOb
        QA+fBlTa4S8oXrr4cwZGTpe1iiCJq71zr0FZRMbCWlioo2ZbGwdmzcdRxL+xwKrauXd3MZDW7QQ
        xQFaxnamFPw+K9Y325gj+ZU6tsmO0+GJfKOACjECkSttBQAxqAEWjVFlwkXrpAjnF0AvWM2fzm0
        XVRv19NFKkxYu/4iTnTZWvGSfVMiUODDY5/BuEsoxrk6Q2mIeSJ+wv7oJjhGclmajRS8yWxQwym
        txuJ6y0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.215400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25512.003
X-MDID: 1593519342-jctUjcFHGZ6j
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EF100 won't have an efx->type->tx_remove method, because there's
 nothing for it to do.  So make the call conditional.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/nic_common.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/nic_common.h b/drivers/net/ethernet/sfc/nic_common.h
index 197ecac5e005..fd474d9e55e4 100644
--- a/drivers/net/ethernet/sfc/nic_common.h
+++ b/drivers/net/ethernet/sfc/nic_common.h
@@ -163,7 +163,8 @@ static inline void efx_nic_init_tx(struct efx_tx_queue *tx_queue)
 }
 static inline void efx_nic_remove_tx(struct efx_tx_queue *tx_queue)
 {
-	tx_queue->efx->type->tx_remove(tx_queue);
+	if (tx_queue->efx->type->tx_remove)
+		tx_queue->efx->type->tx_remove(tx_queue);
 }
 static inline void efx_nic_push_buffers(struct efx_tx_queue *tx_queue)
 {
