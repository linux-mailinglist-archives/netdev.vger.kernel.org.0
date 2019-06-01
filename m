Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0D5C31B44
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 12:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfFAKhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 06:37:43 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:42224 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfFAKhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 06:37:43 -0400
Received: by mail-wr1-f43.google.com with SMTP id o12so969261wrj.9
        for <netdev@vger.kernel.org>; Sat, 01 Jun 2019 03:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2P6ObSJR05OuRzMKv+ncXdQU+uAKOgXXOo0yLuXdv7Q=;
        b=N89rWYZLRyKAQfYSx8SOwp14YLizNfI+SP5MJHBMWynxyuSqxp9ZfYTixnsbi3TlMX
         8Ra4Sx3RAYX7T4YpgRFyKjiOcHNxnFnkBlmyN1kIDSzBF9uohNW5uakm5O9teMrHdFPw
         AttsmazfS9hN0CNRYbOOvGXEPTpVg/MrHJSJXWkc4eAw0FA2VImdYxyInC1QKhy1c1NY
         y07vDfG75SvqphJMOTJVHHvvHf7Kxq4DAvxfLfYHiCe3HOB4g71j6hLgP5oFkPTdyOt+
         tk5onJsh2upRuvBMWqV1FH772OkdbGwFnCStZPSvajjBsMgtPKm35r8qI3/Z0OKyjLiD
         ecoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2P6ObSJR05OuRzMKv+ncXdQU+uAKOgXXOo0yLuXdv7Q=;
        b=YPQvkjiUzCTMlt/zL88cV5zuPOfZaq1FpnbEF43gbg2/Np9EvUYUyI1JfFbLbfQltB
         szOvhhxTZr1X/H2mGChTtO2KkQGFmdnyWjchg43KqxpNamkbybWcPr5J1wI+L7CKaHEq
         EuncdoTgl1O+yP0W378r3JW5454n4cvKPPJ5PTT/yJYLAto+BusrPhsdjioOO4PDCzZe
         fbvDZJFuCXWS3ZayJUSa1JV0HnI4fin6df5T9C7Pi80zPEK9/syzp8+cZS3VvROL8N2m
         4wlrFn2DhWkZZbbKOanwH/SFdxLEKqqsf4PljxA6XSbD0T8aqUrYXOwSUHTYfBqDCXlG
         UpIA==
X-Gm-Message-State: APjAAAUulsSlEM6mD/djgL+GAocyIXzv1RA2hQUyauSnzzoT4zGYTmLC
        KNO+I1Z/ij0VrA0Y1qo5niZfBpwY13M=
X-Google-Smtp-Source: APXvYqzlmnD75KMuIESsGgzAloMJJLXnZyzzW2f9p7ajRzDpzsM44b23kP6dy3CInaVXgtD2+0tTTw==
X-Received: by 2002:adf:b643:: with SMTP id i3mr10222898wre.284.1559385461607;
        Sat, 01 Jun 2019 03:37:41 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id h90sm26273063wrh.15.2019.06.01.03.37.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Jun 2019 03:37:41 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 0/2] Fix link speed handling for SJA1105 DSA driver
Date:   Sat,  1 Jun 2019 13:37:33 +0300
Message-Id: <20190601103735.27506-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes two bugs in the logic handling of the enum
sja1105_speed_t which caused link speeds of 10 and 100 Mbps to not be
interpreted correctly and thus not be applied to the switch MACs.

Vladimir Oltean (2):
  net: dsa: sja1105: Force a negative value for enum sja1105_speed_t
  net: dsa: sja1105: Fix link speed not working at 100 Mbps and below

 drivers/net/dsa/sja1105/sja1105.h      | 1 +
 drivers/net/dsa/sja1105/sja1105_main.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.17.1

