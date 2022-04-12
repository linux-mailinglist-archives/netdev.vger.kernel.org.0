Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F7E4FE73F
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358368AbiDLRjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347117AbiDLRjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:39:05 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980FD5F8F9;
        Tue, 12 Apr 2022 10:36:47 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id p15so38744787ejc.7;
        Tue, 12 Apr 2022 10:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ek5IZF4QsiCOGMfala/H8lskYq2jep0oZg3B2DCoBUI=;
        b=FVP1yKaVPQEsrNiLcbE21956MmEFBCGiSO1WoGkJKxPTWG4EfuA+BZSLXuIKM3r4Es
         x+t9lqxEeDX6lq4r+Uyys6wIWTyt+gJCIUhc604f7DdxTktzzSuapECN7tGjJPJ3zo2l
         R93Q44ySF6RSbrOfVO0+3ovnLht+s06hO6Lr6aMbx4D2Gjb58oqxUZs5z2i8UiC3lttP
         NT9tMwH1MCp5NFyTKN3d332nni6Z7Xz7SdISyH4TeBty9RV99QmNL7LHgspcgJUmeaLU
         X6wtu+825BqQtcwe5GuYr46PQKq/qs4yJ8x2OWhsCjC+6ye9RPG3xidySBJv02ebrxuV
         jHpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ek5IZF4QsiCOGMfala/H8lskYq2jep0oZg3B2DCoBUI=;
        b=vwtjsX9nv/bsaDUAi1S2RCSnTmTz3aL8X3pbaT15EVHYwg/2u2qLty/FnQIbH+cjvX
         XA4h29xXM35gGGywZdomNaVGmDoi5epNNngNmYsPt8LewylfJIbAKRNt8Ite88EfRof0
         +ouANdh0i/SHpfu17s9OC0ru9pgdrF0fVM18bSX+1cjcoUbF3FGAadpqg22+Gt9HLbGM
         br6EUIX1IHSmmsZNx8atiBRjjeDLWKwsg/98apxDHeToRn+2iWorhwUdB5vO50tEHpEl
         HlraLtPtpdv/l2fwknc+BVQATjkG2fB8q9TMw9u+yGxXpEQY+qsnfGv43hPgazgqBFKM
         durg==
X-Gm-Message-State: AOAM533H6UEXW72nJX1CDu5L9k63z1AujpDmOngPlqlcv6QS9didZi6F
        nN78F/ojXX923VylsteQn5U=
X-Google-Smtp-Source: ABdhPJwjjUQ9yQsNQHq3wO2SJzfZi1mt85GURM9Sk2gfjlJZ25UbJh6WPNglvGQS5aDTjxuiS/ikGw==
X-Received: by 2002:a17:906:3a18:b0:6cd:ba45:995f with SMTP id z24-20020a1709063a1800b006cdba45995fmr35679690eje.328.1649785005942;
        Tue, 12 Apr 2022 10:36:45 -0700 (PDT)
Received: from localhost.localdomain ([5.171.105.8])
        by smtp.googlemail.com with ESMTPSA id n11-20020a50cc4b000000b0041d8bc4f076sm48959edi.79.2022.04.12.10.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 10:36:45 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v2 0/4] Reduce qca8k_priv space usage
Date:   Tue, 12 Apr 2022 19:30:15 +0200
Message-Id: <20220412173019.4189-1-ansuelsmth@gmail.com>
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

These 4 patch is a first attempt at reducting qca8k_priv space.
The code changed a lot during times and we have many old logic
that can be replaced with new implementation

The first patch drop the tracking of MTU. We mimic what was done
for mtk and we change MTU only when CPU port is changed.

The second patch finally drop a piece of story of this driver.
The ar8xxx_port_status struct was used by the first implementation
of this driver to put all sort of status data for the port...
With the evolution of DSA all that stuff got dropped till only
the enabled state was the only part of the that struct.
Since it's overkill to keep an array of int, we convert the variable
to a simple u8 where we store the status of each port. This is needed
to don't reanable ports on system resume.

The third patch is a preparation for patch 4. As Vladimir explained
in another patch, we waste a tons of space by keeping a duplicate of
the switch dsa ops in qca8k_priv. The only reason for this is to
dynamically set the correct mdiobus configuration (a legacy dsa one,
or a custom dedicated one)
To solve this problem, we just drop the phy_read/phy_write and we
declare a custom mdiobus in any case. 
This way we can use a static dsa switch ops struct and we can drop it
from qca8k_priv

Patch 4 finally drop the duplicated dsa_switch_ops.

This series is just a start of more cleanup.

The idea is to move this driver to the qca dir and split common code
from specific code. Also the mgmt eth code still requires some love
and can totally be optimized by recycling the same skb over time.

Also while working on the MTU it was notice some problem with
the stmmac driver and with the reloading phase that cause all
sort of problems with qca8k.

I'm sending this here just to try to keep small series instead of
proposing monster series hard to review.

v2:
- Rework MTU patch

Ansuel Smith (4):
  drivers: net: dsa: qca8k: drop MTU tracking from qca8k_priv
  drivers: net: dsa: qca8k: drop port_sts from qca8k_priv
  drivers: net: dsa: qca8k: rework and simplify mdiobus logic
  drivers: net: dsa: qca8k: drop dsa_switch_ops from qca8k_priv

 drivers/net/dsa/qca8k.c | 144 +++++++++++++++-------------------------
 drivers/net/dsa/qca8k.h |  12 ++--
 2 files changed, 56 insertions(+), 100 deletions(-)

-- 
2.34.1

