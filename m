Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75344B8D2C
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 17:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235907AbiBPQDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 11:03:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235893AbiBPQDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 11:03:45 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3E22A82F0
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 08:03:31 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id t21so4703532edd.3
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 08:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cVf2ord3tIBpCLVkNiS9lYcPjPngvv8JI3RlnFJb+Go=;
        b=PE6RmbQHihPPqU838vHjMI2B6KANIAA60vsGXlioK2c14r9HRRCnAyIAFtZcPc5M5v
         vHklsRGq8sBkmbnEEhewG5I4T5L58MIRA4wMr1VL0mB9B7b3IqCgZnjscGjYiy7Uyq1r
         sXWDpeBxgy1QWWO5+N4JWEMAXvchDPUmLepsE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cVf2ord3tIBpCLVkNiS9lYcPjPngvv8JI3RlnFJb+Go=;
        b=l0sBd14icET5yMKcE9Ai5FB8iCzfWLUgPOAJiyD7wY73j7N5Vh7luiFZbZL+3D2Pe0
         HxK5+DZ/dGzWWADzOccPH7/y06jhdJhlwCDbECYqtfPmFmvzszmxgs9IKn3ZL1MKsLdH
         2q55DdIBwCdRIM55ReHIMvo7SP60jp6mirO8/Xbn1kQaRS+0XiJVJx1IWAvzzth7lzWE
         LRzrgl9AXZmML1N1vnT4oFhglx3ulKDn5fMIW5X+B/PytUqe/qtXZM+5IBq4uORDLSCs
         OvcX4PstUW9wFzXeXQ2bEWpa+YDpi65LJY0IV2BeJd/pXRFMEjbhFoiKDtlV8viRpGss
         Bm6g==
X-Gm-Message-State: AOAM533nm7R0k5W9YOJKe+bhTHYrqyWeB8RMxNKciYy22SYVe0GO8HzU
        98wr/kSnMQFv7drcohk2D433cQ==
X-Google-Smtp-Source: ABdhPJzE5vYsfrnjOM/Dn83mcfzSZE5qnr+QFMKaTFfPuxFyWZIJOO9b9Ae/w2RsYXFfrYc4ZZGxjg==
X-Received: by 2002:aa7:cac8:0:b0:410:cc6c:6512 with SMTP id l8-20020aa7cac8000000b00410cc6c6512mr3722719edt.408.1645027410012;
        Wed, 16 Feb 2022 08:03:30 -0800 (PST)
Received: from capella.. ([193.89.194.60])
        by smtp.gmail.com with ESMTPSA id j19sm48365ejm.111.2022.02.16.08.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 08:03:28 -0800 (PST)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] net: dsa: realtek: fix PHY register read corruption
Date:   Wed, 16 Feb 2022 17:04:58 +0100
Message-Id: <20220216160500.2341255-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

These two patches fix the issue reported by Arınç where PHY register
reads sometimes return garbage data.

MAINTAINERS: Please can you help me with the targetting of these two
patches? This bug is present ca. 5.16, when the SMI version of the
rtl8365mb driver was introduced. But now in net-next we have the MDIO
interface from Luiz, where the issue is also present. I am sending what
I think is an ideal patch series, but should I split it up and send the
SMI-related changes to net and the MDIO changes to net-next? If so, how
would I go about splitting it while preventing merge conflicts and build
errors?

For now I am sending it to net-next so that the whole thing can be
reviewed. If it's applied, I would gladly backport the fix to the stable
tree for 5.16, but I am still confused about what to do for 5.17.

Thanks for your help.


Alvin Šipraga (2):
  net: dsa: realtek: allow subdrivers to externally lock regmap
  net: dsa: realtek: rtl8365mb: serialize indirect PHY register access

 drivers/net/dsa/realtek/realtek-mdio.c | 46 +++++++++++++++++++++-
 drivers/net/dsa/realtek/realtek-smi.c  | 48 +++++++++++++++++++++--
 drivers/net/dsa/realtek/realtek.h      |  2 +
 drivers/net/dsa/realtek/rtl8365mb.c    | 54 ++++++++++++++++----------
 4 files changed, 124 insertions(+), 26 deletions(-)

-- 
2.35.0

