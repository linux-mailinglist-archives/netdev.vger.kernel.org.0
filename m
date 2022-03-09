Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148754D3D03
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 23:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237314AbiCIWfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 17:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbiCIWf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 17:35:29 -0500
Received: from smtp1.emailarray.com (smtp1.emailarray.com [65.39.216.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB51121685
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 14:34:29 -0800 (PST)
Received: (qmail 24358 invoked by uid 89); 9 Mar 2022 22:34:28 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 9 Mar 2022 22:34:28 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com,
        kernel-team@fb.com
Subject: [PATCH net-next] ptp: ocp: add UPF_NO_THRE_TEST flag for serial ports
Date:   Wed,  9 Mar 2022 14:34:27 -0800
Message-Id: <20220309223427.34745-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

The serial port driver attempts to test for correct THRE behavior
on startup.  However, it does this by disabling interrupts, and
then intentionally trying to trigger an interrupt in order to see
if the IIR bit is set in the UART.

However, in this FPGA design, the UART interrupt is generated
through the MSI vector, so when interrupts are re-enabled after
the test, the DMAR-IR reports an unhandled IRTE entry, since
no irq handler is installed at this point - it is installed
after the test.

This only happens on the /second/ open of the UART, since on the
first open, the x86_vector has installed and activated by the
driver probe, and is correctly handled.  When the serial port is
closed for the first time, this vector is deactivated and removed,
leading to this error.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 36c09269a12d..64cc92c2426b 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1752,7 +1752,7 @@ ptp_ocp_serial_line(struct ptp_ocp *bp, struct ocp_resource *r)
 	uart.port.mapbase = pci_resource_start(pdev, 0) + r->offset;
 	uart.port.irq = pci_irq_vector(pdev, r->irq_vec);
 	uart.port.uartclk = 50000000;
-	uart.port.flags = UPF_FIXED_TYPE | UPF_IOREMAP;
+	uart.port.flags = UPF_FIXED_TYPE | UPF_IOREMAP | UPF_NO_THRE_TEST;
 	uart.port.type = PORT_16550A;
 
 	return serial8250_register_8250_port(&uart);
-- 
2.31.1

