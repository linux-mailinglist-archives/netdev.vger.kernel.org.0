Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41B104B374
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 09:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731283AbfFSH5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 03:57:22 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39664 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731135AbfFSH5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 03:57:21 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so2222549wrt.6
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 00:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5dKyKaOwlavWxNSkxomQj1frz5OqSkhjLhkBVlvUo7s=;
        b=ejK7Vcn9eWef9XRwQvmw0FPGayQ+0xgjw6rLpse5J5EOiCfwH86gVbr23NxdAiAYAz
         eMD7JX0P6YlcM7qnACBvqdpu+yQEyetHWVoTwz4mWLVo7rvIH2DtSBrtdrAYABta595Z
         P1/ith7PGNoe+p6xnpQXwcX8upSBuw7wCDV/uV/ljf2hvrBztfpT7dc4sqA7m8TOmr5I
         P/obynNB9EymrZ8IfYL4d42BsiXNfINQTB52BRiTbAqmhng7zlGn/X4w7odwvb5Le5VO
         vEVBXxOq/Qgb7ng6V7+WzC5m9549f7JcUOoZrCy9rZATvTrvb4wfUpRChlQX5sxdcUmI
         sY9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5dKyKaOwlavWxNSkxomQj1frz5OqSkhjLhkBVlvUo7s=;
        b=CC0QvMNacouZTsXrqHsL2fcAP7UwoezAOTZlwjUImufzC0apCXdVTFD/dAJ0ZwYe3N
         HuzG487ehfZdKZr+FGOdKXIfzASG++rs60mxk3b2y7G+ootEVV9xwYFFsJshV1R26bHS
         7BTHXsS02HvLZYqEiB7p/c9sbMowWFNa0qBwekNZ+oBAJELpJyZkvYRTOuA/nFeTM5IN
         mstz87BU77prFet1hXThY7jf+vKjaNRDmrdQaxnHs0xAgqEwUmJXj1oba7MgbkcqVMfu
         IGAwXMrBukWL07btjhill/aiQMqR/pHwomVBnS/7Sp9sNYXA1kKRZRWUOs08v7Ru6552
         hYLw==
X-Gm-Message-State: APjAAAXWxEMR9DjVsEehMKVUIHqVqwA201U6sSkYLMyzwzgMXRYjxbka
        t1zcIfl0oupeP9FzCEkIQ2q7NZc65vA=
X-Google-Smtp-Source: APXvYqwgg8ybkeldMPu1AfSbjKneUv7jcLkZKZpkWFf29uDoOtyXVVph0Ci0bKdGa8XoTSWtRqvf/g==
X-Received: by 2002:a5d:46ce:: with SMTP id g14mr28806425wrs.203.1560931039621;
        Wed, 19 Jun 2019 00:57:19 -0700 (PDT)
Received: from apalos.lan (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id y133sm842572wmg.5.2019.06.19.00.57.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 19 Jun 2019 00:57:18 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     jaswinder.singh@linaro.org
Cc:     netdev@vger.kernel.org, ard.biesheuvel@linaro.org,
        masahisa.kojima@linaro.org, davem@davemloft.net,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [net-next, PATCH 2/2] net: netsec: remove loops in napi Rx process
Date:   Wed, 19 Jun 2019 10:57:14 +0300
Message-Id: <1560931034-6810-2-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560931034-6810-1-git-send-email-ilias.apalodimas@linaro.org>
References: <1560931034-6810-1-git-send-email-ilias.apalodimas@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netsec_process_rx was running in a loop trying to process as many packets
as possible before re-enabling interrupts. With the recent DMA changes
this is not needed anymore as we manage to consume all the budget without
looping over the function.
Since it has no performance penalty let's remove that and simplify the Rx
path a bit

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 drivers/net/ethernet/socionext/netsec.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index a10ef700f16d..48fd7448b513 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -820,19 +820,12 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 static int netsec_napi_poll(struct napi_struct *napi, int budget)
 {
 	struct netsec_priv *priv;
-	int rx, done, todo;
+	int done;
 
 	priv = container_of(napi, struct netsec_priv, napi);
 
 	netsec_process_tx(priv);
-
-	todo = budget;
-	do {
-		rx = netsec_process_rx(priv, todo);
-		todo -= rx;
-	} while (rx);
-
-	done = budget - todo;
+	done = netsec_process_rx(priv, budget);
 
 	if (done < budget && napi_complete_done(napi, done)) {
 		unsigned long flags;
-- 
2.20.1

