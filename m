Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6104D10A7
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 08:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344436AbiCHHDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 02:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbiCHHDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 02:03:40 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1995062DA;
        Mon,  7 Mar 2022 23:02:44 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id e13so16249069plh.3;
        Mon, 07 Mar 2022 23:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=A8EZjLfRCVLiqLB95fXPDgz0vTM6xfddeH/ZPy1XLa8=;
        b=e9VqiE0WD1f3eFyJbCKD5qtmN1MWAWvdxaMntfWIthz3hSCIyboXWObl6FvkQJhf/p
         AMHsv2ZHs4U5r2D+C+PngLux5lPfMiMXA5GFXSC9kibXFbQMfp8qjQAc0KbHrUFMfJyD
         kL8YtGRmo+LKsr8gfFWwLI8F8juVwgFSSzZeZyPFr5Rg5tmjkAQxtEG59rEoHHUCbdoy
         MEjTTtOVWk93reFJ51LPGpCEpazYQPKO7JR8HNOPpWFq+8C2nYUIvxWKxZz/qhf7wFez
         cW67Wa2SXlWnyjkJSf0N9tT+NynaAhfozGbWF5MM5tjZ5wjIaF6nya0mPuYpFKAtEJ8O
         Tmgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=A8EZjLfRCVLiqLB95fXPDgz0vTM6xfddeH/ZPy1XLa8=;
        b=tXgKxgIE9RIgsgdXRCGiSR0ibxYFchK/Wzw5YrtpXI+l2nyAyQ+O/bIfrfSFqcQa1Q
         bpzEoQ4AigMMijqAs64ee+xfJt9WXSxIOwO4wtSkdJ52cP2ufG54+oYxFBm2lBYJ2v7X
         Hbfb6u1MzuwkqtbaHAXkRi5zCU8Z375CpSSi+Qub5pdYqvA95gmTyoc2uZ5zrp7WVCmF
         ujtXdFS8aFvg4iL/WzyVr4MLMaLe/5JPNR4maIishsN5ZcQ8V6XKFveXQtCDWBja5goB
         V0x7TDx3EAmfegV7tffYXvBbhuVCVdJOMTe4n7IFTYGYl6/QQ6/dHqT6LCFmYpOoaC0x
         ifOw==
X-Gm-Message-State: AOAM53207v9hJ2wtmB7/brd2MIOiCLXo/J3dN50xilSVZXoSbsA8I9i/
        e1UABwmD0XslBjuxpqyh2DE=
X-Google-Smtp-Source: ABdhPJxGjxKfzDA2Y6r5ZxA67siNwEq9+SHU4CNGHkyYjf7dSP1TEsEhH8CTFj+l7OWKdjvW2BMCRA==
X-Received: by 2002:a17:902:bd88:b0:14f:8ddf:e373 with SMTP id q8-20020a170902bd8800b0014f8ddfe373mr15762890pls.89.1646722963584;
        Mon, 07 Mar 2022 23:02:43 -0800 (PST)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id d11-20020a056a00198b00b004dfc6b023b2sm18072135pfl.41.2022.03.07.23.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 23:02:43 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH] ath10k: Fix error handling in ath10k_setup_msa_resources
Date:   Tue,  8 Mar 2022 07:02:38 +0000
Message-Id: <20220308070238.19295-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.

This function only calls of_node_put() in the regular path.
And it will cause refcount leak in error path.

Fixes: 727fec790ead ("ath10k: Setup the msa resources before qmi init")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 9513ab696fff..f79dd9a71690 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1556,11 +1556,11 @@ static int ath10k_setup_msa_resources(struct ath10k *ar, u32 msa_size)
 	node = of_parse_phandle(dev->of_node, "memory-region", 0);
 	if (node) {
 		ret = of_address_to_resource(node, 0, &r);
+		of_node_put(node);
 		if (ret) {
 			dev_err(dev, "failed to resolve msa fixed region\n");
 			return ret;
 		}
-		of_node_put(node);
 
 		ar->msa.paddr = r.start;
 		ar->msa.mem_size = resource_size(&r);
-- 
2.17.1

