Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0173E210E1B
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731677AbgGAOyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:54:07 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:52342 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731645AbgGAOyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:54:07 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C622960089;
        Wed,  1 Jul 2020 14:54:06 +0000 (UTC)
Received: from us4-mdac16-17.ut7.mdlocal (unknown [10.7.65.241])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C4C312009B;
        Wed,  1 Jul 2020 14:54:06 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.38])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5DDCA220056;
        Wed,  1 Jul 2020 14:54:06 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1088180008B;
        Wed,  1 Jul 2020 14:54:06 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Jul 2020
 15:54:01 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 08/15] sfc: don't call tx_limit_len if NIC type
 doesn't have one
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Message-ID: <2a27c0bc-302f-caf7-3f46-3f52b53fcf37@solarflare.com>
Date:   Wed, 1 Jul 2020 15:53:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25514.003
X-TM-AS-Result: No-2.834500-8.000000-10
X-TMASE-MatchedRID: GkK0OV5ZvkTbUSlFWXatlLsHVDDM5xAP1JP9NndNOkVYwVHjLI3nekAc
        6DyoS2rI2hTOUzxi3QjYg5Psk9+DGNdf8+a4EvVqogGd8wIUGIJ9LQinZ4QefL6qvLNjDYTwxbG
        vmM9nj5NQSFbL1bvQAVgXepbcl7r7McmzRul9ZoPcO+ebV3PxAqOC5BQeC6VEk7EN5qgbBb+B5A
        G9eDR0IVZhrztOU0OCELyXTofJczNaiJ7OqdZvSbDlaxtcd4N7McKpXuu/1jVAMwW4rY/0WO2hZ
        q8RbsdETdnyMokJ1HTiaosWHm9+bH7cGd19dSFd
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.834500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25514.003
X-MDID: 1593615246-PqkSp-LWMMgK
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EF100 doesn't need to split up large DMAs.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/tx_common.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index 2a058b76d1f0..11b64c609550 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -298,7 +298,11 @@ struct efx_tx_buffer *efx_tx_map_chunk(struct efx_tx_queue *tx_queue,
 	/* Map the fragment taking account of NIC-dependent DMA limits. */
 	do {
 		buffer = efx_tx_queue_get_insert_buffer(tx_queue);
-		dma_len = nic_type->tx_limit_len(tx_queue, dma_addr, len);
+
+		if (nic_type->tx_limit_len)
+			dma_len = nic_type->tx_limit_len(tx_queue, dma_addr, len);
+		else
+			dma_len = len;
 
 		buffer->len = dma_len;
 		buffer->dma_addr = dma_addr;

