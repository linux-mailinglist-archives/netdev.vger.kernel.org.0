Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4EFD183962
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 20:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgCLTVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 15:21:49 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:54100 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726594AbgCLTVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 15:21:49 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7FFD5BC006B;
        Thu, 12 Mar 2020 19:21:47 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 12 Mar
 2020 19:21:42 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next] sfc: support configuring vf spoofchk on EF10 VFs
To:     <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <netdev@vger.kernel.org>
Message-ID: <f4055a13-c3bd-ebf1-86fb-6fc64da4d363@solarflare.com>
Date:   Thu, 12 Mar 2020 19:21:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25284.003
X-TM-AS-Result: No-5.439800-8.000000-10
X-TMASE-MatchedRID: zj6qu3YNhdKrAyqWeu/a0CMJO6daqdyWDvc/j9oMIgWbuvvgpZZI+VG9
        QjBckSB9FvIUhHKsIDQPEFjkHTfDsGbQIxHg2fnbqJSK+HSPY+/pVMb1xnESMnAal2A1DQmsQBz
        oPKhLasiPqQJ9fQR1znqkHNinj3pmrYhfqfvQWOmcxB01DrjF9/ngX/aL8PCN4PdcWsl+C/OMbv
        oO9mofAUu5EPLAtH7UkZOl7WKIImrvXOvQVlExsAtuKBGekqUpI/NGWt0UYPBge2m3lGqlZS+xq
        nJxbDjV/KW2dluIJJxLEiWjJhUpxd+yfB9xNB3E
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.439800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25284.003
X-MDID: 1584040908-4gqFEinYFpvC
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Corresponds to the MAC_SPOOFING_TX privilege in the hardware.
Some firmware versions on some cards don't support the feature, so check
 the TX_MAC_SECURITY capability and fail EOPNOTSUPP if trying to enable
 spoofchk on a NIC that doesn't support it.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10_sriov.c | 66 +++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 14393767ef9f..4580b30caae1 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -685,10 +685,70 @@ int efx_ef10_sriov_set_vf_vlan(struct efx_nic *efx, int vf_i, u16 vlan,
 	return rc ? rc : rc2;
 }
 
-int efx_ef10_sriov_set_vf_spoofchk(struct efx_nic *efx, int vf_i,
-				   bool spoofchk)
+static int efx_ef10_sriov_set_privilege_mask(struct efx_nic *efx, int vf_i,
+					     u32 mask, u32 value)
 {
-	return spoofchk ? -EOPNOTSUPP : 0;
+	MCDI_DECLARE_BUF(pm_outbuf, MC_CMD_PRIVILEGE_MASK_OUT_LEN);
+	MCDI_DECLARE_BUF(pm_inbuf, MC_CMD_PRIVILEGE_MASK_IN_LEN);
+	struct efx_ef10_nic_data *nic_data = efx->nic_data;
+	u32 old_mask, new_mask;
+	size_t outlen;
+	int rc;
+
+	EFX_WARN_ON_PARANOID((value & ~mask) != 0);
+
+	/* Get privilege mask */
+	MCDI_POPULATE_DWORD_2(pm_inbuf, PRIVILEGE_MASK_IN_FUNCTION,
+			      PRIVILEGE_MASK_IN_FUNCTION_PF, nic_data->pf_index,
+			      PRIVILEGE_MASK_IN_FUNCTION_VF, vf_i);
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_PRIVILEGE_MASK,
+			  pm_inbuf, sizeof(pm_inbuf),
+			  pm_outbuf, sizeof(pm_outbuf), &outlen);
+
+	if (rc != 0)
+		return rc;
+	if (outlen != MC_CMD_PRIVILEGE_MASK_OUT_LEN)
+		return -EIO;
+
+	old_mask = MCDI_DWORD(pm_outbuf, PRIVILEGE_MASK_OUT_OLD_MASK);
+
+	new_mask = old_mask & ~mask;
+	new_mask |= value;
+
+	if (new_mask == old_mask)
+		return 0;
+
+	new_mask |= MC_CMD_PRIVILEGE_MASK_IN_DO_CHANGE;
+
+	/* Set privilege mask */
+	MCDI_SET_DWORD(pm_inbuf, PRIVILEGE_MASK_IN_NEW_MASK, new_mask);
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_PRIVILEGE_MASK,
+			  pm_inbuf, sizeof(pm_inbuf),
+			  pm_outbuf, sizeof(pm_outbuf), &outlen);
+
+	if (rc != 0)
+		return rc;
+	if (outlen != MC_CMD_PRIVILEGE_MASK_OUT_LEN)
+		return -EIO;
+
+	return 0;
+}
+
+int efx_ef10_sriov_set_vf_spoofchk(struct efx_nic *efx, int vf_i, bool spoofchk)
+{
+	struct efx_ef10_nic_data *nic_data = efx->nic_data;
+
+	/* Can't enable spoofchk if firmware doesn't support it. */
+	if (!(nic_data->datapath_caps &
+	      BIT(MC_CMD_GET_CAPABILITIES_OUT_TX_MAC_SECURITY_FILTERING_LBN)) &&
+	    spoofchk)
+		return -EOPNOTSUPP;
+
+	return efx_ef10_sriov_set_privilege_mask(efx, vf_i,
+		MC_CMD_PRIVILEGE_MASK_IN_GRP_MAC_SPOOFING_TX,
+		spoofchk ? 0 : MC_CMD_PRIVILEGE_MASK_IN_GRP_MAC_SPOOFING_TX);
 }
 
 int efx_ef10_sriov_set_vf_link_state(struct efx_nic *efx, int vf_i,
