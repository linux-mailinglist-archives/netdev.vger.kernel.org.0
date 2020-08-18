Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101F9248501
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 14:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgHRMof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 08:44:35 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:39800 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726676AbgHRMo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 08:44:29 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 88E672007A;
        Tue, 18 Aug 2020 12:44:28 +0000 (UTC)
Received: from us4-mdac16-75.at1.mdlocal (unknown [10.110.50.193])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8714D800A4;
        Tue, 18 Aug 2020 12:44:28 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.8])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3412740076;
        Tue, 18 Aug 2020 12:44:28 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F00C44C0059;
        Tue, 18 Aug 2020 12:44:27 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 13:44:23 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net 3/4] sfc: null out channel->rps_flow_id after freeing it
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <d8d6cdfc-7d4f-81ec-8b3e-bc207a2c7d50@solarflare.com>
Message-ID: <ea34ed03-23e8-568f-ec50-1f238bc0a350@solarflare.com>
Date:   Tue, 18 Aug 2020 13:44:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d8d6cdfc-7d4f-81ec-8b3e-bc207a2c7d50@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25610.005
X-TM-AS-Result: No-2.657100-8.000000-10
X-TMASE-MatchedRID: nZmhj4AdQTmoGXjkaQmeHyxYq3WqsPihkos2tunL8DT2u2oLJUFmGH3k
        R6l0wGIGGTuJ7KCrTPmBFG3MhQh43kPbYPqd/GaJqjZ865FPtpoIgmyKRe524wZvX+0veCCcFSx
        iD1T+DkHvteDyoHBF+Y+yyTvpxxyaedTACv7eJKI/ApMPW/xhXkyQ5fRSh265UDKw/uBUYFpuxE
        KGig3KX/ojD9JaOQQHeAsBl7oOgHRJI5ZUl647UDl/1fD/GopdcmfM3DjaQLHEQdG7H66TyJ8TM
        nmE+d0ZRfR/X3Z5xZ/UVIG3k4wX5H7WFzsdjijjBpym/C4lbLqCdPE6rHJYhEvcHkf9y4ILSbqU
        4CqTx1eYwQJQm5UODTwOn/tvJQq2GhBWFwMpQfUlEjOZsGnBpCAkKbrKkYtno6XmhFfKEUTDyDY
        cE1wXmQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-2.657100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25610.005
X-MDID: 1597754668-1SlM9sne3hWs
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an ef100_net_open() fails, ef100_net_stop() may be called without
 channel->rps_flow_id having been written; thus it may hold the address
 freed by a previous ef100_net_stop()'s call to efx_remove_filters().
 This then causes a double-free when efx_remove_filters() is called
 again, leading to a panic.
To prevent this, after freeing it, overwrite it with NULL.

Fixes: a9dc3d5612ce ("sfc_ef100: RX filter table management and related gubbins")
Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/rx_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index ef9bca92b0b7..5e29284c89c9 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -849,6 +849,7 @@ void efx_remove_filters(struct efx_nic *efx)
 	efx_for_each_channel(channel, efx) {
 		cancel_delayed_work_sync(&channel->filter_work);
 		kfree(channel->rps_flow_id);
+		channel->rps_flow_id = NULL;
 	}
 #endif
 	down_write(&efx->filter_sem);

