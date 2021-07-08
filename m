Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C838D3BF4F0
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 07:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhGHFLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 01:11:42 -0400
Received: from smtp-33.italiaonline.it ([213.209.10.33]:60573 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229593AbhGHFLm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 01:11:42 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it ([79.54.92.92])
        by smtp-33.iol.local with ESMTPA
        id 1MHPmgKzfS6GM1MHSmROYI; Thu, 08 Jul 2021 07:08:59 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1625720939; bh=PG7+0OU2DZ8x65xNZHYEsjNVrJqg8EVvkDKTGUcjQMQ=;
        h=From;
        b=ZzS6k5Y0h+IBO7aC8eraVFr0O1KrzhK1+rEjorEw0B6UTYWqXAeaFzqhH23Dw51Zi
         VX4wh5rtyj7clkFJPlBx6zWmPNnQwmspWS9Q8z0OM/vBO6xGaj2NUbSemSMCFnEwdt
         zhuP8iVqde7b/ykO0Cyossr1On2JcrgNTuj/UNbKcwIyqyRxtcx4JgfwFSeT1XKCn8
         UOgK6IkmaRPYVhYdw14NIi03uA4lIizhszHaqTr8AkBpHmK8iQd4bX7DQfVnuiV73Y
         DfUxaPNTvh76Td0x24Hqvf8q/xK7d+sygktpmAe1oP8RElX/CBB9KLNUEwadTTWAtc
         D+jB36Kesdssw==
X-CNFS-Analysis: v=2.4 cv=AcF0o1bG c=1 sm=1 tr=0 ts=60e6886b cx=a_exe
 a=eKwsI+FXzXP/Nc4oRbpalQ==:117 a=eKwsI+FXzXP/Nc4oRbpalQ==:17
 a=jKyqYac34V-d7di9rr0A:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH] ptp: fix PTP PPS source's lookup cookie set
Date:   Thu,  8 Jul 2021 07:08:49 +0200
Message-Id: <20210708050849.11959-1-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
X-CMAE-Envelope: MS4xfHQFkmo8U4DzJ1kL4fyFsNcOyE63XtDG80zVU6aMrtrTfQDIuNre7oxG3KXy++pKS6E21FrAY5USKvTLMx+HHajib/byWhzcKRoAyTMAuVJWkEXKJFXm
 8J+bDLoiNIUX3tIrex810RFQ3h4vA7ssY56QX8f3lOisLN5e2K31un75EYHEqGkPWfc7XN4ZVc34XY55gHrVsEG0AJmVFEV9IPmKraNWWbBAmWAV1DfWdGLN
 4CzmW/6IjUr9tjbu18t7wN4M6y4XVpHV0uzcqWa/4oOLEfQjJmqrpa3X8rOQXX1n6LfoXjsVE1dv41C2hcpop6Q9ZV2+r2ntQ79uUhoTNC2FiKTabRBa5gN5
 lzv6hIM7u2svzvMa1b+xtHubojd3n2vn0eCc0iJLTqp4FwkUGag=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The setting took place before the PTP PPS source was registered, so
ptp->pps_source was NULL.

Fixes: 8602e40fc813 ("ptp: Set lookup cookie when creating a PTP PPS source.")
Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

 drivers/ptp/ptp_clock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index a23a37a4d5dc..457129c07221 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -218,7 +218,6 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 			pr_err("failed to create ptp aux_worker %d\n", err);
 			goto kworker_err;
 		}
-		ptp->pps_source->lookup_cookie = ptp;
 	}
 
 	err = ptp_populate_pin_groups(ptp);
@@ -238,6 +237,8 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 			pr_err("failed to register pps source\n");
 			goto no_pps;
 		}
+
+		ptp->pps_source->lookup_cookie = ptp;
 	}
 
 	/* Initialize a new device of our class in our clock structure. */
-- 
2.17.1

