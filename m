Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35C76B989A
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjCNPMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjCNPMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:12:20 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F385F8682
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:12:17 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id y14so2007202wrq.4
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112; t=1678806736;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6lp7x1udChMyC6p36QgEpyUbw26Dnd4AZnYOFOa5Qo4=;
        b=OfOLj5E0v38Ut8fTjAxC8eobEZqN4NIQfo0L7vn/Il398bYdBUyrxoMJiPvpc9N3IU
         dh4RsaUiwZvGd8cnPZl1TPziTeXtLrijd+0r9CUqYVlmHctII2bPPwkS9mVqjvfqclCl
         Rgxdh8jD+NDpKYR09FU3ljqGZe6G8vqHym6uooTjsWyUjLAiTxCDTEYQA6LzXDWWe6yV
         L85ZXiJJOJqzA0+B1izdlYrfPFrVqPmW8V7O56gW22TgdQxRI7GJmG7X7NJTFIGWMCYn
         3wZpPbDIpJODUCxKaIr0BNmNv5Hv+ZKNWrPLv59+IAMZwSaCHmA924r57bLbp4a75RyM
         DbJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678806736;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6lp7x1udChMyC6p36QgEpyUbw26Dnd4AZnYOFOa5Qo4=;
        b=F6uWsdPw7CAHeKEBEhM5/LpHdAGdqd7xHSrCIlG7O5oyE4ftLxu9PPkAF4vPAguucH
         9CmCtPmucpJvwOWJm5SbYU9bGG55wPads32RLl+Eq+N9BDUqlgFQiAa+XIQloBojAMiv
         E46qQJuqUooTDPfBwLlo0h8fQz2AZYP57VHQyPkp1tUPJoYFI6142aXIHfQvsW6dlT6K
         3fQu80ohl4lZMGdYmNBVrBbvPp8WhBCKI+Nk+ynZ66qyvnM88Mx1+V1ruInbuzsf6+FI
         LR9hRgu83H15JJUnBS4T9qffbwM6d+n5Sj9Yh1sDgNtTkCgtUHh9FU7C4DdEj9yeLBtW
         k8AQ==
X-Gm-Message-State: AO0yUKUbE5Vd8IYG/KXQXilxARprM5qkOcjnIimxnSqtPKTl2ScM3bP+
        4csaFoO9eT8e0DiUgfhxHKFBJg==
X-Google-Smtp-Source: AK7set/Zo4JBPdC3PLpPkUysS5ZC0JwIbWOhHgwVWdb8Cu0AbZAyEsqaC05iMVTGVzKyVreQZ5M7Nw==
X-Received: by 2002:adf:e30f:0:b0:2c8:309d:77b0 with SMTP id b15-20020adfe30f000000b002c8309d77b0mr26112983wrj.0.1678806736486;
        Tue, 14 Mar 2023 08:12:16 -0700 (PDT)
Received: from blmsp.fritz.box ([2001:4090:a247:8056:be7d:83e:a6a5:4659])
        by smtp.gmail.com with ESMTPSA id d9-20020a5d4f89000000b002c707b336c9sm2320158wru.36.2023.03.14.08.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 08:12:15 -0700 (PDT)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 0/5] can: tcan4x5x: Introduce tcan4552/4553
Date:   Tue, 14 Mar 2023 16:11:56 +0100
Message-Id: <20230314151201.2317134-1-msp@baylibre.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc and everyone,

This series introduces two new chips tcan-4552 and tcan-4553. The
generic driver works in general but needs a few small changes. These are
caused by the removal of wake and state pins.

I included two patches from the optimization series and will remove them
from the optimization series. Hopefully it avoids conflicts and not
polute the other series with tcan4552/4553 stuff.

Best,
Markus

optimization series:
https://lore.kernel.org/lkml/20221221152537.751564-1-msp@baylibre.com

Markus Schneider-Pargmann (5):
  dt-bindings: can: tcan4x5x: Add tcan4552 and tcan4553 variants
  can: tcan4x5x: Remove reserved register 0x814 from writable table
  can: tcan4x5x: Check size of mram configuration
  can: tcan4x5x: Rename ID registers to match datasheet
  can: tcan4x5x: Add support for tcan4552/4553

 .../devicetree/bindings/net/can/tcan4x5x.txt  |  11 +-
 drivers/net/can/m_can/m_can.c                 |  16 +++
 drivers/net/can/m_can/m_can.h                 |   1 +
 drivers/net/can/m_can/tcan4x5x-core.c         | 122 ++++++++++++++----
 drivers/net/can/m_can/tcan4x5x-regmap.c       |   1 -
 5 files changed, 121 insertions(+), 30 deletions(-)

-- 
2.39.2

