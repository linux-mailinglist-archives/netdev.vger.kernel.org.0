Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE455B91D9
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 02:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiIOAl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 20:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiIOAl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 20:41:26 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39FF86FFE
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 17:41:25 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id az6so12816761wmb.4
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 17:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=J//+WymCkxAKbyApy8R91YiSHN6Iph+FDvrIqQgf7Q0=;
        b=CcGShTlOE0aWLle2jb0G2g96FpzJWV0FTWW2ZSYCZE39XVoc8JInBM4nR3y0/vAbOi
         BveJp1DwGuzLqHdIwmV3h3Aj3LXsSYdkMT/vIqLLtvxCJcjbV3uu1PZa+BhzXUe/tpZG
         J+NXClbLPywnpkwtYAeG4LiiZZFHgF7frevTsjZLkjSu/wNNh5tgo7P5Mnh1rhNbUDIH
         7+rxzmBBbYHPMLKf/VVWk4v+njM7ZXREvHcjpE5TXBGmVraYMRrg28u3BBUlLucSeMDF
         6PgvoNeV8Yj7zM/LG894cAMwhOQ8j6J6XJbLvb1V9TtYg//qq8B9dn/lfOCshMV4sQ4m
         4Ykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=J//+WymCkxAKbyApy8R91YiSHN6Iph+FDvrIqQgf7Q0=;
        b=7EJe5BVCKbGNJ/n1p4aX4k5nuVANXa7ZAwD867i4KfM5QMCWIx3r9kl1o93FOVkS2B
         ogmYuESGjPyQUiGNpTsT//ub9jlMovK9EGWGX/LdFGyVFCxhFRDOffM4H6dGA+Zj+nap
         pso7xlxngx1q34K9ZATQX7dpKw01To4vEoUDMt8RWmIEpqy5me95XfwfF0sWA1ty2CH3
         wW38kMstBEu1YXEdy+i3y2r3UTXmV5mpMV9m14XM5ZV4SQb3p7b6K4UIYsU1RF7NdF/f
         kY3RqRBvC8viORmg5H54bCsVY1dIgfvAYApUJsB1aTeVdLtb8eTssAnz39+I3RnHnU2u
         wX8Q==
X-Gm-Message-State: ACgBeo2MwHrLckqV3M0BlE/81RtaiUC+anxO0VJZNrN/vXE4GuxBJ4GR
        REDVy79xXCvfDmotgsUy2lcV/Q==
X-Google-Smtp-Source: AA6agR6hsAbIEn4dM3zpyXg6FbohTXcuVeebojTAMvh6TiDIp/77ziegBgAjUJvhD/ZpWIf2IYapBg==
X-Received: by 2002:a05:600c:1da2:b0:3b4:856a:162c with SMTP id p34-20020a05600c1da200b003b4856a162cmr4736962wms.28.1663202484207;
        Wed, 14 Sep 2022 17:41:24 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id d8-20020adfef88000000b002250c35826dsm645476wro.104.2022.09.14.17.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 17:41:23 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     loic.poulain@linaro.org, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, bryan.odonoghue@linaro.org
Subject: [PATCH v3 0/1] wcn36xx: Use SNR as a source of system entropy
Date:   Thu, 15 Sep 2022 01:41:16 +0100
Message-Id: <20220915004117.1562703-1-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v3:
- Add explict mask for lower-bits per Jason's preference

v2:
- Pass sizeof(s8) not sizeof(int) as Loic pointed out only eight bits of data
  are relevant in the SNR.

- Reword the commit log. I didn't really like it on a second reading.
  It describes the theory a little better now I think.

Bryan O'Donoghue (1):
  wcn36xx: Add RX frame SNR as a source of system entropy

 drivers/net/wireless/ath/wcn36xx/txrx.c | 4 ++++
 1 file changed, 4 insertions(+)

-- 
2.37.3

