Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BCB22235E
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 15:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbgGPNCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 09:02:46 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:43416 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726537AbgGPNCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 09:02:46 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C401A6010B;
        Thu, 16 Jul 2020 13:02:45 +0000 (UTC)
Received: from us4-mdac16-74.ut7.mdlocal (unknown [10.7.64.193])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C2B612009B;
        Thu, 16 Jul 2020 13:02:45 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.36])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2D13A220076;
        Thu, 16 Jul 2020 13:02:45 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D8685B4009A;
        Thu, 16 Jul 2020 13:02:44 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Jul
 2020 14:02:40 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v3 net-next 10/16] sfc_ef100: process events for MCDI
 completions
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <7bb4f1f4-c67f-8c7b-86ba-7bf9f74ffc28@solarflare.com>
Message-ID: <e2296ab6-094e-0799-c0ad-5835aa075071@solarflare.com>
Date:   Thu, 16 Jul 2020 14:02:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <7bb4f1f4-c67f-8c7b-86ba-7bf9f74ffc28@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25544.003
X-TM-AS-Result: No-2.858000-8.000000-10
X-TMASE-MatchedRID: wwj5Mg7bCWSKv8OoSrxC1sGNvKPnBgOa8vvksslXuLdjLp8Cm8vwFwoe
        RRhCZWIBI5Skl4cZDuybHAuQ1dUnuWJZXQNDzktSz9eQMMSRXh6VLkhtDy7dOlVkJxysad/Ii9w
        qKeXPJfXMnDaM0QXFX91U9pcYm07gZDerX7ohbYtbUzvsaHW6Btx+VRsvvQnCr//pfSKj0fF4wW
        iC1lUZQol7/DJo56qNpL8+43M327xKIVgWeEFfup4CIKY/Hg3AtOt1ofVlaoLWRN8STJpl3PoLR
        4+zsDTtHtexZ1+/9PlU7Tzpw2bC+cshxWSDk2q64GfpfD8fetMkt4+cDnckSAN35bIg9RiWgHZj
        NSvT2S3C941IqBMqFRlfaiv0NfS+LtMZUQL+5z585uoYr0mmWaKdpX90rRoSErdW3Lyhe2TZKwv
        JjiAfi8C+ksT6a9fy
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.858000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25544.003
X-MDID: 1594904565-o1D4oCWsyTwX
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
index f62f3be1238b..d415d25e532a 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -163,7 +163,62 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev) {}
 
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

