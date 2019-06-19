Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 943444B5D8
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 12:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731510AbfFSKEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 06:04:09 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52837 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731423AbfFSKEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 06:04:08 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so1071506wms.2
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 03:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1fgMUEftCwlz2jZ0+44CQ5qx9KER8ZCjlEHRZ/xlXrU=;
        b=ysaKDqsE85Z9OLVRlsnTeHEsqvMt9Vowt+ZU0tZYZm6UTd4tJ01luhBv1NCKOIjB/a
         ygCyLg09asmsH71eodlG7dVF5LfdIj8BlSC/MEsMXopBkCEWmgNLMObZvAOfIi47aSMy
         HC1rHn2oCbxF1KA7A6JUfL/+X3Cbzyuoe+NJSWnNSvVHoaXu0pLcBuYwNpefzfD2lDOq
         Itw2czp+t4qK5J67/rHYiEYtA0O5W/8drLDT/Z4iXAkAXcVzT2yN3Kebq+5y9D+At89Z
         2KtRd8MqjBdg7nem/U7gJ/jeK9sCggWOgUymRzzHKJab3jcYL8O94cgL1aJMy23SgXUF
         yBsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1fgMUEftCwlz2jZ0+44CQ5qx9KER8ZCjlEHRZ/xlXrU=;
        b=UZtnEQD5/SWJ0m2CdWu1CW1+kPUDanylIR+inpe9LXnYSsQ6b8d+1F1oRkfk83kcjk
         NuewGwW9LSVr8VI7grbYesxdB9+lrQd2lmoMIr0zzDQdJVoEhSNlr4skLvOZlDIPyBd/
         diUv8h+hoONyK70QeDKq408zMkM1jH6aHi/UrZT3jK7DEBrC/gQSEKkq2DXy+MC1d2tM
         22+mj47Tj9NNMcY5swZ5lBjQk+iV4d98Qe+H1xorfjWn34UKJUTrRoAPJGpaVbebw59h
         l0JetKF7vLt3ExfOqlt4MPT5aJZhHdkrtspK/c+NzZxaJklVpaXjB2Cis2rPr/a3BQZT
         RkUQ==
X-Gm-Message-State: APjAAAWrUmey/0rcReN+owIIGnK3/USIJZyHcK7z/XHbfrwmKPRaU5+Z
        nUsbad+n+BeCDXXMzy7lXRUiGEu/J9o=
X-Google-Smtp-Source: APXvYqyEZqU79ChxoqGZX7xbPebqAuNc6XpiVYo7pTzTHWNu0BSXLdohN9j6UNcDmzG27Q19/npCAQ==
X-Received: by 2002:a1c:7d4e:: with SMTP id y75mr7614207wmc.169.1560938646440;
        Wed, 19 Jun 2019 03:04:06 -0700 (PDT)
Received: from apalos.lan (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id y184sm1197729wmg.14.2019.06.19.03.04.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 19 Jun 2019 03:04:05 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     jaswinder.singh@linaro.org
Cc:     netdev@vger.kernel.org, ard.biesheuvel@linaro.org,
        masahisa.kojima@linaro.org, davem@davemloft.net,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [net-next, PATCH 2/2, v2] net: netsec: remove loops in napi Rx process
Date:   Wed, 19 Jun 2019 13:04:01 +0300
Message-Id: <1560938641-16778-2-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560938641-16778-1-git-send-email-ilias.apalodimas@linaro.org>
References: <1560938641-16778-1-git-send-email-ilias.apalodimas@linaro.org>
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
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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

