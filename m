Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E948453E7E0
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239049AbiFFNqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 09:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239044AbiFFNqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 09:46:14 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2D02462F7
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 06:46:12 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id me5so28543779ejb.2
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 06:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RyE/5WkFj4kqlM+hYKkTtPD1/Znyp8cf8vJddwwLwqc=;
        b=X2xiglIlatM2mHhAVLnJFiDCXvluwipGFTj/XlHQyveUL9xOTRIieaAtU8TGPNGFUi
         VlWUgrHV1wVRPumV4Se6O3GnFdP4bZpKaPwRDzx6lJv2s+Kzka/MCpraBHx2SXdnhGoh
         azcw+UNvxOSBfDYYdGcM867GBBU3m3a5j85z8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RyE/5WkFj4kqlM+hYKkTtPD1/Znyp8cf8vJddwwLwqc=;
        b=Au9MXolY79weHHlN1OqMZdAyzoP4ljJBbCypr4pFB6UWuIyOvKaI000ZlHkj4ljLqz
         mNUw9tFH1wd7fy2YutWYMdSQUmD3HWBbm9OjuPY+VjTdXbdeIZ7jkhhWQrx1HMkFya02
         dC7vIJUy1JXSZDnWRlsYoiiO7Gp/lWu1evRwRapzcSVxPtC9M2c65tezXABiRFdf1nwu
         dFNlNfsasLJlJ9EJqnbineWrpfyKG/+g5wXFoLfAddLL7j4WnK4qSv3ONK5NxBCq+NfX
         xKH4UuEISqJ7YERiAvZLnRdpT8oYGSCkgSvHsUzUsLeEHhbdcEJqL7k7LoE+njE3bx9d
         fM+Q==
X-Gm-Message-State: AOAM531EK8IlRXcf9ubXm2QoKuLIh4h4BxnQINUmival8WpCcB1RtzBj
        jC5X84qDlx5ODcDvChxzWMpxug==
X-Google-Smtp-Source: ABdhPJyw8lLr0zTjgm1NfJVlGHX1hiA8EEPgexnjx8LGyqOURB5i6kJLJIgcQDe3DvCCb664NKohag==
X-Received: by 2002:a17:906:27d4:b0:710:9a8a:85ef with SMTP id k20-20020a17090627d400b007109a8a85efmr11447815ejc.136.1654523171163;
        Mon, 06 Jun 2022 06:46:11 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id a26-20020a1709062b1a00b006f3ef214db4sm5496538ejg.26.2022.06.06.06.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 06:46:10 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     luizluca@gmail.com, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/5] net: dsa: realtek: rtl8365mb: improve handling of PHY modes
Date:   Mon,  6 Jun 2022 15:45:48 +0200
Message-Id: <20220606134553.2919693-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.36.0
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

This series introduces some minor cleanup of the driver and improves the
handling of PHY interface modes to break the assumption that CPU ports
are always over an external interface, and the assumption that user
ports are always using an internal PHY.

Alvin Šipraga (5):
  net: dsa: realtek: rtl8365mb: rename macro RTL8367RB -> RTL8367RB_VB
  net: dsa: realtek: rtl8365mb: remove port_mask private data member
  net: dsa: realtek: rtl8365mb: correct the max number of ports
  net: dsa: realtek: rtl8365mb: remove learn_limit_max private data
    member
  net: dsa: realtek: rtl8365mb: handle PHY interface modes correctly

 drivers/net/dsa/realtek/rtl8365mb.c | 268 ++++++++++++++++++++--------
 1 file changed, 189 insertions(+), 79 deletions(-)

-- 
2.36.0

