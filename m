Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23A54B2C9B
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 19:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352503AbiBKSPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 13:15:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352472AbiBKSPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 13:15:17 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D734D41;
        Fri, 11 Feb 2022 10:15:16 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644603315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Cnx2U3ehecH1EXxHKkd2xHBgTX+RcdbAsjgFaXCm/o=;
        b=YZ2aHIHsD3RWbbdNTfg/nEFEtQHZr31lprXJboGVJI224gluh9gtvnKfHyGVWj60rEWUr/
        DAZumWiOCGMCrl0FIMaD0+Fl161Sx7vAUaQ2gaSAgMmefx8F/fgucRrqjmu/V1OKPhOlPE
        dJCurBSE+tULZwKRyy18s8Zg/iPOcSuNvS3orzlwdE+y8Z0hJLEMN3sX5XQt24bWRG2TWI
        mMR3stxnfg7xbFXYHKcpU6wsFGxLOR8rZEW1uUrXDt/I6CbPtGUR5J/j4qe8NyohcDOzXj
        gF7ST1PivBuZr68N4ubPOyz6h4VeLySJtoB549IFV5oPP2237lLBl2AfQUE1Aw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644603315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Cnx2U3ehecH1EXxHKkd2xHBgTX+RcdbAsjgFaXCm/o=;
        b=PJrnP0HKK3oE2sDAfnkGEx4hPVdxi/YqKdzCfqnBTYMf81IAZlyROFp+ej2ZXqduNASxfV
        yajtfT0Zfq/+BGDA==
To:     greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michael Below <below@judiz.de>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: [PATCH v4 2/7] i2c: core: Use generic_handle_irq_safe() in i2c_handle_smbus_host_notify().
Date:   Fri, 11 Feb 2022 19:14:55 +0100
Message-Id: <20220211181500.1856198-3-bigeasy@linutronix.de>
In-Reply-To: <20220211181500.1856198-1-bigeasy@linutronix.de>
References: <20220211181500.1856198-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The i2c-i801 driver invokes i2c_handle_smbus_host_notify() from his
interrupt service routine. On PREEMPT_RT i2c-i801's handler is forced
threaded with enabled interrupts which leads to a warning by
handle_irq_event_percpu() assuming that irq_default_primary_handler()
enabled interrupts.

i2c-i801's interrupt handler can't be made non-threaded because the
interrupt line is shared with other devices.

Use generic_handle_irq_safe() which can invoked with disabled and enabled
interrupts.

Reported-by: Michael Below <below@judiz.de>
Link: https://bugs.debian.org/1002537
Cc: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Acked-by: Wolfram Sang <wsa@kernel.org>
---
 drivers/i2c/i2c-core-base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 2c59dd748a49f..3f9e5303b6163 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1424,7 +1424,7 @@ int i2c_handle_smbus_host_notify(struct i2c_adapter *=
adap, unsigned short addr)
 	if (irq <=3D 0)
 		return -ENXIO;
=20
-	generic_handle_irq(irq);
+	generic_handle_irq_safe(irq);
=20
 	return 0;
 }
--=20
2.34.1

