Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C27022EB97
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgG0L6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:58:13 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:50494 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726890AbgG0L6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 07:58:12 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 68355600A8;
        Mon, 27 Jul 2020 11:58:12 +0000 (UTC)
Received: from us4-mdac16-75.ut7.mdlocal (unknown [10.7.64.194])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 662D0200A0;
        Mon, 27 Jul 2020 11:58:12 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.198])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 026831C004F;
        Mon, 27 Jul 2020 11:58:12 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id AECD380055;
        Mon, 27 Jul 2020 11:58:11 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jul
 2020 12:58:06 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v5 net-next 10/16] sfc_ef100: process events for MCDI
 completions
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <72cc6ef1-4f7f-bf22-5bec-942beb6353ed@solarflare.com>
Message-ID: <ce0b5890-573a-bd06-0318-6a38d1d2fea0@solarflare.com>
Date:   Mon, 27 Jul 2020 12:58:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <72cc6ef1-4f7f-bf22-5bec-942beb6353ed@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25566.005
X-TM-AS-Result: No-2.659800-8.000000-10
X-TMASE-MatchedRID: vPB3M/ROE+2Kv8OoSrxC1sGNvKPnBgOa8vvksslXuLdjLp8Cm8vwFwoe
        RRhCZWIBI5Skl4cZDuybHAuQ1dUnuWJZXQNDzktSGjzBgnFZvQ4r9gVlOIN/6va7agslQWYYp62
        UawMz5m++O131FKZHs6W+nV9Hv/RwDCED/Oc5L9vM0ihsfYPMYYLQ1EX7jGPgHWtVZN0asThFAP
        lc4VGMQpiXUTPYiDnX52ev+KfkO0VJI5ZUl647UDl/1fD/GopdcmfM3DjaQLHEQdG7H66TyJ8TM
        nmE+d0ZnDxIXVIQKUspWfcRhlH/xAnh9lzj+SZjFAykYThH7v4kwNcfijuE3X6fzI4NkedCoav8
        Jcoyl2jagvDCxSZGh4UtYnTSQ3LFGhBWFwMpQfUlEjOZsGnBpCAkKbrKkYtno6XmhFfKEURWXGv
        UUmKP2w==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.659800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25566.005
X-MDID: 1595851092-YWjfaZBu0ify
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently RX and TX-completion events are unhandled, as neither the RX
 nor the TX path has been implemented yet.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 57 +++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index be37055743c3..c6703527bbe9 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -160,7 +160,62 @@ static void ef100_ev_read_ack(struct efx_channel *channel)
 
 static int ef100_ev_process(struct efx_channel *channel, int quota)
 {
-	return 0;
+	struct efx_nic *efx = channel->efx;
+	struct ef100_nic_data *nic_data;
+	bool evq_phase, old_evq_phase;
+	unsigned int read_ptr;
+	efx_qword_t *p_event;
+	int spent = 0;
+	bool ev_phase;
+	int ev_type;
+
+	if (unlikely(!channel->enabled))
+		return 0;
+
+	nic_data = efx->nic_data;
+	evq_phase = test_bit(channel->channel, nic_data->evq_phases);
+	old_evq_phase = evq_phase;
+	read_ptr = channel->eventq_read_ptr;
+	BUILD_BUG_ON(ESF_GZ_EV_RXPKTS_PHASE_LBN != ESF_GZ_EV_TXCMPL_PHASE_LBN);
+
+	while (spent < quota) {
+		p_event = efx_event(channel, read_ptr);
+
+		ev_phase = !!EFX_QWORD_FIELD(*p_event, ESF_GZ_EV_RXPKTS_PHASE);
+		if (ev_phase != evq_phase)
+			break;
+
+		netif_vdbg(efx, drv, efx->net_dev,
+			   "processing event on %d " EFX_QWORD_FMT "\n",
+			   channel->channel, EFX_QWORD_VAL(*p_event));
+
+		ev_type = EFX_QWORD_FIELD(*p_event, ESF_GZ_E_TYPE);
+
+		switch (ev_type) {
+		case ESE_GZ_EF100_EV_MCDI:
+			efx_mcdi_process_event(channel, p_event);
+			break;
+		case ESE_GZ_EF100_EV_DRIVER:
+			netif_info(efx, drv, efx->net_dev,
+				   "Driver initiated event " EFX_QWORD_FMT "\n",
+				   EFX_QWORD_VAL(*p_event));
+			break;
+		default:
+			netif_info(efx, drv, efx->net_dev,
+				   "Unhandled event " EFX_QWORD_FMT "\n",
+				   EFX_QWORD_VAL(*p_event));
+		}
+
+		++read_ptr;
+		if ((read_ptr & channel->eventq_mask) == 0)
+			evq_phase = !evq_phase;
+	}
+
+	channel->eventq_read_ptr = read_ptr;
+	if (evq_phase != old_evq_phase)
+		change_bit(channel->channel, nic_data->evq_phases);
+
+	return spent;
 }
 
 static irqreturn_t ef100_msi_interrupt(int irq, void *dev_id)

