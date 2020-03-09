Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D76217E69B
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 19:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbgCISQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 14:16:34 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:59970 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726467AbgCISQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 14:16:34 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D1EBFA80083;
        Mon,  9 Mar 2020 18:16:32 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 9 Mar 2020
 18:16:27 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net] sfc: detach from cb_page in efx_copy_channel()
To:     <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <netdev@vger.kernel.org>
Message-ID: <d0c0595d-899b-0701-11cc-d9298c97df74@solarflare.com>
Date:   Mon, 9 Mar 2020 18:16:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25278.003
X-TM-AS-Result: No-7.672500-8.000000-10
X-TMASE-MatchedRID: /FVAr71QmeX0nMCL2lyVdmFdfLBMkul8Ww/S0HB7eoP2u2oLJUFmGHpn
        GiDiSyyD/TQDVXu6aPir/+Gm/JK2uuDocHyqS9Hwt0cS/uxH87BXjjsM2/Dfxo40w42pEhFTVZ5
        6bK8gODu0UC2dwBOZS1l+rJjPLsuB9IKRKjO372G7B1QwzOcQD9ST/TZ3TTpFB2QWi8BF5SiKW8
        BvXyLiE0Etwoxd3OQtSjLlYugtawpNfs8n85Te8oMbH85DUZXy3QfwsVk0UbtuRXh7bFKB7qgmh
        VwN4qJ9EeuMYmVgYB4ZGSyXYrM4vcHTVmt9wiG5aAZk0sEcY14=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.672500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25278.003
X-MDID: 1583777793-Uu7R6B-voHd8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's a resource, not a parameter, so we can't copy it into the new
 channel's TX queues, otherwise aliasing will lead to resource-
 management bugs if the channel is subsequently torn down without
 being initialised.

Before the Fixes:-tagged commit there was a similar bug with
 tsoh_page, but I'm not sure it's worth doing another fix for such
 old kernels.

Fixes: e9117e5099ea ("sfc: Firmware-Assisted TSO version 2")
Suggested-by: Derek Shute <Derek.Shute@stratus.com>
Signed-off-by: Edward Cree <ecree@solarflare.com>
---
The Fixes: is in v4.10, so this will want to go to stable for
 4.14 and later.  Note that the recent refactoring has moved the
 code; in the stable trees efx_copy_channel() will be in efx.c
 rather than efx_channels.c.

 drivers/net/ethernet/sfc/efx_channels.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index aeb5e8aa2f2a..73d4e39b5b16 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -583,6 +583,7 @@ struct efx_channel *efx_copy_channel(const struct efx_channel *old_channel)
 		if (tx_queue->channel)
 			tx_queue->channel = channel;
 		tx_queue->buffer = NULL;
+		tx_queue->cb_page = NULL;
 		memset(&tx_queue->txd, 0, sizeof(tx_queue->txd));
 	}
 
