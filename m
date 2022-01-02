Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F045A482BCB
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 16:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbiABP6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 10:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbiABP6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 10:58:22 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BB9C061784
        for <netdev@vger.kernel.org>; Sun,  2 Jan 2022 07:58:20 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id bm14so127188863edb.5
        for <netdev@vger.kernel.org>; Sun, 02 Jan 2022 07:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OYdnWQTNQSkylqwGU9DXv097uGOIIbNIJox9C8EV798=;
        b=nPEm77WvYKR2bAuCELb6hDDj+BAogUAEoG0cTdk26QKla9SJ/K5GcQp6JK4qseNlLh
         ynCr0FEyuN9+JFK6l9ZYCzUOlcnUAhZKOfn1N+rHPKylr5vXskx4dClVu++IVn534dX1
         4pTIETDYTpcEc7k4eyzc9pCw1RYNrDcSQZZmQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OYdnWQTNQSkylqwGU9DXv097uGOIIbNIJox9C8EV798=;
        b=TpPbQrjOh7QV+ibalRH0DDYvsgQO66GN8o7JEofEzn2ADeVXMLTPc/mML3Av/j5Wr/
         asi1rKImHu/EUn4yvocuWDd3GT0DLtkWc3O2Y/cpKzUWD14DtGCKpCE2FWCBNzN2+cno
         NPa8fUH3CNNifKAWaUDJ81QnDns+e+ye9lUyyhK7IW6l2ZN2OSf9t/Oay1AiujQ26siy
         4YRkaWcwe9MVTF8yjn8zv2k7F/rxxwOGCsm9wKgMypMCZrpL6uKNUVDZQczuYMQ4c/QC
         leEcgTZhPs2/HzXIhgt1LgHmrB3yYzDyUqMFiLK6jDIIrsT93XqWpu8YcyP2YL4AeyWM
         KfHQ==
X-Gm-Message-State: AOAM53144/7nLFNHlyt5KdS7k//Verc+XV6suUKcoi2xbFrE6wOvFj0q
        oYViM6mrqPuMylcRijhkjfL0YQ==
X-Google-Smtp-Source: ABdhPJxs8ZXgg/b3bjvdNyPvKVD2JxQZJjYct8hwUTCt/YFUKUbmE7jl8MO1UjphdsF29E6CygnLKg==
X-Received: by 2002:a17:906:c110:: with SMTP id do16mr31724548ejc.743.1641139098569;
        Sun, 02 Jan 2022 07:58:18 -0800 (PST)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-95-244-92-231.retail.telecomitalia.it. [95.244.92.231])
        by smtp.gmail.com with ESMTPSA id j13sm9025584edw.89.2022.01.02.07.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 07:58:18 -0800 (PST)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Michael Nazzareno Trimarchi <michael@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] can: flexcan: switch the i.MX series to timestamp based rx-offload
Date:   Sun,  2 Jan 2022 16:58:13 +0100
Message-Id: <20220102155813.1646746-1-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As explained by commit b3cf53e988ce ("can: flexcan: add support for
timestamp based rx-offload"), the controller has 64 message buffers but
it uses only 6 for reception. Enabling timestamp mode, instead of FIFO,
allows you to use the maximum number of messages for reception.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Signed-off-by: Michael Nazzareno Trimarchi <michael@amarulasolutions.com>

---

 drivers/net/can/flexcan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 12b60ad95b02..40a6611b5d6e 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -397,11 +397,13 @@ static const struct flexcan_devtype_data fsl_p1010_devtype_data = {
 
 static const struct flexcan_devtype_data fsl_imx25_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_BROKEN_WERR_STATE |
-		FLEXCAN_QUIRK_BROKEN_PERR_STATE,
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE |
+		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP,
 };
 
 static const struct flexcan_devtype_data fsl_imx28_devtype_data = {
-	.quirks = FLEXCAN_QUIRK_BROKEN_PERR_STATE,
+	.quirks = FLEXCAN_QUIRK_BROKEN_PERR_STATE |
+		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP,
 };
 
 static const struct flexcan_devtype_data fsl_imx6q_devtype_data = {
-- 
2.32.0

