Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BCB212964
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGBQ2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:28:22 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:42938 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726779AbgGBQ2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 12:28:22 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D1845600D0;
        Thu,  2 Jul 2020 16:28:21 +0000 (UTC)
Received: from us4-mdac16-23.ut7.mdlocal (unknown [10.7.65.247])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id CB42B200AC;
        Thu,  2 Jul 2020 16:28:21 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.37])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4C4FB22005A;
        Thu,  2 Jul 2020 16:28:21 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F0181B40098;
        Thu,  2 Jul 2020 16:28:20 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul 2020
 17:28:16 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 03/16] sfc: move modparam 'interrupt_mode' out of
 common channel code
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
Message-ID: <990c2dc3-7e52-f6bf-d2ba-9aea10149f2c@solarflare.com>
Date:   Thu, 2 Jul 2020 17:28:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25516.003
X-TM-AS-Result: No-6.657900-8.000000-10
X-TMASE-MatchedRID: 1cNpNi1i8zAfLZjRGBdfQZzEHTUOuMX3SWg+u4ir2NPQBYpS9DhSddMj
        jwb9QfV2po4BEJkW5xkN25tj8sME0qH2g9syPs888Kg68su2wyGqdpuEuCeGaAaYevV4zG3ZQBz
        oPKhLasgauqvYLw3/CkjdTANFgCYpSwojFX8WCDBEVqQW9Bvtqb7DirSpOYvI0SxMhOhuA0Tmy5
        4IL6qFdzZ2dXJskHOJACN6ZcgMDeWZRBKsj/jrq0WtyNepX5gAyoUTqBF1E5sAaVh6SCFg5zpG/
        1g33tjm2w9WUtAsFzfwTCFfL51H2QMH01Bi825+ngIgpj8eDcC063Wh9WVqgtZE3xJMmmXc+gtH
        j7OwNO3vz6NkpWrYb0tEOVLWGgqUFJLGpauUU8ZQb0+GUNdlENOf4kdNRXljVlxr1FJij9s=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.657900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25516.003
X-MDID: 1593707301-YG-VAVnChTs3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EF100 only supports MSI-X, so there's no need for the new driver to
 expose this old module parameter.
Since it's now visible to the linker, we have to rename it internally
 to efx_interrupt_mode to avoid symbol collisions in non-modular
 builds.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c          | 4 ++++
 drivers/net/ethernet/sfc/efx_channels.c | 7 ++-----
 drivers/net/ethernet/sfc/efx_channels.h | 2 ++
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 418676aba43a..2725d1d62d25 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -64,6 +64,10 @@ void efx_get_udp_tunnel_type_name(u16 type, char *buf, size_t buflen)
  *
  *************************************************************************/
 
+module_param_named(interrupt_mode, efx_interrupt_mode, uint, 0444);
+MODULE_PARM_DESC(interrupt_mode,
+		 "Interrupt mode (0=>MSIX 1=>MSI 2=>legacy)");
+
 /*
  * Use separate channels for TX and RX events
  *
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 2220b9507336..50356db39ae5 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -23,10 +23,7 @@
  * 1 => MSI
  * 2 => legacy
  */
-static unsigned int interrupt_mode;
-module_param(interrupt_mode, uint, 0444);
-MODULE_PARM_DESC(interrupt_mode,
-		 "Interrupt mode (0=>MSIX 1=>MSI 2=>legacy)");
+unsigned int efx_interrupt_mode = EFX_INT_MODE_MSIX;
 
 /* This is the requested number of CPUs to use for Receive-Side Scaling (RSS),
  * i.e. the number of CPUs among which we may distribute simultaneous
@@ -558,7 +555,7 @@ int efx_init_channels(struct efx_nic *efx)
 
 	/* Higher numbered interrupt modes are less capable! */
 	efx->interrupt_mode = min(efx->type->min_interrupt_mode,
-				  interrupt_mode);
+				  efx_interrupt_mode);
 
 	efx->max_channels = EFX_MAX_CHANNELS;
 	efx->max_tx_channels = EFX_MAX_CHANNELS;
diff --git a/drivers/net/ethernet/sfc/efx_channels.h b/drivers/net/ethernet/sfc/efx_channels.h
index 8d7b8c4142d7..86dd058d40f3 100644
--- a/drivers/net/ethernet/sfc/efx_channels.h
+++ b/drivers/net/ethernet/sfc/efx_channels.h
@@ -11,6 +11,8 @@
 #ifndef EFX_CHANNELS_H
 #define EFX_CHANNELS_H
 
+extern unsigned int efx_interrupt_mode;
+
 int efx_probe_interrupts(struct efx_nic *efx);
 void efx_remove_interrupts(struct efx_nic *efx);
 int efx_soft_enable_interrupts(struct efx_nic *efx);

