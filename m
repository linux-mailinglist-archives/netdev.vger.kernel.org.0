Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20292459A0C
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 03:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhKWCZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 21:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbhKWCZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 21:25:10 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D11C061574;
        Mon, 22 Nov 2021 18:22:02 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id b68so17847057pfg.11;
        Mon, 22 Nov 2021 18:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=28+tP/OkAykYUl1o7QKYHpxC47JznlPpaZr5ick491w=;
        b=TEfVdWM0CwdJHMk+bcVcwo5vt0WcbhOtuCR5OfHVyjgP6knxwEPazhzj3AxVpoYNJ5
         umI0jxpfXOp6+sWWfRqu/EYlflej60oUzbH/Riz52MgGy/kToZopcTsuZ0Yx9/yYmjhQ
         N/LXW9DDy3gonQRXrgD3b8Jv+z/bKefzP+dAkFJ9ycKYORAv25u599kt4qFEYvDtxCPW
         zVcmtDZZq6A8t9LmpM+H2Yvt3tqBxZZA2OkSARntfcxRUryyyoL49glPnua4w9BDE5/E
         vIpNXnZ664BzLiXsaqOgXPIPcVOHbaOd807SWn9W7Khv2Pmtn1pVGBU6Sy0oWZN4hCHm
         3WAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=28+tP/OkAykYUl1o7QKYHpxC47JznlPpaZr5ick491w=;
        b=qbLKzOOkMPZzjYOEM8wRko2dWcH0tQLfuc1lsoKdGiW92MnczBxXuotKjats90LbSU
         UxnA1VnvDBx4fwTPocgViqWcXn+ezLwPV7QDLFzzK8zdtjZdJ+5wAHhsflO3aDC1Wb2I
         y7lyYBxbqqkXkX3PO8EkVhDWc08qtuX+qqqptFEXnH2HD54PEOfRqvdeeWGRYt2rZCq6
         qeXWN6Ficz5EsXBhr1mqlU/Q2MLOJb/6wOuAYTAxoRjUntHeRjsNFlYNeWGDXVBjIaiV
         PR8/mVN5llSk1eRkX9gBl/LG2RmONM8JuQCSHv/eyLsAY9cM207+HvrBS1ymZXcz43WU
         iu0g==
X-Gm-Message-State: AOAM531pLMUAhMXtF6gZw4cUY+cKWfFQaDvwjuywISwxIszq2wUXNqiE
        ycSnbPapIVrsEyJ4HQiirA==
X-Google-Smtp-Source: ABdhPJxCJeDSVH4/u1ru07UtFftKEB6MluRehsKCNY1FMhyF+klJegSen0WPFRRTbbibTAeRJvMavg==
X-Received: by 2002:aa7:9d1e:0:b0:494:6dec:6425 with SMTP id k30-20020aa79d1e000000b004946dec6425mr1459245pfp.83.1637634122447;
        Mon, 22 Nov 2021 18:22:02 -0800 (PST)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id j8sm10620160pfc.8.2021.11.22.18.22.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Nov 2021 18:22:02 -0800 (PST)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] net: chelsio: cxgb4vf: Fix an error code in cxgb4vf_pci_probe()
Date:   Tue, 23 Nov 2021 02:21:50 +0000
Message-Id: <1637634110-3013-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the process of driver probing, probe function should return < 0
for failure, otherwise kernel will treat value == 0 as success.

Therefore, we should set err to -EINVAL when
adapter->registered_device_map is NULL. Otherwise kernel will assume
that driver has been successfully probed and will cause unexpected
errors.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 64479c464b4e..ae9cca768d74 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -3196,6 +3196,7 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 	}
 	if (adapter->registered_device_map == 0) {
 		dev_err(&pdev->dev, "could not register any net devices\n");
+		err = -EINVAL;
 		goto err_disable_interrupts;
 	}
 
-- 
2.25.1

