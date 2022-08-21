Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F8B59B55A
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 18:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiHUQIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 12:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiHUQIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 12:08:51 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA97140A8
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 09:08:49 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id s1so9432995lfp.6
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 09:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=6sWXp675pYqOez/EMhPpg5tHuwKzInKuJMmEB2E9JA0=;
        b=QSla3pWZW0rAYopThSLnHm9YCtbe95uFHNSelPNe3SRGpbR5R1DKYJoFbezZ91C7wS
         c6yCq2V/W5j3UKhNb4Zn+nVtqwcLjs1VMsPDSIYGKhW2FLEyJUmqn0BngQ6vcEhpKUdz
         6cnBwW88LXCrHcBuHKF+Oni8Aa8r3rzQSrFLcyPQzpHr0qHCIlgCK1HVcUMf+ZLbusyh
         mOtHT4i2tuaqZrBYYCbRo0HrJJPo/CLTW33NUM0UigagXKuhNsRzFqxUAnS6BjUA5da/
         fkP125ip+8qJKQtJYvWCbGSw7BZsQFnfIL5A2FlM0QmrcWr757wOAJGpE2SqhUq0gjBf
         K8PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=6sWXp675pYqOez/EMhPpg5tHuwKzInKuJMmEB2E9JA0=;
        b=E8j8cv+jA33RT9jA14vTZAGH2byYddf7Nd3iQb0Lz2rejkYlFwQTVspA2npdnOjhIi
         jNJfPAgLdDAMDnQixm1YILbGICRlulqYw/FiG1mXBRFFtwVjpfOdFLIy3M7XtYmMTDdq
         Da3PtsofrEv90M4dEXh0TJALIMI5Qs2cCF4QWD4CXf/QGNgnkuBDtP30AcB5CIefx+A+
         ZhcNw7CG/f2lXIHDnLwR53o+nl4V1lGqTKJmeXhFjVPeQ4sRNszacfbHuJcM5JapIKQK
         bpx9NneFasCwupcMmM3rChZsWZ2Ezwq1grXCLgVwsjo1EkT+9bq0vLfGTA39+BbhXYtP
         sAlQ==
X-Gm-Message-State: ACgBeo1s+dmqjBvCJikr88nHA1CrMR7CX4nHuWkJEtLTP4AgHC/bq1v6
        43z5agQjrP1Qa/TOYgBbzXRRfYlBL49PEjbQ
X-Google-Smtp-Source: AA6agR6Lb/Jwlt7ER/hRtUJg5DrD+QKPmh4Mzcc9Em7fiSXuWRGUH60D/5cRM6IgkInPrTJ/4aLPmQ==
X-Received: by 2002:a05:6512:3d07:b0:492:c130:5381 with SMTP id d7-20020a0565123d0700b00492c1305381mr5159427lfv.497.1661098127270;
        Sun, 21 Aug 2022 09:08:47 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:4c08:28eb:df1e:6068])
        by smtp.gmail.com with ESMTPSA id s13-20020a056512214d00b0048b0526070fsm265315lfr.71.2022.08.21.09.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 09:08:46 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org,
        Sergei Antonov <saproj@gmail.com>
Subject: [PATCH] net: ftmac100: set max_mtu to allow DSA overhead setting
Date:   Sun, 21 Aug 2022 19:08:44 +0300
Message-Id: <20220821160844.474277-1-saproj@gmail.com>
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

In case ftmac100 is used with a DSA switch, Linux wants to set MTU
to 1504 to accommodate for DSA overhead. With the default max_mtu
it leads to the error message:
 ftmac100 92000000.mac eth0: error -22 setting MTU to 1504 to include DSA overhead

ftmac100 supports packet length 1518 (MAX_PKT_SIZE constant), so it is
safe to report it in max_mtu.

Signed-off-by: Sergei Antonov <saproj@gmail.com>
---
 drivers/net/ethernet/faraday/ftmac100.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index 8a341e2d5833..2e6524009b19 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -1075,6 +1075,7 @@ static int ftmac100_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 	netdev->ethtool_ops = &ftmac100_ethtool_ops;
 	netdev->netdev_ops = &ftmac100_netdev_ops;
+	netdev->max_mtu = MAX_PKT_SIZE;
 
 	platform_set_drvdata(pdev, netdev);
 
-- 
2.34.1

