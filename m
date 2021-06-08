Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F333A05A1
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 23:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhFHVXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 17:23:05 -0400
Received: from mx4.wp.pl ([212.77.101.12]:53775 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231712AbhFHVXF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 17:23:05 -0400
Received: (wp-smtpd smtp.wp.pl 9564 invoked from network); 8 Jun 2021 23:21:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1623187269; bh=lBM9fagQUsqB5rm/xWIhTisDyZOvVhgoTpGJnaeI+fE=;
          h=From:To:Cc:Subject;
          b=KChRhIdhFcNqZ/31gvgN7CfBzAFoVZFyK9yFkJyW/1kq3iNkFD8a4ATlamZxArnyF
           9M6h3TFss+ME/x6n3FcYSosD75HHmHoGhmYBSgFDcABV8hT7JfHDw0HSzWheBvo0Yi
           NSd24gACxoGzNHWSJT7rgwif48nNRMpltXyurlaQ=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 8 Jun 2021 23:21:09 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH net] net: lantiq: disable interrupt before sheduling NAPI
Date:   Tue,  8 Jun 2021 23:21:07 +0200
Message-Id: <20210608212107.222690-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: 74f9476f921faa77c221978c56049973
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [gUPk]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes TX hangs with threaded NAPI enabled. The scheduled
NAPI seems to be executed in parallel with the interrupt on second
thread. Sometimes it happens that ltq_dma_disable_irq() is executed
after xrx200_tx_housekeeping(). The symptom is that TX interrupts
are disabled in the DMA controller. As a result, the TX hangs after
a few seconds of the iperf test. Scheduling NAPI after disabling
interrupts fixes this issue.

Tested on Lantiq xRX200 (BT Home Hub 5A).

Fixes: 9423361da523 ("net: lantiq: Disable IRQs only if NAPI gets scheduled ")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_xrx200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 36dc3e5f6218..0e10d8aeffe1 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -352,8 +352,8 @@ static irqreturn_t xrx200_dma_irq(int irq, void *ptr)
 	struct xrx200_chan *ch = ptr;
 
 	if (napi_schedule_prep(&ch->napi)) {
-		__napi_schedule(&ch->napi);
 		ltq_dma_disable_irq(&ch->dma);
+		__napi_schedule(&ch->napi);
 	}
 
 	ltq_dma_ack_irq(&ch->dma);
-- 
2.30.2

