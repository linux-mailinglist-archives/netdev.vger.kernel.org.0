Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717943973B5
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 15:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbhFANCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 09:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233064AbhFANCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 09:02:19 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89806C061574;
        Tue,  1 Jun 2021 06:00:36 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id c20so14104469qkm.3;
        Tue, 01 Jun 2021 06:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=Fw6An070zveYAJQ7tdby9/Ztlto07U6GPJhm66jpGcU=;
        b=i9wiT7EX/t/133OY0aZzt72AkEqB27Qm0KwFu1HuQHFYbf0T3klVoqOpLw4E4wwJZZ
         auYzQR9JrDD35Qe8F6OTc7ZJsybvTd87pg7Vc+nvCdIwJS3qy5mKdKf7wCGWrMhzBs30
         VCwJV337q48G45sgEl1iuFaoiujaVtHVIEPT9cxGNve4CvVbV1WICd8wLpYl4dYatzeK
         7m2xiaAKc3szaoHQgI4VSgrF6a+MbElVborL5Xs8ezjJ+X4YwmhmKCjuF1YIzlH7nAir
         YXHiX/9wFzH+bhesOnTXt+sGk0sMnbITuJXv3gwK9lw1NBzQbX/aVQBvBqGz47YDxsRV
         7lLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Fw6An070zveYAJQ7tdby9/Ztlto07U6GPJhm66jpGcU=;
        b=CH2oqAs6rpekNGFzxznfCw8pvC78MvhjOV6N1CkNHeLa9CsbaT/caXLMYJdIFXVHZR
         hLgmaDU3CHp23o4FXQWC+dGIOEqsukPu98xP5nxU9JLFGAfthX2ulTRqYQdY3aeivW8k
         1AnW3XROjfyrurnp3Mpz+zQE4llhYFh0DOQHtTdqIo/jQClHZpghWRFA0wtUUAkvats4
         dy1mSMaQms5HX6L2V5baoGj5XX4rQ1gJDfzt8MlIr0G6f1vXRk0zVyqL39CisLJocTm4
         2F3yU1wtG8XBqe50n774ZClNGPlcKoSMVpuv1elNzd+l82fa1Qnr0TnUL0mXKT8tVwQp
         Rvpg==
X-Gm-Message-State: AOAM531f+r52xui60wi4qXe6mKsv24g9zIQTEVOmYs4oCwL5iFTQbx4F
        LDkFuiGYgt4LBcfFWndbztv5bRsSz2mTa0MI/ksjbg==
X-Google-Smtp-Source: ABdhPJx2FCEYNTg8buJha8b17AbLcXHSd+6eS6JmjUsxQTkFctOYegXHzovLaDTaWVEE8PwhI1KHnQ==
X-Received: by 2002:a05:620a:c0b:: with SMTP id l11mr2014876qki.181.1622552435772;
        Tue, 01 Jun 2021 06:00:35 -0700 (PDT)
Received: from fedora (cpe-68-174-153-112.nyc.res.rr.com. [68.174.153.112])
        by smtp.gmail.com with ESMTPSA id v20sm740015qtq.67.2021.06.01.06.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 06:00:35 -0700 (PDT)
Date:   Tue, 1 Jun 2021 09:00:33 -0400
From:   Nigel Christian <nigel.l.christian@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] NFC: microread: Pass err variable to async_cb()
Message-ID: <YLYvcbjuPg1JFr7/@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case MICROREAD_CB_TYPE_READER_ALL clang reports a dead
code warning. The error code is being directly passed to 
async_cb(). Fix this by passing the err variable, which is also
done in another path.

Addresses-Coverity: ("Unused value") 
Signed-off-by: Nigel Christian <nigel.l.christian@gmail.com>
---
 drivers/nfc/microread/microread.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/microread/microread.c b/drivers/nfc/microread/microread.c
index 8d3988457c58..130b0f554016 100644
--- a/drivers/nfc/microread/microread.c
+++ b/drivers/nfc/microread/microread.c
@@ -367,7 +367,7 @@ static void microread_im_transceive_cb(void *context, struct sk_buff *skb,
 				err = -EPROTO;
 				kfree_skb(skb);
 				info->async_cb(info->async_cb_context, NULL,
-					       -EPROTO);
+					       err);
 				return;
 			}
 
-- 
2.31.1

