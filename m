Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320905033ED
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237636AbiDOXcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 19:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiDOXcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 19:32:51 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368B1F10;
        Fri, 15 Apr 2022 16:30:21 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id s25so10949310edi.13;
        Fri, 15 Apr 2022 16:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E1n7ctWBMqC7NQl+Foty7tMriTNl3+QSAKNR+g9qwv4=;
        b=dwIUoE2cHBkM/Fgr9UJeLIN12Sm8VuJnD7tK36Ta/DLCy6LDfSKsRpI/PV0wRMnPSt
         w5uPLJu1W7ShaFlXE56deadZtHaX6ttUyv63CiZcAP25fsxiJzLjCG9azRUchdFLgoFI
         dlpQhGPHwGxIT/Aj7GCcN4RZ5bIEwX0SBMwziH9o2qh3wCC9xY5IrULDHsj2NhWzUuu0
         m9Ky/LYb8OCR1pU1Lakh2yHKbGz79wt3AFJM1R4s4ifl2fbSxzG/rBi4Hor7Hb6sn1/S
         f0T+ui9HOyotl4hpRJgv5vbZYiUC1el196mfFopyTLDVMS8K/enj4JTuHsiy9tnTTJXT
         DcwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E1n7ctWBMqC7NQl+Foty7tMriTNl3+QSAKNR+g9qwv4=;
        b=knZE7zG7u+ZVKECK4tFm85WuO5gaGRwd7DiWjzyS1BCda32KaQzkQ63UnAuxFLZSuS
         0P6zso95LmJfxQFsUR33RBGaxbrKeo43eB10vzWAohvZP53dPXlbSf3gKQoWigEKWRrN
         RLhPGiVgT45M1M0lqRUJsGM2etgIHtt1/z+ib30CygF+su3+Sur2kx6377mO8VuyGlxk
         phNOPZG1MnSvJPt9+jRa2GSU9Crl0aZOWZpd4kIxN3ja/cAsqDF6Dhw1D+quYDSFA/fG
         BbPXGLPmQ10IicH7F2QAi0aJk0ucGiPLqdfPRTAz9iRj0nYTSziAAaRTK+QHWVoKVm7Q
         BdCg==
X-Gm-Message-State: AOAM533Rd1K4inUr3kqUmCLUcIUaHHUTiOgCrNu6h7ewsE/WvXZY69Tu
        VMg3Zf922Mdom2vIOJ3nIUM=
X-Google-Smtp-Source: ABdhPJw4XNhyYK2SEfopTBxlrAzgRGT+pJg8Nz6hyGP76A1DA5sv7X6uFkOr1SB7+4XN4UuvSpx8QA==
X-Received: by 2002:a05:6402:c13:b0:41d:71e1:9b8c with SMTP id co19-20020a0564020c1300b0041d71e19b8cmr1398531edb.258.1650065419518;
        Fri, 15 Apr 2022 16:30:19 -0700 (PDT)
Received: from localhost.localdomain (host-79-33-253-62.retail.telecomitalia.it. [79.33.253.62])
        by smtp.googlemail.com with ESMTPSA id z21-20020a1709063a1500b006da6436819dsm2114588eje.173.2022.04.15.16.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 16:30:18 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net-next PATCH v3 0/6] Reduce qca8k_priv space usage
Date:   Sat, 16 Apr 2022 01:30:11 +0200
Message-Id: <20220415233017.23275-1-ansuelsmth@gmail.com>
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

These 6 patch is a first attempt at reducting qca8k_priv space.
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

Patch 4 drop the duplicated dsa_switch_ops.

Patch 5 is a fixup for mdio read error.

Patch 6 is an effort to standardize how bus name are done.

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
v3:
- Drop unrealated changes from patch 3
- Add fixup patch for mdio read
- Unify bus name for legacy and OF mdio bus

*** BLURB HERE ***

Ansuel Smith (6):
  net: dsa: qca8k: drop MTU tracking from qca8k_priv
  net: dsa: qca8k: drop port_sts from qca8k_priv
  net: dsa: qca8k: rework and simplify mdiobus logic
  net: dsa: qca8k: drop dsa_switch_ops from qca8k_priv
  net: dsa: qca8k: correctly handle mdio read error
  net: dsa: qca8k: unify bus id naming with legacy and OF mdio bus

 drivers/net/dsa/qca8k.c | 145 +++++++++++++++-------------------------
 drivers/net/dsa/qca8k.h |  12 ++--
 2 files changed, 57 insertions(+), 100 deletions(-)

-- 
2.34.1

