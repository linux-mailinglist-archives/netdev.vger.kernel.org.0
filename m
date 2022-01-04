Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCC4484241
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 14:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbiADNUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 08:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbiADNUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 08:20:46 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25ABDC061784
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 05:20:44 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id m21so149636673edc.0
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 05:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w/GkwF7Da5XIamKReKsj0HsZhSVJSApc2Gxuc5P0F58=;
        b=Orcz1Ulcpgxql5P3geTM4KS23mA4oqud5iffrm073yQbrJxGUBcEMP5qDl5yBdDLQI
         AkkRJeK0J2hxjMSkDJ/LI0n8tZaXDcEU8IsmptJNOyU/nfjPGY6b6EPr6vi/WVV7vlPW
         dcqTdvgIn4kjdLIVjHudOJWHuI2jvgO4PwYlA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w/GkwF7Da5XIamKReKsj0HsZhSVJSApc2Gxuc5P0F58=;
        b=OVctkAX/r2GCVgZVyH0EV6YdD5ONSOpoMNhOutCk8QdmuILaRSr1//Oiv9cCu2ZTsB
         D5IHgM2bnjFF7LsBrpxpLrkcDzX8LSR4boAQJydDvSCoDIhB6OH60AqfxxZ6uwWcV4KC
         ot9NnKj82de9mikad7rWOTDdhThA28skxSBb2mcAMPif51MLazKIws6/NuFDuC31aXLr
         KURVvE09aeG04FpynAjySh/M5SwUQUZFJ/x/IwJE4yDbr1XoLh3WbINwaR/mEUbAGm9l
         HaAAjpMH1Let6XtEYMX/rHcojmP5FV9luG4pqf10TbfjgtVh1fz2jE3sjbBvlOtk6mvP
         aJmA==
X-Gm-Message-State: AOAM533SdSEGETE6tEKqgc+9VK4/GnETTRkIzPaCE9XMltXMBOTAZgt9
        ZXHPXxAAoOlpZGphaeJ84DImSg==
X-Google-Smtp-Source: ABdhPJyJMtxLvzivI2st83HvXyyfiTOFhY2WMHimu9EkqSxFO2LU/qKMIFCwsOUEHgckh0mm3Sj7Hw==
X-Received: by 2002:a05:6402:491:: with SMTP id k17mr48221773edv.333.1641302442702;
        Tue, 04 Jan 2022 05:20:42 -0800 (PST)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-95-244-92-231.retail.telecomitalia.it. [95.244.92.231])
        by smtp.gmail.com with ESMTPSA id y13sm14765575edq.77.2022.01.04.05.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 05:20:42 -0800 (PST)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Michael Trimarchi <michael@amarulasolutions.com>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH 0/2] Change flexcan features at runtime
Date:   Tue,  4 Jan 2022 14:20:24 +0100
Message-Id: <20220104132026.3062763-1-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series was born from the review https://lkml.org/lkml/2022/1/2/127
by Marc Kleine-Budde. The ethtool module is minimal and lacks the
callback to change the setting at runtime (this has yet to be defined).
I'm certainly not an expert but might it make sense to use the
set_features() callback? Although I understand that it belongs to
`struct net_device_ops' and not to 'struct ethtool_ops'.


Dario Binacchi (2):
  can: flexcan: allow to change quirks at runtime
  can: flexcan: add ethtool support

 drivers/net/can/Makefile                      |   3 +
 drivers/net/can/flexcan.h                     | 107 +++++++++++++
 drivers/net/can/flexcan_ethtool.c             |  29 ++++
 drivers/net/can/{flexcan.c => flexcan_main.c} | 144 ++++--------------
 4 files changed, 166 insertions(+), 117 deletions(-)
 create mode 100644 drivers/net/can/flexcan.h
 create mode 100644 drivers/net/can/flexcan_ethtool.c
 rename drivers/net/can/{flexcan.c => flexcan_main.c} (92%)

-- 
2.32.0

