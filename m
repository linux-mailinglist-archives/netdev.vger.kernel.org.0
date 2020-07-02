Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79FC212993
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgGBQby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:31:54 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:53322 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726649AbgGBQbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 12:31:53 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0FA67600B7;
        Thu,  2 Jul 2020 16:31:53 +0000 (UTC)
Received: from us4-mdac16-19.ut7.mdlocal (unknown [10.7.65.243])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0C39C2009B;
        Thu,  2 Jul 2020 16:31:53 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.34])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7E24522004D;
        Thu,  2 Jul 2020 16:31:52 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 30DB960008B;
        Thu,  2 Jul 2020 16:31:52 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul 2020
 17:31:46 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 12/16] sfc: get drvinfo driver name from outside
 the common code
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
Message-ID: <fc18bb2f-0c5a-a97c-fff1-bd3b4a4f151b@solarflare.com>
Date:   Thu, 2 Jul 2020 17:31:43 +0100
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
X-TM-AS-Result: No-0.297800-8.000000-10
X-TMASE-MatchedRID: /w5WcX9GavlAEjf8JRFbHE7CajSVoNFsSWg+u4ir2NMd0WOKRkwsh1ym
        Rv3NQjsE9/Qn8y+r242bHAuQ1dUnuWJZXQNDzktSGjzBgnFZvQ4isyg/lfGoZ1IxScKXZnK04Wj
        9iaClAklVwmhDMdxrr5GTpe1iiCJq71zr0FZRMbBqHXONfTwSQsRB0bsfrpPIreCTu6Ejg5iwwc
        cAUuaQ+Qn/ZctBLddLLoqHcsS1CYouD2ibXO69Hk4iS0jF8t1GxTH++wvdwTIOxDgLTl89D0Zfu
        Rd2CNLkuQPZui2I8KsaEFYXAylB9SUSM5mwacGkICQpusqRi2ejpeaEV8oRRFqAtPM/2FFilExl
        QIQeRG0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-0.297800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25516.003
X-MDID: 1593707513-baDohJiAO7Uc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since ethtool_common.o will be built into both sfc and sfc_ef100 drivers,
 it can't use KBUILD_MODNAME directly.  Instead, make it reference a
 string provided by the individual driver code.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ethtool.c        | 2 ++
 drivers/net/ethernet/sfc/ethtool_common.c | 2 +-
 drivers/net/ethernet/sfc/ethtool_common.h | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 48a96ed6b7d0..9828516bd82d 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -221,6 +221,8 @@ static int efx_ethtool_get_ts_info(struct net_device *net_dev,
 	return 0;
 }
 
+const char *efx_driver_name = KBUILD_MODNAME;
+
 const struct ethtool_ops efx_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_USECS_IRQ |
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index 37a4409e759e..e9a5a66529bf 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -104,7 +104,7 @@ void efx_ethtool_get_drvinfo(struct net_device *net_dev,
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strlcpy(info->driver, efx_driver_name, sizeof(info->driver));
 	strlcpy(info->version, EFX_DRIVER_VERSION, sizeof(info->version));
 	efx_mcdi_print_fwver(efx, info->fw_version,
 			     sizeof(info->fw_version));
diff --git a/drivers/net/ethernet/sfc/ethtool_common.h b/drivers/net/ethernet/sfc/ethtool_common.h
index 7bfbbd08a1ef..3f3aaa92fbb5 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.h
+++ b/drivers/net/ethernet/sfc/ethtool_common.h
@@ -11,6 +11,8 @@
 #ifndef EFX_ETHTOOL_COMMON_H
 #define EFX_ETHTOOL_COMMON_H
 
+extern const char *efx_driver_name;
+
 void efx_ethtool_get_drvinfo(struct net_device *net_dev,
 			     struct ethtool_drvinfo *info);
 u32 efx_ethtool_get_msglevel(struct net_device *net_dev);

