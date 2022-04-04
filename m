Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683254F1540
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 14:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347995AbiDDMzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 08:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348004AbiDDMzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 08:55:45 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94222D59;
        Mon,  4 Apr 2022 05:53:49 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id s8so8837212pfk.12;
        Mon, 04 Apr 2022 05:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=jIV9Y0dd8y4b3CEUF8eRMe2tByfbEiPqIoiabx/kkpw=;
        b=eBKtBLQn+SP4KJCLMN2sVded5uPSZgjLkAsxVOwRYsQSNbW8bxsSsLP+EaTEE10KLs
         XZrz2H0BdSGfqRLPYGFtjBeY0kRTG9ye5UuM4Gkx5zXzIfDBEpO7u5ileh+cO3TQsdal
         DpWXX9IMyJRrpX7iQsWCLNZQR7LgWAdW7LzKKZ7pQ82lFZsb4PTeLZgRiACbx5rWtmpP
         nMVaPwG1C+6esy5oSJ3OtTUk7RwnfGdI8H4vZLSfiKxnlXtGgt7OO9jv7JeazN/c+hV6
         IKnNeSz1Wj7dpd8sFCQIuibmFS3Nd5eo+YoszAVBNkwZ1nB4GHMkhO2YXnBqZap6bMSj
         948A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jIV9Y0dd8y4b3CEUF8eRMe2tByfbEiPqIoiabx/kkpw=;
        b=56N3x5CtjokuEJbHD/7RdlzFcbt8FUJqi5Y2MNsitX+iCLBLpvLPgPWajVTjL8n1Mk
         Y6xebi3TobvuthvVpw3Lb0vhCobPNr+05LBfqG3m/l/OLlv5aAYk1H/OyY5jdvfW3/lf
         eJ69XIZdTiwn4j+TLQcZ310YOQL7AgdYirJwSnFlCDl6GIgzw66h+tOE/Up4rgCMgIca
         JPbaw70YK+7fWioZY9jGzZu1aeuYk1G5TbHskEcdivI0eWFO/luzCNiKsds71XCmXZ/D
         v1Im3gYoCtM6p+5jKyAXxjAORXiKirsv5J+D32muiqG3SNNA4u8FQO/0HN+Usz9U98Zy
         AXvQ==
X-Gm-Message-State: AOAM533C7Rkh30nBIvJl5JnpV/tXscyvjUByE65pT9PFPf4bu5s7gJOu
        jAU+vpHdD0Tcd2sHiZ1PFWI=
X-Google-Smtp-Source: ABdhPJwIsad3KgsoEe5jHm4OIOg+1mIx7tOqGDfZx7i1xTMC58FwhK86o0q7yAwR8m8ijJndIuW5oQ==
X-Received: by 2002:a05:6a00:1903:b0:4fa:fa9e:42e6 with SMTP id y3-20020a056a00190300b004fafa9e42e6mr23885823pfi.1.1649076828801;
        Mon, 04 Apr 2022 05:53:48 -0700 (PDT)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id 196-20020a6300cd000000b0039940fd184dsm1595419pga.9.2022.04.04.05.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 05:53:48 -0700 (PDT)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH] dpaa2-ptp: Fix refcount leak in dpaa2_ptp_probe
Date:   Mon,  4 Apr 2022 12:53:36 +0000
Message-Id: <20220404125336.13427-1-linmq006@gmail.com>
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

This node pointer is returned by of_find_compatible_node() with
refcount incremented. Calling of_node_put() to aovid the refcount leak.

Fixes: d346c9e86d86 ("dpaa2-ptp: reuse ptp_qoriq driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
index 5f5f8c53c4a0..c8cb541572ff 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
@@ -167,7 +167,7 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
 	base = of_iomap(node, 0);
 	if (!base) {
 		err = -ENOMEM;
-		goto err_close;
+		goto err_put;
 	}
 
 	err = fsl_mc_allocate_irqs(mc_dev);
@@ -210,6 +210,8 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
 	fsl_mc_free_irqs(mc_dev);
 err_unmap:
 	iounmap(base);
+err_put:
+	of_node_put(node);
 err_close:
 	dprtc_close(mc_dev->mc_io, 0, mc_dev->mc_handle);
 err_free_mcp:
-- 
2.17.1

