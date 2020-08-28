Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF12C256002
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 19:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgH1RuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 13:50:14 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:34088 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726851AbgH1RuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 13:50:11 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7EC4E2008E;
        Fri, 28 Aug 2020 17:50:10 +0000 (UTC)
Received: from us4-mdac16-65.at1.mdlocal (unknown [10.110.50.184])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7D0F2800A4;
        Fri, 28 Aug 2020 17:50:10 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.105])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 06B6140072;
        Fri, 28 Aug 2020 17:50:10 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C3C999C007F;
        Fri, 28 Aug 2020 17:50:09 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 28 Aug
 2020 18:50:05 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 1/4] sfc: fix W=1 warnings in
 efx_farch_handle_rx_not_ok
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <57fd4501-4f13-37ee-d7f0-cda8b369bba6@solarflare.com>
Message-ID: <d812d896-cd2b-55c1-2cc4-56d3a05b6bcd@solarflare.com>
Date:   Fri, 28 Aug 2020 18:50:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <57fd4501-4f13-37ee-d7f0-cda8b369bba6@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25630.005
X-TM-AS-Result: No-5.720700-8.000000-10
X-TMASE-MatchedRID: t0V6V3Db6XB4iHWtbxtYeUf49ONH0RaSeAFj7cib9nVk55TPiguhpV1o
        7wPE6VhYj7NfJ0vFpC6Jc7ISnvROQvSCkSozt+9huwdUMMznEA/Uk/02d006RQdkFovAReUoaUX
        s6FguVy32Y1WiB0k/cbTe+/bzifD+3drJ6tQCW57RS1KZr1Hv5uZM8S4DYUopVHilIMNtqvajxY
        yRBa/qJQPTK4qtAgwIPcCXjNqUmkV5zdAzex5xZtZparx86R6RF2kyiYZ/IlSQwD9bUlk1rkD7J
        gBBs/2R0BA9poLd6tSUTGVAhB5EbQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.720700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25630.005
X-MDID: 1598637010-GbZl-SWRmsg1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of these RX-event flags aren't used at all, so remove them.
Others are used only #ifdef DEBUG to log a message; suppress the
 unused-var warnings #ifndef DEBUG with a void cast.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/farch.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index d07eeaad9bdf..aff2974e66df 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -863,13 +863,8 @@ static u16 efx_farch_handle_rx_not_ok(struct efx_rx_queue *rx_queue,
 	bool rx_ev_tcp_udp_chksum_err, rx_ev_eth_crc_err;
 	bool rx_ev_frm_trunc, rx_ev_tobe_disc;
 	bool rx_ev_other_err, rx_ev_pause_frm;
-	bool rx_ev_hdr_type, rx_ev_mcast_pkt;
-	unsigned rx_ev_pkt_type;
 
-	rx_ev_hdr_type = EFX_QWORD_FIELD(*event, FSF_AZ_RX_EV_HDR_TYPE);
-	rx_ev_mcast_pkt = EFX_QWORD_FIELD(*event, FSF_AZ_RX_EV_MCAST_PKT);
 	rx_ev_tobe_disc = EFX_QWORD_FIELD(*event, FSF_AZ_RX_EV_TOBE_DISC);
-	rx_ev_pkt_type = EFX_QWORD_FIELD(*event, FSF_AZ_RX_EV_PKT_TYPE);
 	rx_ev_buf_owner_id_err = EFX_QWORD_FIELD(*event,
 						 FSF_AZ_RX_EV_BUF_OWNER_ID_ERR);
 	rx_ev_ip_hdr_chksum_err = EFX_QWORD_FIELD(*event,
@@ -918,6 +913,8 @@ static u16 efx_farch_handle_rx_not_ok(struct efx_rx_queue *rx_queue,
 			  rx_ev_tobe_disc ? " [TOBE_DISC]" : "",
 			  rx_ev_pause_frm ? " [PAUSE]" : "");
 	}
+#else
+	(void) rx_ev_other_err;
 #endif
 
 	if (efx->net_dev->features & NETIF_F_RXALL)

