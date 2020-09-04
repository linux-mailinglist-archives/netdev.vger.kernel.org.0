Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA2525E35B
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 23:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgIDVhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 17:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbgIDVhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 17:37:35 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E0AC061244;
        Fri,  4 Sep 2020 14:37:34 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id u3so393699pjr.3;
        Fri, 04 Sep 2020 14:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7SJkf0fEsg+CIwOBocv+Ie7I+/HiaubEmwfVmeKBTyU=;
        b=f4zYjhQl5VcS2ltHtJnUQTqcdvSciVZB6DwQ/Qo3JL6kGoDdAum1r6jRT56W3qlis8
         tZzqBDc2m17j0DlBWbLhrW6oPODg3RhIUzxaU6TfOUjbDFvRfZHB0JHAmTHfUN1UU0Nb
         v1x4AKjzfgDzRC74DXiU7DBftcs8VmrFf5MF4/eKon/ZmJV5aJ5vDYJiL6uA7yDsRBFk
         +6O3inGyDYwNjcfg8YNm4eKjdO1vjtjsXADQV/yCoslMj8HkukBFBA/0XCgAOUmBVUJd
         GEULkVhugh8TO8Gm212nVPbrm/32wpxxETBExV43lF43J0WtTGpiVkbwl6EiilzzdEkw
         Amww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7SJkf0fEsg+CIwOBocv+Ie7I+/HiaubEmwfVmeKBTyU=;
        b=QbAcfkaMugq2s6lSMri7khUQoTw4/SUvHbginvIIJomvrlgNTztAYYLGS9FqimlEKW
         F8N3gVb1rk2nqmu95F68IuR+Yj6+9tpRtEL0O5LONFs86jdjA2VOAUzuQ+jDprD2R6so
         8OjojKDtI4uJnTA9TFzWGf4d4ZF4z2u/H3T6OOFPS4D/3Myrrmb+RGTanKsNiMcmpg1f
         Fcss87rQpWvBTDEEV2Ho81RKfu4mX/AWo3E3WPR6gUswsPMwzS0vA+Hy3XxPuJ71TMD0
         ZjWH9GTVPwAuP16UoXl+sq2tcQYqmidCevrXocoKp1LUPKtRTkOM2qQq3h8ii2vQKrjc
         oz6A==
X-Gm-Message-State: AOAM532y/Mf3qKs1ivER7GjP+zwo+qWG/gMM0orMVHurIVaCduk8tDxh
        LY+YavU1BC2JGtJcMmW0Qb0g3venKqM=
X-Google-Smtp-Source: ABdhPJxmanxSUUqNOpAeyYhRcCczHo6b85vNqzmXsXTyWJYE0ry3wXZR9IF9K9xgjhlH6QqA4JScDg==
X-Received: by 2002:a17:90a:d812:: with SMTP id a18mr10003156pjv.228.1599255453572;
        Fri, 04 Sep 2020 14:37:33 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d17sm1255093pgn.56.2020.09.04.14.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 14:37:32 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE)
Subject: [PATCH net-next v2 0/2] net: dsa: bcm_sf2: Ensure MDIO diversion is used
Date:   Fri,  4 Sep 2020 14:37:28 -0700
Message-Id: <20200904213730.3467899-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v2:

- export of_update_property() to permit building bcm_sf2 as a module
- provided a better explanation of the problem being solved after
  explaining it to Andrew during the v1 review

Florian Fainelli (2):
  of: Export of_remove_property() to modules
  net: dsa: bcm_sf2: Ensure that MDIO diversion is used

 drivers/net/dsa/bcm_sf2.c | 31 +++++++++++++++++++++++++++++--
 drivers/of/base.c         |  1 +
 include/linux/of.h        |  5 +++++
 3 files changed, 35 insertions(+), 2 deletions(-)

-- 
2.25.1

