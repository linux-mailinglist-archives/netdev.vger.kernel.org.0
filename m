Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8F25E5E5E
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 20:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfJZSEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 14:04:52 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34407 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbfJZSEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 14:04:52 -0400
Received: by mail-wm1-f68.google.com with SMTP id v3so6531987wmh.1
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 11:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=X1tqTz4T6qa5zz8ILNV6jlx3MabLmY/ObkqjjyG43SE=;
        b=toE/qxu54HxyWyUP68tKfa3r34YI2r3PJLx06zspV6usxc8oVHC60m5zEIjmmpXUNr
         HsoL9ZPY1IR/M6vgvTiqNA8/sDprt3+Pbe+C2fEpzP3I4qcOAzhYER0ppdn53PRcOWRq
         tYo6B8Enta0Yql8pintIjN+914wJKcZCvjiwSrCsaKXIyzpkyjfguwCnxpCVwjmAOaTj
         4aeyNfW5C50DhPLlkB2LYadaYzvLzZ4U2eKMzkqDVbJJwTJajaF9ZLSfGv4K/9Zqqzx0
         SCFLuvyvYcyQz8QnTtZr0gxtZFeWDqOIgjw48P8aPey5gQ0JT7dA5l5meTVXDinL1rj+
         2/Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=X1tqTz4T6qa5zz8ILNV6jlx3MabLmY/ObkqjjyG43SE=;
        b=WmxA1cj4eZTzRf5HzN8/2dMJHV1omzpOZ65cFhMW/7wdJE8RcLA2ZGyyimXfAArXf4
         Li3r2OJt1bUNyuPfUUM+iMBaTidmLpmHiUUX3rTuBf5NkOGLKUD3o1BlxGGTlbMiiYnP
         narhvA4ilpRAgYSH9Uy3xFgdJna1ImS+6iEhbJykOPe2y6w19FRsI3VDTrLX73VqrspG
         p64zLwKbsRqV7p7Xx+DpLa3G/FmIzxhnv+Y8kKAGntm1pX3Jow9K3VA5zf5LQg/NW4mt
         JWAfklv0YCuYZ4cMDiw0EokkU2stsN6RmbSVp7QAnusz1pPF1NM2zgFR3f/TU4v1laXh
         8c3g==
X-Gm-Message-State: APjAAAVxY12ORkDj4TFk8T7Ocn1X88miK6Vn0jeRDGyuOpSdBYQB01mf
        d2hEtUFZpOqj2Y9eWv6uXIDMmjNi
X-Google-Smtp-Source: APXvYqxq3Ael4fkidt+3ZPh872MvGvzo09JthwRkOeytzb+LAnIxram9MfZepDt5Ixy/2Z3kOCvSUA==
X-Received: by 2002:a1c:106:: with SMTP id 6mr7895826wmb.134.1572113088866;
        Sat, 26 Oct 2019 11:04:48 -0700 (PDT)
Received: from localhost.localdomain ([188.25.218.57])
        by smtp.gmail.com with ESMTPSA id 1sm5568036wrr.16.2019.10.26.11.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2019 11:04:48 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 0/2] VLAN fixes for Ocelot switch
Date:   Sat, 26 Oct 2019 21:04:25 +0300
Message-Id: <20191026180427.14039-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series addresses 2 issues with vlan_filtering=1:
- Untagged traffic gets dropped unless commands are run in a very
  specific order.
- Untagged traffic starts being transmitted as tagged after adding
  another untagged VID on the port.

Tested on NXP LS1028A-RDB board.

Vladimir Oltean (2):
  net: mscc: ocelot: fix vlan_filtering when enslaving to bridge before
    link is up
  net: mscc: ocelot: refuse to overwrite the port's native vlan

 drivers/net/ethernet/mscc/ocelot.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

-- 
2.17.1

