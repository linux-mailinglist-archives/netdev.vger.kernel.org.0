Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C85859FE16
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 17:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239430AbiHXPRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 11:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239190AbiHXPRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 11:17:42 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8A997D68
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 08:17:41 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id m5so13778834lfj.4
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 08:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=RRzl19XtFuDhqkpUxzSuU1rAjznv5CD+B4wp7QmKqeY=;
        b=lUGGsRCI/+a2suS8v7WQJ5HSBrXXTWgAwE6Mxd5BA8v9fCfizN0vgeofnTg+CXGYY6
         02DA1bvUtV4oslC1ZYeDxPhMOrBwbX74bH3NU3qJ9va6+2j2pTK2ywqWKy9tcBnebbrp
         fuJIJEOG9tjfX+EQb1IFDKD/TajOUqdoORdmBuyuKj00gp+eRea3YkN+IZxahxTDu0DR
         RK94RYPjWdNpfOchk3Tmgr2BqQMX2CCDpyc9RZQbuCDrW1irccuuXoU9cDLf/m24+QvD
         k3ieFuE1/3WQDS144t0SKkEegps7ZSnD9D+RafLBzz8brwqe2M5jXmHitemNoSnPgut9
         CH+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=RRzl19XtFuDhqkpUxzSuU1rAjznv5CD+B4wp7QmKqeY=;
        b=YlA9NECd2OfrZod005AzLoLOS3PuP9HWHKCaIvvLnqBYWHUpVlNP8aqc8aFlfKKUXE
         vS7RksGuFlg+7VCOSwnfb3vysDMwxuQX0K/2TP6U3R9CFAzDc0cHp5FmFNhgNhfjeoNy
         F440A25cVZN7Ho+ig0plqc8DmbSzRVgIcxWEHgT1r0P+HzhR/IDiwHy7UndaE+SbeAjs
         W5gjWu6NednzJBkQCJpIJk+aeVs31FaIvifhUV3DgYx3RgqRZpjX0igDT6cM8bqfBFlx
         zsA2W1AgJFA8pPFIeHZnQ9drHFEc8E/sbPZ/ntMmqvgn4pJqZnD5RFkvXIL7rhK27pA4
         niwQ==
X-Gm-Message-State: ACgBeo0OgmXufL/NQupCDvBYF7mih/0O6R+O1XJDNrtG9vNkio5GZaks
        l5t96koJ/R713TdLEtOiF5nFoKPVmPjISUoQ
X-Google-Smtp-Source: AA6agR6ahLIXGxgUYsNu+aa9gSW77bFkpbVT15WtKy1fahrvRpDUnnsX4TKVfzyvI460QSeWg8EPGg==
X-Received: by 2002:a05:6512:10ce:b0:492:d7cf:a149 with SMTP id k14-20020a05651210ce00b00492d7cfa149mr6605392lfg.400.1661354260009;
        Wed, 24 Aug 2022 08:17:40 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:aaa0:d600:b68d:708c])
        by smtp.gmail.com with ESMTPSA id m10-20020a056512014a00b0047f647414efsm3068053lfo.190.2022.08.24.08.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 08:17:39 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        tangbin@cmss.chinamobile.com, caizhichao@yulong.com,
        Sergei Antonov <saproj@gmail.com>
Subject: [PATCH net-next] net: ftmac100: add an opportunity to get ethaddr from the platform
Date:   Wed, 24 Aug 2022 18:17:24 +0300
Message-Id: <20220824151724.2698107-1-saproj@gmail.com>
X-Mailer: git-send-email 2.34.1
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

This driver always generated a random ethernet address. Leave it as a
fallback solution, but add a call to platform_get_ethdev_address().
Handle EPROBE_DEFER returned from platform_get_ethdev_address() to
retry when EEPROM is ready.

Signed-off-by: Sergei Antonov <saproj@gmail.com>
---
 drivers/net/ethernet/faraday/ftmac100.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index 2e6524009b19..a9af5b4c45b6 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -1077,6 +1077,10 @@ static int ftmac100_probe(struct platform_device *pdev)
 	netdev->netdev_ops = &ftmac100_netdev_ops;
 	netdev->max_mtu = MAX_PKT_SIZE;
 
+	err = platform_get_ethdev_address(&pdev->dev, netdev);
+	if (err == -EPROBE_DEFER)
+		goto defer_get_mac;
+
 	platform_set_drvdata(pdev, netdev);
 
 	/* setup private data */
@@ -1138,6 +1142,7 @@ static int ftmac100_probe(struct platform_device *pdev)
 	release_resource(priv->res);
 err_req_mem:
 	netif_napi_del(&priv->napi);
+defer_get_mac:
 	free_netdev(netdev);
 err_alloc_etherdev:
 	return err;
-- 
2.34.1

