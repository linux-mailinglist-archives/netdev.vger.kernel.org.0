Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5102484FE
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 14:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgHRMoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 08:44:16 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:37418 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726676AbgHRMoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 08:44:05 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 02F8E20064;
        Tue, 18 Aug 2020 12:44:05 +0000 (UTC)
Received: from us4-mdac16-51.at1.mdlocal (unknown [10.110.48.100])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 01532800A3;
        Tue, 18 Aug 2020 12:44:05 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.109])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8ECB010007B;
        Tue, 18 Aug 2020 12:44:04 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5803BB40066;
        Tue, 18 Aug 2020 12:44:04 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 13:43:59 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net 2/4] sfc: take correct lock in ef100_reset()
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <d8d6cdfc-7d4f-81ec-8b3e-bc207a2c7d50@solarflare.com>
Message-ID: <38c7df29-b013-7408-90aa-ed4c3797df34@solarflare.com>
Date:   Tue, 18 Aug 2020 13:43:57 +0100
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
X-TM-AS-Result: No-5.517300-8.000000-10
X-TMASE-MatchedRID: GNv//7IO1BzQMti10yO4N21rAlJKwOBJHqS0sLvYe+zWXfwzppZ8SHi8
        nIGQFeXxPEoGb8keCDpTvVffeIwvQwUcfW/oedmqPwKTD1v8YV5MkOX0UoduuVVkJxysad/IFde
        66xkhv8eY/FfwncZ6lk3JPMMbjLmMj2hRzH1UwuA5f9Xw/xqKXXJnzNw42kCxxEHRux+uk8irEH
        faj14ZyVjnE6veZObzjzNV7f00veUdYQqkdpqwhbwgIkq49O1l6WOsFkc58DSUk/J0QEz3bywON
        loipR2UTH/CzyDMFtSxGHqo0e5ELgCqi9+FhhL4
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-5.517300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25610.005
X-MDID: 1597754645-l-KjJRlqrovC
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When downing and upping the ef100 filter table, we need to take a write
 lock on efx->filter_sem, not just a read lock, because we may kfree()
 the table pointers.
Without this, resets cause a WARN_ON from efx_rwsem_assert_write_locked().

Fixes: a9dc3d5612ce ("sfc_ef100: RX filter table management and related gubbins")
Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index b8a7e9ed7913..19fe86b3b316 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -431,18 +431,18 @@ static int ef100_reset(struct efx_nic *efx, enum reset_type reset_type)
 		/* A RESET_TYPE_ALL will cause filters to be removed, so we remove filters
 		 * and reprobe after reset to avoid removing filters twice
 		 */
-		down_read(&efx->filter_sem);
+		down_write(&efx->filter_sem);
 		ef100_filter_table_down(efx);
-		up_read(&efx->filter_sem);
+		up_write(&efx->filter_sem);
 		rc = efx_mcdi_reset(efx, reset_type);
 		if (rc)
 			return rc;
 
 		netif_device_attach(efx->net_dev);
 
-		down_read(&efx->filter_sem);
+		down_write(&efx->filter_sem);
 		rc = ef100_filter_table_up(efx);
-		up_read(&efx->filter_sem);
+		up_write(&efx->filter_sem);
 		if (rc)
 			return rc;
 

