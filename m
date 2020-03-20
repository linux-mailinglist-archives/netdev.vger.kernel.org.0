Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 877F018C54A
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 03:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgCTCcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 22:32:05 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45010 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgCTCcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 22:32:03 -0400
Received: by mail-pl1-f193.google.com with SMTP id h11so1871207plr.11
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 19:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P+o/xmIwloxnf/kcXoii3cfLlqj1+C/3YOs388gSVDc=;
        b=1P/mN8+KKeiK28Z0o6s/+5xcg4SjG3wL4BRYANIVuxPmbSD5yuKGwJM8IX7DDEZzR4
         hI1Y/p9KWkI/pv7sw9a91FE+6x866ZVXqxx5iXgxZbm3i1g2Vt4x/zGRJkA8jbsYxr4F
         uOdKr7howU7Q5FwSyh/52ZbpWwY8Yj03mbosjM6VLeYrN0In1VQzkyl7jUCL+jeE5N5a
         i/zau3XRBYo1r/qRJxwTlriRcW4orBGwiWDmDua7Bimm+RYV4i9fs5CwxjGebmz4to/6
         fUrDJX+xoLb5DcE3vHlxLyvxMXE/2tecNhC2bmfXVfLb+UTLsjy4BIwonrK8Rk5qqksB
         9mtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P+o/xmIwloxnf/kcXoii3cfLlqj1+C/3YOs388gSVDc=;
        b=rU5XYl5xHAVsdr7R7YB7t9GY/dpqnAy+jwIUPkXAEgcTrxCDpaAcyB8e+LA/0IFcfM
         FfGbN+geWOiWqWaJQULX3FK7vjSM9b7vQhz33GPrL6JVzJLOrVsiwRN6OAheuFb104pn
         lU/7xXd9zOW6c+HjJh9bATRe9XuZonGrPnPB1BBo3pApkuxUfJgtUGvNB09OCdOigUW3
         tfcAzj4Ob46VGTEtACw+SZMFtSh9yXQV5U6vxF3taM+Bnx+PX0ynXzOF4lwIpeUc7ZsU
         LUq4EhMFq0QncAXJx5QtANu+CWKgHPyDMxWRiMnasKMfh0u50dHhAkjN0dbcFiWUpPCf
         tlWQ==
X-Gm-Message-State: ANhLgQ11bCTgpI4KBoKOg6LMbjjPsPc32tMoEPkcYmq/2C4uOC6OJVwQ
        +JGA4EULWTGTjTdS3Cyx8qiZDnmxQBo=
X-Google-Smtp-Source: ADFU+vtTpLYqy+am2jLeVag2fwFItsV2gvSUbCQQngaTZ6SHiviV/CTUHxGLndRk3SaHXk8A38/+Ag==
X-Received: by 2002:a17:902:eb11:: with SMTP id l17mr6222761plb.52.1584671522349;
        Thu, 19 Mar 2020 19:32:02 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i124sm3606485pfg.14.2020.03.19.19.32.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Mar 2020 19:32:01 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/6] ionic: leave dev cmd request contents alone on FW timeout
Date:   Thu, 19 Mar 2020 19:31:49 -0700
Message-Id: <20200320023153.48655-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320023153.48655-1-snelson@pensando.io>
References: <20200320023153.48655-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible (but unlikely) that FW was busy and missed a heartbeat
check but is still alive and will process the pending request, so don't
clean the dev_cmd in this case.  This occasionally occurs when working
with a card that is supporting many devices and is trying to shut them
all down at once, but still wants to see that last LIF disable request.

Fixes: 97ca486592c0 ("ionic: add heartbeat check")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index c5e3d7639f7e..a0dc100b12e6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -360,7 +360,10 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 		done, duration / HZ, duration);
 
 	if (!done && hb) {
-		ionic_dev_cmd_clean(ionic);
+		/* It is possible (but unlikely) that FW was busy and missed a
+		 * heartbeat check but is still alive and will process this
+		 * request, so don't clean the dev_cmd in this case.
+		 */
 		dev_warn(ionic->dev, "DEVCMD %s (%d) failed - FW halted\n",
 			 ionic_opcode_to_str(opcode), opcode);
 		return -ENXIO;
-- 
2.17.1

