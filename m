Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA62136DFA
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 14:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbgAJN0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 08:26:45 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:51510 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727500AbgAJN0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 08:26:45 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F0242800062;
        Fri, 10 Jan 2020 13:26:42 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 10 Jan 2020 13:26:37 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 1/9] sfc: refactor selftest work init code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
Message-ID: <e61009b4-4d39-0df1-756b-3097178ea060@solarflare.com>
Date:   Fri, 10 Jan 2020 13:26:34 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25158.003
X-TM-AS-Result: No-0.069700-8.000000-10
X-TMASE-MatchedRID: 5VG9tYkx4U+h9oPbMj7PPPCoOvLLtsMhP6Tki+9nU38HZBaLwEXlKNnf
        JrUSEbFDzEIp4VT5Da5ioesYKUK6Q2A2IAXETeuKmR5xY+cgRdyIrmqDVyayv1VkJxysad/ILAk
        L2MpbymWZO1URQec1gJG17NwV0jnY5UcZtwNsCro5f9Xw/xqKXZLy/k4uPY3KxEHRux+uk8ifEz
        J5hPndGRFkEE6JZsBHFIe4koxn6tBzd5tfVK6foD0rjVNL5EQ07eHQ+66dtJE48MwIVyRcur7hp
        XASZbEwZNnFSj9hU6mjECK/cWfsPBoQVhcDKUH1JRIzmbBpwaQgJCm6ypGLZ6Ol5oRXyhFEVlxr
        1FJij9s=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.069700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25158.003
X-MDID: 1578662803-ocje4wSbig_q
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/efx_common.c | 2 +-
 drivers/net/ethernet/sfc/selftest.c   | 7 ++++++-
 drivers/net/ethernet/sfc/selftest.h   | 2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 9cd7c1550c08..33b523b6d0a8 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -840,7 +840,7 @@ int efx_init_struct(struct efx_nic *efx,
 #endif
 	INIT_WORK(&efx->reset_work, efx_reset_work);
 	INIT_DELAYED_WORK(&efx->monitor_work, efx_monitor);
-	INIT_DELAYED_WORK(&efx->selftest_work, efx_selftest_async_work);
+	efx_selftest_async_init(efx);
 	efx->pci_dev = pci_dev;
 	efx->msg_enable = debug;
 	efx->state = STATE_UNINIT;
diff --git a/drivers/net/ethernet/sfc/selftest.c b/drivers/net/ethernet/sfc/selftest.c
index ec5002b5ec4f..1ae369022d7d 100644
--- a/drivers/net/ethernet/sfc/selftest.c
+++ b/drivers/net/ethernet/sfc/selftest.c
@@ -785,7 +785,7 @@ void efx_selftest_async_cancel(struct efx_nic *efx)
 	cancel_delayed_work_sync(&efx->selftest_work);
 }
 
-void efx_selftest_async_work(struct work_struct *data)
+static void efx_selftest_async_work(struct work_struct *data)
 {
 	struct efx_nic *efx = container_of(data, struct efx_nic,
 					   selftest_work.work);
@@ -804,3 +804,8 @@ void efx_selftest_async_work(struct work_struct *data)
 				  channel->channel, cpu);
 	}
 }
+
+void efx_selftest_async_init(struct efx_nic *efx)
+{
+	INIT_DELAYED_WORK(&efx->selftest_work, efx_selftest_async_work);
+}
diff --git a/drivers/net/ethernet/sfc/selftest.h b/drivers/net/ethernet/sfc/selftest.h
index a3553816d92c..ca88ebb4f6b1 100644
--- a/drivers/net/ethernet/sfc/selftest.h
+++ b/drivers/net/ethernet/sfc/selftest.h
@@ -45,8 +45,8 @@ void efx_loopback_rx_packet(struct efx_nic *efx, const char *buf_ptr,
 			    int pkt_len);
 int efx_selftest(struct efx_nic *efx, struct efx_self_tests *tests,
 		 unsigned flags);
+void efx_selftest_async_init(struct efx_nic *efx);
 void efx_selftest_async_start(struct efx_nic *efx);
 void efx_selftest_async_cancel(struct efx_nic *efx);
-void efx_selftest_async_work(struct work_struct *data);
 
 #endif /* EFX_SELFTEST_H */
-- 
2.20.1


