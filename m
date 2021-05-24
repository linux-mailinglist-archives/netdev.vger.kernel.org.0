Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE55838E33A
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 11:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbhEXJ1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 05:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhEXJ1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 05:27:04 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A8BC061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 02:25:35 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id n2so40707030ejy.7
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 02:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nyb7N4InOES9OR6R/ne4MxduYt4v2uvRA+xM2/1XvHU=;
        b=udzVpI8MNMT29sj8L3mjOOD6qrBXOimjESZ2AlQAOKkEUZonn/v5FX/AVM/OPgsdaa
         iz5tkhnqXt0WpUHP0ERiMxkAeLOduYsNxjv0pzLvSBNTq5SliUwOsJv+itDEGjEd8cNs
         Z0+WG6s+8QfgCa28z0QzOyj94lv1nJzSB3B7bjc660HBlozjmj0kzPP+NAkUSK08REbX
         3LgzLEcLTswwhxQMxthAhrQXSi5jqezDP8ufMlAKHT+PJuyMM00csp177qlovOSKGaHO
         uhDCgacjCzLKKiBUBNkxlywWQuE+rSn1H+F6v1e8PH+2xYo+O1K4fFjsdyjDQ0TMoYJ+
         5hsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nyb7N4InOES9OR6R/ne4MxduYt4v2uvRA+xM2/1XvHU=;
        b=eZ65zuebsBRe8PGm8YByiHAvt57RSLYp2cqqCscsCs/K6lpk27o0VfFiuSlMgRwRt6
         Jf97jex8cL48wn2TxUUoTV85OF5iPObP/kogDUzN1Gu2e+KamvEGsgUd+5EZyQw0uWa3
         qG68zvGJuEMVuF/FCteuycQ5wC5wGr6bSeWpAvRKHzVDOooGc7g42y6eQbJqBaLE4Azw
         Ne+DLel9NI9YPiMmlEAVT9rRDchqyfW+SBmdNWpq8t6Jv9ZoWnCT7bm+YoLItLFirSol
         jjSc5XuVYvTBofKvksx3Pyyv5xwTTu8nwvIW5BrOMz9Z07OD0BmKBq9tk1ZzxUL1xill
         Y2Jg==
X-Gm-Message-State: AOAM532A3USvEpyMDpWkg6rxRqZy3cfqtnlOrZp1yXSZF+38ES3Ni3UB
        5OseVCHfJhksLHjx5gkPYpQ=
X-Google-Smtp-Source: ABdhPJy+3ii05/Ql8eMlfuRLdhg7BvG+jUbM2cufuQvUKkxBktWr4Z6EhJb7BJ4MzLd1yraNsjE9VA==
X-Received: by 2002:a17:906:2749:: with SMTP id a9mr2116361ejd.498.1621848334135;
        Mon, 24 May 2021 02:25:34 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id yw9sm7553007ejb.91.2021.05.24.02.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 02:25:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net 0/6] Fixes for SJA1105 DSA driver
Date:   Mon, 24 May 2021 12:25:21 +0300
Message-Id: <20210524092527.874479-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series contains some minor fixes in the sja1105 driver:
- improved error handling in the probe path
- rejecting an invalid phy-mode specified in the device tree
- register access fix for SJA1105P/Q/R/S for the virtual links through
  the dynamic reconfiguration interface
- handling 2 bridge VLANs where the second is supposed to overwrite the
  first
- making sure that the lack of a pvid results in the actual dropping of
  untagged traffic

Vladimir Oltean (6):
  net: dsa: sja1105: fix VL lookup command packing for P/Q/R/S
  net: dsa: sja1105: call dsa_unregister_switch when allocating memory
    fails
  net: dsa: sja1105: add error handling in sja1105_setup()
  net: dsa: sja1105: error out on unsupported PHY mode
  net: dsa: sja1105: use 4095 as the private VLAN for untagged traffic
  net: dsa: sja1105: update existing VLANs from the bridge VLAN list

 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 23 +++++-
 drivers/net/dsa/sja1105/sja1105_main.c        | 74 +++++++++++++------
 2 files changed, 70 insertions(+), 27 deletions(-)

-- 
2.25.1

