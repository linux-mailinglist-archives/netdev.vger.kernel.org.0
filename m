Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236913A6666
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhFNMWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:22:24 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:41784 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233393AbhFNMWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 08:22:23 -0400
Received: by mail-ed1-f47.google.com with SMTP id g18so44236353edq.8
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 05:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=liYMUDr3dkA/DDxcxQG97Q4+m1jz380+d+yc0u9TVxg=;
        b=Ikhp7E0J4ceZznmArokTjQbYIcotdycnLm1ft9ANhKWxW4UQ6r+qkxokr2/f7+/NNd
         s/r/W8GF+vGN39kYOKrmRlh82HMuZwt3KX4mMZeRZqu88mOdk73oY6tPK9D67xENy+SS
         kGJcVSOYOOvO/hMZ57/Oe/EOsSSOMA7B0QvoksfHWhYdDHhr/SHfcqKFjaT1EYtL8cFT
         ZCt6zQ+NwUql64vhLc2s9MSwml2xq/CBDzJK35sBL5+I9sI59VQcV6RLXKvCV0mHopQE
         y+bA69kSGg5iMXMWO/jehdALOEc4JMVY4/Y8JuGWSsFwIhXpLtcAKuOfeAur1X6pvhrA
         R4Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=liYMUDr3dkA/DDxcxQG97Q4+m1jz380+d+yc0u9TVxg=;
        b=t1/fd75SzQIJ74LOtE44HZraCEPkj2zY6hVRJB/OR6QmpASXyqOk5cCbwtj9v3rrKm
         b2OMELg2eTmglaC4D0uZW64LTEidw2aVoEpN+X3c7iPs87pClhW9uTg8esji2839REZu
         vxvYdNRGiwljDKEI09x56FBl5hP2yOlz0afE0DS+TfAN4bADWDtxXSvkHMgdx4xV1tL/
         ULYkWl2AAF28lApXHle3fjP5vKzT1kNaRqL6wZj4Q2RWcqtCbEscT2D2fm3jHCP+RRqo
         R7zpjlyaTt5VR+6laYnssElSue1mfV50MglDYQobC/wnjunMKfDuN6JB6pB07vyMn8Ys
         GDkg==
X-Gm-Message-State: AOAM532AlNX83nKGGO1GyH5LlaW/7WVIqooNOuNXuLSrU0z5kFwoOFFr
        DBse4AWtY1J0Toqb+/FLFCU=
X-Google-Smtp-Source: ABdhPJzHEV2kbV4kXARg61vHB7fsdj5EAGUr1AAUxDytZhh3Gt7ZGIzmCaebkj/vyqp9hICma8F12w==
X-Received: by 2002:a05:6402:cb1:: with SMTP id cn17mr16746730edb.42.1623673147245;
        Mon, 14 Jun 2021 05:19:07 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id c18sm8722495edt.97.2021.06.14.05.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 05:19:06 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 0/3] Fixes and improvements to TJA1103 PHY driver
Date:   Mon, 14 Jun 2021 15:18:46 +0300
Message-Id: <20210614121849.437119-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series contains:
- an erratum workaround for the TJA1103 PHY integrated in SJA1110
- an adaptation of the driver so it prints less unnecessary information
  when probing on SJA1110
- a PTP RX timestamping bug fix

Targeting net-next since the PHY support is currently in net-next only.

Vladimir Oltean (3):
  net: phy: nxp-c45-tja11xx: demote the "no PTP support" message to
    debug
  net: phy: nxp-c45-tja11xx: fix potential RX timestamp wraparound
  net: phy: nxp-c45-tja11xx: enable MDIO write access to the
    master/slave registers

 drivers/net/phy/nxp-c45-tja11xx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
2.25.1

