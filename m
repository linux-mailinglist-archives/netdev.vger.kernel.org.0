Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02DC35061ED
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 03:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244128AbiDSCBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 22:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbiDSCBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 22:01:22 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773AF2F006;
        Mon, 18 Apr 2022 18:58:41 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id b17so12130726qvf.12;
        Mon, 18 Apr 2022 18:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WNU/TphCFnbVlBp1Z5GLi2lvQvgI9Sbk164GKyVPu8E=;
        b=hDaaH9Aj1f5M/81SYEwYOiK6gb2rb/RJ5UI25cuoR+XXx9AxrAW6gRCLn4XoPuw2vp
         MKeweM5OEOgh5mme7ASmV2f9nuogyfaCcbfGINPok9hAwddtEsxQQl8pahynBep7WiO0
         djDB87thbWxH7rUbQ9cvSzOXNMpMUllB1TOpzHJm/XWx6Bth+SMLyclxItqQ8C7bcFl2
         4mscroyzSj/MTHwfdxiRnRCdkWq6amSwmscjayA+ZnpL0oCNHGTyGpwwyrDlZK/C24uN
         YZEWbZgDMM0aWPYeFpujosa/VVMo++DDWogwSmgauK5dusjsyt5dTyS0aP84gbQJpWCX
         T4Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WNU/TphCFnbVlBp1Z5GLi2lvQvgI9Sbk164GKyVPu8E=;
        b=FZuDUdbESvkM5e/8mgHX1iRwGbQkWasP6pfh3biIkCVDKnBzQXC3G/A1DKKdhLHPt0
         RQwoE5CmvtcH9+AIcqQUGrJWwWM3V7qedUOJZWbOk+T5wena1haoG+MgjOK8uL3Ndvxf
         zFBzUIbbvd9f78t4g/uI3Vj2N/Crz16Sof8+Xt4x312VS6HIcDNn9lCJZaHHbpFWgAk2
         iq3NxJzTzKATDhQhPiQwuULruhPwJ5UHhJK8Db8QOLNyEZIdA1hsWLCy5Tcf3ocwdoHf
         czi7UinlXP1oaIvvLueuc7IL8lHwVqHZOS4AnDnQJ0b2zKhBfpZBfzTC9i/LJPKIzQHs
         oYzQ==
X-Gm-Message-State: AOAM533cmees6gAGAZ6Cp8ShaIOIWDRUgHZpzBnXjc+9GJ+PKjTjS96W
        owTmCv72W4AA03EeTp48ATY=
X-Google-Smtp-Source: ABdhPJwM2wWDgSXWxNeAPoGVjU8YN2SYfC/GsxDdiLjs1L6aTlJIWp5um2jAKuULyWgE6dXx0SQd2A==
X-Received: by 2002:a0c:a98a:0:b0:443:e880:501a with SMTP id a10-20020a0ca98a000000b00443e880501amr10190878qvb.73.1650333520662;
        Mon, 18 Apr 2022 18:58:40 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id g9-20020ac85d49000000b002f1fbe305e7sm3281002qtx.80.2022.04.18.18.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 18:58:40 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com
Cc:     Mark-MC.Lee@mediatek.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: ethernet: mtk_eth_soc: fix error check return value of debugfs_create_dir()
Date:   Tue, 19 Apr 2022 01:58:32 +0000
Message-Id: <20220419015832.2562366-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

If an error occurs, debugfs_create_file() will return ERR_PTR(-ERROR),
so use IS_ERR() to check it.

Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 drivers/net/ethernet/mediatek/mtk_wed_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c b/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
index a81d3fd1a439..0c284c18a8d7 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
@@ -165,7 +165,7 @@ void mtk_wed_hw_add_debugfs(struct mtk_wed_hw *hw)
 
 	snprintf(hw->dirname, sizeof(hw->dirname), "wed%d", hw->index);
 	dir = debugfs_create_dir(hw->dirname, NULL);
-	if (!dir)
+	if (IS_ERR(dir))
 		return;
 
 	hw->debugfs_dir = dir;
-- 
2.25.1

